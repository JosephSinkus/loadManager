


  // Arrays for the origins and destinations inputs
  var origins = new Array();
  var destinations = new Array();
 
  // Initial query parameters
  var query = {
    travelMode: "DRIVING",
    unitSystem: 1
  };

  
  // Google Distance Matrix Service 
  var dms;

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
  
  /*
   * Retrieves origins and destinations from textareas and
   * determines how to build the entire matrix within query limitations
   */
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
  
  /*
   * Updates the query based on the known sizes of origins and destinations
   */
  function updateQuery(){
    if(origins.length * destinations.length < QUERY_LIMIT && originsLimit < 25){
        query.origins = origins;
    }else{
        query.origins = origins.slice(originsLimit*originsInterval,originsLimit*(originsInterval+1));
    }
	originsInterval  = 0;
  } 
  
  /*
   * Initializes the matrix data and pulls the first set of near 100 results
   */
  function matrixInit(shipperAddress, consigneeAddress,stopid, callFrom){
    dms = new google.maps.DistanceMatrixService();
    getInputs(shipperAddress, consigneeAddress);
    updateMatrix(stopid, callFrom);
  } 
  
  /*
   * Accepts rows and populates table content.  Error validation is limited to the "ZERO_RESULTS"
   * return status.  originsLimit and originsInterval are used to find the correct table cell.
   */
  function extractDistances(rows,stopid, callFrom) {
	  if(document.getElementById("milesUpdateMode"+stopid) != null && document.getElementById("milesUpdateMode"+stopid).value != "auto" && callFrom != "callFromRefreshButton")
	  	return;
	  
    for (var i = 0; i < rows.length; i++) {
      for (var j = 0; j < rows[i].elements.length; j++) {
        if(rows[i].elements[j].status != "ZERO_RESULTS"){
			if(rows[i].elements[j].distance == undefined)
			{
				distance = "0";
				if(stopid=="")
					alert("System cannot calculate the miles for Stop1 because the address is not recognised");
				else
					alert("System cannot calculate the miles for Stop"+stopid+" because the address is not recognised");
			}
			else
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
		
		
		if(document.getElementById("milse"+stopid) != null)
		{
		  document.getElementById("milse"+stopid).value = distance;
		  document.getElementById("milse"+stopid).onchange();
		}
		if(document.getElementById('calculatedMiles') != null){
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
  
function updatedMilesWithLongShort(DSN, UserName){
	var milseFromGoogle = getFloat(document.getElementById('calculatedMiles').value);
	
	var longMiles = getFloat(document.getElementById('longMiles').value);
	var shortMiles = getFloat(document.getElementById('shortMiles').value);	
	
	
	var customerMiles = milseFromGoogle + ((milseFromGoogle/100)*longMiles);
	var carrierMiles = milseFromGoogle - ((milseFromGoogle/100)*shortMiles);
	
	document.getElementById('customerMiles').value = (customerMiles).toFixed(2);
	document.getElementById('carrierMiles').value = (carrierMiles).toFixed(2);
	
	var customerRatePerMile = getFloat(document.getElementById('customerRate').value);
	var carrierRatePerMile = getFloat(document.getElementById('carrierRate').value);
	
	document.getElementById('customerAmount').value = (customerMiles * customerRatePerMile).toFixed(2);
	document.getElementById('carrierAmount').value = (carrierMiles * carrierRatePerMile).toFixed(2);
	
	addQuickCalcInfoToLog(DSN,UserName);
}


  //////////////////////////////////////////////////////////

// Get Customer Info using Coldfusion AJAX

var chkLoad=0;
function checkUnload()
{
	chkLoad = 1;
}

function customerRatePerMileChanged(){
	var totalMiles = document.getElementById('CustomerMilesCalc').value;
	var customerRatePerMile = document.getElementById('CustomerRatePerMile').value;
	
	customerRatePerMile = customerRatePerMile.replace("$","");
	customerRatePerMile = customerRatePerMile.replace(/,/g,"");
	
	
	if(isNaN(customerRatePerMile))
	{
		alert("Please enter a valid Rate");
		document.getElementById('CustomerRatePerMile').value="$0";
		document.getElementById('CustomerMiles').value = "$0";
		document.getElementById('CustomerMilesTotalAmount').value =  "$0";
		updateTotalAndProfitFields();
	}
	else
	{
		var customerRatePerMileFloat = parseFloat(customerRatePerMile);
		var totalMilesAmount = (customerRatePerMileFloat*totalMiles).toFixed(2);
		document.getElementById('CustomerMiles').value = "$"+totalMilesAmount;
		document.getElementById('CustomerMilesTotalAmount').value =  "$"+totalMilesAmount;
		updateTotalAndProfitFields();
	}
}

function carrierRatePerMileChanged(){
	var totalMiles = document.getElementById('CarrierMilesCalc').value;
	var carrierRatePerMile = document.getElementById('CarrierRatePerMile').value;
	
	carrierRatePerMile = carrierRatePerMile.replace("$","");
	carrierRatePerMile = carrierRatePerMile.replace(/,/g,"");
	
	if(isNaN(carrierRatePerMile))
	{
		alert("Please enter a valid Rate");
		document.getElementById('CarrierRatePerMile').value="$0";
		document.getElementById('CarrierMiles').value = "$0";
		document.getElementById('CarrierMilesTotalAmount').value =  "$0";
		updateTotalAndProfitFields();
	}
	else{
		var carrierRatePerMileFloat = parseFloat(carrierRatePerMile);
		var totalMilesAmount = (carrierRatePerMileFloat*totalMiles).toFixed(2);
		document.getElementById('CarrierMiles').value = "$"+totalMilesAmount;
		document.getElementById('CarrierMilesTotalAmount').value = "$"+totalMilesAmount;
		updateTotalAndProfitFields();
	}
}

function addressChanged(stopid, callFrom){
	
	var shipperAddress="";
	if(stopid != '')
	{
		var prevStopId = stopid-1;
		if(prevStopId == 1){prevStopId=""}
		
		//var elemShipperCurrentStop = document.getElementById("Shipper"+(stopid));
		//var elemShipperPrevStop = document.getElementById("Shipper"+(prevStopId));
		
		
		var shipperAddressCurrentStop = $('#shipperlocation'+stopid).val();
		var shipperAddressPrevStop = $('#shipperlocation'+prevStopId).val();
		if( shipperAddressCurrentStop = shipperAddressPrevStop )
		{
			// In this case consider previous consignee's address as the shipper address for miles calculation
			shipperAddress = trim(document.getElementById("consigneelocation"+(prevStopId)).value);
			shipperAddress += "+" + trim(document.getElementById("consigneecity"+(prevStopId)).value);
			var elem = document.getElementById("consigneestate"+(prevStopId));
			if(trim(elem.options[elem.selectedIndex].text) != "Select")
				shipperAddress += "+" + trim(elem.options[elem.selectedIndex].text);
		}
	}
	
	if(trim(shipperAddress) == "")
	{
		shipperAddress = trim(document.getElementById("shipperlocation"+stopid).value);
		
		if(trim(document.getElementById("shipperlocation"+stopid).value) == "")
		return;
		
		shipperAddress += "+" + trim(document.getElementById("shippercity"+stopid).value);
		var e = document.getElementById("shipperstate"+stopid);
		if(trim(e.options[e.selectedIndex].text) != "Select")
			shipperAddress += "+" + trim(e.options[e.selectedIndex].text);
	}
	
	
	
	var consigneeAddress = document.getElementById("consigneelocation"+stopid).value;
	if(trim(document.getElementById("consigneelocation"+stopid).value) == "")
		return;
		
	consigneeAddress += "+" + trim(document.getElementById("consigneecity"+stopid).value);
	e = document.getElementById("consigneestate"+stopid);
	if(trim(e.options[e.selectedIndex].text) != "Select")
		consigneeAddress += "+" + trim(e.options[e.selectedIndex].text);
	
	shipperAddress = prepareAddressForGoogleApi(shipperAddress);
	
	consigneeAddress = prepareAddressForGoogleApi(consigneeAddress);
	
	matrixInit(shipperAddress,consigneeAddress,stopid, callFrom);
	
}

function prepareAddressForGoogleApi(str){
	var strToRet=str;
	strToRet = strToRet.replace(/, /g,'+');
	strToRet = strToRet.replace(/,/g,'+');
	strToRet = strToRet.replace(/ /g,'+');
	strToRet = strToRet.replace(/\n/g,'+');
	return strToRet;
}

function calculateDist(addressField1, addressField2){
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
	//if(add2 == "")
	//	return;
	e = document.getElementById("shipperstate");
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


function getCutomerForm(custID,aDsn,urltoken)
{
	//debugger
	document.getElementById('customerID').value=custID;
	var loadCustomer = new ajaxLoadCutomer();
	var newCustomerFrm1 = loadCustomer.getAjaxLoadCustomerInfo1(aDsn,custID,urltoken);
	var newCustomerFrm2 = loadCustomer.getAjaxLoadCustomerInfo2(aDsn,custID);
	
	document.getElementById('CustInfo1').innerHTML = newCustomerFrm1;
	document.getElementById('CustInfo2').innerHTML = newCustomerFrm2;
	
}

function tablePrevPage(formName){
	if(parseInt(document.getElementById('pageNo').value)>1)
	{
		document.getElementById('pageNo').value = parseInt(document.getElementById('pageNo').value)-1;
		document.forms(formName).submit();
	}
}

function refreshMilesClicked(stopid){
	addressChanged(stopid,"callFromRefreshButton");
}


function getCommissionReport(URLToken){
	var url = "&";
	url += document.getElementById('salesAgent').checked ? "groupBy=salesAgent":"groupBy=dispatcher";
	url += "&orderDateFrom="+document.getElementById('dateFrom').value;
	url += "&orderDateTo="+document.getElementById('dateTo').value;
	url += "&deductionPercentage="+getFloat(document.getElementById('deductionPercent').value);
	url += "&commissionPercentage="+getFloat(document.getElementById('commissionPercent').value);
	
	var e = document.getElementById("salesRepFrom");
	url += "&salesRepFrom="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("salesRepTo");
	url += "&salesRepTo="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("dispatcherFrom");
	url += "&dispatcherFrom="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("dispatcherTo");
	url += "&dispatcherTo="+trim(e.options[e.selectedIndex].text);
	
	e = document.getElementById("reportType");
	url += "&reportType="+trim(e.options[e.selectedIndex].text);
	
	url += "&marginRangeFrom="+getFloat(document.getElementById('marginFrom').value);
	url += "&marginRangeTo="+getFloat(document.getElementById('marginTo').value);
	

	//Status Loads From To
	e = document.getElementById("StatusTo");
	url += "&StatusTo="+trim(e.options[e.selectedIndex].text);
	
	//Status Loads From To
	e = document.getElementById("StatusFrom");
	url += "&StatusFrom="+trim(e.options[e.selectedIndex].text);
	
	url = url.replace(/####/g,'AAAA');
	window.open('index.cfm?event=loadCommissionReport'+url+'&'+URLToken);
}

function getAndUpdateLongShortMilesFields(dsn){
	var arrLongShorMiles = getLongShortMiles(dsn);
	document.getElementById('longMiles').value = arrLongShorMiles[0];
	document.getElementById('shortMiles').value = arrLongShorMiles[1];
}

function getLongShortMiles(dsn){
	var loadCustomer = new ajaxLoadCutomer();
	var arrLongShortMiles = loadCustomer.getLongShortMiles(dsn);
	return arrLongShortMiles; // Long is on Index0; Short is on Index1
}

function saveSystemSetupOptions(dsn){
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

function runSaveSystemSetupOptions(dsn, longMiles, shortMiles, deductionPercentage, ARAndAPExportStatusID,showExpCarriers){
	var loadCustomer = new ajaxLoadCutomer();
	var recordsEffetced = loadCustomer.setSystemSetupOptions(dsn, longMiles, shortMiles, deductionPercentage, ARAndAPExportStatusID,showExpCarriers);
	
	return parseFloat(recordsEffetced);
}

function EnableDisableForm(xForm,flag){
	objElems = xForm.elements;
	for(i=0;i<objElems.length;i++){
		objElems[i].disabled = flag;
	}
}

function tableNextPage(formName){
	if(document.getElementById('message') == null || (document.getElementById('message') != null && document.getElementById('message').innerHTML != "No match found") ) 
	{
		document.getElementById('pageNo').value = parseInt(document.getElementById('pageNo').value)+1;
		document.forms(formName).submit();
	}
	if(formName == 'dispLoadForm' && document.getElementById('message').style.display != 'block')
	{
		document.getElementById('pageNo').value = parseInt(document.getElementById('pageNo').value)+1;
		document.forms(formName).submit();
	}
	// else No Further results
}

function showErrorMessage(flag){
	document.getElementById('message').style.display = flag;
}

function clearPreviousSearchHiddenFields(){
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


function sortTableBy(fieldName, formName){
	if(document.getElementById('sortBy').value == fieldName)
	{
		if(document.getElementById('sortOrder').value == "ASC")
			document.getElementById('sortOrder').value = "DESC"
		else if(document.getElementById('sortOrder').value == "DESC")
			document.getElementById('sortOrder').value = "ASC"
	}
	document.getElementById('sortBy').value = fieldName;
	document.forms(formName).submit();
}

function showWarningEnableButton(flagWarning, stopid){
	document.getElementById('milesUpdateMode'+stopid).value = "manual";
	document.getElementById('warning'+stopid).style.display =flagWarning;
	if(flagWarning == "block")
		document.getElementById('refreshBtn'+stopid).disabled = false;
}

// Get customer Sales Persion and Dispatcher.
function getCutomerSalesPerson(custID,aDsn)
{
	//debugger
	var loadCustomer = new ajaxLoadCutomer();	
	var newCustomerSalesPerson_dispatacher = loadCustomer.getAjaxLoadSalesperson_Dispatcher(aDsn,custID);
	if (newCustomerSalesPerson_dispatacher[0] == '')
		{
			alert('Sale Person is Inactive');
			document.getElementById('slsP').style.display ='block';
			document.getElementById('slsP').innerHTML ='Sales Person is Inactive';
		}	
		
	document.getElementById('Salesperson').value = newCustomerSalesPerson_dispatacher[0];
	document.getElementById('Dispatcher').value = newCustomerSalesPerson_dispatacher[1];
	
}

// Get Shipper Info using Coldfusion AJAX
function getShipperForm(shipperID,aDsn)
{
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
	//document.getElementById('shipperPickupNo1').value = newShipperFrm[9];
//	//document.getElementById('shipperPickupDate').value = newShipperFrm[10];
//	document.getElementById('shipperPickupDate').value ="";
//	//document.getElementById('shipperpickupTime').value = newShipperFrm[11];
//	document.getElementById('shipperTimeIn').value = newShipperFrm[12];
//	document.getElementById('shipperTimeOut').value = newShipperFrm[13];
//	if (newShipperFrm[14])
//	document.getElementById('shipBlind').checked = true;
//	document.getElementById('shipperNotes').value = newShipperFrm[15];
//	document.getElementById('shipperDirection').value = newShipperFrm[16];
	//document.getElementById('ShipperInfo').innerHTML = newShipperFrm;
	
}

function getShipperFormNext(shipperID,aDsn,stopid)
{
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
	//document.getElementById('shipperPickupNo1'+stopid).value = newShipperFrm[9];
//	//document.getElementById('shipperPickupDate'+stopid).value = newShipperFrm[10];
//	document.getElementById('shipperPickupDate'+stopid).value ="";
//	//document.getElementById('shipperpickupTime'+stopid).value = newShipperFrm[11];
//	document.getElementById('shipperTimeIn'+stopid).value = newShipperFrm[12];
//	document.getElementById('shipperTimeOut'+stopid).value = newShipperFrm[13];
//	if (newShipperFrm[14])
//	document.getElementById('shipBlind'+stopid).checked = true;
//	document.getElementById('shipperNotes'+stopid).value = newShipperFrm[15];
//	document.getElementById('shipperDirection'+stopid).value = newShipperFrm[16];
	
	//document.getElementById('ShipperInfo').innerHTML = newShipperFrm;
	
}

// Get Consignee Info using Coldfusion AJAX
function getConsigneeForm(consigneeID,aDsn,frm)
{
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
	//document.getElementById('consigneePickupNo').value = newConsigneeFrm[9];
//	//document.getElementById('consigneePickupDate').value = newConsigneeFrm[10];
//	document.getElementById('consigneePickupDate').value = "";
//	//document.getElementById('consigneepickupTime').value = newConsigneeFrm[11];
//	document.getElementById('consigneeTimeIn').value = newConsigneeFrm[12];
//	document.getElementById('consigneeTimeOut').value = newConsigneeFrm[13];
//	if (newConsigneeFrm[14])
//	document.getElementById('ConsBlind').checked = true;
//	document.getElementById('consigneeNotes').value = newConsigneeFrm[15];
//	document.getElementById('consigneeDirection').value = newConsigneeFrm[16];
	
	getLongitudeLatitude(frm);
	ClaculateDistance(frm);
	
	//document.getElementById('ConsigneeInfo').innerHTML = newConsigneeFrm;
	
}

function getConsigneeFormNext(consigneeID,aDsn,stopid)
{
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
	//document.getElementById('consigneePickupNo'+stopid).value = newConsigneeFrm[9];
//	//document.getElementById('consigneePickupDate'+stopid).value = newConsigneeFrm[10];
//	//document.getElementById('consigneepickupTime'+stopid).value = newConsigneeFrm[11];
//	document.getElementById('consigneeTimeIn'+stopid).value = newConsigneeFrm[12];
//	document.getElementById('consigneeTimeOut'+stopid).value = newConsigneeFrm[13];
//	if (newConsigneeFrm[14])
//	document.getElementById('ConsBlind'+stopid).checked = true;
//	document.getElementById('consigneeNotes'+stopid).value = newConsigneeFrm[15];
//	document.getElementById('consigneeDirection'+stopid).value = newConsigneeFrm[16];
	
	
	//document.getElementById('ConsigneeInfo').innerHTML = newConsigneeFrm;
	
}

// Get Carrier List Info using Coldfusion AJAX
function getFilterCarrierByString(aDsn,stopid)
{
	var filterString = document.getElementById('selectedCarrierValue'+stopid).value;
	
	var loadFilterCarrier = new ajaxLoadCutomer();
	
	var newFilterList = loadFilterCarrier.getAjaxCarrierlistByString(aDsn,filterString);
	document.getElementById('carrierList'+stopid).innerHTML = newFilterList;
	
}

// Get Carrier List Info using Coldfusion AJAX
function getFilterCarrier(filterChar,aDsn)
{
	var loadFilterCarrier = new ajaxLoadCutomer();	
	
	var newFilterList = loadFilterCarrier.getAjaxCarrierlist(aDsn,filterChar);
	document.getElementById('carrierList').innerHTML = newFilterList;
	
}

function getFilterCarrierNext(filterChar,aDsn,stopid)
{
	var loadFilterCarrier = new ajaxLoadCutomer();	
	
	var newFilterList = loadFilterCarrier.getAjaxCarrierlistNext(aDsn,filterChar,stopid);
	document.getElementById('carrierList'+stopid).innerHTML = newFilterList;
	
}

// Open Choose carrier
function chooseCarrier()
{
		document.getElementById("selectedCarrierValue").value = '';
		document.getElementById("CarrierInfo").style.display = 'none';
		document.getElementById('choosCarrier').style.display = 'block';
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


function chooseCarrierNext(stopid)
{
		document.getElementById("selectedCarrierValue"+stopid).value = '';
		document.getElementById("CarrierInfo"+stopid).style.display = 'none';
		document.getElementById('choosCarrier'+stopid).style.display = 'block';
	
}

// Go for edit carrier
function editCarrier(url)
{
	var carrId = document.getElementById("carrierID").value; 
	if (carrId == '')
	{
		alert('Please select a carrier');
		return false;	
	}
	else
	{
	location.href=url + '&carrierid=' + carrId; 
	}
}

function editCarrierNext(url,stopid)
{
	var carrId = document.getElementById("carrierID"+stopid).value; 
	if (carrId == '')
	{
		alert('Please select a carrier');
		return false;	
	}
	else
	{
	location.href=url + '&carrierid=' + carrId; 
	}
}

function useCarrier(aDsn,lFlag,urltoken)
{

	var carrId = document.getElementById("carrierID").value; 
	if (carrId == '')
	{
		if (lFlag == 1){
		alert('Please select a carrier');
		return false;
		}	
	}
	else
	{
		document.getElementById("CarrierInfo").style.display = 'block';
		document.getElementById('choosCarrier').style.display = 'none';
		var loadCarrierInfo = new ajaxLoadCutomer();	
		
		var newCarrierFrm = loadCarrierInfo.getAjaxCarrierInfoForm(aDsn,carrId,urltoken);
		document.getElementById('CarrierInfo').innerHTML = newCarrierFrm;
	}
	
}

function useCarrierNext(aDsn,lFlag,stopid,urltoken)
{
	var carrId = document.getElementById("carrierID"+stopid).value; 
	if (carrId == '')
	{
		if (lFlag == 1){
		alert('Please select a carrier');
		return false;
		}	
	}
	else
	{
		document.getElementById("CarrierInfo"+stopid).style.display = 'block';
		document.getElementById('choosCarrier'+stopid).style.display = 'none';
		var loadCarrierInfo = new ajaxLoadCutomer();	
		
		var newCarrierFrm = loadCarrierInfo.getAjaxCarrierInfoFormNext(aDsn,carrId,stopid,urltoken);
		document.getElementById('CarrierInfo'+stopid).innerHTML = newCarrierFrm;
	}
	
}

function noCarrier()
{
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

function noCarrierNext(stopNo)
{
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

function checkForFee(unitId,itemRowNo,stopNo,aDsn)
{
	var isfree = false;
	var loadCheckFee = new ajaxLoadCutomer();	
	retValue = loadCheckFee.checkFeeUnit(aDsn,unitId);
	
	isfree = retValue.split(',')[0];
	
	frmfld = document.getElementById('isFee'+itemRowNo+''+stopNo);
	
	if (isfree == 'true')
		frmfld.checked = true;
	else
		frmfld.checked = false;
		
	document.getElementById('description'+itemRowNo+''+stopNo).value = retValue.split(',')[1];
	document.getElementById('custCharges'+itemRowNo+''+stopNo).focus();
}

function DisplayIntextField(fldVal,dsn)
{
	//var w = document.load.filterList.selectedIndex;
	//document.getElementById("selectedCarrierValue").value = document.load.filterList.options[w].text;
	//document.getElementById("selectedCarrierValue").value = fldTxt;
	
	var loadCarrierOffice = new ajaxLoadCutomer();	
	var newCarrierOffice = loadCarrierOffice.getSatelliteOfficeBindable(fldVal,dsn);
	var k;
	for(k=document.getElementById("stOffice").options.length-1;k>=0;k--)
	{
		document.getElementById("stOffice").remove(k);
	}
	
	for (var j=0;j<newCarrierOffice.length;j++)
	{
		var optn = document.createElement("OPTION");
		optn.text = newCarrierOffice[j][1];
		optn.value = newCarrierOffice[j][0];
		document.getElementById("stOffice").options.add(optn);
	}

	document.getElementById("carrierID").value = fldVal;
}

function DisplayIntextFieldNext(fldVal,stopid,dsn)
{
	//var w = document.load.filterList.selectedIndex;
	//document.getElementById("selectedCarrierValue").value = document.load.filterList.options[w].text;
	//document.getElementById("selectedCarrierValue"+stopid).value = fldTxt;
	document.getElementById("carrierID"+stopid).value = fldVal;
	
	var loadCarrierOffice = new ajaxLoadCutomer();	
	var newCarrierOffice = loadCarrierOffice.getSatelliteOfficeBindable(fldVal,dsn);
	var k;
	for(k=document.getElementById("stOffice"+stopid).options.length-1;k>=0;k--)
	{
		document.getElementById("stOffice"+stopid).remove(k);
	}
	
	for (var j=0;j<newCarrierOffice.length;j++)
		{
			var optn = document.createElement("OPTION");
			optn.text = newCarrierOffice[j][1];
			optn.value = newCarrierOffice[j][0];
			document.getElementById("stOffice"+stopid).options.add(optn);
			
		}
}

function AddStop(stopName,stopid)
{
	//debugger
	document.getElementById(stopName).style.display='block';
	
	var prevStopId=stopid-1;
	if(prevStopId==1){prevStopId=""}
	
	$('#shipper'+stopid).val($('#shipper'+prevStopId).val());
	$('#shipperValueContainer'+stopid).val($('#shipperValueContainer'+prevStopId).val());
	$('#shipperName'+stopid).val($('#shipperName'+prevStopId).val());
	$('#shipperlocation'+stopid).val($('#shipperlocation'+prevStopId).val());
	$('#shippercity'+stopid).val($('#shippercity'+prevStopId).val());
	$('#shipperstate'+stopid).val($('#shipperstate'+prevStopId).val());
	$('#shipperStateName'+stopid).val($('#shipperstate'+stopid+' option:selected').text());
	$('#shipperZipcode'+stopid).val($('#shipperZipcode'+prevStopId).val());
	$('#shipperContactPerson'+stopid).val($('#shipperContactPerson'+prevStopId).val());
	$('#shipperPhone'+stopid).val($('#shipperPhone'+prevStopId).val());
	$('#shipperFax'+stopid).val($('#shipperFax'+prevStopId).val());
	$('#shipperEmail'+stopid).val($('#shipperEmail'+prevStopId).val());
	$('#shipperEmail'+stopid).val($('#shipperEmail'+prevStopId).val());
	$('#shipperNameText'+stopid).val($('#shipperNameText'+prevStopId).val());
       
	
	$('#consignee'+stopid).val($('#consignee'+prevStopId).val());
	$('#consigneeValueContainer'+stopid).val($('#consigneeValueContainer'+prevStopId).val());
	$('#consigneeName'+stopid).val($('#consigneeName'+prevStopId).val());
	$('#consigneelocation'+stopid).val($('#consigneelocation'+prevStopId).val());
	$('#consigneecity'+stopid).val($('#consigneecity'+prevStopId).val());
	$('#consigneestate'+stopid).val($('#consigneestate'+prevStopId).val());
	$('#consigneeStateName'+stopid).val($('#consigneestate'+stopid+' option:selected').text());
	$('#consigneeZipcode'+stopid).val($('#consigneeZipcode'+prevStopId).val());
	$('#consigneeContactPerson'+stopid).val($('#consigneeContactPerson'+prevStopId).val());
	$('#consigneePhone'+stopid).val($('#consigneePhone'+prevStopId).val());
	$('#consigneeFax'+stopid).val($('#consigneeFax'+prevStopId).val());
	$('#consigneeEmail'+stopid).val($('#consigneeEmail'+prevStopId).val());
	$('#consigneeEmail'+stopid).val($('#consigneeEmail'+prevStopId).val());
	 $('#consigneeNameText'+stopid).val($('#consigneeNameText'+prevStopId).val());
	addressChanged(stopid);
	document.getElementById('shipperstate'+stopid).onchange();
	
	
	if(trim($('#shipperlocation'+prevStopId).val()) == "" ||  trim($('#consigneelocation'+prevStopId).val()) == "" )
		document.getElementById("milse"+stopid).value = 0;
		
	document.getElementById("milse").onchange();
	document.getElementById('totalStop').value=stopid;
	document.getElementById('shipper'+stopid).focus();
}

function deleteStop(stopName,stopNo,flag,stopID,aDsn,loadID)
{
	var deleteYN=false;
	
	if(flag == true)
	 	{
	 		deleteYN = confirm('Are you sure to delete this stop')
	 		if (deleteYN)
	 			{
	 				var deleteStops = new ajaxLoadCutomer();
	 				var confirmDeleteStop = deleteStops.deleteStops(aDsn,stopID,stopNo,loadID);
	 					
	 				document.getElementById(stopName).style.display='none';
					document.getElementById("milse").onchange();	 									
	 			}
	 	}
	 else
	 {
		document.getElementById(stopName).style.display='none';
		document.getElementById("milse").onchange();
		
		//document.location.reload();
	 }
	 if(document.getElementById('totalStop').value==(stopNo+1))
		 document.getElementById('totalStop').value=(document.getElementById('totalStop').value-1)
	strStopLinks = "";
	for(i=1;i<=document.getElementById('totalStop').value;i++)
	{
		if(i!=(stopNo+1))
			strStopLinks = strStopLinks+"<li><a href='#StopNo"+i+"'>#"+i+"</a></li>";
	}
	for(j=1;j<=document.getElementById('totalStop').value;j++)
	{
		if(document.getElementById('ulStopNo'+j))
			document.getElementById('ulStopNo'+j).innerHTML = strStopLinks;
	}	
}


function CheckState(frmstate,frmcountry,frmroleid,frmoffice,frmtele)
{
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
	var st=frmstate.value;
	if (st == "")	{
		alert('Please select a state');
		frmstate.focus();
	 return false;
	}
	var cnt=frmcountry.value;
	if (cnt == "")	
	{
		alert('Please select a country');
		frmcountry.focus();
	 return false;

	}
	var role =frmroleid.value;
	if (role == "")	
	{
		alert('Please select an authlevel');
		frmroleid.focus();
	 return false;

	}
	var office = frmoffice.value;
	if (office == "")	
	{
		alert('Please select an Office');
		frmoffice.focus();
	 return false;

	}
	
	var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frmtele.value;
    LimitCheck = PhoneNumberInitialString.length;
   if (PhoneNumberInitialString !='')
   	{
      var FmtStr=PhoneNumberInitialString;
      if (FmtStr.length == 12)
      {      	
      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-"))      	
        FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
        else
        {
        	//alert(frmfld.value);
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frmtele.focus();
        	return false;
        }  
      }
    else
      {
        FmtStr=PhoneNumberInitialString;        
        //alert(frmfld.value);
        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        frmtele.focus();
        return false;
      }
    return true;
   }
	
}

function CheckCustomer(frmoffice,frmstate,frmcountry,frmcompany,frmlocation)
{
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
	var office=frmoffice.value;
	if (office == "")
	{
		alert('Please select an office');
		frmoffice.focus();
		return false;
	
	}
	var location=frmlocation.value;
	if(location=="")
	{
     alert('Please enter value in address field');
		frmlocation.focus();
		return false;
	}
	
	var state=frmstate.value;
	if(state=="")
	{
		alert('Please select a state');
		frmstate.focus();
		return false;
		
	}
	var country=frmcountry.value;
	if(country=="")
	{
		alert('Please select a country');
		frmcountry.focus();
		return false;
	}
	var company=frmcompany.value;
	if(company=="")
	{
		alert('Please select a company');
		frmcompany.focus();
		return false;
	}

}
function CheckStops(frmState,frmlocation)
{
	var location=frmlocation.value;
	if(location=="")
	{
		alert('Please enter the address');
		frmlocation.focus();
		return false;
		
		
	}
	var state=frmState.value;
	if(state=="")
	{
		alert('Please select a state');
		frmState.focus();
		return false;
		
	}
	
	
}

function CheckCarrier(frmaddress,frmstate,frmcountry,frmequipment)
{
	var address=frmaddress.value;
	if(address=="")
	{
		alert('Please enter the address');
		frmaddress.focus();
		return false;
		
	}
	
	var state=frmstate.value;
	if(state=="")
	{
		alert('Please select a state');
		frmstate.focus();
		return false;
		
	}
	var country=frmcountry.value;
	if(country=="")
	{
		alert('Please select a country');
		frmcountry.focus();
		return false;
	}
	var equipment=frmequipment.value;
	if(equipment=="")
	{
	    alert('Please select an equipment');
		frmequipment.focus();
		return false;	
	}
	
	
}

function CheckCarrier(frmaddress,frmstate,frmcountry,frmequipment)
{
	var setSession = new ajaxLoadCutomer();
    var confirmSession = setSession.setSession(0);
	
	var address=frmaddress.value;
	if(address=="")
	{
		alert('Please enter the address');
		frmaddress.focus();
		return false;
		
	}
	
	var state=frmstate.value;
	if(state=="")
	{
		alert('Please select a state');
		frmstate.focus();
		return false;
		
	}
	var country=frmcountry.value;
	if(country=="")
	{
		alert('Please select a country');
		frmcountry.focus();
		return false;
	}
	var equipment=frmequipment.value;
	if(equipment=="")
	{
	    alert('Please select an equipment');
		frmequipment.focus();
		return false;	
	}
	
	}
	
	
	//function exportAllLoads(){
//		var ajxHandle = new ajaxLoadCutomer();	
//		var ret = ajxHandle.exportAllLoads();
//		alert('after call: '+ret)
//	}
	
	//function sleep(milliSeconds)
//	{
//	    var startTime = new Date().getTime(); // get the current time
//    	while (new Date().getTime() < startTime + milliSeconds);
//	}
	
	var loadExported = false;
	
	function exportLoads(QBdsn, dsn, webpath, URLToken){
		if(loadExported == true)
		{
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
		
		//var url = "&dateFrom="+dateFrom;
//		url += "&dateTo="+dateTo;
//		
//		window.open('index.cfm?event=exportAllLoads'+url+'&URLToken');
		
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
	function saveButStayOnPage(loadid){
/* alert('test');*/
           var PEPcustomerKey=document.getElementById('PEPcustomerKey').value;
			var PEPsecretKey=document.getElementById('PEPsecretKey').value;
			var POSTACTION='A';
			var trucktype='AC';
			var City=document.getElementById('customerCity').value;
			var State=document.getElementById('customerState').value;
			var pickupdate=document.getElementById('consigneePickupDate').value;*/
			 
			var dataString = 'PEPsecretKey='+ PEPsecretKey + '&PEPcustomerKey=' + PEPcustomerKey + '&City=' + City + '&State=' + State + '&pickupdate=' + pickupdate + '&POSTACTION=' + POSTACTION + '&trucktype=' + trucktype;  
 if(document.getElementById("posttoloadboard").checked)
 {
			$.ajax({ 
			 async:false,
			  type: "POST",  
			  url: "loadgateway.cfc",  
			  data: dataString,
			  method:'Posteverywhere';
			  success: function(response) 
			  {  
				  alert(response);
				   if(checkLoad())
					{
						document.getElementById('loadToSaveWithoutExit').value = loadid;
						return true;
					}
					return false; 
			});
 }
		else
		{
		 if(checkLoad())
		{
		  	document.getElementById('loadToSaveWithoutExit').value = loadid;
			return true;
		}
		return false; 
	}
	
	function saveButExitPage(loadid){
		 
	  window.location='index.cfm?event=myLoad'; 
		if(checkLoad())
		{ 
			document.getElementById('loadToSaveAndExit').value = loadid;
			return true;
			
		 
		}
		 
		return false;

	}
	
	function saveButStayOnPage_filterCarrier(loadid){
		if(checkLoad())
		{
			document.getElementById('loadToSaveWithoutExit').value = loadid;
			document.getElementById('loadToCarrierFilter').value = 'true';
			
			var url = document.getElementById('equipment').value+'&consigneecity='+document.getElementById('consigneecity').value+'&consigneestate='+document.getElementById('consigneestate').value+'&consigneeZipcode='+document.getElementById('consigneeZipcode').value+'&shippercity='+document.getElementById('shippercity').value+'&shipperstate='+document.getElementById('shipperstate').value+'&shipperZipcode='+document.getElementById('shipperZipcode').value;
			
			document.getElementById('loadToCarrierURL').value = url;
			//alert(document.getElementById('loadToCarrierURL').value);
			return true;
		}
		return false;
	}
	
  function checkLoad()
  {
	  //debugger
	enableDisableMainCalcFields(false);
  	var setSession = new ajaxLoadCutomer();

	try{
		setSession.setSession(0);
	}catch(e){}

	var status1= document.getElementById('loadStatus').value;
	if(status1=="")
	{
		alert('Please select the load status type');
		loadStatus.focus();
		enableDisableMainCalcFields(true);
		return false;
	}
	var sales= document.getElementById('Salesperson').value;
	if(sales=="")
	{
		alert('Please select a sales person');
		Salesperson.focus();
		enableDisableMainCalcFields(true);  
		return false;
	}
	var disp= document.getElementById('Dispatcher').value;
	if(disp=="")
	{
		alert('Please select a Dispatcher');
		Dispatcher.focus();
		enableDisableMainCalcFields(true);
		return false;
	}
	
	var custId=document.getElementById("cutomerIdAuto").value;
	var custIdContainer=document.getElementById("cutomerIdAutoValueContainer").value;
	//var custId=customerID.value;
	if(custId=="" || custIdContainer=="")
	{
		alert('Please select a valid customer');
		document.getElementById('cutomerIdAuto').focus();
		enableDisableMainCalcFields(true);
		return false;
	}
	
	var chkProcess = true;
	var stopid=1;
	var toStop = document.getElementById('totalStop').value;
	
	
	for (stopid=1;stopid<=toStop;stopid++)
	{
		if(stopid == 1)
			chkProcess = checkLoadNext('');
		else
			chkProcess = checkLoadNext(stopid);
			
		if(!chkProcess && chkProcess != undefined){
			enableDisableMainCalcFields(true);
			return false;
		}
	}
	return true;
	
	}
	
	
	
function checkLoadNext(stopid)
{
	if(stopid == 0)
		stopidForMessage = '1';
	else
		stopidForMessage = stopid;

	enableDisableMainCalcFields(false);
  	var shipperName=document.getElementById('shipperName'+stopid).value;
	var shipperTitle=document.getElementById('shipper'+stopid).value;
	var shipperIDContainer=document.getElementById('shipperValueContainer'+stopid).value;
	if(shipperName=="" &&( shipperIDContainer=="" || shipperTitle==""))
	{
	    alert('Please enter a valid Shipper for stop '+stopidForMessage);
	    document.getElementById('shipper'+stopid).focus();
		enableDisableMainCalcFields(true);
		return false;
	}
	
	if(document.getElementById('shipperstate'+stopid).value =="")
	{
		document.getElementById('shipperstate'+stopid).focus();
	    alert('Please select Shipper state for stop '+stopidForMessage);
		enableDisableMainCalcFields(true);
		return false;
	}
	
	var shipperPickupDate=document.getElementById('shipperPickupDate'+stopid).value;
	if(shipperPickupDate=="")
	{
		document.getElementById('shipperPickupDate'+stopid).focus();
	    alert('Please enter pickup date for stop '+stopidForMessage);
		enableDisableMainCalcFields(true);
		return false;	
	}
	
	var consigneeName=document.getElementById('consigneeName'+stopid).value;
	var consigneeTitle=document.getElementById('consignee'+stopid).value;
	var consigneeIDContainer=document.getElementById('consigneeValueContainer'+stopid).value;
	if(consigneeName==""  &&(consigneeIDContainer=="" || consigneeTitle==""))
	{
		document.getElementById('consignee'+stopid).focus();
	    alert('Please enter a valid Consignee for stop '+stopidForMessage);
		enableDisableMainCalcFields(true);
		return false;	
	}
	
	if(document.getElementById('consigneestate'+stopid).value =="")
	{
		document.getElementById('consigneestate'+stopid).focus();
	    alert('Please select  Consignee state for stop '+stopidForMessage);
		enableDisableMainCalcFields(true);
		return false;	
	}
	
	var consigneeDeliveryDate = document.getElementById('consigneePickupDate'+stopid).value;
	if(consigneeDeliveryDate=="")
	{
		document.getElementById('consigneePickupDate'+stopid).focus();
	    alert('Please enter Consignee pickup date for stop '+stopidForMessage);
		enableDisableMainCalcFields(true);
		return false;	
	}
	return true;
  }	
	
	
	
function ParseUSNumber(PhoneNumberInitialString,frmfld)
  {
    var FmtStr="";
    var index = 0;
    var LimitCheck;
    LimitCheck = PhoneNumberInitialString.length;
   if (PhoneNumberInitialString !='')
   	{
      var FmtStr=PhoneNumberInitialString;
      if (FmtStr.length == 12)
      {      	
      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-"))      	
        FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
        else
        {
        	//alert(frmfld.value);
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frmfld.focus();
        	return false;
        }  
      }
    else
      {
        FmtStr=PhoneNumberInitialString;        
        //alert(frmfld.value);
        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        frmfld.focus();
        return false;
      }
    return false;
   }
  }
 
function validateAgent(frm,dsn,flag)
{
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
	var agentName = frm.FA_name.value;
	if (agentName == '')
		{
			alert('Please enter the Agent Name');
			frm.FA_name.focus();
			return false;
		} 
		
	var agentaddress=frm.address.value;
	if(agentaddress == '')
	{
		alert('Please enter the Agent Address');
		frm.address.focus();
		return false;
	}
	var agentcity=frm.city.value;
	if(agentcity == '')
	{
		alert('Please enter the Agent City');
		frm.city.focus();
		return false;
	}
	var state=frm.state.value;
	if(state=="")	
	{
		alert('Please select a state');
		frm.state.focus();
		return false;
	}	
	var zip=frm.Zipcode.value;
	if(zip=='')	
	{
		alert('Please enter the Agent Zipcode');
		frm.Zipcode.focus();
		return false;
	}	
	var agentcountry=frm.country.value;
	if(agentcountry=="")	
	{
		alert('Please select a country');
		frm.country.focus();
		return false;
	}
	var emailid=frm.FA_email.value;
	if(emailid=='')	
	{
		alert('Please enter a valid EmailId');
		frm.FA_email.focus();
		return false;
	}		
	var login=frm.loginid.value;
	if(login=="")	
	{
		alert('Please enter the Agent Login');
		frm.loginid.focus();
		return false;
	}
	
	if (flag == 1){	
	var validLogin = checkLogin(login,dsn);
	if (validLogin == false)
		{
			return false;
		}
	}
	var password=frm.FA_password.value;	
	if(password=="")	
	{
		alert('Please enter the Agent Password');
		frm.FA_password.focus();
		return false;
	}
	var authlevel=frm.FA_roleid.value;
	
	if(authlevel=="")	
	{
		alert('Please select an Auth Level');
		frm.FA_roleid.focus();
		return false;
	}	
	var office=frm.FA_office.value;
	if(office=="")	
	{
		alert('Please select an Office');
		frm.FA_office.focus();
		return false;
	}	
	
	var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.tel.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   if (PhoneNumberInitialString !='')
   	{
      var FmtStr=PhoneNumberInitialString;
      if (FmtStr.length == 12)
      {      	
      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-"))      	
        FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
        else
        {
        	//alert(frmfld.value);
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frm.tel.focus();
        	return false;
        }  
      }
    else
      {
        FmtStr=PhoneNumberInitialString;        
        //alert(frmfld.value);
        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        frm.tel.focus();
        return false;
      }
   }
	
	
	
}
function validateOffices(frm)
{
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
 var code=frm.officeCode.value;
 if(code=='')	
	{
		alert('Please enter the Office Code');
		frm.officeCode.focus();
		return false;
	}
 var loc=frm.Location.value;
 if(loc=='')	
	{
		alert('Please enter the Office Location');
		frm.Location.focus();
		return false;
	}
	
	
 var manager=frm.adminManager.value;
 if(manager=='')	
	{
		alert('Please enter the Admin Manager');
		frm.adminManager.focus();
		return false;
	}
	
	 var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.contactNo.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   if (PhoneNumberInitialString !='')
   	{
      var FmtStr=PhoneNumberInitialString;
      if (FmtStr.length == 12)
      {      	
      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-"))      	
        FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
        else
        {
        	//alert(frmfld.value);
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frm.contactNo.focus();
        	return false;
        }  
      }
    else
      {
        FmtStr=PhoneNumberInitialString;        
        //alert(frmfld.value);
        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        frm.contactNo.focus();
        return false;
      }
    return true;
   }
 
 var contact=frm.contactNo.value;
 if(contact=='')	
	{
		alert('Please enter the Contact Number');
		frm.contactNo.focus();
		return false;
	}
 var fax=frm.faxno.value;
 if(fax=='')	
	{
		alert('Please enter the Fax Number');
		frm.faxno.focus();
		return false;
	}	
var email=frm.emailID.value;
if(email=='')
{
	    alert('Please enter a valid EmailId');
		frm.emailID.focus();
		return false;
}		
	
	
}
function validateCustomer(frm)
{

var code=frm.CustomerCode.value;
 if(code=='')	
	{
		alert('Please enter the Customer Code');
		frm.CustomerCode.focus();
		return false;
	}
 var custname=frm.CustomerName.value;
 if(custname=='')	
	{
		alert('Please enter the Customer Name');
		frm.CustomerName.focus();
		return false;
	}
	
 var office=frm.OfficeID1.value;
 if(office=="")	
	{
		alert('Please select an Office');
		frm.OfficeID1.focus();
		return false;
	}
	
 	
 var address=frm.Location.value;
 if(address=='')
 {
		alert('Please enter the Customer Address');
		frm.Location.focus();
		return false;
 	
 }
 var custcity=frm.City.value;
 if(custcity=='')
 {
 	alert('Please enter the Customer city');
	frm.City.focus();
	return false;
 }
 var custstate=frm.state1.value;
 if(custstate=="")
 {
 	alert('Please select a State');
	frm.state1.focus();
	return false;
 }
 var zip=frm.Zipcode.value;
 if(zip=='')
 {
 	alert('Please enter the Zipcode');
	frm.Zipcode.focus();
	return false;
 }
 var country=frm.country1.value;
 if(country=="")
 {
 	alert('Please select a Country');
	frm.country1.focus();
	return false;
 }
 
    var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.PhoneNO.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   if (PhoneNumberInitialString !='')
   	{
      var FmtStr=PhoneNumberInitialString;
      if (FmtStr.length == 12)
      {      	
      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-"))      	
        FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
        else
        {
        	//alert(frmfld.value);
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frm.PhoneNO.focus();
        	return false;
        }  
      }
    else
      {
        FmtStr=PhoneNumberInitialString;        
        //alert(frmfld.value);
        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        frm.PhoneNO.focus();
        return false;
      }
    //return true;
   }
   
/*var emailid=frm.Email.value;
if(emailid=='')
{
	    alert('Please enter a valid EmailId');
		frm.Email.focus();
		return false;
}*/

var company=frm.CompanyID1.value;
if(company=='')
{
	alert('Please select a company');
	frm.CompanyID1.focus();
	return false;
}	

return true;
}
function validateStop(frm)
{
	var setSession = new ajaxLoadCutomer();
	var confirmSession = setSession.setSession(0);
	
var stopname=frm.CustomerStopName.value;
if(stopname=='')
{
	alert('Please enter the Customer Stop Name');
	frm.CustomerStopName.focus();
	return false;
	
}	
var address=frm.location.value;
if(address=='')
{
	alert('Please enter the Customer Address');
	frm.location.focus();
	return false;
	
}	
var stopcity=frm.City.value;
 if(stopcity=='')
 {
 	alert('Please enter the Customer city');
	frm.City.focus();
	return false;
 }
 var custstate=frm.StateID.value;
 if(custstate=="")
 {
 	alert('Please select a State');
	frm.StateID.focus();
	return false;
 }
 var zip=frm.Zipcode.value;
 if(zip=='')
 {
 	alert('Please enter the Zipcode');
	frm.Zipcode.focus();
	return false;
 }
 /*
 var contact=frm.ContactPerson.value;
 if(contact=='')
 {
 	alert('Please enter the Contact Person');
	frm.ContactPerson.focus();
	return false;
 }
 
  var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.Phone.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   if (PhoneNumberInitialString !='')
   	{
      var FmtStr=PhoneNumberInitialString;
      if (FmtStr.length == 12)
      {      	
      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-"))      	
        FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
        else
        {
        	//alert(frmfld.value);
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frm.Phone.focus();
        	return false;
        }  
      }
   	}
    else
      {
        FmtStr=PhoneNumberInitialString;        
        //alert(frmfld.value);
        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        frm.Phone.focus();
        return false;
      }

 var faxno=frm.Fax.value;
 if(faxno=='')	
	{
		alert('Please enter the Fax Number');
		frm.Fax.focus();
		return false;
	}	
var email=frm.EmailID.value;
if(email=='')
{
	    alert('Please enter a valid EmailId');
		frm.EmailID.focus();
		return false;
}	*/
var customer=frm.cutomerIdAuto.value;
if(customer=='')
{
	    alert('Please select a customer');
		frm.cutomerIdAuto.focus();
		return false;
}		
}

function  validateCarrier(frm,dsn,flag)
{
try{
var mcno=frm.MCNumber.value;
if(mcno=='')
{
	alert('Please enter the MC Number');
	frm.MCNumber.focus();
	return false;
}	
else
{
	if(flag==0)
	{
		alert('Please enter a Valid MC Number');
		frm.MCNumber.focus();
		return false;
	}
}
var editid=document.getElementById('editid').value;
if(editid=="")
{
var checkMcNo = new ajaxLoadCutomer();	
var mcNoStatus = checkMcNo.checkMCNumber(mcno,dsn);

if (mcNoStatus==true)
	{
	
		alert('MC Number is alredy exist in database.');				
		document.getElementById("MCNumber").focus();
		return false;
	}
}
var carname=frm.CarrierName.value;
if(carname=='')
{
	alert('Please enter the carrierName');
	frm.MCNumber.focus();
	frm.CarrierName.focus();
	return false;
	
}
var address=frm.Address.value;
if(address=='')
{
	alert('Please enter the Carrier Address');
	frm.Address.focus();
	return false;
	
}	
var carcity=frm.City.value;
 if(carcity=='')
 {
 	alert('Please enter the  city');
	frm.City.focus();
	return false;
 }
 var custstate=frm.State.value;
 if(custstate=="")
 {
 	alert('Please select a State');
	frm.State.focus();
	return false;
 }
 var zip=frm.Zipcode.value;
 if(zip=='')
 {
 	alert('Please enter the Zipcode');
	frm.Zipcode.focus();
	return false;
 }
 /*var carcountry=frm.Country.value;
 if(carcountry=="")
 {
 	alert('Please select a Country');
	frm.Country.focus();
	return false;
 }
 */
 
 var phone=frm.Phone.value;
 if(phone=='')
 {
 	alert('Please enter the Phone');
	frm.Phone.focus();
	return false;
 }
 
    var FmtStr="";
    var index = 0;
    var LimitCheck;
    var PhoneNumberInitialString=frm.Phone.value;
    
    LimitCheck = PhoneNumberInitialString.length;
   if (PhoneNumberInitialString !='')
   	{
      var FmtStr=PhoneNumberInitialString;
      if (FmtStr.length == 12)
      {      	
      	if((FmtStr.charAt(3)== "-")&& (FmtStr.charAt(7)== "-")) 
      	{     	
        FmtStr = FmtStr.substring(0,2) + "-" + FmtStr.substring(4,6) + "-" + FmtStr.substring(8,11);
        return true;
      	}
        else
        {
        	//alert(frmfld.value);
        	alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        	frm.Phone.focus();
        	return false;
        }  
      }
    else
      {
        FmtStr=PhoneNumberInitialString;        
        //alert(frmfld.value);
        alert("Please enter phone number in the format of(xxx-xxx-xxxx)");
        frm.Phone.focus();
        return false;
      }
   }
  
 
  /*var cel=frm.CellPhone.value;
 if(cel=='')
 {
 	alert('Please enter the CellPhone');
	frm.CellPhone.focus();
	return false;
 }

 var faxno=frm.Fax.value;
 if(faxno=='')	
	{
		alert('Please enter the Fax Number');
		frm.Fax.focus();
		return false;
	}
 var toll=frm.Tollfree.value;
 if(toll=='')	
	{
		alert('Please enter the Tollfree Number');
		frm.Tollfree.focus();
		return false;
	}
	 
var email=frm.Email.value;
if(email=='')
{
	    alert('Please enter a valid Email Address');
		frm.Email.focus();
		return false;
}	
 var web=frm.Website.value;
 if(web=='')
 {
 	alert('Please enter the Website');
	frm.Website.focus();
	return false;
 }
 

 var equip1=frm.equipment.value;
 
	if(equip1=="")
	{
	    alert('Please select a equipment');
		frm.equipment.focus();
		return false;	
	}

var expdate=frm.InsExpDate.value;
if(expdate=='')
{
	    alert('Please select a Date');
		frm.InsExpDate.focus();
		return false;
}
var limit=frm.InsLimit.value;
if(limit=='')
{
	    alert('Please enter an Insurance Limit');
		frm.InsLimit.focus();
		return false;
}
var comm=frm.CommType.value;
if(comm=='')
{
	    alert('Please enter commission type');
		frm.CommType.focus();
		return false;
}*/				
}catch(e){}

}
function validateEquipment(frm)
{
var code=frm.EquipmentCode.value;
if(code=='')
{
	alert('Please enter the Equipment Code');
	frm.EquipmentCode.focus();
	return false;
	
}	
var eqname=frm.EquipmentName.value;
if(eqname=='')
{
	alert('Please enter the Equipment Name');
	frm.EquipmentName.focus();
	return false;
	
}	
}
function validateUnit(frm)
{
var code=frm.UnitCode.value;
if(code=='')
   {
	alert('Please enter the Unit Code');
	frm.UnitCode.focus();
	return false;	
   }
var unit=frm.UnitName.value;
if(unit=='')
   {
	alert('Please enter the Unit Name');
	frm.UnitName.focus();
	return false;	
   } 

  }
// 02-03-2011

function CalcCustomerTotal()
{
	//debugger
	var TotalCustCharges = 0;
	var TotalCustChargesNext = 0;
	var cutomerCharges=document.getElementById("CustomerRate").value;
	var i = 1;
	for (i=1;i<=5;i++)
		{
			TotalCustCharges = parseFloat((TotalCustCharges) + parseFloat(document.getElementById("custCharges"+i).value) * parseFloat(document.getElementById("qty"+i).value));
			
		}
	var j=2;
	for (j=2;j<=5;j++)
		{
			var k=1
			for (k=1;k<=5;k++)
				{
					TotalCustChargesNext = parseFloat(TotalCustChargesNext) + parseFloat(document.getElementById("custCharges"+k+j).value * parseFloat(document.getElementById("qty"+k+''+j).value));
					
				}
			
			//parseFloat(TotalCustCharges) +
		}
		var custMilesCharges = document.getElementById("CustomerMiles").value;
		custMilesCharges = custMilesCharges.replace('$','');
		custMilesCharges = custMilesCharges.replace(/,/g,'');
		
	var TotalCustcommodities = (parseFloat(TotalCustCharges) + parseFloat(TotalCustChargesNext)).toFixed(2);
	 document.getElementById("TotalCustcommodities").value ='$'+TotalCustcommodities;
	 
	 cutomerCharges = cutomerCharges.replace(/\$/,"");
	 var TotalCustomerCharges = (parseFloat(TotalCustCharges) + parseFloat(TotalCustChargesNext) + parseFloat(cutomerCharges) + parseFloat(custMilesCharges) ).toFixed(2);
	 document.getElementById("TotalCustomerCharges").value ='$'+ TotalCustomerCharges;
	 
	 updateTotalAndProfitFields();
}

//function milesChanged(stopid){
//	updateTotalRates(dsn);
//}

function CalcCarrierTotal()
{ 
	var TotalCarrCharges=0;
	var TotalCarrChargesNext=0;
	var carrierCharges=document.getElementById("CarrierRate").value;
	var i = 1;
	for (i=1;i<=5;i++)
		{
			TotalCarrCharges = parseFloat((TotalCarrCharges) + parseFloat(document.getElementById("carrCharges"+i).value) * parseFloat(document.getElementById("qty"+i).value));
			
		}
		
		var j=2;
	for (j=2;j<=5;j++)
		{
			var k=1
			for (k=1;k<=5;k++)
		{
			TotalCarrChargesNext = parseFloat(TotalCarrChargesNext) + parseFloat(document.getElementById("carrCharges"+k+j).value * parseFloat(document.getElementById("qty"+k+''+j).value)) ;
			
		}

		}
		var totalCommodities = (parseFloat(TotalCarrCharges) + parseFloat(TotalCarrChargesNext)).toFixed(2);
	 document.getElementById("TotalCarcommodities").value ='$'+totalCommodities;
	 carrierCharges = carrierCharges.replace(/\$/,"");
	 carrierCharges = (carrierCharges * 1);
	 TotalCarrCharges = (TotalCarrCharges * 1);
	 TotalCarrChargesNext = (TotalCarrChargesNext * 1);
	 
	 var TotalCarrierCharges = (TotalCarrCharges + TotalCarrChargesNext + carrierCharges).toFixed(2);
	 document.getElementById("TotalCarrierCharges").value = '$'+ TotalCarrierCharges;
			
	updateTotalAndProfitFields();
}

 function getbalance()
        {
         var credit=document.getElementById("CreditLimit").value;
         var avail=document.getElementById("Available").value;
         
         credit = credit.replace(/\$/,"");
	 	 credit = (credit * 1);
	 	 avail = avail.replace(/\$/,"");
	 	 avail = (avail * 1);      
         var balance=credit-avail;
         document.getElementById("Balance").value='$'+balance;
         
        }
function Autofillwebsite(frm)
{
	var strarray="";
	var email=frm.Email.value;
	var mystring=email.toString();
	var strlength=mystring.length;
	var regexp='@';
	var matchpos=mystring.search(regexp);
	if(matchpos!=-1)
	{
		var i;
        for (i=matchpos+1;i<strlength;i++)
        {
       	var indexvalue=mystring.charAt(i);       	
       	strarray=strarray+indexvalue;       
        frm.website.value='http://www.'+strarray;
        }
	}
return false;	
}
// Calaculate Distance
var zipNo = 1;
function getLongitudeLatitude(frm){ 
	
	var firstzip=frm.shipperZipcode.value;
	var secondzip=frm.consigneeZipcode.value;
	var res1=ColdFusion.Map.getLatitudeLongitude(firstzip, callbackHandler);
	var res2=ColdFusion.Map.getLatitudeLongitude(secondzip, callbackHandler);
	
} 
function callbackHandler(result){
	if (zipNo > 2) 
		{
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
	
	//alert("The latitude-longitude of Ann Arbor,MI is: "+result);
}
function  ClaculateDistance(frmload){
	addressChanged("");
	//var latitude1=frmload.lat1.value;
	//var latitude2=frmload.lat2.value;
	//var longtitude1=frmload.long1.value;
	//var longtitude2=frmload.long2.value;
	//var pivalue=Math.PI;
	//var radlat1=((Math.PI * latitude1)/180);
	//var radlat2 = ((Math.PI* latitude2)/180);
	//var radlon1 = ((Math.PI * longtitude1)/180);
	//var radlon2 = ((Math.PI * longtitude2)/180);
	//var theta = longtitude1-longtitude2;
	//var radtheta = ((Math.PI * theta)/180);
	//var dist = ((60 * 1.1515) * (180 /pivalue) * (Math.acos((Math.sin(radlat1) * Math.sin(radlat2)) + (Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)))));
	//document.getElementById("milse").value=parseInt(dist);
	//alert(dist);
	/*---------- Calculate the total miles value
	*/	
	//var TotalMiles;
	//var mils1 = document.getElementById('milse').value;
	//var mils2 = document.getElementById('milse2').value;
	//var mils3 = document.getElementById('milse3').value;
	//var mils4 = document.getElementById('milse4').value;
	//var mils5 = document.getElementById('milse5').value;

	//var CustomerRates = document.getElementById('CustomerRate').value;
	//var CarrierRates = document.getElementById('CarrierRate').value;
	
	//CustomerRates = CustomerRates.replace('$','');
	//CarrierRates = CarrierRates.replace('$','');
				
	//TotalMiles = parseInt(mils1) +  parseInt(mils2) +  parseInt(mils3) +  parseInt(mils4) +  parseInt(mils5);

	//var TotalCustomerRate = TotalMiles*CustomerRates;
	//var TotalCarrierRates = TotalMiles*CarrierRates;
	
	//TotalCustomerRate = '$' + TotalCustomerRate;
	//TotalCarrierRates = '$' + TotalCarrierRates;
	
	//document.getElementById('CustomerMiles').value = TotalCustomerRate;
	//document.getElementById('CarrierMiles').value = TotalCarrierRates;
	//updateTotalRates();
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
function getLongitudeLatitudeNext(frm,stpNo){ 
	document.getElementById('CurrStopNo').value = stpNo;
	var firstzip=document.getElementById('shipperZipcode'+stpNo).value;
	var secondzip=document.getElementById('consigneeZipcode'+stpNo).value;
	var res1=ColdFusion.Map.getLatitudeLongitude(firstzip, callbackHandlerNext);
	var res2=ColdFusion.Map.getLatitudeLongitude(secondzip, callbackHandlerNext);
	
} 
function callbackHandlerNext(result){
	
	stpNo = document.getElementById('CurrStopNo').value;
//	var stpNo=document.getElementById("stopNumber").value;
	if (zipNoNext > 2){
			zipNoNext = 1;
		}
	document.getElementById('result'+zipNoNext+stpNo).value=result;
	//alert(result);	
	var myList = result.toString();
	var myvalue=myList.split(',');
	var myLastVal1=myvalue[0];
	var myLastVal2=myvalue[1];
	var myLastVal1Len = myLastVal1.length;
	var myLastVal2Len = myLastVal2.length;
	document.getElementById('lat'+zipNoNext+stpNo).value=myLastVal1.substring(1,myLastVal1Len);
	document.getElementById('long'+zipNoNext+stpNo).value=myLastVal2.substring(1,myLastVal2Len-1);
	//alert(document.getElementById('lat'+zipNoNext+stpNo).value);
	zipNoNext=zipNoNext+1;
	//alert("The latitude-longitude of Ann Arbor,MI is: "+result);
}

function CalcDist(stpNo){
	addressChanged(stpNo);
	//var frmload = new Object();
	//frmload = document.load;
	
	//alert(stpNo);
	//alert(document.getElementById("lat1"+stpNo).value);
	/*var latitude1=document.getElementById("lat1"+stpNo).value;
	//alert(latitude1);
	var latitude2=document.getElementById('lat2'+stpNo).value;	
	var longtitude1=document.getElementById('long1'+stpNo).value;
    //alert(longtitude1);
	var longtitude2=document.getElementById('long2'+stpNo).value;
	var pivalue=Math.PI;
	var radlat1=((Math.PI * latitude1)/180);
	var radlat2 = ((Math.PI* latitude2)/180);
	var radlon1 = ((Math.PI * longtitude1)/180);
	var radlon2 = ((Math.PI * longtitude2)/180);
	var theta = (longtitude1-longtitude2);
	var radtheta = ((Math.PI * theta)/180);*/
	//alert(radtheta);
	
//	var dist = ((60 * 1.1515) * (180 /Math.PI) * (Math.acos((Math.sin(radlat1) * Math.sin(radlat2)) + (Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)))));
	//alert(dist);
	//document.getElementById('milse'+stpNo).value=parseInt(dist);
	
	/*---------- Calculate the total miles value
	*/	
	//updateTotalRates();
}

// Updates total fileds and all the profit fields
function updateTotalAndProfitFields(){
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
	
	var totalCustCharges = (parseFloat(flatRate) + parseFloat(custCommodities) + parseFloat(CustomerMilesAmount));
	document.getElementById('TotalCustomerCharges').value = "$"+totalCustCharges;
	
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
	
	var totalCarCharges = (parseFloat(flatRateCar) + parseFloat(carCommodities) + parseFloat(CarMilesAmount)).toFixed(2);
	document.getElementById('TotalCarrierCharges').value = "$"+totalCarCharges;
	
	// updating profits fields
	var flatRateProfit = (flatRate - flatRateCar).toFixed(2);
	document.getElementById('flatRateProfit').value = "$"+flatRateProfit;
	var carcommoditiesProfit = (custCommodities - carCommodities).toFixed(2);
	
	document.getElementById('carcommoditiesProfit').value = "$"+carcommoditiesProfit;
	var amountOfMilesProfit = (CustomerMilesAmount - CarMilesAmount).toFixed(2);
	document.getElementById('amountOfMilesProfit').value = "$"+amountOfMilesProfit;
	
	var totalProfit = (parseFloat(flatRateProfit)+parseFloat(carcommoditiesProfit)+parseFloat(amountOfMilesProfit)).toFixed(2)
	document.getElementById('totalProfit').value = "$"+totalProfit;
	// updating percentage profits
	if(totalProfit==0 && totalCustCharges==0)
		document.getElementById('percentageProfit').firstChild.data = "0.00%";
	else
		document.getElementById('percentageProfit').firstChild.data = ((totalProfit/totalCustCharges)*100).toFixed(2)+"%";
	
}


// Updates the total RatePerMiles
function updateTotalRates(dsn){ 
	//alert("miles changed");
	var TotalMiles=0;
	var miles1 = document.getElementById('milse').value;
	TotalMiles = parseFloat(miles1);

	var custElem = $('#cutomerIdValueContainer').val();
	var customerId = custElem; //custElem.options[custElem.selectedIndex].value;
	
	var carrierId = document.getElementById('carrierID').value;
	var carrierId2 = document.getElementById('carrierID2').value;
	var carrierId3 = document.getElementById('carrierID3').value;
	var carrierId4 = document.getElementById('carrierID4').value;
	var carrierId5 = document.getElementById('carrierID5').value;
	
	//var loadCustomer = new ajaxLoadCutomer();
	//var newCustomerFrm1 = loadCustomer.getAjaxCustomerInfo(customerId);
	//alert("customer: "+newCustomerFrm1);
	//alert("customerRate: "+newCustomerFrm1.RatePerMile);
	
	//alert("Customer Id: "+customerId);
	//alert("Carrier Id: "+carrierId);
	

	var CustomerRates = 0; // TODO: get correct rate/mile from DB
	var CarrierRates = 0; // TODO: get correct rate/mile from DB
	
	for(var i=1; i<=5; i++)
	{
		if(document.getElementById('stop'+i)==null || document.getElementById('stop'+i).style.display == 'none')
			continue;
			
		var ithMile = document.getElementById('milse'+i).value;
		TotalMiles += parseFloat(ithMile);
	}
	
	
	// correct calculation:
	var arrLongShortMiles = getLongShortMiles(dsn); // Will return LongMiles on index0 ShortMiles on index1
	var custTotalMiles = TotalMiles + ((TotalMiles/100)*arrLongShortMiles[0]);
	var carTootalMiles = TotalMiles - ((TotalMiles/100)*arrLongShortMiles[1]);
	document.getElementById('CustomerMilesCalc').value = custTotalMiles;
	document.getElementById('CarrierMilesCalc').value = carTootalMiles;
	
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
	
	document.getElementById('CustomerMiles').value = "$"+totalCustomerMilesRate;
	document.getElementById('CarrierMiles').value = "$"+totalCarrierMilesRate;
	document.getElementById('CustomerMilesTotalAmount').value = "$"+totalCustomerMilesRate;
	document.getElementById('CarrierMilesTotalAmount').value = "$"+totalCarrierMilesRate;

	updateTotalAndProfitFields();
}



function calculateTotalRates(dsn){
	updateTotalRates(dsn);
}

function ClaculateDistanceNext(frmload1,stpNo1)
{   
	var calFunc="CalcDist('+stpNo1+')";
	setTimeout(calFunc,1000);
}

function isValidPercentage(strValue){
	if(isNaN(strValue))
	{
		return false;
	}
	else{
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

function addQuickCalcInfoToLog(dsn,userName){
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

function clearQuickCalcFields(){
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


function validateFields(){
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

function getMCDetails(url,mcno,dsn)
{
	
	var checkMcNo = new ajaxLoadCutomer();	
	var mcNoStatus = checkMcNo.checkMCNumber(mcno,dsn);    
	if (mcNoStatus==true)
		{
			
			alert('MC Number is alredy exist in database.');
			document.getElementById("MCNumber").focus();
			return false;
		}
	
	checkUnload();
	document.location.href=url + '&mcNo='+mcno;
}

function checkLogin(loginid,dsn)
{
	var checkLoginid = new ajaxLoadCutomer();	
	var loginStatus = checkLoginid.checkLoginId(loginid,dsn);
	
	if (loginStatus==true)
		{
			alert('Login is alredy exist in database.');
			document.getElementById("loginid").focus();
			return false;
		}
	 
	checkUnload();
}
function ChangeCustomerInfo(customerid)
{
 alert('Please delete stops from different customer, Before changing the customer');
 document.getElementById("cutomerId").value=customerid;
 return false;
}



	//Code for Asigned Load Type--- Radios buttons on selection "On Add Agent"
	function isSelect()
	{
		var _select = document.getElementById('AsignedLoadType');				
		for ( var i = 0; i < _select.options.length; i++ )
		{
			var sel=_select.options[i].value;
			if(_select.options[i].selected == false)
			{
				document.getElementById("L_radio_" + sel).disabled=true;
				document.getElementById("R_radio_" + sel).disabled=true;
				
				document.getElementById("L_radio_" + sel).checked=false;
				document.getElementById("R_radio_" + sel).checked=false;
			}
			else
			{
				document.getElementById("L_radio_" + sel).disabled=false;
				document.getElementById("R_radio_" + sel).disabled=false;
			}
		}
	}