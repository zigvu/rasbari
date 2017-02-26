var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.Controller = Mining.Controller || {};

/*
  This class is manage cluster 2-d plotting
*/

Mining.Controller.ClusterController = function() {
    var self = this;

    this.eventManager = new Mining.Controller.EventManager();
    this.dataManager = new Mining.DataManager.DataManager();

    this.clusterChartManager = new Mining.ChartManager.D3Charts.ClusterChart();

    self.InlineChildManager = new InlineChildManager();

    self.clusterChartManager.onLassoEnd( setClusterData);

    this.loadData = function(miningId, setId){
	self.dataManager.getClusterDataPromise()
	    .then(function(data){
		console.log("defined ? ", self.clusterChartManager);
		self.clusterChartManager.drawChart( data);
	    })
	    .catch(function (errorReason) { self.err(errorReason); });
    };


    function setClusterData(clusterData) {
	console.log("coluster data: ", clusterData);
	self.InlineChildManager.setData( clusterData);
    }


    this.register = function(){
	self.dataManager
	    .setEventManager(self.eventManager);

	self.clusterChartManager
	    .setEventManager(self.eventManager)
	    .setDataManager(self.dataManager);
	
    };

    // shorthand for error printing
    this.err = function(errorReason){
	displayJavascriptError('Mining.Controller.ClusterController -> ' + errorReason);
    };

    function InlineChildManager() {
	var self = this;
	var divId = "lasso_selection"
	self.setData = setData;
	var $div = $("#" + divId);
	function setData(data) {
	    console.log("child has data: ", JSON.stringify(data));
	    var textValue = _.map( data, function(d) {
		return ["[Label: ", d.label, ", X:", d.x, ", Y:", d.y, "]"].join('');
	    }).join(", ");
	    $div.text( textValue);

	}
    }
};
