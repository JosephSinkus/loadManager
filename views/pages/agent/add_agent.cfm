<!---<cfmail from='"alwin.sebastian@techversantinfotech.com" <alwin.sebastian@techversantinfotech.com>' subject="Confirm Your Registration" to="alwin.sebastian@techversantinfotech.com" type="text/plain" server="smtp.gmail.com" username="alwin.sebastian@techversantinfotech.com" password="xxxxx" port="465" usessl="true" usetls="true" >
	Just wondering how things are going.
Looks good, right? However, there are some issues. There are HTML tags in the body of the message, but there is no text portion of the message.
</cfmail>--->
<cfheader name="expires" value="#now()#">
<cfheader name="pragma" value="no-cache">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfoutput>
	<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer">
<cfsilent>	
<!---Init the default value------->       
<cfparam name="integratewithTran360" default="">
<cfparam name="trans360Usename" default="">
<cfparam name="trans360Password" default="">
<cfparam name="loadBoard123Usename" default="">
<cfparam name="loadBoard123Password" default="">
<cfparam name="loadBoard123" default="">
<cfparam name="ProMiles" default="">
<cfparam name="integrationID" default="">
<cfparam name="PCMilerUsername" default="">
<cfparam name="PCMilerPassword" default="">
<cfparam name="companyCode" default="">
<cfparam name="FA_empcode" default="">
<cfparam name="FA_name" default="">
<cfparam name="FA_roleid" default="">
<cfparam name="FA_accesskey" default="">
<cfparam name="FA_createdatetime" default="">
<cfparam name="FA_createby" default="">
<cfparam name="FA_lastmodifidatetime" default="">
<cfparam name="FA_lastmodifiedby" default="">
<cfparam name="FA_ipaddress" default="">
<cfparam name="FA_email" default="">
<cfparam name="FA_smtpAddress" default="">
<cfparam name="FA_smtpUsername" default="">
<cfparam name="FA_smtpPassword" default="">
<cfparam name="FA_smtpPort" default="">
<cfparam name="FA_TLS" default="">
<cfparam name="FA_SSL" default="">
<cfparam name="FA_logindate" default="">
<cfparam name="FA_totallogins" default="">
<cfparam name="FA_office" default="">
<cfparam name="FA_password" default="">
<cfparam name="FA_dispatcherid" default="">
<cfparam name="FA_brokercode" default="">
<cfparam name="url.agent_id" default="0">
<cfparam name="editId" default="0">
<cfparam name="fa_isactive" default="False">
<cfparam name="address" default="">
<cfparam name="city" default="">
<cfparam name="state" default="">
<cfparam name="country" default="">
<cfparam name="state1" default="">
<cfparam name="country1" default="9bc066a3-2961-4410-b4ed-537cf4ee282a">
<cfparam name="Zipcode" default="">
<cfparam name="tel" default="">
<cfparam name="telextension" default="">
<cfparam name="cel" default="">
<cfparam name="fax" default="">
<!---cfparam name="Share" default="0"--->
<cfparam name="emailSignature" default="">
<cfparam name="loginid" default="">
<cfparam name="FA_commonrate" default="0">
<cfparam name="editid" default="0">
<cfset flag=1>

<!--- Encrypt String --->
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>
	
<cfinvoke component="#variables.objLoadGateway#" method="getLoadStatusTypes" returnvariable="request.qLoadStatusTypes" />
<cfif structkeyexists(url,"agentid")>
	<cfinvoke component="#variables.objAgentGateway#" method="getAgentsLoadStatusTypes" agentId="#url.agentid#" returnvariable="qAgentsLoadStatusTypes" />	
	<cfset agentsLoadStatusTypesArray = valueList(qAgentsLoadStatusTypes.loadStatusTypeID)>
<cfelse>	
	<cfset qAgentsLoadStatusTypes="">
	<cfset agentsLoadStatusTypesArray = "">
</cfif>
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurMailAgentdetails" employeID="#session.empid#" />
	<cfif request.qcurMailAgentdetails.recordcount gt 0 and (request.qcurMailAgentdetails.SmtpAddress eq "" or request.qcurMailAgentdetails.SmtpUsername eq "" or request.qcurMailAgentdetails.SmtpPort eq "" or request.qcurMailAgentdetails.SmtpPassword eq "" or request.qcurMailAgentdetails.SmtpPort eq 0)>
	  <cfset mailsettings = "false">
  <cfelse>
	  <cfset mailsettings = "true">
  </cfif>

<cfif isdefined("url.agentId") and len(trim(url.agentId)) gt 1>
<cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" agentId="#url.agentID#" returnvariable="request.qAgent" />

<!--- <cfdump var="#request.qLoadStatusTypes#">
<cfabort> --->
<cfset FA_name=#request.qAgent.name#>
<cfset FA_email=#request.qAgent.emailID#>
<cfset FA_office=#request.qAgent.officeID#>
<cfset FA_password=#request.qAgent.password#>
<cfset FA_commonrate=#request.qAgent.SalesCommission#>
<cfset FA_roleid = #request.qAgent.roleID#>
<cfset FA_empcode = #request.qAgent.employeeCode#>
<cfset FA_accesskey = #request.qAgent.accessKey#>
<cfset FA_dispatcherid = #request.qAgent.DispatcherID#>
<cfset FA_brokercode = #request.qAgent.BrokerCode#>
<cfset fa_isactive = #request.qAgent.isActive#>
<cfset address = #request.qAgent.address#>
<cfset city = #request.qAgent.city#>
<cfset state1 = #request.qAgent.state#>
<cfset Zipcode = #request.qAgent.zip#>
<cfset country1 = #request.qAgent.country#>
<cfset Tel = #request.qAgent.telephone#>
<cfset telextension=#request.qAgent.PhoneExtension#>
<cfset cel = #request.qAgent.cel#>
<cfset fax = #request.qAgent.fax#>
<!---cfset share = #request.qAgent.share#--->
<cfset loginid = #request.qAgent.loginid#>
<cfset emailSignature = #request.qAgent.emailSignature#>
<cfset statustypeid=#request.qLoadStatusTypes.statustypeid#>
<cfset statustypetext=#request.qLoadStatusTypes.statustext# >
<cfset editid="#url.agentId#">
<cfset integratewithTran360 =#request.qAgent.integratewithTran360#>
<cfset trans360Usename =#request.qAgent.trans360Usename#>
<cfset trans360Password =#request.qAgent.trans360Password#>
<cfset integrationID =#request.qAgent.integrationID#>
<cfset PCMilerUsername =#request.qAgent.PCMilerUsername#>
<cfset PCMilerPassword =#request.qAgent.PCMilerPassword#>
<cfset FA_smtpAddress=#request.qAgent.SmtpAddress#>
<cfset FA_smtpUsername=#request.qAgent.SmtpUsername#>
<cfset FA_smtpPassword=#request.qAgent.SmtpPassword#>
<cfset FA_smtpPort=#request.qAgent.SmtpPort#>
<cfset loadBoard123Usename=#request.qAgent.loadBoard123Usename#>
<cfset loadBoard123Password=#request.qAgent.loadBoard123Password#>
<cfset loadBoard123=#request.qAgent.loadBoard123#>
<cfset ProMiles=#request.qAgent.proMilesStatus#>
<cfset companyCode=#request.qAgent.companyCode#>
<cfif request.qAgent.useTLS eq "true">
	<cfset FA_TLS="TLS">
<cfelseif request.qAgent.useSSL eq "true">
	<cfset FA_SSL="SSL">
</cfif>
<cfset flag=0>
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
		$("##City").autocomplete('searchCityAutoFill.cfm', {
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
		strId = this.id;
		$('##state').val(data.state);
		$('##Zipcode').val(data.zip);

		});
	
		//zip AutoComplete
		$("##Zipcode").autocomplete('searchCityAutoFill.cfm', {
		
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
		});
	
		
		
	
});
function popitup(url) {
	newwindow=window.open(url,'Map','height=600,width=900');
	if (window.focus) {newwindow.focus()}
	return false;
}
			
</script>




<cfif ListContains(session.rightsList,'addEditDeleteAgents',',')>
	<cfset deleteLinkURL = "index.cfm?event=agent&agentId=#editid#&#session.URLToken#">
    <cfset deleteLinkOnClick = "return confirm('Are you sure to delete this record?');">
<cfelse>
    <cfset deleteLinkURL = "javascript: alert('Sorry!! you don\'t have rights to delete an Agent.')">
    <cfset deleteLinkOnClick = "">
</cfif>

<cfif isdefined("url.agentId") and len(trim(url.agentId)) gt 1>
<cfinvoke component="#variables.objAgentGateway#" method="getAttachedFiles" linkedid="#url.agentId#" fileType="4" returnvariable="request.filesAttached" /> 
<div class="search-panel"><div class="delbutton"><a href="#deleteLinkURL#" onclick="#deleteLinkOnClick#">  Delete</a></div></div>
<h1>Edit User <span style="padding-left:180px;">#ucase(FA_name)#</span></h1>
<div style="clear:left"></div>
	<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		<div style="float: left; width: 40%;" id="divUploadedFiles">
			<cfif request.filesAttached.recordcount neq 0>
			&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.agentId#&attachTo=4&user=#session.adminusername#&dsn=#dsn#&attachtype=Agent')"><img style="vertical-align:bottom;" src="images/attachment.png">View/Attach Files</a>
			<cfelse>
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 2px;color:white;" href="##" onclick="popitup('../fileupload//multipleFileupload/MultipleUpload.cfm?id=#url.agentId#&attachTo=4&user=#session.adminusername#&dsn=#dsn#&attachtype=Agent')"><img style="vertical-align:bottom;" src="images/attachment.png">Attach Files</a>
			</cfif>	
		</div>
		<div style="float: left; width: 60%;"><h2 style="color:white;font-weight:bold;">User Information</h2></div>
	</div>
<cfelse>
<cfset tempLoadId = #createUUID()#>
<cfset session.checkUnload ='add'>
<h1>Add New User</h1>
		<a href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempLoadId#&attachTo=4&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=Agent')">Attach Files
		<img src="images/Paperclip.png"></a>
</cfif>
<div class="white-con-area">
<div class="white-top"></div>
<div class="white-mid">
<cfform name="frmAgent" action="index.cfm?event=addagent:process&#session.URLToken#" method="post">
	<cfinput type="hidden" id="editId" name="editId" value="#editId#">
	<div class="form-con" style="border-right:1px solid ##B4C2CF;width: 402px;">
	<fieldset>
		<label>User Name*</label>
        <cfinput type="text" name="FA_name" tabindex="1" value="#FA_name#" size="25" required="yes" message="Please  enter the name">
        <div class="clear"></div>
		<label>Address*</label>
        <cftextarea type="text" tabindex="2" name="address">#address#</cftextarea>
        <div class="clear"></div>
		<label>City*</label>
		<cfif zipcode eq ''>
	        <cfinput type="text" name="city" id="City" value="#city#" size="25" tabindex="3" required="yes" message="Please enter a city">
	    <cfelse>
	    	<cfinput type="text" name="city" id="City" value="#city#" size="25" tabindex="4" required="yes" message="Please enter a city">
	    </cfif>
        <div class="clear"></div>
		<label>State*</label>
        <select name="state" id="state" <cfif zipcode eq ''> tabindex="4"<cfelse> tabindex="5"</cfif>>
        <option value="">Select</option>
		<cfloop query="request.qStates">
             	<option value="#request.qStates.stateCode#" <cfif request.qStates.stateCode is state1> selected="selected" </cfif> >#request.qStates.stateCode#</option>	
		</cfloop>
		</select>
        <div class="clear"></div>
		<label>Zip*</label>
        <!---  <cfinclude template="../customer/getcitystate.cfm"> --->
		<cfif zipcode neq ''>
	         <cfinput type="text" name="Zipcode" id="Zipcode" tabindex="3" value="#zipcode#" size="25" required="yes" message="Please enter a valid zipcode">
	    <cfelse>
	    	 <cfinput type="text" name="Zipcode" id="Zipcode" tabindex="5" value="#zipcode#" size="25" required="yes" message="Please enter a valid zipcode">    
	    </cfif>     
        <div class="clear"></div>
		<label>Country*</label>
       <select name="country" tabindex="6">
        <option value="">Select</option>
		<cfloop query="request.qCountries">
            <option value="#request.qCountries.countryID#" <cfif request.qCountries.countryID is country1> selected="selected" </cfif> >#request.qCountries.country#</option>	
		</cfloop>
		</select>
                <div class="clear"></div>
               		<label>Tel</label>
                        <input type="text" name="tel" tabindex="7" value="#tel#" onchange="ParseUSNumber(this);">
               	    <!---<label class="ex">Extension</label>
               		<input type="text" name="telextension" tabindex="19" style="width:37px;" value="#telextension#">--->
               	    <div class="clear"></div>

		<label>Cel</label>
        <cfinput type="text" name="cel" tabindex="8" value="#cel#">
        <div class="clear"></div>
		<label>Fax</label>
        <cfinput type="text" name="fax" tabindex="9" value="#fax#">
        <div class="clear"></div>
	
		<div class="clear"  style="border-top: 1px solid ##B4C2CF;padding-top:5px;padding-bottom: 19px;margin-top: 12px;">&nbsp;</div>
		<label>Email*</label>
		<cfinput class="emailbox" type="text" name="FA_email" tabindex="10" value="#FA_email#" required="yes" validate="email"  message="Please enter a valid email">
		<div class="clear"></div>
		<label>SMTP server address</label>
		<cfinput type="text" name="FA_smtpAddress" tabindex="11" value="#FA_smtpAddress#"  autocomplete="off">	
		<div class="clear"></div>
		<label>SMTP user name</label>
		<cfinput type="text" name="FA_smtpUsername" tabindex="12" value="#FA_smtpUsername#"  autocomplete="off">	
		<div class="clear"></div>
		<label>SMTP password</label>
		<cfinput type="password" name="FA_smtpPassword" tabindex="13" value="#FA_smtpPassword#"  autocomplete="off">
		<div class="clear"></div>
		<label>SMTP port</label>
		<cfinput type="text" name="FA_smtpPort" tabindex="14" value="#FA_smtpPort#"  autocomplete="off">
		<div class="clear"></div>
		<label>Use TLS</label>
		<input type="radio" value="TLS" tabindex="15" name="FA_SEC" id="FA_TLS"  <cfif FA_TLS EQ "TLS">checked="checked"</cfif>   style="width:12px;" />
		<label>Use SSL</label>
		<input type="radio" value="SSL" tabindex="16" name="FA_SEC" id="FA_SSL"  <cfif FA_SSL EQ "SSL">checked="checked"</cfif>   style="width:12px;" />
		<div class="clear"></div>
		<!---<input id="verifySMTP" type="button" name="verify" class="bttn" value="Verify SMTP settings" style="width:112px;" />--->
		<label style="width:130px;">Verify SMTP settings</label>
		<input type="checkbox" name="verifySMTP" id="verifySMTP" style="width:12px;" tabindex="17"/>
		<div class="clear"></div>
		<label>E-mail Signature</label>
		<div class="clear"></div>
		<!---<textarea rows="" name="carrierInstruction" tabindex="12" cols="" class="big">#carrierInstruction#</textarea>--->
        <cftextarea type="text" tabindex="18" name="emailSignature" style="width: 337px;height: 125px;margin-left: 15px;margin-bottom: 23px;">#emailSignature#</cftextarea>
		<div class="clear"  style="border-top: 1px solid ##B4C2CF;padding-top:5px;padding-bottom: 19px;margin-top: 12px;">&nbsp;</div>
		<label>ProMiles</label>
		<input type="checkbox" tabindex="19" name="ProMiles" id="ProMiles" <cfif ProMiles EQ true>checked="checked"</cfif>   style="width:12px;" />
		<div class="clear"></div>
		<label>Pro Miles Username</label> 
		<input type="text" name="PCMilerUsername" tabindex="20" id="PCMilerUsername" value="#PCMilerUsername#" style="margin-top: 6px;"/>
		<div class="clear"></div>
		<label>Pro Miles Password</label> 
		<input type="text" name="PCMilerPassword"  tabindex="21" id="PCMilerPassword" value="#PCMilerPassword#" style="margin-top: 6px;"/>
		<div class="clear"></div>
		<label> Pro Miles CompanyCode</label> 
		<input type="text" name="companyCode" id="companyCode"  tabindex="22" value="#companyCode#" style="margin-top: 6px;"/>
		<div class="clear"  style="border-top: 1px solid ##E6E6E6;height:3px;" >&nbsp;</div>
		<div class="clear"></div>
		</fieldset>
		</div>
		<div class="form-con">
		<fieldset>	
		<div class="right">

       <div style="padding-left:150px;"> 
       
       <cfif ListContains(session.rightsList,'addEditDeleteAgents',',')>
       		<cfset saveAgentOnClick = "return validateAgent(frmAgent,'#application.dsn#',#flag#);">
       <cfelse>
        	<cfset saveAgentOnClick = "return false;">
       </cfif>
        <input id="mailDocLink" type="button" class="bttn"value="Email Doc" data-allowmail="#mailsettings#"/><div class="clear"></div>
        <input  type="submit" name="submit" onfocus="checkUnload();" class="bttn" value="Save User" style="width:112px;" onclick="#saveAgentOnClick#" <cfif saveAgentOnClick eq ''>disabled="disabled"</cfif> />
        <input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" />
       </div>

	    </div>		
        <label>Login*</label>
		<cfinput type="text" name="loginid" id="loginid" tabindex="23" value="#loginid#" required="yes" message="Please enter a loginid">
        <div class="clear"></div>
        <label>Password*</label>
        <cfinput type="password" name="FA_password" tabindex="24" value="#FA_password#" >
        <div class="clear"></div>
		<label>Role*</label>
		<select name="FA_roleid" tabindex="25">            
        <option value="">Select</option>
		<cfloop query="request.qRoles">            
        	<option value="#request.qRoles.roleid#" <cfif request.qRoles.roleid is FA_roleid> selected="selected"</cfif>><cfif lcase(request.qRoles.roleValue) eq "lmadmin">Admin<cfelse>#request.qRoles.roleValue#</cfif> </option>	
		</cfloop>
		</select>
        <div class="clear"></div>
		<label>Active*</label>
		<cfselect  name="FA_isactive" tabindex="26">
		<option value="True" <cfif fa_isactive is 'True'>selected ="selected"</cfif>>True</option>
		<option value="False" <cfif fa_isactive is 'False'>selected ="selected"</cfif>>False</option>
		</cfselect>
		<div class="clear"></div>
        <label>Offices *</label>
		<select name="FA_office" tabindex="27">
		    <option value="">Select..</option>            
			<cfloop query="request.qOffices">
			<option value="#request.qOffices.officeid#" <cfif FA_office is request.qOffices.officeid>selected ="selected"</cfif>>#request.qOffices.location#</option>
		    </cfloop>
		</select>
		<div class="clear"></div>
		<!---label>Share</label>
		<cfinput type="text" name="share" tabindex="28" value="#share#" required="yes" validate="float" message="Please enter an numeric value">
		<div class="clear"></div--->
		<label>Sales Commission</label>
		<cfinput type="text" name="FA_commonrate" tabindex="28" value="#numberformat(FA_commonrate,'0.00')#" validate="float" message="Please enter numeric value">%
        <div class="clear"></div>
		<div class="clear"  style="border-top: 1px solid ##B4C2CF;padding-top:5px;padding-bottom: 19px;margin-top: 12px;">&nbsp;</div>
        <table>
			<tr><td style="text-align:left"><label>Asigned Load Type</label></td><td style="padding-left:45px;"><strong>Status</strong></td><td style="padding-left:65px;"><strong>Dispatch</strong></td></tr>
		</table>
		<div style="padding-left:30px; float:left; padding-top:20px;">"Use CTL + Mouse"</div>
		<div style="padding-left:313px;">Left &nbsp;&nbsp; Right</div>
		
		<div style="float:left; padding-left:10px; ">
			<select name="AsignedLoadType" id="AsignedLoadType" tabindex="29" multiple="multiple" size="5" style="height:145px; padding:5px 0px; width:150px"  onChange="isSelect();">
 
			  <cfloop query="request.qLoadStatusTypes">
				<option value="#request.qLoadStatusTypes.statustypeid#" <cfif ListContains(agentsLoadStatusTypesArray,'#request.qLoadStatusTypes.statustypeid#')>selected ="selected"</cfif>>#request.qLoadStatusTypes.statustext#</option>
			  </cfloop>

			</select>
		</div>
		<div style="float:left; padding-left:28px; padding-top:7px; width:50px; ">
		
			 
			<cfloop query="request.qLoadStatusTypes">
				<cfset statusTypeIDforElements = Replace(request.qLoadStatusTypes.statustypeid,'-','_','ALL')>
				<cfif structKeyExists(url,"agentid")>
					<cfquery name="qAgentDispatchBoardDirection" dbtype="query">
						SELECT dispatchBoardDirection
						FROM qAgentsLoadStatusTypes
						WHERE loadStatusTypeID = <cfqueryparam value="#request.qLoadStatusTypes.statustypeid#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>	
				<p class="radio-p">
				<input title="#request.qLoadStatusTypes.statustext#" type="radio" name="radio_#statusTypeIDforElements#" id="L_radio_#request.qLoadStatusTypes.statustypeid#" value="L" <cfif structKeyExists(url,"agentid") and qAgentDispatchBoardDirection.dispatchBoardDirection EQ 'L'>checked="checked"</cfif> <cfif NOT ListContains(agentsLoadStatusTypesArray,'#request.qLoadStatusTypes.statustypeid#')>disabled="disabled"</cfif> value="" style="width:15px; height:8px;" /> 
				<input title="#request.qLoadStatusTypes.statustext#" type="radio" name="radio_#statusTypeIDforElements#" id="R_radio_#request.qLoadStatusTypes.statustypeid#" value="R" <cfif structKeyExists(url,"agentid") and qAgentDispatchBoardDirection.dispatchBoardDirection EQ 'R'>checked="checked"</cfif> <cfif NOT ListContains(agentsLoadStatusTypesArray,'#request.qLoadStatusTypes.statustypeid#')>disabled="disabled"</cfif> value="" style="width:15px; margin-left:12px; height:8px;" /> 
				</p>
			
			</cfloop>

		</div>
		<div style="clear:both;"></div>
		
		
		
		<!---<div class="clear"></div>
		<label>Carrier Instructions</label>
		<div class="clear"></div>
		<textarea rows="" name="carrierInstruction" tabindex="19" cols="" class="big">#carrierInstruction#</textarea>
--->		<div class="clear"></div>
	
		<div class="clear"  style="border-top: 1px solid ##B4C2CF;<cfif #CGI.HTTP_USER_AGENT# CONTAINS "MSIE">margin-top:36px<cfelse>margin-top:36px;</cfif>padding-top:15px;">&nbsp;</div>
		<label>123 Load Board</label>
		<input type="checkbox" name="loadBoard123" tabindex="30" id="loadBoard123" <cfif loadBoard123 EQ true>checked="checked"</cfif>   style="width:12px;" />
		<div class="clear"></div>
		<label>User Name</label> 
		<input type="text" name="loadBoard123Usename" tabindex="31" id="loadBoard123Usename"   value="#loadBoard123Usename#"    />
		<div class="clear"></div>
		<label>Password</label> 
		<input type="text" name="loadBoard123Password" tabindex="32" id="loadBoard123Password"   value="#loadBoard123Password#" />
		<div class="clear"  style="border-top: 1px solid ##B4C2CF;margin-top:36px;padding-top:15px;">&nbsp;</div>
		<label>DAT Load Board</label>
		<input type="checkbox" name="integratewithTran360" tabindex="33" id="integratewithTran360"  <cfif integratewithTran360 EQ true>checked="checked"</cfif>   style="width:12px;" />
		<div class="clear"></div>
		<label>User Name</label> 
		<input type="text" name="trans360Usename" tabindex="34" id="trans360Usename"   value="#trans360Usename#"    />
		<div class="clear"></div>
		<label>Password</label> 
		<input type="text" name="trans360Password" tabindex="35" id="trans360Password"   value="#trans360Password#" />
		<div class="clear"  style="border-top: 1px solid ##B4C2CF;margin-top:14px;padding-top:15px;">&nbsp;</div>
		<label>Internet Truck Stop</label> 
		<input type="text" name="integrationID" tabindex="36" id="integrationID" value="#integrationID#"/>
		<div class="clear"  style="border-top: 1px solid ##B4C2CF;margin-top:37px;padding-top:22px;">&nbsp;</div>
		<div style="padding-left:142px;">
        <input  type="submit" tabindex="37" name="submit" onfocus="checkUnload();" class="bttn" value="Save User" style="width:112px;" onclick="#saveAgentOnClick#" <cfif saveAgentOnClick eq ''>disabled="disabled"</cfif> />
        <input  type="button" onclick="javascript:history.back();" name="back" class="bttn" tabindex="38" value="Back" style="width:70px;" /></div>
		<div class="clear"></div>
		</fieldset>
	</div>
   <div class="clear"></div>
 </cfform>
<cfif isDefined("url.agentid") and len(agentid) gt 1>
<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qAgent")>&nbsp;&nbsp;&nbsp; #request.qAgent.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qAgent.LastModifiedBy#</cfif></p>
</cfif>
</div>

<div class="white-bot">	
</div>
</div>
<script type="text/javascript">
		$(document).ready(function(){
			<cfif structKeyExists(url, 'Palert') and trim(url.Palert) neq "1">alert("#url.Palert#");</cfif>
//			$('##verifySMTP').click(function(){
//				
//				if(trim($('##FA_smtpAddress').val()) != "" && trim($('##FA_smtpUsername').val()) != "" && trim($('##FA_smtpPassword').val()) != "" && trim($('##FA_smtpPort').val()) != "" && $("input[type='radio'][name='FA_SEC']:checked").length && trim($("input[type='radio'][name='FA_SEC']:checked").val()) != "")
//				{
//					if(trim($("input[type='radio'][name='FA_SEC']:checked").val()) == "SSL")
//					{var secure="&useSSL=true";}
//					else
//					{var secure="&useTLS=true";}
//					var path = "../gateways/agentgateway.cfc?method=verifyMailServer"+secure+"";
//					$.ajax({
//						type : 'POST',
//						url	:path,
//						data: { 
//							host:trim($('##FA_smtpAddress').val()),
//							protocol : "smtp",
//							port     : trim($('##FA_smtpPort').val()),    
//							user     : trim($('##FA_smtpUsername').val()),
//							password : trim($('##FA_smtpPassword').val()),
//							overwrite: false,
//							timeout :10000
//						},
//						success:function(data) {
//							console.log(data.WASVERIFIED);
//						}
//					});
//				}
//			});
			 $('##mailDocLink').click(function(){
				if($(this).attr('data-allowmail') == 'false')
				alert('You must setup your email address in your profile before you can email documents.');
				else
				mailDocOnClick('#session.URLToken#','agent'<cfif isDefined("url.agentId") and len(url.agentId) gt 1>,'#url.agentId#'</cfif>);
			 });
		});
</script>
</cfoutput>