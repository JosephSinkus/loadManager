<!---<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">--->

<cfsilent>
<cfif isDefined('FORM.submitSystemConfig')>
	<cfset imagesFolder = ExpandPath('images\logo')>
	<cfif form.companyLogo NEQ ''>
		<cffile action="upload" fileField="companyLogo" destination="#imagesFolder#" nameconflict="makeunique">
		<cfset serverFileName = '#cffile.SERVERFILE#'>
	<cfelse>
		<cfset serverFileName = ''>
	</cfif>
	
    <cfif isdefined("FORM.DispatchNotes")>
		<cfset dispatch_notes = #FORM.DispatchNotes#>
    <cfelse>
    	<cfset dispatch_notes = false>
    </cfif>
    
    <cfif isdefined("FORM.CarrierNotes")>
		<cfset carrier_notes = #FORM.CarrierNotes#>
    <cfelse>
    	<cfset carrier_notes = false>
    </cfif>
    
    <cfif isdefined("FORM.PricingNotes")>
		<cfset pricing_notes = #FORM.PricingNotes#>
    <cfelse>
    	<cfset pricing_notes = false>
    </cfif>
    
    <cfif isdefined("FORM.Notes")>
		<cfset simple_notes = #FORM.Notes#>
    <cfelse>
    	<cfset simple_notes =false>
    </cfif>

    <cfif isdefined("FORM.chkValidMCNumber")>
		<cfset requireValidMCNumber = true>
    <cfelse>
    	<cfset requireValidMCNumber = false>
    </cfif>
    
	<cfinvoke component="#variables.objloadGateway#" method="setSystemSetupOptions" longMiles="#FORM.longMiles#" shortMiles="#FORM.shortMiles#" deductionPercentage="#FORM.deductionPercentage#" ARAndAPExportStatusID="#FORM.loadStatus#" showExpiredInsuranceCarriers="#FORM.showExpCarriers#" companyName="#Form.txtcompName#" companyLogoName="#serverFileName#" dispatch_notes="#dispatch_notes#" carrier_notes="#carrier_notes#" pricing_notes="#pricing_notes#" simple_notes="#simple_notes#" requireValidMCNumber="#requireValidMCNumber#" returnvariable="systemConfigUpdated" />
</cfif>

<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" /> 
<cfinvoke component="#variables.objloadGateway#" method="getCompanyName" returnvariable="request.qCompanyName" /> 
<cfset loadStatus = request.qGetSystemSetupOptions.ARAndAPExportStatusID>
</cfsilent>
<cfoutput>
<h1>System Setup</h1>
<div style="clear:left"></div>

<div class="white-con-area">
	<div class="white-top"></div>
	
    <div class="white-mid">
	<cfform name="frmLongShortMiles" enctype="multipart/form-data" method="post">

	<div class="form-con">
	<fieldset>
		<label>Long Miles</label>
        <cfinput type="text" name="longMiles" id="longMiles" value="#NumberFormat(request.qGetSystemSetupOptions.LongMiles,'0.00')#" tabindex="1"  onClick="document.getElementById('message').style.display='none';" style="width:28px;"> %
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
		
		<div class="clear"></div>
        <label>Require Valid MC##</label>
        <input type="checkbox" name="chkValidMCNumber" id="chkValidMCNumber" <cfif request.qGetSystemSetupOptions.requireValidMCNumber EQ true>checked="checked"</cfif> style="width:12px;" />
        <div class="clear"></div>
		</fieldset>
		</div>
		<div class="form-con">
		<fieldset>	

        <label>Short Miles</label>
        <cfinput type="text" name="shortMiles" id="shortMiles" value="#NumberFormat(request.qGetSystemSetupOptions.ShortMiles,'0.00')#" tabindex="3" onClick="document.getElementById('message').style.display='none';" style="width:28px;"> %
        <div class="clear"></div>
        
        <label>A/R & A/P Export Status</label>
			<select name="loadStatus" id="loadStatus" onchange="document.getElementById('message').style.display='none';">
				<!---<option value="">Select Status</option>--->
				<cfloop query="request.qLoadStatus">
					<option value="#request.qLoadStatus.value#" <cfif loadStatus is request.qLoadStatus.value> selected="selected" </cfif>>#request.qLoadStatus.Text#</option>
				</cfloop>
			</select>
        <div class="clear"></div>
		
		<label>Show Carriers with Expired Insurance</label>
        <input type="checkbox" class="input_width" name="showExpCarriers" id="showExpCarriers" <cfif request.qGetSystemSetupOptions.showExpiredInsuranceCarriers EQ true>checked="checked"</cfif>>
		<div class="clear"></div>
        
		
        <div class="right" style="margin-right:53px;">
			<input  type="submit" name="submitSystemConfig" onclick="return validateFields();" onfocus="" class="bttn" value="Save" style="width:80px;" />
	    </div>
		</fieldset>
        <div class="clear"></div>
         <div id="message" class="msg-area" style="width:153px; margin-left:200px; display:<cfif isDefined('systemConfigUpdated')>block;<cfelse>none;</cfif>">
		 	<cfif isDefined('systemConfigUpdated') AND systemConfigUpdated GT 0>
			 	Information saved successfully
			<cfelseif isDefined('systemConfigUpdated')>
				unknown <b>Error</b> occured while saving
			</cfif>
		</div>
         <div class="clear">&nbsp;</div>
         <div class="clear">&nbsp;</div>
         
         <!-- Automatic Notes Stamp starts here -->
         <div class="AutomaticNotesStamp">
         	<div style="font-size:14px;color:##000000;clear:both;font-weight:bold;padding:5px 0 5px 0;">Automatic Notes Stamp</div>
         	<div class="clear">&nbsp;</div>
            
            <div><input type="checkbox" name="DispatchNotes" value="" /><span style="padding-left:5px;">Dispatch Notes</span></div>
            <div><input type="checkbox" name="CarrierNotes" value="" /><span style="padding-left:5px;">Carrier Notes</span></div>
            <div><input type="checkbox" name="PricingNotes" value="" /><span style="padding-left:5px;">Pricing Notes</span></div>
            <div><input type="checkbox" name="Notes" value="" /><span style="padding-left:5px;">Notes</span></div>
         
         </div>
         <!-- Automatic Notes Stamp ends here -->
         
	</div>
   <div class="clear"></div>
 </cfform>
    </div>
    
	<div class="white-bot"></div>
</div>

</cfoutput>