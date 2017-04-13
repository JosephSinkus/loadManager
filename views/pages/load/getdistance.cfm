<!--- calculating distance between two zipcode-----------> 
 
<!---<script type="text/javascript" src="http://ajassx.googleapis.com/ajax/libs/jquery/1/jquery.min.js?file=api&sensor=true"></script>--->
<!--- <script language="javascript"> 
var zipNo = 1;
function getLongitudeLatitude(frm) 
{ 
	
	var firstzip=frm.shipperZipcode.value;
	var secondzip=frm.consigneeZipcode.value;
	var res1=ColdFusion.Map.getLatitudeLongitude(firstzip, callbackHandler);
	var res2=ColdFusion.Map.getLatitudeLongitude(secondzip, callbackHandler);
	
} 
function callbackHandler(result) 
{
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
function  ClaculateDistance(frmload)
{
	var latitude1=frmload.lat1.value;
	var latitude2=frmload.lat2.value;
	var longtitude1=frmload.long1.value;
	var longtitude2=frmload.long2.value;
	var pivalue=Math.PI;
	var radlat1=((Math.PI * latitude1)/180);
	var radlat2 = ((Math.PI* latitude2)/180);
	var radlon1 = ((Math.PI * longtitude1)/180);
	var radlon2 = ((Math.PI * longtitude2)/180);
	var theta = longtitude1-longtitude2;
	var radtheta = ((Math.PI * theta)/180);
	var dist = ((60 * 1.1515) * (180 /pivalue) * (Math.acos((Math.sin(radlat1) * Math.sin(radlat2)) + (Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)))));
	document.getElementById("milse").value=dist;  
	alert(dist);
}

</script> ---> 
<!--- 
<cfoutput>
<cfset Zipcode1="">
<cfset Zipcode2="">
<cfSet result1="0,0">
<cfset result2="0,0">
<cfset lat1="0">
<cfset lat2="0">
<cfset long1="0">
<cfset long2="0">
<cfajaximport params="#{googlemapkey='#application.gAPI#'}#">

<div style="width:50px;height:50px;display:none;"><cfmap name="mainMap" centeraddress="HUNTSVILLE" showcentermarker="false" zoomlevel="13" /></div>
	<cfif #Consigneezipcode# neq ''>
		<cfinput tabindex="#evaluate(currentTab+1)#" name="consigneeZipcode" id="consigneeZipcode" value="#Consigneezipcode#" type="text" onchange="getLongitudeLatitude(load); ClaculateDistance(load); addressChanged('');" onkeyup="showChangeAlert('consignee','');"  />
	<cfelse>
		<cfinput  name="consigneeZipcode" id="consigneeZipcode" value="#Consigneezipcode#" type="text" onchange="getLongitudeLatitude(load); ClaculateDistance(load); addressChanged('');" onkeyup="showChangeAlert('consignee','');" />	
	</cfif>
	<cfinput type="hidden" name="result1" id="result1" value="#result1#" >
	<cfinput type="hidden" name="result2" id="result2" value="#result2#" >
	<cfinput type="hidden" name="lat1" id="lat1" value="#lat1#">
	<cfinput type="hidden" name="long1" id="long1" value="#long1#">
	<cfinput type="hidden" name="lat2" id="lat2" value="#lat2#">
	<cfinput type="hidden" name="long2" id="long2" value="#long2#">
</cfoutput>--->
 