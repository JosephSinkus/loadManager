<cfoutput>
	<cfset variables.Eflag=0>
	<cfset variables.Cflag=0>	
		<cfloop index="obj" list="#Application.userLoggedInCount#">
			<cfquery name="rstCurrentSiteEmployee" datasource="#application.dsn#">
				SELECT * 
				FROM Employees
				where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#obj#" />
			</cfquery>
			<cfif rstCurrentSiteEmployee.recordcount>
				<cfset variables.Eflag=1>				
			</cfif>
			<cfquery name="rstCurrentSiteCustomer" datasource="#application.dsn#">
				SELECT * 
				FROM customers
				where CustomerID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#obj#" />
			</cfquery>
			<cfif rstCurrentSiteCustomer.recordcount>
				<cfset variables.Cflag=1>	
			</cfif>
		</cfloop>

<cfif variables.Eflag>
	<br>
	Logged in Employees
	<br>
	<table cellpadding="2" cellspacing="2" border="1px solid" style="border: 1px solid blue;">
			<tr>
				<th>No</th>
				<th>Employee Username</th>
				<th>Employee Id</th>
			</tr>
			<cfset variables.count=0>
			<cfloop index="obj" list="#Application.userLoggedInCount#">
				<cfquery name="rstCurrentSiteUser" datasource="#application.dsn#">
					SELECT * 
					FROM Employees
					where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#obj#" />
				</cfquery>
				<cfif rstCurrentSiteUser.recordcount>
					<cfset variables.count++>
					<tr>
						<td> #variables.count#</td>
						<td> #rstCurrentSiteUser.Name#</td>
						<td> #rstCurrentSiteUser.EmployeeID#</td>
					</tr>
				</cfif>
			</cfloop>
	</table>	
	<br>
	Employees TotalCount: #variables.count#	
</cfif>
<cfif variables.Cflag>
		<br><br><br>
		Logged in Customers
	<br>
	<table cellpadding="2" cellspacing="2" border="1px solid" style="border: 1px solid blue;">
		<tr>
			<th>No</th>
			<th> Customer Username</th>
			<th> Customer Id</th>
		</tr>			
		<cfset variables.count1=0>
		<cfloop index="obj" list="#Application.userLoggedInCount#">
			<cfquery name="rstCurrentSiteUser" datasource="#application.dsn#">
				SELECT * 
				FROM customers
				where CustomerID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#obj#" />
			</cfquery>
			<cfif rstCurrentSiteUser.recordcount>
				<cfset variables.count1++>
				<tr>
					<td>#variables.count1# </td>
					<td> #rstCurrentSiteUser.CustomerName#</td>
					<td>#rstCurrentSiteUser.CustomerID# </td>
				</tr>
			</cfif>
		</cfloop>
	</table>
	<br>
	Customer TotalCount: #variables.count1#	
	<br>
</cfif>
	<br><br>
Note: Now logged in users.when a user logout then usercount will decrease.If the browser is being closed,then the user count will get decreased only after 2 hours.. 
</cfoutput>
