<cfoutput>
	<cfquery name="qrygetCarriersCommodity" datasource="#Application.dsn#">
		select commodityId,carrrate,custTotal from carrier_commodity where carrierId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.carrierid#">		
	</cfquery>
</cfoutput>

<cfoutput>
[	<cfset variables.index=1 >
	<cfloop query="qrygetCarriersCommodity">
			{
				"commodity: "#qrygetCarriersCommodity.commodityId#",
				"carrrate" : "#qrygetCarriersCommodity.carrrate#",
				"location": "#qrygetCarriersCommodity.custTotal#"
			}
			<cfif variables.index neq  qrygetCarriersCommodity.recordcount>,</cfif>
			<cfset variables.index=variables.index+1 >
	</cfloop>
]
</cfoutput>






