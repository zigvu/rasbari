$(".analysis_minings_confusion_finder_workflow_show").ready(function() {
  // special case for wicked wizard since it always uses show - disable
  // when not in set_confusions.html.erb page
  if(!window.isInConfusionPage){ return; }

  var buttonDisabled = false;
  disableButtons();

  heatmapChart = undefined;
  eventManager = new MiningSetup.Confusion.EventManager();
  dataManager = new MiningSetup.Confusion.DataManager();
  dataManager.setEventManager(eventManager);

  populateFilters();

  showSpinner();
  dataManager.getFullDataPromise()
    .then(function(){
      hideSpinner();
      heatmapChart = new MiningSetup.Confusion.HeatmapChart(dataManager);
      heatmapChart.setEventManager(eventManager);

      enableButtons();
    })
    .catch(function (errorReason) {
      displayJavascriptError(errorReason);
    });

  $("#heatmap-submit").click(function(){
    if(buttonDisabled){ return; }
    disableButtons();

    showSpinner();
    populateFilters();
    dataManager.getFullDataPromise()
      .then(function(){
        hideSpinner();
        enableButtons();
      })
      .catch(function (errorReason) {
        displayJavascriptError(errorReason);
      });
  });

  $("#heatmap-hide-diagonal").click(function(){
    if(buttonDisabled){ return; }
    disableButtons();
    dataManager.setZeroDiagonal();
    enableButtons();
    // once diagonals is removed, disable
    $("#heatmap-hide-diagonal").addClass('disabled');
  });


  function populateFilters(){
    var priProbs = $('input[name="priProbThreshs"]:checked').map(function() {
      return parseFloat(this.value);
    }).get();
    var priScales = $('input[name="priScales"]:checked').map(function() {
      return parseFloat(this.value);
    }).get();

    var secProbs = $('input[name="secProbThreshs"]:checked').map(function() {
      return parseFloat(this.value);
    }).get();
    var secScales = $('input[name="secScales"]:checked').map(function() {
      return parseFloat(this.value);
    }).get();

    var intThresh = parseFloat($("#intThresh").val());

    dataManager.updateFilters(priProbs, priScales, secProbs, secScales, intThresh);
  }

  function enableButtons(){
    buttonDisabled = false;
    $("#heatmap-submit").removeClass('disabled');
    $("#heatmap-hide-diagonal").removeClass('disabled');
    $("#maxNumOfLocalizations").text(dataManager.getMaxNumOfLocalizations());
  }

  function disableButtons(){
    buttonDisabled = true;
    $("#heatmap-submit").addClass('disabled');
    $("#heatmap-hide-diagonal").addClass('disabled');
  }
});
