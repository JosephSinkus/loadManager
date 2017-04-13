<cfif isdefined("url.val") and url.val neq "">
 <cfsilent>
	<cfquery name="getEarlierCustName" datasource="#varDsn#">
	    SELECT TOP 1 LoadID,LoadNumber from Loads where LoadNumber=#url.val#
	</cfquery>
</cfsilent>
	<cfoutput>
    <cfif getEarlierCustName.recordcount gt 0>
		<cfset cnt=1>#cnt#
	<cfelse>
		<cfset cnt=0>#cnt#
	</cfif>
	</cfoutput>
</cfif>