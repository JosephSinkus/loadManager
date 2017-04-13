
<cfcomponent output="true">

	<cffunction access="remote" name="eliminateinactiveusers" returntype="any" returnformat="plain">
		<cfset local.response.returnval = false>
		
			<cfquery name="qUpdateLoginStatus" datasource="#Application.dsn#" result="updateLoginStatusResult">
				delete from userCountCheck				
				WHERE cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.customerId#">
				AND useruniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.useruniqueid#">
			</cfquery>
			
		<cfreturn true>
	</cffunction>	

</cfcomponent>	