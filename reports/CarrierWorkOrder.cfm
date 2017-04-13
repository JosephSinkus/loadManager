<cfinclude template="../webroot/Application.cfm">

<cfif structkeyexists(url,"loadno") or structkeyexists(url,"loadid")>

	<cfquery name="careerReport" datasource="#Application.dsn#">
		SELECT *, 
			(SELECT sum(weight)  from vwCarrierConfirmationReport 
			   <cfif structkeyexists(url,"loadno")>
					WHERE  (LoadNumber = #url.loadno#)
				<cfelseif structkeyexists(url,"loadid")>
					WHERE  (LoadID = '#url.loadid#')
			   </cfif>
			 GROUP BY loadnumber) as TotalWeight 
		FROM vwCarrierConfirmationReport
	   <cfif structkeyexists(url,"loadno")>
			WHERE  (LoadNumber = #url.loadno#)
		<cfelseif structkeyexists(url,"loadid")>
			WHERE  (LoadID = '#url.loadid#')
	   </cfif>
	   	   ORDER BY stopnum 
	</cfquery>
	 <cfoutput>
	<cfreport format="PDF" template="CarrierWordOrder.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
		<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
	</cfreport> 
	</cfoutput>	 
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
</cfif>	