<!--- calculating distance between two zipcode-----------> 
<html>
<head>
<!--- <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js?file=api&amp;v=2&amp;sensor=true_or_false&amp;key=<cfoutput>#Application.gAPI#</cfoutput>"></script>--->

 
</head>
<body>
<cfoutput>

<cfset Zipcode1="">
<cfset Zipcode2="">
<cfSet result1="0,0">
<cfset result2="0,0">
<cfset lat1="0">
<cfset lat2="0">
<cfset long1="0">
<cfset long2="0">
<!--- <cfajaximport params="#{googlemapkey='#application.gAPI#'}#">
<div style="width:50px;height:50px;display:none;"><cfmap name="mainMap" centeraddress="HUNTSVILLE" showcentermarker="false" zoomlevel="13" /></div>--->
	<!--- <input name="consigneeZipcode#stopNumber#" id="consigneeZipcode#stopNumber#" value="#Consigneezipcode#" type="text" onchange="getLongitudeLatitudeNext(load,#stopNumber#);ClaculateDistanceNext(load,#stopNumber#);addressChanged(#stopNumber#);"  onkeyup="showChangeAlert('consignee',#stopNumber#);"/> --->
	
	<cfif structkeyexists(url,"loadid") and len(url.loadid) gt 1>
		<input tabindex="" name="consigneeZipcode#stopNumber#" id="consigneeZipcode#stopNumber#" value="#Consigneezipcode#" type="text" onchange="getLongitudeLatitudeNext(load,#stopNumber#);ClaculateDistanceNext(load,#stopNumber#);addressChanged(#stopNumber#);"  onkeyup="showChangeAlert('consignee',#stopNumber#);"/>
	<cfelse>
		<input tabindex="" name="consigneeZipcode#stopNumber#"  id="consigneeZipcode#stopNumber#" value="#Consigneezipcode#" type="text" onchange="getLongitudeLatitudeNext(load,#stopNumber#);ClaculateDistanceNext(load,#stopNumber#);addressChanged(#stopNumber#);"  onkeyup="showChangeAlert('consignee',#stopNumber#);"/>
	</cfif>
	<input type="hidden" name="result1#stopNumber#" id="result1#stopNumber#" value="#result1#" >
	<input type="hidden" name="result2#stopNumber#" id="result2#stopNumber#" value="#result2#" >
	<input type="hidden" name="lat1#stopNumber#" id="lat1#stopNumber#" value="#lat1#">
	<input type="hidden" name="long1#stopNumber#" id="long1#stopNumber#" value="#long1#">
	<input type="hidden" name="lat2#stopNumber#" id="lat2#stopNumber#" value="#lat2#">
	<input type="hidden" name="long2#stopNumber#" id="long2#stopNumber#" value="#long2#">
</cfoutput>
</body>
</html>