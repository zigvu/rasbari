var ZIGVU = ZIGVU || {};
ZIGVU.Analysis = ZIGVU.Analysis || {};
ZIGVU.Analysis.Mining = ZIGVU.Analysis.Mining || {};

var Mining = ZIGVU.Analysis.Mining;
Mining.ChartManager = Mining.ChartManager || {};
Mining.ChartManager.D3Charts = Mining.ChartManager.D3Charts || {};

/*
  D3 timeline chart
*/

Mining.ChartManager.D3Charts.ClusterChart = function() {
    var self = this;

    console.log("init cluster chart");
    this.eventManager = undefined;
    this.dataManager = undefined;

    this.lassoEndCallback = undefined;
    self.onLassoEnd = function( cbLassoEnd) {
	self.lassoEndCallback = cbLassoEnd;
    }

    var divId_d3ScatterChart = "#scatter_chart";
    this.drawChart = drawChart;

    var margin = {top: 20, right: 20, bottom: 30, left: 40},
	width = 960 - margin.left - margin.right,
	height = 500 - margin.top - margin.bottom;

    var x = d3.scale.linear()
        .range([0, width]);

    var y = d3.scale.linear()
        .range([height, 0]);

    var color = d3.scale.category10();

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left");

    var svg = d3.select(divId_d3ScatterChart).append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
	.append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    // Lasso functions to execute while lassoing
    var lasso_start = function() {
	lasso.items()
	    .attr("r",3.5) // reset size
	    .style("fill",null) // clear all of the fills
	    .classed({"not_possible":true,"selected":false}); // style as not possible
    };

    var lasso_draw = function() {
	// Style the possible dots
	lasso.items().filter(function(d) {return d.possible===true})
	    .classed({"not_possible":false,"possible":true});

	// Style the not possible dot
	lasso.items().filter(function(d) {return d.possible===false})
	    .classed({"not_possible":true,"possible":false});
    };

    var lasso_end = function() {
	// Reset the color of all dots
	lasso.items()
	    .style("fill", function(d) { return color(d.label); });

	// Style the selected dots
	lasso.items().filter(function(d) {return d.selected===true})
	    .classed({"not_possible":false,"possible":false})
	    .attr("r",7);

	// Reset the style of the not selected dots
	lasso.items().filter(function(d) {return d.selected===false})
	    .classed({"not_possible":false,"possible":false})
	    .attr("r",3.5);

	if ( self.lassoEndCallback) {
	    var selectedData = lasso.items().filter( function(d) { return d.selected===true; });
	    if ( selectedData.length > 0) {
		var selected = selectedData[0];
		if (selected.length > 0) {
		    var selectedActualData = _.map( selected, function(d) {
			console.log("selected: " , d3.select(d).node().__data__);
			var nodeData = d3.select(d).node().__data__;
			return { x: nodeData.x, y: nodeData.y, label: nodeData.label};
		    })
		    self.lassoEndCallback(  selectedActualData);
		}
	    }
	    
	}
    };

    // Create the area where the lasso event can be triggered
    var lasso_area = svg.append("rect")
        .attr("width",width)
        .attr("height",height)
        .style("opacity",0);

    // Define the lasso
    var lasso = d3.lasso()
        .closePathDistance(75) // max distance for the lasso loop to be closed
        .closePathSelect(true) // can items be selected by closing the path?
        .hoverSelect(true) // can items by selected by hovering over them?
        .area(lasso_area) // area where the lasso can be started
        .on("start",lasso_start) // lasso start function
        .on("draw",lasso_draw) // lasso draw function
        .on("end",lasso_end); // lasso end function

    // Init the lasso on the svg:g that contains the dots
    svg.call(lasso);
    


    function drawChart(clusterData) {
	var data = clusterData;
	x.domain(d3.extent(data, function(d) { return d.x; })).nice();
	y.domain(d3.extent(data, function(d) { return d.y; })).nice();

	svg.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(0," + height + ")")
	    .call(xAxis)
	    .append("text")
	    .attr("class", "label")
	    .attr("x", width)
	    .attr("y", -6)
	    .style("text-anchor", "end")
	    .text("Value (X)");

	svg.append("g")
	    .attr("class", "y axis")
	    .call(yAxis)
	    .append("text")
	    .attr("class", "label")
	    .attr("transform", "rotate(-90)")
	    .attr("y", 6)
	    .attr("dy", ".71em")
	    .style("text-anchor", "end")
	    .text("Value (Y)")


	svg.selectAll(".dot")
	    .data(clusterData)
	    .enter().append("circle")
	    .attr("id",function(d,i) {return "dot_" + i;}) // added
	    .attr("class", "dot")
	    .attr("r", 3.5)
	    .attr("cx", function(d) { return x(d.x); })
	    .attr("cy", function(d) { return y(d.y); })
	    .style("fill", function(d) { return color(d.label); });

	lasso.items(d3.selectAll(".dot"));

	var legend = svg.selectAll(".legend")
	    .data(color.domain())
	    .enter().append("g")
	    .attr("class", "legend")
	    .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

	legend.append("rect")
	    .attr("x", width - 18)
	    .attr("width", 18)
	    .attr("height", 18)
	    .style("fill", color);

	legend.append("text")
	    .attr("x", width - 24)
	    .attr("y", 9)
	    .attr("dy", ".35em")
	    .style("text-anchor", "end")
	    .text(function(d) { return d; });
    }

    //------------------------------------------------
    // set relations
    this.setEventManager = function(em){
	self.eventManager = em;
	//self.eventManager.addPaintFrameCallback(updateChartFromVideoPlayer);
	//self.eventManager.addUpdateAnnoChartCallback(updateAnnoChart);
	return self;
    };

    this.setDataManager = function(dm){
	self.dataManager = dm;
	return self;
    };
};
