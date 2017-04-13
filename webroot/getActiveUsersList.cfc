<cfcomponent output="true">
	<cfsetting showdebugoutput="true">
	<cffunction access="remote" name="getActiveUsersList" returntype="string" returnformat="plain"> 
		<cfif structkeyexists (session,"empid")>
			<cfquery name="qrygetusername" datasource="#Application.dsn#" result="qInsertUserLogged">
				select Name from employees where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
			</cfquery>

			<cfquery name="qIsLoggedIn" datasource="#Application.dsn#" result="qDeleteUserLogged">
				SELECT * from userCountCheck where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
			</cfquery>
			<cfif qIsLoggedIn.recordcount>
				<cfif qIsLoggedIn.isLoggedIn EQ 1>
					<cfquery name="qUpdateActiveStatus" datasource="#Application.dsn#" result="qDeleteUserLogged">
						UPDATE userCountCheck
						SET isactive=<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 
							isLoggedIn=<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
							currenttime=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
						where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
					</cfquery>
				<cfelse>
					<cfquery name="qDeleteLogginCount" datasource="#Application.dsn#" result="a">
						delete from userCountCheck
						where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">						
					</cfquery>
					<cfset structDelete(cookie, "userLogginID") />
					<cfset structDelete(session, "passport") />
					<cfset session.searchtext="" />
					<cfset local.data = "false">
					<cfreturn serializeJSON(local.data) >
				</cfif>
			<cfelse>	
				<cfset local.data = "false">
				<cfif structKeyExists(session, "empid")>
					<cfset structDelete(session, "empid") />
					<cfreturn serializeJSON(local.data) >
				</cfif>
			</cfif>	
		<cfelse>
			<!--- <cfset logoutvar = logoutuser()> --->
			<cfset structDelete(session, "passport") />
			<cfset session.searchtext="" />
			<cflocation url="index.cfm?event=login&AlertMessageID=3" addtoken="yes" />
		</cfif>
	</cffunction>	

	<!---<cfset local.startdate = dateFormat(now(), "mm/dd/yyyy")>
		<cfschedule action="update" url="https://loadmanager.biz/lmdev/www/webroot/deleteInActiveUsers.cfm" startdate="#local.startdate#" starttime="00:00:00" interval="7" task="Deleting Inactive Users"> --->
</cfcomponent>	

