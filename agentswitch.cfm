<cfscript>
	variables.objAgentGateway = getGateway("gateways.agentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfif request.event neq 'login' AND request.event neq 'customerlogin' AND request.event neq 'lostPassword' AND request.event neq "recoveryEmailSuccess">
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- <cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			
			<cfset includeTemplate("views/templates/maintemplate.cfm") />  --->
			<cflocation url="index.cfm?event=login&AlertMessageID=2" addtoken="no">
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="agent">
				<cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" returnvariable="request.qAgent" />
			    <cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/agent/disp_agent.cfm", true) />
			    <cfset includeTemplate("views/templates/maintemplate.cfm") /> 
			</cfcase>
			<cfcase value="addagent">
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllCountries" returnvariable="request.qCountries" />
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qstates"/>
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" returnvariable="request.qAgent" />
				 <cfinvoke component="#variables.objAgentGateway#" method="getOffices" returnvariable="request.qoffices"/>
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllRole" returnvariable="request.qRoles"/>
				 <cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/agent/add_agent.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addagent:process">
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
				 <cfset transMsg = "">
				 <cfif structKeyExists(form,"INTEGRATEWITHTRAN360")>
					<cfinvoke component="#variables.objAgentGateway#" method="verifyTrancoreLoginStatus" returnvariable="transLoginStatus">
						<cfinvokeargument name="tranUname" value="#formStruct.TRANS360USENAME#">
						<cfinvokeargument name="tranPwd" value="#formStruct.TRANS360PASSWORD#">
				    </cfinvoke>
					<cfif not transLoginStatus>
						<cfset structDelete(formStruct,"INTEGRATEWITHTRAN360")>
						<cfset formStruct.TRANS360USENAME = "">
						<cfset formStruct.TRANS360PASSWORD = "">
						<cfset transMsg = 'The Transcore 360 credentials failed. Please update the user name and password and try again.'>
					</cfif>
				 </cfif>
				 <cfif isdefined("form.editid") and len(form.editId) gt 1>
					<cfinvoke component="#variables.objAgentGateway#" method="UpdateAgent" returnvariable="employeeID">
						<cfinvokeargument name="formStruct" value="#formStruct#">
				    </cfinvoke>
				 <cfelse>	 
					 <cfinvoke component="#variables.objAgentGateway#" method="AddAgent" returnvariable="employeeID">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <cfif transMsg.length()>
				 	<cfset message = transMsg>
				 </cfif>
					 
				 <cfif structKeyExists(form,"verifySMTP")>
					 <cfif isdefined("formStruct.FA_SEC") and formStruct.FA_SEC eq "SSL">
						<cfset FA_SSL=True>
						<cfset FA_TLS=False>
					 <cfelse>
						<cfset FA_SSL=False>
						<cfset FA_TLS=True>
					 </cfif>
					 <cfif isdefined("formStruct.FA_smtpPort") and formStruct.FA_smtpPort eq "">
						<cfset FA_port=0>
					 <cfelse>
						<cfset FA_port=formStruct.FA_smtpPort>
					 </cfif>
					 <cfinvoke component="#variables.objAgentGateway#" method="verifyMailServer" returnvariable="status">
						<cfinvokeargument name="host" value="#formStruct.FA_smtpAddress#">
						<cfinvokeargument name="protocol" value="smtp">
						<cfinvokeargument name="port" value=#FA_port#>
						<cfinvokeargument name="user" value="#formStruct.FA_smtpUsername#">
						<cfinvokeargument name="password" value="#formStruct.FA_smtpPassword#">
						<cfinvokeargument name="useTLS" value=#FA_TLS#>
						<cfinvokeargument name="useSSL" value=#FA_SSL#>
						<cfinvokeargument name="overwrite" value=false>
						<cfinvokeargument name="timeout" value=10000>
				     </cfinvoke>
					<cfif status.WASVERIFIED>
					<cfset verifiedStatus = "The SMTP settings are valid.">
					<cfelse>
					<cfset verifiedStatus = "The SMTP settings are not valid.">	
					</cfif>
					<cfoutput>
						<script>
							window.location = "index.cfm?event=addagent&agentId=#employeeID#&&#session.URLToken#&Palert=#verifiedStatus#";
						</script>
					</cfoutput>
					<cfabort>
				</cfif>
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" returnvariable="request.qAgent" />
				 <cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/agent/disp_agent.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
            </cfcase>
		</cfswitch>
		</cfif>
</cfif>
