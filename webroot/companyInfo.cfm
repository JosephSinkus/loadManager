<cfparam name="CarrierHead" default="">
<cfparam name="CustInvHead" default="">
<cfparam name="BOLHead" default="">
<cfparam name="WorkImpHead" default="">
<cfparam name="WorkExpHead" default="">
<cfparam name="SalesHead" default=""> 
<cfsilent>
	<cfif isDefined('form.submitCompanyInformation')>
		<cfif isdefined("form.ccOnEmails")>
			<cfset ccOnEmails = true>
		<cfelse>
			<cfset ccOnEmails = false>
		</cfif>
		<cfinvoke component="#variables.objloadGateway#" method="setCompanyInformationUpdate" companyName="#form.companyName#" emailId="#form.emailId#" ccOnEmails="#ccOnEmails#" address="#form.address#" address2="#form.address2#" city="#form.city#" zipCode="#form.zipCode#"  state="#form.state#" returnvariable="companyInformationUpdated" />
	</cfif>
	<cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qStates" />
	<cfinvoke component="#variables.objloadGateway#" method="getCompanyInformation" returnvariable="request.qGetCompanyInformation" />
	<!---
	<cfset  companyName = request.qGetCompanyInformation.companyName>
	<cfset  Address = request.qGetCompanyInformation.Address>
	<cfset  Address2 = request.qGetCompanyInformation.Address2>
	<cfset  City = request.qGetCompanyInformation.City>
	<cfset  State = request.qGetCompanyInformation.State>
	<cfset  ZipCode = request.qGetCompanyInformation.ZipCode>
	<cfset  companyID = request.qGetCompanyInformation.companyID>
	--->
</cfsilent>
<cfoutput>
	
<div class="white-con-area" style="height: 40px;background-color: ##82bbef;">
	<div style="float: left; width: 100%; min-height: 40px;">
		<h1 style="color:white;font-weight:bold;margin-left:350px;">Company Information</h1>
	</div>
</div>
<div style="clear:left"></div>

<div class="white-con-area">
	<div class="white-top"></div>
	
    <div class="white-mid">
		
		<cfform name="frmCompanyInformation" method="post">
			<div class="form-con">
				<fieldset>
					
					<label>Company Name</label>
					<input type="text" name="companyName" id="companyName" value="#request.qGetCompanyInformation.companyName#">
					<div class="clear"></div>
					
					<label>Email</label>
					<input type="text" name="emailId" id="emailId" value="#request.qGetCompanyInformation.email#">
					<div class="clear"></div>
					
					<input type="checkbox" name="ccOnEmails" id="ccOnEmails"  <cfif request.qGetCompanyInformation.ccOnEmails EQ true>checked="checked"</cfif> style="width: 12px;margin-left: 111px;">CC on all emails</input>
					<div class="clear"></div>
					
					<div class="clear"></div>
					<label>Address</label>
					<input type="text" name="Address" id="Address" value="#request.qGetCompanyInformation.Address#">
					<div class="clear"></div>
					
					
					<div class="clear"></div>
					<label>Address 2</label>
					<input type="text" name="Address2" id="Address2" value="#request.qGetCompanyInformation.Address2#">
					<div class="clear"></div>
					
					<label>City</label>
					<input type="text" name="City" id="City" value="#request.qGetCompanyInformation.City#">
					<div class="clear"></div>
					
					<label>State</label>
					<select name="State" id="State">
						<option value="">Select</option>
						<cfloop query="request.qStates">
							<option value="#request.qStates.statecode#" <cfif request.qStates.statecode is request.qGetCompanyInformation.State> selected="selected" </cfif> >#request.qStates.statecode#</option>
						</cfloop>
					</select>
					
					<div class="clear"></div>
					<label>Zip code</label> 
					<input type="text" name="ZipCode" id="ZipCode"  value="#request.qGetCompanyInformation.ZipCode#"   />
					<div class="clear"></div>
					
					<div class="clear" style="border-top: 1px solid ##E6E6E6;" >&nbsp;</div>	
					<input type="hidden" name="companyID" id="companyID" value="#request.qGetCompanyInformation.companyID#">
					<input  type="submit" name="submitCompanyInformation" onclick="return validateFields();" onfocus="" class="bttn" value="Save" style="width:80px;margin-left:112px;margin-top:5px;" />
					
					<div id="message" class="msg-area" style="width: 181px;margin-left: 70px;margin-top: 36px; display:<cfif isDefined('companyInformationUpdated')>block;<cfelse>none;</cfif>">
						<cfif isDefined('companyInformationUpdated') AND companyInformationUpdated GT 0>
							Information saved successfully
						<cfelseif isDefined('companyInformationUpdated')>
							unknown <b>Error</b> occured while saving
						</cfif>
					</div>
					
				</fieldset>
			</div>
			<div class="clear"></div>
		</cfform>
    </div>
    <div class="white-bot"></div>
</div>

</cfoutput>