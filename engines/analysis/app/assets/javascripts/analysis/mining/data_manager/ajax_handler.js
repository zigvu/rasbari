var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.DataManager = Mining.DataManager || {};

/*
  This class handles talking with rails server.
*/

Mining.DataManager.AjaxHandler = function() {
  var self = this;

  this.dataStore = undefined;
  this.filterStore = undefined;
  this.baseUrl = '/analysis/api/v1';

  this.getMiningDataPromise = function(miningId, setId){
    var dataURL = self.baseUrl + '/minings/set_details';
    var dataParam = {mining_id: miningId, set_id: setId};

    var requestDefer = Q.defer();
    self.getGETRequestPromise(dataURL, dataParam)
      .then(function(data){
        self.dataStore.miningData = data;
        // get full localizations
        dataURL = self.baseUrl + '/minings/full_localizations';
        return self.getGETRequestPromise(dataURL, dataParam);
      })
      .then(function(data){
        self.dataStore.dataFullLocalizations = data;
        // get full annotations
        dataURL = self.baseUrl + '/minings/full_annotations';
        return self.getGETRequestPromise(dataURL, dataParam);
      })
      .then(function(data){
        self.dataStore.dataFullAnnotations = data;
        requestDefer.resolve();
      })
      .catch(function (errorReason) {
        requestDefer.reject('Mining.DataManager.AjaxHandler ->' + errorReason);
      });

    return requestDefer.promise;
  };

  this.getAnnotationSavePromise = function(annotationsData){
    var dataURL = self.baseUrl + '/frames/update_annotations';
    var dataParam = {annotations: annotationsData};

    return self.getPOSTRequestPromise(dataURL, dataParam);
  };

  this.getHeatmapDataPromise = function(clipId, clipFN){
    var chiaModelId = self.dataStore.miningData.chiaModelIds.localization;
    var detectableId = self.filterStore.heatmap.detectable_id;
    var scale = self.filterStore.heatmap.scale;

    var dataURL = self.baseUrl + '/frames/heatmap_data';
    var dataParam = {
      heatmap: {
        chia_model_id: chiaModelId,
        clip_id: clipId,
        clip_fn: clipFN,
        scale: scale,
        detectable_id: detectableId
      }
    };

    return self.getGETRequestPromise(dataURL, dataParam);
  };

  this.getAllLocalizationsPromise = function(clipId, clipFN){
    var requestDefer = Q.defer();

    var chiaModelId = self.dataStore.miningData.chiaModelIds.localization;
    var zdistThresh = self.filterStore.heatmap.zdist_thresh;
    var probScore = self.filterStore.heatmap.prob_score;

    var dataURL = self.baseUrl + '/frames/localization_data';
    var dataParam = {
      localization: {
        chia_model_id: chiaModelId,
        clip_id: clipId,
        clip_fn: clipFN,
        // zdist_thresh: zdistThresh
        prob_score: probScore
      }
    };
    self.getGETRequestPromise(dataURL, dataParam)
      .then(function(data){
        var localizations = [];
        if((data.localizations[clipId] !== undefined) &&
          (data.localizations[clipId][clipFN] !== undefined)){
          localizations = data.localizations[clipId][clipFN];
        }
        self.filterStore.currentLocalizations = localizations;
        requestDefer.resolve();
      })
      .catch(function (errorReason) {
        requestDefer.reject('Mining.DataManager.AjaxHandler ->' + errorReason);
      });

    return requestDefer.promise;
  };

  // note: while jquery ajax return promises, they are deficient
  // and we need to convert to `q` based promises
  this.getGETRequestPromise = function(url, params){
    var requestDefer = Q.defer();
    $.ajax({
      url: url,
      data: params,
      type: "GET",
      success: function(json){ requestDefer.resolve(json); },
      error: function( xhr, status, errorThrown ) {
        requestDefer.reject("Mining.DataManager.AjaxHandler: " + errorThrown);
      }
    });
    return requestDefer.promise;
  };

  this.getPOSTRequestPromise = function(url, params){
    var requestDefer = Q.defer();
    $.ajax({
      url: url,
      data: params,
      type: "POST",
      success: function(json){ requestDefer.resolve(json); },
      error: function( xhr, status, errorThrown ) {
        requestDefer.reject("Mining.DataManager.AjaxHandler: " + errorThrown);
      }
    });
    return requestDefer.promise;
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

  // shorthand for error printing
  this.err = function(errorReason){
    displayJavascriptError('Mining.DataManager.AjaxHandler -> ' + errorReason);
  };
};
