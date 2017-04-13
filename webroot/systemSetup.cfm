<!---<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">--->
<cfparam name="CarrierHead" default="">
<cfparam name="CustInvHead" default="">
<cfparam name="BOLHead" default="">
<cfparam name="WorkImpHead" default="">
<cfparam name="WorkExpHead" default="">
<cfparam name="SalesHead" default=""> 
<cfsilent>
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptionsLoadNumber" />
<cfif isDefined('FORM.submitSystemConfig')>
	<cfset imagesFolder = ExpandPath('images\logo')>
	<cfif form.companyLogo NEQ ''>
		<cffile action="upload" fileField="companyLogo" destination="#imagesFolder#" nameconflict="makeunique">
		<cfset serverFileName = '#cffile.SERVERFILE#'>
	<cfelse>
		<cfset serverFileName = ''>
	</cfif>
	
    <cfif isdefined("FORM.DispatchNotes")>
		<cfset dispatch_notes = true>
    <cfelse>
    	<cfset dispatch_notes = false>
    </cfif>
    
    <cfif isdefined("FORM.CarrierNotes")>
		<cfset carrier_notes = true>
    <cfelse>
    	<cfset carrier_notes = false>
    </cfif>
    
    <cfif isdefined("FORM.PricingNotes")>
		<cfset pricing_notes = true>
    <cfelse>
    	<cfset pricing_notes = false>
    </cfif>
    
    <cfif isdefined("FORM.Notes")>
		<cfset simple_notes = true>
    <cfelse>
    	<cfset simple_notes = false>
    </cfif>
	
	<cfif isdefined("FORM.commodityWeight")>
		<cfset commodityWeight = true>
    <cfelse>
    	<cfset commodityWeight = false>
    </cfif>
	
	<cfif isdefined("FORM.chkValidMCNumber")>
		<cfset requireValidMCNumber = true>
    <cfelse>
    	<cfset requireValidMCNumber = false>
    </cfif>
	<cfif isdefined("FORM.integratewithPEP")>
		<cfset integratewithPEP = true>
	<cfelse>
		<cfset integratewithPEP = false>
	</cfif>
	<cfif isdefined("FORM.integratewithTran360")>
		<cfset integratewithTran360 = true>
	<cfelse>
		<cfset integratewithTran360 = false>
	</cfif>
	<cfif isdefined("FORM.integratewithITS")>
		<cfset integratewithITS = true>
	<cfelse>
		<cfset integratewithITS = false>
	</cfif>
	<cfif isdefined("FORM.AllowLoadentry")>
		<cfset AllowLoadentry = true>
	<cfelse>
		<cfset AllowLoadentry = false>
	</cfif>
	<cfif isdefined("FORM.numberAttachments")>
		<cfset numberAttachments = true>
	<cfelse>
		<cfset numberAttachments = false>
	</cfif>
	<cfif isdefined("FORM.ITSUserName")>
		<cfset ITSUserName = FORM.ITSUserName>
	<cfelse>
		<cfset ITSUserName = "">
	</cfif>

	<cfif isdefined("FORM.lockloadstatus")>
		<cfset lockloadstatus = FORM.lockloadstatus>
	<cfelse>
		<cfset lockloadstatus = "none">
	</cfif>
	
	<cfif isdefined("FORM.ITSPassword")>
		<cfset ITSPassword = FORM.ITSPassword>
	<cfelse>
		<cfset ITSPassword = "">
	</cfif>


	<cfif isdefined("FORM.rowsperpage")>
		<cfset rowsperpage = FORM.rowsperpage>
	<cfelse>
		<cfset rowsperpage = "">
	</cfif>



	<cfif structKeyExists(form, "showcarrieramount") AND len(form.showcarrieramount)>
		<cfset showcarrieramount = 1>
	<cfelse>	
		<cfset showcarrieramount = 0>
	</cfif>

	<cfif structKeyExists(form, "editDispatchNotes") AND len(form.editDispatchNotes)>
		<cfset editDispatchNotes = 1>
	<cfelse>	
		<cfset editDispatchNotes = 0>
	</cfif>

	<cfif structKeyExists(form, "showcustomeramount") AND len(form.showcustomeramount)>
		<cfset showcustomeramount = 1>
	<cfelse>	
		<cfset showcustomeramount = 0>
	</cfif>



	
	<cfif isdefined("FORM.userDef1")>
		<cfset userDef1 = FORM.userDef1>
	<cfelse>
		<cfset userDef1 = "">
	</cfif>
	<cfif isdefined("FORM.userDef2")>
		<cfset userDef2 = FORM.userDef2>
	<cfelse>
		<cfset userDef2 = "">
	</cfif>
	<cfif isdefined("FORM.userDef3")>
		<cfset userDef3 = FORM.userDef3>
	<cfelse>
		<cfset userDef3 = "">
	</cfif>
	<cfif isdefined("FORM.userDef4")>
		<cfset userDef4 = FORM.userDef4>
	<cfelse>
		<cfset userDef4 = "">
	</cfif>
	<cfif isdefined("FORM.userDef5")>
		<cfset userDef5 = FORM.userDef5>
	<cfelse>
		<cfset userDef5 = "">
	</cfif>
	<cfif isdefined("FORM.userDef6")>
		<cfset userDef6 = FORM.userDef6>
	<cfelse>
		<cfset userDef6 = "">
	</cfif>
	<cfif isdefined("FORM.userDef7")>
		<cfif len(trim(FORM.userDef7))>
			<cfset userDef7 = FORM.userDef7>
		<cfelse>
			<cfset userDef7 = 'userDef7'>
		</cfif>	
	</cfif>
	<cfif isdefined("FORM.minimunLoadNumber")>
		<cfset minimunLoadNumber = FORM.minimunLoadNumber>
	<cfelse>
		<cfset minimunLoadNumber = "">
	</cfif>
	<cfset showReadyArriveDat = false>
	<cfif structKeyExists(FORM,"showReadyArriveDat")>
		<cfset showReadyArriveDat = true>
	</cfif>
	
	<cfif isdefined("FORM.statusDispatchNote")>
		<cfset statusDispatchNote = true>
    <cfelse>
    	<cfset statusDispatchNote = false>
    </cfif>

    <cfif isdefined("FORM.rolloverShipDate")>
		<cfset rolloverShipDateStatus = true>
    <cfelse>
    	<cfset rolloverShipDateStatus = false>
    </cfif>
	
	<cfif isdefined("FORM.showExpCarriers")>
		<cfset showExpCarriers = true>
    <cfelse>
    	<cfset showExpCarriers = false>
    </cfif>
	
	<cfif isdefined("FORM.showCarrierInvoiceNumber")>
		<cfset showCarrierInvoiceNumber = true>
    <cfelse>
    	<cfset showCarrierInvoiceNumber = false>
    </cfif>
	
	<cfif isdefined("FORM.EmailReports")>
		<cfset emailReports = true>
    <cfelse>
    	<cfset emailReports = false>
    </cfif>
	<cfif isdefined("FORM.PrintReports")>
		<cfset printReports = true>
    <cfelse>
    	<cfset printReports = false>
    </cfif>
	<cfif request.qGetSystemSetupOptionsLoadNumber.MinimumLoadInvoiceNumber eq 0>
		<cfset loadNumberAssignment=request.qGetSystemSetupOptionsLoadNumber.loadNumberAssignment>
	<cfelse>
		<cfif structKeyExists(FORM,"LoadNumberAssignment")>
			<cfset loadNumberAssignment=form.LoadNumberAssignment>
		<cfelse>
			<cfset loadNumberAssignment=0>
		</cfif>
	</cfif>
	<cfif isdefined("FORM.userDef7")>
		<cfinvoke component="#variables.objloadGateway#" method="setSystemSetupOptions" longMiles="#FORM.longMiles#" shortMiles="#FORM.shortMiles#" deductionPercentage="#FORM.deductionPercentage#" ARAndAPExportStatusID="#FORM.loadStatus#" showExpiredInsuranceCarriers="#showExpCarriers#" showCarrierInvoiceNumber="#showCarrierInvoiceNumber#" companyName="#Form.txtcompName#" companyLogoName="#serverFileName#" dispatch_notes="#dispatch_notes#" carrier_notes="#carrier_notes#" pricing_notes="#pricing_notes#" simple_notes="#simple_notes#"  requireValidMCNumber="#requireValidMCNumber#" integratewithPEP="#integratewithPEP#"  PEPsecretKey="#form.PEPsecretKey#"  PEPcustomerKey="#form.PEPcustomerKey#"   CarrierTerms="#form.CarrierTerms#"  Triger_loadStatus="#form.Triger_loadStatus#" AllowLoadentry="#AllowLoadentry#" showReadyArriveDat="#showReadyArriveDat#" integratewithITS="#integratewithITS#" ITSUserName="#ITSUserName#" ITSPassword="#ITSPassword#" userDef1="#userDef1#" userDef2="#userDef2#" userDef3="#userDef3#" userDef4="#userDef4#" userDef5="#userDef5#"  userDef6="#userDef6#" userDef7="#userDef7#" googleMapsPcMiler="#googleMapsPcMiler#" minimumMargin="#minimumMargin#" CarrierHead="#form.CarrierHead#" CustInvHead="#form.CustInvHead#" BOLHead="#form.BOLHead#" WorkImpHead="#form.WorkImpHead#" WorkExpHead="#form.WorkExpHead#" SalesHead="#form.SalesHead#" minimunLoadNumber="#form.minimunLoadNumber#" statusDispatchNote="#statusDispatchNote#" emailreports="#emailReports#" printReports="#printReports#" CustomerTerms="#CustomerTerms#" loadNumberAssignment="#loadNumberAssignment#" commodityWeight="#commodityWeight#" numberAttachments="#numberAttachments#" rolloverShipDateStatus="#rolloverShipDateStatus#" showcarrieramount="#showcarrieramount#" showcustomeramount="#showcustomeramount#" rowsperpage="#rowsperpage#" lockloadstatus="#lockloadstatus#" editDispatchNotes="#editDispatchNotes#" returnvariable="systemConfigUpdated"  />
	<cfelse>
		<cfinvoke component="#variables.objloadGateway#" method="setSystemSetupOptions" longMiles="#FORM.longMiles#" shortMiles="#FORM.shortMiles#" deductionPercentage="#FORM.deductionPercentage#" ARAndAPExportStatusID="#FORM.loadStatus#" showExpiredInsuranceCarriers="#showExpCarriers#" showCarrierInvoiceNumber="#showCarrierInvoiceNumber#"  companyName="#Form.txtcompName#" companyLogoName="#serverFileName#" dispatch_notes="#dispatch_notes#" carrier_notes="#carrier_notes#" pricing_notes="#pricing_notes#" simple_notes="#simple_notes#"  requireValidMCNumber="#requireValidMCNumber#" integratewithPEP="#integratewithPEP#"  PEPsecretKey="#form.PEPsecretKey#"  PEPcustomerKey="#form.PEPcustomerKey#"   CarrierTerms="#form.CarrierTerms#"  Triger_loadStatus="#form.Triger_loadStatus#" AllowLoadentry="#AllowLoadentry#" showReadyArriveDat="#showReadyArriveDat#" integratewithITS="#integratewithITS#" ITSUserName="#ITSUserName#" ITSPassword="#ITSPassword#" userDef1="#userDef1#" userDef2="#userDef2#" userDef3="#userDef3#" userDef4="#userDef4#" userDef5="#userDef5#"  userDef6="#userDef6#"  googleMapsPcMiler="#googleMapsPcMiler#" minimumMargin="#minimumMargin#" CarrierHead="#form.CarrierHead#" CustInvHead="#form.CustInvHead#" BOLHead="#form.BOLHead#" WorkImpHead="#form.WorkImpHead#" WorkExpHead="#form.WorkExpHead#" SalesHead="#form.SalesHead#" minimunLoadNumber="#form.minimunLoadNumber#" statusDispatchNote="#statusDispatchNote#" emailreports="#emailReports#" printReports="#printReports#" CustomerTerms="#CustomerTerms#" loadNumberAssignment="#loadNumberAssignment#" commodityWeight="#commodityWeight#" numberAttachments="#numberAttachments#" rolloverShipDateStatus="#rolloverShipDateStatus#" showcarrieramount="#showcarrieramount#" showcustomeramount="#showcustomeramount#" rowsperpage="#rowsperpage#" lockloadstatus="#lockloadstatus#" editDispatchNotes="#editDispatchNotes#" returnvariable="systemConfigUpdated"  />
	 </cfif>
</cfif>
<cfinvoke component="#variables.objloadGateway#" method="getLoadSystemSetupOptions" returnvariable="request.qSystemSetupOptions1" />
<cfif request.qSystemSetupOptions1.freightBroker>
	<cfset variables.freightBrokerVal = "Carrier">
	<cfset variables.expiredType = "Insurance">
<cfelse>
	<cfset variables.freightBrokerVal = "Driver">
	<cfset variables.expiredType = "Physical">
</cfif> 
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />

<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" /> 
<cfinvoke component="#variables.objloadGateway#" method="getCompanyName" returnvariable="request.qCompanyName" /> 
<cfset loadStatus = request.qGetSystemSetupOptions.ARAndAPExportStatusID>
<cfset  CarrierHead = request.qGetSystemSetupOptions.CarrierHead>
<cfset  CustInvHead = request.qGetSystemSetupOptions.CustInvHead>
<cfset  BOLHead = request.qGetSystemSetupOptions.BOLHead>
<cfset  WorkImpHead = request.qGetSystemSetupOptions.WorkImpHead>
<cfset  WorkExpHead = request.qGetSystemSetupOptions.WorkExpHead>
<cfset  SalesHead = request.qGetSystemSetupOptions.SalesHead> 
</cfsilent>
<cfoutput>
<script type="text/javascript">

	function popitup(url) {
		newwindow=window.open(url,'Map','height=600,width=600');
		if (window.focus) {newwindow.focus()}
		return false;
	}
			
</script>
<!--- Encrypt String --->
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>
<div class="white-con-area" style="height: 40px;background-color: ##82bbef;">
		<div style="float: left; min-height: 40px; width: 43%;" id="divUploadedFiles">
			&nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=systemsetup&attachTo=10&user=#session.adminusername#&dsn=#dsn#&attachtype=systemSetup&freightBroker=#variables.freightBrokerVal#')">
			<img style="vertical-align:bottom;" src="images/attachment.png">
			File Cabinet</a>
		</div>
		<div style="float: left; width: 57%; min-height: 40px;"><h1 style="color:white;font-weight:bold;">System Setup</h1></div>
	</div>
<div style="clear:left"></div>

<div class="white-con-area">
	<div class="white-top"></div>
	<div class="white-mid">
	<cfform name="frmLongShortMiles" enctype="multipart/form-data" method="post">
	<div style="margin-left:692px;">
		<input  type="submit" name="submitSystemConfig" onclick="return validateFields();" onfocus="" class="bttn" value="Save" style="width:80px;" />
	</div>
	<div id="message" class="msg-area" style="width:153px;margin-left:660px;margin-top:10px; display:<cfif isDefined('systemConfigUpdated')>block;<cfelse>none;</cfif>">
		<cfif isDefined('systemConfigUpdated') AND systemConfigUpdated GT 0>
			Information saved successfully
		<cfelseif isDefined('systemConfigUpdated')>
			unknown <b>Error</b> occured while saving
		</cfif>
	</div>
	
	<div class="form-con">
	<fieldset>
		<div>
			<div style="float:left;width:50%;">
				<label>Long Miles</label>
				<cfinput type="text" name="longMiles" id="longMiles" value="#NumberFormat(request.qGetSystemSetupOptions.LongMiles,'0.00')#" tabindex="1"  onClick="document.getElementById('message').style.display='none';" style="width:28px;"> %
				<div class="clear"></div>
			</div>
			<div style="float:left;width:50%;">
				<label>Short Miles</label>
				<cfinput type="text" name="shortMiles" id="shortMiles" value="#NumberFormat(request.qGetSystemSetupOptions.ShortMiles,'0.00')#" tabindex="3" onClick="document.getElementById('message').style.display='none';" style="width:28px;"> %
				<div class="clear"></div>
			</div>
		</div>
		<div class="clear"></div>
		<label>Deduction %</label>
        <cfinput type="text" name="deductionPercentage" id="deductionPercentage" value="#NumberFormat(request.qGetSystemSetupOptions.DeductionPercentage,'0.00')#" tabindex="2" onClick="document.getElementById('message').style.display='none';" style="width:28px;"> 
        <div class="clear"></div>
        
		<label>Company Logo</label>
        <input type="file" name="companyLogo" />
        <div class="clear"></div>
        <label>Company Name</label>
        <select name="compName" id="companyName" onchange="companyNamechanged();">
			<option value="">-- Select --</option>
        	<cfloop query="request.qCompanyName">
        	<option value="" <cfif request.qCompanyName.CompanyName EQ request.qGetSystemSetupOptions.companyName>selected="selected"</cfif>>#request.qCompanyName.CompanyName#</option>
            </cfloop>
        </select>
        <div class="clear"></div>
        <label>Selected Name</label>
        <input type="text" name="txtcompName" id="txtcompName" value="#request.qGetSystemSetupOptions.companyName#">
        <div class="clear"></div>
		<div>
			<div style="float:left;width:50%;">
				<label>Require Valid MC##</label>
		<input type="checkbox" name="chkValidMCNumber" id="chkValidMCNumber" <cfif request.qGetSystemSetupOptions.requireValidMCNumber EQ true>checked="checked"</cfif>  style="width:12px;" />
				<div class="clear"></div>
			</div>
			<div style="float:left;width:50%;">
				<label>Commodity Weight</label>
				<input type="checkbox" name="commodityWeight" id="commodityWeight" <cfif request.qGetSystemSetupOptions.commodityWeight EQ true>checked="checked"</cfif>  style="width:12px;" />
				<div class="clear"></div>
			</div>
		</div>
		<div class="clear"  style="border-top: 1px solid ##E6E6E6;" ></div>
		<label>Integrate with post everywhere loadboard</label>
		<input type="checkbox" name="integratewithPEP" id="integratewithPEP" <cfif request.qGetSystemSetupOptions.integratewithPEP EQ true>checked="checked"</cfif> style="width:12px;" />
		<div class="clear"></div>
		<label>Post to ITS</label>
		<input type="checkbox" name="integratewithITS" id="integratewithITS" <cfif request.qGetSystemSetupOptions.integratewithITS EQ true>checked="checked"</cfif> style="width:12px;" />
		<div class="clear"></div>
		<label>ITS User Name</label>
		<input type="text" name="ITSUserName" id="ITSUserName" value="#request.qGetSystemSetupOptions.ITSUserName#" />
		<div class="clear"></div>
		<label>ITS Password</label>
		<input type="text" name="ITSPassword" id="ITSPassword" value="#request.qGetSystemSetupOptions.ITSPassword#" />
		<div class="clear"></div>
		<label>PE Service Key</label> 
		<input type="text" name="PEPsecretKey" id="PEPsecretKey"  value="#request.qGetSystemSetupOptions.PEPsecretKey#"   />
		<div class="clear"></div>
		<label>PE Customer Key</label> 
		<input type="text" name="PEPcustomerKey" id="PEPcustomerKey"  value="#request.qGetSystemSetupOptions.PEPcustomerKey#" />
		<div class="clear"></div>
	<!---	<span style="display::none">
 		   <div class="clear"  style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>	
		<label>Integrate with Transcore 360</label>
		<input type="checkbox" name="integratewithTran360" id="integratewithTran360"  <cfif request.qGetSystemSetupOptions.integratewithTran360 EQ true>checked="checked"</cfif>   style="width:12px;" />
		<div class="clear"></div>
		<label>User Name</label> 
		<input type="text" name="trans360Usename" id="trans360Usename"  value="#request.qGetSystemSetupOptions.trans360Usename#"   />
		<div class="clear"></div>
		<label>Password</label> 
		<input type="text" name="trans360Password" id="trans360Password"  value="#request.qGetSystemSetupOptions.trans360Password#" />
		</span>--->
		<div class="clear"></div> 
		<label>Status Trigger for Loadboards </label> 
		<select name="Triger_loadStatus" id="Triger_loadStatus" >
			 <option value="">Select Status</option> 
			<cfloop query="request.qLoadStatus">
				<option value="#request.qLoadStatus.value#" <cfif request.qGetSystemSetupOptions.Triger_loadStatus eq request.qLoadStatus.value> selected="selected" </cfif>>#request.qLoadStatus.Text#</option>
			</cfloop>
		</select>
		<div class="clear"  style="border-top: 1px solid ##E6E6E6;" ></div>
		<label>Allow Load ## Entry?  </label> 
        <input type="checkbox" name="AllowLoadentry" id="AllowLoadentry" <cfif request.qGetSystemSetupOptions.AllowLoadentry EQ true>checked="checked"</cfif>  style="width:12px;" >
		<label style="width: 151px;">Number Attachments?</label> 
		<input type="checkbox" name="numberAttachments" id="numberAttachments" <cfif request.qGetSystemSetupOptions.numberAttachments EQ true>checked="checked"</cfif>  style="width:12px;" >
		
		<div class="clear"></div> 
			
		<label>Show Ready & Arrive Dates on Load Entry</label>
		<input type="checkbox" name="showReadyArriveDat" id="showReadyArriveDat" <cfif request.qGetSystemSetupOptions.showReadyArriveDate EQ true>checked="checked"</cfif>  style="width:12px;" >
		<div class="clear"></div> 
		<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>	
		
		<label style="width:150px;">Maps and Miles calculation</label> 
		<input type="radio" name="googleMapsPcMiler" id="googleMapsPcMiler" value="0" style="width:12px;" <cfif request.qGetSystemSetupOptions.googleMapsPcMiler EQ false>checked</cfif> ><span>Google Maps</span><br/>
		<input type="radio" name="googleMapsPcMiler" id="googleMapsPcMiler" value="1" style="width:12px;position:relative;right:21px;"<cfif request.qGetSystemSetupOptions.googleMapsPcMiler EQ true>checked</cfif> ><span style="position:relative;right:21px;">Pro Miles</span>
		<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>	
		
		<label style="margin-top:12px;">Starting Load##</label> 
		<input type="text" name="minimunLoadNumber" id="minimunLoadNumber" value="#request.qGetSystemSetupOptions.MinimumLoadStartNumber#" style="margin-top:10px;"/>
		<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>

		<label style="margin-top:12px;">Rows Per Page##</label> 
		<input type="text" name="rowsperpage" id="rowsperpage" value="#request.qGetSystemSetupOptions.rowsperpage#" style="margin-top:10px;"/>
		<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>	

		<cfif not request.qGetSystemSetupOptions.freightBroker>
			<label style="margin-top:12px;">Searchable UserDef7</label> 
			<input type="text" name="userDef7" id="userDef7" value="#request.qGetSystemSetupOptions.userDef7#" style="margin-top:16px;"/>
			<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>
		</cfif>	
		<label style="margin-top:12px;">Customer Terms</label> 
		<cftextarea name="CustomerTerms" style="height:200px;width:400px" >#request.qGetSystemSetupOptions.CustomerTerms#</cftextarea>
		<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>	
		<cfif request.qGetSystemSetupOptions.MinimumLoadInvoiceNumber neq 0>
			<label style="margin-top:12px;"> Invoice Number Assignment</label> 
			<select name="LoadNumberAssignment" id="LoadNumberAssignment" style="margin-top:16px;">
				 <option value="0">Select Status</option> 
				 <cfset variables.loadValue=1>
				<cfloop query="request.qLoadStatus">
					<option value="#variables.loadValue#" <cfif request.qGetSystemSetupOptions.loadNumberAssignment eq variables.loadValue> selected="selected" </cfif>>#request.qLoadStatus.Text#</option>
					<cfset variables.loadValue++>
				</cfloop>
			</select>
		</cfif>	

		<div class="automatic_notes_heading">Load Board Columns</div>
		<label style="width:132px;">Show Customer Amount</label>
		<input type="checkbox" name="showCustomerAmount" id="showCustomerAmount" style="width:12px;" <cfif request.qGetSystemSetupOptions.showcustomeramount>checked="checked"</cfif> >

		<div class="clearBoth"></div>
		<label style="width:132px;">Show Carrier Amount</label>
		<input type="checkbox" name="showcarrieramount" id="showcarrieramount" style="width:12px;" <cfif request.qGetSystemSetupOptions.showcarrieramount>checked="checked"</cfif> >
		
		<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>	
		<div class="clear"></div>		
		
		</fieldset>
		</div>
		<div class="form-con">
		<fieldset>	

        <label>Minimum Margin</label>
        <cfinput type="text" name="minimumMargin" id="minimumMargin" value="#NumberFormat(request.qGetSystemSetupOptions.minimumMargin,'0.00')#" tabindex="3" onClick="document.getElementById('message').style.display='none';" style="width:28px;"> %
        <div class="clear"></div>
		
        <label>A/R & A/P Export Status</label>
			<select name="loadStatus" id="loadStatus" onchange="document.getElementById('message').style.display='none';">
				<!---<option value="">Select Status</option>--->
				<cfloop query="request.qLoadStatus">
					<option value="#request.qLoadStatus.value#" <cfif loadStatus is request.qLoadStatus.value> selected="selected" </cfif>>#request.qLoadStatus.Text#</option>
				</cfloop>
			</select>
        <div class="clear"></div>
		
		<label>Show #variables.freightBrokerVal#s with Expired #variables.expiredType#</label>
        <input type="checkbox" class="input_width"  name="showExpCarriers" id="showExpCarriers" <cfif request.qGetSystemSetupOptions.showExpiredInsuranceCarriers EQ true>checked="checked"</cfif>>
		<label>Enter Carrier Invoice##</label>
        <input type="checkbox" class="input_width"  name="showCarrierInvoiceNumber" id="showCarrierInvoiceNumber" <cfif request.qGetSystemSetupOptions.showCarrierInvoiceNumber EQ true>checked="checked"</cfif>>
		<div class="clear">&nbsp;</div>
		
		<label style="margin-top: 6px;">Status for Dispatch Notes</label>
        <input type="checkbox"  class="input_width" name="statusDispatchNote" id="statusDispatchNote" <cfif request.qGetSystemSetupOptions.StatusDispatchNotes EQ true>checked="checked"</cfif> style="margin-top:12px;">
		<div class="clear">&nbsp;</div>
		
		<label style="margin-top: 6px;">Display Update Loads Button</label>
        <input type="checkbox"  class="input_width" name="rolloverShipDate" id="rolloverShipDate" <cfif request.qGetSystemSetupOptions.rolloverShipDateStatus EQ true>checked="checked"</cfif> style="margin-top:12px;">
		<div class="clear">&nbsp;</div>

		<label style="margin-top: 6px;">Edit Dispatch Notes</label>
        <input type="checkbox"  class="input_width" name="editDispatchNotes" id="editDispatchNotes" <cfif request.qGetSystemSetupOptions.editDispatchNotes EQ 1>checked="checked"</cfif>style="margin-top:12px;">
		<div class="clear">&nbsp;</div>
		
		<div class="AutomaticNotesStamp" style="width:88%">
			<div class="automatic_notes_heading">Automatic Dispatch Report Notes</div>
			<div class="clear">&nbsp;</div>
			<div style="width:165px;float:left;">	
				<div class="float_left">
					<input class="input_width" type="checkbox" name="EmailReports" value="" <cfif request.qGetSystemSetupOptions.AutomaticEmailReports EQ true>checked="checked"</cfif>/>
					<span class="notes_msg">Email Reports</span>
				</div>
				<div class="clear"></div>
				<div class="float_left">
					<input class="input_width" type="checkbox" name="PrintReports" value="" <cfif request.qGetSystemSetupOptions.AutomaticPrintReports EQ true>checked="checked"</cfif>/>
					<span class="notes_msg">Print Reports</span>
				</div>
			</div>
		</div>
		<div class="clear">&nbsp;</div>		
		<!-- Automatic Notes Stamp starts here -->
        
		<div class="AutomaticNotesStamp" style="width:88%">
			
			<div class="automatic_notes_heading">Automatic Notes Stamp</div>
			<div class="clear">&nbsp;</div>
			<div style="width:165px;float:left;">	
				<div class="float_left">
					<input class="input_width" type="checkbox" name="DispatchNotes" value="" <cfif request.qGetSystemSetupOptions.DispatchNotes EQ true>checked="checked"</cfif>/>
					<span class="notes_msg">Dispatch Notes</span>
				</div>
				<div class="clear"></div>
				<div class="float_left">
					<input class="input_width" type="checkbox" name="CarrierNotes" value=""  <cfif request.qGetSystemSetupOptions.CarrierNotes EQ true>checked="checked"</cfif>/>
					<span class="notes_msg">#variables.freightBrokerVal# Notes</span>
				</div>
				<div class="clear"></div>
				<div class="float_left">
					<input class="input_width" type="checkbox" name="PricingNotes" value="" <cfif request.qGetSystemSetupOptions.PricingNotes EQ true>checked="checked"</cfif>/>
					<span class="notes_msg">Pricing Notes</span>
				</div>
				<div class="clear"></div>
				<div class="float_left">
					<input class="input_width" type="checkbox" name="Notes" value="" <cfif request.qGetSystemSetupOptions.Notes EQ true>checked="checked"</cfif>/>
					<span class="notes_msg">Notes</span>
				</div>
			</div>
			<div style="width:212px;float:left;">
				<div><span style="padding-left:5px;float:left">UserDef1</span><input type="text" name="userDef1" value="#request.qGetSystemSetupOptions.userDef1#" style="position:relative;left:10px;width:146px;"/></div>
				<div><span style="padding-left:5px;float:left">UserDef2</span><input type="text" name="userDef2" value="#request.qGetSystemSetupOptions.userDef2#" style="position:relative;left:10px;width:146px;" /></div>
				<div><span style="padding-left:5px;float:left">UserDef3</span><input type="text" name="userDef3" value="#request.qGetSystemSetupOptions.userDef3#" style="position:relative;left:10px;width:146px;" /></div>
				<div><span style="padding-left:5px;float:left">UserDef4</span><input type="text" name="userDef4" value="#request.qGetSystemSetupOptions.userDef4#" style="position:relative;left:10px;width:146px;" /></div>
				<div><span style="padding-left:5px;float:left">UserDef5</span><input type="text" name="userDef5" value="#request.qGetSystemSetupOptions.userDef5#" style="position:relative;left:10px;width:146px;" /></div>
				<div><span style="padding-left:5px;float:left">UserDef6</span><input type="text" name="userDef6" value="#request.qGetSystemSetupOptions.userDef6#" style="position:relative;left:10px;width:146px;"/></div>
			</div>

			<div class="clear"></div>
			<label>Lock Load Status</label>
			<select name="lockloadStatus" id="lockloadStatus" onchange="document.getElementById('message').style.display='none';">
				<option value="none" selected>None</option>
				<cfloop query="request.qLoadStatus">
					<option value="#request.qLoadStatus.value#" <cfif request.qSystemSetupOptions1.lockloadstatus EQ request.qLoadStatus.value> selected </cfif> >#request.qLoadStatus.Text#</option>
				</cfloop>
			</select>
        	<div class="clear"></div>
			
		</div>
		<div class="clear"></div>
		<div>
         	<div class="clear"></div>
			<label style="margin-top: 37px;">#variables.freightBrokerVal# terms</label> 
			<cftextarea name="CarrierTerms" style="height:200px;width:400px" >#request.qGetSystemSetupOptions.CarrierTerms#</cftextarea>
			<div class="clear"></div>
         </div>
		<div class="AutomaticNotesStamp" style="width:100%">
			<div class="automatic_notes_heading">Subject Content Reports</div>
			<div class="clear"> </div>
			<label style="width: 155px;text-align:left;">
				<cfif request.qSystemSetupOptions1.freightBroker>
					#variables.freightBrokerVal#
				<cfelse>
					Dispatch
				</cfif>
				Report
			</label> 
			<input type="text" name="CarrierHead" style="width:400px" value="#CarrierHead#">
			<div class="clear"></div>
			<label style="width: 155px;text-align:left;">Customer Invoice Report</label> 
			<input type="text" name="CustInvHead" style="width:400px" value="#CustInvHead#">
			<div class="clear"></div>
			<label style="width: 155px;text-align:left;">BOL Report</label> 
			<input type="text" name="BOLHead" style="width:400px" value="#BOLHead#">
			<div class="clear"></div>
			<label style="width: 155px;text-align:left;">Work Order Import</label> 
			<input type="text" name="WorkImpHead" style="width:400px" value="#WorkImpHead#">
			<div class="clear"></div>
			<label style="width: 155px;text-align:left;">Work Order Export</label> 
			<input type="text" name="WorkExpHead" style="width:400px" value="#WorkExpHead#">
			<div class="clear"></div>
			<label style="width: 155px;text-align:left;">Sales/Commission Report</label> 
			<input type="text" name="SalesHead" style="width:400px" value="#SalesHead#">
			<div class="clear"></div>
		</div>
         <!-- Automatic Notes Stamp ends here -->
		</fieldset>
		<div class="clear">&nbsp;</div>
		<div class="clear">&nbsp;</div>
        <div class="clear"></div>     
	</div>
   <div class="clear"></div>
 </cfform>
    </div>
    
	<div class="white-bot"></div>
</div>

</cfoutput>