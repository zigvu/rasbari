var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.DataManager = Mining.DataManager || {};

/*
  This class manages data.
*/

Mining.DataManager.DataManager = function() {
  var self = this;

  this.eventManager = undefined;

  // ----------------------------------------------
  // stores
  this.filterStore = new Mining.DataManager.Stores.FilterStore();
  this.dataStore = new Mining.DataManager.Stores.DataStore();

  this.ajaxHandler = new Mining.DataManager.AjaxHandler();
  self.ajaxHandler
    .setFilterStore(self.filterStore)
    .setDataStore(self.dataStore);

  // ----------------------------------------------
  // accessors
  this.filterAccessor = new Mining.DataManager.Accessors.FilterAccessor();
  self.filterAccessor
    .setFilterStore(self.filterStore)
    .setDataStore(self.dataStore);

  this.annotationDataAccessor = new Mining.DataManager.Accessors.AnnotationDataAccessor();
  self.annotationDataAccessor
    .setFilterStore(self.filterStore)
    .setDataStore(self.dataStore);

  this.localizationDataAccessor = new Mining.DataManager.Accessors.LocalizationDataAccessor();
  self.localizationDataAccessor
    .setFilterStore(self.filterStore)
    .setDataStore(self.dataStore);

  this.timelineChartDataAccessor = new Mining.DataManager.Accessors.TimelineChartDataAccessor();
  self.timelineChartDataAccessor
    .setFilterStore(self.filterStore)
    .setDataStore(self.dataStore);

  // ----------------------------------------------
  // Mining data
  this.getMiningDataPromise = function(miningId, setId){
    return self.ajaxHandler.getMiningDataPromise(miningId, setId);
  };

  this.massageMiningData = function(){
    self.annotationDataAccessor.createDetectableDecorations();
    self.localizationDataAccessor.createClipDetailsMap();

    // set frame filter states
    self.getFilter_cycleScales();
    self.getFilter_cycleZdists();
  };

  // ----------------------------------------------
  // Annotation data

  this.getAnno_chiaModelId = function(){
    return self.annotationDataAccessor.getChiaModelId();
  };

  this.getAnno_annotationDetectables = function(){
    return self.annotationDataAccessor.getDetectables();
  };

  this.getAnno_annotations = function(clipId, clipFN){
    return self.annotationDataAccessor.getAnnotations(clipId, clipFN);
  };

  this.setAnno_saveAnnotations = function(clipId, clipFN, annotationObjs){
    annotationObjs = self.annotationDataAccessor.updateAnnotations(clipId, clipFN, annotationObjs);
    // save changes to database
    self.ajaxHandler.getAnnotationSavePromise(annotationObjs)
      .then(function(status){ console.log(status); })
      .catch(function (errorReason) { self.err(errorReason); });
    // emit event to update annotation timeline chart
    self.eventManager.fireUpdateAnnoChartCallback({});
  };

  this.getAnno_selectedAnnotationDetails = function(){
    return self.annotationDataAccessor.getSelectedAnnotationDetails();
  };

  this.getAnno_anotationDetails = function(detId){
    return self.annotationDataAccessor.getAnnotationDetails(detId);
  };

  // ----------------------------------------------
  // Heatmap data

  this.heatmap_getHeatmapDataPromise = function(clipId, clipFN){
    var cfn = self.localizationDataAccessor.getTranslatedClipIdClipFN(clipId, clipFN);
    clipId = cfn.clip_id;
    clipFN = cfn.clip_fn;

    return self.ajaxHandler.getHeatmapDataPromise(clipId, clipFN);
  };

  // ----------------------------------------------
  // Localization data

  this.getData_localizationsData = function(clipId, clipFN){
    return self.localizationDataAccessor.getLocalizations(clipId, clipFN);
  };

  this.getData_allLocalizationsDataPromise = function(clipId, clipFN){
    var cfn = self.localizationDataAccessor.getTranslatedClipIdClipFN(clipId, clipFN);
    clipId = cfn.clip_id;
    clipFN = cfn.clip_fn;

    return self.ajaxHandler.getAllLocalizationsPromise(clipId, clipFN);
  };

  this.getData_clipDetailsMap = function(){
    return self.localizationDataAccessor.getClipDetailsMap();
  };

  this.getData_cellMap = function(){
    return self.localizationDataAccessor.getCellMap();
  };
  this.getData_colorMap = function(){
    return self.localizationDataAccessor.getColorMap();
  };

  this.getData_localizationDetails = function(detId){
    return self.localizationDataAccessor.getLocalizationDetails(detId);
  };

  // we get currentPlayState from
  // mining/video_handler/multi_video_extractor.js
  this.getData_videoState = function(currentPlayState){
    return self.localizationDataAccessor.getVideoState(currentPlayState);
  };

  // ----------------------------------------------
  // Filter data

  this.getFilter_cycleScales = function(){
    self.filterAccessor.cycleScales();
    self.eventManager.fireStatusFrameCallback({});
  };
  this.getFilter_cycleZdists = function(){
    self.filterAccessor.cycleZdists();
    self.eventManager.fireStatusFrameCallback({});
  };

  this.getFilter_getFrameFilterState = function(){
    return self.filterAccessor.getFrameFilterState();
  };

  // ----------------------------------------------
  // Timeline chart
  this.tChart_getNumOfSelectedDetIds = function(){
    return self.timelineChartDataAccessor.getNumOfSelectedDetIds();
  };

  this.tChart_createData = function(){
    return self.timelineChartDataAccessor.createChartDataLoc(
      self.localizationDataAccessor
    );
  };


  this.tChart_getNewPlayPosition = function(clipId, clipFN, numOfFrames){
    return self.timelineChartDataAccessor.getNewPlayPosition(clipId, clipFN, numOfFrames);
  };

  this.tChart_getHitLocPlayPosition = function(clipId, clipFN, forwardDirection){
    return self.timelineChartDataAccessor.getHitLocPlayPosition(clipId, clipFN, forwardDirection);
  };

  this.tChart_getHitAnnoPlayPosition = function(clipId, clipFN, forwardDirection){
    return self.timelineChartDataAccessor.getHitAnnoPlayPosition(clipId, clipFN, forwardDirection);
  };

  this.tChart_getCounter = function(clipId, clipFN){
    return self.timelineChartDataAccessor.getCounter(clipId, clipFN);
  };

  this.tChart_isValidClipIdClipFn = function(clipId, clipFN){
    return self.timelineChartDataAccessor.isValidClipIdClipFn(clipId, clipFN);
  };

  this.tChart_getClipIdClipFN = function(counter){
    return self.timelineChartDataAccessor.getClipIdClipFN(counter);
  };

  this.tChart_getTimelineChartDataLoc = function(){
    return self.timelineChartDataAccessor.getTimelineChartDataLoc();
  };

  this.tChart_getTimelineChartDataAnno = function(){
    self.timelineChartDataAccessor.createChartDataAnno(
      self.annotationDataAccessor
    );
    return self.timelineChartDataAccessor.getTimelineChartDataAnno();
  };

  // ----------------------------------------------
  // event handling
  function updateAnnoListSelected(detectableId){
    self.filterStore.currentAnnotationDetId = detectableId;
    self.filterStore.heatmap.detectable_id = detectableId;
  }

  function updateScaleSelected(scale){
    self.filterStore.heatmap.scale = scale;
  }

  function updateZdistThreshSelected(zdistThresh){
    self.filterStore.heatmap.zdist_thresh = zdistThresh;
  }

  //------------------------------------------------
  // set relations
  this.setEventManager = function(em){
    self.eventManager = em;
    self.eventManager.addAnnoListSelectedCallback(updateAnnoListSelected);
    return self;
  };

  this.resetFilters = function(){
    self.dataStore.reset();
    self.filterStore.reset();
  };

  //------------------------------------------------
  // shorthand for error printing
  this.err = function(errorReason){
    displayJavascriptError('Mining.DataManager.DataManager -> ' + errorReason);
  };
};
