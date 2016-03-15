var ZIGVU = ZIGVU || {};
ZIGVU.Kheer = ZIGVU.Kheer || {};
ZIGVU.Kheer.ChiaModel = ZIGVU.Kheer.ChiaModel || {};

var ChiaModel = ZIGVU.Kheer.ChiaModel;


ChiaModel.Selection = function(sel){
  var self = this;

  // hide all minor and mini tables
  $("." + sel + "_table_minor").hide();
  $("." + sel + "_table_mini").hide();

  // if a major is clicked, hide all minors and show selected minor
  $("input[type=radio][name=" + sel + "_radio_major]").change(function() {
    $("." + sel + "_table_minor").hide();
    $("." + sel + "_table_mini").hide();
    $("#" + sel + "_table_minor_" + this.value).show();
  });

  $("input[type=radio][name=" + sel + "_radio_minor]").change(function() {
    $("." + sel + "_table_mini").hide();
    $("#" + sel + "_table_mini_" + this.value).show();
  });
};
