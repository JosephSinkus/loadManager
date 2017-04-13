<cfcomponent>
	<cfscript>
		variables.dsn = "";
		variables.pwdExpiryDays = 60;
	</cfscript>
	
	<!--- INIT FUNCTION TO INITIALIZE VARIABLES --->
	<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="yes" />
		<cfargument name="pwdExpiryDays" type="numeric" required="yes" />
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.pwdExpiryDays = arguments.pwdExpiryDays />
    </cffunction>
    
    
	<!--- Function used to fetch a user from their username and password --->
	<cffunction name="checkLogin" access="public" output="false" returntype="query">
		<cfargument name="strUsername" required="yes" type="string" />
		<cfargument name="strPassword" required="yes" type="string" />
		
		<cfset var rstCurrentSiteUser = "" />
		
		<!--- RUN QUERY TO FETCH THE USER FROM THE DATABASE [2 new fields have been added allowed_users and current_count- Furqan] --->
	
    	<cfquery name="rstCurrentSiteUser" datasource="#variables.dsn#">
			SELECT pkiadminUserID, FirstName, LastName, UserName, EmailAddress, bEnabled, dtCreated, dtUpdated
			FROM fa_AdminUsers
			WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strUsername#" />
			  AND password =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strPassword#" />
			  AND benabled = 'True'
		</cfquery>
		
		<cfif rstCurrentSiteUser.recordcount>
            <cfset session.officeid="">
            <cfset session.EmpId="">
			<cfreturn rstCurrentSiteUser />
		<cfelse>
			<cfquery name="rstCurrentSiteUserFirst" datasource="#variables.dsn#">
				SELECT EmployeeID as pkiadminUserID, name as FirstName, name as LastName,loginid as UserName,emailid as EmailAddress,isActive as bEnabled,createdDateTime as dtCreated,LastModifiedDatetime as dtUpdated, isnull(current_count,0) as current_count , officeId
				FROM Employees
				WHERE loginId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strUsername#" />
				AND password =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strPassword#" />
				AND isActive = 1
			</cfquery>
			<cfquery name="qryUserCount" datasource="#variables.dsn#">
				SELECT allowed_users,usercount
				FROM SystemConfig
				where SystemConfig.allowed_users >= SystemConfig.usercount
			</cfquery>
			<cfset rstCurrentSiteUser = QueryNew("pkiadminUserID, LastName, UserName,EmailAddress,bEnabled,dtCreated,dtUpdated,officeId,allowed_users,usercount", "VarChar, VarChar, VarChar,VarChar,bit,date,date,VarChar,integer,integer")>
			<cfif rstCurrentSiteUserFirst.recordcount and qryUserCount.recordcount>
				<!--- Make one rows in the query ---> 
				<cfset QueryAddRow(rstCurrentSiteUser, 1)> 
				<!--- Set the values of the cells in the query ---> 
				<cfset QuerySetCell(rstCurrentSiteUser, "pkiadminUserID", "#rstCurrentSiteUserFirst.pkiadminUserID#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "LastName", "#rstCurrentSiteUserFirst.LastName#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "UserName", "#rstCurrentSiteUserFirst.UserName#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "EmailAddress", "#rstCurrentSiteUserFirst.EmailAddress#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "bEnabled", "#rstCurrentSiteUserFirst.bEnabled#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "dtCreated", "#rstCurrentSiteUserFirst.dtCreated#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "dtUpdated", "#rstCurrentSiteUserFirst.dtUpdated#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "officeId", "#rstCurrentSiteUserFirst.officeId#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "allowed_users", "#qryUserCount.allowed_users#", 1)> 
				<cfset QuerySetCell(rstCurrentSiteUser, "usercount", "#qryUserCount.usercount#", 1)> 
				
				<cfset session.allowed_users ="#rstCurrentSiteUser.allowed_users#" />
				<!---cfset currentC = #rstCurrentSiteUser.current_count# --->
				<cfset variables.userloggegInCount=listlen(Application.userLoggedInCount)+1>
				<!--- <cfquery name="update" datasource="#variables.dsn#">
					UPDATE SystemConfig
					set
					userCount =  <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.userloggegInCount#" />
				</cfquery> --->
				<cfif rstCurrentSiteUser.allowed_users Gte rstCurrentSiteUser.userCount>
					<cfset userip = #REMOTE_ADDR#>
					<cfset session.userip = #userip#>
					<cfset todayDate = #Now()#> 
					<cfset logindate = #DateFormat(todayDate, "yyyy-mm-dd")# >
					<cfset logintime = #TimeFormat(todayDate, "HH")#>
					<!---cfquery name="editu" datasource="#variables.dsn#" result="e">
						UPDATE Employees
						set
						current_count = #++currentC#
						WHERE EmployeeID='#rstCurrentSiteUser.pkiadminUserID#'
					</cfquery--->
					
					<cfset userpin = #Rand("SHA1PRNG")#>
					<cfset session.userpin = #userpin#>
					<cfquery name="addtracking" datasource="#variables.dsn#" result="t">
						Insert into User_Track
						(user_id,ip,dated,timing,userpin,status)
						Values
						('#rstCurrentSiteUser.pkiadminUserID#','#userip#','#logindate#','#logintime#','#userpin#','active')
					 </cfquery>
				</cfif>
				<!---My Code Ends here--->
				<!---Code That Put inactive users counter down and change their status to inactive from active--->
				<cfset todayDate = #Now()#> 
				<cfset logindate = #DateFormat(todayDate, "yyyy-mm-dd")# >
				<cfset logintime = #TimeFormat(todayDate, "HH")#>
				<cfquery name="chkusers" datasource="#variables.dsn#" result="c">
					SELECT User_Track.user_id, User_Track.track_id, User_Track.ip, User_Track.dated, User_Track.timing
					FROM User_Track
					WHERE User_Track.dated = '#logindate#' AND User_Track.timing ! = #logintime# And User_Track.status = 'active'
				</cfquery>
				<cfif chkusers.recordcount>
					<cfquery name="getrow" datasource="#variables.dsn#" result="e">
						SELECT	Employees.current_count
						FROM Employees
						WHERE Employees.EmployeeID = '#chkusers.user_id#'
					</cfquery>
					<cfset usercount = #getrow.current_count#>
					<cfloop query="chkusers">
						<cfquery name="getrow" datasource="#variables.dsn#" result="e">
							SELECT	Employees.current_count
							FROM Employees
							WHERE Employees.EmployeeID = '#chkusers.user_id#'
						</cfquery>
						<cfset usercount = #getrow.current_count#>
						<cfquery name="editstatus" datasource="#variables.dsn#" result="e">
							UPDATE	Employees
							set 
							Employees.current_count = #--usercount#
							WHERE Employees.EmployeeID = '#chkusers.user_id#'
						</cfquery>
						<cfquery name="editstatus2" datasource="#variables.dsn#" result="e">
							UPDATE	User_Track
							set 
							User_Track.status = 'inactive'
							WHERE User_Track.track_id = #chkusers.track_id#
						</cfquery>
					</cfloop>
                <cfelse>
               		 no record to update.
				</cfif>
				<!---Status Code Ends Here--->
				<cfset session.officeid= rstCurrentSiteUserFirst.officeid>
				<cfset session.EmpId= rstCurrentSiteUserFirst.pkiadminUserID>
			<cfelse>
				<!---Additional code added by Furqan for displaying limit over message--->
				<cfif structkeyexists(Session,"empid") and len(trim(Session.empid))>
					<cfset listPos = ListFindNoCase(Application.userLoggedInCount, Session.empid)>
					<cfif listPos>
						<cfset Application.userLoggedInCount = ListDeleteAt(Application.userLoggedInCount, listPos)>
						<cfquery name="update" datasource="#Application.dsn#">
							UPDATE SystemConfig
							set
							userCount =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(Application.userLoggedInCount)#" />
						</cfquery>
					</cfif>		
				</cfif>
				<cfif structkeyexists(Session,"customerid") and len(trim(Session.customerid))>	
					<cfset listPos = ListFindNoCase(Application.userLoggedInCount, Session.customerid)>
					<cfif listPos>
						<cfset Application.userLoggedInCount = ListDeleteAt(Application.userLoggedInCount, listPos)>
						<cfquery name="update" datasource="#Application.dsn#">
							UPDATE SystemConfig
							set
							userCount =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(Application.userLoggedInCount)#" />
						</cfquery>
					</cfif>
				</cfif>	
				<!--- <cfset structDelete(session, "limitover")> --->
				<!--- <cfquery name="qryUserCountCalculate" datasource="#variables.dsn#">
					SELECT allowed_users,usercount
					FROM SystemConfig
				</cfquery>
				<cfif rstCurrentSiteUserFirst.recordcount and qryUserCountCalculate.userCount gte qryUserCountCalculate.allowed_users>
						<cfset session.limitover = 1>
				 <cfelse>
						<cfset session.limitover = ''>
				 </cfif>
				 <cfif session.limitover eq 1>
					<cfquery name="qryGetEmployeeId" datasource="#variables.dsn#" >
						SELECT EmployeeID, Name
						FROM Employees
						WHERE loginId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strUsername#" />
						AND password =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strPassword#" />
						AND isActive = 1
					</cfquery>
					<cfif qryGetEmployeeId.recordcount>
						<cfquery name="qryInsertExceedList" datasource="#variables.dsn#">
							Insert into UserExceededList
							(UserId,UserName,DateCreated)
							Values
							(<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetEmployeeId.EmployeeID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetEmployeeId.Name#" />,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
							)
						 </cfquery>
					</cfif>	 
				 </cfif> --->
				<!---limit over code ends here--->   
				<cfset session.officeid="">
			</cfif>
			<cfreturn rstCurrentSiteUser />
		</cfif>
	</cffunction>

	<!--- Function used to fetch a user from their username and password --->
	<cffunction name="checkCustomerLogin" access="public" output="false" returntype="query">
		<cfargument name="strUsername" required="yes" type="string" />
		<cfargument name="strPassword" required="yes" type="string" />
		
		<cfset var rstCurrentSiteUser = "" />
		
		<!--- RUN QUERY TO FETCH THE USER FROM THE DATABASE [2 new fields have been added allowed_users and current_count- Furqan] --->

    	<cfquery name="rstCurrentSiteUser" datasource="#variables.dsn#">
			SELECT CustomerID as pkiadminUserID, CustomerName as FirstName, CustomerName as LastName, UserName, Email as EmailAddress, 1 as bEnabled, createdDateTime as dtCreated, LastModifiedDateTime as dtUpdated
			FROM Customers
			WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strUsername#" />
			  AND password =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strPassword#" />
			  AND isPayer = 1
		</cfquery>

		<cfif rstCurrentSiteUser.recordcount>
            <cfset session.officeid="">
            <cfset session.EmpId="">
            <cfset session.isCustomer=1>
            <cfset session.CustomerID = rstCurrentSiteUser.pkiadminUserID>
		<cfelse>
			<cfset session.isCustomer="">
			<cfset session.CustomerID = "">
		</cfif>
		<cfreturn rstCurrentSiteUser />
	</cffunction>
    
	<cffunction name="UserLoginLog" access="public" output="false" returntype="void">
		<cfargument name="strUsername" type="string" />
		<cfargument name="strPassword" type="string" />
		<cfargument name="rstCurrentSiteUser" required="yes"/>
		<cfif (rstCurrentSiteUser.RecordCount GT 0)>
			<cfset variables.LoginSuccess = 1>
		<cfelse>
			<cfset variables.LoginSuccess = 0>
		</cfif>		
		<cfset DateLogged = Now()>
		<cfif structkeyexists(session,"EmpId") AND session.EmpId NEQ "">
			<cfquery name="newq1" datasource="#variables.dsn#">
				SELECT NAME
				from Employees
				WHERE EmployeeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.EmpId#">
			</cfquery>
			<cfif newq1.recordcount>
				<cfset variables.employeename = newq1.NAME>
			<cfelse>
				<cfset variables.employeename = "">
			</cfif>
		</cfif>
		<cfquery name="qCompanyInfo" datasource="#variables.dsn#">
			select top 1 companyID, companyName from companies
		</cfquery>
		
		<cfif IsDefined("cookie.uniqueid")>
			<cfset variables.uniqueId = cookie.uniqueid >
		<cfelse>
			<cfset variables.uniqueId = createuuid() >
			<cfcookie expires="never" name="uniqueid" value="#variables.uniqueId#" >			
		</cfif>
		<cfquery name="addLoginLog" datasource="LoadManagerAdmin">
			Insert into UserLoginLog
			(
				LoginSuccess, UserNameEntered, UserPasswordEntered,DateLogged
				<cfif structkeyexists(session,"EmpId") AND session.EmpId NEQ "">
					,EmployeeID ,EmployeeName
				</cfif>
				<cfif structkeyexists(session,"userip") AND session.userip NEQ "">
					,PublicIP
				</cfif>
				, CompanyID, CompanyName,localip
				<!---, LocalIP, ComputerName, UserName, UserDomain--->
			)
			Values
			(
				<cfqueryparam cfsqltype="cf_sql_bit" value="#variables.LoginSuccess#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strUsername#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strPassword#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateLogged#">
				<cfif structkeyexists(session,"EmpId") AND session.EmpId NEQ "">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.EmpId#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.employeename#">
				</cfif>
				<cfif structkeyexists(session,"userip") AND session.userip NEQ "">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.userip#">
				</cfif>
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#qCompanyInfo.companyID#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#qCompanyInfo.companyName#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.uniqueId#">
			)
		</cfquery>
	</cffunction>
	
	<!---LOGOUT CODE ADDED BY FURQAN--->
    <cffunction name="logoutuser" access="public" output="false">
    
	   <!---Logout Code added for managing allowed user by Furqan--->
	        
	    <cfset todayDate = #Now()#> 
		<cfset logindate = #DateFormat(todayDate, "yyyy-mm-dd")# >
	   	<cfif structKeyExists(session, "EmpId") AND session.EmpId NEQ "">
	   		<cfquery name="newq1" datasource="#variables.dsn#" result="q">
			SELECT Employees.EmployeeID, Employees.current_count, Employees.allowed_users
			from Employees
			WHERE Employees.EmployeeID = '#session.EmpId#'
			</cfquery>
			
			<cfset currentC = #newq1.current_count# >
			<cfquery name="editu" datasource="#variables.dsn#" result="e">
				UPDATE employees
				set
				employees.current_count = #--currentC#
				WHERE employees.employeeid = '#session.EmpId#'
			</cfquery>
		
		    
		  	<cfquery name="tupdate" datasource="#variables.dsn#">
		    UPDATE User_Track
		    set User_Track.status = 'inactive' 
		    WHERE User_Track.user_id= '#session.EmpId#' AND User_Track.ip= '#session.userip#' AND User_Track.dated= '#logindate#' AND User_Track.userpin= '#session.userpin#'
			</cfquery>
	   	</cfif>
    
        
        <!---Code Ended by Furqan--->
		<cfreturn logoutuser />
	</cffunction>
    
    <!---LOGOUT CODE ENDED--->
    
    
     <!---Time Stamping User CODE ADDED BY FURQAN--->
    <cffunction name="timeuser" access="public">
    
   <!---Time Stamp Code added for managing allowed user by Furqan--->
        <cfset todayDate = #Now()#> 
		<cfset logindate = #DateFormat(todayDate, "yyyy-mm-dd")# >
        <cfif isdefined ("session.EmpId") AND isdefined ("session.userip")>
        
        <cfquery name="timeupdate" datasource="#variables.dsn#">
            UPDATE User_Track
            set User_Track.timing = '#TimeFormat(todayDate, "HH")#' 
            WHERE User_Track.user_id= '#session.EmpId#' AND User_Track.ip= '#session.userip#' AND User_Track.dated= '#logindate#' AND User_Track.userpin= '#session.userpin#' AND User_Track.status= 'active'
        </cfquery>
        </cfif>   
          <!---<cfdump var="#timeupdate#">
          <cfabort>--->
        
        <!---Code Ended by Furqan--->
		<cfreturn timeuser />
	</cffunction>
    
    <!---User Time Check CODE ENDED--->
    
      <!--- ADDED BY FURQAN--->
    <cffunction name="UserTimeCheck" access="public">
    
		<cfset todayDate = #Now()#> 
        <cfset logindate = #DateFormat(todayDate, "yyyy-mm-dd")# >
        <cfset logintime = #TimeFormat(todayDate, "HH")#>
           
            <cfquery name="chkusers" datasource="#variables.dsn#" result="c">
                SELECT User_Track.user_id, User_Track.track_id, User_Track.ip, User_Track.dated, User_Track.timing
                FROM User_Track
                WHERE User_Track.dated = '#logindate#' AND User_Track.timing ! = #logintime# And User_Track.status = 'active'
             
            </cfquery>
        
        <cfloop query="chkusers">
        
        	<cfquery name="getrow" datasource="#variables.dsn#" result="e">
        
                 SELECT	Employees.current_count
                 FROM Employees
                 WHERE Employees.EmployeesID = '#chkusers.user_id#'
             
            </cfquery>
       
        <cfset usercount = #getrow.current_count#>
        
       		 <cfquery name="editstatus" datasource="#variables.dsn#" result="e">
            
                 UPDATE	Employees
                 set 
                 Employees.current_count = #--usercount#
                 WHERE Employees.user_id = '#chkusers.user_id#'
             
            </cfquery>
        
            <cfquery name="editstatus2" datasource="#variables.dsn#" result="e">
            
                 UPDATE	User_Track
                 set 
                 User_Track.status = 'inactive'
                 WHERE User_Track.track_id = #chkusers.track_id#
                 
            </cfquery>

        </cfloop>

		<cfreturn UserTimeCheck />
	</cffunction>
    
    <!---Code Ended --->
    
    

	<!--- Function used to fetch a user from their site user id --->
	<cffunction name="getSiteUser" access="public" output="false" returntype="query">
		<cfargument name="intSiteUserID" required="yes" type="any" />
		<cfset var rstCurrentSiteUser = "" />

		<!--- RUN QUERY TO FETCH THE USER FROM THE DATABASE --->
		<cfif structKeyExists(session,'isCustomer')>
			<cfquery name="rstCurrentSiteUser" datasource="#variables.dsn#">
				SELECT CustomerID as pkiadminUserID, CustomerName as FirstName, CustomerName as LastName, UserName, Email as EmailAddress, 1 as bEnabled, createdDateTime as dtCreated, LastModifiedDateTime as dtUpdated
				FROM Customers
				WHERE CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.intSiteUserID#" />
			</cfquery>
			<cfreturn rstCurrentSiteUser />
		<cfelseif len(arguments.intSiteUserID) lt 10 >
			<cfquery name="rstCurrentSiteUser" datasource="#variables.dsn#">
				SELECT pkiadminUserID, FirstName, LastName, UserName, EmailAddress, bEnabled, dtCreated, dtUpdated
				FROM fa_AdminUsers
				WHERE fa_adminUsers.pkiadminUserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.intSiteUserID#" />
			</cfquery>
			<cfreturn rstCurrentSiteUser />
		<cfelse>
			<cfquery name="rstCurrentSiteUser" datasource="#variables.dsn#">
				SELECT employeeid as pkiadminUserID, name as FirstName, name as LastName,loginid as UserName,emailid as EmailAddress,isActive as bEnabled,createdDateTime as dtCreated,LastModifiedDatetime as dtUpdated
				FROM employees
				WHERE employeeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.intSiteUserID#" />
			</cfquery>
			<cfreturn rstCurrentSiteUser />
		</cfif>
	</cffunction>
	
	<cffunction name="checkLostPassword" access="public" output="false" returntype="query">
		<cfargument name="EmailAddress" required="yes" type="string" />
		<!--- <cfargument name="NewPassword" required="yes" type="string" /> --->
		
		<cfset var rstUserDetails = "" />

		<!--- <cfquery name="rstUserDetails" datasource="#variables.dsn#">
			SELECT pkiSiteUserID,sFirstName,sLastName, sUserName
			FROM tSiteUsers
			INNER JOIN tSiteUserPasswords ON fkiSiteUserID = pkiSiteUserID
						     AND tSiteUserPasswords.bExpired = 0
			WHERE pkiSiteUserID = '#arguments.EmailAddress#'
			AND bDeleted = 0
		</cfquery> --->

		<!--- LastModifiedDatetime 7/10/15  spericorn(cfprabhu)--->
		<cfquery name="rstUserDetails" datasource="#variables.dsn#">
			SELECT EmailId,password,Name,smtpAddress,smtpUserName,smtpPassword,smtpPort,loginid,usessl FROM Employees emp
			WHERE emp.EmailId = <cfqueryparam value='#arguments.EmailAddress#' cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- <cfif rstUserDetails.recordcount GT 0>
			<cfquery name="GenerateNewPassword" datasource="#variables.dsn#">
				UPDATE tSiteUserPasswords
				SET bExpired = 1
				WHERE fkiSiteUserID = #rstUserDetails.pkiSiteUserID#
			
				INSERT INTO tSiteUserPasswords
				(
					fkiSiteUserID,
					sPasswordHash,
					dtExpiry,
					bPermanent
				)
				VALUES
				(
					#rstUserDetails.pkiSiteUserID#,
					HashBytes('MD5', CONVERT(nvarchar, CONVERT(binary, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NewPassword#" />))),
					getDate(),
					0
				)
			</cfquery>
		</cfif> --->
		
		<cfreturn rstUserDetails />
	</cffunction>

	<cffunction name="checkCustomerLostPassword" access="public" output="false" returntype="query">
		<cfargument name="EmailAddress" required="yes" type="string" />
		<cfset var rstCustomerDetails = "" />
		<cfquery name="rstCustomerDetails" datasource="#variables.dsn#">
			SELECT Email,userName,password,CustomerName FROM Customers cus
			WHERE cus.Email = <cfqueryparam value='#arguments.EmailAddress#' cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn rstCustomerDetails>
	</cffunction>	

	<!--- Function used to get all the privilege ID's for a site user --->
	<cffunction name="getSiteUserPrivileges" access="public" output="false" returntype="query">
		<cfargument name="intSiteUserID" required="yes" type="numeric" />
		<cfargument name="blnIncludeGroup" required="no" type="boolean" default="false" />
		
		<cfset var rstSiteUserPrivileges = "" />

		<!--- RUN QUERY TO FETCH THE USER FROM THE DATABASE --->
		<cfquery name="rstSiteUserPrivileges" datasource="#variables.dsn#">
			SELECT DISTINCT fkiPrivilegeID
			FROM 	(
					SELECT fkiPrivilegeID
					FROM tSiteUser_Privileges
					WHERE tSiteUser_Privileges.fkiSiteUserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.intSiteUserID#" />
					<cfif arguments.blnIncludeGroup>
						UNION
						SELECT fkiPrivilegeID
						FROM tGroup_Privileges
						INNER JOIN tSiteUser_Groups ON tSiteUser_Groups.fkiGroupID = tGroup_Privileges.fkiGroupID
						WHERE tSiteUser_Groups.fkiSiteUserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.intSiteUserID#" />
					</cfif>
					) AS tmpPrivileges
		</cfquery>
		<cfreturn rstSiteUserPrivileges />
	</cffunction>
	
	<!--- Function used to get all the privilege ID's for a group --->
	<cffunction name="getGroupPrivileges" access="public" output="false" returntype="query">
		<cfargument name="intGroupID" required="yes" type="numeric" />
		
		<cfset var rstGroupPrivileges = "" />

		<!--- RUN QUERY TO FETCH THE USER FROM THE DATABASE --->
		<cfquery name="rstGroupPrivileges" datasource="#variables.dsn#">
			SELECT DISTINCT fkiPrivilegeID
			FROM 	(
					SELECT fkiPrivilegeID
					FROM tGroup_Privileges
					WHERE tGroup_Privileges.fkiGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.intGroupID#" />
					) AS tmpPrivileges
		</cfquery>
		
		<cfreturn rstGroupPrivileges />
	</cffunction>
	
	


	
	
</cfcomponent>