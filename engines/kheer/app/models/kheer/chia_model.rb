module Kheer
  class ChiaModel < ActiveRecord::Base
    serialize :detectable_ids, Array
    before_destroy :delete_iteration, prepend: true

    # Validations
    validates :name, presence: true
    validates :major_id, presence: true # When adding new type (e.g. Logo, Branded Item) of model
    validates :minor_id, presence: true # When adding a new class to model
    validates :mini_id, presence: true # When iterating on existing minor model

    def iteration
      Iteration.where(chia_model_id: self.id).first
    end

    def self.hierarchy
      # format
      # {:major => {:minor => [:mini, ], }, }
      sels = ActiveSupport::OrderedHash.new
      ChiaModel.where(minor_id: 0).each do |cmMajor|
        sels[cmMajor] = ActiveSupport::OrderedHash.new
        cmMajor.decorate.minors.each do |cmMinor|
          sels[cmMajor][cmMinor] = cmMinor.decorate.minis
        end
      end
      sels
    end

    def self.fromVersion(version)
      cm = nil
      ver = version.split(".").map{ |v| v.to_i }
      if ver.count == 1
        cm = ChiaModel.where(major_id: ver[0]).first
      elsif ver.count == 2
        cm = ChiaModel.where(major_id: ver[0], minor_id: ver[1]).first
      elsif ver.count == 3
        cm = ChiaModel.where(major_id: ver[0], minor_id: ver[1], mini_id: ver[2]).first
      end
      raise "Couldn't find chia model for version #{version}" if cm == nil
      cm
    end

    def intThreshs
      (0..10).map{ |i| (i * 0.1).round(1) }
    end
    def probThreshs
      (0..10).map{ |i| (i * 0.1).round(1) }
    end
    def scales
      [1.0]
    end

    private
      def delete_iteration
        iteration.destroy
      end

  end
end
