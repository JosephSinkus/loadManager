<cfquery name="getLoads" datasource="mps">
	select distinct loadid,customerid,loadstopid from loadstops where customerid is not null and  StateCode=''
</cfquery>

<cfdump var="recordcount:#getLoads.recordcount#">
<cfloop query="getloads">
	<cfdump var="#loadstopid#,">
	<cfquery name="getcustomerinformation" datasource="mps">
		select customers.*,states.* from customers left join states on customers.stateid = states.stateid where customerid = '#getloads.customerid#'
	</cfquery>
	
	<cfquery name="updateLoadstops" datasource="mps">
		update loadstops set statecode='#getcustomerinformation.statecode#' where loadstopid='#getloads.loadstopid#'
	</cfquery>	

</cfloop>