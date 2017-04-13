<!---<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">--->

<cfsilent>
	<cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qstates"/>
</cfsilent>


<cfoutput>
<script type="text/javascript" language="javascript" src="javascripts/jquery.js"></script>
<script type='text/javascript' language="javascript" src='javascripts/jquery.autocomplete.js'></script>
<script type="text/javascript">
	$(function() {

	// City DropBox
		function Cityformat(mail) 
		{
			return mail.city + "<br/><b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b> " + mail.zip;
		}
		
		function Zipformat(mail) 
		{
			return mail.zip + "<br/><b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b> " + mail.city;
		}
	
		//City Shippper City
	// Shippper DropBox
	$("##ShipperCity, ##ConsigneeCity").autocomplete('searchCityAutoFill.cfm', {
		extraParams: {queryType: 'getCity'},
		multiple: false,
		width: 400,
		scroll: true,
		scrollHeight: 300,
		cacheLength: 1,
		highlight: false,
		dataType: "json",
		parse: function(data) {
			return $.map(data, function(row) {
				return {
					data: row,
					value: row.value,
					result: row.city
				}
			});
		},
		formatItem: function(item)
		 {
			return Cityformat(item);
		 }
		}).result(function(event, data, formatted) 
		{
			
		strId = this.id;
		initialStr = strId.substr(0, 7);
		if(initialStr != 'Shipper')
			initialStr = 'Consignee';
		$('##'+initialStr+'state').val(data.state);
		$('##'+initialStr+'Zip').val(data.zip);
		
	});
		

	//zip AutoComplete
	$("##ShipperZip, ##ConsigneeZip").autocomplete('searchCityAutoFill.cfm', {
		
		extraParams: {queryType: 'GetZip'},
		multiple: false,
		width: 400,
		scroll: true,
		scrollHeight: 300,
		cacheLength: 5,
		minLength: 5,
		highlight: false,
		dataType: "json",
		parse: function(data) {
			return $.map(data, function(row) {
				return {
					data: row,
					value: row.value,
					result: row.zip
				}
			});
		},
		formatItem: function(item) {
			return Zipformat(item);
		}
	}).result(function(event, data, formatted) {
		strId = this.id;
		zipCodeVal=$('##'+strId).val();
		//auto complete the state and city based on first 5 characters of zip code
		if(zipCodeVal.length == 5)
		{
			
			initialStr = strId.substr(0, 7);
			if(initialStr != 'Shipper')
				initialStr = 'Consignee';
			//Donot update a field if there is already a value entered	
			if($('##'+initialStr+'state').val() == '')
			{
				$('##'+initialStr+'state').val(data.state);
			}	
			
			if($('##'+initialStr+'City').val() == '')
			{
				$('##'+initialStr+'City').val(data.city);	
			}
		}	
	});
	
	});		
</script>
	
	
	
<h1>Quick Miles and Rate Calculation</h1>
<div style="clear:left"></div>

<div class="white-con-area">
	<div class="white-top"></div>
    <div class="white-mid">
		<cfform name="frmAgent" action="##" method="post">
			<div class="form-con">
				<fieldset>	
					<!---<label>Short Miles</label>--->
					<cfinput name="shortMiles" id="shortMiles" value="" type="hidden">
					<div class="clear"></div>
					<div style="margin-top:0px;"><label>Shipper Address</label></div>
					<cftextarea type="text" tabindex="7" name="shipperAddress" id="shipperAddress" onBlur="calculateDist('conAddress','shipperAddress');" onClick=""></cftextarea>
					<div class="clear"></div>
					<label>City</label>
					<cfinput type="text" name="ShipperCity" id="ShipperCity" tabindex="8" size="25" onBlur="calculateDist('conAddress','shipperAddress');">
					<div class="clear"></div>
					<label>State</label>
					<select name="Shipperstate" id="Shipperstate" onchange="calculateDist('conAddress','shipperAddress');" onBlur="calculateDist('conAddress','shipperAddress')" tabindex="9">
						<option value="" selected="selected">Select</option>
						<cfloop query="request.qStates">
							<option value="#request.qStates.statecode#">#request.qStates.statecode#</option>	
						</cfloop>
					</select>
					<div class="clear"></div>
					<label>Zip</label>
					<cfinput type="text" name="ShipperZip" id="ShipperZip" tabindex="10" value="" onBlur="calculateDist('conAddress','shipperAddress')" size="25">
					<div class="clear"></div>
					<label>Carrier Rate Per Mile</label>
					<cfinput type="text" name="carrierRate" id="carrierRate" tabindex="11" value="" size="25" onChange="updatedMilesWithLongShort('#application.DSN#','#session.AdminUserName#');" onClick="">
					<div class="clear"></div>
					<div style="height:30px;"></div>
					<label>Carrier Miles</label>
					<cfinput type="text" name="carrierMiles" id="carrierMiles" value="0" size="25" readonly="readonly" onChange="">
					<div class="clear"></div>
					<label>Carrier Amount</label>
					<cfinput type="text" name="carrierAmount" id="carrierAmount" value="0" size="25" readonly="readonly" onChange="">
					<div class="clear"></div>
					
			   <!---     <div class="right" style="margin-right:53px;">
							<input  type="button" id="clearAllBtn" onclick="addQuickCalcInfoToLog('#application.DSN#','#session.AdminUserName#'); clearQuickCalcFields();" tabindex="12" class="bttn" value="Clear All" style="width:170px;" />
					</div>--->
				</fieldset>
				
			    <div id="message" class="msg-area" style="width:153px; margin-left:200px; display:none;"></div>
			    
			</div>
			<div class="form-con">
				<fieldset>
					<cfinput id="calculatedMiles" name="calculatedMiles" type="hidden" value="" onChange="updatedMilesWithLongShort('#application.DSN#','#session.AdminUserName#');">
					<label>Company Name</label>
					<cfinput type="text" name="companyName" id="companyName" tabindex="1" value="" size="25" onBlur="calculateDist('conAddress','shipperAddress')">
					
					<cfinput name="longMiles" id="longMiles" value="" type="hidden">
					<div class="clear"></div>
					<label>Consignee Address</label>
					<cftextarea type="text" tabindex="2" name="conAddress" id="conAddress" onClick="" onBlur="calculateDist('conAddress','shipperAddress')"></cftextarea>
					<div class="clear"></div>
					<label>City</label>
					<cfinput type="text" name="ConsigneeCity" id="ConsigneeCity" tabindex="3" size="25" onBlur="calculateDist('conAddress','shipperAddress');">
					<div class="clear"></div>
					<label>State</label>
					<select name="Consigneestate" id="Consigneestate" onchange="calculateDist('conAddress','shipperAddress');" onBlur="calculateDist('conAddress','shipperAddress')" tabindex="4">
						<option value="" selected="selected">Select</option>
						<cfloop query="request.qStates">
							<option value="#request.qStates.stateID#">#request.qStates.statecode#</option>	
						</cfloop>
					</select>
					<div class="clear"></div>
					<label>Zip</label>
					<cfinput type="text" name="ConsigneeZip" id="ConsigneeZip" tabindex="5" value="" size="25" onBlur="calculateDist('conAddress','shipperAddress')">
					<div class="clear"></div>
					<label>Customer Rate Per Mile</label>
					<cfinput type="text" name="customerRate" id="customerRate" tabindex="6" value="" size="25" onClick="" onChange="updatedMilesWithLongShort('#application.DSN#','#session.AdminUserName#');">
					<div class="clear"></div>
					<div style="height:30px;"></div>
					<label>Customer Miles</label>
					<cfinput type="text" name="customerMiles" id="customerMiles" value="0" size="25" readonly="readonly" onChange="">
					<div class="clear"></div>
					<label>Customer Amount</label>
					<cfinput type="text" name="customerAmount" id="customerAmount" value="0" size="25" readonly="readonly" onChange="">
					<div class="clear"></div>
						<div class="" style="margin-right:53px;float:right;">
							<input  type="button" id="clearAllBtn" onclick="addQuickCalcInfoToLog('#application.DSN#','#session.AdminUserName#'); clearQuickCalcFields();" tabindex="12" class="bttn" value="Clear All" style="width:170px;" /></div>
						</div>
				</fieldset>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
		</cfform>
		
	</div>
	
	<div class="white-bot"></div>
</div>
<script>getAndUpdateLongShortMilesFields('#application.DSN#');</script>
</cfoutput>