var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.DataManager = Mining.DataManager || {};
Mining.DataManager.Accessors = Mining.DataManager.Accessors || {};

/*
  This class accesses data related to localizations.
*/

Mining.DataManager.Accessors.LocalizationDataAccessor = function() {
  var self = this;

  this.filterStore = undefined;
  this.dataStore = undefined;

  // ----------------------------------------------
  // clip details mapping
  this.getClipDetailsMap = function(){
    return self.dataStore.clipDetailsMap;
  };

  this.createClipDetailsMap = function(){
    var miningData = self.dataStore.miningData;

    // ASSUME: clipSet is already sorted by rails
    self.dataStore.clipDetailsMap.sortedClipIds = _.pluck(miningData.clipSet, 'clip_id');
    self.dataStore.clipDetailsMap.clipMap = {};

    var sortedClipIds = self.dataStore.clipDetailsMap.sortedClipIds;
    var clipMap = self.dataStore.clipDetailsMap.clipMap;

    _.each(sortedClipIds, function(clipId){
      clipMap[clipId] = {};
      var clip = _.findWhere(miningData.clips, {clip_id: clipId});
      clipMap[clipId] = _.extend(clipMap[clipId], clip);
    });
  };

  // ----------------------------------------------
  // chia version mapping
  this.createChiaModelVersionMap = function(){
    var chiaModels = self.dataStore.miningData.chiaModels;
    var chiaMap = {};
    chiaMap[chiaModels.localization.id] = chiaModels.localization;
    chiaMap[chiaModels.annotation.id] = chiaModels.annotation;
    self.dataStore.chiaModelVersionMap = chiaMap;
  };

  this.getChiaDetails = function(chiaModelId){
    return self.dataStore.chiaModelVersionMap[chiaModelId];
  };

  // ----------------------------------------------
  // detectable mapping
  this.getLocalizationDetails = function(detId){
    return {
      id: detId,
      title: self.dataStore.detectables.decorations[detId].pretty_name,
      color: self.dataStore.detectables.decorations[detId].annotation_color
    };
  };

  // ----------------------------------------------
  // for non-evaluated frames, we need to translate frame numbers
  this.getTranslatedClipIdClipFN = function(clipId, clipFN){
    var clip = self.dataStore.clipDetailsMap.clipMap[clipId];
    var detectionRate = clip.detection_frame_rate;

    var efn = self.dataStore.firstEvaluatedVideoFn;
    clipFN = (clipFN - efn) - ((clipFN - efn) % detectionRate) + efn;
    return { clip_id: clipId, clip_fn: clipFN };
  };

  this.isEvaluatedFrame = function(clipId, clipFN){
    var clip = self.dataStore.clipDetailsMap.clipMap[clipId];
    var detectionRate = clip.detection_frame_rate;
    var efn = self.dataStore.firstEvaluatedVideoFn;
    return (((clipFN - efn) % detectionRate) === 0);
  };

  // ----------------------------------------------
  // localization raw data
  this.getMaxScore = function(clipId, clipFN, detId){
    var spatIntThresh = self.dataStore.miningData.smartFilter.spatial_intersection_thresh;
    var loc = self.dataStore.dataFullLocalizations;
    var score = 0, spInterScore = 0;
    if(loc[clipId] && loc[clipId][clipFN] && loc[clipId][clipFN][detId]) {
      // if even one localization is present, it gets a height
      score = 0.6;
      var bboxes = loc[clipId][clipFN][detId];
      spInterScore = _.max(bboxes,
        function(dd){ return dd.spatial_intersection; }).spatial_intersection;
      if (spInterScore >= spatIntThresh){ score = 1.0; }
    }
    return score;
  };

  this.setCurrentLocalization = function(clipId, clipFN){
    var cfn = self.getTranslatedClipIdClipFN(clipId, clipFN);
    clipId = cfn.clip_id;
    clipFN = cfn.clip_fn;

    var curLocs = {};
    var loc = self.dataStore.dataFullLocalizations;
    if(loc[clipId] !== undefined && loc[clipId][clipFN] !== undefined){
      curLocs = loc[clipId][clipFN];
    }
    self.filterStore.currentLocalizations = curLocs;
  };

  //------------------------------------------------
  // for video status
  this.getVideoState = function(currentPlayState){
    // Note: The return keys here have to match in following files:
    // analysis/mining/chart_manager/chart_filters/filter_status_video.js
    // analysis/mining/frame_display/draw_info_overlay.js

    var clipId = currentPlayState.clip_id;
    var clipFN = currentPlayState.clip_fn;

    var clip = self.dataStore.clipDetailsMap.clipMap[clipId];

    // prettyfiy times:
    var clipFrameTime = self.dataStore.textFormatters.getReadableTime(
      1000.0 * clipFN / clip.playback_frame_rate);

    self.dataStore.videoState.previous = _.clone(self.dataStore.videoState.current);

    // return in format usable by display JS
    self.dataStore.videoState.current = {
      clip_id: clipId,
      clip_fn: clipFN,
      clip_time: clipFrameTime,
      is_evaluated_frame: self.isEvaluatedFrame(clipId, clipFN)
    };
    return self.dataStore.videoState;
  };

  //------------------------------------------------
  // set relations
  this.setFilterStore = function(fs){
    self.filterStore = fs;
    return self;
  };

  this.setDataStore = function(ds){
    self.dataStore = ds;
    return self;
  };
};
