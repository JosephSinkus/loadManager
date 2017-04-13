<!---cffunction name="clean_export_data" access="public" output="false" description="To clean the export to excel data of chr(9) and avoid issue with "" inside the value">
	<cfargument name="input_string" required="true">	
	<cfset return_string = TRIM(replace(ARGUMENTS.input_string,chr(9),' ','all')) />
	<cfset return_string = TRIM(replace(return_string,chr(10),' ','all')) />
	<cfset return_string = TRIM(replace(return_string,chr(13),' ','all')) />
	<cfset return_string = replace(return_string,'"','""','all') />	
	<cfreturn return_string />
</cffunction--->
<cfsetting enablecfoutputonly="true">
<cfif structkeyexists(form,"DateFrom") and structkeyexists(form,"DateTo")>	
	<cfinvoke component="#variables.objequipmentGateway#" method="exportAllIftaTaxSummary" DateTo="#form.DateTo#" DateFrom="#form.DateFrom#" returnvariable="request.taxSummary" />	
	<cfif cgi.remote_addr EQ "202.88.237.237">
	
		<cfquery name="test" dbtype="query">
			select sum(TOTALMILES) as TOTALMILES, sum(NONTOLLMILES) as NONTOLLMILES, STATES,	sum(TOLLMILES) as TOLLMILES,	sum(TOTALWEIGHT) as TOTALWEIGHT, LOADEDMILES
			from request.taxSummary 
			group by TRUCK, STATES, LOADEDMILES
		</cfquery>
		<cfdump var="#test#">
		<cfdump var="#request.taxSummary#"><cfabort>
	</cfif>
	
	<cfset variables.columnList = request.taxSummary.getColumnNames()>
	<cfheader name="content-disposition" value="attachment; filename=IftaTaxSummmary.csv">
	<cfcontent type="text/csv"> 
	<cfoutput>IFTA Date Report,#form.DateFrom#,#form.DateTo#,#chr(10)##chr(10)#</cfoutput>
	<cfset variables.count=1>
	<cfoutput> 
		<cfloop array="#variables.columnList#" index="i">
			<cfif i neq 'TYPE' and i neq 'TOTALWEIGHT' and i neq 'loadnumber' >
			#i#
			</cfif>
			<cfif variables.count neq arraylen(variables.columnList)>, </cfif>
			<cfset variables.count++>
		</cfloop>
		#chr(10)#
	</cfoutput>
	<cfloop query="request.taxSummary">
		<cfoutput>
			<cfset variables.countColumns=1>
			<cfif request.taxSummary.TOTALWEIGHT EQ 0>
				<cfset request.taxSummary[ "EmptyMiles" ][ request.taxSummary.currentRow ] = javaCast("int", 0) />
			<cfelse>	
				<cfset request.taxSummary[ "LoadedMiles" ][ request.taxSummary.currentRow ] = javaCast("int", 0) />
			</cfif>
			<cfif request.taxSummary.Type NEQ 'FGP-IFTA'>
				<cfset request.taxSummary[ "FuelGallons" ][ request.taxSummary.currentRow ] = javaCast("int", 0) />
			</cfif>
			<cfif request.taxSummary.Type NEQ 'FGP-IFTA'>
				<cfset request.taxSummary[ "FuelCost" ][ request.taxSummary.currentRow ] = javaCast("int", 0) />
			</cfif>
			<cfloop array="#variables.columnList#" index="i">
				<cfset variables.values=Evaluate('request.taxSummary.'&#i#)>
				<cfif i neq 'TYPE' and i neq 'TOTALWEIGHT'and i neq 'loadnumber'>
				#variables.values#
				</cfif>
				<cfif variables.countColumns neq arraylen(variables.columnList)>, </cfif>
				<cfset variables.countColumns++>
			</cfloop>
			#chr(10)#
		</cfoutput>
	
	</cfloop>
</cfif>	


<cfabort>