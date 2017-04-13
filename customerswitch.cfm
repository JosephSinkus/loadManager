<cfscript>
	variables.objCutomerGateway = getGateway("gateways.customergateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objAgentGateway = getGateway("gateways.agentGateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfif  request.event neq 'login' AND request.event neq 'customerlogin'>
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") /> --->
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="customer">
				<!---<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" returnvariable="request.qCustomer" />--->
				<cfset request.subnavigation = includeTemplate("views/admin/customerNav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/customer/disp_customer.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addcustomer">
			     <cfinvoke component="#variables.objAgentGateway#" method="getOffices"  returnvariable="request.qOffices">
			     <cfinvoke component="#variables.objAgentGateway#" method="getAllCountries" returnvariable="request.qCountries" />
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qstates"/>
			     <cfinvoke component="#variables.objCutomerGateway#" method="getCompanies" returnvariable="request.qCompanies">
				 <cfinvoke component="#variables.objAgentGateway#" AuthLevelId="1,3,4" method="getSalesPerson" returnvariable="request.qSalesPerson" /> 
                 <!--- <cfinvoke component="#variables.objAgentGateway#" roleID="1" method="getAllRole" returnvariable="request.qRole"> --->   
				 <cfinvoke component="#variables.objAgentGateway#" AuthLevelId="3" method="getSalesPerson" returnvariable="request.qDispatcher" />  
                                             		   				                    
				 <cfset request.subnavigation = includeTemplate("views/admin/customerNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/customer/addcustomer.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addcustomer:process">
               
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 
                 <cfif isDefined("url.editid") and len(url.editid) gt 1>
                     <cfinvoke component="#variables.objCutomerGateway#" method="updateCustomers" returnvariable="message">
				     <cfinvokeargument name="formStruct" value="#formStruct#">
				     </cfinvoke>                                          
				 <cfelse>
                      <cfinvoke component="#variables.objCutomerGateway#" method="AddCustomer" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <!---<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" returnvariable="request.qCustomer" />--->
				 <cfset request.subnavigation = includeTemplate("views/admin/customerNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/customer/disp_customer.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="stop">
				<cfinvoke component="#variables.objCutomerGateway#" method="getAllStop" returnvariable="request.qStop" />
				<cfset request.subnavigation = includeTemplate("views/admin/customerNav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/customer/disp_stop.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addstop">
				 <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qstates"/>
			     <cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" returnvariable="request.qCustomer" />
				 <cfset request.subnavigation = includeTemplate("views/admin/customerNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/customer/addStop.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addstop:process">
               
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 
                 <cfif isDefined("url.editid") and len(url.editid) gt 1>
                     <cfinvoke component="#variables.objCutomerGateway#" method="updatestop" returnvariable="message">
				     <cfinvokeargument name="formStruct" value="#formStruct#">
				     </cfinvoke>                                          
				 <cfelse>
                      <cfinvoke component="#variables.objCutomerGateway#" method="AddStop" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <cfinvoke component="#variables.objCutomerGateway#" method="getAllStop" returnvariable="request.qStop" />
				 <cfset request.subnavigation = includeTemplate("views/admin/customerNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/customer/disp_stop.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
		</cfswitch>
		</cfif>
</cfif>
