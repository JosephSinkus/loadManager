<cfoutput>
	<cfquery name="qUpdateActiveStatus" datasource="#Application.dsn#" result="ShedulerResult">
		delete from userCountCheck 		
		WHERE datediff(ss,currenttime,getDate()) > 86400
	</cfquery>
</cfoutput>