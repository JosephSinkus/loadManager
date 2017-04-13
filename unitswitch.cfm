<cfscript>
	variables.objunitGateway = getGateway("gateways.unitgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfif  request.event neq 'login' AND request.event neq 'customerlogin'>
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- <cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") /> --->
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="unit">			  
			    <cfinvoke component="#variables.objunitGateway#" method="getAllUnits" returnvariable="request.qUnits" />
				<cfset request.subnavigation = includeTemplate("views/admin/loadNav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/unit/disp_unit.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addunit">
                 <cfset request.subnavigation = includeTemplate("views/admin/loadNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/unit/addunit.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addunit:process">                   
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 <cfif isdefined("form.editid") and len(form.editid) gt 1>
					<cfinvoke component="#variables.objunitGateway#" method="Updateunit" returnvariable="message">
					   <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 <cfelse>	 
					 <cfinvoke component="#variables.objunitGateway#" method="Addunit" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <!--- <cfoutput>#message#</cfoutput> --->
				 <cfinvoke component="#variables.objunitGateway#" method="getAllUnits" returnvariable="request.qUnits" />
				 <cfset request.subnavigation = includeTemplate("views/admin/loadNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/unit/disp_unit.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
            <cfdefaultcase></cfdefaultcase>
		</cfswitch>
		</cfif>
</cfif>
