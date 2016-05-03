require 'fileutils'
require 'json'
require 'ostruct'

module Kheer
  class ClipDataImporter
    # BEGIN: dumper sub class definitions
    class LocalizationDumper < Kheer::GenericDumper
      def initialize
        super('Kheer::Localization')
      end
      def canFlush?
        @items.count >= @mongoBatchInsertSize
      end
    end
    class IntersectionDumper < Kheer::GenericDumper
      attr_accessor :tracker
      def initialize
        super('Kheer::Intersection')
        # format:
        # {interItemIdx: [loc1ItemIdx, loc2ItemIdx]}
        @tracker = {}
      end
      def canFlush?
        truthy = @items.map{ |itm| itm[:localization_ids].count == 2 }
        @items.empty? || truthy.reduce{ |mm, cnt| mm and cnt }
      end
      def updateTracker(insertResult)
        if insertResult != nil
          locItemIdxs = insertResult.inserted_ids
          @tracker.each do |interItemIdx, locs|
            loc1ItemId = locItemIdxs[locs[0]]
            loc2ItemId = locItemIdxs[locs[1]]
            @items[interItemIdx][:localization_ids] = [loc1ItemId, loc2ItemId]
          end
        end
        @tracker = {}
      end
    end
    # END: dumper sub class definitions

    # debug helper
    attr_accessor :clipData, :chiaToDet, :locDumper, :interDumper

    def initialize(clipFile)
      readClipJson(clipFile)
      @chiaToDet = ChiaModel.find(@chiaModelId).iteration.decorate.chiaToDetMapNonAvoid
      # dumpers
      @locDumper = LocalizationDumper.new
      @interDumper = IntersectionDumper.new
    end

    def writeData
      # update fns
      clip = Video::Clip.find(@clipId)
      clip.update(frame_number_start: @fns.first, frame_number_end: @fns.last)
      # update locs and inters
      @fns.each do |fn|
        addFrameData(fn)
      end
      insertResult = @locDumper.finalize
      @interDumper.updateTracker(insertResult)
      raise RuntimeError("Did not get all ids for localization") if not @interDumper.canFlush?
      @interDumper.finalize
    end

    def readClipJson(clipFile)
      @clipData = JSON.load(File.open(clipFile))
      @clipId = @clipData["meta"]["clip_id"].to_i
      @capEval = CaptureEvaluation.find(@clipData["meta"]["cap_eval_id"])
      @scale = @clipData["meta"]["scale"].to_f
      @chiaModelId = @capEval.chia_model_id
      @fns = @clipData["data"].keys.map{ |fn| fn.to_i }.sort
    end

    def addFrameData(fn)
      # format: {cls1Idx: {bbox1Idx: locItemIdx}}
      fnTrack = {}
      nmsBoxes = clipData["data"][fn.to_s]["nms_boxes"]
      inters = clipData["data"][fn.to_s]["inters"]
      thresh = clipData["data"][fn.to_s]["thresh"]
      @chiaToDet.each do |cls1Idx, detId|
        nmsBoxes[cls1Idx].each do |bbox1Idx, bbox|
          fnTrack[cls1Idx] ||= {}
          fnTrack[cls1Idx][bbox1Idx] = @locDumper.add(bboxToLoc(fn, detId, bbox))
        end
      end
      # bbox2Idx of cls2Idx confuses with bbox1Idx of cls1Idx
      inters.each do |cls1Idx, confs|
        confs.each do |cls2Idx, cls2Confs|
          cls2Confs.each do |bbox1Idx, bbox2Idxs|
            bbox2Idxs.each_with_index do |bbox2Idx, idx|
              th = thresh[cls1Idx][cls2Idx][bbox1Idx][idx]
              loc1ItemIdx = fnTrack[cls1Idx][bbox1Idx]
              loc2ItemIdx = fnTrack[cls2Idx][bbox2Idx.to_s]
              interItem = locsToInter(th, @locDumper.items[loc1ItemIdx], @locDumper.items[loc2ItemIdx])
              interItemIdx = @interDumper.add(interItem)
              @interDumper.tracker[interItemIdx] = [loc1ItemIdx, loc2ItemIdx]
            end
          end
        end
      end
      if @locDumper.canFlush?
        insertResult = @locDumper.flush
        @interDumper.updateTracker(insertResult)
        raise RuntimeError("Did not get all ids for localization") if not @interDumper.canFlush?
        @interDumper.flush
      end
    end

    def bboxToLoc(fn, detId, bbox)
      # format must match that in Kheer::Localization
      return {
        ci: @chiaModelId, cl: @clipId, fn: fn, isa: false, di: detId, ps: bbox[4].to_f,
        zd: bbox[5].to_f, sl: @scale, x: bbox[0].to_i, y: bbox[1].to_i,
        w: bbox[2].to_i - bbox[0].to_i, h: bbox[3].to_i - bbox[1].to_i
      }
    end

    def locsToInter(threshold, loc1, loc2)
      loc1 = OpenStruct.new(loc1)
      loc2 = OpenStruct.new(loc2)
      # format must match that in Kheer::Intersection
      return {
        ci: loc1.ci, cl: loc1.cl, fn: loc1.fn, th: threshold,
        pdi: loc1.di, pps: loc1.ps, pzd: loc1.zd, psl: loc1.sl,
        sdi: loc2.di, sps: loc2.ps, szd: loc2.zd, ssl: loc2.sl,
        localization_ids: [] # need to update this once we get mongo ids
      }
    end

  end
end
