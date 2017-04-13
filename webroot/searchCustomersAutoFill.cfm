<cfsilent>
	<cfquery name="qMatchingCustomers" datasource="#Application.dsn#">
		SELECT * FROM Customers
		WHERE CustomerName LIKE <cfqueryparam value="#url.term#%" cfsqltype="cf_sql_varchar">
		<cfif url.queryType EQ 'getCustomers'>
			AND IsPayer = <cfqueryparam value="true" cfsqltype="cf_sql_bit">
		</cfif>		
		<cfif StructKeyExists(session,"currentusertype") AND session.currentusertype EQ "Sales Representative">
			AND officeid = <cfqueryparam value="#session.officeid#">
		</cfif>
		ORDER BY CustomerName,Zipcode,Location
	</cfquery>	
	<cfquery name="GetCitySelected" datasource="#Application.dsn#">
		select *
		from postalcode		
		<cfif url.queryType EQ 'GetCity'>
				where City LIKE <cfqueryparam value="#url.term#%" cfsqltype="cf_sql_varchar">		
				ORDER BY City
		<cfelseif url.queryType EQ 'GetZip'>
				where PostalCode LIKE <cfqueryparam value="#url.term#%" cfsqltype="cf_sql_varchar">
				ORDER BY PostalCode	
		</cfif>
	</cfquery>
</cfsilent>
<!---<cfoutput>
[
	<cfset isFirstIteration='yes'>
	<cfloop query="qMatchingCustomers">
		<cfif isFirstIteration EQ 'no'>,</cfif>
		<cfset isFirstIteration='no'>
		
		
		<cfif url.queryType EQ 'getCustomers'>
			{
				"name" : "#qMatchingCustomers.CustomerName#",
				"city" : "#qMatchingCustomers.City#",
				"state": "#qMatchingCustomers.StateCode#",
				"zip": "#qMatchingCustomers.zipCode#",
				"value": "#qMatchingCustomers.CustomerID#",
				"location": "#qMatchingCustomers.location#",
				"contactPerson": "#qMatchingCustomers.contactPerson#",
				"phoneNo": "#qMatchingCustomers.phoneNo#",
				"fax": "#qMatchingCustomers.fax#",
				"email": "#qMatchingCustomers.email#",
				"creditLimit": "#qMatchingCustomers.creditLimit#",
				"balance": "#qMatchingCustomers.balance#",
				"available": "#qMatchingCustomers.available#",
				"notes": "#qMatchingCustomers.CustomerNotes#",
				"dispatchNotes": "#qMatchingCustomers.CustomerDirections#",
				"dispatcher": "#qMatchingCustomers.AcctMGRID#",
				"salesRep": "#qMatchingCustomers.SalesRepID#"
			}
		<cfelse>
			{
				"name" : "#qMatchingCustomers.CustomerName#",
				"city" : "#qMatchingCustomers.City#",
				"state": "#qMatchingCustomers.StateCode#",
				"value": "#qMatchingCustomers.CustomerID#",
				"location": "#qMatchingCustomers.location#",
				"zip": "#qMatchingCustomers.Zipcode#",
				"contactPerson": "#qMatchingCustomers.contactPerson#",
				"phoneNo": "#qMatchingCustomers.phoneNo#",
				"fax": "#qMatchingCustomers.fax#",
				"email": "#qMatchingCustomers.email#"
			}
		</cfif>
	</cfloop>
	
]
</cfoutput>--->




	<cfset thisArrayBecomesJSON = [] />
	
		<cfif url.queryType EQ 'getCustomers'>
			<cfloop query="qMatchingCustomers">
			{
				<cfset thisEvent = {
				"label" = "#qMatchingCustomers.CustomerName#",
				"name" = "#qMatchingCustomers.CustomerName#",
				"city" = "#qMatchingCustomers.City#",
				"state"= "#qMatchingCustomers.StateCode#",
				"zip" = "#qMatchingCustomers.zipCode#",
				"value" = "#qMatchingCustomers.CustomerID#",
				"location" = "#qMatchingCustomers.location#",
				"contactPerson" = "#qMatchingCustomers.contactPerson#",
				"phoneNo" = "#qMatchingCustomers.phoneNo#",
				"cellNo" = "#qMatchingCustomers.personMobileNo#",
				"fax" = "#qMatchingCustomers.fax#",
				"email" = "#qMatchingCustomers.email#",
				"creditLimit" = "#qMatchingCustomers.creditLimit#",
				"balance" = "#qMatchingCustomers.balance#",
				"available" = "#qMatchingCustomers.available#",
				"notes" = "#qMatchingCustomers.CustomerNotes#",
				"dispatchNotes" = "#qMatchingCustomers.CustomerDirections#",
				"dispatcher" = "#qMatchingCustomers.AcctMGRID#",
				"salesRep" = "#qMatchingCustomers.SalesRepID#",
				"isPayer" = "#qMatchingCustomers.IsPayer#",
				"CarrierNotes" = "#qMatchingCustomers.CarrierNotes#"
				} />
			}
			<cfset arrayAppend( thisArrayBecomesJSON, thisEvent ) />
			</cfloop>
		<cfelseif url.queryType EQ 'getCity'>
			<cfloop query="GetCitySelected">
				<cfset thisEvent = {"city" = "#GetCitySelected.City#","state" = "#GetCitySelected.StateCode#","zip" = "#GetCitySelected.PostalCode#"} />
			<cfset arrayAppend( thisArrayBecomesJSON, thisEvent ) />
			</cfloop>
		<cfelseif url.queryType EQ 'GetZip'>
			<cfloop query="GetCitySelected">
				<cfset thisEvent = {"zip" = "#GetCitySelected.PostalCode#","city" = "#GetCitySelected.City#","state" = "#GetCitySelected.StateCode#"} />
			<cfset arrayAppend( thisArrayBecomesJSON, thisEvent ) />
			</cfloop>
		<cfelse>
			<cfloop query="qMatchingCustomers">
			{
				<cfset thisEvent = {
				"label" = "#qMatchingCustomers.CustomerName#",
				"name" = "#qMatchingCustomers.CustomerName#",
				"city" = "#qMatchingCustomers.City#",
				"state" = "#qMatchingCustomers.StateCode#",
				"value" = "#qMatchingCustomers.CustomerID#",
				"location" = "#qMatchingCustomers.location#",
				"zip" = "#qMatchingCustomers.Zipcode#",
				"contactPerson" = "#qMatchingCustomers.contactPerson#",
				"phoneNo" = "#qMatchingCustomers.phoneNo#",
				"fax" = "#qMatchingCustomers.fax#",
				"email" = "#qMatchingCustomers.email#",
				"isPayer" = "#qMatchingCustomers.IsPayer#"
				} />
			}
			<cfset arrayAppend( thisArrayBecomesJSON, thisEvent ) />
			</cfloop>
		</cfif>
		
	
<cfset myJSON = serializeJSON( thisArrayBecomesJSON ) />
<cfoutput>#myJSON#</cfoutput>