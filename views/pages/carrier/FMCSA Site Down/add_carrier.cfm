
<cfoutput>
	<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer">
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
	<cfelse>
		<cfset variables.freightBroker = "Driver">
	</cfif>
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
	<cfparam name="businessAddress" default="">
	<cfparam name="businessPhone" default="">
	<cfparam name="insCarrier" default="">
	<cfparam name="insPolicy" default="">
	<cfparam name="insAgentName" default="">
	<cfparam name="insCarrierDetails" default="">
	<cfparam name="Status" default="">
	<cfparam name="StatusValID" default="">
	<cfparam name="StatusValCODE" default="">
	<cfparam name="CarrierName" default="">
	<cfparam name="City" default="">
	<cfparam name="State" default="">
	<cfparam name="State1" default="">
	<cfparam name="Address" default="">
	<cfparam name="Zipcode" default="">
	<cfparam name="Country" default="">
	<cfparam name="Country1" default="9bc066a3-2961-4410-b4ed-537cf4ee282a">
	<cfparam name="Phone" default="">
	<cfparam name="CellPhone" default="">
	<cfparam name="Fax" default="">
	<cfparam name="RemitName" default="">
	<cfparam name="RemitAddress" default="">
	<cfparam name="RemitCity" default="">
	<cfparam name="RemitState" default="">
	<cfparam name="RemitZipCode" default="">
	<cfparam name="RemitContact" default="">
	<cfparam name="RemitPhone" default="">
	<cfparam name="RemitFax" default="">
	<cfparam name="Tollfree" default="">
	<cfparam name="Email" default="">
	<cfparam name="Website" default="">
	<cfparam name="InsCompany" default="">
	<cfparam name="InsComPhone" default="">
	<cfparam name="InsAgent" default="">
	<cfparam name="InsAgentPhone" default="">
	<cfparam name="InsPolicyNo" default="">
	<cfparam name="InsExpDate" default="">
	<cfparam name="InsExpDateLive" default="">
	<cfparam name="CargoAmount" default="">
	<cfparam name="Certificate" default="">
	<cfparam name="Terms" default="">
	<cfparam name="TaxID" default="">
	<cfparam name="Track1099" default="">
	<cfparam name="RegNumber" default="">
	<cfparam name="ContactPerson" default="">
	<!---<cfparam name="RatePerMile" default="0">--->
	<cfparam name="Dispatcher" default="">
	<cfparam name="TaxID" default="">
	<cfparam name="equipment" default="">
	<cfparam name="InsLimit" default="">
	<cfparam name="CommRate" default="">
	<cfparam name="CarrierInstructions" default="">
	<cfparam name="EquipmentNotes" default="">
	<cfparam name="Website" default="">
	<cfparam name="editid" default="0">
	<cfparam name="state11" default="">
	<!--- <cfparam name="url.mcNo" default="0"> --->
	<cfparam name="StateValCODE" default="">
	<cfparam name="notes" default="">
	<cfparam name="variables.InsuranceCompanyName" default="">
	<cfparam name="variables.InsuranceCompanyAddress" default="">
	<cfparam name="variables.ExpirationDate" default="">
	<cfparam name="variables.commonStatus" default="1">
	<cfparam name="variables.contractstatus" default="1">
	<cfparam name="variables.brokerStatus" default="1">
	<cfparam name="variables.commonAppPending" default="1">
	<cfparam name="variables.contractAppPending" default="1">
	<cfparam name="variables.BrokerAppPending" default="1">
	<cfparam name="variables.BIPDInsRequired" default="1">
	<cfparam name="variables.cargoInsRequired" default="1">
	<cfparam name="variables.BIPDInsonFile" default="1">
	<cfparam name="variables.householdGoods" default="1">
	<cfparam name="variables.cargoInsonFile" default="1">
	<cfparam name="variables.CARGOExpirationDate" default="">
	<cfparam name="vendorID" default="">
	<cfparam name="variables.InsAddress" default="">
	<cfparam name="variables.formatRequired" default="">
	<cfparam name="DOTNumber" default="">
	<!--- Encrypt String --->
	<cfset Secret = application.dsn>
	<cfset TheKey = 'NAMASKARAM'>
	<cfset Encrypted = Encrypt(Secret, TheKey)>
	<cfset dsn = ToBase64(Encrypted)>
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
		newwindow=window.open(url,'Map','height=600,width=800');
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
	</script>

	<cfif isDefined("url.carrierid") and len(url.carrierid) >
		<cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier">
			<cfinvokeargument name="carrierid" value="#url.carrierid#">
		</cfinvoke>
		<cfinvoke component="#variables.objCarrierGateway#" method="getlifmcaDetails" returnvariable="request.qrygetlifmcaDetails">
			<cfinvokeargument name="carrierid" value="#url.carrierid#">
		</cfinvoke>
		<cfif not structkeyexists(url,"apidetails")>
			<cfif request.qrygetlifmcaDetails.recordcount>
				<cfset variables.InsuranceCompanyName=request.qrygetlifmcaDetails.InsuranceCompanyName>
				<cfset variables.InsuranceCompanyAddress=request.qrygetlifmcaDetails.InsuranceCompanyAddress>
				<cfset variables.ExpirationDate=request.qrygetlifmcaDetails.ExpirationDate>
				<cfset variables.commonStatus=request.qrygetlifmcaDetails.commonStatus>
				<cfset variables.contractStatus=request.qrygetlifmcaDetails.contractStatus>
				<cfset variables.brokerStatus=request.qrygetlifmcaDetails.brokerStatus>
				<cfset variables.commonAppPending=request.qrygetlifmcaDetails.commonAppPending>
				<cfset variables.contractAppPending=request.qrygetlifmcaDetails.contractAppPending>
				<cfset variables.BrokerAppPending=request.qrygetlifmcaDetails.BrokerAppPending>
				<cfset variables.BIPDInsRequired=request.qrygetlifmcaDetails.BIPDInsRequired>
				<cfset variables.cargoInsRequired=request.qrygetlifmcaDetails.cargoInsRequired>
				<cfset variables.BIPDInsonFile=request.qrygetlifmcaDetails.BIPDInsonFile>
				<cfset variables.cargoInsonFile=request.qrygetlifmcaDetails.cargoInsonFile>
				<cfset variables.householdGoods=request.qrygetlifmcaDetails.householdGoods>
				<cfset variables.CARGOExpirationDate=request.qrygetlifmcaDetails.CARGOExpirationDate>
			</cfif>
			<cfset MCNumber=request.qCarrier.MCNumber>
			<cfset variables.carrierId=url.carrierid>
		<cfelse>
			<cfset variables.carrierId=url.carrierid>
		</cfif>	
	<cfelse>
		<cfset variables.carrierId=0>
						
	</cfif>
	<!--- if updLIData exists in the url, then do the webservice call and update the db --->
	<!---cfif (isdefined('url.updLIData') or len('MCNumber')) and isdefined('url.carrierID')>
		<cfinclude template="websiteDATA.cfm">
		<cfinvoke component="#variables.objCarrierGateway#" method="EditLIWebsiteData" returnvariable="message">
			 <cfinvokeargument name="carrierId" value="#url.carrierID#">
		 </cfinvoke>
		 <cfif not StructKeyExists(url,"updLIData")>
			<cfset message="">
		 </cfif>
	</cfif--->
	<cfset variables.objunitGateway = getGateway("gateways.unitgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#")) >
	<cfinvoke component="#variables.objunitGateway#" method="getloadUnits" status="True" returnvariable="request.qUnits" />
<cfif isDefined("url.carrierid") and len(url.carrierid) and not structkeyexists(url,"apidetails")>
	
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
			 <cfset RemitName=request.qCarrier.RemitName>
			 <cfset RemitAddress=request.qCarrier.RemitAddress>
			 <cfset RemitCity=request.qCarrier.RemitCity>
			 <cfset RemitState=request.qCarrier.RemitState>
			 <cfset RemitZipCode=request.qCarrier.RemitZipCode>
			 <cfset RemitContact=request.qCarrier.RemitContact>
			 <cfset RemitPhone=request.qCarrier.RemitPhone>
			 <cfset RemitFax=request.qCarrier.RemitFax>
			 <cfset InsCompany=request.qCarrier.InsCompany>
			 <cfset InsComPhone=request.qCarrier.InsCompPhone>
			 <cfset InsAgent=request.qCarrier.InsAgent> 
			 <cfset InsAgentPhone=request.qCarrier.InsAgentPhone>
			 <cfset InsPolicyNo=request.qCarrier.InsPolicyNumber>
			 <cfset InsExpDate=request.qCarrier.InsExpDate>
			 <cfset DOTNumber=request.qCarrier.DOTNUMBER>
		</cfif>
		 <cfset CellPhone=request.qCarrier.Cel>
		 <cfset Fax=request.qCarrier.Fax> 
		 <cfset Tollfree=request.qCarrier.Tollfree>
		 <cfset Email=request.qCarrier.EmailID>
		 <cfset TaxID=request.qCarrier.TaxID>
		 <cfset Track1099=request.qCarrier.Track1099> 
		 <cfset RegNumber=request.qCarrier.RegNumber> 
		 <cfset ContactPerson=request.qCarrier.ContactPerson>
	<!---         <cfset RatePerMile=request.qCarrier.RatePrMile>--->
		 <cfset equipment=request.qCarrier.EquipmentID>
		 <cfset InsLimit=request.qCarrier.InsLimit>
		 <cfset CommRate=request.qCarrier.CommRate>
		 <cfset InsExpDate=request.qCarrier.InsExpDate>
		 <cfset CarrierInstructions=request.qCarrier.CarrierInstructions>
		 <cfset EquipmentNotes=request.qCarrier.EquipmentNotes>
		 <cfset Website=request.qCarrier.Website>
		 <cfset notes =request.qCarrier.notes>
		 <cfset Terms =request.qCarrier.CarrierTerms>
		 <cfset editid=#url.carrierid#>
		 <cfset vendorID=request.qCarrier.VENDORID>
		 <cfset getMCNoURL="index.cfm?event=addcarrier&carrierid=#url.carrierid#&#session.URLToken#"> 
	       <!--- since the carrierid exists so pick the data from the carriersLNI and update the session variables and donot make a webservice call --->
<!---	     <cfinclude template="dbwebsiteDATA.cfm"> 
	     <!--- end --->
	     <cfif (isdefined('url.updLIData') or len(request.qCarrier.MCNumber)) and isdefined('url.carrierID')>
	         <cfset CarrierName=pv_legal_name>
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
		     <cfset InsCompany=insCarrier>
		     <cfset InsAgent=trim(replacenocase(insAgentName,"<br/>","","all"))> 
		     <cfset InsAgentPhone=insAgentPhone>
		     <cfset InsPolicyNo=InsPolicy>
		     <cfset InsExpDate=dateformat(InsExpDateLive,'mm/dd/yyyy')>
		     <cfset bipd_Insurance_on_file = replace(bipd_Insurance_on_file,"$","","all")>
		     <cfset bipd_Insurance_on_file = replace(bipd_Insurance_on_file,",","","all")>
		     <cfset InsLimit=val(bipd_Insurance_on_file)>
	     </cfif>--->
	</cfif>
<cfelse>
	<cfif structkeyexists(url,"apidetails")>
		<cfset editid=#url.carrierid#>
		<cfset getMCNoURL="index.cfm?event=addcarrier&carrierid=#url.carrierid#&#session.URLToken#"> 
	<cfelse>
		<cfset getMCNoURL="index.cfm?event=addcarrier&#session.URLToken#">
		 
	</cfif>
	
	<cfif isdefined('url.mcNo') and len(url.mcNo) gt 1>
   		<!--- Since carrierid doesnot exists so here make a webservice call --->
    		<cfinclude template="websiteDATACarrier.cfm"> 
		<!--- end --->
	<cfelseif isdefined('url.DOTNumber') and len(url.DOTNumber) gt 1>
		<!--- Since carrierid doesnot exists so here make a webservice call --->
    		<cfinclude template="websiteDATACarrier.cfm"> 
		<!--- end --->  	
    </cfif>
</cfif>
   <cfif len(CarrierName)> 
    <cfset ValidMCNO=1>      
   	<!--- <cfset CarrOrgName=pv_legal_name>
	<cfset pv_legal_name = Replace(pv_legal_name,"&","~","all")>
	<cfloop list="#pv_legal_name#" index="ldrIndx" delimiters=" ">
		<cfset webLegger = listAppend(webLegger,ldrIndx,"^")>
	</cfloop> --->
	

	<cfif structKeyExists(url, "mcNo") or structKeyExists(url, "DOTNumber")>
	    <cfset InsPolicyNo=insPolicy>
	    <cfset InsComPhone=InsAgentPhone>
	    <cfset InsAgentPhone=InsAgentPhone>
	    <cfset variables.InsuranceCompanyAddress=trim(variables.formatRequired)>
 	    <cfset InsAgent=replacenocase(insAgentName,'<br/>','',"all")>
		 <cfset StateValCODE=State11>	 
		<cfset businessPhone = replacenocase(businessPhone,'(',"","all")>
		<cfset businessPhone = replacenocase(businessPhone,') ',"-","all")>
	    <cfset Phone=businessPhone>
	    <cfset InsCompany=insCarrier>
        <cfif ISVALID("DATE",InsExpDateLive)>
		     <cfset InsExpDate=dateformat(InsExpDateLive,'mm/dd/yyyy')>
        <cfelse>
        	<cfset InsExpDate=''>
        </cfif>
        
	    <cfset bipd_Insurance_on_file = replace(bipd_Insurance_on_file,"$","","all")>
	    <cfset bipd_Insurance_on_file = replace(bipd_Insurance_on_file,",","","all")>
	    <cfset InsLimit=val(bipd_Insurance_on_file)*1000>
        
	</cfif>
<cfelse>
	<cfset  ValidMCNO=0>
</cfif>	

<cfform name="frmCarrier" action="index.cfm?event=addcarrier:process&#session.URLToken#&editid=#editid#" onsubmit="return InsAgentPhone1();" method="post">
	<cfif isDefined("url.carrierid") and len(url.carrierid)>
	<cfinvoke component="#variables.objCarrierGateway#" method="getAttachedFiles" linkedid="#url.carrierid#" fileType="3" returnvariable="request.filesAttached" /> 
	<div class="search-panel" style="height:40px;">
		<div style="float: left; width: 13%;"><h1>Edit Carrier</h1></div>
		<div style="float: left; width: 80%; text-align: center;"><h1>#Ucase(CarrierName)#</h1></div>
		<div class="delbutton"><a href="index.cfm?event=carrier&carrierid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?','Delete Carrier');">Delete</a></div>
	</div>	
	<div class="search-panel" style="height:30px;">
		<div style="float:right">
			<input id="mailDocLink" style="width:110px !important;line-height: 15px;" type="button" class="normal-bttn"value="Email Doc" <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
		  <cfif requireValidMCNumber EQ True>	
			<cfinput name="Save" type="submit" class="normal-bttn" value="Save" onclick="return validateCarrier(frmCarrier,'#application.dsn#','#ValidMCNO#','driver');" onfocus="checkUnload();" style="width:44px;" />
		  <cfelse>
			<cfinput name="Save" type="submit" class="normal-bttn" value="Save" onclick="return validateCarrier(frmCarrier,'#application.dsn#');" onfocus="checkUnload();" style="width:44px;" />
		  </cfif>	
			<cfinput name="Update" id="update_btn" type="button" class="normal-bttn"  onclick="return getConfirmation();" value="Update Via FMCSA" style="width:62px;line-height:15px;" />	
		</div>
	</div>
	</h1>
	 <div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		 <div style="float: left; width: 20%;" id="divUploadedFiles">
			 <cfif request.filesAttached.recordcount neq 0>
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.carrierid#&attachTo=3&user=#session.adminusername#&dsn=#dsn#&attachtype=Carrier')"><img style="vertical-align:bottom;" src="images/attachment.png">View/Attach Files</a>
			<cfelse>
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload//multipleFileupload/MultipleUpload.cfm?id=#url.carrierid#&attachTo=3&user=#session.adminusername#&dsn=#dsn#&attachtype=Carrier')"><img style="vertical-align:bottom;" src="images/attachment.png">Attach Files</a>

			</cfif>	

		</div>
		<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;">Carrier Information</h2></div>
		<div style="float: left; width: 34%;"><h2 style="color:white;font-weight:bold;">Remit Information</h2></div>
	</div>
	<div style="clear:left;"></div>
<cfelse>
	<cfset tempLoadId = #createUUID()#>
	 <cfset session.checkUnload ='add'>
	<div>
		<div style="float:left;">
			<h1>Add New Carrier</h1>
		</div>
		<cfif not isDefined("url.carrierid")>
			<fieldset class="carrierFields">
				<div style="float:right;margin-top: 10px;margin-right: 147px;">
					<cfinput name="Save" type="submit" class="normal-bttn" value="Save"  onfocus="checkUnload();" style="width:44px;"/>
					<cfinput name="Return" type="button" class="normal-bttn" onclick="javascript:history.back();" value="Back" style="width:62px;" />
				</div>
				<div style="clear:both;"></div>
			</fieldset>
		</cfif>	
		<div style="clear:both;"></div>
	</div>
		 <div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
			 <div style="float: left; width: 20%;" id="divUploadedFiles">
				 	&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempLoadId#&attachTo=3&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=Carrier')"><img style="vertical-align:bottom;" src="images/attachment.png">Attach Files</a>
			</div>
			<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;">Carrier Information</h2></div>
			<div style="float: left; width: 34%;"><h2 style="color:white;font-weight:bold;">Remit Information</h2></div>
		</div>
	<div style="clear:left;"></div>
</cfif>
<cfif isdefined("message") and len(message)>
<div class="msg-area" style="margin-left: 13px;">#message#</div>
</cfif>

			<div class="white-con-area">
				<!---<div class="white-top"></div>onchange="getMCDetails('#getMCNoURL#',this.value,'#application.dsn#','carrier');" --->
				
				<!--- <div class="gap"></div> --->
				<div class="white-mid">
                     <cfinput type="hidden" id="editid" name="editid" value="#editid#">
						<div class="form-con">
							<fieldset class="carrierFields">
                                <label>MC ##</label>
								<cfif requireValidMCNumber EQ True>
								  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#"  required="yes" message="Please enter MC Number"/>
								<cfelse>
								  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#" onchange="getMCDetails('#getMCNoURL#',this.value,'#application.dsn#','carrier');" />
								</cfif>
                      		    <label class="DOTNumber">DOT ##</label>
                      		    <cfif structkeyexists(url,"DOTNumber")>
                      		    	<cfinput name="DOTNumber" id="DOTNumber" type="text" value="#Dotnumber#"/>
                      		    <cfelse>
									<cfinput name="DOTNumber" id="DOTNumber" type="text" value="#DOTNumber#"/>
                      		    </cfif>	
                      		    		
                      		    <div class="clear"></div>
                      		    <label>Name *</label>
				       	        <cfinput name="CarrierName" type="text" tabindex="2" value="#CarrierName#"  required="yes" message="Please enter carrier name"/>
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
<!--- <cfloop query="request.qstates">
<option value="#request.qstates.StateCode#" <cfif ucase(request.qstates.StateCode) eq #ucase(StateValCODE)#> selected="true"</cfif>>#request.qstates.statecode#</option>
</cfloop> --->
                               </select>
								<label style="width:70px;">Zip* </label>
							   <!---  <cfinclude template="../customer/getcitystate.cfm"> --->
								<cfinput name="Zipcode" style="width:100px;" id="Zipcode" type="text" value="#Zipcode#" required="yes" tabindex="7" message="Please enter a zipcode"/>
							<div class="clear"></div>
							<label>Country *</label>
							<select name="Country" tabindex="8">
                                   <option value="">Select</option>
                                   <!--- <cfloop query="request.qCountries">
                                       <option value="#request.qCountries.CountryID#" <cfif request.qCountries.CountryID is Country1> selected="true"</cfif>>#request.qCountries.Country#</option>
                                   </cfloop>  --->                       
							</select>
							<div class="clear"></div>
							<label>Phone*</label>
							<cfinput name="Phone" tabindex="9" type="text" value="#Phone#" onchange="ParseUSNumber(this);" style="width:122px;"/>
							<label style="width:35px;">Fax</label>
							<cfinput name="Fax" type="text" tabindex="11" value="#Fax#" style="width:100px;"/>
							<div class="clear"></div>				
							<label>Toll Free</label>
							<cfinput name="Tollfree" type="text" tabindex="12" value="#Tollfree#" style="width:122px;"/>
							<label style="width:35px;">Cell</label>
							<cfinput name="CellPhone" tabindex="10" type="text" value="#CellPhone#" style="width:100px;"/>
							<div class="clear"></div>
							<label>Email</label>
							<cfinput class="emailbox" name="Email" type="text" tabindex="13" value="#Email#"  validate="email"  />
							<div class="clear"></div>
							<label>Website</label>
							<cfinput class="emailbox" name="Website" type="text" tabindex="14"  value="#Website#"/>
							<div class="clear"></div>
                               <label>Contact Person</label>
                               <cfinput name="ContactPerson" type="text" tabindex="15" value="#ContactPerson#">
							<div class="clear"></div>
                               <label>Status</label>
                               <select name="Status" tabindex="16" style="width:100px;">
                                <option value="1" <cfif Status is 1> selected="true" </cfif>>Active</option>
                                <option value="0" <cfif Status is 0> selected="true" </cfif>>InActive</option>
                               </select>
								<input name="HasmatLicense" type="hidden" value="False">
                               <!---  <input name="equipment" type="hidden" > --->
                               <label style="width:70px;">Equip</label>
                                   <select name="equipment" tabindex="17" style="width:106px;">
                                     <option value="">Select</option>
                                     <cfloop query="request.qEquipments">
                                     <option value="#request.qEquipments.equipmentId#" <cfif equipment is request.qEquipments.equipmentId> selected="true" </cfif>>#request.qEquipments.equipmentName#</option>
									</cfloop>
                                 </select>
                               <div class="clear"></div>
                               <label class="FedTaxId">Fed Tax ID</label>
								<cfinput name="TaxID" type="text" value="#TaxID#" tabindex="35" style="width:120px;"/>
								<label style="width:60px;">Track 1099</label>
								<select name="Track1099" tabindex="36" style="width:96px;">
									<option value="True" <cfif Track1099 is 'True'> selected="true" </cfif>>True</option>
									<option value="False" <cfif Track1099 is 'False'> selected="true" </cfif>>False</option>
								</select>
								<div class="clear"></div>
                                <label>Vendor Code</label>
                               	<cfinput name="venderId" type="text" tabindex="18" value="#vendorID#">
							<cfif isdefined('url.CarrierId') and len(url.carrierId) gt 1>
								<div style="float:right;">
									<!---<label style="text-align:left;"><a class="link" href="index.cfm?event=load&#session.URLToken#&carrierId=#url.CarrierId#" target="_blank">CURRENT LOADS</a></label>--->
									<cfinput name="currentloads" type="button" class="normal-bttn" onclick="document.location.href='index.cfm?event=load&#session.URLToken#&carrierId=#url.CarrierId#'" value="CURRENT LOADS" style="width:62px;line-height:15px;margin-top:4px;" />	
								</div>
							</cfif>
							<div class="clear"></div>
							<div>
								<label style="text-align:left;">#variables.freightBroker# Notes</label> 
								<cftextarea name="Terms" style="height:200px;width:400px" >#Terms#</cftextarea>
								<div class="clear"></div>
							 </div>
						 </fieldset>
					</div>
					
						<!---div class="form-con">
						<fieldset>
							<div style="padding-left:120px;">
							<cfinput name="Save" type="submit" class="normal-bttn" value="Save" onclick="return validateCarrier(frmCarrier,'#application.dsn#','#ValidMCNO#');" onfocus="checkUnload();" style="width:44px;" />
							<cfinput name="Return" type="button" class="normal-bttn" onclick="javascript:history.back();" value="Back" style="width:62px;" />
							</div>
						</fieldset>
						</div--->
						<div class="form-con">
						<fieldset class="carrierFields">
							<!---<h2>Remit Information</h2>--->
							<div class="clear"></div>
                      		<label>Remit Name</label>
							<cfinput name="RemitName" type="text" tabindex="18" value="#RemitName#"/>
							<div class="clear"></div>
							<label>Remit Address</label>
							<textarea rows="2" tabindex="19" cols="" name="RemitAddress" style="height:auto;">#trim(RemitAddress)#</textarea>
							<div class="clear"></div>                                
							<label>Remit City</label>
							<cfinput name="RemitCity" id="RemitCity" tabindex="20" type="text" value="#RemitCity#" style="width:90px;"/>
							<label style="width:77px;">Remit State</label>  
								
							<cfselect name="RemitState" id="RemitState" tabindex="21" style="width:96px;">
								<option value="">Select</option>
								<cfloop query="request.qstates">
									<option value="#request.qstates.statecode#" <cfif  request.qstates.statecode is RemitState> selected="true" </cfif>>#request.qstates.statecode#</option>
							   </cfloop>
						   </cfselect>
							<div class="clear"></div>  
							<label>Remit Zipcode</label>
							<cfinput name="RemitZipcode" type="text" value="#RemitZipcode#" tabindex="22" style="width:90px;"/>
							<label style="width:77px;">Remit Contact</label>
							<cfinput name="RemitContact" tabindex="23" type="text" value="#RemitContact#" onchange="ParseUSNumber(this);" style="width:90px;"/>
							<div class="clear"></div>
							<label>Remit Phone</label>
							<cfinput name="RemitPhone" tabindex="24" type="text" value="#RemitPhone#" style="width:90px"/>
							<label style="width:77px;">Remit Fax</label>
							<cfinput name="RemitFax" type="text" tabindex="25" value="#RemitFax#" style="width:90px;"/>
							<div class="clear"></div>
							<div style="height: 36px;background-color: ##82bbef;margin-bottom: 5px;">
								<h2 style="color:white;font-weight:bold;padding-top: 10px;">Insurance</h2>
							</div>
							<label style="width:281px;text-align:left;padding-left:10px;">Company</label>
							<label style="text-align:left;">Phone</label>
							<div class="clear"></div>
							<cfinput name="InsCompany" tabindex="26" type="text" value="#InsCompany#" style="width:274px;margin-left:10px;"/>
							<cfinput name="InsComPhone" tabindex="27" type="text" value="#trim(InsComPhone)#" onchange="ParseUSNumber(this);" style="width:90px;"/>
							<div class="clear"></div>
							<label style="width:281px;text-align:left;padding-left:10px;">Agent</label>
							<label style="text-align:left;">Agent Phone</label>
							<div class="clear"></div>
							<cfinput name="InsAgent" id="InsAgent" tabindex="28" type="text" value="#trim(InsAgent)#" style="width:274px;margin-left:10px;"/>
                            <!--- <cfif isdefined('request.qCarrier.InsAgentPhone')>
	                            <cfset InsAgentPhone = request.qCarrier.InsAgentPhone>
                            </cfif> --->
	
    						<cfinput name="InsAgentPhone"  id="InsAgentPhone" tabindex="29" type="text" value="#trim(InsAgentPhone)#" onchange="ParseUSNumber(this);" style="width:90px;"/>
							<div class="clear"></div>

							<label style="margin-left: -36px;">Address</label>
							<div class="clear"></div>
							<textarea name="InsuranceCompanyAddress" id="InsuranceCompanyAddress" class="textBoxCarrierInsurance" placeholder="Company Address" rows="4">#trim(variables.InsuranceCompanyAddress)#</textarea>
							<div class="clear"></div>
							<label>Policy ##</label>
							<cfinput name="InsPolicyNo" tabindex="30" type="text" value="#InsPolicyNo#" style="width:90px"/>
							<label style="width:89px">Expiration Date</label>
							<cfif isdate(InsExpDate)>
								<cfinput name="InsExpDate" tabindex="31" type="datefield" value="#Dateformat(InsExpDate,'mm/dd/yyyy')#" style="width:64px" onblur="checkDateFormatAll(this);"/>
							<cfelse>
								<cfinput name="InsExpDate" tabindex="31" type="datefield" value="" style="width:64px" onblur="checkDateFormatAll(this);"/>
							</cfif>
							
							<div class="clear"></div>
							<label>Insurance Limit</label>
							<input type="text" name="InsLimit" tabindex="32" value="#DollarFormat(InsLimit)#" validate="float" style="width:79px;text-align: right;">
							<label style="width: 100px; font-size: 10px">Household Goods:</label>
							<select name="householdGoods" id="householdGoods" class="activeSelectbox">
								<option value="1" <cfif variables.householdGoods eq 1>selected="true"</cfif>>Yes</option>
								<option value="0" <cfif variables.householdGoods eq 0>selected="true"</cfif>>No</option>
							</select>
							<!--- <cfinput type="text" name="CommRate" tabindex="33" value="#numberformat(CommRate,"0.00")#" validate="float" message="Please enter numeric value" style="width:64px;text-align: right;">% --->
							<div class="clear"></div>   
							<!--- Insurance Boxes 1 --->
							<table width="237" border="0" cellspacing="0" cellpadding="0" class="noh" bgcolor="" style="    padding-bottom: 9px; margin-left: 76px !important;">
								<thead>
									<tr>
										<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
										<th align="center" valign="middle" class="head-bg">Authority Type</th>
										<th align="center" valign="middle" class="head-bg">Status</th>
										<th align="center" valign="middle" class="head-bg2">App. Pending</th>
										<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
									</tr>
								</thead>
								<tbody>
									<tr bgcolor="##f7f7f7" >
										<td colspan="2" class="head-bg lft-bg" valign="middle" align="center">COMMON</td>
										<td valign="middle" align="center">
											<select name="commonStatus" id="commonStatus" class="activeSelectbox">
												<option value="1" <cfif variables.commonStatus eq 1>selected="true"</cfif>>Active</option>
												<option value="0" <cfif variables.commonStatus eq 0>selected="true"</cfif>>InActive</option>
											</select>
										</td>
										<td valign="middle" align="center">
											<select name="commonAppPending" id="commonAppPending" class="activeSelectbox">
												<option value="1" <cfif variables.commonAppPending eq 1>selected="true"</cfif>>Yes</option>
												<option value="0" <cfif variables.commonAppPending eq 0>selected="true"</cfif>>No</option>
											</select>
										<td class="normal-td3">&nbsp;</td>
									</tr>
									<tr bgcolor="##FFFFFF">
										<td colspan="2" class="head-bg lft-bg" valign="middle" align="center">CONTRACT</td>
										<td valign="middle" align="center">
											<select name="contractStatus" id="contractStatus" class="activeSelectbox">
												<option value="1" <cfif variables.contractStatus eq 1>selected="true"</cfif>>Active</option>
												<option value="0" <cfif variables.contractStatus eq 0>selected="true"</cfif>>InActive</option>
											</select>
										</td>
										<td valign="middle" align="center">
											<select name="contractAppPending" id="contractAppPending" class="activeSelectbox">
												<option value="1" <cfif variables.contractAppPending eq 1>selected="true"</cfif>>Yes</option>
												<option value="0" <cfif variables.contractAppPending eq 0>selected="true"</cfif>>No</option>
											</select>
										</td>
										<td class="normal-td3">&nbsp;</td>
									</tr>
									<tr bgcolor="##f7f7f7">
										<td colspan="2" class="head-bg lft-bg" valign="middle" align="center">BROKER</td>
										<td valign="middle" align="center">
											<select name="brokerStatus" id="brokerStatus" class="activeSelectbox">
												<option value="1" <cfif variables.brokerStatus eq 1>selected="true"</cfif>> Active</option>
												<option value="0" <cfif variables.brokerStatus eq 0>selected="true"</cfif>>InActive</option>
											</select>
										</td>
										<td valign="middle" align="center">
											<select name="BrokerAppPending" id="BrokerAppPending" class="activeSelectbox">
												<option value="1" <cfif variables.BrokerAppPending eq 1>selected="true"</cfif>>Yes</option>
												<option value="0" <cfif variables.BrokerAppPending eq 0>selected="true"</cfif>>No</option>
											</select>
										</td>
										<td class="normal-td3">&nbsp;</td>
									</tr>  
								</tbody>
								<tfoot>
									<tr>
										<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
										<td colspan="3" align="left" valign="middle" class="footer-bg"></td>
										<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
									</tr>	
								</tfoot>	  
							</table>
							<div class="clear"></div>  
							<!--- Insurance Boxes 2 --->
							<table width="315" border="0" cellspacing="0" cellpadding="0" class="noh" bgcolor="" style="padding-bottom:25px; margin-left: 32px !important;">
								<thead>
									<tr>
										<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
										<th align="center" valign="middle" class="head-bg">Ins. Type</th>
										<th align="center" valign="middle" class="head-bg">Ins. Required</th>
										<th align="center" valign="middle" class="head-bg">Ins. on File</th>
										<th align="center" valign="middle" class="head-bg2">Exp. Date</th>
										<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
									</tr>
								</thead>
								<tbody>
									<tr bgcolor="##f7f7f7" >
										<td class="head-bg lft-bg" colspan="2" valign="middle" align="center">BIPD</td>
										<td valign="middle" align="center">
											<select name="BIPDInsRequired" id="BIPDInsRequired" class="activeSelectbox" style="margin-left: 12px;">
												<option value="1" <cfif variables.BIPDInsRequired eq 1>selected="true"</cfif>>Yes</option>
												<option value="0" <cfif variables.BIPDInsRequired eq 0>selected="true"</cfif>>No</option>
											</select>
										</td>

										<td valign="middle" align="center">
											<select name="BIPDInsonFile" id="BIPDInsonFile" class="activeSelectbox">
												<option value="1" <cfif variables.BIPDInsonFile eq 1>selected="true"</cfif>>Yes</option>
												<option value="0" <cfif variables.BIPDInsonFile eq 0>selected="true"</cfif>>No</option>
											</select>
										</td>
										<td valign="middle" align="center">
										
											<cfinput name="ExpirationDate" type="datefield" value="#Dateformat(variables.ExpirationDate,'mm/dd/yyyy')#" style="width:64px" onblur="checkDateFormatAll(this);"/>
										</td>
										
										<td class="normal-td3">&nbsp;</td>
									</tr>
								    <tr bgcolor="##FFFFFF">
										<td class="head-bg lft-bg" colspan="2" valign="middle" align="center">CARGO</td>
										<td valign="middle" align="center">
											<select name="cargoInsRequired" id="cargoInsRequired" class="activeSelectbox" style="margin-left: 12px;">
												<option value="1" <cfif variables.cargoInsRequired eq 1>selected="true"</cfif>>Yes</option>
												<option value="0" <cfif variables.cargoInsRequired eq 0>selected="true"</cfif>>No</option>
											</select>
										</td>
										<td valign="middle" align="center">
											<select name="cargoInsonFile" id="cargoInsonFile" class="activeSelectbox">
												<option value="1" <cfif variables.cargoInsonFile eq 1>selected="true"</cfif>>Yes</option>
												<option value="0" <cfif variables.cargoInsonFile eq 0>selected="true"</cfif>>No</option>
											</select>
										</td>
										<td valign="middle" align="center">
											<cfinput name="CARGOExpirationDate" type="datefield" value="#Dateformat(variables.CARGOExpirationDate,'mm/dd/yyyy')#" style="width:64px" onblur="checkDateFormatAll(this);"/>'
										</td>
										<td class="normal-td3">&nbsp;</td>
								    </tr>
									<!--- <tr bgcolor="##f7f7f7">
										<td class="normaltd2 lft-bg" valign="middle" colspan="5" align="left">HOUSEHOLD GOODS: 
											
										</td>
										<td class="normal-td3">&nbsp;</td>
									</tr> --->
								</tbody>
								<tfoot>
									<tr>
										<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
										<td colspan="4" align="left" valign="middle" class="footer-bg"></td>
										<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
									</tr>	
								</tfoot>	  
							</table>                                                
							<div class="search-rt"></div>
							
							<div class="clear"></div>
							<!--- <label style="text-align:left;width:125px;margin-left:6px;">Carrier Instructions</label>
							<div class="clear"></div>
							<textarea  class="carrier-textarea-medium" name="CarrierInstructions" tabindex="34" rows="" cols="" style="height:200px;width:400px">#CarrierInstructions#</textarea>
							<div class="clear"></div> 
							<label>&nbsp;</label> --->
							<!---<cfif isdefined('url.CarrierId') and len(url.carrierId) gt 1>
								<label style="text-align:left"><a class="link" href="index.cfm?event=addcarrier&carrierid=#url.carrierid#&#session.URLToken#&updLIData=yes&mcno=#MCNumber#">Update L&I Info</a></label>
							</cfif>--->
							<div class="clear"></div>
						</fieldset>
					</div>
				<div class="clear"></div>
				<div class="clear"></div>
				<div class="form-con">&nbsp;</div>
				<cfif isDefined("url.carrierid")>
					<fieldset class="carrierFields">
						<div style="padding-left:120px;">
							<cfinput name="Save" type="submit" class="normal-bttn" value="Save"  onfocus="checkUnload();" style="width:44px;"/>
							<cfinput name="Return" type="button" class="normal-bttn" onclick="javascript:history.back();" value="Back" style="width:62px;" />
						</div>
					</fieldset>
					<div class="gap"></div>
				</cfif>
				<div class="carrier-mid">
				<table id="tblrow" width="100%" class="noh" border="0" cellspacing="0" cellpadding="0">
				  <thead>
				  <tr>
					<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
					<th align="center" valign="middle" class="head-bg">Del</th>
					<th align="center" valign="middle" class="head-bg">Office/Name</th>
					<th align="center" valign="middle" class="head-bg">Manager</th>
	
					<th align="center" valign="middle" class="head-bg">Phone</th>
					<th  align="center" valign="middle" class="head-bg">Fax</th>
					<th align="center" valign="middle" class="head-bg2">Email</th>
					<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
				  </tr>
				  </thead>
				  <tbody>
	             <cfif isdefined('url.carrierId') and len(url.carrierID) >
	             	<cfinvoke component="#variables.objCarrierGateway#" method="getCarrierOffice" carrierid="#url.carrierid#" returnvariable="request.qCarrierOffice" />
	                 <cfloop query="request.qCarrierOffice">
	                   <cfinput type="hidden" name="CarrierOfficeID#request.qCarrierOffice.currentRow#" value="#request.qCarrierOffice.CarrierOfficeID#">
	                     <tr <cfif #request.qCarrierOffice.currentRow# mod 2 eq 0> bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
	           				<td height="20" class="lft-bg">&nbsp;</td>
	           				<td class="lft-bg2" valign="middle" align="center"><input name="delchk#request.qCarrierOffice.currentRow#" class="check" type="checkbox" value="" /></td>
	           				<td class="normaltd" valign="middle" align="left"><input name="office_name#request.qCarrierOffice.currentRow#" class="t-textbox" type="text"  value="#request.qCarrierOffice.location#"/></td>
	           				<td class="normaltd" valign="middle" align="left"><input name="office_manager#request.qCarrierOffice.currentRow#" class="td-textbox" type="text" value="#request.qCarrierOffice.Manager#" /></td>
	           				<td class="normaltd" valign="middle" align="left"><input name="office_phone#request.qCarrierOffice.currentRow#" class="td-textbox" type="text" value="#request.qCarrierOffice.PhoneNo#" /></td>
	           				<td class="normaltd" valign="middle" align="left"><input name="office_fax#request.qCarrierOffice.currentRow#" class="td-textbox" type="text" value="#request.qCarrierOffice.Fax#" /></td>
	           				<td class="normaltd2" valign="middle" align="left"><input name="office_Email#request.qCarrierOffice.currentRow#" class="td-textbox" type="text" value="#request.qCarrierOffice.EmailID#"/></td>
	           				<td class="normal-td3">&nbsp;</td>
	           			  </tr>
		                 </cfloop>
		                 <cfif request.qCarrierOffice.recordcount lt 5>		                                      
		                 <cfset toLoop = 5 - #request.qCarrierOffice.recordcount#>
		                 <cfset cnt=#request.qCarrierOffice.recordcount#+1>
		                 <cfloop index="in" from="#cnt#" to="5">
		                     <cfinput type="hidden" name="CarrierOfficeID#in#" value="0">		                                          
				  			  <tr <cfif #in# mod 2 eq 0> bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
				  				<td height="20" class="lft-bg">&nbsp;</td>
				  				<td class="lft-bg2" valign="middle" align="center"><input name="delchk#in#" class="check" type="checkbox" value="" /></td>
				  				<td class="normaltd" valign="middle" align="left"><input name="office_name#in#" class="t-textbox" type="text"  value=""/></td>
				  				<td class="normaltd" valign="middle" align="left"><input name="office_manager#in#" class="td-textbox" type="text" value="" /></td>
				  				<td class="normaltd" valign="middle" align="left"><input name="office_phone#in#" class="td-textbox" type="text" value="" /></td>
				  				<td class="normaltd" valign="middle" align="left"><input name="office_fax#in#" class="td-textbox" type="text" value="" /></td>
				  				<td class="normaltd2" valign="middle" align="left"><input name="office_Email#in#" class="td-textbox" type="text" value=""/></td>
				  				<td class="normal-td3">&nbsp;</td>
				  			  </tr>
		                </cfloop>
              			</cfif> 
            			<cfelse>
		             <cfloop index="in" from="1" to="5">
					  <tr <cfif #in# mod 2 eq 0> bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
						<td height="20" class="lft-bg">&nbsp;</td>
						<td class="lft-bg2" valign="middle" align="center"><input name="delchk#in#" class="check" type="checkbox" value="" /></td>
						<td class="normaltd" valign="middle" align="left"><input name="office_name#in#" class="t-textbox" type="text"  value=""/></td>
						<td class="normaltd" valign="middle" align="left"><input name="office_manager#in#" class="td-textbox" type="text" value="" /></td>
						<td class="normaltd" valign="middle" align="left"><input name="office_phone#in#" class="td-textbox" type="text" value="" /></td>
						<td class="normaltd" valign="middle" align="left"><input name="office_fax#in#" class="td-textbox" type="text" value="" /></td>
						<td class="normaltd2" valign="middle" align="left"><input name="office_Email#in#" class="td-textbox" type="text" value=""/></td>
						<td class="normal-td3">&nbsp;</td>
					  </tr>
		              </cfloop>
                      </cfif>
					  </tbody>
		               <tfoot>
					  <tr>
					<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
					<td colspan="6" align="left" valign="middle" class="footer-bg"></td>
					<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
				  </tr>	
				  </tfoot>	  
				</table>
		<div class="clear"></div>
		<!--- <table cellpadding="0" class="noh" bgcolor="" cellspacing="0" width="100%" border="0" style="padding-bottom:25px;">
		   <tr>
		      <td bgcolor="" height="28"><strong>L&I Website Data</strong></td>
			  <td bgcolor="" colspan="3" width="50" style="padding-left:27px">MC ###MCNumber#  #pv_legal_name#</td>
			  <td bgcolor="">#dateformat(now(),'mm/dd/yyyy')#</td>
		   </tr>
		    <tr>
				<td valign="top">
					<input name="CarrierId" id="CarrierId" type="hidden" value="#variables.carrierId#">
					<!---cfif isdefined('url.CarrierId') and len(url.carrierId) gt 1>
						<div style="text-align: center;">
									<cfinput name="updateL&I" type="button" class="normal-bttn" onclick="document.location.href='index.cfm?event=addcarrier&carrierid=#url.carrierid#&#session.URLToken#&updLIData=yes&mcno=#MCNumber#'" value="Update L&I Info" style="width:62px;line-height:15px;margin-top:4px;" />	
						</div>
					</cfif--->
				</td>
				<td width="25"></td>
				<td valign="top">
					
				</td>
				<td width="17"></td>
				<td valign="top">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<thead>
							<tr>
								<th valign="top" width="5" align="left"><img src="images/top-left.gif" alt="" width="5" height="23"></th>
								<th class="head-bg2" valign="middle" align="center">Insurance Company</th>
								<th valign="top" width="5" align="right"><img src="images/top-right.gif" alt="" width="5" height="23"></th>
							</tr>
						</thead>
						<tbody>
							<tr bgcolor="##ffffff">
								<td class="lft-bg" height="20">&nbsp;</td>
								<td class="normaltd2" valign="middle" align="left"><input name="InsuranceCompanyName" id="InsuranceCompanyName" value="#variables.InsuranceCompanyName#" class="textBoxCarrierInsurance" placeholder="Company Name"><br><textarea name="InsuranceCompanyAddress" id="InsuranceCompanyAddress" class="textBoxCarrierInsurance" placeholder="Company Address">#variables.InsuranceCompanyAddress#</textarea></td>
								<td class="normal-td3">&nbsp;</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td valign="top" width="5" align="left"><img src="images/left-bot.gif" alt="" width="5" height="23"></td>
								<td class="footer-bg" valign="middle" align="left"></td>
								<td valign="top" width="5" align="right"><img src="images/right-bot.gif" alt="" width="5" height="23"></td>
							</tr>	
						</tfoot>	  
					</table>
				</td>
			
		   </tr>
		</table> --->
		</div>
		<div class="carrier-links">
		<cfif len(pv_usdot_no) gt 1>
		   <ul>
		      <li><a href="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_activeinsurance?pv_apcant_id=#pv_apcant_id#&pv_legal_name=#webLegger#&pv_pref_docket=MC#MCNumber#&pv_usdot_no=#pv_usdot_no#&pv_vpath=LIVIEW" target="blank">Active/Pending Insurance</a></li>
			  <li>|</li>
			  <li><a href="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_rejectinsurance?pv_apcant_id=#pv_apcant_id#&pv_legal_name=#webLegger#&pv_pref_docket=MC#MCNumber#&pv_usdot_no=#pv_usdot_no#&pv_vpath=LIVIEW" target="blank">Rejected Insurance</a></li>
			  <li>|</li>
			  <li><a href="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_insurancehistory?pv_apcant_id=#pv_apcant_id#&pv_legal_name=#webLegger#&pv_pref_docket=MC#MCNumber#&pv_usdot_no=#pv_usdot_no#&pv_vpath=LIVIEW" target="blank">Insurance History</a></li>
			  <li>|</li>
			  <li><a href="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_authorityhistory?pv_apcant_id=#pv_apcant_id#&pv_legal_name=#webLegger#&pv_pref_docket=MC#MCNumber#&pv_usdot_no=#pv_usdot_no#&pv_vpath=LIVIEW" target="blank">Authority History</a></li>
			  <li>|</li>
			  <li><a href="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_pendapplication?pv_apcant_id=#pv_apcant_id#&pv_legal_name=#webLegger#&pv_pref_docket=MC#MCNumber#&pv_usdot_no=#pv_usdot_no#&pv_vpath=LIVIEW" target="blank">Pending Application</a></li>
			  <li>|</li>
              <li><a href="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_revocation?pv_apcant_id=#pv_apcant_id#&amp;pv_legal_name=#webLegger#&amp;pv_pref_docket=MC#MCNumber#&amp;pv_usdot_no=#pv_usdot_no#&amp;pv_vpath=LIVIEW" target="blank">Revocation</a></li>
              <li>|</li>
              <li><a href="http://safersys.org/" target="blank">SAFER System</a></li>
		   </ul>
</cfif>
			 <div class="clear"></div>
		</div>
        <div class="clear"></div>
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;text-align:center;">
			<h2 style="color:white;font-weight:bold;">Carrier Commodity Pricing</h2>
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
							<th align="left" valign="middle" class="head-bg" style="text-align:center;">Carr.rate</th>
							<th align="left" valign="middle" class="head-bg" style="text-align:center;">Carr.% of Cust Total</th>
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
											<option value="#request.qUnits.unitID#" <cfif request.qGetCommodityById.COMMODITYID eq request.qUnits.unitID >selected="true"</cfif> >#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
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
					<cftextarea rows="7" style="width: 80%; height: 83px;" name="Notes">#notes#</cftextarea>
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
					<cfinput type="hidden" value="" name="SaveContinue">
					<cfinput type="hidden" value="#session.urltoken#" name="stoken" id="stoken">
				</fieldset>

		<div class="clear"></div>
		</div>
		<div class="clear"></div>
		<div>
			<cfif isDefined("url.carrierid") and len(url.carrierid) gt 1>
	          <p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;">Last Updated:<cfif isDefined("request.qCarrier")>&nbsp;&nbsp;&nbsp; #request.qCarrier.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qCarrier.LastModifiedBy#</cfif></p>
	       </cfif>
       </div>
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
