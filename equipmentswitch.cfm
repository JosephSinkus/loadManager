<cfscript>
	variables.objequipmentGateway = getGateway("gateways.equipmentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfif  request.event neq 'login' AND request.event neq 'customerlogin'>
		<cfif (not isdefined("session.passport.isLoggedIn") or not(session.passport.isLoggedIn))>
			<!--- <cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") /> --->
		<cfelse>
		<cfswitch expression="#request.event#">
			<cfcase value="equipment">
				<cfif structkeyexists(url,"EquipmentMaint")>
					<cfset variables.maintenanceWithEquipment = 0>
					<cfif structkeyexists(url,"maintenanceWithEquipment")  and url.maintenanceWithEquipment EQ 1>
						<cfset variables.maintenanceWithEquipment = 1>
					</cfif>
					<cfset variables.EquipmentMaint = 1>
				<cfelse>
					<cfset variables.EquipmentMaint = 0>
					<cfset variables.maintenanceWithEquipment = 0>
				</cfif>
				<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" EquipmentMaint="#variables.EquipmentMaint#" maintenanceWithEquipment="#variables.maintenanceWithEquipment#" returnvariable="request.qEquipments" />
				<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				<cfset request.content = includeTemplate("views/pages/equipment/disp_equipment.cfm", true) />
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addequipment">
                 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/addequipment.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addequipment:process">                   
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 <cfif structkeyexists(form,"editid") and len(form.editid) gt 1>
					<cfinvoke component="#variables.objequipmentGateway#" method="Updateequipment" returnvariable="message">
					   <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 <cfelse>	 
					 <cfinvoke component="#variables.objequipmentGateway#" method="Addequipment" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <!--- <cfoutput>#message#</cfoutput> --->
				 <cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
				 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/disp_equipment.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addDriverEquipment">
				<cfif structkeyexists(form,"equipmentId")>
					 <cfset formStruct = structNew()>
					<cfset formStruct = form>
					<cfinvoke component="#variables.objequipmentGateway#" method="insertEquipMaintInformation" returnvariable="message">
					   <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				</cfif>
				<cfif structkeyexists(form,"equipmentIdForMainTrans")>
					 <cfset formStruct = structNew()>
					<cfset formStruct = form>
					<cfinvoke component="#variables.objequipmentGateway#" method="insertEquipMaintTransInformation" returnvariable="message">
					   <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				</cfif>
				<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				<cfset request.content=includeTemplate("views/pages/equipment/addDriverEquipment.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="maintenanceSetUp">
				<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformation" returnvariable="request.qGetMaintenanceInformation" />
                 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/disp_maintenanceSetup.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addMaintenanceSetUp">
                 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/addMaintenanceSetUp.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addmaintenance:process">                   
				 <cfset formStruct = structNew()>
				 <cfset formStruct = form>
                 <cfif structkeyexists(form,"editid") and len(form.editid) gt 0>
					<cfinvoke component="#variables.objequipmentGateway#" method="UpdateMaintenanceInformation" returnvariable="message">
					   <cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 <cfelse>	 
					 <cfinvoke component="#variables.objequipmentGateway#" method="AddMaintenanceInformation" returnvariable="message">
						<cfinvokeargument name="formStruct" value="#formStruct#">
					 </cfinvoke>
				 </cfif>
				 <!--- <cfoutput>#message#</cfoutput> --->
				 <cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformation" returnvariable="request.qGetMaintenanceInformation" />
				 <cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				 <cfset request.content=includeTemplate("views/pages/equipment/disp_maintenanceSetup.cfm",true)/>
				 <cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addNewMaintenance">
				<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				<cfset request.content=includeTemplate("views/pages/equipment/addNewMaintenance.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="addNewMaintenance:process">
				<cfset formStruct = structNew()>
				<cfset formStruct = form>
				<cfif structkeyexists(form,"equipmentId")>
					<cfif structkeyexists(form,"editEquipmentmMaintId") and len(trim(formStruct.editEquipmentmMaintId)) gt 0>
						<cfinvoke component="#variables.objequipmentGateway#" method="updadeEquipMaintInformation" returnvariable="message">
							<cfinvokeargument name="formStruct" value="#formStruct#">
						</cfinvoke>
					<cfelse>
						<cfinvoke component="#variables.objequipmentGateway#" method="insertEquipMaintInformation" returnvariable="message">
						   <cfinvokeargument name="formStruct" value="#formStruct#">
						</cfinvoke>
					</cfif>	
				</cfif>
				<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				<cfset request.content=includeTemplate("views/pages/equipment/addDriverEquipment.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") /> 
			</cfcase>
			<cfcase value="addNewMaintenanceTransaction">
				<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				<cfset request.content=includeTemplate("views/pages/equipment/addNewMaintenanceTransaction.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
			<cfcase value="iftaDownload">
				<cfif structkeyexists(url,"getExcel")>
					<cfset includeTemplate("views/pages/equipment/getExcel.cfm") />
				</cfif>
				<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
				<cfset request.content=includeTemplate("views/pages/equipment/ifta_export.cfm",true)/>
				<cfset includeTemplate("views/templates/maintemplate.cfm") />
			</cfcase>
            <cfdefaultcase>
			</cfdefaultcase>
		</cfswitch>
		</cfif>
</cfif>
