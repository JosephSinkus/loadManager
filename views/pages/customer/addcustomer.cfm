<cfoutput>
	<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer">
<cfsilent>
<cfimport taglib="../../../plugins/customtags/mytag/" prefix="myoffices" >	
<!---Init default Value------->
<cfparam name="CustomerStatusID" default="">
<cfparam name="CustomerCode" default="">
<cfparam name="CustomerName" default="">
<cfparam name="OfficeID" default="">
<cfparam name="OfficeID1" default="">
<cfparam name="Location" default="">
<cfparam name="City" default="">
<cfparam name="State1" default="">
<cfparam name="Zipcode" default="">
<cfparam name="ContactPerson" default="">
<cfparam name="MobileNo" default="">
<cfparam name="PhoneNO" default="">
<cfparam name="Email" default="">
<cfparam name="website" default="http://">
<cfparam name="country1" default="9bc066a3-2961-4410-b4ed-537cf4ee282a">
<cfparam name="SalesRepID" default="">
<cfparam name="AcctMGRID" default="">
<cfparam name="LoadPotential" default="">
<cfparam name="RatePerMile" default="0">
<cfparam name="CompanyID1" default="">
<cfparam name="BestOpp" default="">
<cfparam name="CustomerDirections" default="">
<cfparam name="CustomerNotes" default="">
<cfparam name="CarrierNotes" default="">
<cfparam name="IsPayer" default="0">
<cfparam name="FinanceID" default="">
<cfparam name="CreditLimit" default="">
<cfparam name="Balance" default="0">
<cfparam name="Available" default="">
<cfparam name="url.editid" default="0">
<cfparam name="url.customerid" default="0">
<cfparam name="salesperson" default="">
<cfparam name="Dispatcher" default="">  
<cfparam name="Fax" default="">
<cfparam name="Tollfree" default="">
<cfparam name="UserName" default="">
<cfparam name="Password" default="">
<cfparam name="RemitName" default="">
<cfparam name="RemitAddress" default="">
<cfparam name="RemitCity" default="">
<cfparam name="RemitState" default="">
<cfparam name="RemitZipCode" default="">
<cfparam name="RemitContact" default="">
<cfparam name="RemitPhone" default="">
<cfparam name="RemitFax" default="">
<!--- Encrypt String --->
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurMailAgentdetails" employeID="#session.empid#" />
	<cfif request.qcurMailAgentdetails.recordcount gt 0 and (request.qcurMailAgentdetails.SmtpAddress eq "" or request.qcurMailAgentdetails.SmtpUsername eq "" or request.qcurMailAgentdetails.SmtpPort eq "" or request.qcurMailAgentdetails.SmtpPassword eq "" or request.qcurMailAgentdetails.SmtpPort eq 0)>
	  <cfset mailsettings = "false">
  <cfelse>
	  <cfset mailsettings = "true">
  </cfif>
<cfinvoke component="#variables.objloadGateway#" method="getLoadSystemSetupOptions" returnvariable="request.qSystemSetupOptions" />
<cfif request.qSystemSetupOptions.freightBroker>
	<cfset variables.freightBroker = "Carrier">
<cfelse>
	<cfset variables.freightBroker = "Driver">
</cfif>

<cfif isdefined("url.customerid") and len(trim(url.customerid)) gt 1>
	<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#url.customerid#" returnvariable="request.qCustomer" />
	<cfset CustomerStatusID=#request.qCustomer.CustomerStatusID#>
	<cfset CustomerCode=#request.qCustomer.CustomerCode#>
	<cfset CustomerName=#request.qCustomer.CustomerName#>
	<cfset OfficeID1=#request.qCustomer.OfficeID#>
	<cfset Location=#request.qCustomer.Location#>
	<cfset City=#request.qCustomer.City#>
	<cfset State1=#request.qCustomer.Statecode#>
	<cfset Zipcode=#request.qCustomer.Zipcode#>
	<cfset ContactPerson=#request.qCustomer.ContactPerson#>
	<cfset MobileNo=#request.qCustomer.PersonMobileNo#>
	<cfset PhoneNo=#request.qCustomer.PhoneNo#>
	<cfset Tollfree=#request.qCustomer.Tollfree#>
	<cfset Fax=#request.qCustomer.Fax#>
	<cfset Email=#request.qCustomer.Email#>
	<cfset Website=#request.qCustomer.Website#>
	<cfset SalesRepID=#request.qCustomer.SalesRepID#>
	<cfset AcctMGRID=#request.qCustomer.AcctMGRID#>
	<cfset LoadPotential=#request.qCustomer.LoadPotential#>
    <cfset RatePerMile=#request.qCustomer.RatePrMile#>
	<cfset CompanyID1=#request.qCustomer.CompanyID#>
	<cfset BestOpp=#request.qCustomer.BestOpp#>
	<cfset CustomerDirections=#request.qCustomer.CustomerDirections#>
	<cfset CustomerNotes=#request.qCustomer.CustomerNotes#>
	<cfset CarrierNotes=#request.qCustomer.CarrierNotes#>
	<cfset IsPayer=#request.qCustomer.IsPayer#>
	<cfset FinanceID=#request.qCustomer.FinanceID#>
	<cfset CreditLimit=#request.qCustomer.CreditLimit#>
	<cfset Balance=#request.qCustomer.Balance#>
	<cfset Available=#request.qCustomer.Available#>
	<cfset country1=#request.qCustomer.countryID#>
	<cfset UserName=#request.qCustomer.UserName#>
	<cfset Password=#request.qCustomer.Password#>
	<cfset editid="#url.customerid#">
	<cfset RemitName=request.qCustomer.RemitName>
	<cfset RemitAddress=request.qCustomer.RemitAddress>
	<cfset RemitCity=request.qCustomer.RemitCity>
	<cfset RemitState=request.qCustomer.RemitState>
	<cfset RemitZipCode=request.qCustomer.RemitZipCode>
	<cfset RemitContact=request.qCustomer.RemitContact>
	<cfset RemitPhone=request.qCustomer.RemitPhone>
	<cfset RemitFax=request.qCustomer.RemitFax>
</cfif>
</cfsilent>

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
		}).result(function(event, data, formatted) {
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
	
		$('##IsPayer').change(function(){
			if($(this).val() == 'True')
				$('##CustomerCreds').css('display','block');
			else
				$('##CustomerCreds').css('display','none');
		});
		
	
});
function popitup(url) {
	newwindow=window.open(url,'Map','height=600,width=800');
	if (window.focus) {newwindow.focus()}
	return false;
}
</script>


<cfform name="frmCustomer" action="index.cfm?event=addcustomer:process&editid=#editid#&#session.URLToken#" method="post">
<cfif isdefined("url.customerid") and len(trim(url.customerid)) gt 1>
<cfinvoke component="#variables.objCutomerGateway#" method="getAttachedFiles" linkedid="#url.customerid#" fileType="2" returnvariable="request.filesAttached" /> 
<div style="height: 26px;position: absolute;top: 130px;left: 967px;">
	<div class="delbutton">
		<a href="index.cfm?event=customer&customerid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');">  Delete</a>
	</div>
</div>
<div class="search-panel">
</div>	
<h1>Edit Customer <span style="padding-left:160px;">#CustomerName#</span></h1>

	<div style="clear:left;" id="divUploadedFiles">
	&nbsp;&nbsp;&nbsp;&nbsp;	<a style="font-size:15px;" href="index.cfm?event=stop&#session.URLToken#&customerId=#editid#" <cfif event is 'stop' or event is 'stop:process'> class="active" </cfif>>Stops</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <a style="font-size:15px;" href="index.cfm?event=addstop&#session.URLToken#&customerId=#editid#" <cfif event is 'addstop'> class="active" </cfif>>Add&nbsp;Stops</a>
	
		<div style="float:right;margin-right: 151px;margin-top: -10px;">
			<div style="float:left;">
				<input id="mailDocLink" <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif> style="width:110px !important;" type="button" class="bttn"value="Email Doc" />
			</div>
			<div style="float:left;">
				<input  type="submit" name="submit" class="bttn" onClick="return validateCustomer(frmCustomer);" onfocus="checkUnload();" value="Save Customer" style="width:112px;" tabindex="27" />
			</div>
			<div style="float:left;">
				<input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" />
			</div>
			<div class="clear"></div>
		</div>
	</div>
    <div class="clear"></div>
	
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;margin-top: 2px;">
		 <div style="float: left; width: 40%;" id="divUploadedFiles">
			<cfif request.filesAttached.recordcount neq 0>
			&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.customerid#&attachTo=2&user=#session.adminusername#&dsn=#dsn#&attachtype=Customer')"><img style="vertical-align:bottom;" src="images/attachment.png">View/Attach Files</a>
			<cfelse>
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.customerid#&attachTo=2&user=#session.adminusername#&dsn=#dsn#&attachtype=Customer')"><img style="vertical-align:bottom;" src="images/attachment.png">Attach Files</a>
			</cfif>
		</div>
		<div style="float: left; width: 60%;"><h2 style="color:white;font-weight:bold;">Customer Information</h2></div>
		</div>
<cfelse>
<cfset tempLoadId = #createUUID()#>
<cfset session.checkUnload ='add'>
<h1>Add New Customer</h1>
	<div style="float:right;margin-right: 151px;margin-top: -10px;">
		<div style="float:left;">
			<input id="mailDocLink" <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif> style="width:110px !important;" type="button" class="bttn"value="Email Doc" />
		</div>
		<div style="float:left;">
			<input  type="submit" name="submit" class="bttn" onClick="return validateCustomer(frmCustomer);" onfocus="checkUnload();" value="Save Customer" style="width:112px;" tabindex="27" />
		</div>
		<div style="float:left;">
			<input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" />
		</div>
		<div class="clear"></div>
	</div>
<div class="white-con-area" style="height: 36px;background-color: ##82bbef;margin-top: 19px;">
	<div style="float: left; width: 40%;" id="divUploadedFiles">
		&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempLoadId#&attachTo=2&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=Customer')"><img style="vertical-align:bottom;" src="images/attachment.png">Attach Files</a>
	</div>
	<div style="float: left; width: 60%;"><h2 style="color:white;font-weight:bold;">Customer Information</h2></div>
</div>
</cfif>

<div class="white-con-area">
<div class="white-top"></div>
<div class="white-mid">
	<cfinput type="hidden" name="editid" value="#editid#">
	 <div class="form-con">
	<fieldset class="carrierFields">
	    <label>Customer Code*</label>
	    <cfinput type="text" name="CustomerCode" value="#CustomerCode#" tabindex="1" size="25" required="yes" message="Please  enter the customer code">
	    <div class="clear"></div>  
	    <label>Name*</label>
        <cfinput type="text" name="CustomerName" value="#CustomerName#" tabindex="2" size="25" required="yes" message="Please  enter the name">
        <div class="clear"></div>
        <label>Address*</label>
		<textarea rows="2" cols="" id="location" name="Location" tabindex="4" style="height: 42px;">#Location#</textarea>
        <div class="clear"></div> 
        <label>City*</label>
        <cfinput type="text" name="City" value="#City#" tabindex="5" required="yes" message="Please enter the city">
        <div class="clear"></div> 
        <label>State*</label>
		<select name="state1" id="state" tabindex="6" style="width:100px;">
         <option value="">Select</option>
		<cfloop query="request.qStates">
        	<option value="#request.qStates.statecode#" <cfif request.qStates.statecode is state1> selected="selected" </cfif> >#request.qStates.statecode#</option>	
		</cfloop>
		</select>
		<label style="width:70px;">Zipcode*</label>     
 		<cfinput type="text" name="Zipcode" value="#Zipcode#" tabindex="7" required="yes" message="Please enter a zipcode" style="width:100px;">
        <div class="clear"></div>
		<label>Country*</label>
        <select name="country1" tabindex="8" onload="getUSCountryCust();">
        <option value="">Select</option>
		<cfloop query="request.qCountries">
        	<option value="#request.qCountries.countryID#" <cfif request.qCountries.countryID is country1> selected="selected" </cfif> >#request.qCountries.country#</option>	
		</cfloop>
		</select>
		<div class="clear"></div>
	    <label>Contact Person</label>
        <cfinput type="text" name="ContactPerson" value="#ContactPerson#" tabindex="8">
		<div class="clear"></div>
        <label>Phone No</label>
        <cfinput type="text" name="PhoneNO" value="#PhoneNO#" tabindex="9" onchange="ParseUSNumber(this);" style="width:122px;">
		<label style="width:35px;">Fax</label>
		<cfinput name="Fax" type="text" tabindex="10" value="#Fax#" style="width:100px;"/>
        <div class="clear"></div>
		<label>Toll Free</label>
		<cfinput name="Tollfree" type="text" tabindex="11" value="#Tollfree#" style="width:122px;"/>
        <label style="width:35px;">Cell</label>
        <cfinput type="text" name="MobileNo" value="#MobileNo#" tabindex="12" style="width:100px;">
        <div class="clear"></div>
        <label>Email Id</label>
        <cfinput type="text" name="Email" class="emailbox" value="#Email#" tabindex="13" validate="email" message="Please ennter valid email address" onchange="Autofillwebsite(frmCustomer);">
        <div class="clear"></div>        
        <label>Website</label>
        <input type="text" class="emailbox" name="website" id="website" tabindex="14" value="#website#">
		<div class="clear"></div>		  		
         <label>Company*</label>
   		 <myoffices:virtualtag company='#CompanyID1#' name="CompanyID1" tabindex="15" />
		<div class="clear"></div>
        <label>Office*</label>
        <myoffices:virtualtag officeloc='#OfficeID1#' name="OfficeID1" tabindex="16" />
        <div class="clear"></div>
        <label>Sales Agent</label>
        <select name="salesperson" tabindex="17">
         <option value="">Select</option>
         <cfloop query="request.qSalesPerson">
         <option value="#request.qSalesPerson.EmployeeID#"<cfif request.qSalesPerson.EmployeeID eq  SalesRepID> selected="selected" </cfif>>#request.qSalesPerson.Name#</option>
         </cfloop>
        </select>
       <div class="clear"></div>
       <label>Dispatcher</label>
       <select name="Dispatcher" tabindex="18">
        <option value="">Select</option>
        <cfloop query="request.qSalesPerson">
         <option value="#request.qSalesPerson.EmployeeID#"<cfif request.qSalesPerson.EmployeeID eq  SalesRepID> selected="selected" </cfif>>#request.qSalesPerson.Name#</option>
         </cfloop>
        <!--- <cfloop query="request.qDispatcher">
        <option value="#request.qDispatcher.EmployeeID#"<cfif request.qDispatcher.EmployeeID eq AcctMGRID>selected="selected" </cfif>>#request.qDispatcher.Name#</option>
        </cfloop> --->
       </select>
		<div class="clear"></div>
		<!--- Checking the rights for the Status and IsPayer--->
		<cfif ListContains(session.rightsList,'changeCustomerActiveStatus',',')>
        	<cfset changeActiveStatusRightAvailable = "">
			<cfset disableChangeActiveStatusSelect = "">
        <cfelse>
        	<cfset changeActiveStatusRightAvailable = "disabled">
			<cfif  session.checkUnload neq "add">
				<cfset disableChangeActiveStatusSelect = "disabled">
			<cfelse>
				<cfset disableChangeActiveStatusSelect = "">
			</cfif>
        </cfif>
        <label>Status*</label>
        <cfselect name="CustomerStatusID" tabindex="19" style="width:100px;">
        <cfif changeActiveStatusRightAvailable eq "" OR (changeActiveStatusRightAvailable eq "disabled" AND CustomerStatusID eq 1)>
          <option value="1" <cfif #CustomerStatusID# eq 1>selected="selected" </cfif>>Active</option>
         </cfif>
         <cfif changeActiveStatusRightAvailable eq "" OR (changeActiveStatusRightAvailable eq "disabled" AND CustomerStatusID eq 2) OR (changeActiveStatusRightAvailable eq "disabled" AND session.checkUnload eq "add")>
          <option value="2" <cfif #CustomerStatusID# eq 2>selected="selected" </cfif>>Inactive</option>
         </cfif>
        </cfselect>
		<label style="width:76px;">Payer*</label>
		 <select name="IsPayer" id="IsPayer" tabindex="20" style="width:100px;">
			<cfif changeActiveStatusRightAvailable eq "" OR (changeActiveStatusRightAvailable eq "disabled" AND IsPayer is 'True')>
	  		 	<option value="True" <cfif IsPayer is 'True'>selected ="selected"</cfif>>True</option>
	  		</cfif> 	
	  		<cfif changeActiveStatusRightAvailable eq "" OR (changeActiveStatusRightAvailable eq "disabled" AND IsPayer is 'False') OR (changeActiveStatusRightAvailable eq "disabled" AND session.checkUnload eq "add")>
	  		 	 <option value="False" <cfif IsPayer is 'False'>selected ="selected"</cfif>>False</option>
	  		</cfif>	 
  		 </select>
       <div class="clear"></div>	   
		<label style="text-align:left;width:120px;">Customer Notes</label>
   		<textarea rows="" cols="" tabindex="21" name="CustomerNotes" style="width:400px">#CustomerNotes#</textarea>
			<div class="clear"></div>
		<div style="border-bottom:1px solid ##e6e6e6; padding-top:7px;"></div>
	
		<div id="CustomerCreds" style="padding-top: 16px;"<cfif !val(IsPayer)>style="display:none;"</cfif> >
				<cfinput style="display:none" type="text" name="CustomerUsername"/>
				<cfinput style="display:none" type="password" name="CustomerPassword"/>
				<label>Login Name</label>
				<cfinput type="text" name="CustomerUsername" value="#Username#" tabindex="22" autocomplete="off">
				<label>Password</label>
				<cfinput type="password" name="CustomerPassword" value="#password#" tabindex="23" autocomplete="off" >
				<div class="clear"></div>
				<label>Customer Login</label>
				<cfif CGI.HTTPS EQ "on">
					<cfset variables.https = "https://">
				<cfelse>
					<cfset variables.https = "http://">
				</cfif>
				<cfset variables.customerLoginUrl = variables.https & cgi.SERVER_NAME & cgi.SCRIPT_NAME & '?event=customerlogin'>
				<a href="#variables.customerLoginUrl#" target="_blank">Link</a>
		</div>
	   <div class="clear"></div>	   
       <fieldset>
       </div>
       <div class="form-con">
       	<fieldset class="carrierFields"> 
		<div class="clear"></div>
		<label>Remit Name</label>
		<cfinput name="RemitName" type="text" tabindex="24" value="#RemitName#"/>
		<div class="clear"></div>
		<label>Remit Address</label>
		<textarea rows="2" tabindex="25" cols="" name="RemitAddress" style="height:25px;">#trim(RemitAddress)#</textarea>
		<div class="clear"></div>                                
		<label>Remit City</label>
		<cfinput name="RemitCity" id="RemitCity" tabindex="26" type="text" value="#RemitCity#" style="width:90px;"/>
		<label style="width:77px;">Remit State</label>  
		<cfselect name="RemitState" id="RemitState" tabindex="27" style="width:96px;">
			<option value="">Select</option>
			<cfloop query="request.qstates">
				<option value="#request.qstates.statecode#" <cfif  request.qstates.statecode eq RemitState> selected="selected" </cfif>>#request.qstates.statecode#</option>
		   </cfloop>
	   </cfselect>
		<div class="clear"></div>  
		<label>Remit Zipcode</label>
		<cfinput name="RemitZipcode" type="text" value="#RemitZipCode#" tabindex="28" style="width:90px;"/>
		<label style="width:77px;">Remit Contact</label>
		<cfinput name="RemitContact" tabindex="29" type="text" value="#RemitContact#" onchange="ParseUSNumber(this);" style="width:90px;"/>
		<div class="clear"></div>
		<label>Remit Phone</label>
		<cfinput name="RemitPhone" tabindex="30" type="text" value="#RemitPhone#" style="width:90px" onchange="ParseUSNumber(this);"/>
		<label style="width:77px;">Remit Fax</label>
		<cfinput name="RemitFax" type="text" tabindex="31" value="#RemitFax#" style="width:90px;"/>
		<div class="clear"></div>

		<div style="border-bottom:1px solid ##e6e6e6; padding-top:7px;"></div>
		<div style="padding-top:13px;">
        <label>Load Potential</label>
        <cfinput type="text" name="LoadPotential" value="#LoadPotential#" tabindex="32" >
        </div>
 		<label>Rate Per Mile*</label>
        <cfinput type="text" name="RatePerMile" value="#RatePerMile#" tabindex="33" required="yes" message="Please enter Rate Per Mile">
         <div class="clear"></div>   		
   		 <label>BestOpp</label>
   		 <cfinput type="text" name="BestOpp" value="#BestOpp#" tabindex="34" >
   		<div class="clear"></div> 	
		<div style="border-bottom:1px solid ##e6e6e6; padding-top:7px;"></div>
   		 <cfinput type="hidden" name="FinanceID" value="#FinanceID#" tabindex="35">
		<div style="width:100%; padding-top:13px;">
			<table style="border-collapse: collapse;border-spacing: 0;">
				<tbody>
					<tbody>
					<tr>
					  <td><label style="text-align: left !important;width: 65px !important;">Credit Limit</label></td>
					  <td>
						  <cfinput type="text" class="mid-textbox-1" style="text-align:right;" name="CreditLimit" id="CreditLimit" tabindex="36" value="#DollarFormat(CreditLimit)#" readonly="true" message="Please enter the credit limit">
						</td>
					  <td><label style="text-align: left !important;width: 40px !important;">Balance</label></td>
					  <td>
						  <cfinput type="text" class="mid-textbox-1" style="text-align:right;" name="Available" id="Available" tabindex="37" value="#DollarFormat(Available)#"  readonly="true" message="Please enter the available Amount" onchange="getbalance()">
						</td>
					  <td><label style="text-align: left !important;width: 50px !important;">Available</label></td>
					  <td>
						  <cfinput type="text" class="mid-textbox-1" style="text-align:right;" name="Balance"  id="Balance" value="#DollarFormat(Balance)#" readonly="true" tabindex="38" >
						</td>
					</tr>
				</tbody>
				</tbody>
			</table>
		</div>
		<!---<div class="clear"></div>
		<label>Credit Limit</label>
		<cfinput type="text" name="CreditLimit" id="CreditLimit" tabindex="22" value="#DollarFormat(CreditLimit)#" readonly="true" message="Please enter the credit limit">
		<div class="clear"></div>
		<label>Available</label>
        <cfinput type="text" name="Available" id="Available" tabindex="23" value="#DollarFormat(Available)#"  readonly="true" message="Please enter the available Amount" onchange="getbalance()">
		<div class="clear"></div>
        <label>Balance</label>
        <cfinput type="text" name="Balance"  id="Balance" value="#DollarFormat(Balance)#" readonly="true" tabindex="24" >--->
		 <div class="clear"></div>
		 <div style="padding-top:34px;">
		 <label style="text-align:left;width:120px;">Customer Directions</label>
		 <textarea rows="" cols="" tabindex="39" name="CustomerDirections" style="width:400px"  tabindex="39">#CustomerDirections#</textarea>
		 </div>
		 <div class="clear"></div>
		 <label style="text-align:left;width:120px;">#variables.freightBroker# Notes</label>
   		 <textarea rows="" cols="" tabindex="40" name="CarrierNotes" style="width:400px"  tabindex="40">#CarrierNotes#</textarea>
		 <div class="clear"></div>
		 <div style="padding-left:100px;padding-top:19px;"><input  type="submit" name="submit" class="bttn" onClick="return validateCustomer(frmCustomer);" onfocus="checkUnload();" value="Save Customer" style="width:112px;" tabindex="41" /><input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" tabindex="42" /></div>
		<div class="clear"></div>
		</fieldset>
	</div>
   <div class="clear"></div>
 </cfform>
<cfif isDefined("url.customerid") and len(url.customerid) gt 1>
<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qCustomer")>&nbsp;&nbsp;&nbsp; #request.qCustomer.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qCustomer.LastModifiedBy#</cfif></p>
</cfif>
</div>
<div class="white-bot"></div>
</div>
<br /><br /><br />
<script type="text/javascript">
		$(document).ready(function(){
			 $('##mailDocLink').click(function(){
				if($(this).attr('data-allowmail') == 'false')
				alert('You must setup your email address in your profile before you can email documents.');
				else
				mailDocOnClick('#session.URLToken#','customer'<cfif isDefined("url.customerid") and len(url.customerid) gt 1>,'#url.customerid#'</cfif>);
			 });
		});
</script>		    
</cfoutput>


