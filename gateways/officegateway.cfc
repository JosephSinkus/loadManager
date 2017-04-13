<cfcomponent output="false">
<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>

<!--- Add Office --->
<cffunction name="addOffice" access="public" output="false" returntype="Any">
	<cfargument name="formStruct" type="struct" required="yes">
	<cfquery name="addOffice" datasource="#variables.dsn#">
		insert into offices (officecode,location,adminmanager,contactno,faxno,emailid,isActive,createdBy,createdDateTime,lastmodifiedby,lastmodifieddatetime,disclaimertext,customerdisclaimertext,CreatedByIP,GUID)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.officecode#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.location#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.adminmanager#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.contactNo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.faxNo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.emailid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.isActive#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.disclaimertext#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.customerdisclaimertext#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">
		   )
	</cfquery>
	<cfreturn "Office has been added successfully">
</cffunction>

<!--- Update Office --->
<cffunction name="updateOffice" access="public" output="false" returntype="Any">
	<cfargument name="formStruct" type="struct" required="yes">
	<cfquery name="updateOffice" datasource="#variables.dsn#">
		update offices set
			officecode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.officecode#">,
			location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.location#">,
			adminmanager = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.adminmanager#">,
			contactno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.contactNo#">,
			faxno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.faxNo#">,
			emailid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.emailid#">,
			isActive = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.isActive#">,
			lastmodifiedby = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			lastmodifieddatetime = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			disclaimertext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.disclaimertext#">,
			customerdisclaimertext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.customerdisclaimertext#">,
            UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
		   where officeId = '#arguments.formStruct.editid#'
	</cfquery>
	<cfreturn "Office has been updated successfully.">
</cffunction>

<!--- Get Ofiices--->
<cffunction name="getAllOffices" access="public" output="false" returntype="query">
	<cfargument name="officeID" required="no" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
	<CFSTOREDPROC PROCEDURE="USP_GetOfficeDetails" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.officeID') and len(arguments.officeID)>
		 	<CFPROCPARAM VALUE="#arguments.officeID#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="qrygetoffices"> 
	</CFSTOREDPROC>
    
    <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
             
          <cfquery datasource="#variables.dsn#" name="getnewAgent">
                      select *  from Offices
                      where 1=1
                      order by #arguments.sortby# #arguments.sortorder#;
          </cfquery>
                    
         <cfreturn getnewAgent>               
                      
    </cfif>
    <cfreturn qrygetoffices>
</cffunction>
<!--- Delete Office--->
<cffunction name="deleteOffice" access="public" output="false" returntype="any">
	<cfargument name="officeID" required="yes" type="any">
	<cftry>
    <cfquery name="qrygetoffices" datasource="#variables.dsn#">
        delete from Offices where officeId  = '#arguments.officeID#'
    </cfquery>
    <cfreturn "Office has been deleted successfully.">
	<cfcatch type="any"><cfreturn "Delete opereation has been not successfull. This record is being used by other module."></cfcatch>
	</cftry>
</cffunction>

<!--- Search Offices --->

<cffunction name="getSearchedOffices" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="searchOffices" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.searchText') and len(arguments.searchText)>
		 	<CFPROCPARAM VALUE="#arguments.searchText#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="QreturnSearch"> 
	</CFSTOREDPROC>
    <cfreturn QreturnSearch>
</cffunction>

</cfcomponent>