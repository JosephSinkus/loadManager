<cfinclude template="../webroot/Application.cfm">


<cfset variables.frieghtBroker = "">
<cfif structkeyexists(url,"type")>
	<cfset variables.frieghtBroker=url.type>
</cfif>

<cfif structkeyexists(url,"loadno") or structkeyexists(url,"loadid")>
	<cfquery name="careerReport" datasource="#Application.dsn#">
	
		SELECT * FROM vwCarrierRateConfirmation
	   <cfif structkeyexists(url,"loadno")>
			WHERE  (LoadNumber = #url.loadno#)
		<cfelseif structkeyexists(url,"loadid")>
			WHERE  (LoadID = '#url.loadid#')
	   </cfif>
			ORDER BY StopNo, LoadType, SrNo
	   </cfquery>
	 <cfoutput>
	<!---
	<cfreport format="PDF" template="loadReportForCarrierConfirmation.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
	--->
	<cfif variables.frieghtBroker eq 'Carrier'>
		<cfreport format="PDF" template="loadReportForCarrierConfirmation.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
			<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
		</cfreport> 
	<cfelseif variables.frieghtBroker eq 'Dispatch'>
	<!---
		<cfreport format="PDF" template="LoadReportForDispatch.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
	--->
		<cfreport format="PDF" template="loadReportForCarrierConfirmation.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 		
			<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
		</cfreport> 
	</cfif>	
	</cfoutput>	 
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
</cfif>	