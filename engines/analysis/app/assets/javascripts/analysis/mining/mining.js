$(".analysis_minings_mine").ready(function() {
  annotationController = new Mining.Controller.AnnotationController();
  annotationController.register();
  annotationController.loadData(window.miningId, window.setId);
  // annotationController.bindPageUnload();
});
