<cfscript>
	variables.objclassGateway = getGateway("gateways.classgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfif  request.event neq 'login' AND request.event neq 'customerlogin'>
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- <cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") /> --->
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="class">			  
			    <cfinvoke component="#variables.objclassGateway#" method="getAllClasses" returnvariable="request.qClasses" />
				<cfset request.subnavigation = includeTemplate("views/admin/loadNav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/class/disp_class.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addclass">
                 <cfset request.subnavigation = includeTemplate("views/admin/loadNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/class/addclass.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addclass:process">                   
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 <cfif isdefined("form.editid") and len(form.editid) gt 1>
					<cfinvoke component="#variables.objclassGateway#" method="Updateclass" returnvariable="message">
					   <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 <cfelse>	 
					 <cfinvoke component="#variables.objclassGateway#" method="Addclass" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <!--- <cfoutput>#message#</cfoutput> --->
				 <cfinvoke component="#variables.objclassGateway#" method="getAllClasses" returnvariable="request.qClasses" />
				 <cfset request.subnavigation = includeTemplate("views/admin/loadNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/class/disp_class.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
            <cfdefaultcase></cfdefaultcase>
		</cfswitch>
		</cfif>
</cfif>
