// Arrays for the origins and destinations inputs
var origins = new Array();
var destinations = new Array();

// Initial query parameters
var query = {
travelMode: "DRIVING",
unitSystem: 1
};


// Google Distance Matrix Service 
var dms = new google.maps.DistanceMatrixService();

// Interval and Limit values for tracking origins groupings (for staying within QUERY_LIMIT)
var originsInterval = 0;
var originsLimit;

// Query Limit - 100 is the non-premier query limit as of this update
var QUERY_LIMIT = 100;

/*
* Updates the query, then uses the Distance Matrix Service
   */
function updateMatrix(stopid, callFrom) {
    updateQuery();
	if(callFrom == "callFromRefreshButton")
	{
		dms.getDistanceMatrix(query, function(response, status) {
        		if (status == "OK") {
          			extractDistances(response.rows,stopid, "callFromRefreshButton");
	        	}else{
    	        	alert("There was a problem with the request to googleMap.  The reported error is '"+status+"'");
        		}
      		}
    	);
	}
	else
	{
		dms.getDistanceMatrix(query, function(response, status) {
        		if (status == "OK") {
          			extractDistances(response.rows,stopid);
	        	}else{
    	        	alert("There was a problem with the request to googleMap.  The reported error is '"+status+"'");
        		}
      		}
    	);
	}
}

$(document).ready(function(){
	var tooltipClassCount=$('body').find('.tooltip').length;
	if (tooltipClassCount >0){
		$( ".tooltip" ).tooltip({
		  	position: {
				my: "top",
				at: "top-35",
			},
		  	show: {
				duration: "fast"
			},
		  	hide: {
				effect: "hide"
		  	}
		});
	}
	var InfotoolTipClassCount=$('body').find('.InfotoolTip').length;
	if (InfotoolTipClassCount >0){
	  	$('.InfotoolTip').tooltip({
		  	position: {
				my: "center bottom-20",
				at: "center top",
				using: function( position, feedback ) {
				  	$( this ).css( position );
				  	$( "<div>" )
					.addClass( "arrow" )
					.addClass( feedback.vertical )
					.addClass( feedback.horizontal )
					.appendTo( this );
				}
	  		}
		});
	}
});
  
/* 	* Retrieves origins and destinations from textareas and
	* determines how to build the entire matrix within query limitations 	*/
function getInputs(shipperAdd, consigneeAdd){
    var originsString = shipperAdd;
    var destinationsString = consigneeAdd;
	
    
    origins = originsString.split("|");
    destinations = destinationsString.split("|");
    query.destinations = destinations;
    originsLimit = Math.floor(QUERY_LIMIT/destinations.length);
    if(originsLimit > 25){
        originsLimit = 25;
    }
}
  
/*   * Updates the query based on the known sizes of origins and destinations   */
function updateQuery(){
    if(origins.length * destinations.length < QUERY_LIMIT && originsLimit < 25){
        query.origins = origins;
    }else{
        query.origins = origins.slice(originsLimit*originsInterval,originsLimit*(originsInterval+1));
    }
	originsInterval  = 0;
} 
  
/*   * Initializes the matrix data and pulls the first set of near 100 results   */
function matrixInit(shipperAddress, consigneeAddress,stopid, callFrom){
    dms = new google.maps.DistanceMatrixService();
    getInputs(shipperAddress, consigneeAddress);
    updateMatrix(stopid, callFrom);
} 
  
/*	* Accepts rows and populates table content.  Error validation is limited to the "ZERO_RESULTS"
   	* return status.  originsLimit and originsInterval are used to find the correct table cell.   */
function extractDistances(rows,stopid, callFrom) {
	if(document.getElementById("milesUpdateMode"+stopid) != null && document.getElementById("milesUpdateMode"+stopid).value != "auto" && callFrom != "callFromRefreshButton")
	  	return;
	  
    for (var i = 0; i < rows.length; i++) {
      	for (var j = 0; j < rows[i].elements.length; j++) {
        	if(rows[i].elements[j].status != "ZERO_RESULTS"){
				if(rows[i].elements[j].distance == undefined) {	
					distance = "0";
					if(stopid=="")
						alert("System cannot calculate the miles for Stop1 because the address is not recognised");
					else
						alert("System cannot calculate the miles for Stop"+stopid+" because the address is not recognised");
				} else
	           		distance = rows[i].elements[j].distance.text;
        	}else{
            	//alert("No Result"); // Do Nothing
       		}
      	}
	  
	  	distance = distance.replace(/,/g,"");
	  	distance = distance.replace("mi","");
	  	distance = trim(distance);

	  	if(isNaN(distance))
	  		distance = 0;
		if(document.getElementById("milse"+stopid) != null) {
		  	document.getElementById("milse"+stopid).value = distance;
		  	document.getElementById("milse"+stopid).onchange();
		}
		if(document.getElementById('calculatedMiles') != null) {
			document.getElementById('calculatedMiles').value = distance;
			document.getElementById('calculatedMiles').onchange();
		}
    }
}
  
function getFloat(str){
	if(trim(str) == "")
		str = "0";
	str = str.replace(/,/g,'');
	str = str.replace(/\$/g,'');
	str = str.replace(/\(/,'-');
	str = str.replace(/\)/,'');
	if(isNaN(str))
	{
		alert('invalid number entered')
		str = "0";
	}
	return parseFloat(str);
}
  
function updatedMilesWithLongShort(DSN, UserName) {
	var milseFromGoogle = getFloat(document.getElementById('calculatedMiles').value);
	
	var longMiles = getFloat(document.getElementById('longMiles').value);
	var shortMiles = getFloat(document.getElementById('shortMiles').value);	
	
	
	var customerMiles = milseFromGoogle + ((milseFromGoogle/100)*longMiles);
	var carrierMiles = milseFromGoogle - ((milseFromGoogle/100)*shortMiles);
	
	document.getElementById('customerMiles').value = convertNumberFormat(customerMiles);
	document.getElementById('carrierMiles').value = convertNumberFormat(carrierMiles);
	
	var customerRatePerMile = getFloat(document.getElementById('customerRate').value);
	var carrierRatePerMile = getFloat(document.getElementById('carrierRate').value);
	
	document.getElementById('customerAmount').value = (customerMiles * customerRatePerMile).toFixed(2);
	document.getElementById('carrierAmount').value = (carrierMiles * carrierRatePerMile).toFixed(2);
	
	addQuickCalcInfoToLog(DSN,UserName);
}


  //////////////////////////////////////////////////////////

// Get Customer Info using Coldfusion AJAX

var chkLoad=0;
function checkUnload() {
	chkLoad = 1;
}

function customerRatePerMileChanged() {
	var totalMiles = document.getElementById('CustomerMilesCalc').value;
	var customerRatePerMile = document.getElementById('CustomerRatePerMile').value;
	
	customerRatePerMile = customerRatePerMile.replace("$","");
	customerRatePerMile = customerRatePerMile.replace(/,/g,"");
	
	
	if(isNaN(customerRatePerMile)) {
		alert("Please enter a valid Rate");
		document.getElementById('CustomerRatePerMile').value="$0";
		document.getElementById('CustomerMiles').value = "$0";
		document.getElementById('CustomerMilesTotalAmount').value =  "$0";
		updateTotalAndProfitFields();
	} else {
		var customerRatePerMileFloat = parseFloat(customerRatePerMile);
		var totalmilesCommaReject=parseFloat(totalMiles.replace(/\,/g,''));
		var totalMilesAmount = (customerRatePerMileFloat*totalmilesCommaReject).toFixed(2);
		document.getElementById('CustomerMiles').value = "$"+convertDollarNumberFormat(totalMilesAmount);
		document.getElementById('CustomerMilesTotalAmount').value =  "$"+convertDollarNumberFormat(totalMilesAmount);
		updateTotalAndProfitFields();
	}
}

function carrierRatePerMileChanged() {
	var totalMiles = document.getElementById('CarrierMilesCalc').value;
	var carrierRatePerMile = document.getElementById('CarrierRatePerMile').value;
	
	carrierRatePerMile = carrierRatePerMile.replace("$","");
	carrierRatePerMile = carrierRatePerMile.replace(/,/g,"");
	
	if(isNaN(carrierRatePerMile)) {
		alert("Please enter a valid Rate");
		document.getElementById('CarrierRatePerMile').value="$0";
		document.getElementById('CarrierMiles').value = "$0";
		document.getElementById('CarrierMilesTotalAmount').value =  "$0";
		updateTotalAndProfitFields();
	} else {
		var carrierRatePerMileFloat = parseFloat(carrierRatePerMile);
		var totalmilesCommaReject=parseFloat(totalMiles.replace(/\,/g,''));
		var totalMilesAmount = (carrierRatePerMileFloat*totalmilesCommaReject).toFixed(2);
		document.getElementById('CarrierMiles').value = "$"+convertDollarNumberFormat(totalMilesAmount);
		document.getElementById('CarrierMilesTotalAmount').value = "$"+convertDollarNumberFormat(totalMilesAmount);
		updateTotalAndProfitFields();
	}
}

function addressChanged(stopid, callFrom) {
	/*miles calculation start*/
	var directionDisplayLoad;
    var directionsServiceLoad= new google.maps.DirectionsService();
	var stop1Shipper=$('#shipperlocation').val();
	var stop1Consignee=$('#consigneelocation').val();
	var consigneeAddress="";
	var shipperAddress="";
	var endPoint="";
	var startPoint="";
	var midPoint="";
	var distanceTotal=0;
	if(stopid == '') {
		if (stop1Shipper !="" && stop1Consignee !="") {
			shipperAddress = stop1Shipper;
			shipperAddress += " " + trim(document.getElementById("shippercity").value);
			var e = document.getElementById("shipperstate");
			if(trim(e.options[e.selectedIndex].text) != "Select")
			shipperAddress += "," + trim(e.options[e.selectedIndex].text);
			consigneeAddress = stop1Consignee;
			consigneeAddress += " " + trim(document.getElementById("consigneecity").value);
			e = document.getElementById("consigneestate");
			if(trim(e.options[e.selectedIndex].text) != "Select")
				consigneeAddress += "," + trim(e.options[e.selectedIndex].text);
			startPoint=shipperAddress;
			endPoint=consigneeAddress;
			
		} else if(stop1Shipper =="" || stop1Consignee =="") {
			shipperAddress =trim(document.getElementById("shippercity").value);
			var e = document.getElementById("shipperstate");
			if(trim(e.options[e.selectedIndex].text) != "Select")
			shipperAddress += "," + trim(e.options[e.selectedIndex].text);
			consigneeAddress = trim(document.getElementById("consigneecity").value);
			e = document.getElementById("consigneestate");
			if(trim(e.options[e.selectedIndex].text) != "Select")
				consigneeAddress += "," + trim(e.options[e.selectedIndex].text);
			startPoint=shipperAddress;
			endPoint=consigneeAddress;
		} else {
			$('#milse').val(0);
		}
		var constate = document.getElementById("consigneestate");
		var	constateValue='';
		if((constate.options[constate.selectedIndex].text) != "Select")
			constateValue =(constate.options[constate.selectedIndex].text);
		if((trim(document.getElementById("consigneelocation").value) == "") && ((document.getElementById("consigneecity").value) == "") && ((constateValue == "")))  {
			return;
		}
	}

	if(stopid != '') {
		startPoint="";
		endPoint="";
		shipperAddress="";
		consigneeAddress="";
		var prevStopId = stopid-1;
		if(prevStopId == 1){prevStopId=""}
		
		var shipperAddressPrev = trim(document.getElementById("shipperlocation"+prevStopId).value);
		if (shipperAddressPrev =="") {
			shipperAddressPrev = trim(document.getElementById("shippercity"+prevStopId).value);
		} else {
			shipperAddressPrev += " " + trim(document.getElementById("shippercity"+prevStopId).value);
		}
		var e = document.getElementById("shipperstate"+prevStopId);
		if(trim(e.options[e.selectedIndex].text) != "Select")
			shipperAddressPrev += "," + trim(e.options[e.selectedIndex].text);

		var consigneeAddressPrev = document.getElementById("consigneelocation"+prevStopId).value;
		if(consigneeAddressPrev =="") {
			consigneeAddressPrev =trim(document.getElementById("consigneecity"+prevStopId).value);
		} else {
			consigneeAddressPrev += " " + trim(document.getElementById("consigneecity"+prevStopId).value);
		}
		e = document.getElementById("consigneestate"+prevStopId);
		if(trim(e.options[e.selectedIndex].text) != "Select")
			consigneeAddressPrev += "," + trim(e.options[e.selectedIndex].text);
		shipperAddress = trim(document.getElementById("shipperlocation"+stopid).value);
		if(shipperAddress =="") {
			shipperAddress = trim(document.getElementById("shippercity"+stopid).value);
		} else {
			shipperAddress += " " + trim(document.getElementById("shippercity"+stopid).value);
		}
		var e = document.getElementById("shipperstate"+stopid);
		if(trim(e.options[e.selectedIndex].text) != "Select")
			shipperAddress += "," + trim(e.options[e.selectedIndex].text);
		
		consigneeAddress = document.getElementById("consigneelocation"+stopid).value;
		if(consigneeAddress =="") {
			consigneeAddress =trim(document.getElementById("consigneecity"+stopid).value);
		} else {
			consigneeAddress += " " + trim(document.getElementById("consigneecity"+stopid).value);
		}
		
		e = document.getElementById("consigneestate"+stopid);
		if(trim(e.options[e.selectedIndex].text) != "Select")
			consigneeAddress += "," + trim(e.options[e.selectedIndex].text);
		var shipperAddressCurrentStop = $('#shipperlocation'+stopid).val();
		var shipperStateCurrentStop = $('#shipperstate'+stopid).val();
		var shipperCityCurrentStop = $('#shippercity'+stopid).val();
		var consigneeAddressCurrentStop = $('#consigneelocation'+stopid).val();
		var shipperCustomer = $('#shipper'+stopid).val();
		var consigneeCustomer = $('#consignee'+stopid).val();
		var consigneecitycheck = $('#consigneecity'+stopid).val();
		var consigneestateCheck = $('#consigneestate'+stopid).val();
		var shipperAddressPrevStop = $('#shipperlocation'+prevStopId).val();
		var shipperCityPrevStop = $('#shippercity'+prevStopId).val();
		var shipperStatePrevStop = $('#shipperstate'+prevStopId).val();
		var consigneeAddressPrevStop = $('#consigneelocation'+prevStopId).val();
		var consigneeCityPrevStop = $('#consigneecity'+prevStopId).val();
		var consigneeStatePrevStop = $('#consigneestate'+prevStopId).val();
		if(consigneeAddressPrevStop != "" || consigneeCityPrevStop !="" ||consigneeStatePrevStop !="") {
			startPoint=consigneeAddressPrev;
		} else {
			if(shipperAddressPrevStop != "" ||shipperCityPrevStop !="" ||shipperStatePrevStop !="") {
				startPoint=shipperAddressPrev;
			} else {
				if(stopid ==2){
					var previousStopidVal = document.getElementById("milse").value;
				} else {
					var previousStopid = stopid-1;
					var previousStopidVal = document.getElementById("milse"+previousStopid).value;
				}
				document.getElementById("milse"+stopid).value = previousStopidVal;
				if(trim(consigneeAddressCurrentStop) ==""|| (trim(consigneestateCheck)) =="" || (trim(consigneecitycheck)) ==""){
					return;
				}
			}
		}
		  
		if(trim(shipperAddressCurrentStop) != "" || trim(shipperStateCurrentStop) !="" || trim(shipperCityCurrentStop) !="" ){
			if(trim(consigneeAddressCurrentStop) !=""|| (trim(consigneestateCheck)) !="" || (trim(consigneecitycheck)) !=""){
				if (startPoint != "") {
					midPoint=shipperAddress;
				}
				else{	
					startPoint=shipperAddress;
				}
				endPoint=consigneeAddress;
			}else{
				endPoint=shipperAddress;
			}
		} else {
			if(trim(consigneeAddressCurrentStop) !="" || (trim(consigneestateCheck)) !="" || (trim(consigneecitycheck)) !=""){
				endPoint=consigneeAddress;
			}else{
				if(stopid ==2){
					var previousStopidVal = document.getElementById("milse").value;
				} else{
					var previousStopid = stopid-1;
					var previousStopidVal = document.getElementById("milse"+previousStopid).value;
				}
				document.getElementById("milse"+stopid).value = previousStopidVal;
				return;
			}
		}
	}

	if(midPoint != "") {
		var requestLoad = {
			origin: startPoint,
		    destination: endPoint,
		  	waypoints: [{ location: midPoint}
			], 
			provideRouteAlternatives: false,
			travelMode: google.maps.DirectionsTravelMode.DRIVING
		};
	} else {
		var requestLoad = {
			origin: startPoint,
		    destination: endPoint,
			provideRouteAlternatives: false,
			travelMode: google.maps.DirectionsTravelMode.DRIVING
		};
	}
		directionsServiceLoad.route(requestLoad, function(response, status) {
			if(document.getElementById("milesUpdateMode"+stopid) != null && document.getElementById("milesUpdateMode"+stopid).value != "auto" && callFrom != "callFromRefreshButton"){
				return;
			}		
			if (status == "OK"){
				var totalDistance = 0;
				var totalDuration = 0;
				var legs = response.routes[0].legs;
				for(var i=0; i<legs.length; ++i) {
					totalDistance += legs[i].distance.value;
					totalDuration += legs[i].duration.value;
				}
				var METERS_TO_MILES = 0.000621371192;
				distanceTotal+=(Math.round( totalDistance * METERS_TO_MILES * 10 ) / 10);
			}	
			else{
				if(stopid==""){
					alert("System cannot calculate the miles for Stop1 because the address is not recognised");
				}else{
					alert("System cannot calculate the miles for Stop"+stopid+" because the address is not recognised");
				}	
			}	
			if(isNaN(distanceTotal)){	
				distance = 0;
			 }
			if(document.getElementById("milse"+stopid) != null)
			{
			  document.getElementById("milse"+stopid).value = distanceTotal;
			  document.getElementById("milse"+stopid).onchange();
			}
			if(document.getElementById('calculatedMiles') != null){
				document.getElementById('calculatedMiles').value = distanceTotal;
				document.getElementById('calculatedMiles').onchange();
			}
		});
	//	shipperAddress = prepareAddressForGoogleApi(shipperAddress);
	//	consigneeAddress = prepareAddressForGoogleApi(consigneeAddress);
	//matrixInit(shipperAddress,consigneeAddress,stopid, callFrom);
}

function prepareAddressForGoogleApi(str){
	var strToRet=str;
	strToRet = strToRet.replace(/, /g,'+');
	strToRet = strToRet.replace(/,/g,'+');
	strToRet = strToRet.replace(/ /g,'+');
	strToRet = strToRet.replace(/\n/g,'+');
	return strToRet;
}

function calculateDist(addressField1, addressField2) {
	var add1 = document.getElementById(addressField1).value;
	add1 = trim(add1);
	//if(add1 == "")
	//	return;
	var e = document.getElementById("Consigneestate");
	
	var conCity = trim(document.getElementById("ConsigneeCity").value);
	var conState = trim(e.options[e.selectedIndex].text);
	var conZip = trim(document.getElementById("ConsigneeZip").value);
	
	add1 += "+" + conCity;
	
	if(conState != "Select")
		add1 += "+" + conState;
	add1 += "+" + conZip;
	
	add1 = prepareAddressForGoogleApi(add1);
	
	var add2 = document.getElementById(addressField2).value;
	add2 = trim(add2);
	e = document.getElementById("Shipperstate");
	var shipperCity = trim(document.getElementById("ShipperCity").value);
	var shipperState = trim(e.options[e.selectedIndex].text);
	var shipperZip = trim(document.getElementById("ShipperZip").value);
	
	add2 += "+" + shipperCity;
	
	if(shipperState != "Select")
		add2 += "+" + shipperState;
	add2 += "+" + shipperZip;
	
	if ( ((shipperCity != '' && shipperState != "Select") || (shipperZip != '')) && ((conCity != '' && conState != "Select") || (conZip != ''))){
		// Continue with calculation
	}
	else
		return;
	
	add2 = prepareAddressForGoogleApi(add2);
	
	matrixInit(add1, add2, '', '');
}


function getCutomerForm(custID,aDsn,urltoken) {
    var path = urlComponentPath+"loadgateway.cfc";
	$.get(path,
      	{
	        method: "getAjaxLoadCustomerInfo1",
	        dataType: "html",
	        argumentCollection: JSON.stringify( {
	            dsn: aDsn,
	            customerID: custID,
	            urlToken: urltoken
	        })
      	},
  	function (data) {
       document.getElementById('CustInfo1').innerHTML = data;
    });

  	$.get(path,
  		{
    		method: "getAjaxLoadCustomerInfo2",
    		dataType: "html",
    		argumentCollection: JSON.stringify( {
        		dsn: aDsn,
        		customerID: custID
      		})
  		},
  	function (data) {
   		document.getElementById('CustInfo2').innerHTML = data;
		var loaddisabledStatus=$("#loaddisabledStatus").val();
		if (loaddisabledStatus == 'false'){
			$('#load input[name="save"]').removeAttr('disabled');
			$('#load input[name="submit"]').removeAttr('disabled');
			$('#load input[name="saveexit"]').removeAttr('disabled');
		}
  	});
  
}

function getAjaxLoadCustomerInfo1Handler(response){
	document.getElementById('CustInfo1').innerHTML = response;
}

function getAjaxLoadCustomerInfo2Handler(response) {
	document.getElementById('CustInfo2').innerHTML = response;
	if (loaddisabledStatus == 'false'){
		$('#load input[name="save"]').removeAttr('disabled');
		$('#load input[name="submit"]').removeAttr('disabled');
		$('#load input[name="saveexit"]').removeAttr('disabled');
	}	
}

function tablePrevPage(formName){
	if(parseInt(document.getElementById('pageNo').value)>1) {
		document.getElementById('pageNo').value = parseInt(document.getElementById('pageNo').value)-1;
		$('#'+formName).submit();
	}
}

function refreshMilesClicked(stopid) {
	addressChanged(stopid,"callFromRefreshButton");
}


function getCommissionReport(URLToken, action,dsn,customerStatus,pageBreakStatus,ShowSummaryStatus,ShowProfit){
	var url = "";
	var datetype = $("input[name='datetype']:checked").val();
	var freightBrokerValues=$("#freightBroker").val();
	if( document.getElementById('none').checked ) {
		var groupBy='none';
	} else if( document.getElementById('salesAgent').checked ) {
		if(freightBrokerValues =='Driver'){
			var groupBy='userDefinedFieldTrucking';
		}else{
			var groupBy='salesAgent';
		}
	} else if ( document.getElementById('dispatcher').checked ) {
		var groupBy='dispatcher';
	}else if ( document.getElementById('customer').checked ) {
		var groupBy='CustName';	
	} else if ( document.getElementById('Carrier') != null && document.getElementById('Carrier').checked ) {
		var groupBy='Carrier';
	} else if ( document.getElementById('Driver') != null && document.getElementById('Driver').checked ) {
		var groupBy='Driver';
	}
	url += "groupBy="+groupBy;
	if(datetype=='Shipdate') {
		url += "&orderDateFrom="+document.getElementById('dateFrom').value;
		url += "&orderDateTo="+document.getElementById('dateTo').value;
	} 
	if(datetype=='Invoicedate') {
		url += "&billDateFrom="+document.getElementById('dateFrom').value;
		url += "&billDateTo="+document.getElementById('dateTo').value;	
	}
	url += "&deductionPercentage="+getFloat(document.getElementById('deductionPercent').value);
	url += "&commissionPercentage="+getFloat(document.getElementById('commissionPercent').value);
	var salesRepFrom='';
	var salesRepTo='';
	if(freightBrokerValues =='Driver') {
		salesRepFrom=$("#salesRepFrom").val();
		salesRepTo=$("#salesRepTo").val();
	} else {
		var s=document.getElementById("salesRepFrom");
		salesRepFrom=trim(s.options[s.selectedIndex].text);
		var t=document.getElementById("salesRepTo");
		salesRepTo=trim(t.options[t.selectedIndex].text);
	}
	var e = document.getElementById("salesRepFrom");
	url += "&salesRepFrom="+salesRepFrom;
	
	e = document.getElementById("salesRepTo");
	url += "&salesRepTo="+salesRepTo;
	
	e = document.getElementById("dispatcherFrom");
	url += "&dispatcherFrom="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("dispatcherTo");
	url += "&dispatcherTo="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("customerFrom");
	url += "&customerFrom="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("customerTo");
	url += "&customerTo="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("reportType");
	var type = trim(e.options[e.selectedIndex].text);
	url += "&reportType="+type;
	
	url += "&marginRangeFrom="+getFloat(document.getElementById('marginFrom').value);
	url += "&marginRangeTo="+getFloat(document.getElementById('marginTo').value);

	//Status Loads From To
	e = document.getElementById("StatusTo");
	url += "&StatusTo="+trim(e.options[e.selectedIndex].text);
	
	//Status Loads From To
	e = document.getElementById("StatusFrom");
	url += "&StatusFrom="+trim(e.options[e.selectedIndex].text);
	
	//customer From To
	e = document.getElementById("customerFrom");
	url += "&customerLimitFrom="+trim(e.options[e.selectedIndex].text);
	
	//customer From To
	e = document.getElementById("customerTo");
	url += "&customerLimitTo="+trim(e.options[e.selectedIndex].text);
	
	//equipment From To
	e = document.getElementById("equipmentFrom");
	url += "&equipmentFrom="+trim(e.options[e.selectedIndex].text);
	
	//equipment From To
	e = document.getElementById("equipmentTo");
	url += "&equipmentTo="+trim(e.options[e.selectedIndex].text);
	
	//salesRep From and To Id's
	e = document.getElementById("salesRepFrom");
	url += "&salesRepFromId="+trim(e.value);
	
	e = document.getElementById("salesRepTo");
	url += "&salesRepToId="+trim(e.value);
	
	//dispatcherRep From and To Id's
	e = document.getElementById("dispatcherFrom");
	url += "&dispatcherFromId="+trim(e.value);
	
	e = document.getElementById("dispatcherTo");
	url += "&dispatcherToId="+trim(e.value);

	e = document.getElementById("freightBroker");
	url += "&freightBroker="+trim(e.value);
	
	url = url.replace(/####/g,'AAAA');
	if(action == 'view')
	{
		window.open('../reports/loadCommissionReport.cfm?'+url+'&dsn='+dsn+'&customerStatus='+customerStatus+'&pageBreakStatus='+pageBreakStatus+'&ShowSummaryStatus='+ShowSummaryStatus+'&ShowProfit='+ShowProfit+'&datetype='+datetype+'&'+URLToken);
	}
	else if(action == 'mail')
	{
		newwindow=window.open('index.cfm?event=loadMail&type='+type+'&'+url+'&dsn='+dsn+'&customerStatus='+customerStatus+'&pageBreakStatus='+pageBreakStatus+'&ShowSummaryStatus='+ShowSummaryStatus+'&ShowProfit='+ShowProfit+'&datetype='+datetype+'&'+URLToken+'','Map','height=400,width=750');
		if (window.focus) {newwindow.focus()}
	}
}

function getAndUpdateLongShortMilesFields(dsn) {
	var arrLongShorMiles = getLongShortMiles(dsn);
	document.getElementById('longMiles').value = arrLongShorMiles[0];
	document.getElementById('shortMiles').value = arrLongShorMiles[1];
}

function phoneFormatValid(val) {
	var phoneText = val;
	phoneText = phoneText.toString().replace(/,/g, "");
	phoneText = phoneText.replace(/-/g, "");
	phoneText = phoneText.replace(/\(/g, "");
	phoneText = phoneText.replace(/\)/g, "");
	phoneText = phoneText.replace(/ /g, "");
	if(!isNaN(phoneText.substring(0,10)) & phoneText.substring(0,10).length==10) {
		var part1 = phoneText.substring(0,6);
		part1 = part1.replace(/(\S{3})/g, "$1-");
		var part2 = phoneText.substring(6,10);
		var ext = phoneText.substring(10);
		var phoneField = part1 + part2 + " " + ext;
	}
	else if(phoneText.substring(0,10).length!=0){alert('Invalid Phone Number!')}
}

$( "body" ).on( "change", ".phoneFormatValid",function() {
	var phoneText = $(this).val();
	phoneText.replace(/,/g,'');
	console.log(phoneText);
});

function getLongShortMiles(dsn) {
    var path = urlComponentPath+"loadgateway.cfc?method=getLongShortMiles";
    var arrLongShortMiles = "";
    $.ajax({
        type: "get",
		url: path,		
        dataType: "json",
        async: false,
        data: {
            dsn: dsn
          },
        success: function(data){
          arrLongShortMiles = data;
        }
      });
    return arrLongShortMiles;
}

function saveSystemSetupOptions(dsn) {
	var longMiles = getFloat(document.getElementById('longMiles').value);
	var shortMiles = getFloat(document.getElementById('shortMiles').value);
	var deductionPercentage = getFloat(document.getElementById('deductionPercentage').value);
	var ARAndAPExportStatusID = trim(document.getElementById('loadStatus').value);
	var showExpCarriers = document.getElementById('showExpCarriers').checked;
	
	if(runSaveSystemSetupOptions(dsn, longMiles, shortMiles, deductionPercentage, ARAndAPExportStatusID,showExpCarriers) >= 1)
	{
		document.getElementById('message').innerHTML = 'Information saved successfully';
		document.getElementById('message').style.display = 'block';
	}
	else
	{
		document.getElementById('message').innerHTML = 'unknown <b>Error</b> occured while saving';
		document.getElementById('message').style.display = 'block';
	}
}

function runSaveSystemSetupOptions(dsn, longMiles, shortMiles, deductionPercentage, ARAndAPExportStatusID,showExpCarriers) {
	var loadCustomer = new ajaxLoadCutomer();
	var recordsEffetced = loadCustomer.setSystemSetupOptions(dsn, longMiles, shortMiles, deductionPercentage, ARAndAPExportStatusID,showExpCarriers);
	return parseFloat(recordsEffetced);
}

function EnableDisableForm(xForm,flag) {
	objElems = xForm.elements;
	for(i=0;i<objElems.length;i++){
		objElems[i].disabled = flag;
	}
}

function tableNextPage(formName) {
	if(document.getElementById('message') == null || (document.getElementById('message') != null && document.getElementById('message').innerHTML != "No match found")) {
		document.getElementById('pageNo').value = parseInt(document.getElementById('pageNo').value)+1;
		$('#'+formName).submit();
	}
	if(formName == 'dispLoadForm' && document.getElementById('message').style.display != 'block') {
		document.getElementById('pageNo').value = parseInt(document.getElementById('pageNo').value)+1;
		$('#'+formName).submit();
	}
}

function showErrorMessage(flag) {
	document.getElementById('message').style.display = flag;
}

function clearPreviousSearchHiddenFields() {
	document.getElementById('pageNo').value=1;
	document.getElementById('LoadStatus').value="";
	document.getElementById('LoadNumber').value="";
	document.getElementById('Office').value="";
	document.getElementById('ShipperState').value="";
	document.getElementById('ConsigneeState').value="";
	document.getElementById('CustomerName').value="";
	document.getElementById('StartDate').value="";
	document.getElementById('EndDate').value="";
	document.getElementById('CarrierName').value="";
	document.getElementById('CustomerPO').value="";
	document.getElementById('weekMonth').value="";
}

function sortTableBy(fieldName, formName) { 
	if(document.getElementById('sortBy').value == fieldName) {
		if(document.getElementById('sortOrder').value == "ASC")
			document.getElementById('sortOrder').value = "DESC"
		else if(document.getElementById('sortOrder').value == "DESC")
			document.getElementById('sortOrder').value = "ASC"
	}
	document.getElementById('sortBy').value = fieldName;
	$('#'+formName).submit();
}

function showWarningEnableButton(flagWarning, stopid) {
	document.getElementById('milesUpdateMode'+stopid).value = "manual";
	document.getElementById('warning'+stopid).style.display =flagWarning;
	if(flagWarning == "block"){
		//document.getElementById('refreshBtn'+stopid).disabled = false;
	}
}

// Get customer Sales Persion and Dispatcher.
function getCutomerSalesPerson(custID,aDsn) {
	var loadCustomer = new ajaxLoadCutomer();	
	var newCustomerSalesPerson_dispatacher = loadCustomer.getAjaxLoadSalesperson_Dispatcher(aDsn,custID);
	if (newCustomerSalesPerson_dispatacher[0] == '') {
		alert('Sale Person is Inactive');
		document.getElementById('slsP').style.display ='block';
		document.getElementById('slsP').innerHTML ='Sales Person is Inactive';
	}	
	document.getElementById('Salesperson').value = newCustomerSalesPerson_dispatacher[0];
	document.getElementById('Dispatcher').value = newCustomerSalesPerson_dispatacher[1];
}

// Get Shipper Info using Coldfusion AJAX
function getShipperForm(shipperID,aDsn) {
	var loadShipper = new ajaxLoadCutomer();	
	var newShipperFrm = loadShipper.getAjaxLoadShipperInfo(aDsn,shipperID);
	document.getElementById('ShipperName').value = newShipperFrm[0];
	document.getElementById('shipperlocation').value = newShipperFrm[1];
	document.getElementById('shippercity').value = newShipperFrm[2];
	document.getElementById('shipperstate').value = newShipperFrm[3];
	document.getElementById('shipperZipcode').value = newShipperFrm[4];
	document.getElementById('shipperContactPerson').value = newShipperFrm[5];
	document.getElementById('shipperPhone').value = newShipperFrm[6];
	document.getElementById('shipperFax').value = newShipperFrm[7];
	document.getElementById('shipperEmail').value = newShipperFrm[8];	
}

function getShipperFormNext(shipperID,aDsn,stopid) {
	var loadShipper = new ajaxLoadCutomer();	
	var newShipperFrm = loadShipper.getAjaxLoadShipperInfo(aDsn,shipperID);
	document.getElementById('ShipperName'+stopid).value = newShipperFrm[0];
	document.getElementById('shipperlocation'+stopid).value = newShipperFrm[1];
	document.getElementById('shippercity'+stopid).value = newShipperFrm[2];
	document.getElementById('shipperstate'+stopid).value = newShipperFrm[3];
	document.getElementById('shipperZipcode'+stopid).value = newShipperFrm[4];
	document.getElementById('shipperContactPerson'+stopid).value = newShipperFrm[5];
	document.getElementById('shipperPhone'+stopid).value = newShipperFrm[6];
	document.getElementById('shipperFax'+stopid).value = newShipperFrm[7];
	document.getElementById('shipperEmail'+stopid).value = newShipperFrm[8];	
}

// Get Consignee Info using Coldfusion AJAX
function getConsigneeForm(consigneeID,aDsn,frm) {
	var loadConsignee = new ajaxLoadCutomer();	
	var newConsigneeFrm = loadConsignee.getAjaxLoadConsigneeInfo(aDsn,consigneeID);
	document.getElementById('consigneeName').value = newConsigneeFrm[0];
	document.getElementById('consigneelocation').value = newConsigneeFrm[1];
	document.getElementById('consigneecity').value = newConsigneeFrm[2];
	document.getElementById('consigneestate').value = newConsigneeFrm[3];
	document.getElementById('consigneeZipcode').value = newConsigneeFrm[4];
	document.getElementById('consigneeContactPerson').value = newConsigneeFrm[5];
	document.getElementById('consigneePhone').value = newConsigneeFrm[6];
	document.getElementById('consigneeFax').value = newConsigneeFrm[7];
	document.getElementById('consigneeEmail').value = newConsigneeFrm[8];
	getLongitudeLatitude(frm);
	ClaculateDistance(frm);
}

function getConsigneeFormNext(consigneeID,aDsn,stopid) {
	var loadConsignee = new ajaxLoadCutomer();	
	var newConsigneeFrm = loadConsignee.getAjaxLoadConsigneeInfo(aDsn,consigneeID);
	document.getElementById('consigneeName'+stopid).value = newConsigneeFrm[0];
	document.getElementById('consigneelocation'+stopid).value = newConsigneeFrm[1];
	document.getElementById('consigneecity'+stopid).value = newConsigneeFrm[2];
	document.getElementById('consigneestate'+stopid).value = newConsigneeFrm[3];
	document.getElementById('consigneeZipcode'+stopid).value = newConsigneeFrm[4];
	document.getElementById('consigneeContactPerson'+stopid).value = newConsigneeFrm[5];
	document.getElementById('consigneePhone'+stopid).value = newConsigneeFrm[6];
	document.getElementById('consigneeFax'+stopid).value = newConsigneeFrm[7];
	document.getElementById('consigneeEmail'+stopid).value = newConsigneeFrm[8];
}

// Get Carrier List Info using Coldfusion AJAX
function getFilterCarrierByString(aDsn,stopid) {
	var filterString = document.getElementById('selectedCarrierValue'+stopid).value;
	var loadFilterCarrier = new ajaxLoadCutomer();
	var newFilterList = loadFilterCarrier.getAjaxCarrierlistByString(aDsn,filterString);
	document.getElementById('carrierList'+stopid).innerHTML = newFilterList;
}

// Get Carrier List Info using Coldfusion AJAX
function getFilterCarrier(filterChar,aDsn) {
	var loadFilterCarrier = new ajaxLoadCutomer();	
	var newFilterList = loadFilterCarrier.getAjaxCarrierlist(aDsn,filterChar);
	document.getElementById('carrierList').innerHTML = newFilterList;
}

function getFilterCarrierNext(filterChar,aDsn,stopid) {
	var loadFilterCarrier = new ajaxLoadCutomer();	
	var newFilterList = loadFilterCarrier.getAjaxCarrierlistNext(aDsn,filterChar,stopid);
	document.getElementById('carrierList'+stopid).innerHTML = newFilterList;
}

// Open Choose carrier
function chooseCarrier() {
	document.getElementById("selectedCarrierValue").value = '';
	document.getElementById("CarrierInfo").style.display = 'none';
	document.getElementById('choosCarrier').style.display = 'block';
	document.getElementById('carrier_id').value = "";
	document.getElementById('carrierID').value = "";
}


// Removes leading whitespaces
function LTrim( value ) {	
	var re = /\s*((\S+\s*)*)/;
	return value.replace(re, "$1");
}

// Removes ending whitespaces
function RTrim( value ) {
	var re = /((\s*\S+)*)\s*/;
	return value.replace(re, "$1");
}

// Removes leading and ending whitespaces
function trim( value ) {
	return LTrim(RTrim(value));
}


function chooseCarrierNext(stopid) {
	document.getElementById("selectedCarrierValue"+stopid).value = '';
	document.getElementById("CarrierInfo"+stopid).style.display = 'none';
	document.getElementById('choosCarrier'+stopid).style.display = 'block';
	document.getElementById('carrier_id'+stopid).value = "";
	document.getElementById('carrierID'+stopid).value = "";	
}

// Go for edit carrier
function editCarrier(url) {
	var carrId = document.getElementById("carrierID").value; 
	if (carrId == '') {
		alert('Please select a carrier');
		return false;	
	} else {
		location.href=url + '&carrierid=' + carrId; 
	}
}

function editCarrierNext(url,stopid) {
	var carrId = document.getElementById("carrierID"+stopid).value; 
	if (carrId == '') {
		alert('Please select a carrier');
		return false;	
	} else {
		location.href=url + '&carrierid=' + carrId; 
	}
}

function useCarrier(aDsn,lFlag,urltoken) {
	var carrId = document.getElementById("carrierID").value; 
	if (carrId == '') {
		if (lFlag == 1) {
			alert('Please select a carrier');
			return false;
		}	
	} else {
		document.getElementById("CarrierInfo").style.display = 'block';
		document.getElementById('choosCarrier').style.display = 'none';
		var loadCarrierInfo = new ajaxLoadCutomer();	
		loadCarrierInfo.setCallbackHandler(getAjaxCarrierInfoFormHandler); 
		var newCarrierFrm = loadCarrierInfo.getAjaxCarrierInfoForm(aDsn,carrId,urltoken);
	}
}

function getAjaxCarrierInfoFormHandler(newCarrierFrm) {
	document.getElementById('CarrierInfo').innerHTML = newCarrierFrm;
}

function useCarrierNext(aDsn,lFlag,stopid,urltoken) {
	var carrId = document.getElementById("carrierID"+stopid).value; 
	var stopID_temp = stopid;
	if (carrId == '') {
		if (lFlag == 1) {
			alert('Please select a carrier');
			return false;
		}	
	} else {
		document.getElementById("CarrierInfo"+stopid).style.display = 'block';
		document.getElementById('choosCarrier'+stopid).style.display = 'none';
        var path = urlComponentPath+"loadgateway.cfc?method=getAjaxCarrierInfoFormNext";
        var newCarrierFrm = "";
        $.ajax({
            type: "get",
            url: path,		
            dataType: "json",
            data: {
                dsn: aDsn,
                carrierId: carrId,
                stopNo: stopid,
                urltoken: urltoken
              },
            success: function(data){
              getAjaxCarrierInfoFormNextHandler(data)
            }
        });
	}
}

function getAjaxCarrierInfoFormNextHandler(response) {
	newCarrierFrm = response;
	var stopid = newCarrierFrm.DATA[0][0];
	var newCarrierFrm = newCarrierFrm.DATA[0][1];
	document.getElementById('CarrierInfo'+stopid).innerHTML = newCarrierFrm;
}

function noCarrier() {
	document.getElementById("carrierID").value=''; 
	document.getElementById("selectedCarrierValue").value = '';	
	document.getElementById("CarrierInfo").style.display = 'none';
	document.getElementById('choosCarrier').style.display = 'block';
	var k;
	for(k=document.getElementById("stOffice").options.length-1;k>=0;k--)
	{
		document.getElementById("stOffice").remove(k);
	}
	
	var optn = document.createElement("OPTION");
	optn.text = 'Choose a Satellite Office Contact';
	optn.value = '';
	document.getElementById("stOffice").options.add(optn);
}

function noCarrierNext(stopNo) {
	document.getElementById("carrierID"+stopNo).value=''; 
	document.getElementById("selectedCarrierValue"+stopNo).value = '';	
	document.getElementById("CarrierInfo"+stopNo).style.display = 'none';
	document.getElementById('choosCarrier'+stopNo).style.display = 'block';
	var k;
	for(k=document.getElementById("stOffice"+stopNo).options.length-1;k>=0;k--)
	{
		document.getElementById("stOffice"+stopNo).remove(k);
	}
	
	var optn = document.createElement("OPTION");
	optn.text = 'Choose a Satellite Office Contact';
	optn.value = '';
	document.getElementById("stOffice"+stopNo).options.add(optn);
}
//check for free unit

function checkForFee(unitId,itemRowNo,stopNo,aDsn) {
	var isfree = false;
    var path = urlComponentPath+"loadgateway.cfc?method=checkAjaxFeeUnit";
    $.ajax({
        type: "get",
        url: path,		
        dataType: "json",
        async: false,
        data: {
            dsn: aDsn,
            unitId: unitId
          },
        success: function(data){
          retValue = data;
        }
    }); 
  
	var fsctext = "milse";
	isfree = retValue[0];
	carrier_id=$('#carrier_id'+stopNo).val();
	frmfld = document.getElementById('isFee'+itemRowNo+''+stopNo);
	try {
		if (isfree == 'true')
			frmfld.checked = true;
		else
			frmfld.checked = false;
			
		document.getElementById('description'+itemRowNo+''+stopNo).value = retValue[1];
		document.getElementById('CustomerRate'+itemRowNo+''+stopNo).value = '$'+retValue[2];
		document.getElementById('CarrierRate'+itemRowNo+''+stopNo).value = '$'+retValue[3];
		
		try {
			var index = document.getElementById('type'+itemRowNo+''+stopNo).selectedIndex;
			var unittype = document.getElementById('type'+itemRowNo+''+stopNo).options[index].text;
			if(carrier_id.length){
				getCarrierCommodityValue(carrier_id,"type",stopNo);
			}
		}
		catch(e) {
			var index = document.getElementById('unit'+itemRowNo+''+stopNo).selectedIndex;
			var unittype = document.getElementById('unit'+itemRowNo+''+stopNo).options[index].text;
			if(carrier_id.length){
				getCarrierCommodityValue(carrier_id,"unit",stopNo);
			}
		}
		if(unittype.indexOf("FSC Mxxx") > -1) {
			if(stopNo>1){
				 fsctext = "milse"+stopNo;	
			}
			document.getElementById('qty'+itemRowNo+''+stopNo).value = document.getElementById(fsctext).value;
		}	
	}
	catch(e) {
		console.log(e);
	}
	CalculateTotal(aDsn);
}

function DisplayIntextField(fldVal,dsn) {
	var path = urlComponentPath+"loadgateway.cfc?method=getAjaxSatelliteOfficeBindable";
    var newCarrierOffice = "";
  
    $.ajax({
        type: "get",
        url: path,		
        dataType: "json",
        async: false,
        data: {
            carrierid: fldVal,
            dsn: dsn
          },
        success: function(data){
          newCarrierOffice = data;
        }
    });
  
	var k;
	for(k=document.getElementById("stOffice").options.length-1;k>=0;k--) {
		document.getElementById("stOffice").remove(k);
	}
	
	for (var j=0;j<newCarrierOffice.length;j++) {
		var optn = document.createElement("OPTION");
		optn.text = newCarrierOffice[j][1];
		optn.value = newCarrierOffice[j][0];
		document.getElementById("stOffice").options.add(optn);
	}
	document.getElementById("carrierID").value = fldVal;
}

function DisplayIntextFieldNext(fldVal,stopid,dsn) {
	document.getElementById("carrierID"+stopid).value = fldVal;
    var path = urlComponentPath+"loadgateway.cfc?method=getAjaxSatelliteOfficeBindable";
    var newCarrierOffice = "";
  
    $.ajax({
        type: "get",
        url: path,		
        dataType: "json",
        async: false,
        data: {
            carrierid: fldVal,
            dsn: dsn
          },
        success: function(data){
          newCarrierOffice = data;
        }
    });
  
	var k;
	for(k=document.getElementById("stOffice"+stopid).options.length-1;k>=0;k--)	{
		document.getElementById("stOffice"+stopid).remove(k);
	}
	
	for(var j=0;j<newCarrierOffice.length;j++)	{
		var optn = document.createElement("OPTION");
		optn.text = newCarrierOffice[j][1];
		optn.value = newCarrierOffice[j][0];
		document.getElementById("stOffice"+stopid).options.add(optn);
	}
}

//ajax function to load all the tabs that are not needed and are to be made invisble(helps the page to be faster)
function ajaxloadNextStops(loadid, totStops, LoadNumber, currentTab) {
	if(LoadNumber == "novalue")	{
		LoadNumber = '';
	}
	$.ajax({
        type: "get",
        url: "index.cfm?event=nextStopLoad&loadid="+loadid+"&LoadNumber="+LoadNumber+"&totStops="+totStops+"&currentTab="+currentTab,		 dataType: "html",
        success: function(response){
			//append all the tabs to the form(id - load)
			$( "#load" ).append(response);
			
			//initialise all the tabs again
			$( ".tabsload" ).tabs({
				beforeLoad: function( event, ui ) {
					ui.jqXHR.error(function() {
						ui.panel.html(
							"Couldn't load this tab. We'll try to fix this as soon as possible. " +
							"If this wouldn't be a demo." 
						);
					});
				}
			});
			
			//initialise all the datepickers again for the new tabs
			$( ".datefield" ).datepicker({ 
              dateFormat: "mm/dd/yy",
              showOn: "button",
              buttonImage: "images/DateChooser.png",
              buttonImageOnly: true
            });
			
			//remove the disabled attributes of the input fields of the newly loaded tabs
			if($.trim($('#load input[name="loadnumber"]').val()).length == 0){
				var loaddisabledStatus=$("#loaddisabledStatus").val();
				if (loaddisabledStatus == 'false'){
					$('#load input[name="save"]').removeAttr('disabled');
					$('#load input[name="submit"]').removeAttr('disabled');
					$('#load input[name="saveexit"]').removeAttr('disabled');
					$('#load input[name="addstopButton"]').removeAttr('disabled');
				}	
			}
        }
    });
}

function AddStop(stopName,stopid) {
	var editid=$("#editid").val();
	if(editid !=0){
		var Totalcount=$('#totalResult'+stopid).val();
		for(i=2;i<=Totalcount;i++){
			$('#commodities'+stopid+'_'+i).remove();
		}
		$('#TotalrowCommodities'+stopid).val(1);
		$('#totalResult'+stopid).val(1);
		$('#commoditityAlreadyCount'+stopid).val(1);
		
		$('#isFee'+stopid+'_1').prop('checked',false);
		$('#unit'+stopid+'_1 option[value=""]').attr("selected", "selected");
		$('#class'+stopid+'_1 option[value=""]').attr("selected", "selected");
		$('#description'+stopid+'_1').val('');
		$('#weight'+stopid+'_1').val(0);
		$('#CustomerRate'+stopid+'_1').val('$0.00');
		$('#CarrierRate'+stopid+'_1').val('$0.00');
		$('#CarrierPer'+stopid+'_1').val('0.00%');
		$('#custCharges'+stopid+'_1').val('$0.00');
		$('#carrCharges'+stopid+'_1').val('$0.00');
	}
	document.getElementById(stopName).style.display='block';
	$('input[type=text]').addClass('myElements');
    $('input[type=checkbox]').addClass('myElements');
	$('input[type=datefield]').addClass('myElements');
    $('select').addClass('myElements');
    $('textarea').addClass('myElements');
	var prevStopId=stopid-1;
	if(prevStopId==1){prevStopId=""}
	$('#consigneeValueContainer'+stopid).val($('#consigneeValueContainer'+prevStopId).val());
	document.getElementById('shipperstate'+stopid).onchange();
	if(trim($('#shipperlocation'+prevStopId).val()) == "" ||  trim($('#consigneelocation'+prevStopId).val()) == "" ){
		document.getElementById("milse"+stopid).value = 0;
	}
	document.getElementById("milse").onchange();
	document.getElementById('totalStop').value=stopid;
	document.getElementById('shipper'+stopid).focus();
}

function deleteStop(stopName,stopNo,flag,stopID,aDsn,loadID) {
	var deleteYN=false;
	if(flag == true) {
 		deleteYN = confirm('Are you sure to delete this stop')
 		if (deleteYN) {
            var frieghtBroker=$('#frieghtBroker').val();                    
            var PostTo123LoadBoard=$('#PostTo123LoadBoard').val();                    
            var loadBoard123=$('#loadBoard123').val();                    
            var Is123LoadBoardPst=$('#Is123LoadBoardPst').val();                    
            var path = urlComponentPath+"loadgateway.cfc?method=ajaxDeleteStops";
            var  pathDeleteSingleLoad= urlComponentPath+"loadgateway.cfc?method=delete123LoadBoardWebserviceSeparate";
            var confirmDeleteStop = "";
			if (frieghtBroker==1 && PostTo123LoadBoard==1 && loadBoard123==1 && Is123LoadBoardPst==1){
				var username=$('#loadBoard123Username').val(); 	
				var password=$('#loadBoard123Password').val(); 	
				$.ajax({
					type: "get",
					url: pathDeleteSingleLoad,		
					dataType: "json",
					async: false,
					data: {
						   dsn: aDsn,
						loadStopId: stopID,
						username:username,
						password:password
					  },
					success: function(data){
					  
					}
				});		
			}

            $.ajax({
                type: "get",
                url: path,		
                dataType: "json",
                async: false,
                data: {
                    dsn: aDsn,
                    stopID: stopID,
                    stopNo: stopNo,
                    LoadID: loadID
                  },
                success: function(data){
					confirmDeleteStop = data.transaction;
					if(data.transaction)
					{
					    document.getElementById(stopName).style.display='none';
					    document.getElementById("milse").onchange();
						
					}
                }
            });							
 		}
	} else {
		document.getElementById(stopName).style.display='none';
		document.getElementById("milse").onchange();
	}
	 
	if(document.getElementById('totalStop').value==(stopNo+1)){
		document.getElementById('totalStop').value=(document.getElementById('totalStop').value-1)
	}
	strStopLinks = "";

	for(i=1;i<=document.getElementById('totalStop').value;i++) {
		if(i!=(stopNo+1))
			strStopLinks = strStopLinks+"<li><a href='#StopNo"+i+"'>#"+i+"</a></li>";
	}
	for(j=1;j<=document.getElementById('totalStop').value;j++) {
		if(document.getElementById('ulStopNo'+j))
			document.getElementById('ulStopNo'+j).innerHTML = strStopLinks;
	}
	//show add stop btn    
    var ary = [];
    var ary2 = []
    for(i=2;i<11;i++) {
        ($('#stop'+i).css('display')=="block" ? ary.push(i):ary2.push(i));
        $('#stop'+i+'h2').text('Stop '+i);
    }
    k = ary[ary.length-1]
    
    $('#stop'+k+' .green-btn[value="Add Stop"]').show();
    if(ary.length == 0){
        $('#tabs1 .green-btn[value="Add Stop"]').show();
    }
}



function CheckState(frmstate,frmcountry,frmroleid,frmoffice,frmtele) {
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
	var st=frmstate.value;
	if (st == "") {
		alert('Please select a state');
		frmstate.focus();
	 	return false;
	}
	var cnt=frmcountry.value;
	if (cnt == "") {
		alert('Please select a country');
		frmcountry.focus();
	 	return false;
	}
	var role =frmroleid.value;
	if (role == "")	{
		alert('Please select an authlevel');
		frmroleid.focus();
	 	return false;
	}
	var office = frmoffice.value;
	if (office == "") {
		alert('Please select an Office');
		frmoffice.focus();
	 	return false;
	}
	var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frmtele.value;
    LimitCheck = PhoneNumberInitialString.length;
   	if (PhoneNumberInitialString !='') {
      	var FmtStr=PhoneNumberInitialString;
      	if (FmtStr.length == 12) {      	
      		if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-")){
	        	FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
      		} else {
        		alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        		frmtele.focus();
        		return false;
        	}  
      	} else {
        	FmtStr=PhoneNumberInitialString;        
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frmtele.focus();
        	return false;
      	}
    	return true;
   	}
}

function CheckCustomer(frmoffice,frmstate,frmcountry,frmcompany,frmlocation) {
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
	var office=frmoffice.value;
	if (office == "") {
		alert('Please select an office');
		frmoffice.focus();
		return false;
	}
	var location=frmlocation.value;
	if(location=="") {
     alert('Please enter value in address field');
		frmlocation.focus();
		return false;
	}
	
	var state=frmstate.value;
	if(state=="") {
		alert('Please select a state');
		frmstate.focus();
		return false;
	}
	var country=frmcountry.value;
	if(country=="")	{
		alert('Please select a country');
		frmcountry.focus();
		return false;
	}
	var company=frmcompany.value;
	if(company=="")	{
		alert('Please select a company');
		frmcompany.focus();
		return false;
	}
}

function CheckStops(frmState,frmlocation) {
	var location=frmlocation.value;
	if(location=="") {
		alert('Please enter the address');
		frmlocation.focus();
		return false;
	}
	var state=frmState.value;
	if(state=="") {
		alert('Please select a state');
		frmState.focus();
		return false;
	}
}

function CheckCarrier(frmaddress,frmstate,frmcountry,frmequipment) {
	var address=frmaddress.value;
	if(address=="")	{
		alert('Please enter the address');
		frmaddress.focus();
		return false;
	}
	
	var state=frmstate.value;
	if(state=="") {
		alert('Please select a state');
		frmstate.focus();
		return false;
	}
	var country=frmcountry.value;
	if(country=="")	{
		alert('Please select a country');
		frmcountry.focus();
		return false;
	}
	var equipment=frmequipment.value;
	if(equipment=="") {
	    alert('Please select an equipment');
		frmequipment.focus();
		return false;	
	}
}

function CheckCarrier(frmaddress,frmstate,frmcountry,frmequipment) {
	var setSession = new ajaxLoadCutomer();
    var confirmSession = setSession.setSession(0);
	
	var address=frmaddress.value;
	if(address=="")	{
		alert('Please enter the address');
		frmaddress.focus();
		return false;
	}
	
	var state=frmstate.value;
	if(state=="") {
		alert('Please select a state');
		frmstate.focus();
		return false;
	}
	var country=frmcountry.value;
	if(country=="")	{
		alert('Please select a country');
		frmcountry.focus();
		return false;
	}
	var equipment=frmequipment.value;
	if(equipment=="") {
	    alert('Please select an equipment');
		frmequipment.focus();
		return false;	
	}
}
	
var loadExported = false;

function exportLoads(QBdsn, dsn, webpath, URLToken){
	if(loadExported == true) {
		document.getElementById('messageWarning').innerHTML = 'This data has already been exported. To export this data again please contact site adminitrator.';
		document.getElementById('messageWarning').style.display = 'block';
		
		document.getElementById('messageLoadsExportedForCustomer').style.display = 'none';
		document.getElementById('messageLoadsExportedForCarrier').style.display = 'none';
		document.getElementById('messageLoadsExportedForBoth').style.display = 'none';
		document.getElementById('exportLink').className = "exportbutton";
		
		return false;
	}

	var dateFrom = document.getElementById('orderDateFrom').value;
	var dateTo = document.getElementById('orderDateTo').value;		
	var ajxHandle = new ajaxLoadCutomer();	
	var ret = ajxHandle.exportAllLoads(QBdsn, dsn, dateFrom, dateTo);
	
	document.getElementById('messageLoadsExportedForCustomer').style.display = 'block';
	document.getElementById('messageLoadsExportedForCustomer').innerHTML = ret[0]+' Load(s) exported for Customers';
	
	document.getElementById('messageLoadsExportedForCarrier').style.display = 'block';
	document.getElementById('messageLoadsExportedForCarrier').innerHTML = ret[1]+' Load(s) exported for Carriers';
	
	document.getElementById('messageLoadsExportedForBoth').style.display = 'block';
	document.getElementById('messageLoadsExportedForBoth').innerHTML = ret[2]+' Load(s) exported for both Customers and Carriers';
	
	document.getElementById('messageWarning').innerHTML = 'Warning!! In modern browsers you may see the options to save/discard the downloadable file. If you discard, you won\'t be able to download the data again.';
	document.getElementById('messageWarning').style.display = 'block';
	
	document.getElementById('exportLink').className = "exportbutton";
	
	window.location.replace(webpath+"/../views/templates/QBData.mdb");
	loadExported = true;
}
	
function enableDisableMainCalcFields(flag){
	document.getElementById('TotalCarrierCharges').disabled = flag;
	document.getElementById('TotalCustomerCharges').disabled = flag;
	document.getElementById('CustomerMilesCalc').disabled = flag;
	document.getElementById('CarrierMilesCalc').disabled = flag;
	if(document.getElementById('totalProfit') != null)
		document.getElementById('totalProfit').disabled = flag;
	document.getElementById('ARExported').disabled = flag;
	document.getElementById('APExported').disabled = flag;
	document.getElementById('CustomerMiles').disabled = flag;
	document.getElementById('CarrierMiles').disabled = flag;
	document.getElementById('TotalCustcommodities').disabled = flag;
	document.getElementById('TotalCarcommodities').disabled = flag;
	document.getElementById('CustomerRate').disabled = flag;
	document.getElementById('CarrierRate').disabled = flag;
}

function saveButStayOnPage(loadid) {
	if(checkLoad())	{
		document.getElementById('loadToSaveWithoutExit').value = loadid;
		return true;
	}
	return false; 
}

function saveButExitPage(loadid){
	if(checkLoad()) { 
		document.getElementById('loadToSaveAndExit').value = loadid;
		 $('#load').submit();
		return true;
	}
	return false;
}
	
function checkLoad() { 
	enableDisableMainCalcFields(false);
	try{
        setAjaxSession(0);
	}catch(e){

	}
	var loadManualNoExists= document.getElementById('loadManualNoExists').value;
	var CreditLimit=$('#CreditLimit').length;
	var Available=$('#Available').length;

	if(CreditLimit && Available >0){
		var CreditValue=$('#CreditLimitInput').val();
		var AvailableValue=$('#AvailableInput').val();
		var TotalCustomerChargesHidden=$('#TotalCustomerChargesHidden').val();
		if ((CreditValue > 0)&&(AvailableValue < TotalCustomerChargesHidden)){
			alert('The customer has exceeded their credit limit.');

		}
	}
	if (document.getElementById('LoadNumber').value=="") {
		if(document.getElementById('loadManualNoExists').value==1)
		{
			alert('Load number you have been entered is duplicate , Please correct and try again');
			 
			enableDisableMainCalcFields(true);
			return false;
		}
	}
	if(document.getElementById('LoadNumber').value !="" && (document.getElementById('LoadNumber').value != document.getElementById('loadManualNo').value ) ) {
		 if(document.getElementById('loadManualNoExists').value==1)
		{
			alert('Load number you have been entered is duplicate , Please correct and try again');
			 
			enableDisableMainCalcFields(true);
			return false;
		}
	}
	var status1= document.getElementById('loadStatus').value;
	if(status1=="")	{
		alert('Please select the load status type');
		loadStatus.focus();
		enableDisableMainCalcFields(true);
		return false;
	}
	if ( $( "#Salesperson" ).length ) {
		var sales= document.getElementById('Salesperson').value;
		if(sales=="")
		{
			alert('Please select a sales person');
			Salesperson.focus();
			enableDisableMainCalcFields(true);
			return false;
		}
	}	
	var disp= document.getElementById('Dispatcher').value;
	if(disp=="") {
		alert('Please select a Dispatcher');
		Dispatcher.focus();
		enableDisableMainCalcFields(true);
		return false;
	}

	var custId=document.getElementById("cutomerIdAuto").value;
	var custIdContainer=document.getElementById("cutomerIdAutoValueContainer").value;
	//var custId=customerID.value;
	if(custId=="" || custIdContainer=="") {
		alert('Please select a valid customer');
		document.getElementById('cutomerIdAuto').focus();
		enableDisableMainCalcFields(true);
		return false;
	}
	var chkProcess = true;
	var stopid=1;
	var toStop = document.getElementById('totalStop').value;
	
	for (stopid=1;stopid<=toStop;stopid++) {  
		if(stopid == 1)
			chkProcess = checkLoadNext('');
		else
			chkProcess = checkLoadNext(stopid);
			
		if(!chkProcess && chkProcess != undefined){ 
			enableDisableMainCalcFields(true);
			return false;
		}
	}
	var Trans_Del= document.getElementById('Trancore_checkDelete').value;
	
	if(Trans_Del !=0 && document.getElementById('posttoTranscore').checked == false) { 
		document.getElementById('Trancore_DeleteFlag').value=1;
	}
	return true;
}

function setAjaxSession(value) {
  	var path = urlComponentPath+"loadgateway.cfc?method=setAjaxSession";
  	var setSession = "";
  	$.ajax({
      	type: "get",
      	url: path,		
      	dataType: "json",
      	async: false,
      	data: {
          isSession: value
        },
      	success: function(data){
        	setSession = data.sessionCheck;
      	}
    });
    return setSession;
}
	
function checkLoadNext(stopid) {
	if(stopid == 0){
		stopidForMessage = '1';
	} else {
		stopidForMessage = stopid;
	}	
	enableDisableMainCalcFields(false);
	var statusfreightBroker=document.getElementById('statusfreightBroker').value;
	if(statusfreightBroker==1) {
		var PostTo123LoadBoardStatus =document.getElementById('PostTo123LoadBoard').value;
		var loadnumber =document.getElementById('LoadNumber').value; 
		if(PostTo123LoadBoardStatus==1){
			var loardBoard123Exists=$("#loadBoard123").val();
			var equipment = document.getElementById('equipment'+stopid).value;	
			if(loadnumber == "" && equipment == "")	{
				document.getElementById('equipment'+stopid).focus();
				alert('Please select equipment for stop '+stopidForMessage);
				enableDisableMainCalcFields(true);
				return false;	
			}
		}
	}	
	return true;
}	

function ParseUSNumber(frmfld) {
	var phoneText = $(frmfld).val();
	phoneText = phoneText.toString().replace(/,/g, "");
	phoneText = phoneText.replace(/-/g, "");
	phoneText = phoneText.replace(/\(/g, "");
	phoneText = phoneText.replace(/\)/g, "");
	phoneText = phoneText.replace(/ /g, "");
	phoneText = phoneText.replace(/ /g, "");
	  
  	if(phoneText.substring(0,10).search(/[a-zA-Z]/g)==-1 & isFinite(phoneText.substring(0,10)) & phoneText.substring(0,10).length==10){
		var part1 = phoneText.substring(0,6);
		part1 = part1.replace(/(\S{3})/g, "$1-");
		var part2 = phoneText.substring(6,10);
		var ext = phoneText.substring(10);
		if (ext.length) {
			var phoneField = part1 + part2+" "+ext;
		} else {
			var phoneField = part1 + part2;
		}
		$(frmfld).val(phoneField);
	} else if(phoneText.substring(0,10).length !=0) {
		alert('Invalid Phone Number!');
		$(frmfld).focus();
	}
}

function ParseSSNumber(frmfld) {
	var phoneText = $(frmfld).val();
	phoneText = phoneText.toString().replace(/,/g, "");
	phoneText = phoneText.replace(/-/g, "");
	phoneText = phoneText.replace(/\(/g, "");
	phoneText = phoneText.replace(/\)/g, "");
	phoneText = phoneText.replace(/ /g, "");
	phoneText = phoneText.replace(/ /g, "");
	  
	if(phoneText.substring(0,9).search(/[a-zA-Z]/g)==-1 & isFinite(phoneText.substring(0,9)) & phoneText.substring(0,9).length==9){
		var part1 = phoneText.substring(0,5);
		part1 = part1.replace(/(\S{3})/g, "$1-");
		part1 = part1.replace(/(\S{6})/g, "$1-");
		var part2 = phoneText.substring(5,9);
		var ext = "";
		if (ext.length) {
			var phoneField = part1 + part2+" "+ext;
		} else {
			var phoneField = part1 + part2;
		}
		$(frmfld).val(phoneField);
	} else if(phoneText.substring(0,9).length !=0) {
		alert('Invalid SS Number!');
		$(frmfld).focus();
	}
}
 
function validateAgent(frm,dsn,flag) {
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
	var agentName = frm.FA_name.value;
	if (agentName == '') {
		alert('Please enter the Agent Name');
		frm.FA_name.focus();
		return false;
	} 
		
	var agentaddress=frm.address.value;
	if(agentaddress == '') {
		alert('Please enter the Agent Address');
		frm.address.focus();
		return false;
	}

	var agentcity=frm.city.value;
	if(agentcity == '')	{
		alert('Please enter the Agent City');
		frm.city.focus();
		return false;
	}
	var state=frm.state.value;
	if(state=="") {
		alert('Please select a state');
		frm.state.focus();
		return false;
	}	

	var zip=frm.Zipcode.value;
	if(zip=='')	{
		alert('Please enter the Agent Zipcode');
		frm.Zipcode.focus();
		return false;
	}

	var agentcountry=frm.country.value;
	if(agentcountry=="") {
		alert('Please select a country');
		frm.country.focus();
		return false;
	}

	var emailid=frm.FA_email.value;
	if(emailid=='')	{
		alert('Please enter a valid EmailId');
		frm.FA_email.focus();
		return false;
	}	

	var login=frm.loginid.value;
	var empID = frm.editId.value;
	if(login=="") {
		alert('Please enter the Agent Login');
		frm.loginid.focus();
		return false;
	}
	
	if (flag == 1) {	
		var validLogin = checkLogin(login,dsn);
		if (validLogin == false) {
			return false;
		}
	}
	else if (flag == 0) {
		var validLogin = checkLogin(login,dsn,empID);
		if (validLogin == false) {
			return false;
		}
	}
	var password=frm.FA_password.value;	
	if(password=="") {
		alert('Please enter the Agent Password');
		frm.FA_password.focus();
		return false;
	}
	var authlevel=frm.FA_roleid.value;
	
	if(authlevel=="") {
		alert('Please select an Auth Level');
		frm.FA_roleid.focus();
		return false;
	}

	var office=frm.FA_office.value;
	if(office=="") {
		alert('Please select an Office');
		frm.FA_office.focus();
		return false;
	}	
	
	var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.tel.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   	if (PhoneNumberInitialString !='') {
      	var FmtStr=PhoneNumberInitialString;
      	if (FmtStr.length == 12) {      	
      		if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-")) {
        		FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
      		} else {
	        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
	        	frm.tel.focus();
	        	return false;
        	}  
      	} else {
	        FmtStr=PhoneNumberInitialString;        
	        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
	        frm.tel.focus();
	        return false;
      	}
	}
}

function validateOffices(frm) {
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
 	var code=frm.officeCode.value;
 	if(code=='') {
		alert('Please enter the Office Code');
		frm.officeCode.focus();
		return false;
	}
 	var loc=frm.Location.value;
 	if(loc=='')	{
		alert('Please enter the Office Location');
		frm.Location.focus();
		return false;
	}
 	var manager=frm.adminManager.value;
 	if(manager=='')	{
		alert('Please enter the Admin Manager');
		frm.adminManager.focus();
		return false;
	}

	var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.contactNo.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   	if (PhoneNumberInitialString !='') {
      	var FmtStr=PhoneNumberInitialString;
      	if (FmtStr.length == 12) {      	
      		if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-")) {
        		FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
      		} else {
	        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
	        	frm.contactNo.focus();
	        	return false;
        	}  
      	} else {
	        FmtStr=PhoneNumberInitialString;        
	        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
	        frm.contactNo.focus();
	        return false;
      	}
    	return true;
   	}
 	var contact=frm.contactNo.value;
 	if(contact=='')	{
		alert('Please enter the Contact Number');
		frm.contactNo.focus();
		return false;
	}

 	var fax=frm.faxno.value;
 	if(fax=='')	{
		alert('Please enter the Fax Number');
		frm.faxno.focus();
		return false;
	}	

	var email=frm.emailID.value;
	if(email=='') {
	    alert('Please enter a valid EmailId');
		frm.emailID.focus();
		return false;
	}		
}

function validateCustomer(frm) {
	var code=frm.CustomerCode.value;
 	if(code=='') {
		alert('Please enter the Customer Code');
		frm.CustomerCode.focus();
		return false;
	}
 	var custname=frm.CustomerName.value;

 	if(custname=='') {
		alert('Please enter the Customer Name');
		frm.CustomerName.focus();
		return false;
	}
 	var office=frm.OfficeID1.value;
 	if(office=="") {
		alert('Please select an Office');
		frm.OfficeID1.focus();
		return false;
	}
 	
 	var address=frm.Location.value;
 	if(address=='') {
		alert('Please enter the Customer Address');
		frm.Location.focus();
		return false;
 	}

 	var custcity=frm.City.value;
 	if(custcity=='') {
	 	alert('Please enter the Customer city');
		frm.City.focus();
		return false;
 	}

 	var custstate=frm.state1.value;
 	if(custstate=="") {
	 	alert('Please select a State');
		frm.state1.focus();
		return false;
	}

 	var zip=frm.Zipcode.value;
 	if(zip=='') {
	 	alert('Please enter the Zipcode');
		frm.Zipcode.focus();
		return false;
	}

	var country=frm.country1.value;
	if(country=="") {
	 	alert('Please select a Country');
		frm.country1.focus();
		return false;
	}
 
    var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.PhoneNO.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   	if (PhoneNumberInitialString !='') {
      	var FmtStr=PhoneNumberInitialString;
      	if (FmtStr.length == 12) {      	
	      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-"))      	
	        	FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
	        else {
        		alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
    			frm.PhoneNO.focus();
        		return false;
        	}  
      	} else {
        	FmtStr=PhoneNumberInitialString;        
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frm.PhoneNO.focus();
        	return false;
      	}
   	}

	var company=frm.CompanyID1.value;
	if(company=='') {
		alert('Please select a company');
		frm.CompanyID1.focus();
		return false;
	}	
	return true;
}

function validateStop(frm) {
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	var stopname=frm.CustomerStopName.value;
	if(stopname=='') {
		alert('Please enter the Customer Stop Name');
		frm.CustomerStopName.focus();
		return false;
	}	
	var address=frm.location.value;
	if(address=='') {
		alert('Please enter the Customer Address');
		frm.location.focus();
		return false;
	}	
	var stopcity=frm.City.value;
 	if(stopcity=='') {
	 	alert('Please enter the Customer city');
		frm.City.focus();
		return false;
	}
	var custstate=frm.StateID.value;
 	if(custstate=="") {
	 	alert('Please select a State');
		frm.StateID.focus();
		return false;
	}
	var zip=frm.Zipcode.value;
 	if(zip=='') {
	 	alert('Please enter the Zipcode');
		frm.Zipcode.focus();
		return false;
	}
	var customer=frm.cutomerIdAuto.value;
	if(customer=='') {
	    alert('Please select a customer');
		frm.cutomerIdAuto.focus();
		return false;
	}		
}

function  validateCarrier(frm,dsn,flag,type) {
	try {
		var mcno=frm.MCNumber.value.trim();
		if(type == 'carrier') {
			var numberType = 'MC';
		} else {
			var numberType = 'Lic';
		}
		if(mcno=='') {
			alert('Please enter the ' + numberType +' Number');
			frm.MCNumber.focus();
			return false;
		} else {
			if(flag==0 && type == 'carrier') {
				alert('Please enter a Valid ' + numberType + ' Number');
				frm.MCNumber.focus();
				return false;
			}
		}
		var editid=document.getElementById('editid').value;
		if(editid=="") {
			var checkMcNo = new ajaxLoadCutomer();	
			var mcNoStatus = checkMcNo.checkMCNumber(mcno,dsn);
			if (mcNoStatus==true) {
				alert(numberType + ' Number is already exist in database.');				
				document.getElementById("MCNumber").focus();
				return false;
			}
		}
		var carname=frm.CarrierName.value;
		if(carname=='') {
			alert('Please enter the carrierName');
			frm.MCNumber.focus();
			frm.CarrierName.focus();
			return false;
		}
		var address=frm.Address.value;
		if(address=='') {
			alert('Please enter the Carrier Address');
			frm.Address.focus();
			return false;
		}	
		var carcity=frm.City.value;
 		if(carcity=='') {
		 	alert('Please enter the  city');
			frm.City.focus();
			return false;
		}
		var custstate=frm.State.value;
		if(custstate=="") {
		 	alert('Please select a State');
			frm.State.focus();
			return false;
		}
		var zip=frm.Zipcode.value;
		if(zip=='') {
 			alert('Please enter the Zipcode');
			frm.Zipcode.focus();
			return false;
 		}
 		var phone=frm.Phone.value.trim();
 		if(phone=='') {
		 	alert('Please enter the Phone');
			frm.Phone.focus();
			return false;
 		} else {
			var phoneText = frm.Phone.value;
		  	phoneText = phoneText.toString().replace(/,/g, "");
		  	phoneText = phoneText.replace(/-/g, "");
		  	phoneText = phoneText.replace(/\(/g, "");
		  	phoneText = phoneText.replace(/\)/g, "");
		  	phoneText = phoneText.replace(/ /g, "");
		  	phoneText = phoneText.replace(/ /g, "");
	  		if(phoneText.substring(0,10).search(/[a-zA-Z]/g)==-1 & isFinite(phoneText.substring(0,10)) & phoneText.substring(0,10).length==10){
	  		} else if(phoneText.substring(0,10).length !=0) {
		  		alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
		  		frm.Phone.focus();
	      		return false;
	  		}
		}			
	}catch(e){

	}

}

function validateEquipment(frm) {
	var code=frm.EquipmentCode.value;
	if(code=='') {
		alert('Please enter the Equipment Code');
		frm.EquipmentCode.focus();
		return false;
	}	
	var eqname=frm.EquipmentName.value;
	if(eqname=='') {
		alert('Please enter the Equipment Name');
		frm.EquipmentName.focus();
		return false;
	}	
}

function validateUnit(frm) {
	var code=frm.UnitCode.value;
	if(code=='') {
		alert('Please enter the Unit Code');
		frm.UnitCode.focus();
		return false;	
	}
	var unit=frm.UnitName.value;
	if(unit=='') {
		alert('Please enter the Unit Name');
		frm.UnitName.focus();
		return false;	
	} 
}

function CalcCustomerTotal() {
	var TotalCustCharges = 0;
	var TotalCustChargesNext = 0;
	var cutomerCharges=document.getElementById("CustomerRate").value;
	var i = 1;
	for (i=1;i<=7;i++) {
		TotalCustCharges = parseFloat((TotalCustCharges) + parseFloat(document.getElementById("CustomerRate"+i).value) * parseFloat(document.getElementById("qty"+i).value));
	}
	var j=2;
	for (j=2;j<=10;j++) {
		var k=1
		for (k=1;k<=7;k++) {
			TotalCustChargesNext = parseFloat(TotalCustChargesNext) + parseFloat(document.getElementById("CustomerRate"+k+j).value * parseFloat(document.getElementById("qty"+k+''+j).value));
		}
	}
	var custMilesCharges = document.getElementById("CustomerMiles").value;
	custMilesCharges = custMilesCharges.replace('$','');
	custMilesCharges = custMilesCharges.replace(/,/g,'');
		
	var TotalCustcommodities = (parseFloat(TotalCustCharges) + parseFloat(TotalCustChargesNext)).toFixed(2);
	document.getElementById("TotalCustcommodities").value ='$'+convertDollarNumberFormat(TotalCustcommodities);
	cutomerCharges = cutomerCharges.replace(/\$/,"");
	var TotalCustomerCharges = (parseFloat(TotalCustCharges) + parseFloat(TotalCustChargesNext) + parseFloat(cutomerCharges) + parseFloat(custMilesCharges) ).toFixed(2);
	document.getElementById("TotalCustomerCharges").value ='$'+ convertDollarNumberFormat(TotalCustomerCharges);
	$( "#TotalCustomerChargesHidden" ).attr( "value", TotalCustomerCharges);
	updateTotalAndProfitFields();
}

function CalculateTotal(dsn) {
	var TotalCustCharges = 0;
	var TotalCarrCharges = 0;
	var newcharge = 0;
	var newcustcharge = 0;
	var newcareermilse = 0;
	var UnitIdArray='';
	var counter=1;
	var subCounter=1;
	var path=urlComponentPath+"unitgateway.cfc?method=getUnitIdsOfPaymentAdvance";
		$.ajax({
		  	type: "post",
		  	url: path,		
		  	dataType: "text",
		  	async: false,
		  	data: {
			  	dsn:dsn,
			},
		  	success: function(data){
			 	UnitIdArray=data;
		  	}
		});

	$('.noh').each(function(i, obj) {
		$(this).find('.CustomerRate').each(function(i, obj){
			var parentDiv = $(obj).parent().parent();
			var CustomerRate = $(parentDiv).find(".CustomerRate").val().replace(/\$/,"");
			var carrCharges = $(parentDiv).find(".CarrierRate").val().replace(/\$/,"");
			var qty = $(parentDiv).find(".qty").val();
			var CarrierPer =$(parentDiv).find(".CarrierPer").val();
			try{
				CarrierPer=parseFloat(CarrierPer);
			}
			catch(e){
				CarrierPer=0
			}
			
			var custTotal = (parseFloat(CustomerRate) * parseFloat(qty)).toFixed(2);
			CarrierPer=(CarrierPer*custTotal)/100;
			var carrTotal = (parseFloat(carrCharges) * parseFloat(qty)+CarrierPer).toFixed(2);
			
			$(parentDiv).find(".custCharges").val('$'+custTotal);
			$(parentDiv).find(".carrCharges").val('$'+carrTotal );
			
			TotalCustCharges = parseFloat((TotalCustCharges) + parseFloat(CustomerRate) * parseFloat(qty));
			TotalCarrCharges = parseFloat((TotalCarrCharges) + parseFloat(carrCharges) * parseFloat(qty));	
		});
	});

	$('.carrCharges').each(function(i, obj) {
		data= this.value.replace("$","");
		if(!isNaN(data) && this.offsetWidth > 0){
			var arraycontainsmatchvalues = (UnitIdArray.indexOf($(this).parent().parent().find(".unit").val()));
			if(arraycontainsmatchvalues ==0 || arraycontainsmatchvalues ==-1){
			newcharge = newcharge+parseFloat(data);
			}
		}
	});
	
	$('.custCharges').each(function(i, obj) {
		data= this.value.replace("$","");
		if(!isNaN(data) && this.offsetWidth > 0) {
			var arraycontainsmatchvalues = (UnitIdArray.indexOf($(this).parent().parent().find(".unit").val()));
			if(arraycontainsmatchvalues ==0 || arraycontainsmatchvalues ==-1) {
				newcustcharge = newcustcharge+parseFloat(data);
			}
		}
	});
	
	$('.careermilse').each(function(i, obj) {
		data= this.value.replace("$","");
		if(!isNaN(data) && this.offsetWidth > 0) {
			newcareermilse = newcareermilse+parseFloat(data);
		}
	});

	TotalCustCharges=newcharge;
	var cutomerRate= $("#CustomerRate").val();
	var custMilesRate = $("#CustomerMiles").val().replace('$','').replace(/,/g,'');
	var carrierRate= $("#CarrierRate").val();
	var carrMilesRate = $("#CarrierMiles").val().replace('$','').replace(/,/g,'');
	$('#TotalCustcommodities').val( '$'+convertNumberFormat(newcustcharge));
	$('#TotalCarcommodities').val( '$'+convertNumberFormat(newcharge));
	$('#CustomerMilesCalc').val(convertNumberFormat(newcareermilse));
	var TotalCustomerCharges = (parseFloat(TotalCustCharges) + parseFloat(cutomerRate)+parseFloat(custMilesRate)).toFixed(2);
	var TotalCarrierCharges = (parseFloat(TotalCarrCharges) + parseFloat(carrierRate)+parseFloat(carrMilesRate)).toFixed(2);
	$('#TotalCustomerCharges').val(convertDollarNumberFormat(TotalCustomerCharges));
	$( "#TotalCustomerChargesHidden" ).attr( "value", TotalCustomerCharges);
	$('#TotalCarrierCharges').val(convertDollarNumberFormat(TotalCarrierCharges));
	$( "#TotalCarrierChargesHidden" ).attr( "value", TotalCarrierCharges);
	updateTotalAndProfitFields();
}

function formatDollar(num, idValue) {
	var DecimalSeparator = Number("1.2").toLocaleString().substr(1,1);
	var AmountWithCommas = num.toLocaleString();
	var arParts = String(AmountWithCommas).split(DecimalSeparator);
	var intPart = arParts[0];
	var decPart = (arParts.length > 1 ? arParts[1] : '');
	decPart = (decPart + '00').substr(0,2);
	if((intPart + DecimalSeparator + decPart )[0] != "$") {
		var returnvalue = '$' + intPart + DecimalSeparator + decPart;
	} else {
		var returnvalue = intPart + DecimalSeparator + decPart;
	}
	$('#'+idValue).val(returnvalue);
}

function CalcCarrierTotal() { 
	var TotalCarrCharges=0;
	var TotalCarrChargesNext=0;
	var carrierCharges=document.getElementById("CarrierRate").value;
	var i = 1;
	for (i=1;i<=7;i++) {
		TotalCarrCharges = parseFloat((TotalCarrCharges) + parseFloat(document.getElementById("CarrierRate"+i).value) * parseFloat(document.getElementById("qty"+i).value));
	}
	var j=2;
	for (j=2;j<=10;j++)	{
		var k=1
		for (k=1;k<=7;k++) {
			TotalCarrChargesNext = parseFloat(TotalCarrChargesNext) + parseFloat(document.getElementById("CarrierRate"+k+j).value * parseFloat(document.getElementById("qty"+k+''+j).value)) ;
		}
	}
	var totalCommodities = (parseFloat(TotalCarrCharges) + parseFloat(TotalCarrChargesNext)).toFixed(2);
	document.getElementById("TotalCarcommodities").value ='$'+convertDollarNumberFormat(totalCommodities);
	carrierCharges = carrierCharges.replace(/\$/,"");
	carrierCharges = (carrierCharges * 1);
	TotalCarrCharges = (TotalCarrCharges * 1);
	TotalCarrChargesNext = (TotalCarrChargesNext * 1);
	var TotalCarrierCharges = (TotalCarrCharges + TotalCarrChargesNext + carrierCharges).toFixed(2);
	document.getElementById("TotalCarrierCharges").value = '$'+ convertDollarNumberFormat(TotalCarrierCharges);
	$( "#TotalCarrierChargesHidden" ).attr( "value", TotalCarrierCharges);		
	updateTotalAndProfitFields();
}

function getbalance() {
	var credit=document.getElementById("CreditLimit").value;
	var avail=document.getElementById("Available").value;
	credit = credit.replace(/\$/,"");
	credit = (credit * 1);
	avail = avail.replace(/\$/,"");
	avail = (avail * 1);      
	var balance=credit-avail;
	document.getElementById("Balance").value='$'+balance;
}

function Autofillwebsite(frm) {
	var strarray="";
	var email=frm.Email.value;
	var mystring=email.toString();
	var strlength=mystring.length;
	var regexp='@';
	var matchpos=mystring.search(regexp);
	if(matchpos!=-1) {
		var i;
        for (i=matchpos+1;i<strlength;i++) {
	       	var indexvalue=mystring.charAt(i);       	
	       	strarray=strarray+indexvalue;       
	        frm.website.value='http://www.'+strarray;
        }
	}
	return false;	
}

// Calaculate Distance
var zipNo = 1;
function getLongitudeLatitude(frm) { 
	var firstzip=frm.shipperZipcode.value;
	var secondzip=frm.consigneeZipcode.value;
	var res1=ColdFusion.Map.getLatitudeLongitude(firstzip, callbackHandler);
	var res2=ColdFusion.Map.getLatitudeLongitude(secondzip, callbackHandler);
} 

function callbackHandler(result) {
	if (zipNo > 2) {
		zipNo = 1;
	}
	document.getElementById('result'+zipNo).value=result;
	var myList = result.toString();
	var myvalue=myList.split(',');
	var myLastVal1=myvalue[0];
	var myLastVal2=myvalue[1];
	var myLastVal1Len = myLastVal1.length;
	var myLastVal2Len = myLastVal2.length;
	document.getElementById('lat'+zipNo).value=myLastVal1.substring(1,myLastVal1Len);
	document.getElementById('long'+zipNo).value=myLastVal2.substring(1,myLastVal2Len-1);
	zipNo=zipNo+1;
}

function  ClaculateDistance(frmload) {
	addressChanged("");
}

// Calculate distance for next stop

function sleep(milliseconds) {
	var start = new Date().getTime();
		for (var i = 0; i < 1e7; i++) {
			if ((new Date().getTime() - start) > milliseconds){
			break;
		}
	}
}

var zipNoNext = 1;
var stpNo;
function getLongitudeLatitudeNext(frm,stpNo) { 
	document.getElementById('CurrStopNo').value = stpNo;
	var firstzip=document.getElementById('shipperZipcode'+stpNo).value;
	var secondzip=document.getElementById('consigneeZipcode'+stpNo).value;
	var res1=ColdFusion.Map.getLatitudeLongitude(firstzip, callbackHandlerNext);
	var res2=ColdFusion.Map.getLatitudeLongitude(secondzip, callbackHandlerNext);
} 

function callbackHandlerNext(result) {
	stpNo = document.getElementById('CurrStopNo').value;
	if (zipNoNext > 2) {
		zipNoNext = 1;
	}
	document.getElementById('result'+zipNoNext+stpNo).value=result;	
	var myList = result.toString();
	var myvalue=myList.split(',');
	var myLastVal1=myvalue[0];
	var myLastVal2=myvalue[1];
	var myLastVal1Len = myLastVal1.length;
	var myLastVal2Len = myLastVal2.length;
	document.getElementById('lat'+zipNoNext+stpNo).value=myLastVal1.substring(1,myLastVal1Len);
	document.getElementById('long'+zipNoNext+stpNo).value=myLastVal2.substring(1,myLastVal2Len-1);
	zipNoNext=zipNoNext+1;
}

function CalcDist(stpNo){
	addressChanged(stpNo);
}

// Updates total fileds and all the profit fields
function updateTotalAndProfitFields() {

	// updating total charges for Customers
	var flatRate = document.getElementById('CustomerRate').value;
	flatRate = flatRate.replace("$","");
	flatRate = flatRate.replace(/,/g,"");
	var custCommodities = document.getElementById('TotalCustcommodities').value;
	custCommodities = custCommodities.replace("$","");
	custCommodities = custCommodities.replace(/,/g,"");
	var CustomerMilesAmount = document.getElementById('CustomerMiles').value;
	CustomerMilesAmount = CustomerMilesAmount.replace("$","");
	CustomerMilesAmount = CustomerMilesAmount.replace(/,/g,"");
	CustomerMilesAmount = parseFloat(CustomerMilesAmount).toFixed(2);
	var totalCustCharges = (parseFloat(flatRate) + parseFloat(custCommodities) + parseFloat(CustomerMilesAmount)).toFixed(2);
	var AdvancePaymentsCustomer=$("#AdvancePaymentsCustomer").val().replace("$","");
	var TotalCustomerChargesDisplay=0;
	if(parseFloat(totalCustCharges) >= parseFloat(AdvancePaymentsCustomer)){
		TotalCustomerChargesDisplay=parseFloat(totalCustCharges)- parseFloat(AdvancePaymentsCustomer);
	}
	document.getElementById('TotalCustomerCharges').value = "$"+convertDollarNumberFormat(TotalCustomerChargesDisplay);
	$( "#TotalCustomerChargesHidden" ).attr( "value", totalCustCharges);

	// updating total charges for Carriers
	var flatRateCar = document.getElementById('CarrierRate').value;
	flatRateCar = flatRateCar.replace("$","");
	flatRateCar = flatRateCar.replace(/,/g,"");
	var carCommodities = document.getElementById('TotalCarcommodities').value;
	carCommodities = carCommodities.replace("$","");
	carCommodities = carCommodities.replace(/,/g,"");
	var CarMilesAmount = document.getElementById('CarrierMiles').value;
	CarMilesAmount = CarMilesAmount.replace("$","");
	CarMilesAmount = CarMilesAmount.replace(/,/g,"");
	var AdvancePaymentsCarrier=$("#AdvancePaymentsCarrierhidden").val();
	var totalCarCharges = (parseFloat(flatRateCar) + parseFloat(carCommodities) + parseFloat(CarMilesAmount)).toFixed(2);
	var TotalCarrierChargesDisplay=0;
	if(parseFloat(totalCarCharges) >=parseFloat(AdvancePaymentsCarrier)){
		TotalCarrierChargesDisplay=(parseFloat(totalCarCharges)- (parseFloat(AdvancePaymentsCarrier))).toFixed(2);
	}
	document.getElementById('TotalCarrierCharges').value = "$"+convertDollarNumberFormat(TotalCarrierChargesDisplay);
	$( "#TotalCarrierChargesHidden" ).attr( "value", totalCarCharges);
	
	// updating profits fields
	var flatRateProfit = (flatRate - flatRateCar).toFixed(2);
	document.getElementById('flatRateProfit').value = "$"+convertDollarNumberFormat(flatRateProfit);
	var carcommoditiesProfit = (custCommodities - carCommodities).toFixed(2);
	
	document.getElementById('carcommoditiesProfit').value = "$"+convertDollarNumberFormat(carcommoditiesProfit);
	var amountOfMilesProfit = (CustomerMilesAmount - CarMilesAmount).toFixed(2);
	document.getElementById('amountOfMilesProfit').value = "$"+convertDollarNumberFormat(amountOfMilesProfit);
	
	var totalProfit = (parseFloat(flatRateProfit)+parseFloat(carcommoditiesProfit)+parseFloat(amountOfMilesProfit)).toFixed(2)
	document.getElementById('totalProfit').value = "$"+convertDollarNumberFormat(totalProfit);

	// updating percentage profits
	if(totalProfit==0 && totalCustCharges==0) {
		document.getElementById('percentageProfit').firstChild.data = "0% Profit";
	} else {
		var calcPerc = Math.round((totalProfit/totalCustCharges)*100);
		document.getElementById('percentageProfit').firstChild.data = calcPerc+"% Profit";
	}
}

function carrierReportOnClick(loadid,URLToken,dsn) {
	var minimumMargin = document.getElementById('minimumMargin').value;
	var percentageProfit = document.getElementById('percentageProfit').innerHTML;
	var frieghtBrokerStatus = document.getElementById('frieghtBroker').value;
	var percentageProfit = trim(percentageProfit.replace("% Profit", ""));
	var frieghtBrokerName='Dispatch';
	if(frieghtBrokerStatus ==1){
		var frieghtBrokerName='Carrier';
	}
	// Validation removed
	window.open('../reports/loadReportForDispatch.cfm?type='+frieghtBrokerName+'&loadid='+loadid+'&dsn='+dsn+'&'+URLToken+'');
}

function carrierMailReportOnClick(loadid,URLToken) {
	var minimumMargin = document.getElementById('minimumMargin').value;
	var frieghtBrokerStatus = document.getElementById('frieghtBroker').value;
	var percentageProfit = document.getElementById('percentageProfit').innerHTML;
	var percentageProfit = trim(percentageProfit.replace("% Profit", ""));
	var frieghtBrokerName='Dispatch';
	if(frieghtBrokerStatus ==1){
		var frieghtBrokerName='Carrier';
	}
	if(Number(percentageProfit) >=  Number(minimumMargin) ) {
		newwindow=window.open('index.cfm?event=loadMail&type='+frieghtBrokerName+'&loadid='+loadid+'&'+URLToken+'','Map','height=400,width=750');/*,'Map','height=400,width=750'*/
		if (window.focus) {
			newwindow.focus()
		}
	} 
	else {
		alert('You cannot print the Carrier Rate Confirmation because the Margin does not meet the minimum Margin percent of '+minimumMargin+'%');
		return false;
	}
}

function BOLReportOnClick(loadid,URLToken) {
	newwindow=window.open('index.cfm?event=loadMail&type=BOL&loadid='+loadid+'&'+URLToken+'','Map','height=400,width=750');/*,'Map','height=400,width=750'*/
	if (window.focus) {
		newwindow.focus()
	}
}

function CarrierWorkOrderImportOnClick(loadid,URLToken,dsn) {
	window.open('../reports/CarrierWorkOrderImport.cfm?loadid='+loadid+'&dsn='+dsn+'&'+URLToken+'');
}

function CarrierMailWorkOrderImportOnClick(loadid,URLToken) {
	newwindow=window.open('index.cfm?event=loadMail&type=importWork&loadid='+loadid+'&'+URLToken+'','Map','height=400,width=750');
	if (window.focus) {
		newwindow.focus()
	}
}

function CarrierWorkOrderExportOnClick(loadid,URLToken,dsn) {
	window.open('../reports/CarrierWorkOrderExport.cfm?loadid='+loadid+'&dsn='+dsn+'&'+URLToken+'');
}

function CarrierMailWorkOrderExportOnClick(loadid,URLToken) {
	newwindow=window.open('index.cfm?event=loadMail&type=exportWork&loadid='+loadid+'&'+URLToken+'','Map','height=400,width=750');
	if (window.focus) {
		newwindow.focus()
	}
}

function CustomerReportOnClick(loadid,URLToken,dsn) {
	window.open('../reports/CustomerInvoiceReport.cfm?loadid='+loadid+'&dsn='+dsn+'&'+URLToken+'');
}

function CustomerMailReportOnClick(loadid,URLToken,customerID) {
	newwindow=window.open('index.cfm?event=loadMail&type=customer&loadid='+loadid+'&customerID='+customerID+'&'+URLToken+'','Map','height=400,width=750');
	if (window.focus) {
		newwindow.focus()
	}
}
function mailDocOnClick(URLToken,docType,ID) {
	var urlID ="";
	if(ID != ""){urlID = '&id='+ID;}
	newwindow=window.open('index.cfm?event=loadMail&type=mailDoc&attachTo=10&docType='+docType+'&'+URLToken+''+urlID+'','Map','height=600,width=750');
	if (window.focus) {
		newwindow.focus()
	}
}
//BOL report url is in loadswitch.cfm
// Updates the total RatePerMiles

function updateTotalRates(dsn) { 
	var TotalMiles=0;
	var miles1 = document.getElementById('milse').value;
	TotalMiles = parseFloat(miles1);

	var custElem = $('#cutomerIdValueContainer').val();
	var customerId = custElem; //custElem.options[custElem.selectedIndex].value;
	
	var CustomerRates = 0; // TODO: get correct rate/mile from DB
	var CarrierRates = 0; // TODO: get correct rate/mile from DB
	
	for(var i=1; i<=10; i++) {
		if(document.getElementById('stop'+i)==null || document.getElementById('stop'+i).style.display == 'none')
			continue;
		var ithMile = document.getElementById('milse'+i).value;
		TotalMiles += parseFloat(ithMile);
	}
		
	// correct calculation:
	var arrLongShortMiles = getLongShortMiles(dsn); // Will return LongMiles on index0 ShortMiles on index1
	var custTotalMiles = TotalMiles + ((TotalMiles/100)*arrLongShortMiles[0]);
	var carTootalMiles = TotalMiles - ((TotalMiles/100)*arrLongShortMiles[1]);
	document.getElementById('CustomerMilesCalc').value = convertNumberFormat(custTotalMiles);
	document.getElementById('CarrierMilesCalc').value = convertNumberFormat(carTootalMiles);
	
	var customerRatePerMile = document.getElementById('CustomerRatePerMile').value;
	var carrierRatePerMile = document.getElementById('CarrierRatePerMile').value;
	
	customerRatePerMile = customerRatePerMile.replace("$","");
	customerRatePerMile = customerRatePerMile.replace(/,/g,"");
	
	carrierRatePerMile = carrierRatePerMile.replace("$","");
	carrierRatePerMile = carrierRatePerMile.replace(/,/g,"");
	
	if(trim(customerRatePerMile) == "0" || trim(customerRatePerMile)=="")
		document.getElementById('CustomerRatePerMile').value = "$"+CustomerRates; // 0.00 for now. Need to get it from DB
	else
		CustomerRates = parseFloat(customerRatePerMile);
		
	if(trim(carrierRatePerMile) == "0" || trim(carrierRatePerMile)=="")
		document.getElementById('CarrierRatePerMile').value = "$"+CarrierRates;  // 0.00 for now. Need to get it from DB
	else
		CarrierRates = parseFloat(carrierRatePerMile);
	
	var totalCustomerMilesRate = custTotalMiles * CustomerRates;
	var totalCarrierMilesRate = carTootalMiles * CarrierRates;
	
	totalCustomerMilesRate = totalCustomerMilesRate.toFixed(2); // till 2 decimal places
	totalCarrierMilesRate = totalCarrierMilesRate.toFixed(2); // till 2 decimal places
	
	document.getElementById('CustomerMiles').value = "$"+convertDollarNumberFormat(totalCustomerMilesRate);
	document.getElementById('CarrierMiles').value = "$"+convertDollarNumberFormat(totalCarrierMilesRate);
	document.getElementById('CustomerMilesTotalAmount').value = "$"+convertDollarNumberFormat(totalCustomerMilesRate);
	document.getElementById('CarrierMilesTotalAmount').value = "$"+convertDollarNumberFormat(totalCarrierMilesRate);

	updateTotalAndProfitFields();
}

function calculateTotalRates(dsn) {
	updateTotalRates(dsn);
}

function ClaculateDistanceNext(frmload1,stpNo1) {   
	var calFunc="CalcDist('+stpNo1+')";
	setTimeout(calFunc,1000);
}

function isValidPercentage(strValue) {
	if(isNaN(strValue))	{
		return false;
	} else {
		if(strValue.indexOf('.') >= 0){
			if(strValue[1] != '.' && strValue[2] != '.')
				return false;
		}
		else{
			if(strValue.length >2)
				return false;
		}
	}
	return true;
}

function addQuickCalcInfoToLog(dsn,userName) {
	var companyName = document.getElementById('companyName').value;
	var consigneeAddress = document.getElementById('conAddress').value;
	var shipperAddress = document.getElementById('shipperAddress').value;
	var custRatePerMile = getFloat(document.getElementById('customerRate').value);
	var carRatePerMile = getFloat(document.getElementById('carrierRate').value);
	var custMiles = getFloat(document.getElementById('customerMiles').value);
	var carMiles = getFloat(document.getElementById('carrierMiles').value);
	var customerAmount = getFloat(document.getElementById('customerAmount').value);
	var carrierAmount = getFloat(document.getElementById('carrierAmount').value);
	var loadCustomer = new ajaxLoadCutomer();
	loadCustomer.addQuickCalcInfoToLog(dsn, consigneeAddress, shipperAddress, custRatePerMile, carRatePerMile, custMiles, carMiles, customerAmount, carrierAmount, companyName,userName);
}

function clearQuickCalcFields() {
	document.getElementById('companyName').value = "";
	document.getElementById('conAddress').value = "";
	document.getElementById('shipperAddress').value = "";
	document.getElementById('customerRate').value = "0.00";
	document.getElementById('carrierRate').value = "0.00";
	document.getElementById('customerAmount').value = "0.00";
	document.getElementById('customerMiles').value = "0.00";
	document.getElementById('carrierMiles').value = "0.00";
	document.getElementById('carrierAmount').value = "0.00";
}


function validateFields() {
	var longMiles = document.getElementById('longMiles').value;
	var shortMiles = document.getElementById('shortMiles').value;
	if(longMiles[longMiles.length - 1] == '.')
		document.getElementById('longMiles').value = longMiles+'0';
	if(shortMiles[shortMiles.length - 1] == '.')
		document.getElementById('shortMiles').value = shortMiles+'0';
	if(isValidPercentage(longMiles) && isValidPercentage(shortMiles))
		return true;
	alert('Invalid percentage entered');
	return false;
}

function getMCDetails(url,mcno,dsn,type) {
	if(type == 'carrier') {
		var numberType = 'MC';
	} else {
		var numberType = 'Lic';
	}
	var checkMcNo = new ajaxLoadCutomer();	
	var mcNoStatus = checkMcNo.checkMCNumber(mcno,dsn);    
	if (mcNoStatus==true) {
		alert(numberType + ' Number is already exist in database.');
		document.getElementById("MCNumber").focus();
		return false;
	}
	checkUnload();
	if(type == 'carrier') {
		document.location.href=url + '&mcNo='+mcno;
	}
}

function checkLogin(loginid,dsn,empID) {	
	var checkLoginid = new ajaxLoadCutomer();	
	var loginStatus = checkLoginid.checkLoginId(loginid,dsn,empID);
	if (loginStatus==true) {
		alert('Login name already exists. Please change it and click save.');
		document.getElementById("loginid").focus();
		return false;
	}
	checkUnload();
}

function ChangeCustomerInfo(customerid) {
	alert('Please delete stops from different customer, Before changing the customer');
	document.getElementById("cutomerId").value=customerid;
	return false;
}



//Code for Asigned Load Type--- Radios buttons on selection "On Add Agent"
function isSelect() {
	var _select = document.getElementById('AsignedLoadType');				
	for ( var i = 0; i < _select.options.length; i++ ) {
		var sel=_select.options[i].value;
		if(_select.options[i].selected == false) {
			document.getElementById("L_radio_" + sel).disabled=true;
			document.getElementById("R_radio_" + sel).disabled=true;
			
			document.getElementById("L_radio_" + sel).checked=false;
			document.getElementById("R_radio_" + sel).checked=false;
		} else {
			document.getElementById("L_radio_" + sel).disabled=false;
			document.getElementById("R_radio_" + sel).disabled=false;
			document.getElementById("L_radio_" + sel).checked=true;
		}
	}
}

function convertNumberFormat(cNumber) {
    var parts = cNumber.toFixed(2).toString().split(".");
    parts[0] = parts[0].replace(/,/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
}

function convertDollarNumberFormat(cNumber) {
    var parts = cNumber.toString().split(".");
    parts[0] = parts[0].replace(/,/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
}

function checkloadNUmberDB(val,varDsn) {
	document.getElementById("loadManualNo").value = val.replace(/[^0-9]/g,'');
	var valGt=document.getElementById("loadManualNo").value;
	var xmlhttp;
	if (window.XMLHttpRequest) {
  		xmlhttp=new XMLHttpRequest();
	} else {
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
	xmlhttp.onreadystatechange=function() {
  		if (xmlhttp.readyState==4 && xmlhttp.status==200) {
			if(xmlhttp.responseText ==1) {  
				if (document.getElementById('LoadNumber').value=="") {
					document.getElementById("myDiv").innerHTML='<font color="red">Load number duplicate in system</font>';
					document.getElementById("loadManualNoExists").value=1;
		  		} else if(document.getElementById('LoadNumber').value !="" && (document.getElementById('LoadNumber').value != document.getElementById('loadManualNo').value ) ) {
			 		document.getElementById("myDiv").innerHTML='<font color="red">Load number duplicate in system</font>';
					document.getElementById("loadManualNoExists").value=1;
		  		}
			} else {
				document.getElementById("myDiv").innerHTML='';
				document.getElementById("loadManualNoExists").value='';
			}
    	}
  	}
	xmlhttp.open("GET","checkloadNoexists.cfm?val="+valGt+"&varDsn="+varDsn,true);
	xmlhttp.send();
}

function rememberSearchSession(data) {
	var isChecked = $(data).prop('checked');
	var searchText = $("#searchText").val();
	var csfrToken = $("#csfrToken").val();
	var getPath=urlComponentPath.split("/");
	var path = "/"+getPath[1]+"/www/webroot/sessionSettingajax.cfm?checked="+isChecked+"&searchText="+searchText+"&csfrToken="+csfrToken;
    $.ajax({
		type: "get",
		url: path,	
		success: function(data){

		}, 
		error: function(err){
			console.log(err);
		}
    });
}

function validationMaintenance(dsName) {
	var milesInterval=document.getElementById("milesInterval").value;
	var description=document.getElementById("description").value;
	var editid=document.getElementById("editid").value;
	var dateInterval=document.getElementById("dateInterval").value;
	var intRegex = /[0-9 -()+]+$/;
	if (description==""){
		alert('please enter Description');
		document.getElementById("description").focus();
		return false;
	}
	if(dateInterval ==0 && milesInterval ==""){
		alert('please enter MilesInterval or DateInterval');
		document.getElementById("milesInterval").focus();
		return false;
	}
	if(milesInterval!=""){
		if (!milesInterval.match(intRegex)){
			alert('please enter miles interval in numbers');
			document.getElementById("milesInterval").focus();
			return false;
		}	
	}	
	var path = urlComponentPath+"equipmentgateway.cfc?method=getDescriptionDuplicate&dsName="+dsName+"&description="+description+"&editid="+editid;
	$.ajax({
		type: "get",
		url: path,	
		success: function(data){
			if(data==1){
				$("#frmMaintenance").submit();
			}else{
				$("#errorShow").show();
				return false;
			}
		}, 
		error: function(err){
			return false;
		}
    });
}

function getmaintenancesetUpValues(dsName) {
	var description=document.getElementById("description").value;
	var path = urlComponentPath+"equipmentgateway.cfc?method=getMaintenanceInformationAjax&EquipmentMaintSetupId="+description+"&dsName="+dsName;
	$.ajax({
		type: "get",
		url: path,	
		success: function(data) {
			if(data!=1){
				var returnedData = $.parseJSON($.trim(data));
				for(dataIndex=0;dataIndex < returnedData.DATA.length;dataIndex++){
					for(columnsIndex=0;columnsIndex < returnedData.COLUMNS.length;columnsIndex++){
						if (columnsIndex==1){
							$('#MilesInterval').val(returnedData.DATA[dataIndex][2]);
							$('#DateInterval option').each(function() {
								if($(this).val() == returnedData.DATA[dataIndex][3]) {
									$(this).prop("selected", true);
								}
							});
							$('#Notes').val(returnedData.DATA[dataIndex][4]);
						 }
					}
				}	
			} else {
				$("#MilesInterval").val('');
				$("#DateInterval").val(0);
				$("#Notes").val('');
			}
		}, 
		error: function(err) {
			return false;
		}
    });
}

function checkValidation() {
	var description=$("#description").val();
	var milesInterval=document.getElementById("MilesInterval").value;
	var dateInterval=document.getElementById("DateInterval").value;
	var Date=document.getElementById("Date").value;
	var intRegex = /[0-9 -()+]+$/;
	if(description=="") {
		alert('Please select the description');	
		return false;
	}
	if(dateInterval ==0 && milesInterval =="" && Date == "") {
		alert('please enter milesInterval or dateinterval or nextdate');
		document.getElementById("MilesInterval").focus();
		return false;
	}
	if(milesInterval!="") {
		if (!milesInterval.match(intRegex)){
			alert('please enter miles interval in numbers');
			document.getElementById("MilesInterval").focus();
			return false;
		}	
	}	
}

function checkDateFormatAll(ele) {
	var reg =/((^(10|12|0?[13578])([/])(3[01]|[12][0-9]|0?[1-9])([/])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(11|0?[469])([/])(30|[12][0-9]|0?[1-9])([/])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(0?2)([/])(2[0-8]|1[0-9]|0?[1-9])([/])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(0?2)([/])(29)([/])([2468][048]00)$)|(^(0?2)([/])(29)([/])([3579][26]00)$)|(^(0?2)([/])(29)([/])([1][89][0][48])$)|(^(0?2)([/])(29)([/])([2-9][0-9][0][48])$)|(^(0?2)([/])(29)([/])([1][89][2468][048])$)|(^(0?2)([/])(29)([/])([2-9][0-9][2468][048])$)|(^(0?2)([/])(29)([/])([1][89][13579][26])$)|(^(0?2)([/])(29)([/])([2-9][0-9][13579][26])$))/;
	var textValue=$(ele).val();
	if(textValue.length){
		if(!textValue.match(reg)){
			alert('Please enter a date in mm/dd/yyyy format');
			$(ele).focus();
		}
	}	
}

function deleteEquipmaintTrans(ele,id,dsName,equipMaintId) {
	var equipmentId=document.getElementById("equipmentId").value;
	var path = urlComponentPath+"equipmentgateway.cfc?method=deleteEquipmentsMainTransaction&equipMainID="+id+"&dsName="+dsName+"&equipmentId="+equipmentId+"&equipMaintId="+equipMaintId;
	if(confirm("Are you sure to delete it ?")) {
		$.ajax({
			type: "get",
			url: path,	
			success: function(data){
				$(ele).parent().parent().remove();
				location.reload();
				
			}, error: function(err){
				console.log(err);
				return false;
			}
		});
    }
    else{
        return false;
    }
}

function checkValidationTransaction() {
	var Odometer=$("#Odometer").val();
	var Date=$("#Date").val();
	var intRegex = /[0-9 -()+]+$/;
	if (!Odometer.match(intRegex) ) {
		alert('Please enter odometer in digits');
		$("#Odometer").focus();
		return false;
	}	
	if(Date==""){
		alert('Please enter the Date');	
		$("#Date").focus();
		return false;
	}
}

function popitupEquip(url) {
	newwindow=window.open(url,'Map','height=600,width=600');
	if (window.focus) {newwindow.focus()}
	return false;
}

function exportTaxSummary() {
	var DateFrom=document.getElementById("DateFrom").value;
	var DateTo=document.getElementById("DateTo").value;
	if(DateFrom=="") {
		alert('please enter a date for datefrom field');
		return false;
	}
	if(DateTo==""){
		alert('please enter a date for dateto field');
		return false;
	}
	document.getElementById('exportLink').className = 'busyButton';
	$("#disptaxSummary").submit();
	document.getElementById('exportLink').className = 'exportbutton';
}

function showHideIcons(ele,stopId) {
	var checkClass=$(ele).hasClass( "fa-plus-circle" );
	if (checkClass){
		$(ele).removeClass("fa-plus-circle");
		$(ele).addClass("fa-minus-circle");
		$(ele).parent().parent().find(".InfoShipping"+stopId).slideDown();
	} else {
		$(ele).removeClass("fa-minus-circle");
		$(ele).addClass("fa-plus-circle");
		$(ele).parent().parent().find(".InfoShipping"+stopId).slideUp();
		if(stopId ==1) {
			var stopId="";
		}
		$("#span_Shipper"+stopId).hide();
	}
}

function showHideConsineeIcons(ele,stopId) {
	var checkClass=$(ele).hasClass( "fa-plus-circle" );
	if (checkClass){
		$(ele).removeClass("fa-plus-circle");
		$(ele).addClass("fa-minus-circle");
		$(ele).parent().parent().find(".InfoConsinee"+stopId).slideDown();
	} else {
		$(ele).removeClass("fa-minus-circle");
		$(ele).addClass("fa-plus-circle");
		$(ele).parent().parent().find(".InfoConsinee"+stopId).slideUp();
		if(stopId==1){
			var stopId="";
		}
		$("#span_Consignee"+stopId).hide();
	}
}

/*checkBox select unselect  on allload starts*/
function checkboxOperation(ele) {
	if ($(ele).prop('checked')==true){ 
		$(".checkboxSelect").prop("checked", true);
    }else{
		$(".checkboxSelect").prop("checked", false);
	} 
}

function UpdateLoadsCheck(){
	return ValidationCheckUpdateLoads();
}

function fnOpenNormalDialog() {
    $("#dialog-confirm").html("Are you want to update the  checked loads?");
    // Define the Dialog and its properties.
    $("#dialog-confirm").dialog({
        resizable: false,
        modal: true,
        title: "Confirm Box",
        height: 160,
        width: 350,
        buttons: {
            "Yes": function () {
                $(this).dialog('close');
                callback(true);
            },
                "No": function () {
                $(this).dialog('close');
            }
        }
    });
}

function fnOpenNormalDialogProcess() {
    $("#Information").html("<img width='325px' style='margin-top: 13px;' src='images/loadingbar.gif'>");
    // Define the Dialog and its properties.
    $("#Information").dialog({
        resizable: false,
        modal: true,
        title: "Information",
        height: 160,
        width: 350
    }); 
}
function responseUploadProcess(numbers,loadboard,datloadboard,loadstatus1,itsloadboard,LoadBoardDeletionOccuredStatus,loadboarditsDeleted,datLoadbordDeleted,Loadbord123Deleted,posteveryWhere,posteveryWhereDeleted) {
	if(numbers !=""){
		$("#responseUploadProcess").html("<h3 style='color:#31a047;'>ShipDate Updated Loads</h3>");
		$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+numbers+"</div>");
	}
	if(loadstatus1.length != 0){
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>LoadStatus  Updated  Loads</h3>");	
		$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+loadstatus1+"</div>");
	}
	if(LoadBoardDeletionOccuredStatus ==true){
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>ShipDate Updated DatLoadBoard Loads</h3>");	
		if(datloadboard.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>DatLoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+datloadboard+"</div>");
		}
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>ShipDate Updated 123LoadBoard Loads</h3>");	
		if(loadboard.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>123 LoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+loadboard+"</div>");
		}
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>ShipDate Updated ITS LoadBoard Loads</h3>");	
		if(itsloadboard.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>ITS LoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+itsloadboard+"</div>");
		}
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>ShipDate Updated PosteveryWhere LoadBoard Loads</h3>");	
		if(posteveryWhere.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>PosteveryWhere LoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+posteveryWhere+"</div>");
		}
	}else{
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>DatLoadBoard deletion occured loads due to system setup statusTrigger</h3>");	
		if(datLoadbordDeleted.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>DatLoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+datLoadbordDeleted+"</div>");
		}
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>123LoadBoard deletion occured loads due to system setup statusTrigger</h3>");	
		if(Loadbord123Deleted.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>123 LoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+Loadbord123Deleted+"</div>");
		}
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>ITS LoadBoard deletion occured loads due to system setup statusTrigger</h3>");	
		if(loadboarditsDeleted.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>ITS LoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+loadboarditsDeleted+"</div>");
		}
		$("#responseUploadProcess").append("<h3 style='color:#31a047;'>Posteverywhere LoadBoard deletion occured loads due to system setup statusTrigger</h3>");	
		if(posteveryWhereDeleted.length == 0){
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>Posteverywhere LoadBoard Says:None</div>");
		}else{
			$("#responseUploadProcess").append("<div style='word-wrap:break-word;'>"+posteveryWhereDeleted+"</div>");
		}
	}	
    // Define the Dialog and its properties.
    $("#responseUploadProcess").dialog({
        resizable: false,
        modal: true,
        title: "Updated Information",
        height: 450,
        width: 500
    });
}

function ValidationCheckUpdateLoads(){
	var shipperDateToUpdate=$('#rollOverShipDate').val();
	var statustext=$('#loadStatusUpdate').val();
	if(shipperDateToUpdate =="" && statustext ==""){
		alert('Please enter Date or select status');
		return false;
	}
	fnOpenNormalDialog(); 
}

function callback(value) {
    if (value) {
		var shipperDateToUpdate=$('#rollOverShipDate').val();
		var statustext=$('#loadStatusUpdate').val();
		var matches = [];
		$(".checkboxSelect:checked").each(function() {
			matches.push(this.value);
		});
		var dsn=$('#dsn').val();
		var loadstatus=$('#loadStatusUpdate').val();
		if($('#weekendRollOvercheck').prop('checked')==true){
			var weekendRollOvercheck=1;
		}else{
			var weekendRollOvercheck=0;
		}
		if(loadstatus == 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44') {
			if($('#postToIts').prop('checked')==true){
				var postits=1;
			}else{
				var postits=0;
			}
			if($('#posteverywhere').prop('checked')==true){
				var posteverywhere=1;
			}else{
				var posteverywhere=0;
			}
			if($('#post123loadboard').prop('checked')==true){
				var post123loadboard=1;
			}else{
				var post123loadboard=0;
			}
			if($('#postdatloadboard').prop('checked')==true){
				var postdatloadboard=1;
			}else{
				var postdatloadboard=0;
			}
			
		} else {
			var postits=0;
			var posteverywhere=0;
			var post123loadboard=0;
			var postdatloadboard=0;
		}

		if(matches !="") {
			var loadNumbers = JSON.stringify(matches);
			var path = urlComponentPath+"ShipDateUpdate.cfc?method=updateshipdateAll";
			var setSession = "";
			var empId=$('#Id').val();
			fnOpenNormalDialogProcess();
			$.ajax({
				  type: "post",
				  url: path,		
				  dataType: "json",
				  async: false,
				  data: {
					  loadNumbers:loadNumbers,dsn:dsn,shipperDateToUpdate:shipperDateToUpdate,empId:empId,statustext:statustext,postits:postits,posteverywhere:posteverywhere,post123loadboard:post123loadboard,postdatloadboard:postdatloadboard,weekendRollOvercheck:weekendRollOvercheck
					},
				  success: function(data){
					if (data.status==true){
						$( "#Information" ).dialog( "close" );

						$("#responseUploadProcess").dialog({
							close : function( event, ui ){
								location.href = location.href;
							}
						});
						console.log(data);
						responseUploadProcess(data.UpdatedShipDate,data.Loadbord123,data.datLoadbord,data.LoadStatus,data.loadboardits,data.LoadBoardDeletionOccuredStatus,data.loadboarditsDeleted,data.datLoadbordDeleted,data.Loadbord123Deleted,data.posteveryWhere,data.posteveryWhereDeleted);
					}
				  }
			});
		}	
	}	
} 

$(document).ready(function() {
	$(".checkboxSelect").click(function() {
	  	var ischecked = $('#dispLoadFormUdateShipDate .checkboxSelect:checked').length;
	  	if(ischecked !=0){
		  	$('.hideDate').css("display","block");
		  	$('.hideStatus').css("display","block");
		  	loadboardsstatus();
	  	} else {
		  	$('.hideDate').css("display","none");
		  	$('.hideStatus').css("display","none");
	  	}
	});

	if (document.getElementById(responseUploadProcess)) {
		$('div#responseUploadProcess').on('dialogclose', function(event) {
			window.location.href=window.location.href;
		});
	}
});

function showCustomerCheckBox() {
	$('.hidecheckBox').css("display","block");
}

function hideCustomerCheckBox() {
	$('.hidecheckBox').css("display","none");
	$('#customerCheck').prop('checked', true);
}

function showcheckBoxGroup() {
	$('.hidecheckBoxGroup').css("display","block");
	$('#customerCheckGroup').prop('checked', true);
}

function hidecheckBoxGroup() {
	$('.hidecheckBoxGroup').css("display","none");
	$('#customerCheckGroup').prop('checked', true);
}

function loadboardsstatus() {
	var loadstatus=$('#loadStatusUpdate').val();
	if(loadstatus == 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44') {
		$("#postToIts").prop("disabled", false);
		$("#postdatloadboard").prop("disabled", false);
		$("#posteverywhere").prop("disabled", false);
		$("#post123loadboard").prop("disabled", false);
	} else {
		$("#postToIts").prop("disabled", true);
		$("#postdatloadboard").prop("disabled", true);
		$("#posteverywhere").prop("disabled", true);
		$("#post123loadboard").prop("disabled", true);
	}
}

function stopInterChanging(action,loadid,dsn,stopNumber) {
	var InputChanged=$("#inputChanged").val();
	if(InputChanged==1){
		$("#dialog-confirm").html("Are you sure want to save the information you edited now, If Yes please click Yes otherwise No?");
		// Define the Dialog and its properties.
		$("#dialog-confirm").dialog({
			resizable: false,
			modal: true,
			title: "Confirm Box",
			height: 160,
			width: 350,
			buttons: {
				"Yes": function () {
					$(this).dialog('close');
					$("#saveLoad").click();
				},
					"No": function () {
					$(this).dialog('close');
					var path=urlComponentPath+"loadgateway.cfc?method=stopInterChanging";
					$.ajax({
						  type: "post",
						  url: path,		
						  dataType: "json",
						  async: false,
						  data: {
							  action:action,dsn:dsn,loadid:loadid,stopNumber:stopNumber
							},
						  success: function(data){
							  if (data==1){
								window.location.href=window.location.href;
							  }	
						  }
					});
				}
			}
		});
	} else if (InputChanged==0) {
		var path=urlComponentPath+"loadgateway.cfc?method=stopInterChanging";
		$.ajax({
			type: "post",
			url: path,		
			dataType: "json",
			async: false,
			data: {
			  	action:action,dsn:dsn,loadid:loadid,stopNumber:stopNumber
			},
			success: function(data){
				if (data==1){
					window.location.href=window.location.href;
				}	
			}
		});
	}
}

function getConfirmation() {
  	if(confirm("Load Manager uses the FMCSA Data API to update carrier insurance information but Load Manager is not endorsed or certified by the FMSCA. Are you ready to update this Carriers data?")){
		var dotnumber=$("#DOTNumber").val();
		var MCNumber=$("#MCNumber").val();
		var editid=$("#editid").val();
		var stoken=$("#stoken").val();
		if(dotnumber !="") {
			window.location='index.cfm?event=addcarrier&DOTNumber='+dotnumber+'&carrierid='+editid+'&apidetails=1&'+stoken+'';  
		} else if(MCNumber !=""){
			window.location='index.cfm?event=addcarrier&mcno='+MCNumber+'&carrierid='+editid+'&apidetails=1&'+stoken+''; 
		} else {
			alert('Please enter DotNumber or mc number');
			return false;
		}
  	}
}

function getsaferwatchConfirmation() {
  	if(confirm("Load Manager uses the SaferWatch API to update carrier insurance information but Load Manager is not endorsed or certified by the SaferWatch. Are you ready to update this Carriers data?")){
		var dotnumber=$("#DOTNumber").val();
		var MCNumber=$("#MCNumber").val();
		var editid=$("#editid").val();
		var stoken=$("#stoken").val();
		if(dotnumber !="") {
			window.location='index.cfm?event=addcarrier&DOTNumber='+dotnumber+'&carrierid='+editid+'&saferWatchUpdate=1&'+stoken+'';  
		} else if(MCNumber !=""){
			window.location='index.cfm?event=addcarrier&mcno='+MCNumber+'&carrierid='+editid+'&saferWatchUpdate=1&'+stoken+''; 
		} else {
			alert('Please enter DotNumber or mc number');
			return false;
		}
  	}
}

/*function to remove values in inuseby field*/
function removeEditAccess(loadid){
	var dsn =$("#appDsn").val();
	var path=urlComponentPath+"loadgateway.cfc?method=removeUserAccessOnLoad";
		$.ajax({
			type: "post",
			url: path,		
			dataType: "json",
			async: false,
			data: {
			  	dsn:dsn,loadid:loadid
			},
			success: function(data){
				//alert('Administrator has removed load editing permission of '+data.userName+''+data.onDateTime+' for load '+data.loadnumber);
				alert('The load editing lock for load# '+data.loadnumber+' has been removed');
				window.location = 'index.cfm?event=load';
			
			}
		});
}	