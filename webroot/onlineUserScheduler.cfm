<cfset nextTime = timeFormat(now(),"hh:mm tt")>
<cfset variables.currentFileName = ListLast(cgi.SCRIPT_NAME,"/")>
<cfset variables.schedulerPathForlistOnlineusers = ReplaceNoCase(cgi.SCRIPT_NAME,variables.currentFileName ,"getActiveUsers.cfm")>
<cfif cgi.https EQ "off">
	<cfset variables.https = "http">
<cfelse>
	<cfset variables.https = "https">
</cfif>
<cfschedule 
    action="update" 
    task="listOnlineusers#application.dsn#" 
    operation="httprequest" 
    url="#variables.https#://#cgi.http_host##variables.schedulerPathForlistOnlineusers#" 
    startdate="#dateFormat(Now(), 'mm-dd-yyyy')#" 
    starttime="#nextTime#" 
    resolveurl="yes" 
    interval="30"
/>