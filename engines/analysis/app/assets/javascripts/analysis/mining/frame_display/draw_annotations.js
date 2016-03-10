var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.FrameDisplay = Mining.FrameDisplay || {};

/*
  Annotation creation
*/

Mining.FrameDisplay.DrawAnnotations = function() {
  var self = this;

  this.canvas = document.getElementById("annotationCanvas");
  new Mining.FrameDisplay.CanvasExtender(self.canvas);
  this.ctx = self.canvas.getContext("2d");

  this.dataManager = undefined;

  var polygons = [], selectedPolyId, polyIdCounter = 0;
  var currentClipId, currentClipFN;

  this.annotationMode = false;

  this.startAnnotation = function(clipId, clipFN){
    // if previously was annotating, save that annotation
    if(self.annotationMode){ self.endAnnotation(); }
    // new annotation
    self.annotationMode = true;
    self.drawAnnotations(clipId, clipFN);
  };

  this.endAnnotation = function(){
    self.annotationMode = false;

    var svPs = self.getPolygonsToSave();
    // no need to check new locs objects
    if( svPs.deleted_annos.length > 0 ||
        svPs.new_annos.length > 0 ||
        svPs.deleted_locs.length > 0){
      self.dataManager.setAnno_saveAnnotations(currentClipId, currentClipFN, svPs);
    }
    self.resetWithoutSave();
  };

  this.resetWithoutSave = function(){
    self.annotationMode = false;
    polygons = [];
    polyIdCounter = 0;
    self.drawOnce();
  };

  this.drawAnnotations = function(clipId, clipFN){
    currentClipId = clipId;
    currentClipFN = clipFN;

    var annotations = self.dataManager.getFilter_getCurrentAnnotations();
    _.each(annotations, function(anno, detectableId){
      _.each(anno, function(annoCoords){
        self.addPointCoords(annoCoords, detectableId);
      });
    });
    self.drawOnce();
  };

  this.deleteAnnotation = function(){
    if (selectedPolyId !== undefined){
      _.find(polygons, function(poly){
        if(poly.getPolyId() == selectedPolyId){
          poly.setDeleted();
          selectedPolyId = undefined;
          self.drawOnce();
          return true; // break
        }
        return false;
      });
    }
  };

  this.getselectedPolyId = function(){ return selectedPolyId; };

  this.getPolygonsToSave = function(){
    var deletedAnnoObjs = [], newAnnoObjs = [];
    var deletedLocObjs = [], newLocObjs = [];

    _.map(polygons, function(poly){
      if(poly.isClosed()){
        if(poly.isDeleted()){
          if(poly.isSourceChiaModel()){
            deletedLocObjs.push(poly.getPoints());
          } else if(poly.isSourceUser()) {
            deletedAnnoObjs.push(poly.getPoints());
          }
        }
        if(poly.isNew()){
          if(poly.isSourceChiaModel()){
            newLocObjs.push(poly.getPoints());
          } else {
            poly.setSourceUser();
            newAnnoObjs.push(poly.getPoints());
          }
        }
      }
    });
    return {
      deleted_annos: deletedAnnoObjs,
      new_annos: newAnnoObjs,
      deleted_locs: deletedLocObjs,
      new_locs: newLocObjs
    };
  };

  this.addToPolygons = function(poly){
    poly.setPolyId(polyIdCounter++);
    polygons.push(poly);
  };

  this.addPointCoords = function(annoCoords, detId){
    var p1 = new Mining.FrameDisplay.Shapes.Point(annoCoords.x0, annoCoords.y0);
    var p2 = new Mining.FrameDisplay.Shapes.Point(annoCoords.x1, annoCoords.y1);
    var p3 = new Mining.FrameDisplay.Shapes.Point(annoCoords.x2, annoCoords.y2);
    var p4 = new Mining.FrameDisplay.Shapes.Point(annoCoords.x3, annoCoords.y3);

    var annoDetails = self.dataManager.getAnno_anotationDetails(detId);
    var poly = new Mining.FrameDisplay.Shapes.Polygon(
      annoCoords.chia_model_id, annoDetails.id, annoDetails.title, annoDetails.color);
    poly.setSourceType(annoCoords.source_type);
    if(annoCoords.is_new){ poly.setNew(); }
    poly.addPoint(p1);
    poly.addPoint(p2);
    poly.addPoint(p3);
    poly.addPoint(p4);

    self.addToPolygons(poly);
  };

  this.handleLeftClick = function(x, y){
    if (self.annotationMode){
      // deselect all
      _.each(polygons, function(poly){ poly.deselect(); });

      // select last poly
      var poly = _.last(polygons);
      // start a new polygon if no polygon exists or if last polygon is complete
      if(poly === undefined || poly.isClosed()){
        var annoDetails = self.dataManager.getAnno_selectedAnnotationDetails();
        var chiaModelId = self.dataManager.getAnno_chiaModelId();
        poly = new Mining.FrameDisplay.Shapes.Polygon(
          chiaModelId, annoDetails.id, annoDetails.title, annoDetails.color);

        poly.setNew();
        self.addToPolygons(poly);
      }
      // add new point
      var point = new Mining.FrameDisplay.Shapes.Point(x,y);
      poly.addPoint(point);
    }
  };

  this.handleRightClick = function(x, y){
    if (self.annotationMode){
      // if was creating new poly, discard
      if((polygons.length > 0) && !(_.last(polygons).isClosed())){ polygons.pop(); }

      // deselect all
      _.each(polygons, function(poly){ poly.deselect(); });
      selectedPolyId = undefined;

      // check to see if any polygon got clicked
      clickedPolygon = self.getClickedPolygon(x, y);
      if(clickedPolygon !== undefined){
        selectedPolyId = clickedPolygon.getPolyId();
        clickedPolygon.select();
      } else {
        // do nothing
      }
    } else {
      // pause playback
    }
  };

  this.getClickedPolygon = function(x, y){
    return _.find(polygons, function(poly){ return poly.contains(x, y); });
  };

  this.drawOnce = function(){
    // clear existing content
    self.ctx.clearRect(0, 0, self.canvas.width, self.canvas.height);

    // if not annotating, no need to draw background rect
    if (self.annotationMode){
      // draw a transparent background for clicks
      self.ctx.fillStyle = 'rgba(0, 0, 0, 0)';
      self.ctx.fillRect(0, 0, self.canvas.width, self.canvas.height);
    }

    _.each(polygons, function(poly){ poly.draw(self.ctx); });
  };

  // define mouse handlers
  self.canvas.addEventListener('mousedown', function(e) {
    // if not annotating, disable mouse activity
    if (!self.annotationMode){ return; }

    e = e || window.event;
    mouse = self.getMouse(e);
    if (e.which == 1){
      self.handleRightClick(mouse.x, mouse.y);
    } else {
      self.handleLeftClick(mouse.x, mouse.y);
    }
    self.drawOnce();
  }, false);

  this.getMouse = function(e){
    // get mouse position relative to canvas
    var canvasRect = self.canvas.getBoundingClientRect();
    var canvasRectX = canvasRect.left;
    var canvasRectY = canvasRect.top;
    return {
      x: e.clientX - canvasRectX,
      y: e.clientY - canvasRectY
    };
  };

  // disable context menu on right click in canvas
  self.canvas.addEventListener("contextmenu", function(e){
    e.preventDefault();
  }, false);

  // set relations
  this.setDataManager = function(dm){
    self.dataManager = dm;
    return self;
  };
};
