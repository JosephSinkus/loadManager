<cfcomponent>
	<cfscript>
		variables.rstPrivileges = "";
	</cfscript>
	
	<!--- INIT FUNCTION TO INITIALIZE VARIABLES --->
	<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="xmlFilePath" type="string" required="yes" />
		<cfscript>
			variables.rstPrivileges = readPrivileges(arguments.xmlFilePath);
		</cfscript>
	</cffunction>

	<cffunction name="getPrivileges" access="public" output="false" returntype="query">
		<cfargument name="lstPrivilegeIDs" type="string" required="no" />
		<cfargument name="strCriteria" type="string" required="no" />
		<cfset var rstPrivileges = "" />
		
		<cfif StructKeyExists(arguments, "lstPrivilegeIDs") And Len(arguments.lstPrivilegeIDs) EQ 0>
			<cfset arguments.lstPrivilegeIDs = 0 />
		</cfif>
		
		<cfquery name="rstPrivileges" dbtype="query">
			SELECT DISTINCT iPrivilegeID,sPrivilege
			FROM variables.rstPrivileges
			WHERE 1 = 1
			<cfif StructKeyExists(arguments, "lstPrivilegeIDs")>
				AND iPrivilegeID IN (#arguments.lstPrivilegeIDs#)
			</cfif>
			<cfif StructKeyExists(arguments, "strCriteria")>
				AND sPrivilege LIKE '%#arguments.strCriteria#%'
			</cfif>
			ORDER BY sPrivilege
		</cfquery>
		
		<cfreturn rstPrivileges />
	</cffunction>

	<cffunction name="getEventsFromPrivilegeIDs" access="public" output="false" returntype="string">
		<cfargument name="lstPrivilegeIDs" type="string" required="yes" />
		<cfset var lstEvents = "" />
		<cfset var rstEvents = "" />
		
		<cfif StructKeyExists(arguments, "lstPrivilegeIDs") And Len(arguments.lstPrivilegeIDs) EQ 0>
			<cfset arguments.lstPrivilegeIDs = 0 />
		</cfif>

		<cfquery name="rstEvents" dbtype="query">
			SELECT DISTINCT sEvent
			FROM variables.rstPrivileges
			WHERE iPrivilegeID IN (#arguments.lstPrivilegeIDs#)
		</cfquery>
		
		<cfset lstEvents = ValueList(rstEvents.sEvent, "|") />

		<cfreturn lstEvents />
	</cffunction>

	<cffunction name="getObjectsFromPrivilegeIDs" access="public" output="false" returntype="string">
		<cfargument name="lstPrivilegeIDs" type="string" required="yes" />
		<cfset var lstObjects = "" />
		<cfset var rstObjects = "" />
		
		<cfif StructKeyExists(arguments, "lstPrivilegeIDs") And Len(arguments.lstPrivilegeIDs) EQ 0>
			<cfset arguments.lstPrivilegeIDs = 0 />
		</cfif>

		<cfquery name="rstObjects" dbtype="query">
			SELECT DISTINCT sObject
			FROM variables.rstPrivileges
			WHERE iPrivilegeID IN (#arguments.lstPrivilegeIDs#)
		</cfquery>
		
		<cfset lstObjects = ValueList(rstObjects.sObject, "|") />
				
		<cfreturn lstObjects />
	</cffunction>

	<cffunction name="readPrivileges" access="private" output="false" returntype="query">
		<cfargument name="xmlFilePath" required="yes" type="string" />
		<cfset var xmlFile = "" />
		<cfset var strFileData = "" />
		<cfset var qoqReturn = QueryNew("iPrivilegeID,sPrivilege,sEvent,sObject", "integer,varchar,varchar,varchar") />
		<cfset var arrPrivileges = "" />
		<cfset var intPrivilegeArrayCount = 0 />
		<cfset var intPrivilegeID = 0 />
		<cfset var strPrivilegeName = "" />
		<cfset var arrPrivilegeChildren = "" />
		<cfset var intPrivilegeChildrenArrayCount = 0 />
		<cfset var lstCheckDuplicates = "," />
		
		<cffile action="read" file="#arguments.xmlFilePath#" variable="strFileData" >
		
		<cfscript>
			xmlFile = XMLParse(strFileData);
			arrPrivileges = xmlFile.privileges.xmlChildren;
			
			for (intPrivilegeArrayCount = 1; intPrivilegeArrayCount LTE ArrayLen(arrPrivileges); intPrivilegeArrayCount = intPrivilegeArrayCount + 1) {
				intPrivilegeID = arrPrivileges[intPrivilegeArrayCount].xmlAttributes.id;
				
				if (Find("," & intPrivilegeID & ",", lstCheckDuplicates) GT 0) 
					cfthrowError("2001", "Duplicate Privilege ID", "A duplicate privilege id was found in the privileges.xml file.  The duplicate id was '#intPrivilegeID#'.", "developer");
					
				lstCheckDuplicates = lstCheckDuplicates & intPrivilegeID & ","; //ListAppend(lstCheckDuplicates, intPrivilegeID);
				
				strPrivilegeName = arrPrivileges[intPrivilegeArrayCount].xmlAttributes.name;
				arrPrivilegeChildren = arrPrivileges[intPrivilegeArrayCount].xmlChildren;
				for (intPrivilegeChildrenArrayCount = 1; intPrivilegeChildrenArrayCount LTE ArrayLen(arrPrivilegeChildren); intPrivilegeChildrenArrayCount = intPrivilegeChildrenArrayCount + 1) {
					QueryAddRow(qoqReturn, 1);
					QuerySetCell(qoqReturn, "iPrivilegeID", intPrivilegeID);
					QuerySetCell(qoqReturn, "sPrivilege", strPrivilegeName);
					
					if (LCase(arrPrivilegeChildren[intPrivilegeChildrenArrayCount].xmlName) EQ "event") {
						QuerySetCell(qoqReturn, "sEvent", arrPrivilegeChildren[intPrivilegeChildrenArrayCount].xmlAttributes.name);
					}
					else if (LCase(arrPrivilegeChildren[intPrivilegeChildrenArrayCount].xmlName) EQ "object") {
						QuerySetCell(qoqReturn, "sObject", arrPrivilegeChildren[intPrivilegeChildrenArrayCount].xmlAttributes.name);
					}
				}
			}
		
		</cfscript>		
		<cfreturn qoqReturn />		
	</cffunction>
	
	<cffunction name="cfthrowError" access="private" output="false" returntype="void">
		<cfdump var="#arguments#" />
		<cfabort />
	</cffunction>
	
</cfcomponent>