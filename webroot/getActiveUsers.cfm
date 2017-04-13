<cfset SmtpAddress='smtpout.secureserver.net'>
<cfset SmtpUsername='no-reply@loadmanager.com'>
<cfset SmtpPort='3535'>
<cfset SmtpPassword='wsi11787'>
<cfset FA_SSL=0>
<cfset FA_TLS=1>
<!--- <cfset variables.timeOutPoint = DateAdd('s', -30, Now())> --->
<cfset variables.timeout=this.sessiontimeout>
<cfquery name="qDeleteUserLoggedInCount" datasource="#Application.dsn#">
	update onlineusers
	set
	isActive=<cfqueryparam cfsqltype="cf_sql_bit" value="0">
	where lastseenDatetime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', '-#variables.timeout#', Now())#">
</cfquery>
<!--- <cfmail type="text" from="#SmtpUsername#" subject="Lost Password Retrieval" to="arunraj@spericorn.com" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
	<cfquery name="qusercount" datasource="#Application.dsn#">
	select count(*) as count from userLoggedInCount
	where isactive=1
	</cfquery>

	<cfoutput>#qusercount.count#</cfoutput>
</cfmail>
 --->