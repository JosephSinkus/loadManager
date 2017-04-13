<!---cfinclude template="../webroot/Application.cfm"--->

<cfset dsn = "#Application.dsn#">

<cfsetting requestTimeOut = "24000">
<cfset groupBy = url.groupBy>
<cfset orderDateFrom = "">
<cfset orderDateTo = "">
<cfset billDateFrom = "">
<cfset billDateTo = "">

<cfif structKeyExists(url, "orderDateFrom") and len(url.orderDateFrom)>
	<cfset orderDateFrom = url.orderDateFrom>
</cfif>
<cfif structKeyExists(url, "orderDateTo") and len(url.orderDateTo)>
	<cfset orderDateTo = url.orderDateTo>
</cfif>
<cfif structKeyExists(url, "billDateFrom") and len(url.billDateFrom)>
	<cfset billDateFrom = url.billDateFrom>
</cfif>
<cfif structKeyExists(url, "billDateTo") and len(url.billDateTo)>
	<cfset billDateTo = url.billDateTo>
</cfif>

<cfset datetype = url.datetype>
<cfset salesRepFrom = url.salesRepFrom>
<cfset salesRepFromForQuery = url.salesRepFrom>
<cfset salesRepTo = url.salesRepTo>
<cfset salesRepToForQuery = url.salesRepTo>
<cfset dispatcherFrom = url.dispatcherFrom>
<cfset dispatcherFromForQuery = url.dispatcherFrom>
<cfset dispatcherTo = url.dispatcherTo>
<cfset dispatcherToForQuery = url.dispatcherTo>
<cfset customerFrom = url.customerLimitFrom>
<cfset customerFromForQuery = url.customerLimitFrom>
<cfset customerTo = url.customerLimitTo>
<cfset customerToForQuery = url.customerLimitTo>
<cfset marginRangeFrom = url.marginRangeFrom>
<cfset marginRangeTo = url.marginRangeTo>
<cfset deductionPercentage = url.deductionPercentage>
<cfset commissionPercentage = url.commissionPercentage>
<cfset reportType = url.reportType>
<cfset statusTo = url.statusTo>
<cfset statusFrom = url.statusFrom>
<cfset equipmentFrom = url.equipmentFrom>
<cfset equipmentFromForQuery = url.equipmentFrom>
<cfset equipmentTo= url.equipmentTo>
<cfset equipmentToForQuery= url.equipmentTo>
<cfset freightBroker= url.freightBroker>

<cfif structKeyExists(url, "ShowSummaryStatus")>
	<cfif url.ShowSummaryStatus eq 1>
		<cfset variables.ShowSummaryStatus=1>
	<cfelse>
		<cfset variables.ShowSummaryStatus=0>	
	</cfif>	
</cfif>	

<cfif structKeyExists(url, "ShowProfit")>
	<cfif url.ShowProfit eq 1>
		<cfset variables.ShowProfit=1>
	<cfelse>
		<cfset variables.ShowProfit=0>	
	</cfif>	
</cfif>	

<cfif freightBroker eq 'Driver'>
	<cfif salesRepFrom eq "">
		<cfset salesRepFrom = "########">
	    <cfset salesRepFromForQuery = "(BLANK)">
	</cfif>
	<cfif salesRepTo eq "">
		<cfset salesRepTo = "########">
	    <cfset salesRepToForQuery = "(BLANK)">
	</cfif>
<cfelse>
	<cfif salesRepFrom eq "AAAA">
		<cfset salesRepFrom = "########">
	    <cfset salesRepFromForQuery = "(BLANK)">
	</cfif>
	<cfif salesRepTo eq "AAAA">
		<cfset salesRepTo = "########">
	    <cfset salesRepToForQuery = "(BLANK)">
	</cfif>
</cfif>	

<cfif dispatcherFrom eq "AAAA">
	<cfset dispatcherFrom = "########">
    <cfset dispatcherFromForQuery = "">
</cfif>

<cfif dispatcherTo eq "AAAA">
	<cfset dispatcherTo = "########">
    <cfset dispatcherToForQuery = "">
</cfif>

<cfif customerFrom eq "AAAA">
	<cfset customerFrom = "########">
    <cfset customerFromForQuery = "(BLANK)">
</cfif>

<cfif customerTo eq "AAAA">
	<cfset customerTo = "########">
    <cfset customerToForQuery = "(BLANK)">
</cfif>

<cfif equipmentFrom eq "AAAA">
	<cfset equipmentFrom = "########">
    <cfset equipmentFromForQuery = "(BLANK)">
</cfif>

<cfif equipmentTo eq "AAAA">
	<cfset equipmentTo = "########">
    <cfset equipmentToForQuery = "(BLANK)">
</cfif>

<cfif groupBy eq "salesAgent">
	<cfset groupBy = "Sales Agent">
	<cfset groupsBy = "SALESAGENT">
<cfelseif groupBy eq "Driver">	
	<cfset groupBy = "Driver">
	<cfset groupsBy = "Driver">
<cfelseif groupBy eq "userDefinedFieldTrucking">	
	<cfset groupBy = "userDefinedFieldTrucking">
	<cfset groupsBy = "userDefinedFieldTrucking">	
<cfelseif groupBy eq "Carrier">	
	<cfset groupBy = "Carrier">
	<cfset groupsBy = "Carrier">	
<cfelseif groupBy eq "CustName">	
	<cfset groupBy = "CustName">
	<cfset groupsBy = "CUSTOMERNAME">		
<cfelseif  groupBy eq 'dispatcher'>
	<cfset groupBy = "Dispatcher">
	<cfset groupsBy = "DISPATCHER">
<cfelse>
	<cfset groupBy = "none">
	<cfset groupsBy = "none">
</cfif>

<cfstoredproc procedure="USP_GetLoadsForCommissionReport" datasource="#dsn#">
	<cfprocparam value="#datetype#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#orderDateFrom#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#orderDateTo#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#billDateFrom#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#billDateTo#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#groupsBy#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#groupBy#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#salesRepFromForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#salesRepToForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#dispatcherFromForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#dispatcherToForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#statusTo#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#statusFrom#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#deductionPercentage#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#equipmentFromForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#equipmentToForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#customerFromForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#customerToForQuery#" cfsqltype="cf_sql_varchar">
	<cfprocparam value="#freightBroker#" cfsqltype="cf_sql_varchar">
	<cfprocresult name="qCommissionReportLoads">
</cfstoredproc>

<cfif structKeyExists(url, "customerStatus")>
	<cfif url.customerStatus eq 1>
		<cfif structKeyExists(url, "pageBreakStatus")>
			<cfif url.pageBreakStatus eq 1>
				<cfset tempRootPath = expandPath("../reports/loadCommissionReportPageBreak.cfr")>
			<cfelse>
				<cfset tempRootPath = expandPath("../reports/loadCommissionReport.cfr")>
			</cfif>
		</cfif>		
	<cfelse>
		<!--- Show Customer Info,--->
		<cfif structKeyExists(url, "pageBreakStatus")>
			<cfif url.pageBreakStatus eq 1>
            
            	<cfif url.GroupBy eq "Carrier">
                	<cfset tempRootPath = expandPath("../reports/loadCommissionReportSCIPageBreakCarrierPay.cfr")>
                <cfelse>
					<cfset tempRootPath = expandPath("../reports/loadCommissionReportSCIPageBreak.cfr")>
				</cfif>
            
			<cfelse>
				<cfset tempRootPath = expandPath("../reports/loadCommissionReportSCI.cfr")> 
			</cfif>
		</cfif>	
	</cfif>	
</cfif>	

<cfoutput>
	<cftry>
		<cfreport format="pdf" template="#tempRootPath#" query="#qCommissionReportLoads#">
			<cfreportParam name="ReportType" value="#reportType#">
			<cfreportParam name="orderDateFrom" value="#orderDateFrom#">
			<cfreportParam name="orderDateTo" value="#orderDateTo#">
			<cfreportParam name="billDateFrom" value="#billDateFrom#">
			<cfreportParam name="billDateTo" value="#billDateTo#">
			<cfreportParam name="salesRepFrom" value="#salesRepFrom#">
			<cfreportParam name="salesRepTo" value="#salesRepTo#">
			<cfreportParam name="dispatcherFrom" value="#dispatcherFrom#">
			<cfreportParam name="dispatcherTo" value="#dispatcherTo#">
			<cfreportParam name="customerFrom" value="#customerFrom#">
			<cfreportParam name="customerTo" value="#customerTo#">
			<cfreportParam name="marginRangeFrom" value="#marginRangeFrom#">
			<cfreportParam name="marginRangeTo" value="#marginRangeTo#">
			<cfreportParam name="paramgroupBy" value="#groupsBy#">
			<cfreportParam name="deductionPercentage" value="#deductionPercentage#">
			<cfreportParam name="equipmentFrom" value="#equipmentFrom#">
			<cfreportParam name="equipmentTo" value="#equipmentTo#">
			<cfreportParam name="freightBroker" value="#freightBroker#">
			<cfreportParam name="ShowSummaryStatus" value="#variables.ShowSummaryStatus#">
			<cfreportParam name="ShowProfit" value="#variables.ShowProfit#">
		</cfreport>
	<cfcatch>
		<cfdump var="#cfcatch#" abort="true">
		Sorry! Unexpected error occurred. Please try again later.
	</cfcatch> 
	</cftry>
</cfoutput> 
