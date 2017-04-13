<cfoutput>
	<cfquery name="qrygetCarriersCommodity" datasource="#Application.dsn#">
		select commodityId,carrrate,CarrRateOfCustTotal from carrier_commodity where carrierId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.carrierid#">		
	</cfquery>
</cfoutput>

<cfoutput><cfset variables.index=1><cfloop query="qrygetCarriersCommodity">#qrygetCarriersCommodity.commodityId#,#qrygetCarriersCommodity.carrrate#,#qrygetCarriersCommodity.CarrRateOfCustTotal#<cfif variables.index neq qrygetCarriersCommodity.recordcount>,</cfif><cfset variables.index++></cfloop></cfoutput>






