<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- Page: switch.cfm --->
<!--- Purpose: This is the farmework's main page.  DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING! --->
<!--- Created By: Clive Munro --->
<!--- Date: 2007-03-17 --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- MAKE SURE THAT THE VARIABLES YOU NEED ARE HERE --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<cfparam name="URL.event" default="login" />
<cfparam name="request.event" default="#URL.event#" />
<cfparam name="request.SubNavigation" default="" />
<cfparam name="request.strBase" default="" />


<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- INCLUDE LISTENERS --->

<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<cfinclude template="listeners/security/securitylistener.cfm" />
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<!--- INCLUDE THE EXTRA SWITCH PAGES --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<cfinclude template="securityswitch.cfm" />
<!---Condition to check the user is not in loadedit page--->
<cfif structKeyExists(url, "event") and url.event neq "addload" and url.event neq "nextStopLoad" and structkeyexists(session,"empid") and len(trim(session.empid)) and structkeyexists(session,"currentloadid") and len(trim(session.currentloadid))>
	<!---Object to get corresponding user edited the load--->
	<cfinvoke component="#variables.objloadGateway#" method="getUserEditingDetails" loadid="#session.currentloadid#" returnvariable="request.qryUserId"/>
	<cfif request.qryUserId.recordcount and request.qryUserId.inuseby eq  session.empid >
		<!---Object to update corresponding user edited the load to null--->
		<cfinvoke component="#variables.objloadGateway#" method="updateEditingUserId" loadid="" userid="#session.empid#" status="true"/>
	</cfif>
</cfif>
<cfinclude template="agentswitch.cfm" />
<cfinclude template="officeswitch.cfm" />
<cfinclude template="Customerswitch.cfm" />
<cfinclude template="carrierswitch.cfm" />
<cfinclude template="equipmentswitch.cfm" />
<cfinclude template="unitswitch.cfm" />
<cfinclude template="classswitch.cfm" />
<cfinclude template="loadswitch.cfm" />
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- PRIVATE FUNCTIONS --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<cffunction name="includeTemplate" access="private" output="true" returntype="string" >
	<cfargument name="strIncludePage" required="yes" type="string" />
	<cfargument name="blnReturnTheContent" required="no" type="boolean" default="false" />	
	<cfset var returnContent = "" />	
	<cfif arguments.blnReturnTheContent >
		<cfsavecontent variable="returnContent">
			<cfinclude template="#arguments.strIncludePage#" />
		</cfsavecontent>
		<cfreturn returnContent />
	<cfelse>
		<cfinclude template="#arguments.strIncludePage#" />
	</cfif>
</cffunction>

<cffunction name="GetBean" access="private" output="false" returntype="any">
	<cfargument name="BeanPath" type="string" required="yes" />
	<cfset var objBean = CreateObject("component", arguments.BeanPath) />
	<cfset var arrFormKeys = "" />
	
	<!--- IF THE FORM IS DEFINED, THEN POPULATE THE BEAN WITH THE FORM VARIABLES --->
	<cfif IsDefined("FORM")>
		<cfset arrFormKeys = ListToArray(StructKeyList(FORM)) />
		<cfif ArrayLen(arrFormKeys) GT 0>
			<cfinvoke component="#objBean#" method="init">
				<cfloop from="1" to="#ArrayLen(arrFormKeys)#" index="i">
					<!--- FIRST REMOVE THE PREFIX --->
					<cfif ListFindNoCase("txt,hdn,cbo,rdo", Left(arrFormKeys[i], 3)) GT 0>
						<cfset strArgName = Mid(arrFormKeys[i], 4, Len(arrFormKeys[i])) />
					<cfelse>
						<cfset strArgName = arrFormKeys[i] />
					</cfif>
					<cfset strArgValue = Evaluate("FORM.#arrFormKeys[i]#") />
					<cfinvokeargument name="#strArgName#" value="#strArgValue#" />
				</cfloop>
			</cfinvoke>
		</cfif>
	</cfif>
	
	<cfreturn objBean />
</cffunction>

<cffunction name="getGateway" access="private" output="false" returntype="any">
	<cfargument name="GatewayPath" type="string" required="yes" />
	<cfargument name="Parameters" type="array" required="no" default="#ArrayNew(1)#" />
	<cfset var tmpGateway = "" />
	<cfset var objFile = CreateObject("java", "java.io.File") />
	<cfset var objDate = CreateObject("java","java.util.Date") />
	<cfset var blnGatewayExpired = true />
	<cfset var intArrayCount = 0 />
	
    <!--- Check the Last Modified Date --->
	<cfscript>
        if (Not StructKeyExists(Application, "Gateways"))
            Application.Gateways = StructNew();

        if (StructKeyExists(Application.Gateways, arguments.GatewayPath)) {
            objFile.init(ExpandPath(Replace(arguments.GatewayPath, ".", "/", "ALL")));
            if (objDate.init(objFile.lastModified()) GT Application.Gateways[arguments.GatewayPath].lastLoaded)
                blnGatewayExpired = true;
        }
    </cfscript>
    
	<cfif (Not StructKeyExists(Application.Gateways, arguments.GatewayPath) OR IsDefined("URL.reload") OR blnGatewayExpired OR Session.blnDebugMode)>
		<!--- Lock and Reload --->
		<cflock name="application_#Application.Name#_gatewayloader" type="exclusive" timeout="120">

			<cfset tmpGateway = CreateObject("component", arguments.GatewayPath) />

			<cfinvoke component="#tmpGateway#" method="init">
				<cfloop from="1" to="#ArrayLen(arguments.Parameters)#" index="intArrayCount">
					<cfinvokeargument name="#arguments.Parameters[intArrayCount].name#" value="#arguments.Parameters[intArrayCount].value#" />
				</cfloop>
			</cfinvoke>

			<cfscript>
				Application.Gateways[arguments.GatewayPath] = StructNew();
				Application.Gateways[arguments.GatewayPath].object = tmpGateway;
				Application.Gateways[arguments.GatewayPath].lastLoaded = Now();
			</cfscript>

        </cflock>
	</cfif>
	
		<cfreturn Application.Gateways[arguments.GatewayPath].object />

</cffunction>

<cffunction name="getPlugin" access="private" output="false" returntype="any">
	<cfargument name="PluginPath" type="string" required="yes" />
	<cfargument name="Parameters" type="array" required="no" default="#ArrayNew(1)#" />
	<cfset var tmpPlugin = "" />
	<cfset var objFile = CreateObject("java", "java.io.File") />
	<cfset var objDate = CreateObject("java","java.util.Date") />
	<cfset var blnPluginExpired = false />
	<cfset var intArrayCount = 0 />
	
    <!--- Check the Last Modified Date --->
	<cfscript>
        if (Not StructKeyExists(Application, "Plugins"))
            Application.Plugins = StructNew();

        if (StructKeyExists(Application.Plugins, arguments.PluginPath)) {
            objFile.init(ExpandPath("../" & Replace(arguments.PluginPath, ".", "/", "ALL") & ".cfc"));
            if (objDate.init(objFile.lastModified()) GT Application.Plugins[arguments.PluginPath].lastLoaded)
                blnPluginExpired = true;
        }
    </cfscript>

    <cfif (Not StructKeyExists(Application.Plugins, arguments.PluginPath) OR IsDefined("URL.reload") OR blnPluginExpired OR Session.blnDebugMode)>
		<!--- Lock and Reload --->
		<cflock name="application_#Application.Name#_pluginloader" type="exclusive" timeout="120">
			<cfset tmpPlugin = CreateObject("component", arguments.PluginPath) />
			<cfinvoke component="#tmpPlugin#" method="init">
				<cfloop from="1" to="#ArrayLen(arguments.Parameters)#" index="intArrayCount">
					<cfinvokeargument name="#arguments.Parameters[intArrayCount].name#" value="#arguments.Parameters[intArrayCount].value#" />
				</cfloop>
			</cfinvoke>
			<cfscript>
				Application.Plugins[arguments.PluginPath] = StructNew();
				Application.Plugins[arguments.PluginPath].object = tmpPlugin;
				Application.Plugins[arguments.PluginPath].lastLoaded = Now();
			</cfscript>
        </cflock>
	</cfif>
	<cfreturn Application.Plugins[arguments.PluginPath].object />
</cffunction>

<cffunction name="MakeParameters" access="private" output="false" returntype="Array">
	<cfargument name="ParameterString" type="string" required="yes" />
	<cfset var arrReturn = ArrayNew(1) />
	<cfset var tmpStruct = "" />
	<cfset var strParameterStringItem = "" />
	<cfset var intArrayCount = 0 />
	
	<cfloop list="#arguments.ParameterString#" index="strParameterStringItem">
		<cfset tmpStruct = StructNew() />
		<cfset tmpStruct.name = ListFirst(strParameterStringItem, "=") />
		<cfset tmpStruct.value = ListLast(strParameterStringItem, "=") />
		<cfset intArrayCount = intArrayCount + 1 />
		<cfset arrReturn[intArrayCount] = tmpStruct />
	</cfloop>
	
	<cfreturn arrReturn />
</cffunction>

<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
