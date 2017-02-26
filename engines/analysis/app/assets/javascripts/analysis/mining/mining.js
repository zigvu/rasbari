$(".analysis_minings_mine").ready(function() {
  annotationController = new Mining.Controller.AnnotationController();
  annotationController.register();
  annotationController.loadData(window.miningId, window.setId);
  // annotationController.bindPageUnload();
});


$("#scatter_plot").ready(function() {
    console.log('scatter plot ready');
    var clusterController = new Mining.Controller.ClusterController();
    clusterController.register();
    clusterController.loadData();

});
