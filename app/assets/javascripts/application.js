// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require d3
//= require colorbrewer
//= require crossfilter
//= require jquery-readyselector
//= require jquery-spinner
//= require q
//= require underscore
//= require kheer/application
//= require analysis/application
//= require turbolinks
//= require_tree .

$(function(){
  $(document).foundation();
  $(document).ready(decorateNavigationList);
  $(document).ready(activateSelectAllLinks);
});
