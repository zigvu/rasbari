var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.DataManager = Mining.DataManager || {};
Mining.DataManager.Accessors = Mining.DataManager.Accessors || {};

/*
  This class accesses data related to filters.
*/

Mining.DataManager.Accessors.FilterAccessor = function() {
  var self = this;

  this.filterStore = undefined;
  this.dataStore = undefined;

  this.cycleScales = function(){
    var scales = self.dataStore.miningData.chiaModels.localization.settings.scales;
    var curScale = self.filterStore.heatmap.scale;
    if(curScale === undefined){
      self.filterStore.heatmap.scale = scales[0];
    } else {
      self.filterStore.heatmap.scale = scales[(_.indexOf(scales, curScale) + 1) % scales.length];
    }
    return self.filterStore.heatmap.scale;
  };
  this.cycleZdists = function(){
    var zdists = self.dataStore.miningData.chiaModels.localization.settings.zdist_threshs;
    var curZdist = self.filterStore.heatmap.zdist_thresh;
    if(curZdist === undefined){
      self.filterStore.heatmap.zdist_thresh = zdists[0];
    } else {
      self.filterStore.heatmap.zdist_thresh = zdists[(_.indexOf(zdists, curZdist) + 1) % zdists.length];
    }
    return self.filterStore.heatmap.zdist_thresh;
  };
  this.cycleProbScores = function(){
    var probScores = self.dataStore.miningData.chiaModels.localization.settings.prob_scores;
    var curProbScore = self.filterStore.heatmap.prob_score;
    if(curProbScore === undefined){
      self.filterStore.heatmap.prob_score = probScores[0];
    } else {
      self.filterStore.heatmap.prob_score = probScores[
        (_.indexOf(probScores, curProbScore) + 1) % probScores.length
      ];
    }
    return self.filterStore.heatmap.prob_score;
  };

  this.getFrameFilterState = function(){
    // Note: The return keys here have to match in following files:
    // annotations/chart_manager/chart_filters/filter_status_frame.js
    return {
      heatmap: self.filterStore.heatmap
    };
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
