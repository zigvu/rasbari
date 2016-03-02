var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.FrameDisplay = Mining.FrameDisplay || {};
Mining.FrameDisplay.Shapes = Mining.FrameDisplay.Shapes || {};

/*
  Rectangle drawing for drawing one cell of heatmap.
*/

Mining.FrameDisplay.Shapes.HeatCell = function() {
  var self = this;

  this.draw = function(ctx, cell, fillColor){
    ctx.fillStyle = fillColor;
    ctx.fillRect(cell.x, cell.y, cell.w, cell.h);
  };
};
