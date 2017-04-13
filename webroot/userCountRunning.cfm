<cfif structkeyexists (session,"empid") and structkeyexists(session, "passport")>			
			<cfif Session.empid neq "">		
				<cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
					select cutomerId,currenttime
					from userLoggedInCount
					where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
				</cfquery>
				<cfquery name="qrygetusername" datasource="#Application.dsn#">
					select Name from employees where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
				</cfquery>
				<cfif qGetUserLoggedInCount.recordcount>
					<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
						update userLoggedInCount
						set 
							currenttime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
							ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							username= <cfqueryparam cfsqltype="cf_sql_varchar" value="#qrygetusername.Name#">,
							isactive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
						where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
					</cfquery>
				<cfelse>
					
						<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
							insert into userLoggedInCount(cutomerId,currenttime,isactive,ipAddress,username)
							VALUES(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#qrygetusername.Name#">
							) 
						</cfquery>
					
				</cfif>				
			</cfif>	
		</cfif>
		<cfif structkeyexists (session,"customerid") and structkeyexists(session, "passport")>
			<cfif Session.customerid neq "">	
				<cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
					select cutomerId,currenttime,ipAddress 
					from userLoggedInCount
					where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">
				</cfquery>
				<cfquery name="qrygetusername" datasource="#Application.dsn#">
					select Name from employees where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
				</cfquery>
				<cfif qGetUserLoggedInCount.recordcount>
					<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
						update userLoggedInCount
						set 
							currenttime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
							ipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							username= <cfqueryparam cfsqltype="cf_sql_varchar" value="#qrygetusername.Name#">,
							isactive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
						where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">
					</cfquery>
				<cfelse>
					<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
						insert into userLoggedInCount(cutomerId,currenttime,isactive,ipAddress,username)
						VALUES(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="1">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#qrygetusername.Name#">
						) 
					</cfquery>
				</cfif>
			</cfif>	
		</cfif>	
		<cfquery name="qusercount" datasource="#Application.dsn#">
			select count(*) as count from userLoggedInCount
			where isactive=1
		</cfquery>
		<cfquery name="qUpdateUserCount" datasource="#Application.dsn#">
			update Employees set 
			userCount=<cfqueryparam cfsqltype="cf_sql_integer" value="#val(qusercount.count)#">
		</cfquery>
<cfcontent
    type="text/plain"
    variable="#ToBinary( ToBase64( 'true' ) )#"
    />
