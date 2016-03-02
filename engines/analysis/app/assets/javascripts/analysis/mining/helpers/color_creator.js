var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.Helpers = Mining.Helpers || {};

/*
  Creates colors
*/

Mining.Helpers.ColorCreator = function() {
  var self = this;
  var curColorCounter = 0;

  var buttonTransparency = 0.6,
    buttonHoverTransparency = 1.0,
    annotationPolygonTransparency = 0.5;
    chartTransparency = 0.8;

  this.getColorButton = function(){ return self.getRGBAColor(buttonTransparency); };
  this.getColorButtonHover = function(){ return self.getRGBAColor(buttonHoverTransparency); };
  this.getColorAnnotation = function(){ return self.getRGBAColor(annotationPolygonTransparency); };
  this.getColorChart = function(){ return self.getRGBAColor(chartTransparency); };

  this.getRGBAColor = function(transparency){
    return self.rgba(locColors[curColorCounter], transparency);
  };

  this.nextColor = function(){
    curColorCounter++;
    if(curColorCounter >= locColors.length){ curColorCounter = 0; }
  };

  this.rgba = function(rgb, a){
    return "rgba(" + rgb[0] + "," + rgb[1] + "," + rgb[2] + "," + a + ")";
  };

  var locColors = [
    [255,0,0], [255,204,0], [43,171,145], [108,85,171], [171,0,0],
    [171,137,0], [128,255,246], [68,0,171], [171,43,43], [87,69,0],
    [43,87,84], [94,43,171], [87,22,22], [255,230,128], [191,255,251],
    [145,128,171], [255,128,128], [255,242,191], [0,238,255], [136,0,255],
    [255,191,191], [171,162,128], [43,162,171], [58,0,87], [87,65,65],
    [255,238,0], [0,204,255], [191,64,255], [255,89,64], [171,159,0],
    [43,145,171], [213,128,255], [171,97,85], [238,255,0], [128,230,255],
    [234,191,255], [87,49,43], [82,87,22], [43,78,87], [137,0,171],
    [255,115,64], [137,171,0], [128,162,171], [154,85,171], [171,77,43],
    [229,255,128], [0,170,255], [78,43,87], [87,39,22], [154,171,85],
    [43,128,171], [238,0,255], [255,162,128], [162,171,128], [191,234,255],
    [171,0,159], [171,108,85], [170,255,0], [0,136,255], [87,65,85],
    [255,208,191], [234,255,191], [43,111,171], [255,0,204], [255,102,0],
    [56,87,22], [128,196,255], [87,0,69], [171,68,0], [77,87,65],
    [43,66,87], [255,128,229], [255,140,64], [94,171,43], [128,151,171],
    [171,128,162], [171,94,43], [178,255,128], [0,102,255], [171,0,114],
    [255,179,128], [120,171,85], [43,94,171], [87,43,72], [171,120,85],
    [34,255,0], [128,179,255], [255,191,234], [87,61,43], [12,87,0],
    [0,68,255], [255,0,136], [171,145,128], [200,255,191], [0,46,171],
    [87,0,46], [87,74,65], [0,171,0], [43,77,171], [255,128,196],
    [255,136,0], [128,171,134], [128,162,255], [171,85,131], [171,91,0],
    [127,255,161], [43,55,87], [255,0,102], [87,56,22], [0,87,35],
    [191,208,255], [171,0,68], [255,196,128], [43,171,94], [128,140,171],
    [255,0,68], [255,225,191], [0,255,136], [0,12,87], [255,128,162],
    [255,170,0], [191,255,225], [43,43,87], [87,43,55], [171,114,0],
    [64,255,191], [34,0,255], [255,191,208], [171,142,85], [128,255,212],
    [145,128,255], [171,85,97], [87,72,43], [128,171,157], [200,191,255],
    [171,128,134], [87,79,65], [0,87,69], [68,65,87]];

    this.heatmapColors = {
      "0":"#000080","1":"#000089","2":"#000096","3":"#00009f","4":"#0000ad",
      "5":"#0000b6","6":"#0000c4","7":"#0000cd","8":"#0000da","9":"#0000e8",
      "10":"#0000f1","11":"#0000ff","12":"#0000ff","13":"#0004ff","14":"#000dff",
      "15":"#0019ff","16":"#0021ff","17":"#002dff","18":"#0039ff","19":"#0041ff",
      "20":"#004dff","21":"#0054ff","22":"#0061ff","23":"#0069ff","24":"#0074ff",
      "25":"#0081ff","26":"#0088ff","27":"#0095ff","28":"#009dff","29":"#00a8ff",
      "30":"#00b1ff","31":"#00bdff","32":"#00c5ff","33":"#00d1ff","34":"#00ddfe",
      "35":"#00e5f8","36":"#09f1ee","37":"#0ff9e7","38":"#19ffde","39":"#1fffd7",
      "40":"#29ffce","41":"#30ffc7","42":"#39ffbe","43":"#43ffb4","44":"#49ffad",
      "45":"#53ffa4","46":"#5aff9d","47":"#63ff94","48":"#6aff8d","49":"#73ff83",
      "50":"#7dff7a","51":"#83ff73","52":"#8dff6a","53":"#94ff63","54":"#9dff5a",
      "55":"#a4ff53","56":"#adff49","57":"#b4ff43","58":"#beff39","59":"#c7ff30",
      "60":"#ceff29","61":"#d7ff1f","62":"#deff19","63":"#e7ff0f","64":"#eeff09",
      "65":"#f8f500","66":"#feed00","67":"#ffe200","68":"#ffd700","69":"#ffd000",
      "70":"#ffc400","71":"#ffbd00","72":"#ffb200","73":"#ffab00","74":"#ff9f00",
      "75":"#ff9400","76":"#ff8d00","77":"#ff8200","78":"#ff7a00","79":"#ff6f00",
      "80":"#ff6800","81":"#ff5d00","82":"#ff5500","83":"#ff4a00","84":"#ff3f00",
      "85":"#ff3800","86":"#ff2d00","87":"#ff2500","88":"#ff1a00","89":"#ff1300",
      "90":"#f10800","91":"#e80000","92":"#da0000","93":"#cd0000","94":"#c40000",
      "95":"#b60000","96":"#ad0000","97":"#9f0000","98":"#960000","99":"#890000",
      "100":"#800000"
    };
};