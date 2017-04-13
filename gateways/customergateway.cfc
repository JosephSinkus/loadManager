<cfcomponent output="false">
<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>
<cffunction name="getAttachedFiles" access="public" returntype="query">
	<cfargument name="linkedid" type="string">
	<cfargument name="fileType" type="string">

	<cfquery name="getFilesAttached" datasource="#variables.dsn#">
		select * from FileAttachments where linked_id='#linkedid#' and linked_to='#filetype#'
	</cfquery>		
		
	<cfreturn getFilesAttached>	
</cffunction>
<!----Get All Customer Information---->
<cffunction name="getAllCustomers" access="public" output="false" returntype="any">
    <cfargument name="CustomerID" required="no" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
    <cfargument name="dsn" required="no" type="any">
    
    <cfif isdefined('dsn')>
    	<cfset activedsn = dsn>
    <cfelse>
    	<cfset activedsn = variables.dsn>
    </cfif>
    
			<CFSTOREDPROC PROCEDURE="USP_GetCustomerDetails" DATASOURCE="#activedsn#"> 
				<cfif isdefined('arguments.CustomerID') and len(arguments.CustomerID)>
				 	<CFPROCPARAM VALUE="#arguments.CustomerID#" cfsqltype="CF_SQL_VARCHAR">  
				 <cfelse>
				 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
				 </cfif>
				 <CFPROCRESULT NAME="qrygetcustomers"> 
			</CFSTOREDPROC>
  
      <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
               
            <cfquery datasource="#activedsn#" name="getnewAgent">
                        select Customers.CustomerID, Customers.CustomerName,Customers.Location as custLocation,Customers.PhoneNo,ISNULL(RatePerMile,0) AS RatePrMile,Customers.CustomerStatusID,CUSTOMERs.OFFICEID,Customers.CompanyID,Offices.Location as ofLocation,Companies.CompanyName from Customers
                        inner join Offices on Offices.OfficeID = Customers.OfficeID
                        inner join Companies on Companies.CompanyID=Customers.CompanyID
                        where 1=1 AND IsPayer = 1
                        order by #arguments.sortby# #arguments.sortorder#;
            </cfquery>
                      
           <cfreturn getnewAgent>
                        
       </cfif>
             <cfreturn qrygetcustomers>
</cffunction>



<!---Add Customer Information---->
<cffunction name="AddCustomer" access="public" output="false" returntype="any">
	<cfargument name="formStruct" type="struct" required="no" />
	<cfargument name="idReturn" type="string" required="no"  default="" />
	
	<cfif not structKeyExists(variables,"dsn")>
		<cfset variables.dsn =application.dsn>
	</cfif>

	<cfset variables.userExists = 0>

	<cfif arguments.formStruct.IsPayer AND len(trim(arguments.formStruct.CustomerUsername))>
	    <cfquery name="qryGetCustomer" datasource="#variables.dsn#">
	    	select CustomerID from Customers
	    	where 
	    		Username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerUsername#">
		</cfquery>
		<cfif qryGetCustomer.recordCount>
			<cfset variables.userExists = 1>
		</cfif>
	</cfif>
	
	<CFSTOREDPROC PROCEDURE="USP_InsertCustomer" DATASOURCE="#variables.dsn#">
			<CFPROCPARAM VALUE="#arguments.formStruct.CustomerStatusID#" cfsqltype="CF_SQL_Int">
			<CFPROCPARAM VALUE="#arguments.formStruct.CustomerCode#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.formStruct.CustomerName#" cfsqltype="CF_SQL_VARCHAR">,
            <CFPROCPARAM VALUE="#arguments.formStruct.OfficeID1#" cfsqltype="CF_SQL_VARCHAR">,  
            <CFPROCPARAM VALUE="#arguments.formStruct.Location#" cfsqltype="CF_SQL_VARCHAR">,   
            <CFPROCPARAM VALUE="#arguments.formStruct.City#"  cfsqltype="CF_SQL_VARCHAR">,   
            <CFPROCPARAM VALUE="#arguments.formStruct.State1#"  cfsqltype="CF_SQL_VARCHAR">,   
            <CFPROCPARAM VALUE="#arguments.formStruct.Zipcode#" cfsqltype="CF_SQL_VARCHAR">,
            <CFPROCPARAM VALUE="#arguments.formStruct.ContactPerson#" cfsqltype="CF_SQL_VARCHAR">,
            <CFPROCPARAM VALUE="#arguments.formStruct.MobileNo#"  cfsqltype="CF_SQL_VARCHAR">,
            <CFPROCPARAM VALUE="#arguments.formStruct.PhoneNO#"  cfsqltype="CF_SQL_VARCHAR">,
            <CFPROCPARAM VALUE="#arguments.formStruct.Email#"  cfsqltype="CF_SQL_VARCHAR">,
            <CFPROCPARAM VALUE="#arguments.formStruct.website#"  cfsqltype="CF_SQL_VARCHAR">,
			<cfif isdefined('arguments.formStruct.salesperson') and len(arguments.formStruct.salesperson)>
		 		<CFPROCPARAM VALUE="#arguments.formStruct.salesperson#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
		 		<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
		 	</cfif>
		 	
		 	<cfif isdefined('arguments.formStruct.Dispatcher') and len(arguments.formStruct.Dispatcher)>
		 		<CFPROCPARAM VALUE="#arguments.formStruct.Dispatcher#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
		 		<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
		 	</cfif>
		 	
		 	<cfif isdefined('arguments.formStruct.LoadPotential') and len(arguments.formStruct.LoadPotential)>
		 		<CFPROCPARAM VALUE="#arguments.formStruct.LoadPotential#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
		 		<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
		 	</cfif>
		 	
            <CFPROCPARAM VALUE="#arguments.formStruct.CompanyID1#" cfsqltype="CF_SQL_VARCHAR">,  
			
			<cfif isdefined('arguments.formStruct.BestOpp') and len(arguments.formStruct.BestOpp)>
		 		<CFPROCPARAM VALUE="#arguments.formStruct.BestOpp#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
		 		<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
		 	</cfif>
			
            <CFPROCPARAM VALUE="#arguments.formStruct.CustomerDirections#" cfsqltype="CF_SQL_NText">  ,
            <CFPROCPARAM VALUE="#arguments.formStruct.CustomerNotes#" cfsqltype="CF_SQL_VARCHAR">,  
            <CFPROCPARAM VALUE="#arguments.formStruct.IsPayer#" cfSqltype="Cf_SQL_BIT">,
            <CFPROCPARAM VALUE="#session.adminUserName#"  cfsqltype="CF_SQL_VARCHAR">,  
            <CFPROCPARAM VALUE="#arguments.formStruct.FinanceID#" cfsqltype="CF_SQL_VARCHAR">,
			<cfif arguments.formStruct.CreditLimit contains '$'>
			  	<CFPROCPARAM VALUE="#val(right(arguments.formStruct.CreditLimit,len(arguments.formStruct.CreditLimit)-1))#" cfsqltype="Cf_Sql_MONEY">,
			<cfelse>
              	<CFPROCPARAM VALUE="#val(arguments.formStruct.CreditLimit)#" cfsqltype="Cf_Sql_MONEY">,
			</cfif>
			  <cfif arguments.formStruct.Balance contains '$'>
				  <CFPROCPARAM VALUE="#val(right(arguments.formStruct.Balance,len(arguments.formStruct.Balance)-1))#" cfsqltype="Cf_Sql_MONEY">,
			  <cfelse>
	              <CFPROCPARAM VALUE="#val(arguments.formStruct.Balance)#" cfsqltype="Cf_Sql_MONEY">
			  </cfif>
              <cfif arguments.formStruct.Available contains '$'>
				<CFPROCPARAM VALUE="#val(right(arguments.formStruct.Available,len(arguments.formStruct.Available)-1))#" cfsqltype="Cf_Sql_MONEY">,
			  <cfelse>	
			  	<CFPROCPARAM VALUE="#val(arguments.formStruct.Available)#" cfsqltype="Cf_Sql_MONEY">,
			  </cfif>
              <cfif arguments.formStruct.RatePerMile contains '$'>
				<CFPROCPARAM VALUE="#val(right(arguments.formStruct.RatePerMile,len(arguments.formStruct.RatePerMile)-1))#" cfsqltype="Cf_Sql_MONEY">,
			  <cfelse>	
			  	<CFPROCPARAM VALUE="#val(arguments.formStruct.RatePerMile)#" cfsqltype="Cf_Sql_MONEY">,
			  </cfif>
			  <CFPROCPARAM VALUE="#arguments.formStruct.country1#" cfsqltype="cf_sql_varCHAR">,
              <CFPROCPARAM VALUE="#cgi.REMOTE_ADDR#"  cfsqltype="cf_sql_varCHAR">,
              <CFPROCPARAM VALUE="#cgi.HTTP_USER_AGENT#"  cfsqltype="cf_sql_varCHAR">,
			  <CFPROCPARAM VALUE="#arguments.formStruct.CarrierNotes#" cfsqltype="CF_SQL_VARCHAR">,
			  <CFPROCPARAM VALUE="#arguments.formStruct.Tollfree#"  cfsqltype="CF_SQL_VARCHAR">
			  <CFPROCPARAM VALUE="#arguments.formStruct.Fax#"  cfsqltype="CF_SQL_VARCHAR">
				<cfif isdefined('arguments.formStruct.RemitName') and len(arguments.formStruct.RemitName)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitName#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>	
				<cfif isdefined('arguments.formStruct.RemitAddress') and len(arguments.formStruct.RemitAddress)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitAddress#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>		
				<cfif isdefined('arguments.formStruct.RemitCity') and len(arguments.formStruct.RemitCity)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitCity#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>		
				<cfif isdefined('arguments.formStruct.RemitState') and len(arguments.formStruct.RemitState)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitState#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>		
				<cfif isdefined('arguments.formStruct.RemitZipcode') and len(arguments.formStruct.RemitZipcode)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitZipcode#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>	
				<cfif isdefined('arguments.formStruct.RemitContact') and len(arguments.formStruct.RemitContact)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitContact#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>	
				<cfif isdefined('arguments.formStruct.RemitFax') and len(arguments.formStruct.RemitFax)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitFax#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>	
				<cfif isdefined('arguments.formStruct.RemitPhone') and len(arguments.formStruct.RemitPhone)>
					<CFPROCPARAM VALUE="#arguments.formStruct.RemitPhone#"  cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>	
			  <cfif arguments.formStruct.isPayer>
			  		<cfif variables.userExists>
			  			<CFPROCPARAM VALUE=""  cfsqltype="CF_SQL_VARCHAR">
			  		<cfelse>
			  			<CFPROCPARAM VALUE="#arguments.formStruct.CustomerUsername#"  cfsqltype="CF_SQL_VARCHAR">
			  		</cfif>				  
				  	<CFPROCPARAM VALUE="#arguments.formStruct.CustomerPassword#"  cfsqltype="CF_SQL_VARCHAR">
			  <cfelse>
			  		<CFPROCPARAM VALUE=""  cfsqltype="CF_SQL_VARCHAR">
				  	<CFPROCPARAM VALUE=""  cfsqltype="CF_SQL_VARCHAR">
			  </cfif>
              <cfprocresult name="qLastInsertedCustomer"> 
	</CFSTOREDPROC>
	
	<cfif arguments.idReturn eq "true">
		<cfset resultStruct ={}>
		<cfset resultStruct.id = qLastInsertedCustomer.lastInsertedCustomerID>
		<cfif qLastInsertedCustomer.lastInsertedCustomerID eq ''>
			<cfset resultStruct.message ="Customer addition failed">
		<cfelseif variables.userExists>
			<cfset resultStruct.message ="The username is already in use, please update the username.">
		<cfelse>
			<cfset resultStruct.message ="Customer has been added Successfully">
		</cfif>
		<cfreturn resultStruct>
	<cfelseif variables.userExists>
		<cfreturn "The username is already in use, please update the username.">
	<cfelse>
	  <cfreturn "Customer has been added Successfully">
	</cfif>	  
   <cfreturn "Customer has been added Successfully">	    	

</cffunction>

<!---Get All Offices--->
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
<!--- Get All Companies ---->
 <cffunction name="getCompanies" access="public" output="false" returntype="query">
         	<cfargument name="CompanyID" required="no" type="any">
             <cfquery name="qrygetcompanies" datasource="#variables.dsn#">
                 select * from Companies                
         		<cfif isdefined('arguments.CompanyID') and len(arguments.CompanyID)>
         			where CompanyID  = '#arguments.CompanyID#'
         		</cfif>	
             </cfquery>
             <cfreturn qrygetcompanies>
 </cffunction>
<!---Update Customer --->
<cffunction name="updateCustomers" access="public" output="false" returntype="any">
    <cfargument name="formStruct" type="struct">
    <cfargument name="editid" type="any"> 
	
	<cfset variables.userExists = 0>

    <cfif arguments.formStruct.IsPayer AND len(trim(arguments.formStruct.CustomerUsername))>
	    <cfquery name="qryGetCustomer" datasource="#variables.dsn#">
	    	select CustomerID from Customers
	    	where 
	    		Username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerUsername#"> AND
	    		CustomerID <> <cfqueryparam value="#arguments.formStruct.editid#">		
		</cfquery>
		<cfif qryGetCustomer.recordCount>
			<cfset variables.userExists = 1>
		</cfif>
	</cfif>
    <cfquery name="qryupdatecustomer" datasource="#variables.dsn#">
         update Customers
         set  CustomerStatusID= <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.formStruct.CustomerStatusID#">,
         CustomerCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerCode#">,
         CustomerName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerName#">,
         OfficeID='#arguments.formStruct.OfficeID1#',
         Location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Location#">,
         City=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.City#">,
         statecode='#arguments.formStruct.State1#',
         Zipcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
         ContactPerson=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ContactPerson#">,
         PersonMobileNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.MobileNo#">,
         PhoneNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.PhoneNo#">,
         Email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Email#">,
         Website=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Website#">,
		 <cfif arguments.formStruct.salesperson neq ''>
	         SalesRepID='#arguments.formStruct.salesperson#',
	     </cfif> 
	     <cfif arguments.formStruct.Dispatcher neq ''>   
	         AcctMGRID='#arguments.formStruct.Dispatcher#',
	     </cfif>    
         LoadPotential=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.LoadPotential#">,
         CompanyID='#arguments.formStruct.CompanyID1#',
	     BestOpp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.BestOpp#">,
         CustomerDirections= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.formStruct.CustomerDirections#">,
         CustomerNotes= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.formStruct.CustomerNotes#">,
         IsPayer=<cfqueryparam cfsqltype="cf_sql_bit"  value="#arguments.formStruct.IsPayer#">,
		 LastModifiedBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
		 LastModifiedDateTime=<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
		 FinanceID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.FinanceID#">,
		 <cfif arguments.formStruct.CreditLimit contains '$'>
			CreditLimit=<cfqueryparam cfsqltype="cf_sql_money" value="#val(right(arguments.formStruct.CreditLimit,len(arguments.formStruct.CreditLimit)-1))#">,
	     <cfelse>
		 	CreditLimit=<cfqueryparam cfsqltype="cf_sql_money" value="#val(arguments.formStruct.CreditLimit)#">,
		 </cfif>
		  <cfif arguments.formStruct.Balance contains '$'>
			  Balance=<cfqueryparam cfsqltype="cf_sql_money" value="#val(right(arguments.formStruct.Balance,len(arguments.formStruct.Balance)-1))#">,
		  <cfelse>
		 	  Balance=<cfqueryparam cfsqltype="cf_sql_money" value="#val(arguments.formStruct.Balance)#">,
		</cfif>
		<cfif arguments.formStruct.Available contains '$'>
			Available =<cfqueryparam cfsqltype="cf_sql_money" value="#val(right(arguments.formStruct.Available,len(arguments.formStruct.Available)-1))#">,
		 <cfelse>	
		 Available =<cfqueryparam cfsqltype="cf_sql_money" value="#val(arguments.formStruct.Available)#">,
		</cfif>
        <cfif arguments.formStruct.RatePerMile contains '$'>
			RatePerMile =<cfqueryparam cfsqltype="cf_sql_money" value="#val(right(arguments.formStruct.RatePerMile,len(arguments.formStruct.RatePerMile)-1))#">,
		 <cfelse>	
			 RatePerMile =<cfqueryparam cfsqltype="cf_sql_money" value="#val(arguments.formStruct.RatePerMile)#">,
		</cfif>
		 countryID = '#arguments.formStruct.country1#',	
         UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#"> ,
		 CarrierNotes= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.formStruct.CarrierNotes#">,
		 TollFree=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.TollFree#">,
	     Fax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Fax#">,
		 RemitName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitName#">,
		 RemitAddress=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitAddress#">,  
		 RemitCity= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitCity#">, 
		 RemitState= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitState#">,         
		 RemitZipcode=   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitZipcode#">,
		 RemitContact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitContact#">,
		 RemitPhone=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitPhone#">,
         RemitFax=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitFax#">
	     <cfif arguments.formStruct.IsPayer>
	     	<cfif NOT variables.userExists>
	     		,Username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerUsername#">
	     	</cfif>			
			,Password=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerPassword#">	     	
	     </cfif>
      where CustomerID='#arguments.formStruct.editid#' 
     </cfquery>
     <cfif variables.userExists>
     	<cfset result = "The username is already in use, please select a different username">
     <cfelse>
     	<cfset result = "Customer has been updated Successfully">	
     </cfif>
     <cfreturn result>
</cffunction>
<cffunction name="deleteCustomers"  access="public" output="false" returntype="any">
<cfargument name="CustomerID" type="any" required="yes">
    <cftry>
    		<cfquery name="qryDelete" datasource="#variables.dsn#">
    			 delete from Customers where  CustomerID='#arguments.CustomerID#'
    		</cfquery>
    		<cfreturn "Customer has been deleted successfully.">	
    		<cfcatch type="any">
    			<cfreturn "Cannot Delete Customer because related data exists.Please consider deleting other data or making the customer Inactive">
    		</cfcatch>
    	</cftry>
</cffunction>       

<!--- Search customer --->
<cffunction name="getSearchedCustomer" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
    <cfargument name="pageNo" required="yes" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
	<cfargument name="argPayer" required="no" type="any" default="2">
    	
	
	
	<CFSTOREDPROC PROCEDURE="searchCustomer" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.searchText') and len(arguments.searchText)>
		 	<CFPROCPARAM VALUE="#arguments.searchText#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
         
         <cfif isdefined('arguments.pageNo') and len(arguments.pageNo)>
		 	<CFPROCPARAM VALUE="#arguments.pageNo#" cfsqltype="cf_sql_integer"> 
		 <cfelse>
		 	<CFPROCPARAM VALUE="1" cfsqltype="cf_sql_integer">  
		 </cfif>
         
         <CFPROCPARAM VALUE="30" cfsqltype="cf_sql_integer"> <!--- Page Size --->
         
         <cfif isdefined('arguments.sortorder') and len(arguments.sortorder)>
		 	<CFPROCPARAM VALUE="#arguments.sortorder#" cfsqltype="cf_sql_varchar"> 
		 <cfelse>
		 	<CFPROCPARAM VALUE="ASC" cfsqltype="cf_sql_varchar">  
		 </cfif>
         
         <cfif isdefined('arguments.sortby') and len(arguments.sortby)>
		 	<CFPROCPARAM VALUE="#arguments.sortby#" cfsqltype="cf_sql_varchar"> 
		 <cfelse>
		 	<CFPROCPARAM VALUE="CustomerName" cfsqltype="cf_sql_varchar">  
		 </cfif>
         <CFPROCPARAM VALUE="#argPayer#" cfsqltype="cf_sql_varchar">
		
		 <CFPROCRESULT NAME="QreturnSearch"> 
	</CFSTOREDPROC>
    <cfif structkeyexists(session,"currentusertype") >
		<cfset variables.currentusertype = lcase(session.currentusertype) >
		<cfset variables.listCurrentusertype = "sales representative" >
		<cfif listfindnocase("sales representative,dispatcher,manager",variables.currentusertype) >
			<cfquery name="QreturnSearch" dbtype="query">
				select * from QreturnSearch where officeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.officeid#">
			</cfquery>
			<cfset variables.OfficeId = session.officeid >
		</cfif>
	</cfif>
    <cfreturn QreturnSearch>
</cffunction>
<!--- Add Stop--->
<cffunction name="AddStop" access="public" output="false" returntype="any">
   <cfargument name="formStruct" type="struct" required="no" />
   <cfquery name="insertquery" datasource="#variables.dsn#">
       insert into LoadStops(CustomerStopName,City,StateID,PostalCode,Phone,Fax,ContactPerson,CreatedBy,CreatedDateTime,
	    ModifiedBy,LastModifiedDate,CustomerID,EmailID,Location,Instructions,Directions,<!---CreatedByIP,GUID,--->LoadType)
       values(
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerStopName#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.City#">,
              '#arguments.formStruct.StateID#',  
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Phone#">, 
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Fax#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ContactPerson#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
              '#arguments.formStruct.CustomerID#',
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EmailID#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Location#">,
              <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.formStruct.NewInstructions#">,
              <cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#arguments.formStruct.NewDirections#">,
              <!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,--->
              <!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,--->
              <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.StopType#">
              )
   </cfquery>
   <cfreturn "Stop has been added Successfully">	    	
</cffunction>

<!--- Update Stop--->
<cffunction name="UpdateStop" access="public" output="false" returntype="any">
   <cfargument name="formStruct" type="struct" required="no" />
   <cfquery name="insertquery" datasource="#variables.dsn#">
       update CustomerStops
	   set 
	        CustomerStopName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CustomerStopName#">,
            City= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.City#">,
            StateID= '#arguments.formStruct.StateID#',  
			PostalCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
            Phone=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Phone#">, 
            Fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Fax#">,
            ContactPerson=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ContactPerson#">,
			LastModifiedBy =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			LastModifiedDateTime= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
            CustomerID= '#arguments.formStruct.CustomerID#',
            EmailID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EmailID#">,
            Location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Location#">,
            NewInstructions= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.formStruct.NewInstructions#">,
            NewDirections = <cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#arguments.formStruct.NewDirections#">,
            UpdatedByIp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
            StopType= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.StopType#">
			where CustomerStopID='#arguments.formStruct.editid#' 
			  
   </cfquery>
   <cfreturn "Stop has been Updated Successfully">	    	
</cffunction>

<!----Get All Stop Information---->
<cffunction name="getAllStop" access="public" output="false" returntype="any">
    <cfargument name="CustomerStopID" required="no" type="any">
         	<CFSTOREDPROC PROCEDURE="USP_GetStopDetails" DATASOURCE="#variables.dsn#"> 
				<cfif isdefined('arguments.CustomerStopID') and len(arguments.CustomerStopID)>
				 	<CFPROCPARAM VALUE="#arguments.CustomerStopID#" cfsqltype="CF_SQL_VARCHAR">  
				 <cfelse>
				 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
				 </cfif>
				 <CFPROCRESULT NAME="qrygetStops"> 
			</CFSTOREDPROC>
             <cfreturn qrygetStops>
</cffunction>

<!----Get All Stop Information By Customer---->
<cffunction name="getAllStopByCustomer" access="public" output="false" returntype="any">
    <cfargument name="CustomerID" required="no" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
         	<CFSTOREDPROC PROCEDURE="USP_GetStopDetailsByCustomer" DATASOURCE="#variables.dsn#"> 
				<cfif isdefined('arguments.CustomerID') and len(arguments.CustomerID)>
				 	<CFPROCPARAM VALUE="#arguments.CustomerID#" cfsqltype="CF_SQL_VARCHAR">  
				 <cfelse>
				 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
				 </cfif>
				 <CFPROCRESULT NAME="qrygetStops"> 
			</CFSTOREDPROC>
            
     <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
                    
                 <cfquery datasource="#variables.dsn#" name="getnewAgent">
                             select CustomerStops.*, Customers.CustomerName from CustomerStops
                             inner join Customers on Customers.CustomerID=CustomerStops.CustomerID
                             where 1=1
                             order by #arguments.sortby# #arguments.sortorder#;
                 </cfquery>
                           
                <cfreturn getnewAgent>               
                             
      </cfif>
            
<cfreturn qrygetStops>
</cffunction>



<!--- Get Shipper--->
<cffunction name="getShipper" access="public" output="false" returntype="any">
	<!---<CFSTOREDPROC PROCEDURE="USP_GetShippersFromLoadStopsTable" DATASOURCE="#variables.dsn#">
		 <CFPROCRESULT NAME="qryGetShipperFrmLoadStopsTable"> 
	</CFSTOREDPROC>--->
	
	<CFSTOREDPROC PROCEDURE="USP_GetShippersFromCustomersTable" DATASOURCE="#variables.dsn#">
		 <CFPROCRESULT NAME="qryGetShipperFrmCustomersTable"> 
	</CFSTOREDPROC>
	
	<!---<cfquery name="MergedQueries" dbtype="query">
		<!--- Select all from the first query. --->
		(
			SELECT
			*
			FROM
			qryGetShipperFrmLoadStopsTable
		)
	
		<!--- Union the two queries together. --->
		UNION
	
		<!--- Select all from the second query. --->
		(
			SELECT
			*
			FROM
			qryGetShipperFrmCustomersTable
		)
	</cfquery>
	
	
	<cfquery name="mergedQueriesDistinct" dbtype="query">
		SELECT MIN(CustomerID) AS CustomerID, CustomerName, Location, City, StateCode, zipCode
		FROM MergedQueries
		GROUP BY CustomerName, Location, City, StateCode, zipCode
	</cfquery>--->
	
	 <cfreturn qryGetShipperFrmCustomersTable>
	 
</cffunction>


<!--- Delete Stop--->
<cffunction name="deleteStop"  access="public" output="false" returntype="any">
<cfargument name="CustomerStopID" type="any" required="yes">
    <cftry>
    		<cfquery name="qryDelete" datasource="#variables.dsn#">
    			 DELETE FROM LoadStops WHERE LoadStopID='#arguments.CustomerStopID#'
    		</cfquery>
    		<cfreturn "Stop has been deleted successfully.">
    		<cfcatch type="any">
    			<cfreturn "Delete operation has been not successfull. This record is being used by other module.">
    		</cfcatch>
    	</cftry>
</cffunction>       

<!--- Search Stop --->
<cffunction name="getSearchedStop" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="searchStops" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.searchText') and len(arguments.searchText)>
		 	<CFPROCPARAM VALUE="#arguments.searchText#" cfsqltype="CF_SQL_VARCHAR">
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
		 </cfif>
		 <CFPROCRESULT NAME="QreturnSearch">
	</CFSTOREDPROC>
    <cfreturn QreturnSearch>
</cffunction>

<!--- Get State Id by state code--->
<cffunction name="getStatesID" access="remote" output="false" returntype="any">
    <cfargument name="stateCode" type="string" required="yes">
	<cfquery name="qrygetState" datasource="freightAgency">
      select stateID as stid from states 
      where statecode = '#arguments.stateCode#'
    </cfquery>
	 <cfreturn qrygetState.stid>   
</cffunction>
	<cffunction name="getAllpayerCustomers" access="public" output="false" returntype="any">
		<cfquery name="qryGetCustomers" datasource="#variables.dsn#">
			select * from  customers
			where IsPayer=<cfqueryparam cfsqltype="cf_sql_bit" value="1">
			and username IS NOT NULL and password IS NOT NULL
			order by CustomerName asc
		</cfquery>	
		<cfreturn qryGetCustomers>
	</cffunction>
</cfcomponent>