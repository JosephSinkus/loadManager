<cfoutput>
<cfif structkeyExists(url,"dsn")>
<!--- Decrypt String --->
<cfset TheKey = 'NAMASKARAM'>
<cfset dsn = Decrypt(ToString(ToBinary(url.dsn)), TheKey)>
</cfif>
<cfif structkeyexists(url,"loadno") or structkeyexists(url,"loadid")>
	<cfquery name="careerReport" datasource="#dsn#">
		SELECT *, 
			(SELECT sum(weight)  from vwCarrierConfirmationReport 
			   <cfif structkeyexists(url,"loadno")>
					WHERE  (LoadNumber = #url.loadno#)
				<cfelseif structkeyexists(url,"loadid")>
					WHERE  (LoadID = '#url.loadid#')
			   </cfif>
			 GROUP BY loadnumber) as TotalWeight 
		FROM vwCustomerInvoiceReport
	   <cfif structkeyexists(url,"loadno")>
			WHERE  (LoadNumber = #url.loadno#)
		<cfelseif structkeyexists(url,"loadid")>
			WHERE  (LoadID = '#url.loadid#')
	   </cfif>
	   	   ORDER BY stopnum 
	</cfquery> 
    
	<cfreport format="PDF" template="../reports/CustomerInvoiceReport.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
		<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
	</cfreport> 	 
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
</cfif>
</cfoutput>