$(".analysis_minings_det_finder_workflow_show").ready(function() {
  locSel = new ZIGVU.Kheer.ChiaModel.Selection('loc');
  annoSel = new ZIGVU.Kheer.ChiaModel.Selection('anno');

  // for video/channel selection
  var options = { sortable: true };
  $("select#channel_selection").treeMultiselect(options);
});
