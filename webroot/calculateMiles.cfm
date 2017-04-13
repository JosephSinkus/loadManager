<!---url:/calculateMiles.cfm?origin=Denver,%20CO,%20USA&destination=New%20York,%20na,%20USA&avoid=tolls--->
<cfoutput>
	<cfif structkeyexists(url,"origin") and structkeyexists(url,"destination")>
		<cfset variables.originvalues=#url.origin#>
		<cfset variables.destinationValues=#url.destination#>
		<cfif structkeyexists(url,"avoid")>
			<cfset variables.avoid = "&avoid=#url.avoid#">
		<cfelse>
			<cfset variables.avoid = "">
		</cfif>
		<cfset variables.url = "https://maps.googleapis.com/maps/api/directions/json?origin=#variables.originvalues#&destination=#variables.destinationValues##variables.avoid#">
		<cfhttp url="#variables.url#" method="get"/>
		<cfset variables.filecontent=#DeserializeJSON(cfhttp.filecontent.toString())#>
		<cfdump var="#variables.filecontent#">
		<cfif variables.filecontent.status neq "NOT_FOUND">	
			<cfset arraylength=arraylen(variables.filecontent.routes[1].legs[1].steps)>
			<cfset total=''>
			<cfset totalNonMiles=''>
			<cfset milevalue=1>
			<cfloop index="name" from="1" to="#arraylength#">
				<cfset  variables.tollvalue = variables.filecontent.routes[1].legs[1].steps[name].html_instructions >
				<cfif findnocase("toll road",variables.tollvalue)>
					<cfset  variables.calvalue = variables.filecontent.routes[1].legs[1].steps[name].distance.text >
					<cfif findnocase("ft",variables.calvalue)>
						<cfset feetValue=replace(variables.calvalue," ft","","all")>
						<cfset variables.calvalue=feetValue * 0.00018939>
					</cfif>
					<cfset variables.calvalue=replace(variables.calvalue," mi","","all")>
					<cfset totalNonMiles=listappend(totalNonMiles,variables.calvalue)>
				<cfelse>
					<cfset  variables.nonToll = variables.filecontent.routes[1].legs[1].steps[name].distance.text >
					<cfif findnocase("ft",variables.nonToll)>
						<cfset feetValue=replace(variables.nonToll," ft","","all")>
						<cfset variables.nonToll=feetValue * 0.000189394>
					</cfif>
					<cfset variables.nonToll=replace(variables.nonToll," mi","","all")>
					<cfset total=listappend(total,variables.nonToll)>
					</cfif>
			</cfloop>
			<cfset arrayValuesOfMiles=listtoarray(totalNonMiles)>
			<cfset tollMilestotal=ArraySum(arrayValuesOfMiles)>
			<cfset arrayValuesOfMiles=listtoarray(total)>
			<cfset nonTollMiles=ArraySum(arrayValuesOfMiles)>
			<cfset totalMiles=0>
			<cfset totalMiles=tollMilestotal+nonTollMiles>
			<table cellpadding="2" cellspacing="2"  border="1px solid">
				<tr>
					<th>Toll Miles</th>
					<th>Non-toll Miles</th>
					<th>Total Miles</th>
				</tr>
				<tr>
					<td>#tollMilestotal#mi</td>
					<td>#nonTollMiles#mi</td>
					<td>#totalMiles#mi</td>
				</tr>
			</table>
		<cfelse>
			Please enter valid origin and destination
		</cfif>
	<cfelse>
		You must pass the parameters origin and destination into the URL
	</cfif>
</cfoutput>