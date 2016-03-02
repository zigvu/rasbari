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
    return self.rgba(allColors[curColorCounter], transparency);
  };

  this.nextColor = function(){
    curColorCounter++;
    if(curColorCounter >= allColors.length){ curColorCounter = 0; }
  };
  
  this.rgba = function(rgb, a){
    return "rgba(" + rgb[0] + "," + rgb[1] + "," + rgb[2] + "," + a + ")";
  };

  var allColors = [
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
};