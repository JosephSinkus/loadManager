<cfcomponent output="false">	
<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="yes" />
		<cfset variables.dsn = Application.dsn />
</cffunction>
<!---Get Agent Information------->	
<cffunction name="getAllAgent" access="remote" returntype="any">
<cfargument name="agentid" required="no">
<cfargument name="sortorder" required="no" type="any">
<cfargument name="sortby" required="no" type="any">
	
	<CFSTOREDPROC PROCEDURE="USP_GetAgentDetails" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.agentid') and len(arguments.agentid)>
		 	<CFPROCPARAM VALUE="#arguments.agentid#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <cfif session.currentusertype EQ 'Manager'>
		 	<CFPROCPARAM VALUE="#session.officeid#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR"> 
		 </cfif>
		<CFPROCRESULT NAME="getAgent"> 
	</CFSTOREDPROC>
     <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
          
       <cfquery datasource="#variables.dsn#" name="getnewAgent">
                   select Employees.* , Offices.Location,Roles.RoleValue from Employees
                   inner join Offices on Offices.OfficeID = Employees.OfficeID
                   inner join Roles on Roles.RoleID = Employees.RoleID
                   where 1=1 
				   <cfif session.currentusertype EQ 'Manager'>
						AND Offices.OfficeID = '#session.officeid#'
				   </cfif>
                   order by #arguments.sortby# #arguments.sortorder#;
       </cfquery>        
      <cfreturn getnewAgent>               
                   
     </cfif>
    
  <cfreturn getAgent>
</cffunction>
<!-----Insert Agent Information----->
<cffunction name="AddAgent" access="public" returntype="string">
<cfargument name="formStruct" type="struct" required="no">
	<cfif isdefined("arguments.formStruct.integratewithTran360")>
	    <cfset integratewithTran360=True>
	<cfelse>
		<cfset integratewithTran360=False>
	</cfif>
	<cfif isdefined("arguments.formStruct.loadBoard123")>
	    <cfset loadBoard123=True>
	<cfelse>
		<cfset loadBoard123=False>
	</cfif>
	<cfif isdefined("arguments.formStruct.ProMiles")>
	    <cfset proMilesStatus=True>
	<cfelse>
		<cfset proMilesStatus=False>
	</cfif>
	<cfif isdefined("arguments.formStruct.FA_SEC") and arguments.formStruct.FA_SEC eq "SSL">
		<cfset FA_SSL=True>
	    <cfset FA_TLS=False>
	<cfelse>
		<cfset FA_SSL=False>
		<cfset FA_TLS=True>
	</cfif>
	<cfif isdefined("arguments.formStruct.FA_smtpPort") and arguments.formStruct.FA_smtpPort eq "">
	    <cfset FA_port=0>
	<cfelse>
		<cfset FA_port=arguments.formStruct.FA_smtpPort>
	</cfif>
<cfquery name="insertquery" datasource="#variables.dsn#" result="result">
SET NOCOUNT ON
 insert into employees(name,address,city,state,zip,country,telephone,cel,fax,emailSignature,loginid,roleid,password,CreatedDateTime,createdBy,LastModifiedDateTime,LastModifiedBy,
IsActive,LastIpAddress,lastLoginDate,totalLogins,EmailID,OfficeID,SalesCommission,CreatedByIP,GUID,integratewithTran360,trans360Usename,trans360Password,PCMilerUsername,PCMilerPassword,SmtpAddress,SmtpUsername,SmtpPassword,SmtpPort,useTLS,useSSL,loadBoard123,loadBoard123Usename,loadBoard123Password,proMilesStatus,companyCode)
	OUTPUT inserted.EMPLOYEEID 
 values(  
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_name#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.address#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.city#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.state#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.country#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.tel#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.cel#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.fax#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.emailSignature#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.loginid#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_roleid#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_password#">,
	  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
	  <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_isactive#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
	  <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_email#">,
	  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_office#">,
	  <cfif arguments.formStruct.FA_commonrate contains '$'>
		  <cfqueryparam cfsqltype="cf_sql_float" value="#val(right(arguments.formStruct.FA_commonrate,len(arguments.formStruct.FA_commonrate)-1))#">,
	  <cfelse>
	  	<cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.formStruct.FA_commonrate)#">,
	  </cfif>
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">, 
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,
	   <cfqueryparam value="#integratewithTran360#" cfsqltype="cf_sql_bit">,
	 <cfqueryparam value="#arguments.formStruct.trans360Usename#" cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#arguments.formStruct.trans360Password#" cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#arguments.formStruct.PCMilerUsername#" cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#arguments.formStruct.PCMilerPassword#" cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#arguments.formStruct.FA_smtpAddress#"	cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#arguments.formStruct.FA_smtpUsername#"	cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#arguments.formStruct.FA_smtpPassword#"	cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#FA_port#"		cfsqltype="cf_sql_integer">,
	 <cfqueryparam value="#FA_TLS#" cfsqltype="cf_sql_bit">,
	 <cfqueryparam value="#FA_SSL#" cfsqltype="cf_sql_bit">,
	 <cfqueryparam value="#loadBoard123#" cfsqltype="cf_sql_bit">,
	 <cfqueryparam value="#arguments.formStruct.loadBoard123Usename#" cfsqltype="cf_sql_varchar">,
	 <cfqueryparam value="#arguments.formStruct.loadBoard123Password#" cfsqltype="cf_sql_varchar">,
	  <cfqueryparam value="#proMilesStatus#" cfsqltype="cf_sql_bit">,
	  <cfqueryparam value="#arguments.formStruct.companyCode#" cfsqltype="cf_sql_varchar">
 )
 SET NOCOUNT OFF
</cfquery>
<cfquery name="insertquery" datasource="#variables.dsn#" result="result">
	select  EMPLOYEEID from employees where EmailID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_email#">
</cfquery>
<cfquery name="delete" datasource="#variables.dsn#">
	DELETE FROM agentsLoadTypes
    WHERE agentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#insertquery.employeeid#">
</cfquery>

<cfif isdefined('AsignedLoadType')>
    <cfloop index="i" list="#arguments.formStruct.AsignedLoadType#">
		<cfset statusTypeIDforElements = Replace(i,'-','_','ALL')>
		
        <cfquery name="qInsertAgentLoadType" datasource="#variables.dsn#">
            INSERT INTO agentsLoadTypes(agentid,loadstatustypeid,dispatchBoardDirection)
            VALUES(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#insertquery.employeeid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('RADIO_#statusTypeIDforElements#')#">
			)
        </cfquery>
		
    </cfloop>
	
</cfif>

	<cfreturn insertquery.EMPLOYEEID>
</cffunction>
<cffunction name="getAttachedFiles" access="public" returntype="query">
	<cfargument name="linkedid" type="string">
	<cfargument name="fileType" type="string">

	<cfquery name="getFilesAttached" datasource="#variables.dsn#">
		select * from FileAttachments where linked_id='#linkedid#' and linked_to='#filetype#'
	</cfquery>		
		
	<cfreturn getFilesAttached>	
</cffunction>
<!-----Update Agent Information---->
<cffunction name="UpdateAgent" access="public" returntype="any">
<cfargument name="formStruct" type="struct" required="yes">
	<cfif isdefined("arguments.formStruct.integratewithTran360")>
	    <cfset integratewithTran360=True>
	<cfelse>
		<cfset integratewithTran360=False>
	</cfif>
	<cfif isdefined("arguments.formStruct.loadBoard123")>
	    <cfset loadBoard123=True>
	<cfelse>
		<cfset loadBoard123=False>
	</cfif>
	<cfif isdefined("arguments.formStruct.ProMiles")>
	    <cfset proMilesStatus=True>
	<cfelse>
		<cfset proMilesStatus=False>
	</cfif>
	<cfif isdefined("arguments.formStruct.FA_SEC") and arguments.formStruct.FA_SEC eq "SSL">
		<cfset FA_SSL=True>
	    <cfset FA_TLS=False>
	<cfelse>
		<cfset FA_SSL=False>
		<cfset FA_TLS=True>
	</cfif>
	<cfif isdefined("arguments.formStruct.FA_smtpPort") and arguments.formStruct.FA_smtpPort eq "">
	    <cfset FA_port=0>
	<cfelse>
		<cfset FA_port=arguments.formStruct.FA_smtpPort>
	</cfif>
		
		
<cfquery name="qryUpdate" datasource="#variables.dsn#">
  update employees
	set 
	 name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_name#">,
	 roleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_roleid#">,
	 password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_password#">,
     address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.address#">,
	 city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.city#">,
     state = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.state#">,
     zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
     country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.country#">,
     telephone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.tel#">,
     cel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.cel#">,
	 fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.fax#">,
     loginID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.loginid#">,
     emailSignature = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.emailSignature#">,
	 LastModifiedDateTime = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
	 LastModifiedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
	 IsActive = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_isactive#">,
	 LastIpAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	 EmailID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_email#">,
	 OfficeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FA_office#">,
	 <cfif arguments.formStruct.FA_commonrate contains '$'>
		 SalesCommission = <cfqueryparam cfsqltype="cf_sql_float" value="#val(right(arguments.formStruct.FA_commonrate,len(arguments.formStruct.FA_commonrate)-1))#">,
	  <cfelse>
	 	SalesCommission = <cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.formStruct.FA_commonrate)#">,
	 </cfif>
     UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	 integratewithTran360 = <cfqueryparam value="#integratewithTran360#" cfsqltype="cf_sql_bit">,
	trans360Usename = <cfqueryparam value="#arguments.formStruct.trans360Usename#" cfsqltype="cf_sql_varchar">,
	trans360Password = <cfqueryparam value="#arguments.formStruct.trans360Password#" cfsqltype="cf_sql_varchar">,
	integrationID = <cfqueryparam value="#arguments.formStruct.integrationID#" cfsqltype="cf_sql_varchar">,
	PCMilerUsername = <cfqueryparam value="#arguments.formStruct.PCMilerUsername#" cfsqltype="cf_sql_varchar">,
	PCMilerPassword = <cfqueryparam value="#arguments.formStruct.PCMilerPassword#" cfsqltype="cf_sql_varchar">,
	SmtpAddress = <cfqueryparam value="#arguments.formStruct.FA_smtpAddress#"	cfsqltype="cf_sql_varchar">,
	SmtpUsername = <cfqueryparam value="#arguments.formStruct.FA_smtpUsername#"	cfsqltype="cf_sql_varchar">,
	SmtpPassword = <cfqueryparam value="#arguments.formStruct.FA_smtpPassword#"	cfsqltype="cf_sql_varchar">,
	SmtpPort = <cfqueryparam value="#FA_port#"		cfsqltype="cf_sql_integer">,
	useTLS = <cfqueryparam value="#FA_TLS#" cfsqltype="cf_sql_bit">,
	useSSL = <cfqueryparam value="#FA_SSL#" cfsqltype="cf_sql_bit">,
	loadBoard123 = <cfqueryparam value="#loadBoard123#" cfsqltype="cf_sql_bit">,
	loadBoard123Usename = <cfqueryparam value="#arguments.formStruct.loadBoard123Usename#" cfsqltype="cf_sql_varchar">,
	loadBoard123Password = <cfqueryparam value="#arguments.formStruct.loadBoard123Password#" cfsqltype="cf_sql_varchar">,
	proMilesStatus = <cfqueryparam value="#proMilesStatus#" cfsqltype="cf_sql_bit">,
	companyCode = <cfqueryparam value="#arguments.formStruct.companyCode#" cfsqltype="cf_sql_varchar">
	 where employeeID = '#arguments.formStruct.editid#'
</cfquery>
<!--- insert AgentLoadTypes --->
<cfquery name="delete" datasource="#variables.dsn#">
	DELETE FROM agentsLoadTypes
    WHERE agentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">
</cfquery>

<cfif isdefined('AsignedLoadType')>
    <cfloop index="i" list="#arguments.formStruct.AsignedLoadType#">
		<cfset statusTypeIDforElements = Replace(i,'-','_','ALL')>
		
        <cfquery name="qInsertAgentLoadType" datasource="#variables.dsn#">
            INSERT INTO agentsLoadTypes(agentid,loadstatustypeid,dispatchBoardDirection)
            VALUES(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('RADIO_#statusTypeIDforElements#')#">
			)
        </cfquery>
		
    </cfloop>
	
</cfif>
<cfreturn arguments.formStruct.editid>
</cffunction>
<!----delete agent------>
<cffunction name="deleteAgent" access="public" returntype="any">
<cfargument name="agentid" required="yes">
	<cftry>
		<cfquery name="qryDelete" datasource="#variables.dsn#">
			 delete from Employees where  EmployeeID='#arguments.agentid#'
		</cfquery>
		<cfreturn "Agent has been deleted successfully.">	
		<cfcatch type="any">
			<cfreturn "Delete operation has been not successfull. This record is being used by other module.">
		</cfcatch>
	</cftry>
</cffunction>
<!---Get All offices--->
<cffunction name="getOffices" access="public" output="false" returntype="query">
	<cfargument name="officeID" required="no" type="any">
	<CFSTOREDPROC PROCEDURE="USP_GetOfficeDetails" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.officeID') and len(arguments.officeID)>
		 	<CFPROCPARAM VALUE="#arguments.officeID#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="qrygetoffices"> 
	</CFSTOREDPROC>
    <cfreturn qrygetoffices>
</cffunction>

<!---Get All Countries--->
<cffunction name="getAllCountries" access="public" output="false" returntype="query">
	<CFSTOREDPROC PROCEDURE="USP_GetcountryDetails" DATASOURCE="#variables.dsn#"> 
		 <CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 <CFPROCRESULT NAME="qrygetcountries"> 
	</CFSTOREDPROC>	
    <cfreturn qrygetcountries>
</cffunction>
<!--- Get All States--->
<cffunction name="getAllStaes" access="public" output="false" returntype="query">
	<cfargument name="stateID" required="no" type="any">
	<CFSTOREDPROC PROCEDURE="USP_GetStateDetails" DATASOURCE="#variables.dsn#"> 
    	<cfif isdefined('arguments.stateID')>
			<CFPROCPARAM VALUE="#arguments.stateID#" cfsqltype="CF_SQL_VARCHAR">
		<cfelse>
			<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
        </cfif>
		 <CFPROCRESULT NAME="qrygetStates"> 
	</CFSTOREDPROC>
	 <cfreturn qrygetStates>   
</cffunction>
<!--- Get User Role--->
<cffunction name="getUserRoleByUserName" access="public" output="false" returntype="query">
	<cfargument name="userName" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="USP_GetUserRoleByUserName" DATASOURCE="#variables.dsn#"> 
		 <CFPROCPARAM VALUE="#userName#" cfsqltype="CF_SQL_VARCHAR">
		 <CFPROCRESULT NAME="qrygetStates">
	</CFSTOREDPROC>
	 <cfreturn qrygetStates>   
</cffunction>
<!---Get All Roles--->
<!--- Get Loggedin User Info--->
<cffunction name="GetUserInfoUserName" access="public" output="false" returntype="query">
	<cfargument name="userName" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="USP_GetUserInfoUserName" DATASOURCE="#variables.dsn#"> 
		 <CFPROCPARAM VALUE="#userName#" cfsqltype="CF_SQL_VARCHAR">
		 <CFPROCRESULT NAME="qrygetInfos">
	</CFSTOREDPROC>
	 <cfreturn qrygetInfos>
</cffunction>
<!---Get All Roles--->

<cffunction name="getAllRole" access="public" output="false" returntype="query">
	<cfargument name="roleID" required="no" type="any">
    <cfquery name="qrygetRole" datasource="#variables.dsn#">
        select * from roles where 1=1
		<cfif isdefined('arguments.roleID') and len(arguments.roleID)>
			and roleID  = '#arguments.roleID#'
		</cfif>	
    </cfquery>
    <cfreturn qrygetRole>
</cffunction>
<!---Get All Dispatcher--->
<cffunction name="getAllDispatcher" access="public" output="false" returntype="query">
    <cfquery name="qrygetDispatcher" datasource="#variables.dsn#">
        select * from carriers where status = 1
        ORDER BY CarrierName
    </cfquery>
    <cfreturn qrygetDispatcher>
</cffunction>
<!--- Get Search Agent --->
<cffunction name="getSearchedAgent" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="searchAgent" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.searchText') and len(arguments.searchText)>
		 	<CFPROCPARAM VALUE="#arguments.searchText#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="QreturnSearch"> 
	</CFSTOREDPROC>
    <cfreturn QreturnSearch>
</cffunction>
<!---Get Sales Person with auth level---->
<cffunction name="getSalesPerson" access="remote" returntype="any">
 <cfargument name="AuthLevelId" required="no">
	 <cfquery name="getSalesperson" datasource="#variables.dsn#">
		 SELECT * FROM employees
         WHERE  ( roleid <cfif IsNumeric(arguments.AuthLevelId)> = #arguments.AuthLevelId#<cfelse>in (<cfqueryparam list="true" value="#arguments.AuthLevelId#">) </cfif> OR  roleid = '4' )  and isActive = 'True'
         ORDER BY Name
	 </cfquery>
 <cfreturn getSalesperson>
</cffunction>


<cffunction name="getAgentsLoadStatusTypes" access="public" returntype="any">
<cfargument name="agentid" required="yes">
	 <cfquery name="qAgentsLoadStatuses" datasource="#variables.dsn#">
		SELECT loadStatusTypeID, dispatchBoardDirection
		FROM employees
		LEFT OUTER JOIN agentsLoadTypes ON employees.employeeID = agentsLoadTypes.AgentID
		WHERE employeeID = <cfqueryparam value="#arguments.agentid#" cfsqltype="cf_sql_varchar">
	 </cfquery>
 <cfreturn qAgentsLoadStatuses>
</cffunction>

<cffunction name="getAgentsLoadStatusTypesByLoginID" access="public" returntype="any">
<cfargument name="agentLoginId" required="yes">
	 <cfquery name="qAgentsLoadStatuses" datasource="#variables.dsn#">
		SELECT loadStatusTypeID, dispatchBoardDirection
		FROM employees
		LEFT OUTER JOIN agentsLoadTypes ON employees.employeeID = agentsLoadTypes.AgentID
		WHERE loginid = <cfqueryparam value="#agentLoginId#" cfsqltype="cf_sql_varchar">
	 </cfquery>
 <cfreturn qAgentsLoadStatuses>
</cffunction>

<cffunction name="verifyTrancoreLoginStatus" access="public" returntype="boolean">
	<cfargument name="tranUname" type="string" required="yes" default="">
	<cfargument name="tranPwd" type="string" required="yes" default="">
	
	<cfset var isSuccess = true>
	<cfset var TranscoreData360 = "">
	<cfset var tranLoginText = "">
	
	<cfsavecontent variable="soapHeaderTransCoreTxt">
	<cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
		  <soapenv:Header>
			  <tcor:sessionHeader soapenv:mustUnderstand="1">
				<tcor:sessionToken>
					<tcor1:primary></tcor1:primary>
					<tcor1:secondary></tcor1:secondary>
				</tcor:sessionToken>
			  </tcor:sessionHeader>
			  <tcor:correlationHeader soapenv:mustUnderstand="0">
			  </tcor:correlationHeader>
			  <tcor:applicationHeader soapenv:mustUnderstand="0">
				<tcor:application>TFMI</tcor:application>
				<tcor:applicationVersion>1</tcor:applicationVersion>
			  </tcor:applicationHeader>
		  </soapenv:Header>
		  <soapenv:Body>
			  <tfm:loginRequest>
				<tfm:loginOperation>
					<tfm:loginId>#arguments.tranUname#</tfm:loginId>
					<tfm:password>#arguments.tranPwd#</tfm:password>
					<tfm:thirdPartyId>TFMI</tfm:thirdPartyId>
					<tfm:apiVersion>2</tfm:apiVersion>
				</tfm:loginOperation>
			  </tfm:loginRequest>
		  </soapenv:Body>
		</soapenv:Envelope>
	</cfoutput>
	</cfsavecontent>
	
	<cftry>
	<!--- TEST URL
		<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="TranscoreData360">
			<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTxt )#" /> 
		</cfhttp> --->
		
<!--- LIVE URL --->		
  		<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="TranscoreData360">
			<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTxt )#" /> 
		</cfhttp>
		
		<cfset TranscoreData360 = xmlparse(TranscoreData360.filecontent)>
		<cfset tranLoginText = TranscoreData360['soapenv:Envelope']['soapenv:Body']['XmlChildren'][1]['XmlChildren'][1]['XmlChildren'][1]['XmlName']>
			
		<cfif tranLoginText.contains('Error') or tranLoginText.contains('error')>
			<cfset isSuccess = false>
		</cfif>
		
		<cfcatch type="any">
			<cfset isSuccess = false>
		</cfcatch>
	</cftry>
	
	<cfreturn isSuccess>

</cffunction>
			
<cffunction name="verifyMailServer" returntype="struct" access="public" output="true">
    <cfargument name="protocol" type="string" required="true" hint="Mail protocol: SMTP, POP3 or IMAP" />
    <cfargument name="host" type="string" required="true" hint="Mail server name (Example: pop.gmail.com)"/>
    <cfargument name="port" type="numeric" default="-1" hint="Mail server port number. Default is -1, meaning use the default port for this protocol)" />
    <cfargument name="user" type="string" required="true" hint="Mail account username" />
    <cfargument name="password" type="string" required="true" hint="Mail account password" />
    <cfargument name="useSSL" type="boolean" default="false" hint="If true, use SSL (Secure Sockets Layer)" >
    <cfargument name="useTLS" type="boolean" default="false" hint="If true, use TLS (Transport Level Security)" >
    <cfargument name="enforceTLS" type="boolean" default="false" hint="If true, require TLS support" >
    <cfargument name="timeout" type="numeric" default="0" hint="Maximum milliseconds to wait for connection. Default is 0 (wait forever)" />
    <cfargument name="debug" type="boolean" default="false" hint="If true, enable debugging. By default information is sent to is sent to System.out." >
    <cfargument name="logPath" type="string" default="" hint="Send debugging output to this file. Absolute file path. Has no effect if debugging is disabled." >
    <cfargument name="append" type="boolean" default="true" hint="If false, the existing log file will be overwritten" >
		
    <cfset var status         = structNew() />
    <cfset var props         = "" />
    <cfset var mailSession     = "" />
    <cfset var store         = "" />
    <cfset var transport    = "" />
    <cfset var logFile        = "" />
    <cfset var fos             = "" />
    <cfset var ps             = "" />
    
    <!--- validate protocol --->
    <cfset arguments.protocol = lcase( trim(arguments.protocol) ) />
    <cfif not listFindNocase("pop3,smtp,imap", arguments.protocol)>
        <cfthrow type="IllegalArgument" message="Invalid protocol. Allowed values: POP3, IMAP and SMTP" />
    </cfif>
    
    <cfscript>
		// initialize status messages
		status.wasVerified		= false;
		status.errorType		= "";
		status.errorDetail		= "";

      try {
		props = createObject("java", "java.util.Properties").init();
		
		// enable securty settings
		if (arguments.useSSL or arguments.useTLS) {
			// use the secure protocol
			// this will set the property mail.{protocol}.ssl.enable = true
			if (arguments.useSSL) {
				arguments.protocol = arguments.protocol &"s";
				props.put("mail.user", arguments.user);
				props.put("mail.password", arguments.password);
			}
			// enable identity check
			//props.put("mail."& protocol &".ssl.checkserveridentity", "true");
		
			// enable transport level security and make it mandatory
			// so the connection fails if TLS is not supported
			if (arguments.useTLS) {
				//props.put("mail."& protocol &".starttls.required", "true");
				props.put("mail."& protocol &".starttls.enable", "true");
			}
		
			props.put("mail."& protocol &".host", arguments.host);
			props.put("mail."& protocol &".port", arguments.port);
		}
		
		// force authentication command
		props.put("mail."& protocol &".auth", "true");
		
		// for simple verifications, apply timeout to both socket connection and I/O
		if (structKeyExists(arguments, "timeout")) {
			props.put("mail."& protocol &".connectiontimeout", arguments.timeout);
			props.put("mail."& protocol &".timeout", arguments.timeout);
		}
		
		// create a new mail session 
		mailSession = createObject("java", "javax.mail.Session").getInstance( props );
		// enable debugging
		if (arguments.debug) {
			mailSession.setDebug( true );

			// redirect the output to the given log file
			if ( len(trim(arguments.logPath)) ) {
				logFile = createObject("java", "java.io.File").init( arguments.logPath );
				fos      = createObject("java", "java.io.FileOutputStream").init( logFile, arguments.overwrite );
				ps       = createObject("java", "java.io.PrintStream").init( fos );
				mailSession.setDebugOut( ps );
			}
		}
		
		// Connect to an SMTP server ... 
		if ( left(arguments.protocol, 4) eq "smtp") {
			transport = mailSession.getTransport( protocol );
			transport.connect(arguments.host, arguments.port, arguments.user, arguments.password);
			transport.close();
			// if we reached here, the credentials should be verified
			status.wasVerified     = true;
		}
		
		// Otherwise, it is a POP3 or IMAP server
		else {

			store = mailSession.getStore( protocol );
			store.connect(arguments.host, arguments.port, arguments.user, arguments.password);
			store.close();
			// if we reached here, the credentials should be verified
			status.wasVerified     = true;
		}
	  }
	 //for authentication failures
	 catch(javax.mail.AuthenticationFailedException e) {
			   status.errorType     = "Authentication";
			 status.errorDetail     = e;
		}
	 // some other failure occurred like a javax.mail.MessagingException
	 catch(Any e) {
			 status.errorType     = "Other";
			 status.errorDetail     = e;
	 }



	 // always close the stream ( messy work-around for lack of finally clause prior to CF9...)
	 if ( not IsSimpleValue(ps) ) {
		   ps.close();
	 }

        return status;
    </cfscript>
</cffunction>
	<!---function to get editing User Name--->
	<cffunction name="getEditingUserName" access="public" returntype="any">
		<cfargument name="employeID" required="yes">
		<!---Query to get editing User Name--->
		 <cfquery name="qryGetEditingUserName" datasource="#variables.dsn#">
			SELECT NAME
			FROM employees
			WHERE employeeID = <cfqueryparam value="#arguments.employeID#" cfsqltype="cf_sql_varchar">
		 </cfquery>
		<cfreturn qryGetEditingUserName>
	</cffunction>
	<!---function to get roleid--->
	<cffunction name="getRoleid" access="public" returntype="any">
		<cfargument name="employeID" required="yes">
		<!---Query to get roleid--->
		 <cfquery name="qryGetRoleid" datasource="#variables.dsn#">
			SELECT roleid
			FROM employees
			WHERE employeeID = <cfqueryparam value="#arguments.employeID#" cfsqltype="cf_sql_varchar">
		 </cfquery>
		<cfreturn qryGetRoleid>
	</cffunction>
</cfcomponent>



