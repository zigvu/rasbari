var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.FrameDisplay = Mining.FrameDisplay || {};

/*
  Handler to draw heatmap.
*/

Mining.FrameDisplay.DrawHeatmap = function() {
  var self = this;

  this.canvas = document.getElementById("heatmapCanvas");
  this.ctx = self.canvas.getContext("2d");

  this.dataManager = undefined;
  var heatmapDrawn = false;

  var heatCell = new Mining.FrameDisplay.Shapes.HeatCell();

  this.drawHeatmap = function(clipId, clipFN){
    // cycle through scales array if heatmap already drawn
    if(heatmapDrawn){
      self.dataManager.getFilter_cycleScales();
    }
    self.clear();
    self.dataManager.heatmap_getHeatmapDataPromise(clipId, clipFN)
      .then(function(heatmapData){
        if(heatmapData.length > 0){
          var colorMap = self.dataManager.getData_colorMap();
          // draw background
          bkgrndCell = {x: 0, y: 0, w: self.canvas.width, h: self.canvas.height};
          heatCell.draw(self.ctx, bkgrndCell, colorMap[0]);
          // draw boxes
          _.each(heatmapData, function(cell, idx, list){
            var color = colorMap[parseInt(cell.prob_score * 100)];
            heatCell.draw(self.ctx, cell, color);
          });
          heatmapDrawn = true;
        } else {
          console.log("Heatmap data not available");
        }
      })
      .catch(function (errorReason) { self.err(errorReason); });
  };

  this.clear = function(){
    if(heatmapDrawn){
      // clear existing content
      self.ctx.clearRect(0, 0, self.canvas.width, self.canvas.height);
      heatmapDrawn = false;
    }
  };

  // set relations
  this.setDataManager = function(dm){
    self.dataManager = dm;
    return self;
  };

  // shorthand for error printing
  this.err = function(errorReason){
    displayJavascriptError('Mining.FrameDisplay.DrawHeatmap -> ' + errorReason);
  };
};
