<cfparam name="queryTable" default="">
<cfswitch expression="#url.fieldClass#">
	<cfcase value="typePickUpAddress">
		<cfset queryTable = 'LoadStopCargoPickupAddress'>
	</cfcase>
	<cfcase value="typeDeliveryddress">
		<cfset queryTable = 'LoadStopCargoDeliveryAddress'>
	</cfcase>
	<cfcase value="typeEmptyReturnAddress">
		<cfset queryTable = 'LoadStopEmptyReturnAddress'>
	</cfcase>
	<cfcase value="typeEmptyPickUpAddress">
		<cfset queryTable = 'LoadStopEmptyPickupAddress'>
	</cfcase>
	<cfcase value="typeLoadingAddress">
		<cfset queryTable = 'LoadStopLoadingAddress'>
	</cfcase>
	<cfcase value="typeReturnAddress">
		<cfset queryTable = 'LoadStopReturnAddress'>
	</cfcase>
</cfswitch>
<cfif queryTable NEQ "">
	<cfoutput>
		<cfquery name="qryLoadStopAddress" datasource="#Application.dsn#">
			SELECT *
			FROM #queryTable#
			where (ltrim(Address) like '#url.term#%') 
		</cfquery>
	</cfoutput>
	<cfoutput>
	[
		<cfset isFirstIteration='yes'>
		<cfloop query="qryLoadStopAddress">
			<cfif isFirstIteration EQ 'no'>,</cfif>
			<cfset isFirstIteration='no'>
				{
					"label": "#REReplace(replace(TRIM(qryLoadStopAddress.address),'"','&apos;','all'),'#chr(13)#|#chr(9)#|\n|\r','\n','ALL')#",
					"value": "#REReplace(replace(TRIM(qryLoadStopAddress.address),'"','&apos;','all'),'#chr(13)#|#chr(9)#|\n|\r','\n','ALL')#",
					"loadstopid" : "#replace(TRIM(qryLoadStopAddress.loadstopid),'"','&apos;','all')#"
				}
		</cfloop>
	]
	</cfoutput>
</cfif>






