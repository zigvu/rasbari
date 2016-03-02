var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.ChartManager = Mining.ChartManager || {};
Mining.ChartManager.ChartFilters = Mining.ChartManager.ChartFilters || {};

/*
  Filter to display current video position
*/

Mining.ChartManager.ChartFilters.FilterStatusVideo = function(htmlGenerator) {
  var self = this;
  this.dataManager = undefined;
  this.eventManager = undefined;

  var divId_filterContainer = "#filter-status-clip-container";

  var divId_filterStatusClipId = "#filter-status-clip-id";
  var divId_filterStatusClipFrameNumber = "#filter-status-clip-fn";
  var divId_filterStatusClipFrameTime = "#filter-status-clip-time";


  function updateStatusFromVideoPlayer(args){
    var vs = self.dataManager.getData_videoState(args).current;

    $(divId_filterStatusClipId).text(vs.clip_id);
    $(divId_filterStatusClipFrameNumber).text(vs.clip_fn);
    $(divId_filterStatusClipFrameTime).text(vs.clip_time);
  }

  this.empty = function(){ };

  this.show = function(){ $(divId_filterContainer).show(); };
  this.hide = function(){ $(divId_filterContainer).hide(); };

  //------------------------------------------------
  // set relations
  this.setEventManager = function(em){
    self.eventManager = em;
    self.eventManager.addPaintFrameCallback(updateStatusFromVideoPlayer);
    return self;
  };

  this.setDataManager = function(dm){
    self.dataManager = dm;
    return self;
  };
};
