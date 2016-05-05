var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.DataManager = Mining.DataManager || {};
Mining.DataManager.Stores = Mining.DataManager.Stores || {};

/*
  This class stores all server provided data.
*/

/*
  Data structure:
  [Note: Ruby style hash (:keyname => value) implies that raw id are used as keys of objects.
  JS style hash implies that (keyname: value) text are used as keys of objects.]

  firstEvaluatedVideoFn: int

  miningData: {
    chiaModels: [<chiaModel>, ],
    chiaModelIds: {localization: int, annotation: int},
    detectables: [<detectable>, ],
    detectableIds: {localization: [int, ], annotation: [int, ]},
    clips: [<clip>, ],
    clipSet: [{clip_id:, other_unused:, }],
    selectedDetIds: [int, ],
    smartFilter: {spatial_intersection_thresh:,}
  }

  where:
    <chiaModel>: {
      id:, name:, version:,
      settings: {zdist_threshs: [zdistValue, ], scales: [scale, ], prob_scores: [score, ]}
    }
    <detectables>: [{id:, name:, pretty_name:}, ]
    <clip>: {clip_id:, clip_url:, clip_fn_start:, clip_fn_end:, length:,
      playback_frame_rate:, detection_frame_rate: }

  dataFullLocalizations: {:clip_id => {:clip_fn => {:detectable_id => [loclz]}}}
    where loclz: {
      chia_model_id:, zdist_thresh:, prob_score:,
      spatial_intersection:, scale:, x:, y:, w:, h:
    }

  dataFullAnnotations: {:clip_id => {:clip_fn => {:detectable_id => [anno]}}}
    where anno: {chia_model_id:, source_type:, is_new: false, x0:, y0:, x1:, y1:, x2:, y2:, x3:, y3}

  colorMap: {:integer => 'rgb', }

  detectables:
    { decorations:
      {:detectable_id =>
        { id:, name:, pretty_name:,
          button_color:, button_hover_color:, annotation_color:
        }
      },
    }

  clipDetailsMap: {
    sortedClipIds: [],
    clipMap: {:clip_id => <clip_details_from_miningData>, }
  }

  chiaModelIdMap: {:chia_model_id => <chiaModel>, }

  tChartDataLoc: [{name:, color:, values: [{counter: score:}, ]}, ]
  tChartDataAnno: [{name:, color:, values: [{counter: score:}, ]}, ]
  toCounterMap: {:clip_id => {:clip_fn => counter}}
  fromCounterMap: {:counter => {clip_id: , clip_fn:}}

  videoState = {current:, previous:}
    where current/previous is difned in file:
    annotations/data_manager/accessors/localization_data_accessor.js -> getVideoState()

*/

Mining.DataManager.Stores.DataStore = function() {
  var self = this;
  this.colorCreator = new Mining.Helpers.ColorCreator();
  this.textFormatters = new Mining.Helpers.TextFormatters();

  // TODO: get from config
  this.firstEvaluatedVideoFn = 0;

  // raw data
  this.miningData = undefined;
  this.dataFullLocalizations = undefined;
  this.dataFullAnnotations = undefined;
  this.colorMap = undefined;

  // massaged data
  this.detectables = { decorations: undefined };
  this.clipDetailsMap = {
    sortedClipIds: undefined, clipMap: undefined
  };
  this.chiaModelIdMap = undefined;

  // timeline chart data
  this.tChartData = undefined;
  this.toCounterMap = undefined;
  this.fromCounterMap = undefined;

  // current states
  this.videoState = {current: undefined, previous: undefined};

  this.reset = function(){
    self.miningData = undefined;
    self.dataFullLocalizations = undefined;
    self.dataFullAnnotations = undefined;
    self.colorMap = undefined;

    self.detectables = { decorations: undefined };
    self.clipDetailsMap = {
      sortedClipIds: undefined, clipMap: undefined
    };
    self.chiaModelIdMap = undefined;

    self.tChartData = undefined;
    self.toCounterMap = undefined;
    self.fromCounterMap = undefined;

    self.videoState = {current: undefined, previous: undefined};
  };
};
