<cfscript>
	variables.objOfficeGateway = getGateway("gateways.officegateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objAgentGateway = getGateway("gateways.agentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfif  request.event neq 'login' AND request.event neq 'customerlogin'>
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- <cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") /> --->
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="office">
				<cfinvoke component="#variables.objOfficeGateway#" method="getAllOffices" returnvariable="request.qOffice" />
				<cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/office/disp_office.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addoffice">
				 <cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/office/addoffices.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addoffice:process">
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
				 <cfif isdefined("form.editid") and len(form.editId) gt 1>
					<cfinvoke component="#variables.objOfficeGateway#" method="updateOffice" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
				    </cfinvoke>
				 <cfelse>	 
					 <cfinvoke component="#variables.objOfficeGateway#" method="Addoffice" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <!--- <cfoutput>#message#</cfoutput> --->
				 <cfinvoke component="#variables.objOfficeGateway#" method="getAllOffices" returnvariable="request.qOffice" />
				 <cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/office/disp_office.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
		</cfswitch>
		</cfif>
</cfif>
