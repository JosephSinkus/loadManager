
<cfoutput>
<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer">

<cfsilent>
 <cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
 <cfset requireValidMCNumber = request.qGetSystemSetupOptions.requireValidMCNumber>
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurMailAgentdetails" employeID="#session.empid#" />
	<cfif request.qcurMailAgentdetails.recordcount gt 0 and (request.qcurMailAgentdetails.SmtpAddress eq "" or request.qcurMailAgentdetails.SmtpUsername eq "" or request.qcurMailAgentdetails.SmtpPort eq "" or request.qcurMailAgentdetails.SmtpPassword eq "" or request.qcurMailAgentdetails.SmtpPort eq 0)>
	  <cfset mailsettings = "false">
  <cfelse>
	  <cfset mailsettings = "true">
  </cfif>
	<cfif request.qGetSystemSetupOptions.freightBroker>
		<cfset variables.freightBroker = "Carrier">
		<cfset variables.freightBrokerShortForm = "Carr">
		<cfset variables.freightBrokerId = "MC">
	<cfelse>
		<cfset variables.freightBroker = "Driver">
		<cfset variables.freightBrokerShortForm = "Driver">
		<cfset variables.freightBrokerId = "Driver Lic">
	</cfif>
</cfsilent>

<!---Init the default value------->
<cfparam name="pv_apcant_id" default="">
<cfparam name="pv_usdot_no" default="">
<cfparam name="pv_pref_docket" default="">
<cfparam name="pv_legal_name" default="">
<cfparam name="AuthType_Common_status" default="">
<cfparam name="AuthType_Common_appPending" default="">
<cfparam name="AuthType_Contract_status" default="">
<cfparam name="AuthType_Contract_appPending" default="">
<cfparam name="AuthType_Broker_status" default="">
<cfparam name="AuthType_Broker_appPending" default="">
<cfparam name="household_goods" default="">
<cfparam name="bipd_Insurance_required" default="">
<cfparam name="bipd_Insurance_on_file" default="">
<cfparam name="cargo_Insurance_required" default="">
<cfparam name="cargo_Insurance_on_file" default="">
<cfparam name="webLegger" default="">
<cfparam name="MCNumber" default="">
<cfparam name="DOBDate" default="">
<cfparam name="hiredDate" default="">
<cfparam name="businessAddress" default="">
<cfparam name="businessPhone" default="">
<cfparam name="insCarrier" default="">
<cfparam name="insPolicy" default="">
<cfparam name="insAgentName" default="">
<cfparam name="insCarrierDetails" default="">
<cfparam name="licState" default="">
<cfparam name="Status" default="">
<cfparam name="StatusValID" default="">
<cfparam name="StatusValCODE" default="">
<cfparam name="CarrierName" default="">
<cfparam name="City" default="">
<cfparam name="State" default="">
<cfparam name="State1" default="">
<cfparam name="Address" default="">
<cfparam name="Zipcode" default="">
<cfparam name="ss" default="">
<cfparam name="Country" default="">
<cfparam name="Country1" default="9bc066a3-2961-4410-b4ed-537cf4ee282a">
<cfparam name="Phone" default="">
<cfparam name="CellPhone" default="">
<cfparam name="Fax" default="">
<cfparam name="Tollfree" default="">
<cfparam name="Email" default="">
<cfparam name="CDLExpires" default="">
<cfparam name="InsExpDate" default="">
<cfparam name="lastDrugTest" default="">
<cfparam name="employeeType" default="">
<cfparam name="InsExpDateLive" default="">
<cfparam name="CargoAmount" default="">
<cfparam name="Certificate" default="">
<cfparam name="Terms" default="">
<cfparam name="RegNumber" default="">
<cfparam name="Dispatcher" default="">
<cfparam name="equipment" default="">
<cfparam name="CarrierInstructions" default="">
<cfparam name="EquipmentNotes" default="">
<cfparam name="editid" default="0">
<cfparam name="state11" default="">
<cfparam name="url.mcNo" default="0">
<cfparam name="StateValCODE" default="">
<cfparam name="notes" default="">

<!--- Encrypt String --->
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>


<cfset CarrOrgName="">
<cfset getMCNoURL=""> 
<cfif isdefined('url.mcNo') and len(url.mcNo) gt 1>
	<cfset MCNumber=url.mcNo>
</cfif>

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
	
	
		//City 
		$("##City, ##RemitCity").autocomplete('searchCityAutoFill.cfm', {
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
		formatItem: function(item) {
			return Cityformat(item);
		}
		}).result(function(event, data, formatted) 
		{
			var strId = this.id;
			if(strId == "City")
			{
				$('##state').val(data.state);
				$('##Zipcode').val(data.zip);
			}
			else if(strId == "RemitCity")
			{
				$('##RemitState').val(data.state);
				$('##RemitZipcode').val(data.zip);
			}

		});
	
		//zip AutoComplete
		$("##Zipcode, ##RemitZipcode").autocomplete('searchCityAutoFill.cfm', {
		
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

			var strId = this.id;
			if(strId == "Zipcode")
			{
				initialStr = strId.substr(0, 7);
				//Donot update a field if there is already a value entered	
				if($('##state').val() == '')
				{
					$('##state').val(data.state);
				}	
				
				if($('##City').val() == '')
				{
					$('##City').val(data.city);	
				}
			}
			else if(strId == "RemitZipcode")
			{
				$('##RemitState').val(data.state);
				$('##RemitCity').val(data.city);
			}
			
			
			
		}	
		});
	
		
		
	
});
function popitup(url) {
	newwindow=window.open(url,'Map','height=600,width=600');
	if (window.focus) {newwindow.focus()}
	return false;
}
function InsAgentPhone1() {
  var q=$('##InsAgentPhone').val();
if(q.length>=50)
{	
	alert('Agent Phone needs to be corrected or text length must be less than 50' );
  return false;
 }
}	

function addNewRow(){
	var selectOptions = $('.sel_commodityType').html();
	var currentRowCount = parseInt($('.commodityWrap tbody tr').length);
	var newRowCont = currentRowCount+1;
	var appenString = '<tr><td height="20" class="lft-bg">&nbsp;</td><td valign="middle" align="left" class="normaltd" style="width:274px;position:relative;top:-5px;padding:8px 0px;">';
	appenString  = appenString + '<select class="sel_commodityType" id="type" style="width:240px;height:26px;" name="sel_commodityType_'+newRowCont+'">'+selectOptions+'</select>';
	appenString  = appenString + '<input type="hidden" name="numberOfCommodity" value="1"></td>';
	appenString  =	appenString + '<td valign="middle" align="left" class="normaltd" style="width:142px;position:relative;top:-5px;"><input type="text" class="txt_carrRateComm q-textbox" value="$0.00" name="txt_carrRateComm_'+newRowCont+'"></td>';
	appenString  = appenString + '<td valign="middle" colspan="2" align="left" class="normaltd" style="width:132px;position:relative;top:-5px;"><input type="text" class="txt_custRateComm q-textbox" value="0.00%" name="txt_custRateComm_'+newRowCont+'"></td>';
	
						
	$('.commodityWrap tbody').append(appenString);
	$(appenString).find('.sel_commodityType').attr('name', 'sel_commodityType_' + parseInt(currentRowCount)+1);
}

function ConfirmMessage(index,stopno){
	if(stopno !=0){
		index=index+""+stopno;
	}
	percentagedata=$('##txt_custRateComm_'+index).val();
	percentagedata=percentagedata.replace("%", "");	
	if(percentagedata.indexOf("%")==-1){
		if(percentagedata<1){
			percentagedata=percentagedata*100;			
		}
		var percentagedata = parseFloat(percentagedata).toFixed(2);
		$('##txt_custRateComm_'+index).val(percentagedata+"%");
	}
	if(percentagedata.indexOf("%")>-1){
		var percentagedata = parseFloat(percentagedata).toFixed(2);
		$('##txt_custRateComm_'+index).val(percentagedata+"%");
	}
}
function checkDateFormat(ele){
	/*var reg = /^(0[1-9]|1[012])([\/])(0[1-9]|[12][0-9]|3[01])\2(\d{4})$/;*/
	var reg =/((^(10|12|0?[13578])([/])(3[01]|[12][0-9]|0?[1-9])([/])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(11|0?[469])([/])(30|[12][0-9]|0?[1-9])([/])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(0?2)([/])(2[0-8]|1[0-9]|0?[1-9])([/])((1[8-9]\d{2})|([2-9]\d{3}))$)|(^(0?2)([/])(29)([/])([2468][048]00)$)|(^(0?2)([/])(29)([/])([3579][26]00)$)|(^(0?2)([/])(29)([/])([1][89][0][48])$)|(^(0?2)([/])(29)([/])([2-9][0-9][0][48])$)|(^(0?2)([/])(29)([/])([1][89][2468][048])$)|(^(0?2)([/])(29)([/])([2-9][0-9][2468][048])$)|(^(0?2)([/])(29)([/])([1][89][13579][26])$)|(^(0?2)([/])(29)([/])([2-9][0-9][13579][26])$))/;
	var textValue=$(ele).val();
	if(textValue.length){
		if(!textValue.match(reg)){
			alert('Please enter a date in mm/dd/yyyy format');
			$(ele).focus();
		}
	}	
}
</script>

<cfif isDefined("url.carrierid") and len(url.carrierid)>
    <cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier">
    	<cfinvokeargument name="carrierid" value="#url.carrierid#">
    </cfinvoke>
		<cfset MCNumber=request.qCarrier.MCNumber>
</cfif>

<!--- if updLIData exists in the url, then do the webservice call and update the db --->
<cfif (isdefined('url.updLIData') or len('MCNumber')) and isdefined('url.carrierID')>
	<cfinclude template="websiteDATA.cfm">
	<cfinvoke component="#variables.objCarrierGateway#" method="EditLIWebsiteData" returnvariable="message">
		 <cfinvokeargument name="carrierId" value="#url.carrierID#">
	 </cfinvoke>
	 <cfif not StructKeyExists(url,"updLIData")>
		<cfset message="">
	 </cfif>
</cfif>
<cfset variables.objunitGateway = getGateway("gateways.unitgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#")) >
    
<cfinvoke component="#variables.objunitGateway#" method="getloadUnits" status="True" returnvariable="request.qUnits" />
<cfif isDefined("url.carrierid") and len(url.carrierid)>
	<cfinvoke component="#variables.objCarrierGateway#" method="getCarrierOffice" carrierid="#url.carrierid#" returnvariable="request.qCarrierOffice" />
	<cfinvoke component="#variables.objCarrierGateway#" method="getLIWebsiteData" returnvariable="request.qLiWebsiteData">
		<cfinvokeargument name="carrierid" value="#url.carrierid#">
    </cfinvoke>
	<cfinvoke component="#variables.objCarrierGateway#" method="getCommodityById"  returnvariable="request.qGetCommodityById" >
		<cfinvokeargument name="carrierID" value="#url.carrierid#">
	</cfinvoke>
	
     <cfif request.qCarrier.recordcount gt 0 >
	     <cfset CarrierName=request.qCarrier.CarrierName>
	     <cfif isDefined("url.mcNo") and len(url.mcNo) gt 1>
			<cfset MCNumber=url.mcNo>		 
		 <cfelse>	     
			 <cfset MCNumber=request.qCarrier.MCNumber>
			 <cfset Address=request.qCarrier.Address>
			 <cfset StateValCODE=trim(request.qCarrier.StateCODE)>
			 <cfset Status=request.qCarrier.Status>
			 <cfset City=request.qCarrier.City>
			 <cfset Zipcode=request.qCarrier.Zipcode>
			 <cfset Country1=request.qCarrier.Country>
			 <cfset Phone=request.qCarrier.Phone>
			 <cfset InsExpDate=request.qCarrier.InsExpDate>
		 </cfif>
	     <cfset CellPhone=request.qCarrier.Cel>
	     <cfset Fax=request.qCarrier.Fax> 
	     <cfset Tollfree=request.qCarrier.Tollfree>
	     <cfset Email=request.qCarrier.EmailID> 
		 <cfset CDLExpires=request.qCarrier.CDLExpires> 
	     <cfset RegNumber=request.qCarrier.RegNumber>
	     <cfset equipment=request.qCarrier.EquipmentID>
	     <cfset InsExpDate=request.qCarrier.InsExpDate>
	     <cfset CarrierInstructions=request.qCarrier.CarrierInstructions>
	     <cfset EquipmentNotes=request.qCarrier.EquipmentNotes>
		 <cfset notes =request.qCarrier.notes>
		 <cfset Terms =request.qCarrier.CarrierTerms>		 
		 <cfset licState =request.qCarrier.licState>
		 <cfset DOBDate =request.qCarrier.DOBDate>
		 <cfset hiredDate =request.qCarrier.hiredDate>
		 <cfset ss =request.qCarrier.ss>
		 <cfset employeeType =request.qCarrier.employeeType>
		 <cfset lastDrugTest =request.qCarrier.lastDrugTest>		 
	     <cfset editid=#url.carrierid#>
	     <cfset getMCNoURL="index.cfm?event=adddriver&carrierid=#url.carrierid#&#session.URLToken#"> 
		 <cfinclude template="dbwebsiteDATA.cfm"> 
	</cfif>
<cfelse>
	<cfset getMCNoURL="index.cfm?event=adddriver&#session.URLToken#">
	<!---
	<cfif isdefined('url.mcNo') and len(url.mcNo) gt 1>
	<cfset MCNumber=url.mcNo>     
	--->
   <!--- Since carrierid doesnot exists so here make a webservice call --->
    	<cfinclude template="websiteDATA.cfm"> 
		<!--- end --->
	<!---
    </cfif>
	--->
</cfif>
   <cfif len(pv_legal_name)> 
    <cfset ValidMCNO=1>      
   	<cfset CarrOrgName=pv_legal_name>
	<cfset pv_legal_name = Replace(pv_legal_name,"&","~","all")>
	<cfloop list="#pv_legal_name#" index="ldrIndx" delimiters=" ">
		<cfset webLegger = listAppend(webLegger,ldrIndx,"^")>
	</cfloop>
	<cfset MCNumber=#MCNumber#>
	<cfif not isDefined("url.carrierid")>
		<cfset CarrierName=CarrOrgName>
	    <cfset MCNumber=#MCNumber#>
	    <cfset NowAddress=replace(businessAddress,"&nbsp;"," ","all")>
	    <cfset addLen = listlen(NowAddress," ")> 
	    <cfset Address="">       
        <cfset AddressLen=addLen-3>
         <cfloop from="1" to="#AddressLen#" index="listindex">
         <cfset Address=Address & " " & listgetAt(NowAddress,listindex," ")>
        </cfloop>
        <cfset Address=trim(Address)>
        <cfset loopCount = 1>
        
	    <cfloop from="#addLen#" to="1" step="-1" index="lstindx">
	     <cfif loopcount is 1 >
	    	<cfset Zipcode=listgetAt(NowAddress,lstindx," ")>
	     <cfelseif loopcount is 2>
	     	<cfset State11=listgetAt(NowAddress,lstindx," ")>
	     <cfelseif loopcount is 3>
	     	<cfset City=listgetAt(NowAddress,lstindx," ")>
	     <cfelse>        
	      <cfbreak>
	     </cfif>
	    <cfset loopCount = loopCount + 1>
	    </cfloop>

		 <cfset StateValCODE=State11>	 
		<cfset businessPhone = replacenocase(businessPhone,'(',"","all")>
		<cfset businessPhone = replacenocase(businessPhone,') ',"-","all")>
	    <cfset Phone=businessPhone>
                
        <cfif ISVALID("DATE",InsExpDateLive)>
		    <cfset InsExpDate=dateformat(InsExpDateLive,'mm/dd/yyyy')>
        <cfelse>
        	<cfset InsExpDate=''>
        </cfif>
        
	    <cfset bipd_Insurance_on_file = replace(bipd_Insurance_on_file,"$","","all")>
	    <cfset bipd_Insurance_on_file = replace(bipd_Insurance_on_file,",","","all")>
        
	</cfif>
<cfelse>
<cfset  ValidMCNO=0>
</cfif>	
<cfform name="frmCarrier" action="index.cfm?event=adddriver:process&#session.URLToken#&editid=#editid#" onsubmit="return InsAgentPhone1();" method="post">

<cfif isDefined("url.carrierid") and len(url.carrierid)>
 
	<cfinvoke component="#variables.objCarrierGateway#" method="getAttachedFiles" linkedid="#url.carrierid#" fileType="3" returnvariable="request.filesAttached" /> 
	<div class="search-panel" style="height:40px;">
		<div style="float: left; width: 13%;"><h1>Edit #variables.freightBroker#</h1></div>
		<div style="float: left; width: 80%; text-align: center;"><h1>#Ucase(CarrierName)#</h1></div>
		<div class="delbutton"><a href="index.cfm?event=carrier&carrierid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?','Delete #variables.freightBroker#');">Delete</a></div>
	</div>	
	<div class="search-panel" style="height:30px;">
		<div style="float:right">
			<input id="mailDocLink" style="width:110px !important;line-height: 15px;" type="button" class="normal-bttn"value="Email Doc" <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
		  <cfif requireValidMCNumber EQ True>	
			<cfinput name="Save" type="submit" class="normal-bttn" value="Save" onclick="return validateCarrier(frmCarrier,'#application.dsn#','#ValidMCNO#','driver');" onfocus="checkUnload();" style="width:44px;" />
		  <cfelse>
			<cfinput name="Save" type="submit" class="normal-bttn" value="Save" onclick="return validateCarrier(frmCarrier,'#application.dsn#');" onfocus="checkUnload();" style="width:44px;" />
		  </cfif>	
			<cfinput name="Return" type="button" class="normal-bttn" onclick="javascript:history.back();" value="Back" style="width:62px;line-height:15px;" />	

		</div>
	</div>
	</h1>
	 <div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		 <div style="float: left; width: 20%;" id="divUploadedFiles">
			 <cfif request.filesAttached.recordcount neq 0>
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.carrierid#&attachTo=3&user=#session.adminusername#&dsn=#dsn#&attachtype=Carrier')"><img style="vertical-align:bottom;" src="images/attachment.png">View/Attach Files</a>
			<cfelse>
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.carrierid#&attachTo=3&user=#session.adminusername#&dsn=#dsn#&attachtype=Carrier')"><img style="vertical-align:bottom;" src="images/attachment.png">Attach Files</a>

			</cfif>	

		</div>
		<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;">#variables.freightBroker# Information</h2></div>
		<div style="float: left; width: 34%;"><h2 style="color:white;font-weight:bold;">Remit Information</h2></div>
	</div>
	<div style="clear:left;"></div>
<cfelse>
	<cfset tempLoadId = #createUUID()#>
	 <cfset session.checkUnload ='add'>
	 
	<h1>Add New #variables.freightBroker#</h1>
		 <div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
			 <div style="float: left; width: 20%;" id="divUploadedFiles">
				 	&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempLoadId#&attachTo=3&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=Carrier')"><img style="vertical-align:bottom;" src="images/attachment.png">Attach Files</a>
			</div>
			<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;">#variables.freightBroker# Information</h2></div>
			<div style="float: left; width: 34%;"><h2 style="color:white;font-weight:bold;">Remit Information</h2></div>
		</div>
	<div style="clear:left;"></div>
</cfif>
<cfif isdefined("message") and len(message)> 
	<!---cfif message neq 'Data not available'>
		<div class="msg-area" style="margin:0;width:820px" >#message#</div>
	</cfif--->	
</cfif>

			<div class="white-con-area">
				<!---<div class="white-top"></div>--->

				<div class="white-mid">
                     <cfinput type="hidden" id="editid" name="editid" value="#editid#">
						<div class="form-con">
							<fieldset class="carrierFields">
                                <label>#variables.freightBrokerId# ##</label>
								<cfif requireValidMCNumber EQ True>
								  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#" onchange="getMCDetails('#getMCNoURL#',this.value,'#application.dsn#','driver');"  style="width:55px;"/>
								<cfelse>
								  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#" onchange="getMCDetails('#getMCNoURL#',this.value,'#application.dsn#','driver');" style="width:55px;" />
								</cfif>
                      		    <label style="width:50px;">Lic State:</label>
								<cfinput id="licState" type="text" tabindex="1" style="width:18px;" name="licState" maxlength="2" value="#licState#">
								<label style="width:25px;">DOB:</label>
								<cfinput name="DOBDate" tabindex="1" type="datefield" value="#Dateformat(DOBDate,'mm/dd/yyyy')#" style="width:60px" onblur="checkDateFormat(this);"/>
                      		    <div class="clear"></div>
                      		   
							    <label>Name *</label>
				       	        <cfinput name="CarrierName" type="text" tabindex="2" value="#CarrierName#"  required="yes" message="Please enter #variables.freightBroker# name" style="width:146px;"/>
				       			<label style="width:25px;">Hired:</label>
								<cfinput name="hiredDate" tabindex="2" type="datefield" value="#Dateformat(hiredDate,'mm/dd/yyyy')#" style="width:60px" onblur="checkDateFormat(this);"/>
								<div class="clear"></div>
								
				       	        <cfinput name="RegNumber" type="hidden" tabindex="3" value="#RegNumber#"/>
							   	<label>Address *</label>
								<textarea rows="2" tabindex="4" cols="" name="Address" style="height:auto;">#trim(Address)#</textarea>
								<div class="clear"></div>                                
								<label>City *</label>
								<cfinput name="City" id="City" tabindex="5" type="text" value="#City#" required="yes" message="Please enter a city"/>
								<div class="clear"></div>
								<label>State *</label>
                                <select name="State" id="state" tabindex="6" style="width:100px;">
                                    <option value="">Select</option>
                                    <cfloop query="request.qstates">
                                        <option value="#request.qstates.StateCode#" <cfif  request.qstates.STATECODE is StateValCODE> selected="selected" </cfif>>#request.qstates.statecode#</option>
                                   </cfloop>
                               </select>
								<label style="width:70px;">Zip* </label>
							   <!---  <cfinclude template="../customer/getcitystate.cfm"> --->
								<cfinput name="Zipcode" style="width:100px;" id="Zipcode" type="text" value="#Zipcode#" required="yes" tabindex="7" message="Please enter a zipcode"/>
							<div class="clear"></div>
							<label>Country *</label>
							<select name="Country" tabindex="8" style="width:128px;">
                                   <option value="">Select</option>
                                   <cfloop query="request.qCountries">
                                       <option value="#request.qCountries.CountryID#" <cfif request.qCountries.CountryID is Country1> selected="selected" </cfif>>#request.qCountries.Country#</option>
                                   </cfloop>                        
							</select>
							<label style="width:43px;">SS##</label>
							<cfinput name="ss" style="width:100px;" id="ss" type="text" value="#ss#" onchange="ParseSSNumber(this);" tabindex="8" message="Please enter a SS##" maxlength="11"/>
							<div class="clear"></div>
							<label>Phone*</label>
							<cfinput name="Phone" tabindex="9" type="text" value="#Phone#" onchange="ParseUSNumber(this);" style="width:122px;"/>
							<label style="width:35px;">Fax</label>
							<cfinput name="Fax" type="text" tabindex="10" value="#Fax#" style="width:100px;"/>
							<div class="clear"></div>				
							<label>Phone 2</label>
							<cfinput name="Tollfree" type="text" tabindex="11" value="#Tollfree#" style="width:122px;"/>
							<label style="width:35px;">Cell</label>
							<cfinput name="CellPhone" tabindex="12" type="text" value="#CellPhone#" style="width:100px;"/>
							<div class="clear"></div>
							<label>Email</label>
							<cfinput class="emailbox" name="Email" type="text" tabindex="13" value="#Email#"  validate="email"  />
							<div class="clear"></div>
							
							<label style="width:89px">CDL Expires</label>
							<cfinput name="CDLExpires" tabindex="14" type="datefield" value="#Dateformat(CDLExpires,'mm/dd/yyyy')#" style="width:64px" onblur="checkDateFormat(this);"/>
							
							<input name="HasmatLicense" type="hidden" value="False">
                            <label style="width:70px;">Equip</label>
                            <select name="equipment" tabindex="17" style="width:106px;">
                                     <option value="">Select</option>
                                     <cfloop query="request.qEquipments">
                                     <option value="#request.qEquipments.equipmentId#" <cfif equipment is request.qEquipments.equipmentId> selected="selected" </cfif>>#request.qEquipments.equipmentName#</option>
									</cfloop>
                            </select>
                            <div class="clear"></div>
							<label style="width:89px">Physical Expires</label>
							<cfinput name="InsExpDate" tabindex="17" type="datefield" value="#Dateformat(InsExpDate,'mm/dd/yyyy')#" style="width:64px" onblur="checkDateFormat(this);" />
							
							<label style="width:73px;">Emp. Type</label>
                            <select name="employeeType" tabindex="17" style="width:106px;">
								<option value="">Select</option>
								<option value="ownerOperator" <cfif employeeType EQ "ownerOperator"> selected="selected" </cfif>>Owner Operator</option>
								<option value="employee" <cfif employeeType EQ "employee"> selected="selected" </cfif>>Employee</option>
                            </select>
							<div class="clear"></div>
							
							<label style="width:89px">Last Drug Test</label>
							<cfinput name="lastDrugTest" tabindex="31" type="datefield" value="#Dateformat(lastDrugTest,'mm/dd/yyyy')#" style="width:64px"  onblur="checkDateFormat(this);" />
							<label style="width:73px;">Status</label>
                            <select name="Status" tabindex="31" style="width:106px;">
                                <option value="1" <cfif Status is 1> selected="selected" </cfif>>Active</option>
                                <option value="0" <cfif Status is 0> selected="selected" </cfif>>InActive</option>
                            </select>							
							<div class="clear"></div>
                            <!---<label>Rate Per Mile*</label>
                             <cfinput name="RatePerMile" type="text" tabindex="18" value="#RatePerMile#">--->
							<!---
							<cfif isdefined('url.CarrierId') and len(url.carrierId) gt 1>
								<div style="float:right;">
									<!---<label style="text-align:left;"><a class="link" href="index.cfm?event=load&#session.URLToken#&carrierId=#url.CarrierId#" target="_blank">CURRENT LOADS</a></label>--->
									<cfinput name="currentloads" type="button" class="normal-bttn" onclick="document.location.href='index.cfm?event=load&#session.URLToken#&carrierId=#url.CarrierId#'" value="CURRENT LOADS" style="width:62px;line-height:15px;margin-top:4px;" />	
								</div>
							</cfif>
							<div class="clear"></div>
							--->							
						 </fieldset>
					</div>
					<div class="form-con">
						<fieldset class="carrierFields">
							<!---<h2>Remit Information</h2>--->
							<div class="clear"></div>
							
							<cfif isdefined('url.CarrierId') and len(url.carrierId) gt 1>
								<div style="float:right;">
									<cfinput name="currentloads" type="button" class="normal-bttn" onclick="document.location.href='index.cfm?event=load&#session.URLToken#&carrierId=#url.CarrierId#'" value="CURRENT LOADS" style="width:62px;line-height:15px;margin-top:4px;" />	
								</div>
							</cfif>
							<div class="clear"></div>
							
							<label style="text-align:left;">#variables.freightBroker# Terms</label>
							<div class="clear"></div>
							<cftextarea name="Terms" tabindex="33" style="height:200px;width:400px" >#Terms#</cftextarea>
							<div class="clear"></div>
							
							<label style="text-align:left;width:125px;margin-left:6px;">#variables.freightBroker# Instructions</label>
							<div class="clear"></div>
							<textarea name="CarrierInstructions" tabindex="34" rows="" cols="" style="height:100px;width:400px">#CarrierInstructions#</textarea>
							<div class="clear"></div>							
						</fieldset>
					</div>
					<div class="clear"></div>
					<div class="gap"></div>
					
		
					<div class="clear"></div>
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;text-align:center;">
			<h2 style="color:white;font-weight:bold;">#variables.freightBroker# Commodity Pricing</h2>
		</div>
		<div class="carrier-mid" style="background-color: white;">
			<br/>
			<div><input type="button" onclick="addNewRow()" value="Add New Row"></div>
			<br/>
			<div class="commodityWrap">
				<table id="tblrow"  class="noh" border="0" cellspacing="0" cellpadding="0">
					<thead>
						<tr>
							<th align="left" width="5" valign="top"><img src="images/top-left.gif" alt=""  height="23" /></th>
							<th align="center" valign="middle" class="head-bg" style="text-align:center;">Type</th>
							<th align="left" valign="middle" class="head-bg" style="text-align:center;">#variables.freightBrokerShortForm#.rate</th>
							<th align="left" valign="middle" class="head-bg" style="text-align:center;">#variables.freightBrokerShortForm#.% of Cust Total</th>
							<th valign="top" width="5" align="right" style="left: -1px;position: relative;"><img src="images/top-right.gif" alt="" width="5" height="23"></th>
						</tr>
					</thead>					
					<tbody>
						<cfset variables.leftIndex=5>
						<cfif IsDefined("request.qGetCommodityById") and request.qGetCommodityById.recordcount >
							<cfloop query="#request.qGetCommodityById#">
								<tr>
									<td height="20"  width="5"  class="lft-bg">&nbsp;</td>
									<td class="normaltd" valign="middle" align="left" style="width:274px;position:relative;top:-#variables.leftIndex#px;padding:8px 0px;">
										<select name="sel_commodityType_#request.qGetCommodityById.currentrow#" id="type" class="sel_commodityType" style="width:240px;height:26px;">
										  <option value=""></option>
										  <cfloop query="request.qUnits">
											<option value="#request.qUnits.unitID#" <cfif request.qGetCommodityById.COMMODITYID eq request.qUnits.unitID >selected</cfif> >#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
										  </cfloop>
										</select>
										<input type="hidden" value="1" name="numberOfCommodity">
									</td>
									
									<td class="normaltd" valign="middle" align="left"  style="width:142px;position:relative;top:-5px;"><input type="text" name="txt_carrRateComm_#request.qGetCommodityById.currentrow#" class="txt_carrRateComm q-textbox" value="$#request.qGetCommodityById.carrrate#"></td>
									<td class="normaltd" colspan="2" valign="middle" align="left"  style="width:132px;position:relative;top:-5px;"><input type="text" name="txt_custRateComm_#request.qGetCommodityById.currentrow#" id="txt_custRateComm_#request.qGetCommodityById.currentrow#" class="txt_custRateComm q-textbox" value="#request.qGetCommodityById.CarrRateOfCustTotal#%" onChange="ConfirmMessage('#request.qGetCommodityById.currentrow#',0)"></td>
								</tr><cfset variables.leftIndex=variables.leftIndex+2>
							</cfloop>
							
						<cfelse>
							<tr>
									<td height="20"  width="5"  class="lft-bg">&nbsp;</td>
									<td class="normaltd" valign="middle" align="left" style="width:274px;position:relative;top:-#variables.leftIndex#px;padding:8px 0px;">
										<select name="sel_commodityType_1" id="type" class="sel_commodityType" style="width:240px;height:26px;">
										  <option value=""></option>
										  <cfloop query="request.qUnits">
											<option value="#request.qUnits.unitID#"  >#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
										  </cfloop>
										</select>
										<input type="hidden" value="1" name="numberOfCommodity">
									</td>
									
									<td class="normaltd" valign="middle" align="left"  style="width:142px;position:relative;top:-5px;"><input type="text" name="txt_carrRateComm_1" class="txt_carrRateComm q-textbox" value="0"></td>
									<td class="normaltd" colspan="2" valign="middle" align="left"  style="width:132px;position:relative;top:-5px;"><input type="text" name="txt_custRateComm_1" class="txt_custRateComm q-textbox" value="0"></td>
								</tr><cfset variables.leftIndex=variables.leftIndex+2>
						</cfif>
					</tbody>
					<tfoot>
						<tr>
							<td width="5" align="left" valign="top" style="position:relative;top:-6px;"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
							<td colspan="2" align="left" valign="middle" style="position:relative;top:-6px;" class="footer-bg"></td>
							<td colspan="1" align="left" valign="middle" style="position:relative;top:-6px;" class="footer-bg"></td>
							<td width="5" style="position:relative;top:-6px;" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
						</tr>	
					</tfoot>
				</table>
			</div>
		</div>	
		
		
		<div class="clear"></div>

		<div class="form-con" style="height:98px;">
				<fieldset class="carrierFields">
					<label style="width:38px">Notes</label>
					<cftextarea rows="7" style="width: 80%; height: 107px;" name="Notes">#notes#</cftextarea>
					<div class="clear"></div>
					
				</fieldset>
		<div class="clear"></div>
		</div>

		<div class="form-con" style="height:98px;">
				<fieldset class="carrierFields">
					<label style="width:98px">Equipment Notes</label> 
					<cftextarea rows="5" style="width: 70%; height: 79px;" name="EquipmentNotes" id="EquipmentNotes" onkeypress="checkmaxlength()">#EquipmentNotes#</cftextarea>
                     <div class="clear"></div>
					<label>&nbsp;</label>					
					<div class="clear"></div>
				</fieldset>

		<div class="clear"></div>
		</div>
		<div class="clear"></div>
		<div class="form-con">&nbsp;</div>
		<div class="form-con">
		<fieldset class="carrierFields">
			<div style="padding-left:120px;">
			<cfif requireValidMCNumber EQ True>	
				<cfinput name="Save" type="submit" class="normal-bttn" value="Save" onclick="return validateCarrier(frmCarrier,'#application.dsn#','#ValidMCNO#','driver');" onfocus="checkUnload();" style="width:44px;" />
			<cfelse>
				<cfinput name="Save" type="submit" class="normal-bttn" value="Save" onclick="return validateCarrier(frmCarrier,'#application.dsn#');" onfocus="checkUnload();" style="width:44px;" />
			</cfif>
			<!---cfinput name="Save" type="submit" class="normal-bttn" value="Save"  onfocus="checkUnload();" style="width:44px;" /--->
			<cfinput name="Return" type="button" class="normal-bttn" onclick="javascript:history.back();" value="Back" style="width:62px;" />
			</div>
		</fieldset>
		</div>
		<div class="clear"></div>
		
		<cfif isDefined("url.carrierid") and len(url.carrierid) gt 1>
          <p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;">Last Updated:<cfif isDefined("request.qCarrier")>&nbsp;&nbsp;&nbsp; #request.qCarrier.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qCarrier.LastModifiedBy#</cfif></p>
       </cfif>
	</div>
	</cfform>
		<div class="white-bot"></div>
</div>
<br/><br/><br/>
<script type="text/javascript">
		$(document).ready(function(){
			 $('##mailDocLink').click(function(){
				if($(this).attr('data-allowmail') == 'false')
				alert('You must setup your email address in your profile before you can email documents.');
				else
					mailDocOnClick('#session.URLToken#','carrier'<cfif isDefined("url.carrierid") and len(url.carrierid) gt 1>,'#url.carrierid#'</cfif>);
			 });
		});
</script>
</cfoutput>	
