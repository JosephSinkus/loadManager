<cfcomponent output="false">
<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>
<!--- Get Carrier Offices --->
<cffunction name="getCarrierOffice" access="public" output="false" returntype="any">
    <cfargument name="carrierid" type="any" required="no">
	<CFSTOREDPROC PROCEDURE="USP_GetCarrierOfficeDetails" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('carrierid') and len(carrierid)>
		 	<CFPROCPARAM VALUE="#carrierid#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="qrygetcarrieroffice"> 
	</CFSTOREDPROC>
    <cfreturn qrygetcarrieroffice>
</cffunction>
<cffunction name="getAttachedFiles" access="public" returntype="query">
	<cfargument name="linkedid" type="string">
	<cfargument name="fileType" type="string">

	<cfquery name="getFilesAttached" datasource="#variables.dsn#">
		select * from FileAttachments where linked_id='#linkedid#' and linked_to='#filetype#'
	</cfquery>		
		
	<cfreturn getFilesAttached>	
</cffunction>
<!--- Add Carrier --->
<cffunction name="AddCarrier" access="public" output="false" returntype="any">
    <cfargument name="formStruct" type="struct" required="yes">
     <cfquery name="qryinsertcarrier" datasource="#variables.dsn#">
		 SET NOCOUNT ON
    insert into Carriers(CarrierName,MCNumber,Address,RegNumber,ContactPerson,TaxID,equipmentID,RemitName,RemitAddress,RemitCity,RemitState,
	RemitZipcode,RemitContact,RemitPhone,RemitFax,InsCompany,InsCompPhone,
    InsAgent,InsAgentPhone,InsPolicyNumber,InsExpDate,Track1099,InsLimit, 
	StateCode,
    ZipCode,EquipmentNotes,Status,CreatedBy,LastModifiedBy,CreatedDateTime,LastModifiedDateTime,
    City,country,phone,Fax,Cel,EmailID,website,TollFree,IsInsVerified,IsInsDate,IsContractVerified,IsW9,IsReferences,CreatedByIP,GUID,notes,CarrierTerms,VendorID,DOTNumber,SaferWatch,RiskAssessment)
	OUTPUT inserted.CarrierID 
    values(
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierName#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.MCNumber#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Address#">,            
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RegNumber#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ContactPerson#">,
           <!---<cfif arguments.formStruct.RatePerMile contains '$'>
		   		<cfqueryparam cfsqltype="cf_sql_real" value="#val(right(arguments.formStruct.RatePerMile,len(arguments.formStruct.RatePerMile)-1))#">,	
		   <cfelse>
	            <cfqueryparam cfsqltype="cf_sql_real" value="#val(arguments.formStruct.RatePerMile)#">,
		   </cfif>--->
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.TaxID#">,
           <cfif len(arguments.formStruct.equipment) lte 0>
              null,
           <cfelse>
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.equipment#">,
           </cfif>
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitName#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitAddress#">, 
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitCity#">,
			'#arguments.formStruct.RemitState#',
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitZipcode#">,
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitContact#">,
		   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitPhone#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitFax#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsCompany#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsComPhone#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsAgent#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsAgentPhone#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(arguments.formStruct.InsPolicyNo,49)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.InsExpDate#">,
           <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Track1099#">,
		  <!---  <cfif arguments.formStruct.InsLimit contains '$'>
		   		<cfqueryparam cfsqltype="cf_sql_real" value="#val(right(arguments.formStruct.InsLimit,len(arguments.formStruct.InsLimit)-1))#">,	
		   <cfelse>
	            <cfqueryparam cfsqltype="cf_sql_real" value="#val(arguments.formStruct.InsLimit)#">,
		   </cfif>--->
           <cfqueryparam cfsqltype="cf_sql_real" value="#LSParseCurrency(arguments.formStruct.InsLimit)#">,
		   <cfif listlen(arguments.formStruct.State) gt 0>'#listfirst(arguments.formStruct.State)#'<cfelse>'#arguments.formStruct.State#'</cfif>, 
		   
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentNotes#">,
            <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierInstructions#">,--->
           <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.formStruct.Status#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.City#">,
           <cfif len(arguments.formStruct.Country) lte 0>
            null,
           <cfelse>
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Country#">,
           </cfif>
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Phone#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Fax#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CellPhone#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Email#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Website#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Tollfree#">,
			<!---<cfif arguments.formStruct.CommRate contains '$'>
				<cfqueryparam cfsqltype="cf_sql_real" value="#val(right(arguments.formStruct.CommRate,len(arguments.formStruct.CommRate)-1))#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_real" value="#val(arguments.formStruct.CommRate)#">,
			</cfif>--->
			<cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.notes#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.terms#" null="#not len(arguments.formStruct.terms)#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.venderId#" null="#not len(arguments.formStruct.venderId)#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.DOTNumber#" null="#not len(arguments.formStruct.DOTNumber)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.risk_assessment#" null="#not len(arguments.formStruct.risk_assessment)#">
           )
     SET NOCOUNT OFF
 </cfquery>
 <cfset var i = 1>
 <cfloop list="#arguments.formStruct.numberOfCommodity#" index="index">
	 <cfset var carrRateComm = evaluate("arguments.formStruct.txt_carrRateComm_#i#") >
	 <cfset var custRateComm = evaluate("arguments.formStruct.txt_custRateComm_#i#") >
	 <cfset var commodityType = evaluate("arguments.formStruct.sel_commodityType_#i#") >
	 
	 <cfif carrRateComm contains '$'>
		<cfset carrRateComm = val(right(carrRateComm,len(carrRateComm)-1))>	
     <cfelse>
		<cfset carrRateComm = val(carrRateComm)>
	 </cfif>
	 
	 <cfif custRateComm contains '%'>
		<cfset custRateComm = val(left(custRateComm,len(custRateComm)-1))>	
     <cfelse>
		<cfset custRateComm = val(custRateComm)>
	 </cfif>
	 <cfquery name="qInsertCommodity" datasource="#variables.dsn#">
		INSERT INTO carrier_commodity(CARRIERID,carrrate,COMMODITYID,CarrRateOfCustTotal)
		VALUES(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryinsertcarrier.carrierId#">,
			<cfqueryparam value="#carrRateComm#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#commodityType#">,
			<cfqueryparam value="#custRateComm#">
		)
	 </cfquery>
	 <cfset i++ >
  </cfloop>
  <cfquery name="qryInsertLifmcaDetails" datasource="#variables.dsn#">
	   insert into lipublicfmcsa(InsuranceCompanyAddress,carrierId,ExpirationDate,DateCreated,commonStatus,contractStatus,BrokerStatus,commonAppPending,contractAppPending,BrokerAppPending,BIPDInsRequired,cargoInsRequired,BIPDInsonFile,cargoInsonFile,householdGoods,CARGOExpirationDate)
		values( 
				<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsuranceCompanyName#">,--->
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsuranceCompanyAddress#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryinsertcarrier.carrierId#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.formStruct.ExpirationDate#"  null="#yesNoFormat(NOT len(arguments.formStruct.ExpirationDate))#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonStatus#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractStatus#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerStatus#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonAppPending#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractAppPending#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerAppPending#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BIPDInsRequired#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.cargoInsRequired#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BIPDInsonFile#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.cargoInsonFile#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.householdGoods#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.formStruct.CARGOExpirationDate#" null="#yesNoFormat(NOT len(arguments.formStruct.CARGOExpirationDate))#">
				)
    </cfquery>
<cfreturn "Carrier has been added successfully.">
</cffunction>

<!--- Add Driver --->
<cffunction name="AddDriver" access="public" output="false" returntype="any">
  <cfargument name="formStruct" type="struct" required="yes">
  <cfquery name="qryinsertcarrier" datasource="#variables.dsn#">
    SET NOCOUNT ON
    insert into Carriers
    (
      CarrierName,MCNumber,Address,RegNumber,equipmentID,InsExpDate, 
      StateCode,
      ZipCode,EquipmentNotes,Status,CreatedBy,LastModifiedBy,CreatedDateTime,LastModifiedDateTime,
      City,country,phone,Fax,Cel,EmailID,TollFree,IsInsVerified,IsInsDate,IsContractVerified,IsW9,IsReferences,CreatedByIP,GUID,notes,CarrierTerms,
      licState,DOBDate,hiredDate,ss,employeeType,lastDrugTest,CDLExpires
    )
    OUTPUT inserted.CarrierID 
    values
    (
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierName#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.MCNumber#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Address#">,            
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RegNumber#">,
      <cfif len(arguments.formStruct.equipment) lte 0>
        null,
      <cfelse>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.equipment#">,
      </cfif>
      <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.InsExpDate#">,
      <cfif listlen(arguments.formStruct.State) gt 0>'#listlast(arguments.formStruct.State)#'<cfelse>'#arguments.formStruct.State#'</cfif>,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentNotes#">,
      <!---CarrierInstructions=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierInstructions#">,--->
      <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.formStruct.Status#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
      <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
      <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.City#">,
      <cfif len(arguments.formStruct.Country) lte 0>
        null,
      <cfelse>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Country#">,
      </cfif>
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Phone#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Fax#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CellPhone#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Email#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Tollfree#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="False">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.notes#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.terms#" null="#not len(arguments.formStruct.terms)#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.licState#">,
      <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.DOBDate#">,
      <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.hiredDate#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ss#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.employeeType#">,
      <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.lastDrugTest#">,
      <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.CDLExpires#">
    )
    SET NOCOUNT OFF
  </cfquery>
  <cfset var i = 1>
  <cfloop list="#arguments.formStruct.numberOfCommodity#" index="index">
    <cfset var carrRateComm = evaluate("arguments.formStruct.txt_carrRateComm_#i#") >
    <cfset var custRateComm = evaluate("arguments.formStruct.txt_custRateComm_#i#") >
    <cfset var commodityType = evaluate("arguments.formStruct.sel_commodityType_#i#") >

    <cfif carrRateComm contains '$'>
      <cfset carrRateComm = val(right(carrRateComm,len(carrRateComm)-1))> 
    <cfelse>
      <cfset carrRateComm = val(carrRateComm)>
    </cfif>

    <cfif custRateComm contains '%'>
      <cfset custRateComm = val(left(custRateComm,len(custRateComm)-1))>  
    <cfelse>
      <cfset custRateComm = val(custRateComm)>
    </cfif>
    <cfquery name="qInsertCommodity" datasource="#variables.dsn#">
      INSERT INTO carrier_commodity
      (
        CARRIERID,carrrate,COMMODITYID,CarrRateOfCustTotal
      )
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryinsertcarrier.carrierId#">,
        <cfqueryparam value="#carrRateComm#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#commodityType#">,
        <cfqueryparam value="#custRateComm#">
      )
    </cfquery>
    <cfset i++ >
  </cfloop>
  <cfreturn "Driver has been added successfully.">
</cffunction>

<!--- Add carrier Offices --->
<cffunction name="AddCarrierOffices" access="public" output="false" returntype="any">
   <cfargument name="formStruct" type="struct"  required="yes">
   <cfargument name="fieldID" type="any" required="yes">
        <cfquery name="getLastCarrierID" datasource="#variables.dsn#">
           select top 1 carrierID from carriers order by createddatetime desc
        </cfquery>
       <cfif isDefined("getLastCarrierID.recordcount") and getLastCarrierID.recordcount gt 0>
            <cfset carrierid=getLastCarrierID.carrierID>
        </cfif>
  
  <cfif isdefined("formStruct.Office_Name#arguments.fieldID#") and len('formStruct.Office_Name#arguments.fieldID#') gt 0>
      <cfset Office_Name=evaluate("arguments.formStruct.Office_Name#arguments.fieldID#")>
  </cfif>
  <cfif isdefined("formStruct.Office_Manager#arguments.fieldID#") and len('formStruct.Office_Manager#arguments.fieldID#') gt 0>
          <cfset Office_Manager=evaluate("arguments.formStruct.Office_Manager#arguments.fieldID#")>
  </cfif>
  <cfif isdefined("formStruct.Office_Phone#arguments.fieldID#") and len('formStruct.Office_Phone#arguments.fieldID#') gt 0>
         <cfset Office_Phone=evaluate("arguments.formStruct.Office_Phone#arguments.fieldID#")>
  </cfif>
  <cfif isdefined("formStruct.Office_Email#arguments.fieldID#") and len('formStruct.Office_Email#arguments.fieldID#') gt 0>
        <cfset Office_Email=evaluate("arguments.formStruct.Office_Email#arguments.fieldID#")>
  </cfif>
  <cfif isdefined("formStruct.Office_Fax#arguments.fieldID#") and len('formStruct.Office_Fax#arguments.fieldID#') gt 0>
        <cfset Office_Fax=evaluate("arguments.formStruct.Office_Fax#arguments.fieldID#")>
   </cfif> 
               
  <cfif len(Office_Name)>
         <cfquery name="qryinsertoffice" datasource="#variables.dsn#">
            insert into CarrierOffices(CarrierID,Location,Manager,PhoneNo,EmailID,Fax)
            values( '#getLastCarrierID.carrierID#',
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Manager#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Phone#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Email#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Fax#">
                    )
         </cfquery>  
</cfif>
<cfreturn "Carrier has been added successfully.">
</cffunction>
<!--- Get Carriers --->
<cffunction name="getAllCarriers" aceess="public" output="false" returntype="any">
    <cfargument name="carrierid" required="no" type="string">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
	<CFSTOREDPROC PROCEDURE="USP_GetCarrierDetails" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.carrierid') and len(arguments.carrierid)>
		 	<CFPROCPARAM VALUE="#arguments.carrierid#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="qrygetCarriers"> 
	</CFSTOREDPROC>
    
   <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
             
          <cfquery datasource="#variables.dsn#" name="getnewAgent">
                      select *, ISNULL(RatePerMile,0) AS RatePrMile  from Carriers
                      where 1=1
                      order by #arguments.sortby# #arguments.sortorder#;
          </cfquery>
                    
         <cfreturn getnewAgent>               
                      
    </cfif>
	
   <cfreturn qrygetCarriers>
</cffunction>



<!--- Get Carriers Info --->
<cffunction name="getCarriersInfo" access="public" output="false" returntype="query">
    <cfargument name="carrierid" required="yes">

	<cfquery name="qryGetCarrierInfo" datasource="#variables.dsn#">
        SELECT Carriers.CarrierName AS CarrierName, ISNULL(Carriers.RatePerMile,0) AS RatePerMile, Carriers.Address AS location, Carriers.City as city, Carriers.StateCode AS state, Carriers.ZipCode AS zip, Carriers.phone AS phone, carriers.fax as fax
		FROM Carriers
        <!--- INNER JOIN States ON Carriers.StateID = States.StateID --->
        <cfif arguments.carrierid eq ''> <!--- if the load does not have a carrier, use null as carrierid to return an empty query --->
        	WHERE CarrierID = null
        <cfelse>
        	WHERE CarrierID = <cfqueryparam value="#arguments.carrierid#" cfsqltype="cf_sql_varchar">
        </cfif>
    </cfquery>
    
    
   <cfreturn qryGetCarrierInfo>
</cffunction>

<!--- get Carrier Commodity By Id --->
<cffunction name="getCarrierCommodityById" access="remote" output="false" returntype="query">
    <cfargument name="carrierid" required="yes" type="string">
	<cfargument name="LoadStopID" required="yes" type="string">	
	<cfquery name="qGetCarrierCommodityById" datasource="#Application.dsn#">
        SELECT carrierid,carrrate,commodityid,CarrRateOfCustTotal,id
		FROM carrier_commodity
        WHERE carrierid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrierid#">        
    </cfquery>
   <cfreturn qGetCarrierCommodityById>
</cffunction>

<!---   Carrier --->
<cffunction name="UpdateCarrier" access="public" output="false" returntype="any">
 <cfargument name="formStruct" type="struct" required="yes">
 
 <cfquery name="qryupdate" datasource="#variables.dsn#">
	
     update Carriers 
     set CarrierName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierName#">,
         MCNumber= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.MCNumber#">,
         Address=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Address#">,            
         RegNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RegNumber#">,
         ContactPerson=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ContactPerson#">,
         <!---<cfif arguments.formStruct.RatePerMile contains '$'>
			RatePerMile= <cfqueryparam cfsqltype="cf_sql_real" value="#val(right(arguments.formStruct.RatePerMile,len(arguments.formStruct.RatePerMile)-1))#">,
		<cfelse>
	        RatePerMile= <cfqueryparam cfsqltype="cf_sql_real" value="#val(arguments.formStruct.RatePerMile)#">,
		</cfif>--->
         TaxID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.TaxID#">,
         <cfif len(arguments.formStruct.equipment) lte 0>
         equipmentID = null,
         <cfelse>
         equipmentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.equipment#">,
         </cfif>
		 RemitName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitName#">,
		 RemitAddress=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitAddress#">,  
		 RemitCity= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitCity#">, 
		 RemitState= '#arguments.formStruct.RemitState#',         
		 RemitZipcode=   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitZipcode#">,
		 RemitContact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitContact#">,
		 RemitPhone=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitPhone#">,
         RemitFax=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RemitFax#">,
         InsCompany= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsCompany#">,
         InsCompPhone= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsComPhone#">,
         InsAgent= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsAgent#">,
         InsAgentPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsAgentPhone#">,

         <!--- Somtimes the policy number comes in with a long string of text begining with 'A Licensing'. Test for it and do not save it. --->
         <cfif Left(#arguments.formStruct.InsPolicyNo#,11) neq 'A Licensing'>
         	InsPolicyNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsPolicyNo#">,
         <cfelse>
		 	InsPolicyNumber = Null,
         </cfif>
         
         InsExpDate= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.InsExpDate#">,
         Track1099= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Track1099#">,
<!---		<cfif arguments.formStruct.InsLimit contains '$'>
			InsLimit= <cfqueryparam cfsqltype="cf_sql_real" value="#val(right(arguments.formStruct.InsLimit,len(arguments.formStruct.InsLimit)-1))#">,
		<cfelse>
	        InsLimit= <cfqueryparam cfsqltype="cf_sql_real" value="#val(arguments.formStruct.InsLimit)#">,
		</cfif>--->
        
		InsLimit = <cfqueryparam cfsqltype="cf_sql_real" value="#LSParseCurrency(arguments.formStruct.InsLimit)#">,
        
         <!---
		 StateID= <cfif listlen(arguments.formStruct.State) gt 0>'#listfirst(arguments.formStruct.State)#'<cfelse>'#arguments.formStruct.State#'</cfif>, --->
		 
		  <!--- Yasir Turned ON--->
         StateCode = <cfif listlen(arguments.formStruct.State) gt 0>'#listlast(arguments.formStruct.State)#'<cfelse>'#arguments.formStruct.State#'</cfif>,
		 Zipcode=   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
         EquipmentNotes=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentNotes#">,
         <!---CarrierInstructions=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierInstructions#">,--->
         Status= <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.formStruct.Status#">,
         LastModifiedBy= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
         LastModifiedDateTime=<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
         City= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.City#">,
         Country= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Country#">,
         Phone=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Phone#">,
         Fax=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Fax#">,
         Cel=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CellPhone#">,
         EmailID=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Email#">,
         Website=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Website#">,
         Tollfree=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Tollfree#">,
		<!---<cfif arguments.formStruct.CommRate contains '$'>
			CommRate=<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(right(arguments.formStruct.CommRate,len(arguments.formStruct.CommRate)-1))#">,
		<cfelse>
         	CommRate=<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.CommRate)#">,
		</cfif>--->
         UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
		 notes =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.notes#">,
     CarrierTerms=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.terms#" null="#not len(arguments.formStruct.terms)#">,
		 VendorID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.venderId#" null="#not len(arguments.formStruct.venderId)#">,
     DOTNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.DOTNumber#" null="#not len(arguments.formStruct.DOTNumber)#">
	<cfif structKeyExists(arguments.formStruct,"bit_addWatch") AND arguments.formStruct.bit_addWatch GT 0 >
		,SaferWatch = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.bit_addWatch#" null="#not len(arguments.formStruct.bit_addWatch)#">
	<cfelse>
		,SaferWatch = 0
	</cfif>
	,RiskAssessment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.risk_assessment#" null="#not len(arguments.formStruct.risk_assessment)#">
      where CarrierID='#arguments.formStruct.editid#'
 </cfquery>

 <cfquery name="qDeleteCommodity" datasource="#variables.dsn#">
	DELETE FROM carrier_commodity 
	WHERE CARRIERID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">
 </cfquery>
 <cfset var i = 1>
 <cfloop list="#arguments.formStruct.numberOfCommodity#" index="index">
	 <cfset var carrRateComm = evaluate("arguments.formStruct.txt_carrRateComm_#i#") >
	 <cfset var custRateComm = evaluate("arguments.formStruct.txt_custRateComm_#i#") >
	 <cfset var commodityType = evaluate("arguments.formStruct.sel_commodityType_#i#") >
	 
	 <cfif carrRateComm contains '$'>
		<cfset carrRateComm = val(right(carrRateComm,len(carrRateComm)-1))>	
     <cfelse>
		<cfset carrRateComm = val(carrRateComm)>
	 </cfif>
	 
	 <cfif custRateComm contains '%'>
		<cfset custRateComm = val(left(custRateComm,len(custRateComm)-1))>	
     <cfelse>
		<cfset custRateComm = val(custRateComm)>
	 </cfif>
	 <cfquery name="qInsertCommodity" datasource="#variables.dsn#">
		INSERT INTO carrier_commodity(CARRIERID,carrrate,COMMODITYID,CarrRateOfCustTotal)
		VALUES(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">,
			<cfqueryparam value="#carrRateComm#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#commodityType#">,
			<cfqueryparam value="#custRateComm#">
		)
	 </cfquery>
	 <cfset i++ >
  </cfloop>
   <cfquery name="qryrecorExistsForlipublicfmcsa" datasource="#variables.dsn#">
		select * from  lipublicfmcsa
		where carrierId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">
   </cfquery>
   <cfif qryrecorExistsForlipublicfmcsa.recordcount>
		 <cfquery name="qryUpdateLifmcaDetails" datasource="#variables.dsn#">
		   update lipublicfmcsa 
			set 
			<!---InsuranceCompanyName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsuranceCompanyName#">,--->
			InsuranceCompanyAddress= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsuranceCompanyAddress#">,
			ExpirationDate=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.formStruct.ExpirationDate#"  null="#yesNoFormat(NOT len(arguments.formStruct.ExpirationDate))#">,
			DateModified=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			commonStatus=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonStatus#">,
			contractStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractStatus#">,
			BrokerStatus= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerStatus#">,
			commonAppPending= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonAppPending#">,
			contractAppPending=  <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractAppPending#">,
			BrokerAppPending=  <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerAppPending#">,
			BIPDInsRequired= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BIPDInsRequired#">,
			cargoInsRequired= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.cargoInsRequired#">,
			BIPDInsonFile=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BIPDInsonFile#">,
			cargoInsonFile= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.cargoInsonFile#">,
			householdGoods= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.householdGoods#">,
			CARGOExpirationDate= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.formStruct.CARGOExpirationDate#" null="#yesNoFormat(NOT len(arguments.formStruct.CARGOExpirationDate))#">
		where 
			carrierId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">
  </cfquery>
	<cfelse>
		 <cfquery name="qryInsertLifmcaDetails" datasource="#variables.dsn#">
		   insert into lipublicfmcsa(InsuranceCompanyAddress,carrierId,ExpirationDate,DateCreated,commonStatus,contractStatus,BrokerStatus,commonAppPending,contractAppPending,BrokerAppPending,BIPDInsRequired,cargoInsRequired,BIPDInsonFile,cargoInsonFile,householdGoods,CARGOExpirationDate)
			values( 
					<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsuranceCompanyName#">,--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.InsuranceCompanyAddress#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.formStruct.ExpirationDate#"  null="#yesNoFormat(NOT len(arguments.formStruct.ExpirationDate))#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonStatus#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractStatus#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerStatus#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonAppPending#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractAppPending#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerAppPending#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BIPDInsRequired#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.cargoInsRequired#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BIPDInsonFile#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.cargoInsonFile#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.householdGoods#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.formStruct.CARGOExpirationDate#" null="#yesNoFormat(NOT len(arguments.formStruct.CARGOExpirationDate))#">
					)
		</cfquery>
   </cfif>
 <cfreturn "Carrier has been updated successfully.">
</cffunction>

 <!--- Update Driver --->
  <cffunction name="UpdateDriver" access="public" output="false" returntype="any">
    <cfargument name="formStruct" type="struct" required="yes">
    <cfquery name="qryupdate" datasource="#variables.dsn#">
      update Carriers 
      set 
        CarrierName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierName#">,
        MCNumber= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.MCNumber#">,
        Address=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Address#">,            
        RegNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.RegNumber#">,
        <cfif len(arguments.formStruct.equipment) lte 0>
          equipmentID = null,
        <cfelse>
          equipmentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.equipment#">,
        </cfif>
        InsExpDate= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.InsExpDate#">,
        StateCode = <cfif listlen(arguments.formStruct.State) gt 0>'#listlast(arguments.formStruct.State)#'<cfelse>'#arguments.formStruct.State#'</cfif>,
        Zipcode=   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Zipcode#">,
        EquipmentNotes=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentNotes#">,
        <!---CarrierInstructions=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CarrierInstructions#">,--->
        Status= <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.formStruct.Status#">,
        LastModifiedBy= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
        LastModifiedDateTime=<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
        City= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.City#">,
        Country= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Country#">,
        Phone=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Phone#">,
        Fax=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Fax#">,
        Cel=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.CellPhone#">,
        EmailID=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Email#">,
        Tollfree=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Tollfree#">,
        UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
        notes =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.notes#">,
        CarrierTerms=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.terms#" null="#not len(arguments.formStruct.terms)#">,
        licState=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.licState#">,
        DOBDate=  <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.DOBDate#">,
        hiredDate=  <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.hiredDate#">,
        ss=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ss#">,
        employeeType=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.employeeType#">,
        lastDrugTest=  <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.lastDrugTest#">,
        CDLExpires = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.CDLExpires#">
      where 
        CarrierID='#arguments.formStruct.editid#'
    </cfquery>

    <cfquery name="qDeleteCommodity" datasource="#variables.dsn#">
      DELETE FROM carrier_commodity 
      WHERE CARRIERID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">
    </cfquery>
    <cfset var i = 1>
    <cfloop list="#arguments.formStruct.numberOfCommodity#" index="index">
      <cfset var carrRateComm = evaluate("arguments.formStruct.txt_carrRateComm_#i#") >
      <cfset var custRateComm = evaluate("arguments.formStruct.txt_custRateComm_#i#") >
      <cfset var commodityType = evaluate("arguments.formStruct.sel_commodityType_#i#") >

      <cfif carrRateComm contains '$'>
        <cfset carrRateComm = val(right(carrRateComm,len(carrRateComm)-1))> 
      <cfelse>
        <cfset carrRateComm = val(carrRateComm)>
      </cfif>

      <cfif custRateComm contains '%'>
        <cfset custRateComm = val(left(custRateComm,len(custRateComm)-1))>  
      <cfelse>
        <cfset custRateComm = val(custRateComm)>
      </cfif>
      <cfquery name="qInsertCommodity" datasource="#variables.dsn#">
        INSERT INTO carrier_commodity
        (
          CARRIERID,carrrate,COMMODITYID,CarrRateOfCustTotal
        )
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.editid#">,
          <cfqueryparam value="#carrRateComm#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#commodityType#">,
          <cfqueryparam value="#custRateComm#">
        )
      </cfquery>
      <cfset i++ >
    </cfloop>
    <cfreturn "Driver has been updated successfully.">
  </cffunction>

<!--- Update Carrier Offices --->
<cffunction name="UpdateCarrierOffices" access="public" output="false" returntype="any">
    <cfargument name="formStruct" type="struct"  required="yes">
    <cfargument name="fieldID" type="any" required="yes">
     
          <cfif isdefined("formStruct.CarrierOfficeID#arguments.fieldID#") and len('formStruct.CarrierOfficeID#arguments.fieldID#') gt 0>
             <cfset CarrierOfficeID=evaluate("arguments.formStruct.CarrierOfficeID#arguments.fieldID#")>
          </cfif>
          <cfif isdefined("formStruct.Office_Name#arguments.fieldID#") and len('formStruct.Office_Name#arguments.fieldID#') gt 0>
              <cfset Office_Name=evaluate("arguments.formStruct.Office_Name#arguments.fieldID#")>
          </cfif>
          <cfif isdefined("formStruct.Office_Manager#arguments.fieldID#") and len('formStruct.Office_Manager#arguments.fieldID#') gt 0>
                  <cfset Office_Manager=evaluate("arguments.formStruct.Office_Manager#arguments.fieldID#")>
          </cfif>
          <cfif isdefined("formStruct.Office_Phone#arguments.fieldID#") and len('formStruct.Office_Phone#arguments.fieldID#') gt 0>
                 <cfset Office_Phone=evaluate("arguments.formStruct.Office_Phone#arguments.fieldID#")>
          </cfif>
          <cfif isdefined("formStruct.Office_Email#arguments.fieldID#") and len('formStruct.Office_Email#arguments.fieldID#') gt 0>
                <cfset Office_Email=evaluate("arguments.formStruct.Office_Email#arguments.fieldID#")>
          </cfif>
          <cfif isdefined("formStruct.Office_Fax#arguments.fieldID#") and len('formStruct.Office_Fax#arguments.fieldID#') gt 0>
                <cfset Office_Fax=evaluate("arguments.formStruct.Office_Fax#arguments.fieldID#")>
          </cfif> 

       <!---  <cfquery name="chkCarrierOffices" datasource="#variables.dsn#">
            select top 1 CarrierID from CarrierOffices
            where CarrierID='#arguments.formStruct.editid#' and
              CarrierOfficeID='#CarrierOfficeID#'
        </cfquery>
       <cfoutput> #chkCarrierOffices.recordcount#</cfoutput>
     --->
   <!--- <cfif chkCarrierOffices.recordcount gt 0>
        --->
   <cfif len(CarrierOfficeID)  gt 1>
        
    <cfquery name="qryupdate" datasource="#variables.dsn#">
        update CarrierOffices
        set Location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Name#">,
            Manager=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Manager#">,
			PhoneNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Phone#">,
			EmailID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Email#">,
			Fax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Fax#">            		
        where CarrierID='#arguments.formStruct.editid#' and
              CarrierOfficeID='#CarrierOfficeID#'
    </cfquery>
    
    <cfelse>
    
      <cfquery name="qryinsert" datasource="#variables.dsn#">
           insert into CarrierOffices(CarrierID,Location,Manager,PhoneNo,EmailID,Fax)
            values( '#arguments.formStruct.editid#',
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Manager#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Phone#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Email#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Office_Fax#">
                    )
      </cfquery>
      
    </cfif>
   
</cffunction>
<!--- Delete Carrier --->
<cffunction name="deleteCarriers" access="public" returntype="any">
    <cfargument name="CarrierID" type="any" required="yes">
    <cftry>
    <cfquery name="qrydelete" datasource="#variables.dsn#">
        delete from Carriers
        where CarrierID='#arguments.CarrierID#'
    </cfquery>
    <cfreturn "1">
    <cfcatch type="any">
        <cfreturn "0">
    </cfcatch>
    </cftry>
</cffunction>
<!--- Delete Carrier Offices --->
<cffunction name="deleteCarriersoffices" access="public" returntype="any">
    <cfargument name="CarrierID" type="any" required="yes">
        <cftry>
        <cfquery name="qrydelete" datasource="#variables.dsn#">
            delete from CarrierOffices
            where CarrierID='#arguments.CarrierID#'
        </cfquery>
        <cfreturn "Record has been deleted successfully.">
        <cfcatch type="any">
            <cfreturn "Deletion is not allowed because data is active in other records. ">
        </cfcatch>
        </cftry>  
</cffunction>

<cffunction name="deleteCarrierLipublicfmcsa" access="public" returntype="any">
    <cfargument name="CarrierID" type="any" required="yes">
        <cftry>
        <cfquery name="qrydelete" datasource="#variables.dsn#">
            delete from lipublicfmcsa
            where carrierId= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CarrierID#">
        </cfquery>
        <cfreturn "Record has been deleted successfully.">
        <cfcatch type="any">
            <cfreturn "Deletion is not allowed because data is active in other records. ">
        </cfcatch>
        </cftry>  
</cffunction>
<!--- Get Search Agent --->
<cffunction name="getSearchedCarrier" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
    <cfargument name="pageNo" required="yes" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">


    <cfif not isdefined('arguments.searchText')>
		<cfset arguments.searchText = "">
	</cfif>
    
    <cfif not isdefined('arguments.pageNo')>
		<cfset arguments.pageNo = 1>
	</cfif>
    
    <cfif not isdefined('arguments.sortorder')>
		<cfset arguments.sortorder = "ASC">
	</cfif>
    
    <cfif not isdefined('arguments.sortby')>
		<cfset arguments.sortby = "CarrierName">
	</cfif>
    

	<!---<CFSTOREDPROC PROCEDURE="searchCarrier" DATASOURCE="#variables.dsn#"> 
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
		 	<CFPROCPARAM VALUE="UPPER(#arguments.sortby#)" cfsqltype="cf_sql_varchar"> 
		 <cfelse>
		 	<CFPROCPARAM VALUE="UPPER(CarrierName)" cfsqltype="cf_sql_varchar">  
		 </cfif>
         
		 <CFPROCRESULT NAME="QreturnSearch"> 
	</CFSTOREDPROC>--->
    
	<!---<cfif isdefined('arguments.sortorder') AND len(arguments.sortorder) AND isdefined('arguments.sortby') AND len(arguments.sortby)>--->
		<cfquery name="QreturnSearch" datasource="#variables.dsn#">
			WITH page AS (
				select carriers.*,<!--- States.StateCode AS StateCode1 ,---> ROW_NUMBER() OVER (ORDER BY 
					UPPER(#arguments.sortby#) #arguments.sortorder#
				) AS Row
			from carriers <!--- INNER JOIN States ON States.StateID = carriers.stateID --->
			where 
				CarrierName like '%#arguments.searchText#%'
				or MCNumber like '%#arguments.searchText#%'
				or carriers.Address like '%#arguments.searchText#%'
				or City like '%#arguments.searchText#%'
				or Zipcode like '%#arguments.searchText#%'
				or Phone like '%#arguments.searchText#%'
				or EmailID like '%#arguments.searchText#%'
				or Website like '%#arguments.searchText#%'
        or StateCode like '%#arguments.searchText#%' 
				or DOTNumber like '%#arguments.searchText#%' 
				or Notes like '%#arguments.searchText#%' )
			 SELECT * FROM page WHERE Row between (#pageNo# - 1) * 30 + 1 and #pageNo#*30
		</cfquery>
    <!---</cfif>--->
    <cfreturn QreturnSearch>
</cffunction> 


<!--- Filter carriers starts here --->
<cffunction name="getFilteredCarrier" access="public" output="false" returntype="query">
	
    
    <cfargument name="pageNo" required="yes" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
    <cfargument name="insexp" required="yes" type="any">
    <cfargument name="shippercity" required="yes" type="any">
    <cfargument name="shipperstate" required="yes" type="any">
    <cfargument name="shipperZipcode" required="yes" type="any">
    <cfargument name="consigneecity" required="yes" type="any">
    <cfargument name="consigneestate" required="yes" type="any">
    <cfargument name="consigneeZipcode" required="yes" type="any">

	<cfif not isdefined('arguments.pageNo')>
		<cfset arguments.pageNo = 1>
	</cfif>
    
    <cfif not isdefined('arguments.sortorder')>
		<cfset arguments.sortorder = "ASC">
	</cfif>
    
    <cfif not isdefined('arguments.sortby')>
		<cfset arguments.sortby = "CarrierName">
	</cfif>
    
		<cfquery name="QreturnSearch" datasource="#variables.dsn#">
			WITH page AS (
				select carriers.*, ROW_NUMBER() OVER (ORDER BY 
					UPPER(#arguments.sortby#) #arguments.sortorder#
				) AS Row
			from carriers 
			where 1=1 AND
            		(
                    <cfif isdefined('arguments.insexp') and #arguments.insexp# eq 1 >
						INSEXPDATE <= '#DateFormat(Now())#'
                        AND 
					</cfif>
                        ( 1=1
                         <cfif isdefined('arguments.consigneecity') and trim(Len(#arguments.consigneecity#)) gt 1 >
                            AND City = '#arguments.consigneecity#'
                         </cfif>
                         <cfif isdefined('arguments.consigneestate') and trim(Len(#arguments.consigneestate#)) gt 1 >
                            AND STATECODE = '#arguments.consigneestate#'
                         </cfif>
                         <cfif isdefined('arguments.consigneeZipcode') and trim(Len(#arguments.consigneeZipcode#)) gt 1 >
                            AND Zipcode = '#arguments.consigneeZipcode#'
                         </cfif>
                         <cfif (isdefined('arguments.shippercity') and trim(Len(#arguments.shippercity#)) gt 1) OR (isdefined('arguments.shipperstate') and trim(Len(#arguments.shipperstate#)) gt 1) OR (isdefined('arguments.shipperZipcode') and trim(Len(#arguments.shipperZipcode#)) gt 1 ) >
                            OR 1=1
                         </cfif>
                         <cfif isdefined('arguments.shippercity') and trim(Len(#arguments.shippercity#)) gt 1 >
                            AND City = '#arguments.shippercity#'
                         </cfif>
                         <cfif isdefined('arguments.shipperstate') and trim(Len(#arguments.shipperstate#)) gt 1 >
                            AND STATECODE = '#arguments.shipperstate#'
                         </cfif>
                         <cfif isdefined('arguments.shipperZipcode') and trim(Len(#arguments.shipperZipcode#)) gt 1 >
                            AND Zipcode = '#arguments.shipperZipcode#'
                         </cfif>
                        )
                    )

                	<!---AND
                	EQUIPMENTID = '#url.equipment#'--->
                           
                )
			 SELECT * FROM page WHERE Row between (#pageNo# - 1) * 30 + 1 and #pageNo#*30 
 
		</cfquery>
    	
    <cfreturn QreturnSearch>

</cffunction>

<!--- Filter carriers ends here --->


         
<!--- Add LI Web Site Data--->
<cffunction name="AddLIWebsiteData" access="public" output="false" returntype="any">
	<cfargument name="formStruct" required="yes" type="struct">
		<cfquery name="getLastCarrierID" datasource="#variables.dsn#">
           select top 1 carrierID from carriers order by createddatetime desc
        </cfquery>
       <cfif isDefined("getLastCarrierID.recordcount") and getLastCarrierID.recordcount gt 0>
            <cfset carrierid=getLastCarrierID.carrierID>
        </cfif>
	   <cfquery name="AddLIData" datasource="#variables.dsn#">	
	    insert into carriersLNI (CarrierID,DOTCommonAuthorityStatus,DOTContractAuthorityStatus,DOTBrokerAuthorityStatus
	    ,DOTCommonAppPending,DOTContractAppPending,DOTBrokerAppPending,InsLiabilities,InsOnFileLiabilities,InsCargo,InsOnFileCargo,CargoAuthHouseHold
	    ,ChangedDate,RefreshedDate)
	    values('#carrierid#','#session.AuthType_Common_status#','#session.AuthType_Contract_status#','#session.AuthType_Broker_status#',
	    		'#session.AuthType_Common_appPending#','#session.AuthType_Contract_appPending#','#session.AuthType_Broker_appPending#',
	    		'#session.bipd_Insurance_required#','#session.bipd_Insurance_on_file#','#session.cargo_Insurance_required#',
	    		'#session.cargo_Insurance_on_file#','#session.household_goods#',#now()#,#now()#)
	   </cfquery>
</cffunction> 

<!--- Add LI Web Site Data--->
<cffunction name="EditLIWebsiteData" access="public" output="false" returntype="any">
	<cfargument name="CarrierID" required="yes" type="any">
	   <cfquery name="AddLIData" datasource="#variables.dsn#">	
	    update carriersLNI set 
	    DOTCommonAuthorityStatus = '#session.AuthType_Common_status#'
	    ,DOTContractAuthorityStatus = '#session.AuthType_Contract_status#'
	    ,DOTBrokerAuthorityStatus = '#session.AuthType_Broker_status#'
	    ,DOTCommonAppPending = '#session.AuthType_Common_appPending#'
	    ,DOTContractAppPending = '#session.AuthType_Contract_appPending#'
	    ,DOTBrokerAppPending = '#session.AuthType_Broker_appPending#'
	    ,InsLiabilities = '#session.bipd_Insurance_required#'
	    ,InsOnFileLiabilities = '#session.bipd_Insurance_on_file#'
	    ,InsCargo = '#session.cargo_Insurance_required#'
	    ,InsOnFileCargo ='#session.cargo_Insurance_on_file#'
	    ,CargoAuthHouseHold = '#session.household_goods#'
	    ,RefreshedDate = #now()#
		    where carrierID = '#arguments.CarrierID#'
	   </cfquery>
	<cfreturn 'LI Web site data has been updated successfully.'>
</cffunction> 
         
<!--- Get LI Web Site Data--->
<cffunction name="getLIWebsiteData" access="public" output="false" returntype="query">	
	<cfargument name="CarrierID" required="yes" type="any">
	   <cfquery name="getLIData" datasource="#variables.dsn#">	
		 select * from CarriersLNI where carrierId = '#arguments.CarrierID#'
	   </cfquery>
    <cfreturn getLIData>
</cffunction> 


<!--- get commodity by carrier id --->
<cffunction name="getCommodityById" access="public" output="false" returntype="query">
	<cfargument name="carrierID" required="yes" type="string">
	<cfquery name="qGetCommodityById" datasource="#variables.dsn#">	
		select CARRIERID,carrrate,COMMODITYID,CarrRateOfCustTotal,ID
		from carrier_commodity 
		where CARRIERID = '#arguments.CarrierID#'
	</cfquery>
	<cfreturn qGetCommodityById >
</cffunction> 
<!---update lifmca details--->
<cffunction name="UpdatelifmcaDetails" access="public" output="false" returntype="query">
    <cfargument name="formStruct" type="struct"  required="yes">
      <cfquery name="qryUpdateLifmcaDetails" datasource="#variables.dsn#">
           update lipublicfmcsa 
			set 
			<!---InsuranceCompanyName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#argument.formStruct.InsuranceCompanyName#">,--->
			InsuranceCompanyAddress= <cfqueryparam cfsqltype="cf_sql_varchar" value="#argument.formStruct.InsuranceCompanyAddress#">,
			ExpirationDate=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#argument.formStruct.ExpirationDate#" null="#yesNoFormat(NOT len(arguments.formStruct.ExpirationDate))#">,
			DateModified=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			commonStatus=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonStatus#">,
			contractStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractStatus#">,
			BrokerStatus= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerStatus#">,
			commonAppPending= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.commonAppPending#">,
			contractAppPending=  <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.contractAppPending#">,
			BrokerAppPending=  <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BrokerAppPending#">,
			BIPDInsRequired= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.BIPDInsRequired#">,
			cargoInsRequired= <cfqueryparam cfsqltype="cf_sql_bit" value="#session.adminUserName#">,
			BIPDInsonFile=<cfqueryparam cfsqltype="cf_sql_bit" value="#Now()#">,
			cargoInsonFile= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.City#">,
			householdGoods= <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Country#">
		where 
			carrierId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.carrierId#">
      </cfquery>
	  <cfreturn 'LI Web site data has been updated successfully.'>
</cffunction>
<!---get lifmcaDetails--->
<cffunction name="getlifmcaDetails" access="public" output="false" returntype="query">
    <cfargument name="carrierid" type="string"  required="yes">
      <cfquery name="qrygetlifmcaDetails" datasource="#variables.dsn#">
           select * from lipublicfmcsa 
			where carrierId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrierId#">
      </cfquery>
	  <cfreturn qrygetlifmcaDetails>
</cffunction>

<!--- add watch --->
	<cffunction name="AddWatch" access="public"  returntype="any">
		<cfargument name="DOTNumber" type="string"  default="0">
		<cfargument name="MCNumber" type="string"  default="0">
		<cfif arguments.DOTNumber GT 0 >
			<cfset variables.number = arguments.DOTNumber >
		<cfelseif arguments.MCNumber GT 0 >
			<cfset variables.number = arguments.MCNumber >
		<cfelse>
			<cfset variables.number = 0>
		</cfif>
		<cfquery name="qSystemSetupOptions" datasource="#variables.dsn#">
	    	SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey    
			FROM SystemConfig
	    </cfquery>
		<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=AddWatch&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
		</cfhttp>	
		<cfif cfhttp.Statuscode EQ '200 OK'>	
			<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>
			<cfreturn variables.resStruct.ResponseDO.displayMsg>
		<cfelse>
			<cfreturn "Not added to watch.">
		</cfif>
	</cffunction>
	
	<cffunction name="getCarrier" access="public"  returntype="any">
		<cfargument name="carrierid" type="string"  default="0">
		<cfquery name="qgetCarrier" datasource="#variables.dsn#">
	    	 SELECT DOTNumber,MCNumber FROM carriers WHERE  CarrierID = '#arguments.carrierid#'
	    </cfquery>
		<cfreturn qgetCarrier>
	</cffunction>
<!--- Remove  watch --->
	<cffunction name="RemoveWatch" access="public"  returntype="any">
		<cfargument name="DOTNumber" type="string"  default="0">
		<cfargument name="MCNumber" type="string"  default="0">
		<cfif arguments.DOTNumber GT 0 >
			<cfset variables.number = arguments.DOTNumber >
		<cfelseif arguments.MCNumber GT 0 >
			<cfset variables.number = arguments.MCNumber >
		<cfelse>
			<cfset variables.number = 0>
		</cfif>
		<cfquery name="qSystemSetupOptions" datasource="#variables.dsn#">
	    	SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey    
			FROM SystemConfig
	    </cfquery>
		<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=RemoveWatch&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
		</cfhttp>	
		<cfif cfhttp.Statuscode EQ '200 OK'>	
			<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>
			<cfreturn variables.resStruct.ResponseDO.displayMsg>
		<cfelse>
			<cfreturn "Unable to remove watch.">
		</cfif>
	</cffunction>
	
	<!--- Carrier Lookup--->
	<cffunction name="CarrierRiskAssessment" access="public"  returntype="any">
		<cfargument name="DOTNumber" type="string"  default="0">
		<cfargument name="MCNumber" type="string"  default="0">
		<cfset risk_assessment = "" >
		<cfif arguments.DOTNumber GT 0 >
			<cfset variables.number = arguments.DOTNumber >
		<cfelseif arguments.MCNumber GT 0 >
			<cfset variables.number = arguments.MCNumber >
		<cfelse>
			<cfset variables.number = 0>
		</cfif>
		<cfquery name="qSystemSetupOptions" datasource="#variables.dsn#">
	    	SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey    
			FROM SystemConfig
	    </cfquery>
		<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=CarrierLookup&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
		</cfhttp>	
		<cfif cfhttp.Statuscode EQ '200 OK'>	
			<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>
			<cfif structKeyExists(variables.resStruct ,"CarrierDetails") AND variables.resStruct.CarrierDetails.dotNumber EQ  arguments.DOTNumber AND variables.resStruct.CarrierDetails.docketNumber EQ arguments.MCNumber AND structKeyExists(variables.resStruct .CarrierDetails,"RiskAssessment") AND structKeyExists(variables.resStruct .CarrierDetails.RiskAssessment,"Overall")  >
				<cfset risk_assessment = variables.resStruct .CarrierDetails.RiskAssessment.Overall>
			</cfif>			
		<cfelse>
			<cfreturn "">
		</cfif>
		<cfreturn risk_assessment>
	</cffunction>	
	
	<!--- Carrier Lookup--->
	<cffunction name="CarrierLookup" access="public"  returntype="any">
		<cfargument name="DOTNumber" type="string"  default="0">
		<cfargument name="MCNumber" type="string"  default="0">
		<cfset risk_assessment = "" >
		<cfif arguments.DOTNumber GT 0 >
			<cfset variables.number = arguments.DOTNumber >
		<cfelseif arguments.MCNumber GT 0 >
			<cfset variables.number = arguments.MCNumber >
		<cfelse>
			<cfset variables.number = 0>
		</cfif>
		<cfquery name="qSystemSetupOptions" datasource="#variables.dsn#">
	    	SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey    
			FROM SystemConfig
	    </cfquery>
		<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=CarrierLookup&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
		</cfhttp>	
		<cfif cfhttp.Statuscode EQ '200 OK'>	
			<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>
			<cfif structKeyExists(variables.resStruct ,"CarrierDetails") AND structKeyExists(variables.resStruct .CarrierDetails,"RiskAssessment") AND structKeyExists(variables.resStruct .CarrierDetails.RiskAssessment,"Overall")  >
				<cfset risk_assessment = variables.resStruct >
			</cfif>			
		<cfelse>
			<cfreturn "">
		</cfif>
		<cfreturn risk_assessment>
	</cffunction>
	
	<cffunction name="UpdateWatchList" access="public"  returntype="any">
		<cfargument name="DOTNumber" type="string"  default="0">
		<cfargument name="MCNumber" type="string"  default="0">
		<cfargument name="SaferWatch" type="string"  default="0">
		<cfargument name="bit_addWatch" type="string"  default="0">
		<cfargument name="editid" type="string"  default="0">
		<cfquery name="qCarrier" datasource="#variables.dsn#">
	    	SELECT SaferWatch
			FROM Carriers
			WHERE CarrierID = '#arguments.editid#'
	    </cfquery>
		 <cfif StructKeyExists(arguments,"SaferWatch") AND  arguments.SaferWatch EQ 1 >
			<cfif StructKeyExists(arguments,"bit_addWatch") AND arguments.bit_addWatch EQ 1 AND qCarrier.SaferWatch EQ 0 >
				<cfinvoke component="#variables.objCarrierGateway#" method="AddWatch" returnvariable="message">
					<cfinvokeargument name="DOTNumber" value="#arguments.DOTNumber#">
					<cfinvokeargument name="MCNumber" value="MC#arguments.MCNumber#">
				</cfinvoke>
			<cfelseif  qCarrier.SaferWatch EQ 1 AND  NOT StructKeyExists(arguments,"bit_addWatch")>
				<cfinvoke component="#variables.objCarrierGateway#" method="RemoveWatch" returnvariable="message">
					<cfinvokeargument name="DOTNumber" value="#arguments.DOTNumber#">
					<cfinvokeargument name="MCNumber" value="MC#arguments.MCNumber#">
				</cfinvoke>
			</cfif>						
		 </cfif>
	</cffunction>
	
	<cffunction name="ConvertXmlToStruct" access="public" returntype="struct" output="true"  hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
		<cfargument name="xmlNode" type="string" required="true" />
		<cfargument name="str" type="struct" required="true" />		
		<cfset var i 							= 0 />
		<cfset var axml						= arguments.xmlNode />
		<cfset var astr						= arguments.str />
		<cfset var n 							= "" />
		<cfset var tmpContainer 	= "" />

		<cfset axml = XmlSearch(XmlParse(arguments.xmlNode),"/node()")>
		<cfset axml = axml[1] />
		
		<cfloop from="1" to="#arrayLen(axml.XmlChildren)#" index="i">			
			<cfset n = replace(axml.XmlChildren[i].XmlName, axml.XmlChildren[i].XmlNsPrefix&":", "") />			
			<cfif structKeyExists(astr, n)>				
				<cfif not isArray(astr[n])>					
					<cfset tmpContainer = astr[n] />					
					<cfset astr[n] = arrayNew(1) />					
					<cfset astr[n][1] = tmpContainer />
				<cfelse>				
				</cfif>
				
				<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>						
						<cfset astr[n][arrayLen(astr[n])+1] = ConvertXmlToStruct(axml.XmlChildren[i], structNew()) />
				<cfelse>						
						<cfset astr[n][arrayLen(astr[n])+1] = axml.XmlChildren[i].XmlText />
				</cfif>
			<cfelse>				
				<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>				
					<cfset astr[n] = ConvertXmlToStruct(axml.XmlChildren[i], structNew()) />
				<cfelse>
					<cfif IsStruct(aXml.XmlAttributes) AND StructCount(aXml.XmlAttributes)>
						<cfset at_list = StructKeyList(aXml.XmlAttributes)>
						<cfloop from="1" to="#listLen(at_list)#" index="atr">
							 <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">								 
								<cfset Structdelete(axml.XmlAttributes, listgetAt(at_list,atr))>
							 </cfif>
						 </cfloop>						
						 <cfif StructCount(axml.XmlAttributes) GT 0>
							 <cfset astr['_attributes'] = axml.XmlAttributes />
						</cfif>
					</cfif>					
					<cfif IsStruct(aXml.XmlChildren[i].XmlAttributes) AND StructCount(aXml.XmlChildren[i].XmlAttributes) GT 0>						
						<cfset astr[n] = axml.XmlChildren[i].XmlText />						
						 <cfset attrib_list = StructKeylist(axml.XmlChildren[i].XmlAttributes) />
						 <cfloop from="1" to="#listLen(attrib_list)#" index="attrib">
							 <cfif ListgetAt(attrib_list,attrib) CONTAINS "xmlns:">							
								<cfset Structdelete(axml.XmlChildren[i].XmlAttributes, listgetAt(attrib_list,attrib))>
							 </cfif>
						 </cfloop>						 
						 <cfif StructCount(axml.XmlChildren[i].XmlAttributes) GT 0>
							 <cfset astr[n&'_attributes'] = axml.XmlChildren[i].XmlAttributes />
						</cfif>
					<cfelse>
						 <cfset astr[n] = axml.XmlChildren[i].XmlText />
					</cfif>
				</cfif>
			</cfif>
		</cfloop>		
		<cfreturn astr />
	</cffunction>
</cfcomponent>
