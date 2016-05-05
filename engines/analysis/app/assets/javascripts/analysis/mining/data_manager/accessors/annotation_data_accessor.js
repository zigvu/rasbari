var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.DataManager = Mining.DataManager || {};
Mining.DataManager.Accessors = Mining.DataManager.Accessors || {};

/*
  This class accesses data related to annotations.
*/

Mining.DataManager.Accessors.AnnotationDataAccessor = function() {
  var self = this;

  this.filterStore = undefined;
  this.dataStore = undefined;

  // ----------------------------------------------
  // chia data
  this.getDetectablesById = function(detectableIds){
    var detectables = self.dataStore.miningData.detectables;
    var dets = [];
    // maintain order of detectableIds
    _.each(detectableIds, function(detId){
      det = _.find(detectables, function(d){ return d.id == detId; });
      dets.push(det);
    });
    return dets;
  };

  this.getAnnotationDetectables = function(){
    return self.getDetectablesById(self.dataStore.miningData.detectableIds.annotation);
  };

  this.getLocalizationDetectables = function(){
    return self.getDetectablesById(self.dataStore.miningData.detectableIds.localization);
  };

  this.getChiaModelId = function(){
    return self.dataStore.miningData.chiaModelIds.annotation;
  };

  // ----------------------------------------------
  // annotaitons raw data
  this.setCurrentAnnotations = function(clipId, clipFN){
    var anno = self.dataStore.dataFullAnnotations;
    var curAnnos = {};
    if(anno[clipId] !== undefined && anno[clipId][clipFN] !== undefined){
      curAnnos = anno[clipId][clipFN];
    }
    self.filterStore.currentAnnotations = curAnnos;
  };

  this.updateAnnotations = function(clipId, clipFN, annotationObjs){
    // put in clip_id and clip_fn for each object
    _.each(annotationObjs, function(objArr, arrKey){
      _.each(objArr, function(ao){
        _.extend(ao, { clip_id: clipId, clip_fn: clipFN });
      });
    });

    // update internal data structure
    var anno = self.dataStore.dataFullAnnotations;
    if(anno[clipId] === undefined){ anno[clipId] = {}; }
    if(anno[clipId][clipFN] === undefined){ anno[clipId][clipFN] = {}; }

    // update - deleted annotations
    _.each(annotationObjs.deleted_annos, function(ao){
      var idx = -1;
      _.find(anno[clipId][clipFN][ao.detectable_id], function(a, i, l){
        if((a.x0 == ao.x0) && (a.y0 == ao.y0) && (a.x1 == ao.x1) &&
          (a.x2 == ao.x2) && (a.x3 == ao.x3)) { idx = i; return true; }
        return false;
      });
      if(idx != -1){ anno[clipId][clipFN][ao.detectable_id].splice(idx, 1); }
    });

    // update - new annotations
    _.each(annotationObjs.new_annos, function(ao){
      if(anno[clipId][clipFN][ao.detectable_id] === undefined){
        anno[clipId][clipFN][ao.detectable_id] = [];
      }
      anno[clipId][clipFN][ao.detectable_id].push(ao);
    });

    // update - new localizations as annotations
    _.each(annotationObjs.new_locs, function(ao){
      if(anno[clipId][clipFN][ao.detectable_id] === undefined){
        anno[clipId][clipFN][ao.detectable_id] = [];
      }
      anno[clipId][clipFN][ao.detectable_id].push(ao);
    });

    // delete existing localizations
    self.dataStore.dataFullLocalizations[clipId][clipFN] = {};
    self.filterStore.currentLocalizations = {};
    return annotationObjs;
  };

  this.getSelectedAnnotationDetails = function(){
    return self.getAnnotationDetails(self.filterStore.currentAnnotationDetId);
  };

  this.getAnnotationDetails = function(detId){
    return {
      id: detId,
      title: self.dataStore.detectables.decorations[detId].pretty_name,
      color: self.dataStore.detectables.decorations[detId].annotation_color
    };
  };

  //------------------------------------------------
  // create decorations
  this.createDetectableDecorations = function(){
    var colorCreator = self.dataStore.colorCreator;
    var textFormatters = self.dataStore.textFormatters;

    self.dataStore.detectables.decorations = {};
    var decorations = self.dataStore.detectables.decorations;

    // provide color to annotation list first
    _.each(self.getAnnotationDetectables(), function(d){
      var decos = {
        pretty_name: textFormatters.ellipsisForAnnotation(d.pretty_name),
        button_color: colorCreator.getColorButton(),
        button_hover_color: colorCreator.getColorButtonHover(),
        annotation_color: colorCreator.getColorAnnotation(),
        chart_color: colorCreator.getColorChart()
      };

      colorCreator.nextColor();
      decorations[d.id] = _.extend(d, decos);
    });

    // provide color to localization list second
    _.each(self.getLocalizationDetectables(), function(d){
      // skip if already in decoration map
      if(_.has(decorations, d.id)){ return; }
      // else, continue
      var decos = {
        pretty_name: textFormatters.ellipsisForAnnotation(d.pretty_name),
        button_color: colorCreator.getColorButton(),
        button_hover_color: colorCreator.getColorButtonHover(),
        annotation_color: colorCreator.getColorAnnotation(),
        chart_color: colorCreator.getColorChart()
      };

      colorCreator.nextColor();
      decorations[d.id] = _.extend(d, decos);
    });
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
