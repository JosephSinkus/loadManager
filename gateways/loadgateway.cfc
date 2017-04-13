<cfcomponent output="true">
<!--- <cfsetting showdebugoutput="false"> --->

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="yes" />
		<cfset variables.dsn = Application.dsn />
	</cffunction>

	<!--- Get current Agent --->
	<cffunction name="getcurAgentdetails" access="public" returntype="query">
		<cfargument name="employeID" required="yes" type="string">
		<cfquery name="qcurAgentdetails" datasource="#variables.dsn#">
	    	SELECT integratewithTran360,trans360Usename,trans360Password,IntegrationID, PCMilerUsername, PCMilerPassword,loadBoard123,loadBoard123Usename,loadBoard123Password,proMilesStatus,companyCode,RoleID
	        FROM Employees
	        WHERE EmployeeID = <cfqueryparam value="#arguments.employeID#" cfsqltype="cf_sql_varchar">
	    </cfquery>
	    <cfreturn qcurAgentdetails>
	</cffunction>

	<cffunction name="getcurAgentMaildetails" access="public" returntype="query">
		<cfargument name="employeID" required="yes" type="string">
		<cfquery name="qcurAgentdetails" datasource="#variables.dsn#">
	    	SELECT Name, EmailID, SmtpAddress, SmtpUsername, SmtpPassword, SmtpPort, useTLS, useSSL,emailSignature
	        FROM Employees
	        WHERE EmployeeID = '#employeID#'
	    </cfquery>
	    <cfreturn qcurAgentdetails>
	</cffunction>

	<!--- Get Load Status--->
	<cffunction name="getLoadStatus" access="public" returntype="query">
		<cfargument name="LoadStatusID" required="No" type="any">
		<CFSTOREDPROC PROCEDURE="USP_GetStatus" DATASOURCE="#variables.dsn#"> 
			<cfif isdefined('arguments.LoadStatusID') and len(arguments.LoadStatusID)>
		 	<CFPROCPARAM VALUE="#arguments.LoadStatusID#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
			 <CFPROCRESULT NAME="qrygetstatus"> 
		</CFSTOREDPROC>
	    <cfreturn qrygetstatus>
	</cffunction>

	<!--- Get Load StatusTypeText self defined --->
	<cffunction name="getLoadStatusTypes" access="public" returntype="query">
	   	<cfquery name="qryGetLoadStatusTypes" datasource="#variables.dsn#">
			SELECT statustypeid,statustext,colorCode
			FROM LoadStatusTypes 
			ORDER BY statustext
		</cfquery>
		<cfreturn qryGetLoadStatusTypes>	
	</cffunction>
	
	<!--- Get Load StatusTypeID --->
	<cffunction name="getLoadStatusTypeId" access="public" returntype="query">
		<cfargument name="LoadStatus" required="yes" type="string">
		<cfquery name="qrygetstatusTypeID" datasource="#variables.dsn#">
	    	SELECT StatusTypeID
	        FROM LoadStatusTypes
	        WHERE StatusText = #LoadStatus#
	    </cfquery>
	    <cfreturn qrygetstatusTypeID>
	</cffunction>

	<!--- Get Load Details for report--->

	<cffunction name="getCarrierReportInfoFromLoad" access="public" returntype="query">
		<cfargument name="LoadID" required="yes" type="any">
		<CFSTOREDPROC PROCEDURE="USP_GetReportInfoFromLoad" DATASOURCE="#variables.dsn#"> 
		 	<CFPROCPARAM VALUE="#arguments.LoadID#" cfsqltype="CF_SQL_VARCHAR">  
	        
	        <CFPROCRESULT NAME="qrygetstatus"> 
		</CFSTOREDPROC>
	    <cfreturn qrygetstatus>
	</cffunction>

	<!--- Get Cutomer Info--->

	<cffunction name="getAjaxLoadCustomerInfo1" access="remote" output="yes">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="customerID" required="No" type="any">
		<cfargument name="urlToken" required="no" type="any">
		<!--- call SP to Get a Customer Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCustomerinfoForLoad" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.CustomerID') and len(arguments.CustomerID)>
			 	<CFPROCPARAM VALUE="#arguments.CustomerID#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetcustomers"> 
		</CFSTOREDPROC>
		<!--- call SP to Get Customer Info--->
		<!---<CFSTOREDPROC PROCEDURE="USP_GetCustomerDetails" DATASOURCE="#arguments.dsn#"> 
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
				<CFPROCRESULT NAME="qrygetAllcustomers"> 
		</CFSTOREDPROC>--->
		 
		<cfsavecontent variable="customerInfoForm">
			<cfoutput>
				<input name="customerID" type="hidden" value="#arguments.CustomerID#" />
				<input name="customerAddress" id="customerAddress" type="hidden" value="#qrygetcustomers.location#"/>
				<input name="customerCity" id="customerCity" type="hidden" value="#qrygetcustomers.city#"/>
				<input name="customerState" id="customerState" type="hidden" value="#qrygetcustomers.stateCode#"/>
				<input name="customerZipCode" id="customerZipCode" type="hidden" value="#qrygetcustomers.zipCode#"/>
				<input name="customerContact" id="customerContact" type="hidden" value="#qrygetcustomers.ContactPerson#"/>
				<input name="customerPhone" id="customerPhone" type="hidden" value="#qrygetcustomers.TEL#"/>
				<input name="customerCell" id="customerCell" type="hidden" value="#qrygetcustomers.Cel#"/>
				<input name="customerFax" id="customerFax" type="hidden" value="#qrygetcustomers.Fax#"/>
				
				<label class="field-textarea" style="width:188px;"><b><a href="index.cfm?event=addcustomer&customerid=#arguments.CustomerID#&#arguments.urlToken#" style="color:##4322cc;text-decoration:underline;">#qrygetcustomers.custname#</a></b><br/> #qrygetcustomers.location# <br/>
				#qrygetcustomers.City# , #qrygetcustomers.stateCode# <br/>#qrygetcustomers.ZIPCODE#</label>
				<div class="clear"></div>
				<label>Contact</label><label class="field-text">#qrygetcustomers.ContactPerson#</label>
				<div class="clear"></div>
				<label>Tel</label>
				<label class="field-text" style="width:100px;">#qrygetcustomers.TEL#</label>
				<!--- <div class="clear"></div> --->
				<label style="width:31px;">Cell</label>
				<label class="field-text"  style="width:100px;">#qrygetcustomers.Cel#</label>
				<div class="clear"></div>
				<!--- <label>Fax</label>
				<label class="field-text">#qrygetcustomers.fax#</label> --->
				<div class="clear"></div>
				<label>Email</label>
				<label class="emailbox" style="width:247px;">#qrygetcustomers.Email#</label>
			</cfoutput>
		</cfsavecontent>
		#customerInfoForm#
	</cffunction>

	<cffunction name="getAjaxLoadCustomerInfo2" access="remote" output="yes">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="customerID" required="No" type="any">
		<!--- call SP to Get a Customer Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCustomerinfoForLoad" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.CustomerID') and len(arguments.CustomerID)>
			 	<CFPROCPARAM VALUE="#arguments.CustomerID#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetcustomers"> 
		</CFSTOREDPROC>
		<!--- call SP to Get Customer Info--->
		<!---<CFSTOREDPROC PROCEDURE="USP_GetCustomerDetails" DATASOURCE="#arguments.dsn#"> 
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
				<CFPROCRESULT NAME="qrygetAllcustomers"> 
		</CFSTOREDPROC>--->
		
		<cfsavecontent variable="customerInfoForm">
			<cfoutput>
			<!---<div class="form-con">--->
				<fieldset>
					<!---<label>Credit Limit</label>
					<label class="field-text">#dollarformat(qrygetcustomers.CreditLimit)#</label>
					<div class="clear"></div>
					<label>Balance</label>
					<label class="field-text">#dollarformat(qrygetcustomers.Balance)#</label>
					<div class="clear"></div>
					<label>Available</label>
					<label class="field-text">#dollarformat(qrygetcustomers.Available)#</label>
					<div class="clear"></div>
					<label>Notes</label>
					<label class="field-textarea">#qrygetcustomers.Notes#</label>
					<div class="clear"></div>
					<label>Dispatch Notes</label>
					<label class="field-textarea">#qrygetcustomers.DispatchNotes#</label>
					<div class="clear"></div>--->
					<div style="width:100%">
						<table style="border-collapse: collapse;border-spacing: 0;">
							<tbody>
								<tbody>
								<tr>
								  <td><label style="text-align: left !important;width: 65px !important;padding-right:3px;">Credit Limit</label></td>
								  <td><label class="field-text disabledLoadInputs" id="CreditLimit" style="text-align:right !important; width: 60px !important;margin:0px;">#dollarformat(qrygetcustomers.CreditLimit)#</label></td>
									<input id="CreditLimitInput" name="CreditLimitInput" value="#qrygetcustomers.CreditLimit#" type="hidden"  />
								  <td><label style="text-align: left !important;width: 40px !important;padding: 0 5px 0 14px;">Balance</label></td>
								  <td><label class="field-text disabledLoadInputs" id="Balance" style="text-align:right !important; width: 60px !important;margin:0px;">#dollarformat(qrygetcustomers.Balance)#</label></td>
								  <td><label style="text-align: left !important;width: 50px !important;padding: 0 3px 0 14px;">Available</label></td>
								  <td><label class="field-text disabledLoadInputs" id="Available" style="text-align:right !important; width: 60px !important;margin:0px;">#dollarformat(qrygetcustomers.Available)#</label></td>
								  <input id="AvailableInput" name="AvailableInput" value="#qrygetcustomers.Available#" type="hidden"  />
								</tr>
							</tbody>
							</tbody>
						</table>
					</div>
					<div class="clear"></div>
					<label class="space_it_medium margin_top">Notes</label>
					<div class="clear"></div>
					<label class="field-textarea" style="margin: 0 0 8px 8px !importat;width: 378px !important;">#qrygetcustomers.Notes#</label>
					<div class="clear"></div>
					<label class="space_it_medium margin_top">Dispatch Notes</label>
					<div class="clear"></div>
					<label class="field-textarea" style="margin: 0 0 8px 8px !importat;width: 378px !important;">#qrygetcustomers.DispatchNotes#</label>
					<div class="clear"></div>
					
				</fieldset>
			<!---</div>--->
			</cfoutput>
		</cfsavecontent>
		#customerInfoForm#
	</cffunction>

	<!--- Get Shipper Info--->

	<cffunction name="getAjaxLoadShipperInfo" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="shipperID" required="No" type="any">
		<!--- Call stored procedure for Get a Shipper --->
			<CFSTOREDPROC PROCEDURE="USP_GetStopDetails" DATASOURCE="#arguments.dsn#"> 
				<cfif isdefined('arguments.shipperID') and len(arguments.shipperID)>
				 	<CFPROCPARAM VALUE="#arguments.shipperID#" cfsqltype="CF_SQL_VARCHAR">  
				 <cfelse>
				 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
				 </cfif>
				 <CFPROCRESULT NAME="qShipper"> 
			</CFSTOREDPROC>
		<cfset ShipperArray = ArrayNew(1)>
		<cfif qShipper.recordcount>	
			<cfset ShipperArray[1]=qShipper.CustomerName>
			<cfset ShipperArray[2]=qShipper.Location>
			<cfset ShipperArray[3]=qShipper.City>
			<cfset ShipperArray[4]=qShipper.StateID>
			<cfset ShipperArray[5]=qShipper.zipCode>
			<cfset ShipperArray[6]=qShipper.ContactPerson>
			<cfset ShipperArray[7]=qShipper.PhoneNo>
			<cfset ShipperArray[8]=qShipper.Fax>
			<cfset ShipperArray[9]=qShipper.Email>
			<!---<cfset ShipperArray[10]=qShipper.ReleaseNo>
			<cfset ShipperArray[11]=Dateformat(qShipper.StopDate,'MM/DD/YYYY')>
			<cfset ShipperArray[12]=qShipper.StopTime>
			<cfset ShipperArray[13]=qShipper.TimeIn>
			<cfset ShipperArray[14]=qShipper.TimeOut>
			<cfset ShipperArray[15]=qShipper.Blind>
			<cfset ShipperArray[16]=qShipper.Instructions>
			<cfset ShipperArray[17]=qShipper.Directions>--->
		</cfif>
		<cfoutput>
		</cfoutput>
		<cfreturn ShipperArray>
	</cffunction>

	<!--- Get Consignee Info--->

	<cffunction name="getAjaxLoadConsigneeInfo" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="consigneeID" required="No" type="any">
		<!--- Call stored procedure for Get a Shipper --->
			<CFSTOREDPROC PROCEDURE="USP_GetStopDetails" DATASOURCE="#arguments.dsn#"> 
				<cfif isdefined('arguments.consigneeID') and len(arguments.consigneeID)>
				 	<CFPROCPARAM VALUE="#arguments.consigneeID#" cfsqltype="CF_SQL_VARCHAR">  
				 <cfelse>
				 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
				 </cfif>
				 <CFPROCRESULT NAME="qShipper"> 
			</CFSTOREDPROC>
		<cfset ShipperArray = ArrayNew(1)>
		<cfif qShipper.recordcount>
			<cfset ShipperArray[1]=qShipper.CustomerName>
			<cfset ShipperArray[2]=qShipper.Location>
			<cfset ShipperArray[3]=qShipper.City>
			<cfset ShipperArray[4]=qShipper.StateID>
			<cfset ShipperArray[5]=qShipper.zipCode>
			<cfset ShipperArray[6]=qShipper.ContactPerson>
			<cfset ShipperArray[7]=qShipper.PhoneNo>
			<cfset ShipperArray[8]=qShipper.Fax>
			<cfset ShipperArray[9]=qShipper.Email>
			<!---<cfset ShipperArray[10]=qShipper.ReleaseNo>
			<cfset ShipperArray[11]=Dateformat(qShipper.StopDate,'MM/DD/YYYY')>
			<cfset ShipperArray[12]=qShipper.StopTime>
			<cfset ShipperArray[13]=qShipper.TimeIn>
			<cfset ShipperArray[14]=qShipper.TimeOut>
			<cfset ShipperArray[15]=qShipper.Blind>
			<cfset ShipperArray[16]=qShipper.Instructions>
			<cfset ShipperArray[17]=qShipper.Directions>--->
		</cfif>
		<cfreturn ShipperArray>
	</cffunction>



	<!--- Get Carrier List By String --->
	<cffunction name="getAjaxCarrierlistByString" access="remote" returntype="string">
		<cfargument name="dsn" type="string" required="yes" />
		<cfargument name="filterString" required="No" type="string">
		<!--- call SP to Get a carrier Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCarrierListByFilterString" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.filterString') and len(arguments.filterString)>
			 	<CFPROCPARAM VALUE="#arguments.filterString#" cfsqltype="cf_sql_varchar">
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="cf_sql_varchar">
			 </cfif>
			 <CFPROCRESULT NAME="qrygetFilterCarrier">
		</CFSTOREDPROC>
		
		<cfsavecontent variable="filteredCarrierList">
		<cfoutput>
			<select size="10" name="filterList" class="carrier-select" style="height:162px" onchange="DisplayIntextField(this.value,this.options[this.selectedIndex].text,'#arguments.dsn#');">
				<cfloop query="qrygetFilterCarrier">
					<option value="#qrygetFilterCarrier.value#">
						<cfif arguments.filterString neq ''>#ucase(arguments.filterString)# & </cfif>#qrygetFilterCarrier.TEXT# &nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.city#&nbsp;#qrygetFilterCarrier.statecode#&nbsp;&nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.phone#&nbsp;&nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.status#
					</option>
				</cfloop>
			</select>
		</cfoutput>
		</cfsavecontent>
		<cfreturn filteredCarrierList>
	</cffunction>

	<!--- Get Carrier List--->
	<cffunction name="getAjaxCarrierlist" access="remote" returntype="string">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="filterChar" required="No" type="any">
		<!--- call SP to Get a carrier Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCarrierListByFilterChar" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.filterChar') and len(arguments.filterChar)>
			 	<CFPROCPARAM VALUE="#arguments.filterChar#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetFilterCarrier"> 
		</CFSTOREDPROC>
		
		<cfsavecontent variable="filteredCarrierList">
			<cfoutput>
				<select size="10" name="filterList" class="carrier-select" style="height:162px" onchange="DisplayIntextField(this.value,this.options[this.selectedIndex].text,'#arguments.dsn#');">
					<cfloop query="qrygetFilterCarrier">
						<option value="#qrygetFilterCarrier.value#">
							#ucase(arguments.filterChar)# & #qrygetFilterCarrier.TEXT# &nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.city#&nbsp;#qrygetFilterCarrier.statecode#&nbsp;&nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.phone#&nbsp;&nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.status#
						</option>
					</cfloop>
				</select>
			</cfoutput>
		</cfsavecontent>
		<cfreturn filteredCarrierList>
	</cffunction>



	<!--- Get Long and Short Miles --->
	<!---<cffunction name="getLongShortMiles" access="remote" returntype="array">--->
	<cffunction name="getLongShortMiles" access="remote"  output="yes" returnformat="json">
		<cfargument name="dsn" type="string" required="yes" />
		
		<cfset var arrReturn = ArrayNew(1) />
		
		<cfquery name="qryGetLongShortMiles" datasource="#arguments.dsn#">
			SELECT ISNULL(LongMiles,0) AS LongMiles, ISNULL(ShortMiles,0) AS ShortMiles
			FROM SystemConfig
		</cfquery>
		
		<cfloop query="qryGetLongShortMiles">
			<cfset ArrayAppend(arrReturn, #qryGetLongShortMiles.LongMiles#)>
		    <cfset ArrayAppend(arrReturn, #qryGetLongShortMiles.ShortMiles#)>
		</cfloop>
	          
	<!---	<cfreturn arrReturn>--->
	    #SerializeJSON(arrReturn)#
	</cffunction>


	<!--- Set Long and Short Miles --->
	<cffunction name="setSystemSetupOptions" access="public" returntype="string">
		<!---<cfargument name="dsn" type="string" required="yes"/>--->
		<cfargument name="longMiles" type="numeric" required="yes"/>
		<cfargument name="shortMiles" type="numeric" required="yes"/>
		<cfargument name="deductionPercentage" type="numeric" required="yes"/>
		<cfargument name="ARAndAPExportStatusID" type="string" required="yes"/>
		<cfargument name="showExpiredInsuranceCarriers" type="string" required="yes"/>
		<cfargument name="showCarrierInvoiceNumber" type="string" required="yes"/>
		<cfargument name="companyName" type="string" required="yes"/>
		<cfargument name="companyLogoName" type="string" required="yes"/>
		<cfargument name="dispatch_notes" type="string" required="yes" />
		<cfargument name="carrier_notes" type="string" required="yes" />
		<cfargument name="pricing_notes" type="string" required="yes" />
		<cfargument name="simple_notes" type="string" required="yes" />
		<cfargument name="requireValidMCNumber" type="string" required="yes"/>
		<cfargument name="integratewithPEP" type="string" required="yes" />
		<cfargument name="PEPsecretKey" type="string" required="yes" />
		<cfargument name="PEPcustomerKey" type="string" required="yes"/>
		<cfargument name="CarrierTerms" type="string" required="yes"/>
		<cfargument name="Triger_loadStatus" type="string" required="yes"/>
		<cfargument name="AllowLoadentry" type="string" required="yes"/>
		<cfargument name="showReadyArriveDat" type="string" required="yes"/>
		<cfargument name="integratewithITS" type="string" required="yes"/>
		<cfargument name="ITSUserName" type="string" required="yes"/>
		<cfargument name="ITSPassword" type="string" required="yes"/>	
		<cfargument name="userDef1" type="string" required="yes"/>
		<cfargument name="userDef2" type="string" required="yes"/>	
		<cfargument name="userDef3" type="string" required="yes"/>
		<cfargument name="userDef4" type="string" required="yes"/>
		<cfargument name="userDef5" type="string" required="yes"/>
		<cfargument name="userDef6" type="string" required="yes"/>
		<cfargument name="userDef7" type="string" required="no"/>
		<cfargument name="googleMapsPcMiler" type="numeric" required="yes"/>
		<cfargument name="minimumMargin" type="numeric" required="yes"/>
		<cfargument name="CarrierHead" type="string" required="yes"/>
		<cfargument name="CustInvHead" type="string" required="yes"/>
		<cfargument name="BOLHead" type="string" required="yes"/>
		<cfargument name="WorkImpHead" type="string" required="yes"/>
		<cfargument name="WorkExpHead" type="string" required="yes"/>
		<cfargument name="SalesHead" type="string" required="yes"/>
		<cfargument name="minimunLoadNumber" type="numeric" required="yes"/>
		<cfargument name="statusDispatchNote" type="string" required="yes"/>
		<cfargument name="emailreports" type="string" required="yes"/>
		<cfargument name="printReports" type="string" required="yes"/>
		<cfargument name="CustomerTerms" type="string" required="yes"/>
		<cfargument name="loadNumberAssignment" type="string" required="yes"/>
		<cfargument name="commodityWeight" type="string" required="yes"/>
		<cfargument name="numberAttachments" type="string" required="yes"/>
		<cfargument name="rolloverShipDateStatus" type="string" required="yes"/>

		<cfargument name="editDispatchNotes" type="string" required="no"/>
		<cfargument name="showcarrieramount" type="string" required="no"/>
		<cfargument name="showcustomeramount" type="string" required="no"/>
		<cfargument name="rowsperpage" type="any" required="no"/>
		<cfargument name="lockloadstatus" type="string" required="no"/>

		<cfif NOT len(arguments.userDef1)>
			<cfset arguments.userDef1 = 'userDef1'>
		</cfif>
		<cfif NOT len(arguments.userDef2)>
			<cfset arguments.userDef2 = 'userDef2'>
		</cfif>
		<cfif NOT len(arguments.userDef3)>
			<cfset arguments.userDef3 = 'userDef3'>
		</cfif>
		<cfif NOT len(arguments.userDef4)>
			<cfset arguments.userDef4 = 'userDef4'>
		</cfif>
		<cfif NOT len(arguments.userDef5)>
			<cfset arguments.userDef5 = 'userDef5'>
		</cfif>
		<cfif NOT len(arguments.userDef6)>
			<cfset arguments.userDef6 = 'userDef6'>
		</cfif>
		
		<cfif LCase(requireValidMCNumber) EQ 'NO'>
			<cfset requireMCNoInCar = false>
		<cfelse>
			<cfset requireMCNoInCar = true>
		</cfif>
		<cfif LCase(showExpiredInsuranceCarriers) EQ 'NO'>
			<cfset showExpInsCar = false>
		<cfelse>
			<cfset showExpInsCar = true>
		</cfif>
		<cfquery name="qSystemSetupOptionsFreightBrokerStatus" datasource="#Application.dsn#">
	    	SELECT freightBroker
	        FROM SystemConfig
	    </cfquery>
		<cfquery name="qrySetSystemSetupOptions" datasource="#Application.dsn#" result="qResult">
			SET NOCOUNT ON
			UPDATE SystemConfig
			SET ShortMiles = <cfqueryparam value="#arguments.shortMiles#" cfsqltype="cf_sql_float">,
		    LongMiles = <cfqueryparam value="#arguments.longMiles#" cfsqltype="cf_sql_float">,
		    DeductionPercentage = <cfqueryparam value="#arguments.deductionPercentage#" cfsqltype="cf_sql_float">,
		    ARAndAPExportStatusID = <cfqueryparam value="#arguments.ARAndAPExportStatusID#" cfsqltype="cf_sql_varchar">,
			showExpiredInsuranceCarriers = <cfqueryparam value="#showExpInsCar#" cfsqltype="cf_sql_bit">,
			showCarrierInvoiceNumber = <cfqueryparam value="#arguments.showCarrierInvoiceNumber#" cfsqltype="cf_sql_bit">,
			<cfif arguments.companyLogoName NEQ ''>
				companyLogoName = <cfqueryparam value="#arguments.companyLogoName#" cfsqltype="cf_sql_varchar">,
			</cfif>
			companyName = <cfqueryparam value="#arguments.companyName#" cfsqltype="cf_sql_varchar">,
		    DispatchNotes = <cfqueryparam value="#arguments.dispatch_notes#" cfsqltype="cf_sql_bit">,
		    CarrierNotes = <cfqueryparam value="#arguments.carrier_notes#" cfsqltype="cf_sql_bit">,
		    PricingNotes = <cfqueryparam value="#arguments.pricing_notes#" cfsqltype="cf_sql_bit">,
		    Notes = <cfqueryparam value="#arguments.simple_notes#" cfsqltype="cf_sql_bit">,
		    requireValidMCNumber = <cfqueryparam value="#requireMCNoInCar#" cfsqltype="cf_sql_bit">,
			integratewithPEP = <cfqueryparam value="#integratewithPEP#" cfsqltype="cf_sql_bit">,
			PEPsecretKey = <cfqueryparam value="#PEPsecretKey#" cfsqltype="cf_sql_varchar">,
			PEPcustomerKey = <cfqueryparam value="#PEPcustomerKey#" cfsqltype="cf_sql_varchar">,
			CarrierTerms=<cfqueryparam value="#CarrierTerms#" cfsqltype="cf_sql_varchar">,
			Triger_loadStatus= <cfqueryparam value="#Triger_loadStatus#" cfsqltype="cf_sql_varchar"> ,
			AllowLoadentry= <cfqueryparam value="#AllowLoadentry#" cfsqltype="cf_sql_bit">,
			showReadyArriveDate = <cfqueryparam value="#showReadyArriveDat#" cfsqltype="cf_sql_bit">,
			integratewithITS = <cfqueryparam value="#integratewithITS#" cfsqltype="cf_sql_bit">,
			ITSUserName = <cfqueryparam value="#ITSUserName#" cfsqltype="cf_sql_varchar">,
			ITSPassword = <cfqueryparam value="#ITSPassword#" cfsqltype="cf_sql_varchar">,
			userDef1 = <cfqueryparam value="#userDef1#" cfsqltype="cf_sql_varchar">,
			userDef2 = <cfqueryparam value="#userDef2#" cfsqltype="cf_sql_varchar">,
			userDef3 = <cfqueryparam value="#userDef3#" cfsqltype="cf_sql_varchar">,
			userDef4 = <cfqueryparam value="#userDef4#" cfsqltype="cf_sql_varchar">,
			userDef5 = <cfqueryparam value="#userDef5#" cfsqltype="cf_sql_varchar">,
			userDef6 = <cfqueryparam value="#userDef6#" cfsqltype="cf_sql_varchar">,
			<cfif structkeyexists(arguments,"userDef7")>
				userDef7 = <cfqueryparam value="#userDef7#" cfsqltype="cf_sql_varchar">,
			</cfif>	
			googleMapsPcMiler = <cfqueryparam value="#googleMapsPcMiler#" cfsqltype="cf_sql_bit">,
			minimumMargin = <cfqueryparam value="#arguments.minimumMargin#" cfsqltype="cf_sql_float">,
			CarrierHead=<cfqueryparam value="#arguments.CarrierHead#" cfsqltype="cf_sql_varchar">,
			CustInvHead=<cfqueryparam value="#arguments.CustInvHead#" cfsqltype="cf_sql_varchar">,
			BOLHead=<cfqueryparam value="#arguments.BOLHead#" cfsqltype="cf_sql_varchar">,
			WorkImpHead=<cfqueryparam value="#arguments.WorkImpHead#" cfsqltype="cf_sql_varchar">,
			WorkExpHead=<cfqueryparam value="#arguments.WorkExpHead#" cfsqltype="cf_sql_varchar">,
			SalesHead=<cfqueryparam value="#arguments.SalesHead#" cfsqltype="cf_sql_varchar">,
			MinimumLoadStartNumber=<cfqueryparam value="#arguments.minimunLoadNumber#" cfsqltype="cf_sql_numeric">,
			StatusDispatchNotes=<cfqueryparam value="#arguments.statusDispatchNote#" cfsqltype="cf_sql_bit">,
			AutomaticEmailReports = <cfqueryparam value="#arguments.emailreports#" cfsqltype="cf_sql_bit">,
			AutomaticPrintReports = <cfqueryparam value="#arguments.printReports#" cfsqltype="cf_sql_bit">,
			CustomerTerms=<cfqueryparam value="#CustomerTerms#" cfsqltype="cf_sql_varchar"> ,
			loadNumberAssignment=<cfqueryparam value="#arguments.loadNumberAssignment#" cfsqltype="cf_sql_integer">,
			commodityWeight=<cfqueryparam value="#arguments.commodityWeight#" cfsqltype="cf_sql_bit">,
			numberAttachments=<cfqueryparam value="#arguments.numberAttachments#" cfsqltype="cf_sql_bit">,
			rolloverShipDateStatus=<cfqueryparam value="#arguments.rolloverShipDateStatus#" cfsqltype="cf_sql_bit">,
			showcarrieramount=<cfqueryparam value="#arguments.showcarrieramount#" cfsqltype="cf_sql_varchar"> ,
			EditDispatchNotes=<cfqueryparam value="#arguments.editDispatchNotes#" cfsqltype="cf_sql_varchar"> ,
			showcustomeramount=<cfqueryparam value="#arguments.showcustomeramount#" cfsqltype="cf_sql_varchar">, 
			rowsperpage=<cfqueryparam value="#arguments.rowsperpage#">, 
			lockloadstatus=<cfqueryparam value="#arguments.lockloadstatus#" cfsqltype="cf_sql_varchar"> 
			SELECT @@ROWCOUNT as updatedRows
			SET NOCOUNT OFF
		</cfquery>
		
		<cfreturn qrySetSystemSetupOptions.updatedRows>
	</cffunction>

	<cffunction name="getCompanyName" access="remote" returntype="query">
		<cfargument name="dsn" type="any" required="no"/>
	    <cfif isdefined('dsn')>
	    	<cfset companyName=dsn>
	    <cfelse>
	    	<cfset companyName=variables.dsn>
	    </cfif>
		<cfquery name="qCompanyName" datasource="#companyName#">
		    SELECT CompanyName
			FROM Companies
	    </cfquery>
	    <cfreturn qCompanyName>
	</cffunction>

	<cffunction name="getSystemSetupOptions" access="remote" returntype="query">
		<cfargument name="dsn" type="any" required="no"/>
	    <cfif isdefined('dsn')>
	    	<cfset activedns = dsn>
	    <cfelse>
	    	<cfset activedns = variables.dsn>
	    </cfif>
		<cfquery name="qSystemSetupOptions" datasource="#activedns#">
	    	SELECT LongMiles, ShortMiles, DeductionPercentage, ARAndAPExportStatusID, showExpiredInsuranceCarriers, companyName, companyLogoName,DispatchNotes, CarrierNotes, PricingNotes, Notes, requireValidMCNumber,integratewithPEP,PEPsecretKey,PEPcustomerKey,CarrierTerms,integratewithTran360,trans360Usename,trans360Password,TRIGER_LOADSTATUS,AllowLoadentry,showReadyArriveDate,ISNULL(IntegrateWithITS,0) AS IntegrateWithITS,ITSUserName, ITSPassword, userDef1, userDef2, userDef3, userDef4, userDef5, userDef6, userDef7, googleMapsPcMiler, minimumMargin, CarrierHead, CustInvHead, BOLHead, WorkImpHead, WorkExpHead, SalesHead, MinimumLoadStartNumber,StatusDispatchNotes,AutomaticEmailReports,AutomaticPrintReports, emailtype, FreightBroker, CustomerTerms,loadNumberAssignment,commodityWeight,MinimumLoadInvoiceNumber,numberAttachments,rolloverShipDateStatus,showcarrieramount,showcustomeramount,rowsperpage,lockloadstatus,EditDispatchNotes,showCarrierInvoiceNumber,SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey    
	        FROM SystemConfig
	    </cfquery>
	    <cfreturn qSystemSetupOptions>
	</cffunction>
	<!--------get load add /edit system option---->
	<cffunction name="getLoadSystemSetupOptions" access="remote" returntype="query">
		<cfargument name="dsn" type="any" required="no"/>
	    <cfif isdefined('dsn')>
	    	<cfset activedns = dsn>
	    <cfelse>
	    	<cfset activedns = variables.dsn>
	    </cfif>
		<cfquery name="qSystemSetupOptions" datasource="#activedns#">
	    	SELECT integratewithPEP,companyLogoName,companyName,integratewithITS,freightBroker,rolloverShipDateStatus,userDef7,showcarrieramount,showcustomeramount,rowsperpage,lockloadstatus,EditDispatchNotes,showCarrierInvoiceNumber
	        FROM SystemConfig
	    </cfquery>
	    <cfreturn qSystemSetupOptions>
	</cffunction>
	<!--- Get Long and Short Miles --->
	<cffunction name="addQuickCalcInfoToLog" access="remote" returntype="void">
		<cfargument name="dsn" type="string" required="yes"/>
		<cfargument name="consigneeAddress" type="string" required="yes"/>
		<cfargument name="shipperAddress" type="string" required="yes"/>
		<cfargument name="custRatePerMile" type="numeric" required="yes"/>
		<cfargument name="carRatePerMile" type="numeric" required="yes"/>
		<cfargument name="custMiles" type="numeric" required="yes"/>
		<cfargument name="carMiles" type="numeric" required="yes"/>
		<cfargument name="customerAmount" type="numeric" required="yes"/>
		<cfargument name="carrierAmount" type="numeric" required="yes"/>
		<cfargument name="companyName" type="string" required="yes"/>
		<cfargument name="userName" type="string" required="yes"/>

		<cfquery name="qrySetQuickMilesAndRateCalcInfo" datasource="#arguments.dsn#" result="qResult">
			INSERT INTO quickMilesAndRateCalcLog(ConsigneeAddress,ShipperAddress,CustomerRatePerMile,CarrierRatePerMile,customerMiles,carrierMiles,CustomerAmount,CarrierAmount,companyName,DateTime,userName,IP)
			VALUES(
		    <cfqueryparam value="#arguments.consigneeAddress#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#arguments.shipperAddress#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#arguments.custRatePerMile#" cfsqltype="cf_sql_float">,
		    <cfqueryparam value="#arguments.carRatePerMile#" cfsqltype="cf_sql_float">,
		    <cfqueryparam value="#arguments.custMiles#" cfsqltype="cf_sql_float">,
		    <cfqueryparam value="#arguments.carMiles#" cfsqltype="cf_sql_float">,
		    <cfqueryparam value="#arguments.customerAmount#" cfsqltype="cf_sql_float">,
		    <cfqueryparam value="#arguments.carrierAmount#" cfsqltype="cf_sql_float">,
		    <cfqueryparam value="#arguments.companyName#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		    <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_varchar">)
		</cfquery>
	</cffunction>



	<cffunction name="getAjaxCarrierlistNext" access="remote" returntype="string">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="filterChar" required="No" type="any">
		<cfargument name="stopNo" required="yes" type="any">
		<!--- call SP to Get a carrier Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCarrierListByFilterChar" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.filterChar') and len(arguments.filterChar)>
			 	<CFPROCPARAM VALUE="#arguments.filterChar#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetFilterCarrier"> 
		</CFSTOREDPROC>
		
		<cfsavecontent variable="filteredCarrierList">
			<cfoutput>
				<select size="10" name="filterList" class="carrier-select" style="height:162px" onchange="DisplayIntextFieldNext(this.value,this.options[this.selectedIndex].text,#arguments.stopNo#,'#arguments.dsn#');">
					<cfloop query="qrygetFilterCarrier">
						<option value="#qrygetFilterCarrier.value#">
							#ucase(arguments.filterChar)# & #qrygetFilterCarrier.TEXT# &nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.city#&nbsp;#qrygetFilterCarrier.statecode#&nbsp;&nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.phone#&nbsp;&nbsp;&nbsp;&nbsp;#qrygetFilterCarrier.status#
						</option>
					</cfloop>
				</select>
			</cfoutput>
		</cfsavecontent>
		<cfreturn filteredCarrierList>
	</cffunction>

	<!--- Get carrier Info Form--->
	<cffunction name="getAjaxCarrierInfoForm" access="remote" returntype="string">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="carrierId" required="No" type="any">
		<cfargument name="urlToken" required="no" type="any">
		<!--- call SP to Get a carrier Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCarrierDetails" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.carrierId') and len(arguments.carrierId)>
			 	<CFPROCPARAM VALUE="#arguments.carrierId#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetCarrierDetails"> 
		</CFSTOREDPROC>

		<cfsavecontent variable="CarrierInfoForm">
			<cfoutput>
				<div class="clear"></div>
				<!---<input name="carrierID" id="carrierID" type="hidden" value="#qrygetCarrierDetails.carrierID#" />--->
				<div class="clear"></div>
				<label>&nbsp;</label>
				<label class="field-textarea"><b><a href="index.cfm?event=addcarrier&carrierid=#qrygetCarrierDetails.carrierID#&#arguments.urlToken#" style="color:##4322cc;text-decoration:underline;">#qrygetCarrierDetails.CarrierName#</a></b><br/>#qrygetCarrierDetails.Address#<br/>#qrygetCarrierDetails.City#<br/>#qrygetCarrierDetails.stateCode#&nbsp;-&nbsp;#qrygetCarrierDetails.ZipCode#</label>
				<div class="clear"></div>
				<label>Tel</label>
				<label class="field-text">#qrygetCarrierDetails.phone#</label>
				<div class="clear"></div>
				<label>Cell</label>
				<label class="field-text">#qrygetCarrierDetails.cel#</label>
				<div class="clear"></div>
				<label>Fax</label>
				<label class="field-text">#qrygetCarrierDetails.fax#</label>
				<div class="clear"></div>
				<label>Email</label>
				<label class="emailbox">#qrygetCarrierDetails.emailID#</label>
			</cfoutput>
		</cfsavecontent>
		<cfreturn CarrierInfoForm>
	</cffunction>

	<!--- Get carrier Info Form--->
	<cffunction name="getCarrierInfoForm" access="public" returntype="string">
		<cfargument name="carrierId" required="No" type="any">
		<cfargument name="urlToken" required="no" type="any">
		<cfset risk_assessment = "">
		<!--- call SP to Get a carrier Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCarrierDetails" DATASOURCE="#variables.dsn#"> 
			<cfif isdefined('arguments.carrierId') and len(arguments.carrierId)>
			 	<CFPROCPARAM VALUE="#arguments.carrierId#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetCarrierDetails"> 
		</CFSTOREDPROC>
		<cfquery name="qSystemSetupOptions" datasource="#Application.dsn#">
				SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey,FreightBroker    
				FROM SystemConfig
		</cfquery>
		<cfif qSystemSetupOptions.SaferWatch EQ 1  AND  qSystemSetupOptions.FreightBroker EQ 1 >
				<cfif qrygetCarrierDetails.MCNumber NEQ "">
					<cfset number = "MC"&qrygetCarrierDetails.MCNumber >
				<cfelseif  qrygetCarrierDetails.DOTNumber NEQ "" >
					<cfset number = qrygetCarrierDetails.DOTNumber>
				<cfelse>
					<cfset number = 0 >
				</cfif>
				<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=CarrierLookup&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
				</cfhttp>	
				<cfif cfhttp.Statuscode EQ '200 OK'>	
					<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>
					<cfif structKeyExists(variables.resStruct ,"CarrierDetails") AND structKeyExists(variables.resStruct .CarrierDetails,"RiskAssessment") AND structKeyExists(variables.resStruct .CarrierDetails.RiskAssessment,"Overall")  >
						<cfset risk_assessment = variables.resStruct .CarrierDetails.RiskAssessment.Overall>
					</cfif>			
				<cfelse>
					<cfset risk_assessment = "">
				</cfif>								
			</cfif>
		<cfsavecontent variable="CarrierInfoForm">
			<cfoutput>
				<div class="clear"></div>
				<!---<input name="carrierID" id="carrierID" type="hidden" value="#qrygetCarrierDetails.carrierID#" />--->
				<div class="clear"></div>
				<label>
					<cfif qSystemSetupOptions.SaferWatch EQ 1  AND  qSystemSetupOptions.FreightBroker EQ 1 >
						<a href="http://www.saferwatch.com/swCarrierDetailsLink.php?&number=#number#" target="_blank">
							<cfif risk_assessment EQ "Unacceptable">
								<img style="vertical-align:bottom;" src="images/SW-Red.png">
							<cfelseif risk_assessment EQ "Moderate">
								<img style="vertical-align:bottom;" src="images/SW-Yellow.png">
							<cfelseif risk_assessment EQ "Acceptable">
								<img style="vertical-align:bottom;" src="images/SW-Green.png">
							<cfelse>   
								<img style="vertical-align:bottom;" src="images/SW-Blank.png">
							</cfif>
						</a>
					<cfelse>
						&nbsp;
					</cfif>
				</label>
				<label class="field-textarea"><b><a href="index.cfm?event=addcarrier&carrierid=#qrygetCarrierDetails.carrierID#&#arguments.urlToken#" style="color:##4322cc;text-decoration:underline;">#qrygetCarrierDetails.CarrierName#</a></b><br/>#qrygetCarrierDetails.Address#<br/>#qrygetCarrierDetails.City#<br/>#qrygetCarrierDetails.stateCode#&nbsp;-&nbsp;#qrygetCarrierDetails.ZipCode#</label>
				<div class="clear"></div>
				<label>Tel</label>
				<label class="field-text">#qrygetCarrierDetails.phone#</label>
				<div class="clear"></div>
				<label>Cell</label>
				<label class="field-text">#qrygetCarrierDetails.cel#</label>
				<div class="clear"></div>
				<label>Fax</label>
				<label class="field-text">#qrygetCarrierDetails.fax#</label>
				<div class="clear"></div>
				<label>Email</label>
				<label class="emailbox">#qrygetCarrierDetails.emailID#</label>
			</cfoutput>
		</cfsavecontent>
		<cfreturn CarrierInfoForm>
	</cffunction>

	<!--- Get carrier Info Form for Next Stop--->
	<cffunction name="getAjaxCarrierInfoFormNext" access="remote" output="yes" returnformat="json">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="carrierId" required="No" type="any">
		<cfargument name="stopNo" required="No" type="any">
		<cfargument name="urltoken" required="no" type="any">
		
		<!--- call SP to Get a carrier Info--->
		<CFSTOREDPROC PROCEDURE="USP_GetCarrierDetails" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.carrierId') and len(arguments.carrierId)>
			 	<CFPROCPARAM VALUE="#arguments.carrierId#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetCarrierDetails"> 
		</CFSTOREDPROC>
		
		<cfsavecontent variable="CarrierInfoForm">
			<cfoutput>
				<div class="clear"></div>
				<!---<input name="carrierID#arguments.stopNo#" id="carrierID#arguments.stopNo#" type="hidden" value="#qrygetCarrierDetails.carrierID#" />--->
				<div class="clear"></div>
				<label>&nbsp;</label>
				<label class="field-textarea"><b><a href="index.cfm?event=addcarrier&carrierid=#qrygetCarrierDetails.carrierID#&#arguments.urlToken#">#qrygetCarrierDetails.carrierName#</a></b><br/>#qrygetCarrierDetails.Address#<br/>#qrygetCarrierDetails.City#<br/>#qrygetCarrierDetails.StateCode#&nbsp;-&nbsp;#qrygetCarrierDetails.ZipCode#</label>
				<div class="clear"></div>
				<label>Tel</label>
				<label class="field-text">#qrygetCarrierDetails.phone#</label>
				<div class="clear"></div>
				<label>Cell</label>
				<label class="field-text">#qrygetCarrierDetails.cel#</label>
				<div class="clear"></div>
				<label>Fax</label>
				<label class="field-text">#qrygetCarrierDetails.fax#</label>
				<div class="clear"></div>
				<label>Email</label>
				<label class="field-text">#qrygetCarrierDetails.emailID#</label>
			</div>	
			</cfoutput>
		</cfsavecontent>
		<cfset returnVariable = querynew("stopid,CarrierInfoForm")>
		<cfset queryaddrow(returnVariable,1)>
		<cfset querySetCell(returnVariable, 'stopid', '#stopNo#',1)>
	    <cfset querySetCell(returnVariable, "CarrierInfoForm", "#CarrierInfoForm#", 1)>
		<!--- <cfset returnVariable = '{"ROWCOUNT":1, "COLUMNS":["stopid","CarrierInfoForm"], "DATA":{"stopid":["#stopNo#"],"CarrierInfoForm":["#CarrierInfoForm#"]}}'> 
		<cfreturn returnVariable>--->
	      #SerializeJSON(returnVariable)#
	</cffunction>

	<!---Check for free unit--->
	<cffunction name="checkFeeUnit" access="remote" returntype="any">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="unitId" required="No" type="any">
		<cfquery name="qrygetunits" datasource="#arguments.dsn#">
	         select isFee, UnitCode,CustomerRate,CarrierRate from  Units
	         where 1=1
	 		 <cfif isdefined('arguments.unitId') and len(arguments.unitId)>
	 			and UnitID='#arguments.unitId#'
	 		</cfif>
	     </cfquery>
		<cfif qrygetunits.recordcount and qrygetunits.isfee is true>
			<cfreturn 'true,#qrygetunits.UnitCode#,#qrygetunits.CustomerRate#,#qrygetunits.CarrierRate#'>
		<cfelse>
			<cfreturn 'false,#qrygetunits.UnitCode#,#qrygetunits.CustomerRate#,#qrygetunits.CarrierRate#'>
		</cfif>
	</cffunction>
	          
	<cffunction name="checkAjaxFeeUnit" access="remote" output="yes" returnformat="json">
		<cfargument name="dsn" type="string" required="yes" />	
		<cfargument name="unitId" required="No" type="any">
		<cfquery name="qrygetunits" datasource="#arguments.dsn#">
	         select isFee, UnitCode,CustomerRate,CarrierRate from  Units
	         where 1=1
	 		 <cfif isdefined('arguments.unitId') and len(arguments.unitId)>
	 			and UnitID='#arguments.unitId#'
	 		</cfif>
	     </cfquery>
		<cfif qrygetunits.recordcount and qrygetunits.isfee is true>
	        <cfset unitsArr = ["true","#qrygetunits.UnitCode#", "#qrygetunits.CustomerRate#", "#qrygetunits.CarrierRate#"]>
		<cfelse>
	        <cfset unitsArr = ["false","#qrygetunits.UnitCode#", "#qrygetunits.CustomerRate#", "#qrygetunits.CarrierRate#"]>
		</cfif>
	      #SerializeJSON(unitsArr)#
	</cffunction>



	<!---Update Customer --->
	<cffunction name="updateCustomer" access="public" output="false" returntype="any">
	    <cfargument name="formStruct" type="struct">
		<cfargument name="updateType" type="string">
		<cfargument name="stopNo" type="string">
		<cfif stopNo EQ '0'>
			<cfset stopNo = ''>
		</cfif>
		<cfset custToEditId = Evaluate('arguments.formStruct.#updateType#ValueContainer#stopNo#')>
		<cfquery name="qryupdatecustomer" datasource="#variables.dsn#">
	       	UPDATE Customers
	       	SET 
				CustomerName=			<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#Name#stopNo#')#">,
			 	Location=				<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#location#stopNo#')#">,
				City=					<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#city#stopNo#')#">,
				<cfif EValuate('arguments.formStruct.#updateType#state#stopNo#') NEQ ''>
				statecode=				<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#state#stopNo#')#">,
				</cfif>
				Zipcode=				<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#Zipcode#stopNo#')#">,
				ContactPerson=			<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#ContactPerson#stopNo#')#">,
				PhoneNo=				<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#Phone#stopNo#')#">,
				Email=					<cfqueryparam cfsqltype="cf_sql_varchar" value="#EValuate('arguments.formStruct.#updateType#Email#stopNo#')#">,
				CustomerDirections= 	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#EValuate('arguments.formStruct.#updateType#Direction#stopNo#')#">,
				CustomerNotes= 		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#EValuate('arguments.formStruct.#updateType#Notes#stopNo#')#">,
				LastModifiedBy=		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
				LastModifiedDateTime=	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				UpdatedByIP=			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
			WHERE CustomerID = '#custToEditId#'
		</cfquery>	
		<cfreturn "#custToEditId#">
	</cffunction>


	<cffunction name="formCustStruct" access="public" returntype="any">
		<cfargument name="frmstruct" type="struct" required="yes">
		<cfargument name="type" required="yes">	
		<cfargument name="stop" required="false" default="">	
		
		<cfif arguments.type eq "shipper">
			<cfset shipperStruct = {}>
		   	<cfquery name="getShipperDetails" datasource="#variables.dsn#" >
			   select loadPotential,companyID,bestOpp
			   from customers where customerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.cutomerIdAutoValueContainer#">
		  	</cfquery>
	 	  	<cfset shipperStruct.customerStatusID 	= 1>
			<cfset shipperStruct.customerCode 		= evaluate("arguments.frmstruct.shipperName#stop#")>
			<cfset shipperStruct.customerName		= evaluate("arguments.frmstruct.shipperName#stop#")>
			<cfset shipperStruct.officeID1			= session.officeID>
			<cfset shipperStruct.location			= evaluate("arguments.frmstruct.shipperlocation#stop#")>
			<cfset shipperStruct.city				= evaluate("arguments.frmstruct.shipperCity#stop#")>
			<cfset shipperStruct.state1				= evaluate("arguments.frmstruct.shipperState#stop#")>
			<cfset shipperStruct.zipCode		 	= evaluate("arguments.frmstruct.shipperZipCode#stop#")>
			<cfset shipperStruct.contactPerson 		= evaluate("arguments.frmstruct.shipperContactPerson#stop#")>
			<cfset shipperStruct.mobileNo			= "">
			<cfset shipperStruct.phoneNo			= evaluate("arguments.frmstruct.shipperPhone#stop#")>
			<cfset shipperStruct.email 				= evaluate("arguments.frmstruct.shipperEmail#stop#")>
			<cfset shipperStruct.website 			= "">
			<cfif structKeyExists(arguments.frmstruct, "salesPerson")>
				<cfset shipperStruct.salesPerson 		= arguments.frmstruct.salesPerson>
			<cfelse>
				<cfset shipperStruct.salesPerson 		= "">
			</cfif>
			<cfset shipperStruct.dispatcher 		= arguments.frmstruct.Dispatcher>
			<cfset shipperStruct.loadPotential 		= 0>
			<cfset shipperStruct.companyID1			= #getShipperDetails.companyID#>
			<cfset shipperStruct.bestOpp 			= 0>
			<cfset shipperStruct.customerDirections = evaluate("arguments.frmstruct.shipperDirection#stop#")>
			<cfset shipperStruct.customerNotes 		= evaluate("arguments.frmstruct.shipperNotes#stop#")>
			<cfset shipperStruct.isPayer			= 0>
			<cfset shipperStruct.financeID 			= "">
			<cfset shipperStruct.creditLimit		= 0>
			<cfset shipperStruct.balance 			= 0>
			<cfset shipperStruct.available			= 0>
			<cfset shipperStruct.ratePerMile		= 0>
			<cfset shipperStruct.fax				= evaluate("arguments.frmstruct.shipperFax#stop#")>
			<cfset shipperStruct.country1 			= "">
			<cfset shipperStruct.CarrierNotes 		= "">
			<cfset shipperStruct.Tollfree 			= "">
			
			<cfreturn #shipperStruct#>		
		<cfelseif arguments.type eq "consignee">
			<cfset consigneeStruct = {}>
	 	   	<cfquery name="getConsigneeDetails" datasource="#variables.dsn#" >
				select loadPotential,companyID,bestOpp
				from customers where customerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.cutomerIdAutoValueContainer#">		  	
			</cfquery>
	  	
			<cfset consigneeStruct.customerStatusID 	= 1>
			<cfset consigneeStruct.customerCode 		= evaluate("arguments.frmstruct.consigneeName#stop#")>
			<cfset consigneeStruct.customerName			= evaluate("arguments.frmstruct.consigneeName#stop#")>
			<cfset consigneeStruct.officeID1			= session.officeID>
			<cfset consigneeStruct.location				= evaluate("arguments.frmstruct.consigneelocation#stop#")>
			<cfset consigneeStruct.city					= evaluate("arguments.frmstruct.consigneeCity#stop#")>
			<cfset consigneeStruct.state1				= evaluate("arguments.frmstruct.consigneeState#stop#")>
			<cfset consigneeStruct.zipCode		 		= evaluate("arguments.frmstruct.consigneeZipCode#stop#")>
			<cfset consigneeStruct.contactPerson 		= evaluate("arguments.frmstruct.consigneeContactPerson#stop#")>
			<cfset consigneeStruct.mobileNo				= "">
			<cfset consigneeStruct.phoneNo				= evaluate("arguments.frmstruct.consigneePhone#stop#")>
			<cfset consigneeStruct.email 				= evaluate("arguments.frmstruct.consigneeEmail#stop#")>
			<cfset consigneeStruct.website 				= "">
			<cfif structKeyExists(arguments.frmstruct, "salesPerson")>
				<cfset consigneeStruct.salesPerson 			= arguments.frmstruct.salesPerson>
			<cfelse>
				<cfset consigneeStruct.salesPerson 			="">	
			</cfif>	
			<cfset consigneeStruct.dispatcher 			= arguments.frmstruct.Dispatcher>
			<cfset consigneeStruct.loadPotential 		= getConsigneeDetails.loadPotential>
			<cfset consigneeStruct.companyID1			= getConsigneeDetails.companyID>
			<cfset consigneeStruct.bestOpp 				= getConsigneeDetails.bestOpp>
			<cfset consigneeStruct.customerDirections	= evaluate("arguments.frmstruct.consigneeDirection#stop#")>
			<cfset consigneeStruct.customerNotes 		= evaluate("arguments.frmstruct.consigneeNotes#stop#")>
			<cfset consigneeStruct.isPayer				= 0>
			<cfset consigneeStruct.financeID 			= "">
			<cfset consigneeStruct.creditLimit			= 0>
			<cfset consigneeStruct.balance 				= 0>
			<cfset consigneeStruct.available			= 0>
			<cfset consigneeStruct.ratePerMile			= 0>
			<cfset consigneeStruct.fax					= evaluate("arguments.frmstruct.consigneeFax#stop#")>
			<cfset consigneeStruct.country1 			= "">
			<cfset consigneeStruct.CarrierNotes 		= "">
			<cfset consigneeStruct.Tollfree 			= "">
			
		    <cfreturn #consigneeStruct#>
		</cfif>	
	</cffunction>	

	<!-------------posttoITS WEBERVICE start----------------->
		
	<cffunction name="ITSWebservice" returntype="any" access="remote" returnformat="wddx">
		<cfargument name="impref" type="any" required="true" />
		<cfargument name="postaction" type="any" required="true" />
		<cfargument name="ITSUsername" type="any" required="true" />
		<cfargument name="ITSPassword" type="any" required="true" />
		<cfargument name="ITSintegrationID" type="any" required="true" />
		<!---  add by sp --->
		<cfargument name="loadNumber" type="any" required="false" default="" />
		<!---  add by sp --->
		<cfargument name="dsn" type="any" required="no" />

		
		<cftry> 
			<cfoutput>

				<cfif structkeyexists(arguments,"dsn")>
					<cfset variables.dsn=arguments.dsn>	
				<cfelse>
					<cfset variables.dsn=variables.dsn>	
				</cfif>	
				<!---  change by sp --->
				<cfset variables.loadnumber = arguments.impref >
				<cfif len(trim(arguments.loadNumber))>
					<cfset variables.loadnumber = arguments.loadNumber >
				</cfif>
				<cfquery name="vwLoadsITS" datasource="#variables.dsn#">
					select * from vwLoadsITS where loadNumber = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.loadnumber#"> 
				</cfquery>
				<!---  change by sp --->
				
				<cfif vwLoadsITS.length eq 0  or  vwLoadsITS.length eq "">
					<cfset vwLoadsITS.length=1 />
				</cfif>
				<cfif vwLoadsITS.FullOrPartial is True>
					<cfset vwLoadsITS.FullOrPartial=False/>
				<cfelse> 
					<cfset vwLoadsITS.FullOrPartial=True/>
				</cfif>	
				<!---  add by sp --->
				<cfif not len(trim(vwLoadsITS.width))>
					<cfset vwLoadsITS.width = 0>
				</cfif>
				<!---  add by sp --->
				
			</cfoutput>
			<cfif arguments.postaction EQ 'A'>
				<!------Post Load to ITS----->
				<cfoutput>
					<cfsavecontent variable="soapHeaderPosttoITStxt">
						<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://webservices.truckstop.com/v11" xmlns:web="http://schemas.datacontract.org/2004/07/WebServices" xmlns:web1="http://schemas.datacontract.org/2004/07/WebServices.Posting" xmlns:web2="http://schemas.datacontract.org/2004/07/WebServices.Objects" xmlns:truc="http://schemas.datacontract.org/2004/07/Truckstop2.Objects">
							<soapenv:Header/>
							<soapenv:Body>
								<v11:PostLoads>
									<v11:loads>
										<web:IntegrationId>#arguments.ITSintegrationID#</web:IntegrationId>
										<web:Password>#arguments.ITSPassword#</web:Password>
										<web:UserName>#arguments.ITSUsername#</web:UserName>
										<web1:Loads>
											<web2:Load>
												<web2:DeliveryDate>#dateformat(vwLoadsITS.DeliveryDate,'yyyy-mm-dd')#</web2:DeliveryDate>
												<web2:DeliveryTime>#vwLoadsITS.DeliveryTime#</web2:DeliveryTime>
												<web2:DestinationCity>#vwLoadsITS.DestCity#</web2:DestinationCity>
												<web2:DestinationState>#vwLoadsITS.DestState#</web2:DestinationState>
												<web2:IsFavorite>0</web2:IsFavorite>
												<web2:IsLoadFull>#vwLoadsITS.FullOrPartial#</web2:IsLoadFull>
												<web2:Length>#vwLoadsITS.Length#</web2:Length>
												<web2:LoadId>0</web2:LoadId>
												<web2:LoadNumber>#vwLoadsITS.ImportRef#</web2:LoadNumber>
												<web2:OriginCity>#vwLoadsITS.OriginCity#</web2:OriginCity>
												<web2:OriginState>#vwLoadsITS.OriginState#</web2:OriginState>
												
												<!---
												<web2:PaymentAmount>#vwLoadsITS.PaymentAmount#</web2:PaymentAmount>
												--->
												
												<web2:PickUpDate>#dateformat(vwLoadsITS.PickupDate,'yyyy-mm-dd')#</web2:PickUpDate>
												<web2:PickUpTime>#vwLoadsITS.PickupTime#</web2:PickUpTime>
												<web2:Quantity>1</web2:Quantity>
												<web2:SpecInfo>#escapeSpecialCharacters(vwLoadsITS.Notes)#</web2:SpecInfo>
												<web2:TypeOfEquipment>#vwLoadsITS.TypeofEquipment#</web2:TypeOfEquipment>
												<web2:Weight>#vwLoadsITS.Weight#</web2:Weight>
												<web2:Width>#vwLoadsITS.Width#</web2:Width>
											</web2:Load>
										</web1:Loads>
									</v11:loads>
								</v11:PostLoads>
							</soapenv:Body>
						</soapenv:Envelope>

					</cfsavecontent>
				</cfoutput>
					
				<!--- Insert into ITS --->
				    <!--- LIVE URL --- <cfhttp method="post" url="http://webservices.truckstop.com/V13/Posting/LoadPosting.svc" result="objGet"> ---> 
				 	<!--- TEST URL --- <cfhttp method="post" url="http://testws.truckstop.com:8080/V13/Posting/LoadPosting.svc" result="objGet"> ---> 
					<cfhttp method="post" url="http://webservices.truckstop.com/V13/Posting/LoadPosting.svc" result="objGet">				
					<cfhttpparam type="header" name="SOAPAction" value="http://webservices.truckstop.com/v11/ILoadPosting/PostLoads"/>
					<cfhttpparam type="xml"  value="#trim( soapHeaderPosttoITStxt )#" />
				</cfhttp>
				<cfif objGet.Statuscode EQ "200 OK">
					<cfset objGetITS =  objGet.filecontent />
					<cfset PostToITSResponse = xmlParse(objGetITS) />
					<cfset postAssetSuccess_res = XmlSearch(PostToITSResponse,"//*[name()='ErrorMessage']") />
					
					<cfif arrayLen(postAssetSuccess_res) NEQ 0>
						<!-----if fail----->
						<cfset sts='Fail' />
					<!---	
						<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
							update Loads SET posttoITS = 0  where http://webservices.truckstop.com/V13/Posting/LoadPosting.svc = #arguments.impref# 
						</cfquery>
						--->
			   				<cfset Alertvar ="1" />
			
						<cfif postAssetSuccess_res[1].xmltext NEQ "">
							<cfset Alertvar = postAssetSuccess_res[1].xmltext >
						</cfif>
						
						<cfif Alertvar EQ  1>
							<cfset Alertvar="Your ITS Webservice status failed. 100" />
						</cfif>
					<cfelse>
						<!----if success---->
						<cfset sts='Success' />
						<cfset Alertvar="1" />
						
						<cfquery name="ITSFlagInsert" datasource="#variables.dsn#">
							update Loads SET posttoITS = 1 where loadnumber = #arguments.impref#
						</cfquery>
						
						<!-----delete old asset from DB if any---->
						<cfquery name="GetTranceCoreDBcount" datasource="#variables.dsn#">
							delete from LoadPostEverywhereDetails where imprtref='#arguments.impref#' and From_web='ITS' and status='Success' 
						</cfquery>
					</cfif>
					<!-----Insert new asset from DB if any---->
					<cfquery name="PEPinsert" datasource="#variables.dsn#">
						INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#soapHeaderPosttoITStxt#','#objGet.filecontent#','#arguments.impref#','ITS','#sts#') 
					</cfquery>
				<cfelse>
					<cfset Alertvar="Connection failure in ITS. 101" />
				</cfif>
					
			<cfelseif arguments.postaction EQ 'U'>
				<!--- Update Post in ITS --->
				<cfoutput>
					<cfsavecontent variable="soapHeaderPosttoITSTxt">
						<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://webservices.truckstop.com/v11" xmlns:web="http://schemas.datacontract.org/2004/07/WebServices" xmlns:web1="http://schemas.datacontract.org/2004/07/WebServices.Posting" xmlns:web2="http://schemas.datacontract.org/2004/07/WebServices.Objects" xmlns:truc="http://schemas.datacontract.org/2004/07/Truckstop2.Objects">
							<soapenv:Header/>
							<soapenv:Body>
								<v11:PostLoads>
									<v11:loads>
										<web:IntegrationId>#arguments.ITSintegrationID#</web:IntegrationId>
										<web:Password>#arguments.ITSPassword#</web:Password>
										<web:UserName>#arguments.ITSUsername#</web:UserName>
										<web1:Loads>
											<web2:Load>
												<web2:DeliveryDate>#dateformat(vwLoadsITS.DeliveryDate,'yyyy-mm-dd')#</web2:DeliveryDate>
												<web2:DeliveryTime>#vwLoadsITS.DeliveryTime#</web2:DeliveryTime>
												<web2:DestinationCity>#vwLoadsITS.DestCity#</web2:DestinationCity>
												<web2:DestinationState>#vwLoadsITS.DestState#</web2:DestinationState>
												<web2:IsFavorite>0</web2:IsFavorite>
												<web2:IsLoadFull>#vwLoadsITS.FullOrPartial#</web2:IsLoadFull>
												<web2:Length>#vwLoadsITS.Length#</web2:Length>
												<web2:LoadId>0</web2:LoadId>
												<web2:LoadNumber>#vwLoadsITS.ImportRef#</web2:LoadNumber>
												<web2:OriginCity>#vwLoadsITS.OriginCity#</web2:OriginCity>
												<web2:OriginState>#vwLoadsITS.OriginState#</web2:OriginState>
												
												<!---
												<web2:PaymentAmount>#vwLoadsITS.PaymentAmount#</web2:PaymentAmount>
												--->
												
												<web2:PickUpDate>#dateformat(vwLoadsITS.PickupDate,'yyyy-mm-dd')#</web2:PickUpDate>
												<web2:PickUpTime>#vwLoadsITS.PickupTime#</web2:PickUpTime>
												<web2:Quantity>1</web2:Quantity>
												<web2:SpecInfo>#escapeSpecialCharacters(vwLoadsITS.Notes)#</web2:SpecInfo>											<web2:TypeOfEquipment>#vwLoadsITS.TypeofEquipment#</web2:TypeOfEquipment>
												<web2:Weight>#vwLoadsITS.Weight#</web2:Weight>
												<web2:Width>#vwLoadsITS.Width#</web2:Width>
											</web2:Load>
										</web1:Loads>
									</v11:loads>
								</v11:PostLoads>
							</soapenv:Body>
						</soapenv:Envelope>
					</cfsavecontent>
					
				</cfoutput>
				<!--- Update to ITS --->
				<!--- LIVE URL --- <cfhttp method="post" url="http://webservices.truckstop.com/V13/Posting/LoadPosting.svc" result="objGet"> ---> 
				<!--- TEST URL --- <cfhttp method="post" url="http://testws.truckstop.com:8080/V13/Posting/LoadPosting.svc" result="objGet"> ---> 
				<cfhttp method="post" url="http://webservices.truckstop.com/V13/Posting/LoadPosting.svc" result="objGet">				
					<cfhttpparam type="header" name="SOAPAction" value= "http://webservices.truckstop.com/v11/ILoadPosting/PostLoads" />
					<cfhttpparam type="xml"  value="#trim(soapHeaderPosttoITSTxt)#" />
				</cfhttp>
				<cfif objGet.Statuscode EQ "200 OK">
					<cfset objGetITS =  objGet.filecontent />
					<cfset PostToITSResponse = xmlParse( objGetITS ) />
					<cfset updateAssetSuccess_res = XmlSearch(PostToITSResponse,"//*[name()='ErrorMessage']") />
					
					<cfif arrayLen(updateAssetSuccess_res) NEQ 0>
						<!--- If fail --->
						<cfset sts='Fail' />
						<cfset Alertvar =1 />
						
						<cfif updateAssetSuccess_res[1].XmlText NEQ "">
							<cfset Alertvar = updateAssetSuccess_res[1].XmlText/>
						</cfif>
						
						<cfif Alertvar EQ 1 >
							<cfset Alertvar="Your ITS Webservice status is Failed. 102" />
						</cfif>
						
						<cfquery name="ITSinsert" datasource="#variables.dsn#">
							INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#soapHeaderPosttoITSTxt#','#objGet.filecontent#','#arguments.impref#','ITS','#sts#') 
						</cfquery>
					<cfelse>
						<!--- If success --->
						<cfset Alertvar	= 1 />
						
						<cfquery name="ITSFlaginsert" datasource="#variables.dsn#">
							UPDATE Loads SET posttoITS = 1 WHERE loadnumber = #arguments.impref# 
						</cfquery>
						
						<cfquery name="UpdateAsset" datasource="#variables.dsn#">
							UPDATE LoadPostEverywhereDetails
							SET 
								Postrequest_text	= '#soapHeaderPosttoITStxt#',
								Response_text		= '#objGet.filecontent#',
								created				= GETDATE()
							WHERE imprtref = '#arguments.impref#' AND From_web = 'ITS' AND status = 'Success'
						</cfquery>
					</cfif>
				<cfelse>
					<cfset Alertvar="Connection failure in ITS. 103" />
				</cfif>
				
			<cfelseif arguments.postaction EQ 'D'>
				<cfoutput>
					<cfsavecontent variable="soapHeaderDeleteITSTxt">
						<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://webservices.truckstop.com/v11" xmlns:web="http://schemas.datacontract.org/2004/07/WebServices" xmlns:web1="http://schemas.datacontract.org/2004/07/WebServices.Posting" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
							<soapenv:Header/>
							<soapenv:Body>
								<v11:DeleteLoadsByLoadNumber>
									<v11:deleteRequest>
										<web:IntegrationId>#arguments.ITSintegrationID#</web:IntegrationId>
										<web:Password>#arguments.ITSPassword#</web:Password>
										<web:UserName>#arguments.ITSUsername#</web:UserName>
										<web1:LoadNumbers>
											<arr:string>#vwLoadsITS.ImportRef#</arr:string>
										</web1:LoadNumbers>
									</v11:deleteRequest>
								</v11:DeleteLoadsByLoadNumber>
							</soapenv:Body>
						</soapenv:Envelope>
					</cfsavecontent>
				</cfoutput>
				
				<!--- Delete from ITS --->
				    <!--- LIVE URL --- <cfhttp method="post" url="http://webservices.truckstop.com/V13/Posting/LoadPosting.svc" result="objGet"> ---> 
				 	<!--- TEST URL --- <cfhttp method="post" url="http://testws.truckstop.com:8080/V13/Posting/LoadPosting.svc" result="objGet"> ---> 
					<cfhttp method="post" url="http://webservices.truckstop.com/V13/Posting/LoadPosting.svc" result="objGet">				
					<cfhttpparam type="header" name="SOAPAction" value="http://webservices.truckstop.com/v11/ILoadPosting/DeleteLoadsByLoadNumber"/>
					<cfhttpparam type="xml"  value="#trim(soapHeaderDeleteITSTxt)#" />
				</cfhttp>
				<cfif objGet.Statuscode EQ "200 OK">
					<cfset textResponse = objget.filecontent>
					<cfset PostToITSResponse = xmlparse(textResponse)>
					<cfset deleteAssetSuccess_res = XmlSearch(PostToITSResponse,"//*[name()='ErrorMessage']") />
				
					<cfif arrayLen(deleteAssetSuccess_res) NEQ 0>
						<!----if Fail---->
						<cfset sts = 'Fail' />
						<cfset Alertvar="1" />
						
						<cfif deleteAssetSuccess_res[1].XmlText NEQ "">
							<cfset Alertvar = deleteAssetSuccess_res[1].XmlText/>
						</cfif>
						
						<cfif Alertvar EQ 1 >
							<cfset Alertvar="Your ITS Webservice status is Failed. 104" />
						</cfif>
						
						<cfquery name="ITSinsert" datasource="#variables.dsn#">
							INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#soapHeaderDeleteITSTxt#','#objget.filecontent#','#arguments.impref#','ITS','#sts#') 
						</cfquery>
					<cfelse>
						
						<!----if Success---->
						<cfset sts = 'Success' />
						<cfset Alertvar = 1 />
						<cfquery name="ITSFlaginsert" datasource="#variables.dsn#">
							UPDATE Loads SET posttoITS = 0 WHERE loadnumber = #arguments.impref# 
						</cfquery>
							
						<cfquery name="ITSinsert" datasource="#variables.dsn#">
							DELETE FROM LoadPostEverywhereDetails WHERE imprtref = '#arguments.impref#' AND From_web = 'ITS' AND status = 'Success'
						</cfquery>
					</cfif>
				<cfelse>
					<cfset Alertvar="Connection failure in ITS. 105" />
				</cfif>
			</cfif> 
			
			<cfif Alertvar neq 1>
				<cfset Alertvar="ITS Says : "&Alertvar />
			</cfif>
			
			<cfif isdefined("Prev_sts")>
				<cfset Alertvar=Alertvar&"!!!" />
			</cfif>
			<cfreturn Alertvar />
			
			 <cfcatch type="any">
			 <cfdump var="#cfcatch#"><cfabort>
				<cfset Alertvar='Cannot post to ITS because the Address is not valid.' />
				<cfreturn Alertvar />
			</cfcatch>
		</cftry> 
	</cffunction>
		
	<!-------------posttoITS WEBERVICE End----------------->

	<!-------------posteverywhereWEBERVICE----------------->

	<cffunction name="Posteverywhere" returntype="any" access="remote" returnformat="JSON">
		<cfargument name="impref" type="any" required="yes"> 
		<cfargument name="POSTACTION" type="any" required="yes">
		<cfargument name="PEPcustomerKey" type="any" required="yes">
		<cfargument name="PEPsecretKey" type="any" required="yes"> 
		<cfargument name="dsn" type="any" required="no" />
		<cfif structkeyexists(arguments,"dsn")>
			<cfset variables.dsn=arguments.dsn>	
		<cfelse>
			<cfset variables.dsn=variables.dsn>	
		</cfif>	
		<cfquery name="ViewPostEveryWhere" datasource="#variables.dsn#">
				select * from vwLoadsPostEveryWhere where ImportRef='#arguments.impref#'			
			</cfquery>
			<cfif ViewPostEveryWhere.length eq 0  or  ViewPostEveryWhere.length eq "">
				<cfset ViewPostEveryWhere.length=48>
			</cfif>
			<cfif ViewPostEveryWhere.FullOrPartial eq false  or  ViewPostEveryWhere.FullOrPartial eq "">
				<cfset FullOrPartial='Full'>
			<cfelse>
				<cfset FullOrPartial='Partial'>
			</cfif>
			
	 	<cfset strXML="
		 
		<PostLoads.Many>
		
		   <LoadDO>
		
			  <postAction>#arguments.postaction#</postAction>
		
			  <importRef>#ViewPostEveryWhere.ImportRef#</importRef>
		
			  <originCity>#ViewPostEveryWhere.OriginCity#</originCity>
		
			  <originState>#ViewPostEveryWhere.OriginState#</originState>
		
			  <pickupDate>#dateformat(ViewPostEveryWhere.PickupDate,'YYYY-MM-DD')#</pickupDate>
		
			  <destCity>#ViewPostEveryWhere.DestCity#</destCity>
		
			  <destState>#ViewPostEveryWhere.DestState#</destState>
		
			  <truckType>#ViewPostEveryWhere.TruckType#</truckType>
		
			  <fullOrPartial>#FullOrPartial#</fullOrPartial>
		
			  <length>#ViewPostEveryWhere.length#</length>
		
			  <weight>#ViewPostEveryWhere.Weight#</weight>
			  
		 	  <deliveryDate>#dateformat(ViewPostEveryWhere.FinalDelivDate,'YYYY-MM-DD')#</deliveryDate>
			  <comment> </comment>
		
		   </LoadDO>
		 
		 </PostLoads.Many>">
	     <cfhttp method="post" url="http://app.posteverywhere.com/webservices/PostLoads.php" useragent="#CGI.http_user_agent#" result="objGet">
			<cfhttpparam type="url" name="ServiceKey" value="#arguments.PEPsecretKey#"/>
			<cfhttpparam type="url" name="CustomerKey"  value="#arguments.PEPcustomerKey#"/>
			<cfhttpparam type="url"  name="ServiceAction"  value="Many" />
			<cfhttpparam type="body" value="#strXML.Trim()#"/>
		</cfhttp>  
		<cfset test=#findnocase("APPROVED",objGet.FileContent)# >
		<cfif test neq 0>
			<cfset Alertvar="1">
		<cfelse>
			<cfif #findnocase("JPE01149",objGet.FileContent)# neq 0>
				<cfset Alertvar="Posting FAILED and returned this error: Missing or invalid Web Services Key">
			<cfelseif  #findnocase("JPE05900",objGet.FileContent)# neq 0>
				<cfset Alertvar="Posting FAILED and returned this error: Please enter a valid length between 1 and 57">
			<cfelseif  #findnocase("JPE01133",objGet.FileContent)# neq 0>
				<cfset Alertvar="Posting FAILED and returned this error: There was an error processing your request">
			<cfelseif  #findnocase("FAILED",objGet.FileContent)# neq 0>
				<cfset Alertvar="Posting FAILED and returned this error: Missing or invalid Web Services Key">
			<cfelse>
				<cfset Alertvar="Posting FAILED and returned this error: There was an error processing your request ">
			</cfif>
			
			<cfquery name="PEPinsert" datasource="#variables.dsn#">
				UPDATE Loads SET iSPost = 0 WHERE loadnumber = '#arguments.impref#'
			</cfquery>
		</cfif>

		<cfquery name="PEPinsert" datasource="#variables.dsn#">
			insert into LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref) values('#strXML.Trim()#','#objGet.FileContent#','#arguments.impref#')
		</cfquery>
	 
		<cfif Alertvar neq 1>
			<cfset Alertvar="Post Everywhere Says : "&Alertvar>
		</cfif>
	 
		<cfreturn Alertvar >
		 
	</cffunction>

	<!------------------posteverywhere end---------->


	<!---------------Transcore 360 webservice---->

	<cffunction name="Transcore360Webservice" returntype="any" access="remote" returnformat="wddx">
		<cfargument name="impref" type="any" required="true" />
		<cfargument name="postaction" type="any" required="true" />
		<cfargument name="trans360Usename" type="any" required="true" />
		<cfargument name="trans360Password" type="any" required="true" />
		<cfargument name="dsn" type="any" required="no" />
		<cfparam name="Alertvar" default="1">
		<cfparam name="variables.EquipmentName" default="">
		<cfparam name="variables.OriginCity" default="">
		<cfparam name="variables.OriginState" default="">
		<cfparam name="variables.DestCity" default="">
		<cfparam name="variables.DestState" default="">
		<cfparam name="variables.Weight" default="0">
		<cfparam name="variables.Notes" default="">
		<cfparam name="variables.length" default="1">
		<cfparam name="variables.PickupDate" default="">
		<cfparam name="variables.FinalDelivDate" default="">
		<cftry>
			<cfoutput>
				<cfif structkeyexists(arguments,"dsn")>
					<cfset variables.dsn=arguments.dsn>	
				<cfelse>
					<cfset variables.dsn=variables.dsn>	
				</cfif>	
				<cfquery name="ViewPostEveryWhere" datasource="#variables.dsn#">
					select * from vwLoadsTranscore where loadnumber='#arguments.impref#' 
				</cfquery>	
				<cfif ViewPostEveryWhere.recordcount>
					<cfset variables.EquipmentName=ViewPostEveryWhere.EquipmentName>
					<cfset variables.OriginCity=ViewPostEveryWhere.OriginCity>
					<cfset variables.OriginState=ViewPostEveryWhere.OriginState>
					<cfset variables.DestCity=ViewPostEveryWhere.DestCity>
					<cfset variables.DestState=ViewPostEveryWhere.DestState>
					<cfset variables.Weight=ViewPostEveryWhere.Weight>
					<cfset variables.PickupDate=ViewPostEveryWhere.PickupDate>
					<cfset variables.FinalDelivDate=ViewPostEveryWhere.FinalDelivDate>
					<cfset variables.length=ViewPostEveryWhere.length>
					<cfset variables.Notes=ViewPostEveryWhere.Notes>
				</cfif>
				<cfif ViewPostEveryWhere.length eq 0  or  ViewPostEveryWhere.length eq "">
					<cfset ViewPostEveryWhere.length=1 />
				</cfif>
				
				<cfif ViewPostEveryWhere.FullOrPartial eq false  or  ViewPostEveryWhere.FullOrPartial eq "">
					<cfset FullOrPartial='false' />
				<cfelse>
					<cfset FullOrPartial='true' />
				</cfif>
				<!---cfif  not structkeyexists(session,'primaryKey') and not structkeyexists(session,'SeconKey')  --->
					<!------login request----->
					<cfsavecontent variable="soapHeaderTransCoreTxt">
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
									<tcor:applicationVersion>2</tcor:applicationVersion>
								</tcor:applicationHeader>
							</soapenv:Header>
							<soapenv:Body>
								<tfm:loginRequest>
									<tfm:loginOperation>
										<tfm:loginId>#trans360Usename#</tfm:loginId>
										<tfm:password>#trans360Password#</tfm:password>
										<tfm:thirdPartyId>TFMI</tfm:thirdPartyId>
										<tfm:apiVersion>2</tfm:apiVersion>
									</tfm:loginOperation>
								</tfm:loginRequest>
							</soapenv:Body>
						</soapenv:Envelope>
					</cfsavecontent>
					
					<!--- TEST URL --->
	<!---				<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="TranscoreData360">
						<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTxt )#" />
					</cfhttp>				
					--->
						
					
					<!--- LIVE URL --->
					<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="TranscoreData360">
						<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTxt )#" />
					</cfhttp>
						
					<cfset soapResponse = xmlParse( TranscoreData360.FileContent ) />
					
					<cfset arr_primary		= XmlSearch(soapResponse,"//*[name()='tcor:primary']")>
					<cfset arr_secondary	= XmlSearch(soapResponse,"//*[name()='tcor:secondary']")>
					<cfif arrayLen(arr_primary) AND  arrayLen(arr_secondary)>
						<cfset session.primaryKey	= arr_primary />
						<cfset session.SeconKey		= arr_secondary />
						<cfset session.timesession_exp = XmlSearch(soapResponse,"//*[name()='tfm:expiration']") />
					<cfelse>
						<cfset arr_error	= XmlSearch(soapResponse,"//*[name()='tcor:message']")>
						<cfif arrayLen(arr_error)>
							<cfset Alertvar= "Transcore Says : "&arr_error[1].XmlText>
						<cfelse>
							<cfset Alertvar='Transcore connection failure error. Call Tech Support for more assistance.' />
						</cfif>
						<cfreturn Alertvar />
					</cfif>
					<!------End login request----->
				<!---/cfif--->
			</cfoutput>
						
			<cftransaction>
				<cfif arguments.postaction EQ 'D'><!--- Delete from Tanscore360 --->
					<cfquery name="GetTranceCoreDBcount" datasource="#variables.dsn#">
						SELECT imprtref FROM LoadPostEverywhereDetails WHERE imprtref='#arguments.impref#' AND From_web='Tc360' AND status='success'
					</cfquery>
					
					<cfif GetTranceCoreDBcount.recordcount GT 0>
						<!-----Delete asset from TranceCore---->
						<cfoutput>
							<cfsavecontent variable="soapHeaderDelAsstCoreTxt">
								<Envelope 
									xmlns="http://schemas.xmlsoap.org/soap/envelope/" 
									xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" 
									xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" 
									xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
									<Header>
										<tcor:sessionHeader>
											<tcor:sessionToken>
												<tcor1:primary>#trim(session.primaryKey[1].XmlText)#</tcor1:primary>
												<tcor1:secondary>#trim(session.SeconKey[1].XmlText)#</tcor1:secondary>
											</tcor:sessionToken>
										</tcor:sessionHeader>
									</Header>
									<Body>
										<tfm:deleteAssetRequest>
											<tfm:deleteAssetOperation>
												<tfm:deleteAssetByPostersReferenceId>
													<tfm:postersReferenceId>#arguments.impref#</tfm:postersReferenceId>
												</tfm:deleteAssetByPostersReferenceId>
											</tfm:deleteAssetOperation>
										</tfm:deleteAssetRequest>
									</Body>
								</Envelope>
							</cfsavecontent>
						</cfoutput>
						
						<!--- TEST URL --->			
	<!---					<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="searchlookup_res">
							<cfhttpparam type="xml"  value="#trim( soapHeaderDelAsstCoreTxt )#" />
						</cfhttp>					
						--->
						
						<!--- LIVE URL --->
						<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="searchlookup_res">
							<cfhttpparam type="xml"  value="#trim( soapHeaderDelAsstCoreTxt )#" />
						</cfhttp>
					</cfif>
					
					<cfset Alertvar = "This Load sucessfully deleted from DAT Loadboard " />
					
					<!-----Delete asset from DB if any---->
					<cfquery name="GetTranceCoreDBcount" datasource="#variables.dsn#">
						DELETE FROM LoadPostEverywhereDetails WHERE imprtref='#arguments.impref#' AND From_web='Tc360' AND status='success'
					</cfquery>
					
					<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
						update Loads SET IsTransCorePst=0, Trans_Sucess_Flag=0 WHERE ControlNumber=#arguments.impref#
					</cfquery>
					
			
				<cfelseif arguments.postaction EQ 'A'>
					<!------Post asset to trancecore----->
					<cfoutput>
						<cfsavecontent variable="soapHeaderTransCoreTokenTxt">
							<Envelope 
								xmlns="http://schemas.xmlsoap.org/soap/envelope/" 
								xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" 
								xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" 
								xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
								<Header>
									<tcor:sessionHeader>
										<tcor:sessionToken>
											<tcor1:primary>#session.primaryKey[1].XmlText#</tcor1:primary>
											<tcor1:secondary>#session.SeconKey[1].XmlText#</tcor1:secondary>
										</tcor:sessionToken>
									</tcor:sessionHeader>
								</Header>
								<Body>
									<tfm:postAssetRequest>
										<tfm:postAssetOperations>
											<tfm:shipment>
												<tfm:equipmentType>#variables.EquipmentName#</tfm:equipmentType>
												<tfm:origin>
													<tfm:cityAndState>
														<tfm:city>#variables.OriginCity#</tfm:city>
														<tfm:stateProvince>#variables.OriginState#</tfm:stateProvince>
													</tfm:cityAndState>
												</tfm:origin>
												<tfm:destination>
													<tfm:cityAndState>
														<tfm:city>#variables.DestCity#</tfm:city>
														<tfm:stateProvince>#variables.DestState#</tfm:stateProvince>
													</tfm:cityAndState>
												</tfm:destination>
											</tfm:shipment>
											<tfm:postersReferenceId>#arguments.impref#</tfm:postersReferenceId>
											<tfm:ltl>#FullOrPartial#</tfm:ltl>
											<tfm:comments>#variables.Notes#</tfm:comments>
											<tfm:dimensions>
												<tfm:lengthFeet>#variables.length#</tfm:lengthFeet>
												<tfm:weightPounds>
													<cfif not isnumeric(variables.Weight) or variables.Weight eq 0>
														1
													<cfelse>
														#variables.Weight#
													</cfif>
												</tfm:weightPounds>
											</tfm:dimensions>
											<tfm:availability>
												<tfm:earliest>
													#dateformat(variables.PickupDate,"yyyy-mm-dd")#T08:00:00.000Z
												</tfm:earliest>
	<!---											<tfm:latest>
													#dateformat(variables.FinalDelivDate,"yyyy-mm-dd")#T08:00:00.000Z
												</tfm:latest>--->
											</tfm:availability>
											<tfm:includeAsset>false</tfm:includeAsset>
										</tfm:postAssetOperations>
									</tfm:postAssetRequest>
								</Body>
							</Envelope>
						</cfsavecontent>
					</cfoutput>
					
					<!--- Insert into transcore --->

					<!--- TEST URL --->
	<!---				<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="objGet">
						<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
					</cfhttp>--->

					
					<!--- LIVE URL --->
					<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="objGet">
						<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
					</cfhttp>
						
					<cfset objGet360 =  objGet.filecontent />
					<cfset TranscoreobjGetData3601 = xmlParse( objGet360 ) />
					<cfset postAssetSuccess_res = XmlSearch(TranscoreobjGetData3601,"//*[name()='tfm:postAssetSuccessData']") />
					<!---<cfset errorInResult = XmlSearch(TranscoreobjGetData3601,"//*[name()='tcor:detailedMessage']") />--->
					<cfset errorInResult = XmlSearch(TranscoreobjGetData3601,"//*[name()='message']") />
					
					<!---cfif arraylen(errorInResult)>	
						<cfif not findnocase("Reference ID already exists",errorInResult[1].XmlText)--->
					
					<cfif arraylen(postAssetSuccess_res) eq 0>	
						<cfquery name="GetTranceCoreDBcount" datasource="#variables.dsn#">
							select imprtref,Postrequest_text from LoadPostEverywhereDetails where imprtref='#arguments.impref#' and From_web='Tc360' and status='success' 
						</cfquery>
						<cfif GetTranceCoreDBcount.recordcount gt 0>
							<!-----rechecking prepost if fail----->
							<!------Post asset to trancecore----->
							<cfoutput>
								<cfsavecontent variable="soapHeaderTransCoreHead">
									<Header>
										<tcor:sessionHeader>
											<tcor:sessionToken>
												<tcor1:primary>#session.primaryKey[1].XmlText#</tcor1:primary>
												<tcor1:secondary>#session.SeconKey[1].XmlText#</tcor1:secondary>
											</tcor:sessionToken>
										</tcor:sessionHeader>
									</Header>
								</cfsavecontent>
								<cfset strHXml = reReplace(GetTranceCoreDBcount.Postrequest_text, "<Header>(.*?)</Header>", soapHeaderTransCoreHead) />
								<cfsavecontent variable="soapHeaderTransCoreTokenTxt">
									#trim(strHXml)# 
								</cfsavecontent>
							</cfoutput>
							<!--- Test URL --->
	<!---						<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="objGet1">
								<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
							</cfhttp>--->
							<!--- Live URL --->
							<!---cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="objGet1">
								<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
							</cfhttp--->	
							<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="objGet1">
								<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
							</cfhttp>
							<cfset objGet3601 =  objGet1.filecontent />
							<cfset TranscoreobjGetData36011 = xmlParse( objGet3601 ) />
							<cfset postAssetSuccess_res1 = XmlSearch(TranscoreobjGetData36011,"//*[name()='tfm:postAssetSuccessData']") />
							<cfif arraylen(postAssetSuccess_res1) eq 0>
								<!-----if fail----->
								<cfset sts='Fail' />							
								<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
									update Loads SET IsTransCorePst=0,Trans_Sucess_Flag=0 where controlNumber=#arguments.impref# 
								</cfquery>
								<cfset Alertvar ="1" />
								<cfset msg = XmlSearch(TranscoreobjGetData36011,"//*[name()='message']") />
								<cfif arraylen(msg) eq 0>
									<cfset Alertvar ="1" />
									<cfset msg1 = XmlSearch(TranscoreobjGetData36011,"//*[name()='tcor:message']") />
									<cfif arraylen(msg1) eq 0>
										<cfset Alertvar ="1" />
									<cfelse>
										<cfset Alertvar=replace(#msg1[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
									</cfif>
								<cfelse>
									<cfset Alertvar=replace(#msg[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
								</cfif>
								<cfif Alertvar eq  1>
									<cfset Alertvar="Your Transcore Webservice status is Failed" />
								</cfif>
								<!-----if fail----->
							<cfelse>
								<!----if success---->
								<cfset sts='success' />
								<cfset Prev_sts='success' />
								<cfset Alertvar="1" />
								<cfset msg = XmlSearch(TranscoreobjGetData3601,"//*[name()='message']") />
								<cfif arraylen(msg) eq 0>
									<cfset Alertvar ="1" />
									<cfset msg1 = XmlSearch(TranscoreobjGetData3601,"//*[name()='tcor:message']") />
									<cfif arraylen(msg1) eq 0>
										<cfset Alertvar ="1" />
									<cfelse>
										<cfset Alertvar=replace(#msg1[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
									</cfif>
								<cfelse>
									<cfset Alertvar=replace(#msg[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
								</cfif>
								<cfif Alertvar eq  1>
									<cfset Alertvar="Your Transcore Webservice status is Failed" />
								</cfif>							
								<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
									update Loads SET IsTransCorePst=1,Trans_Sucess_Flag=1 where controlNumber=#arguments.impref# 
								</cfquery>
								<!-----if success--->
							</cfif>
							<!-----rechecking prepost if fail----->
						<cfelse>
							<!-----if fail----->
							<cfset sts='Fail' />
							<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
								update Loads SET IsTransCorePst=0,Trans_Sucess_Flag=0 where controlNumber=#arguments.impref# 
							</cfquery>
							<cfset Alertvar ="1" />
							<cfset msg = XmlSearch(TranscoreobjGetData3601,"//*[name()='message']") />
							<cfif arraylen(msg) eq 0>
								<cfset Alertvar ="1" />
								<cfset msg1 = XmlSearch(TranscoreobjGetData3601,"//*[name()='tcor:message']") />
								<cfif arraylen(msg1) eq 0>
									<cfset Alertvar ="1" />
								<cfelse>
									<cfset Alertvar=replace(#msg1[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
								</cfif>
							<cfelse>
								<cfset Alertvar=replace(#msg[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
							</cfif>
							<cfif Alertvar eq  1>
								<cfset Alertvar="Your Transcore Webservice status is Failed" />
							</cfif>
							<!-----if fail----->
						</cfif>
					<cfelse>
						<!----if success---->
						<cfset sts='success' />
						<cfset Alertvar="You have successfully posted to Dat Loadboard" />
						<cfquery name="TransFlaginsert" datasource="#variables.dsn#" result="mm">
							update Loads SET IsTransCorePst=1,Trans_Sucess_Flag=1 where LOADNUMBER=#arguments.impref# 
						</cfquery>
						<!-----if success--->
					</cfif>
						<!-----delete asset from DB if any---->
						<cfquery name="GetTranceCoreDBcount" datasource="#variables.dsn#">
							delete from LoadPostEverywhereDetails where imprtref='#ViewPostEveryWhere.IMPORTREF#' and From_web='Tc360' and status='success' 
							<!--- delete from LoadPostEverywhereDetails where imprtref='#arguments.impref#' and From_web='Tc360' and status='success' --->
						</cfquery>
						<!-----Insert new asset from DB if any---->
						<cfquery name="PEPinsert" datasource="#variables.dsn#">
							INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#soapHeaderTransCoreTokenTxt#','#objGet.FileContent#','#ViewPostEveryWhere.IMPORTREF#','Tc360','#sts#')
							<!--- INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#soapHeaderTransCoreTokenTxt#','#objGet.FileContent#','#arguments.impref#','Tc360','#sts#') --->
						</cfquery>	
				<cfelseif arguments.postaction EQ 'U'>
					<!--- <cfif REMOTE_ADDR eq '202.88.237.237'>
						<cfoutput>
							<cfsavecontent variable="soapHeaderDelAsstCoreTxt">
								<?xml version="1.0" encoding="UTF-8"?>
									<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
									   <soapenv:Header>
										  <tcor:sessionHeader soapenv:mustUnderstand="1">
											 <tcor:sessionToken>
												<tcor1:primary>#session.primaryKey[1].XmlText#</tcor1:primary>
												<tcor1:secondary>#session.SeconKey[1].XmlText#</tcor1:secondary>
											 </tcor:sessionToken>
										  </tcor:sessionHeader>
										  <tcor:correlationHeader soapenv:mustUnderstand="0">
										  </tcor:correlationHeader>
										  <tcor:applicationHeader soapenv:mustUnderstand="0">
											 <tcor:application></tcor:application>
											 <tcor:applicationVersion></tcor:applicationVersion>
										  </tcor:applicationHeader>
									   </soapenv:Header>
									   <soapenv:Body>
										  <tfm:updateAssetRequest>
											 <tfm:updateAssetOperation>
												<!--You have a CHOICE of the next 2 items at this level-->
												<tfm:assetId>DS18LJ9R</tfm:assetId>
												<!--You have a CHOICE of the next 2 items at this level-->
												<tfm:shipmentUpdate>
												   <!--Optional:-->
												   <tfm:ltl>false</tfm:ltl>
												   <!--0 to 2 repetitions:-->
												   <tfm:comments>#variables.Notes#</tfm:comments>
												   <!--Optional:-->
												   <tfm:dimensions>
									                  <!--Optional:-->
									                  <tfm:lengthFeet>10</tfm:lengthFeet>
									                  <!--Optional:-->
									                  <tfm:weightPounds>30</tfm:weightPounds>
									               </tfm:dimensions>
									               <tfm:stops>1</tfm:stops>
												   <tfm:truckStops>
													  	<!--You have a CHOICE of the next 3 items at this level-->
													  	<tfm:truckStopIds>
															 <!--1 or more repetitions:-->
															 <tfm:ids>1</tfm:ids>
													  	</tfm:truckStopIds>
													  	 <tfm:alternateClosest>
								                            <!--You have a CHOICE of the next 5 items at this level-->
								                            <tfm:postalCode>
								                                <tfm:country>usa</tfm:country>
								                                <tfm:code>11787</tfm:code>
								                            </tfm:postalCode>
								                     
								                        </tfm:alternateClosest>
								                        <tfm:enhancements>Highlight</tfm:enhancements>
												   </tfm:truckStops>
												</tfm:shipmentUpdate>
											 </tfm:updateAssetOperation>
										  </tfm:updateAssetRequest>
									   </soapenv:Body>
									</soapenv:Envelope>
							</cfsavecontent>
						</cfoutput>
					
						<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="objGet">
							<cfhttpparam type="xml"  value="#trim( soapHeaderDelAsstCoreTxt )#" />
						</cfhttp>
						<CFDUMP VAR="#objGet#">
						<CFDUMP VAR="#soapHeaderDelAsstCoreTxt#">
						<cfabort>


						<cfset objGet360 =  objGet.filecontent />
						<cfset TranscoreobjGetData3601 = xmlParse( objGet360 ) />
						<cfdump var="1">
						<cfdump var="#objGet#"><cfabort>
					<cfelse>	 --->
						<cfoutput>
							<cfsavecontent variable="soapHeaderDelAsstCoreTxt">
								<Envelope 
									xmlns="http://schemas.xmlsoap.org/soap/envelope/" 
									xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" 
									xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" 
									xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
									<Header>
										<tcor:sessionHeader>
											<tcor:sessionToken>
												<tcor1:primary>#session.primaryKey[1].XmlText#</tcor1:primary>
												<tcor1:secondary>#session.SeconKey[1].XmlText#</tcor1:secondary>
											</tcor:sessionToken>
										</tcor:sessionHeader>
									</Header>
									<Body>
										<tfm:deleteAssetRequest>
											<tfm:deleteAssetOperation>
												<tfm:deleteAssetByPostersReferenceId>
													<tfm:postersReferenceId>#arguments.impref#</tfm:postersReferenceId>
												</tfm:deleteAssetByPostersReferenceId>
											</tfm:deleteAssetOperation>
										</tfm:deleteAssetRequest>
									</Body>
								</Envelope>
							</cfsavecontent>
						</cfoutput>
						<!--- TEST URL --->			
	<!---					<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="searchlookup_res">
							<cfhttpparam type="xml"  value="#trim( soapHeaderDelAsstCoreTxt )#" />
						</cfhttp>					
						--->
						<!--- LIVE URL --->
						<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="searchlookup_res">
							<cfhttpparam type="xml"  value="#trim( soapHeaderDelAsstCoreTxt )#" />
						</cfhttp>
						<cfoutput>
						<cfsavecontent variable="soapHeaderTransCoreTokenTxt">
							<Envelope 
								xmlns="http://schemas.xmlsoap.org/soap/envelope/" 
								xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" 
								xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" 
								xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
								<Header>
									<tcor:sessionHeader>
										<tcor:sessionToken>
											<tcor1:primary>#session.primaryKey[1].XmlText#</tcor1:primary>
											<tcor1:secondary>#session.SeconKey[1].XmlText#</tcor1:secondary>
										</tcor:sessionToken>
									</tcor:sessionHeader>
								</Header>
								<Body>
									<tfm:postAssetRequest>
										<tfm:postAssetOperations>
											<tfm:shipment>
												<tfm:equipmentType>#variables.EquipmentName#</tfm:equipmentType>
												<tfm:origin>
													<tfm:cityAndState>
														<tfm:city>#variables.OriginCity#</tfm:city>
														<tfm:stateProvince>#variables.OriginState#</tfm:stateProvince>
													</tfm:cityAndState>
												</tfm:origin>
												<tfm:destination>
													<tfm:cityAndState>
														<tfm:city>#variables.DestCity#</tfm:city>
														<tfm:stateProvince>#variables.DestState#</tfm:stateProvince>
													</tfm:cityAndState>
												</tfm:destination>
											</tfm:shipment>
											<tfm:postersReferenceId>#arguments.impref#</tfm:postersReferenceId>
											<tfm:ltl>#FullOrPartial#</tfm:ltl>
											<tfm:comments>#variables.Notes#</tfm:comments>
											<tfm:dimensions>
												<tfm:lengthFeet>#variables.length#</tfm:lengthFeet>
												<tfm:weightPounds>
													<cfif not isnumeric(variables.Weight) or variables.Weight eq 0>
														1
													<cfelse>
														#variables.Weight#
													</cfif>
												</tfm:weightPounds>
											</tfm:dimensions>
											<tfm:availability>
												<tfm:earliest>
													#dateformat(variables.PickupDate,"yyyy-mm-dd")#T08:00:00.000Z
												</tfm:earliest>
	<!---											<tfm:latest>
													#dateformat(variables.FinalDelivDate,"yyyy-mm-dd")#T08:00:00.000Z
												</tfm:latest>--->
											</tfm:availability>
											<tfm:includeAsset>false</tfm:includeAsset>
										</tfm:postAssetOperations>
									</tfm:postAssetRequest>
								</Body>
							</Envelope>
						</cfsavecontent>
					</cfoutput>
					
					<!--- Insert into transcore --->
					<!--- TEST URL --->
	<!---				<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="objGet">
						<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
					</cfhttp>--->
					
					<!--- LIVE URL --->
					<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="objGet">
						<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
					</cfhttp>
					<cfset objGet360 =  objGet.filecontent />
					<cfset TranscoreobjGetData3601 = xmlParse( objGet360 ) />
					<cfset postAssetSuccess_res = XmlSearch(TranscoreobjGetData3601,"//*[name()='tfm:postAssetSuccessData']") />
					<!--- <cfset errorInResult = XmlSearch(TranscoreobjGetData3601,"//*[name()='tcor:detailedMessage']") /> --->
					<cfset errorInResult = XmlSearch(TranscoreobjGetData3601,"//*[name()='message']") />
					<!---
					<cfif arraylen(errorInResult)>	
						<cfif not findnocase("Reference ID already exists",errorInResult[1].XmlText)>
					--->
							<cfif arraylen(postAssetSuccess_res) eq 0>	
								<cfquery name="GetTranceCoreDBcount" datasource="#variables.dsn#">
									select imprtref,Postrequest_text from LoadPostEverywhereDetails where imprtref='#arguments.impref#' and From_web='Tc360' and status='success' 
								</cfquery>
								<cfif GetTranceCoreDBcount.recordcount>
									<!-----rechecking prepost if fail----->
									<!------Post asset to trancecore----->
									<cfoutput>
										<cfsavecontent variable="soapHeaderTransCoreHead">
											<Header>
												<tcor:sessionHeader>
													<tcor:sessionToken>
														<tcor1:primary>#trim(session.primaryKey[1].XmlText)#</tcor1:primary>
														<tcor1:secondary>#trim(session.SeconKey[1].XmlText)#</tcor1:secondary>
													</tcor:sessionToken>
												</tcor:sessionHeader>
											</Header>
										</cfsavecontent>
										<cfset strHXml = reReplace(GetTranceCoreDBcount.Postrequest_text, "<Header>(.*?)</Header>", soapHeaderTransCoreHead) />
										<cfsavecontent variable="soapHeaderTransCoreTokenTxt">
											#trim(strHXml)# 
										</cfsavecontent>
									</cfoutput>
									
									<!--- Test URL --->
			<!---						<cfhttp method="post" url="http://cnx.test.dat.com:9280/TfmiRequest" result="objGet1">
										<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
									</cfhttp>--->
									
									<!--- Live URL --->
									<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="objGet1">
										<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" />
									</cfhttp>		
									<cfset objGet3601 =  objGet1.filecontent />
									<cfset TranscoreobjGetData36011 = xmlParse( objGet3601 ) />
									<cfset postAssetSuccess_res1 = XmlSearch(TranscoreobjGetData36011,"//*[name()='tfm:postAssetSuccessData']") />
									
									
									
									<cfif arraylen(postAssetSuccess_res1) eq 0>
										<!-----if fail----->
										<cfset sts='Fail' />							
										<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
											update Loads SET IsTransCorePst=0,Trans_Sucess_Flag=0 where controlNumber=#arguments.impref# 
										</cfquery>
										<cfset Alertvar ="1" />
										<cfset msg = XmlSearch(TranscoreobjGetData36011,"//*[name()='message']") />
										<cfif arraylen(msg) eq 0>
											<cfset Alertvar ="1" />
											<cfset msg1 = XmlSearch(TranscoreobjGetData36011,"//*[name()='tcor:message']") />
											<cfif arraylen(msg1) eq 0>
												<cfset Alertvar ="1" />
											<cfelse>
												<cfset Alertvar=replace(#msg1[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
											</cfif>
										<cfelse>
											<cfset Alertvar=replace(#msg[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
										</cfif>
										<cfif Alertvar eq  1>
											<cfset Alertvar="Your Transcore Webservice status is Failed" />
										</cfif>
										<!-----if fail----->
									<cfelse>
										<!----if success---->
										<cfset sts='Fail' />
										<cfset Prev_sts='success' />
										<cfset Alertvar="1" />
										<cfset msg = XmlSearch(TranscoreobjGetData3601,"//*[name()='message']") />
										<cfif arraylen(msg) eq 0>
											<cfset Alertvar ="1" />
											<cfset msg1 = XmlSearch(TranscoreobjGetData3601,"//*[name()='tcor:message']") />
											<cfif arraylen(msg1) eq 0>
												<cfset Alertvar ="1" />
											<cfelse>
												<cfset Alertvar=replace(#msg1[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
											</cfif>
										<cfelse>
											<cfset Alertvar=replace(#msg[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
										</cfif>
										<cfif Alertvar eq  1>
											<cfset Alertvar="Your Transcore Webservice status is Failed" />
										</cfif>							
										<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
											update Loads SET IsTransCorePst=0,Trans_Sucess_Flag=0 where controlNumber=#arguments.impref# 
										</cfquery>
										<!-----if success--->
									</cfif>
									<!-----rechecking prepost if fail----->
								<cfelse>
									<!-----if fail----->
									<cfset sts='Fail' />
									<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
										update Loads SET IsTransCorePst=0,Trans_Sucess_Flag=0 where controlNumber=#arguments.impref# 
									</cfquery>
									
									<cfset Alertvar ="1" />
									<cfset msg = XmlSearch(TranscoreobjGetData3601,"//*[name()='message']") />
									
									<cfif arraylen(msg) eq 0>
										<cfset Alertvar ="1" />
										<cfset msg1 = XmlSearch(TranscoreobjGetData3601,"//*[name()='tcor:message']") />
										<cfif arraylen(msg1) eq 0>
											<cfset Alertvar ="1" />
										<cfelse>
											<cfset Alertvar=replace(#msg1[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
										</cfif>
									<cfelse>
										<cfset Alertvar=replace(#msg[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"") />
									</cfif>
									
									<cfif Alertvar eq  1>
										<cfset Alertvar="Your Transcore Webservice status is Failed" />
									</cfif>
									<!-----if fail----->
								</cfif>
							<cfelse>
								<!----if success---->
								<cfset sts='success' />
								<cfset Alertvar="you have successfully posted to Dat Loadboard" />
								
								<cfquery name="TransFlaginsert" datasource="#variables.dsn#" result="mm">
									update Loads SET IsTransCorePst=1,Trans_Sucess_Flag=1 where LOADNUMBER=#arguments.impref# 
								</cfquery>
								<!-----if success--->
							</cfif>
							<!-----delete asset from DB if any---->
							<cfquery name="GetTranceCoreDBcount" datasource="#variables.dsn#">
								delete from LoadPostEverywhereDetails where imprtref='#ViewPostEveryWhere.IMPORTREF#' and From_web='Tc360' and status='success' 
								<!--- delete from LoadPostEverywhereDetails where imprtref='#arguments.impref#' and From_web='Tc360' and status='success' --->
							</cfquery>
							<!-----Insert new asset from DB if any---->
							<cfquery name="PEPinsert" datasource="#variables.dsn#" result="result">
								INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#soapHeaderTransCoreTokenTxt#','#objGet.FileContent#','#ViewPostEveryWhere.IMPORTREF#','Tc360','#sts#')
								<!--- INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#soapHeaderTransCoreTokenTxt#','#objGet.FileContent#','#arguments.impref#','Tc360','#sts#') --->
							</cfquery>
						</cfif>
				<!--- </cfif> --->
			</cftransaction>
			<cfif Alertvar neq 1>
				<cfset Alertvar="DAT Loadboard Says : "&Alertvar />
			</cfif>
			<cfif isdefined("Prev_sts")>
				<cfset Alertvar=Alertvar&"!!!" />
			</cfif>
			
			<cfreturn Alertvar />
			
			<cfcatch type="any"><cfdump var="#cfcatch#"><cfdump var="d"><cfabort>
				<cfset Alertvar='Transcore have connection failure error. sorry please try later' />
				<cfreturn Alertvar />
			</cfcatch>
		</cftry>
	</cffunction>
	<!---------------Transcore 360 webservice end----->	
		
		<!---------------delete 123loadboard seperateloads end----->	
		<cffunction name="delete123LoadBoardWebserviceSeparate" access="remote" returntype="any">	
			<cfargument name="username" type="string" required="yes">
			<cfargument name="password" type="string" required="yes">
			<cfargument name="dsn" type="string" required="yes">
			<cfargument name="loadStopId" type="string" required="yes">
			<cfparam name="Alertvar" default="1">
			<cfoutput>
				<cfset variables.PostProviderID='LMGR428AP'>
			<!--- Delete from 123LoadboardAjax--->
				<cfquery name="Get123LoadBoardDBcount" datasource="#arguments.dsn#">
					select * from vwLoads123LoadBoard where LOADSTOPID=<cfqueryparam value="#arguments.loadStopId#" cfsqltype="cf_sql_varchar">
				</cfquery>		
				<cfif Get123LoadBoardDBcount.recordcount>
					<!-----Delete asset from TranceCore---->
					<cfsavecontent variable="myVariable"> 
							<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
								<s:Header>
									<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
								</s:Header> 
								<s:Body>
									<CancelLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
										<PostProviderID>#variables.PostProviderID#</PostProviderID>
										<UserName>#arguments.username#</UserName>
										<Password>#arguments.password#</Password>
										<LoadIDs xmlns:a="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
											
												<a:string>#left(arguments.loadStopId,25)#</a:string>
											
										</LoadIDs>
									</CancelLoad>
								</s:Body>
							</s:Envelope>
					</cfsavecontent> 
					<cfscript>
						var getHttpResponse = "";
						var httpServiceParams = [
							{
								type = "xml",
								value = trim(myVariable)
							}
						];
						getHttpResponse = getHttpResponseCancelLoad ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
					</cfscript>
					<cfif getHttpResponse.Statuscode eq '200 OK'>
						<cfset variables.status="success">
					<cfelse>
						<cfset variables.status="fail">
					</cfif>
					<cfif variables.status EQ "success">			
						<cfset Alertvar = "This Load has been sucessfully deleted from 123 LoadBoard "/>
					<cfelse>
						<cfset Alertvar = "This Load is not sucessfully cancelled from 123 LoadBoard "/>
					</cfif>
				</cfif>
				<cfif Alertvar neq 1>
					<cfset Alertvar="123Loadboard Says : "&Alertvar />
				</cfif>
			</cfoutput>	
			<cfreturn Alertvar>
		</cffunction>		
	<!------------- Webservice for 123loadboard start----------------->
		<cffunction name="postTo123LoadBoardWebservice" access="remote" returntype="any">	
			<cfargument name="postAction" type="string" required="yes"> 
			<cfargument name="PostProviderID" type="string" required="yes"> 
			<cfargument name="username" type="string" required="yes">
			<cfargument name="password" type="string" required="yes">
			<cfargument name="impref" type="string" required="yes">
			<cfargument name="dsn" type="string" required="yes">
			<cfparam name="Alertvar" default="1">
			<cftry>
				<cfoutput>
					<cfset variables.dsn=arguments.dsn>
					<cfquery name="ViewPost123LoadBoard" datasource="#variables.dsn#">
						select * from vwLoads123LoadBoard where loadnumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
					</cfquery>		
					<cfquery name="qryGetStopNo" datasource="#variables.dsn#">
						select distinct(stopNo) from vwLoads123LoadBoard where loadnumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
					</cfquery>	
					<cfset var stopNumbers=valuelist(qryGetStopNo.stopNo)>
					<!--- Create a new three-column query, specifying the column data types ---> 
					<cfset qryView123LoadBoard = QueryNew("loadid,loadStopid,EquipmentCode,LoadBoardcode,stopNo,LoadType,sourceCity,sourceStatecode,sourcePostalCode,emailId,contactPerson,phone,sourceStopDate,sourceStopTime,isPartial,notes,LoadNumber,weight,qty,commodity,destnationCity,destinationStatecode,destinationPostalcode,destinationStopdate,destinationStoptime")> 
					 
					<!--- Make  rows in the query ---> 
					<cfset newRow = QueryAddRow(qryView123LoadBoard, 1)> 
					<cfset rowNum = 1 >
					<cfloop list="#stopNumbers#" index="i">
						 <cfquery name="qryEachStop" datasource="#variables.dsn#">
							select * from vwLoads123LoadBoard where stopNo = <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">and loadnumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
							order by loadtype asc
						 </cfquery>
						 <cfset variables.loadid=GetQueryRow(qryEachStop,1)>
						  <cfset variables.loadStopid=GetQueryRow(qryEachStop,1)>
						 <cfset variables.EquipmentCode=GetQueryRow(qryEachStop,1)>
						 <cfset variables.LoadBoardcode=GetQueryRow(qryEachStop,1)>
						 <cfset variables.stopNo=GetQueryRow(qryEachStop,1)>
						 <cfset variables.LoadType=GetQueryRow(qryEachStop,1)>
						 <cfset variables.sourceCity=GetQueryRow(qryEachStop,1)>
						 <cfset variables.sourceStatecode=GetQueryRow(qryEachStop,1)>
						 <cfset variables.emailId=GetQueryRow(qryEachStop,1)>
						 <cfset variables.contactPerson=GetQueryRow(qryEachStop,1)>
						 <cfset variables.phone=GetQueryRow(qryEachStop,1)>
						 <cfset variables.sourceStopDate=GetQueryRow(qryEachStop,1)>
						 <cfset variables.sourceStopTime=GetQueryRow(qryEachStop,1)>
						 <cfset variables.sourcePostalcode=GetQueryRow(qryEachStop,1)>
						 <cfset variables.isPartial=GetQueryRow(qryEachStop,1)>
						 <cfset variables.notes=GetQueryRow(qryEachStop,1)>
						 <cfset variables.LoadNumber=GetQueryRow(qryEachStop,1)>
						 <cfset variables.weight=GetQueryRow(qryEachStop,1)>
						 <cfset variables.commodity=GetQueryRow(qryEachStop,1)>
						 <cfset variables.destnationCity=GetQueryRow(qryEachStop,2)>
						 <cfset variables.destinationStatecode=GetQueryRow(qryEachStop,2)>
						 <cfset variables.destinationPostalcode=GetQueryRow(qryEachStop,2)>
						 <cfset variables.destinationStopdate=GetQueryRow(qryEachStop,2)>
						 <cfset variables.destinationStoptime=GetQueryRow(qryEachStop,2)>
						 <cfset QuerySetCell(qryView123LoadBoard, "loadid",variables.loadid.loadid, rowNum)>
						 <cfset QuerySetCell(qryView123LoadBoard, "loadStopid",variables.loadStopid.loadstopid, rowNum)>
						 <cfset QuerySetCell(qryView123LoadBoard, "EquipmentCode", variables.loadid.equipmentcode, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "LoadBoardcode", variables.LoadBoardcode.LoadBoardcode, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "stopNo", variables.stopNo.stopNo, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "LoadType", variables.LoadType.LoadType, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "sourceCity", variables.sourceCity.City, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "sourceStatecode", variables.sourceStatecode.Statecode, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "emailId", variables.emailId.emailId, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "contactPerson", variables.contactPerson.contactPerson, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "phone", variables.phone.phone, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "sourceStopDate", variables.sourceStopDate.Stopdate, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "sourcePostalCode", variables.sourcePostalcode.Postalcode, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "sourceStopTime", variables.sourceStopTime.StopTime, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "isPartial", variables.isPartial.isPartial, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "notes", variables.notes.notes, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "LoadNumber", variables.LoadNumber.LoadNumber, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "weight", variables.weight.weight, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "commodity", variables.commodity.commodity, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "destnationCity", variables.destnationCity.City, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "destinationStatecode", variables.destinationStatecode.Statecode, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "destinationPostalcode", variables.destinationPostalcode.Postalcode, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "destinationStopdate", variables.destinationStopdate.Stopdate, rowNum)> 
						 <cfset QuerySetCell(qryView123LoadBoard, "destinationStoptime", variables.destinationStoptime.Stoptime, rowNum)> 
						 <cfif ListLen(stopNumbers) NEQ rowNum >
							<cfset newRow = QueryAddRow(qryView123LoadBoard, 1)> 
						 </cfif>
						 <cfset rowNum ++ >
					</cfloop>
					<cftransaction>
						<cfif arguments.postaction EQ 'D'><!--- Delete from 123Loadboard --->
							<cfquery name="Get123LoadBoardDBcount" datasource="#variables.dsn#">
								SELECT * FROM LoadPostEverywhereDetails 
								WHERE 
									imprtref=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer"> AND 
									From_web=<cfqueryparam value="123LoadBoard" cfsqltype="cf_sql_varchar"> AND 
									status=<cfqueryparam value="success" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif Get123LoadBoardDBcount.recordcount>
								<!-----Delete asset from TranceCore---->
								<cfsavecontent variable="myVariable"> 
										<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
											<s:Header>
												<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
											</s:Header> 
											<s:Body>
												<CancelLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
													<PostProviderID>#arguments.PostProviderID#</PostProviderID>
													<UserName>#arguments.username#</UserName>
													<Password>#arguments.password#</Password>
													<LoadIDs xmlns:a="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
														<cfloop query="qryView123LoadBoard">
															<cfset count=qryView123LoadBoard.STOPNO+1>
															<a:string>#left(qryView123LoadBoard.loadStopid,25)#</a:string>
														</cfloop>
	         										</LoadIDs>
												</CancelLoad>
											</s:Body>
										</s:Envelope>
								</cfsavecontent> 
								<cfscript>
									var getHttpResponse = "";
									var httpServiceParams = [
										{
											type = "xml",
											value = trim(myVariable)
										}
									];
									getHttpResponse = getHttpResponseCancelLoad ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
								</cfscript>
								<cfif getHttpResponse.Statuscode eq '200 OK'>
									<cfset variables.status="success">
								<cfelse>
									<cfset variables.status="fail">
								</cfif>
								<cfif variables.status EQ "success">							
									<!-----Delete asset from DB if any---->
									<cfquery name="Get123LoadBoardDbDelete" datasource="#variables.dsn#" >
										DELETE FROM LoadPostEverywhereDetails 
										WHERE 
											imprtref=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer"> AND 
											From_web=<cfqueryparam value="123LoadBoard" cfsqltype="cf_sql_varchar"> AND 
											status=<cfqueryparam value="success" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="loadBoard123Flaginsert" datasource="#variables.dsn#">
										update Loads 
										SET 
											postto123loadboard=0
										WHERE 
											ControlNumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfset Alertvar = "This Load has been sucessfully deleted from 123 LoadBoard "/>
								<cfelse>
									<cfset Alertvar = "This Load is not sucessfully cancelled from 123 LoadBoard "/>
								</cfif>
							</cfif>
						<cfelseif arguments.postaction EQ 'A'>
							<!------Post asset to 123loadboard----->
								
								<cfsavecontent variable="myVariable"> 
									
									<?xml version="1.0" encoding="UTF-8"?>
										<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
											
											<s:Header>
												<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
											</s:Header> 
											<s:Body>
												
												<PostLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
													<PostProviderID>#arguments.PostProviderID#</PostProviderID>
													<UserName>#arguments.username#</UserName>
													<Password>#arguments.password#</Password>
													
													<Loads xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
														<cfloop query="qryView123LoadBoard">
															<cfset count=qryView123LoadBoard.STOPNO+1>
															<Load>
																<AmountType i:nil="true"/>
																<Commodity i:nil="true">#Replace(qryView123LoadBoard.commodity, "&", "and", "ALL")#</Commodity>
																<DelivDate>#dateformat(qryView123LoadBoard.destinationstopdate,"yyyy-mm-dd'T'HH:mm:ss")#</DelivDate>
																<DestCity>#qryView123LoadBoard.destnationcity#</DestCity>
																<DestState>#qryView123LoadBoard.destinationstatecode#</DestState>
																<DispatcherEmail i:nil="true">#qryView123LoadBoard.emailid#</DispatcherEmail>
																<DispatcherExt i:nil="true"/>
																<DispatcherName i:nil="true">#qryView123LoadBoard.contactperson#</DispatcherName>
																<DispatcherPhone i:nil="true">#qryView123LoadBoard.phone#</DispatcherPhone>
																<EquipCode>#qryView123LoadBoard.loadboardcode#</EquipCode>
																<EquipInfo i:nil="true"/>
																<LoadID>#left(qryView123LoadBoard.loadStopid,25)#</LoadID>
																<LoadSize><cfif qryView123LoadBoard.ISPARTIAL eq 0>TL<cfelse>LTL</cfif></LoadSize>
																<OrigCity>#qryView123LoadBoard.sourcecity#</OrigCity>
																<OrigLatitude>0</OrigLatitude>
																<OrigLongitude>0</OrigLongitude>
																<OrigState>#qryView123LoadBoard.sourcestatecode#</OrigState>
																<OrigZipcode i:nil="true">#qryView123LoadBoard.sourcepostalcode#</OrigZipcode>
																<PickUpDate>#dateformat(qryView123LoadBoard.sourcestopdate,"yyyy-mm-dd'T'HH:mm:ss")#</PickUpDate>
																<RepeatDaily>true</RepeatDaily>
																<TeamLoad i:nil="true"/>
																<Notes i:nil="true">#qryView123LoadBoard.notes#</Notes>
																<TrackNo i:nil="true"/>
																<DelivTime i:nil="true">#qryView123LoadBoard.destinationstoptime#</DelivTime>
																<DestZipcode i:nil="true">#qryView123LoadBoard.destinationpostalcode#</DestZipcode>
																<LoadQty i:nil="true">#qryView123LoadBoard.qty#</LoadQty>
																<PickUpTime i:nil="true">#qryView123LoadBoard.sourcestoptime#</PickUpTime>
																<Stops>#count#</Stops>
															</Load>
														</cfloop>
													</Loads>
												</PostLoad>
												
											</s:Body>
												
										</s:Envelope>
												
								</cfsavecontent> 
							<cfscript>
								var getHttpResponse = "";
								var httpServiceParams = [
									{
										type = "xml",
										value = trim(myVariable)
									}
								];
								getHttpResponse = getHttpResponseLoadBoard ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
							</cfscript>
							<cfif getHttpResponse.Statuscode eq '200 OK'>
								<cfset variables.status="success">
							<cfelse>
								<cfset variables.status="fail">
							</cfif>
							<cfif getHttpResponse.Statuscode eq '200 OK'>
								<cfquery name="LoadBoard123Flaginsert" datasource="#variables.dsn#">
									update Loads SET postto123loadboard=1 WHERE ControlNumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfquery name="Get123LoadBoardDbDelete" datasource="#variables.dsn#" >
									DELETE FROM LoadPostEverywhereDetails 
									WHERE 
										imprtref=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer"> AND 
										From_web=<cfqueryparam value="123LoadBoard" cfsqltype="cf_sql_varchar"> AND 
										status=<cfqueryparam value="success" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfquery name="LoadboardInsertTOEveryWhere" datasource="#variables.dsn#">
									INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#myVariable#','#getHttpResponse.Filecontent#','#arguments.impref#','123LoadBoard','#variables.status#');
								</cfquery>						
								<cfset Alertvar = "Your are successfully posted to 123 LoadBoard">
							<cfelse>
								<cfquery name="LoadBoard123Flaginsert" datasource="#variables.dsn#">
									update Loads SET postto123loadboard=0 WHERE ControlNumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
								</cfquery>						
								<cfset variables.messages = xmlparse(getHttpResponse.filecontent)>
								<cfset variables.AlertContent=XmlSearch(variables.messages,"s:Envelope/s:Body/s:Fault/detail")>
								<cfif arraylen(variables.AlertContent) gt 0>
									<cfset variables.AlertContent1=variables.AlertContent[1].XmlChildren[1].XmlChildren[1].XmlText>
									<cfif variables.AlertContent1 eq 1001>
										<cfset Alertvar="PostProviderID is invalid for posting load to 123Loadboard">
									<cfelseif variables.AlertContent1 eq 1002>	
										<cfset Alertvar="Verify post provider ID failed for posting load to 123Loadboard">
									<cfelseif (variables.AlertContent1) eq 2002 or (variables.AlertContent1) eq 2001>
										<cfset Alertvar="Username/password is incorrect for posting load to 123Loadboard">
									<cfelseif variables.AlertContent1 eq 2003>
										<cfset Alertvar="2003 Verify account failed for posting load to 123Loadboard">
									<cfelseif variables.AlertContent1 eq 3001>
										<cfset Alertvar="Post load(s) failed for 123Loadboard">	
									<cfelseif variables.AlertContent1 eq 3002>
										<cfset Alertvar=" Cancel load(s) failed for 123Loadboard.">
									<cfelse>
										<cfset Alertvar= " Your 123Loadboard Webservice posting Failed.">
									</cfif>
								</cfif>
							</cfif>	
						<cfelseif arguments.postaction EQ 'U'>
							<!------Post asset to 123loadboard----->
								<cfsavecontent variable="myVariable"> 
									<?xml version="1.0" encoding="UTF-8"?>
										<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
											<s:Header>
												<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
											</s:Header> 
											<s:Body>
												<PostLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
													<PostProviderID>#arguments.PostProviderID#</PostProviderID>
													<UserName>#arguments.username#</UserName>
													<Password>#arguments.password#</Password>
													<Loads xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
														<cfloop query="qryView123LoadBoard">
															<cfset count=qryView123LoadBoard.STOPNO+1>
															<Load>
																<AmountType i:nil="true"/>
																<Commodity i:nil="true">#Replace(qryView123LoadBoard.commodity, "&", "and", "ALL")#</Commodity>
																<DelivDate>#dateformat(qryView123LoadBoard.destinationstopdate,"yyyy-mm-dd'T'HH:mm:ss")#</DelivDate>
																<DestCity>#qryView123LoadBoard.destnationcity#</DestCity>
																<DestState>#qryView123LoadBoard.destinationstatecode#</DestState>
																<DispatcherEmail i:nil="true">#qryView123LoadBoard.emailid#</DispatcherEmail>
																<DispatcherExt i:nil="true"/>
																<DispatcherName i:nil="true">#qryView123LoadBoard.contactperson#</DispatcherName>
																<DispatcherPhone i:nil="true">#qryView123LoadBoard.phone#</DispatcherPhone>
																<EquipCode>#qryView123LoadBoard.loadboardcode#</EquipCode>
																<EquipInfo i:nil="true"/>
																<LoadID>#left(qryView123LoadBoard.loadStopid,25)#</LoadID>
																<LoadSize><cfif qryView123LoadBoard.ISPARTIAL eq 0>TL<cfelse>LTL</cfif></LoadSize>
																<OrigCity>#qryView123LoadBoard.sourcecity#</OrigCity>
																<OrigLatitude>0</OrigLatitude>
																<OrigLongitude>0</OrigLongitude>
																<OrigState>#qryView123LoadBoard.sourcestatecode#</OrigState>
																<OrigZipcode i:nil="true">#qryView123LoadBoard.sourcepostalcode#</OrigZipcode>
																<PickUpDate>#dateformat(qryView123LoadBoard.sourcestopdate,"yyyy-mm-dd'T'HH:mm:ss")#</PickUpDate>
																<RepeatDaily>false</RepeatDaily>
																<TeamLoad i:nil="true"/>
																<Notes i:nil="true">#qryView123LoadBoard.notes#</Notes>
																<TrackNo i:nil="true"/>
																<DelivTime i:nil="true">#qryView123LoadBoard.destinationstoptime#</DelivTime>
																<DestZipcode i:nil="true">#qryView123LoadBoard.destinationpostalcode#</DestZipcode>
																<LoadQty i:nil="true">#qryView123LoadBoard.qty#</LoadQty>
																<PickUpTime i:nil="true">#qryView123LoadBoard.sourcestoptime#</PickUpTime>
																<Stops>#count#</Stops>
															</Load>
														</cfloop>
													</Loads>
												</PostLoad>
											</s:Body>
										</s:Envelope>
								</cfsavecontent>
							<cfscript>
								var getHttpResponse = "";
								var httpServiceParams = [
									{
										type = "xml",
										value = trim(myVariable)
									}
								];
								getHttpResponse = getHttpResponseLoadBoard ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
							</cfscript>
							<cfif getHttpResponse.Statuscode eq '200 OK'>
								<cfset variables.status="success">
							<cfelse>
								<cfset variables.status="fail">
							</cfif>
							<cfif getHttpResponse.Statuscode eq '200 OK'>
								<cfquery name="LoadBoard123Flaginsert" datasource="#variables.dsn#">
									update Loads SET postto123loadboard=1 WHERE ControlNumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfquery name="Get123LoadBoardDbDelete" datasource="#variables.dsn#" >
									DELETE FROM LoadPostEverywhereDetails 
									WHERE 
										imprtref=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer"> AND 
										From_web=<cfqueryparam value="123LoadBoard" cfsqltype="cf_sql_varchar"> AND 
										status=<cfqueryparam value="success" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfquery name="LoadboardInsertTOEveryWhere" datasource="#variables.dsn#">
									INSERT INTO LoadPostEverywhereDetails (Postrequest_text,Response_text,imprtref,From_web,status) VALUES('#myVariable#','#getHttpResponse.Filecontent#','#arguments.impref#','123LoadBoard','#variables.status#');
								</cfquery>						
								<cfset Alertvar = "Your are successfully posted to 123 LoadBoard">
							<cfelse>
								<cfquery name="LoadBoard123Flaginsert" datasource="#variables.dsn#">
									update Loads SET postto123loadboard=0 WHERE ControlNumber=<cfqueryparam value="#arguments.impref#" cfsqltype="cf_sql_integer">
								</cfquery>						
								<cfset variables.messages = xmlparse(getHttpResponse.filecontent)>
								<cfset variables.AlertContent=XmlSearch(variables.messages,"s:Envelope/s:Body/s:Fault/detail")>
								<cfif arraylen(variables.AlertContent) gt 0>
									<cfset variables.AlertContent1=variables.AlertContent[1].XmlChildren[1].XmlChildren[1].XmlText>
									<cfif variables.AlertContent1 eq 1001>
										<cfset Alertvar="PostProviderID is invalid for posting load to 123Loadboard">
									<cfelseif variables.AlertContent1 eq 1002>	
										<cfset Alertvar="Verify post provider ID failed for posting load to 123Loadboard">
									<cfelseif (variables.AlertContent1) eq 2002 or (variables.AlertContent1) eq 2001>
										<cfset Alertvar="Username/password is incorrect for posting load to 123Loadboard">
									<cfelseif variables.AlertContent1 eq 2003>
										<cfset Alertvar="2003 Verify account failed for posting load to 123Loadboard">
									<cfelseif variables.AlertContent1 eq 3001>
										<cfset Alertvar="Post load(s) failed for 123Loadboard">	
									<cfelseif variables.AlertContent1 eq 3002>
										<cfset Alertvar=" Cancel load(s) failed for 123Loadboard.">
									<cfelse>
										<cfset Alertvar= " Your 123Loadboard Webservice posting Failed.">
									</cfif>
								</cfif>
							</cfif>	
						</cfif>
					</cftransaction>	
					<cfif Alertvar neq 1>
						<cfset Alertvar="123Loadboard Says : "&Alertvar />
					</cfif>
				</cfoutput>
				<cfreturn Alertvar />
				<cfcatch type="any">
					<cfdump var="#cfcatch#">
					<cfabort>
					<cfset Alertvar='123LoadBoard have connection failure error. sorry please try later' />
					<cfreturn Alertvar />
				</cfcatch>
			</cftry>
			
			
			
		</cffunction>
		<!------------- Webservice for posting load in 123loadboard start----------------->	
		<!---function to find the current row of a query--->
		<cfscript>
			function GetQueryRow(query, rowNumber) {
				var i = 0;
				var rowData = StructNew();
				var cols = ListToArray(query.columnList);
				for (i = 1; i lte ArrayLen(cols); i = i + 1) {
					rowData[cols[i]] = query[cols[i]][rowNumber];
				}
				return rowData;
			}
		</cfscript>
		<!-----------Live url processing for postload start----------------->	
		
		<cffunction name="getHttpResponseLoadBoard" access="public" returntype="any">	
			<cfargument name="method" type="string" required="yes"> 
			<cfargument name="setUrl" type="string" required="yes">
			<cfargument name="httpParameters" type="array" required="yes">
			<cfscript>
				var httpService = new http();
				httpService.setMethod(arguments.method); 
				httpService.setUrl(arguments.setUrl);
				httpService.addParam(type="header",name="Content-Type", value="text/xml; charset=utf-8"); 
				httpService.addParam(type="header",name="host", value="ws.123loadboard.com"); 
				httpService.addParam(type="header",name="SOAPAction", value="PostLoad");
				if(arrayLen(arguments.httpParameters)){
					for(var parameter = 1; parameter <= arrayLen(arguments.httpParameters); parameter++) {
						httpService.addParam(type = arguments.httpParameters[parameter].type,value = arguments.httpParameters[parameter].value);  			
					}	
				}
				var httpResponse = httpService.send().getPrefix();
				return httpResponse;
			</cfscript>
		</cffunction>
		<!-----------Live url processing for postload end----------------->	
		<!-----------Live url processing for cancelload start----------------->	
			<cffunction name="getHttpResponseCancelLoad" access="public" returntype="any">	
				<cfargument name="method" type="string" required="yes"> 
				<cfargument name="setUrl" type="string" required="yes">
				<cfargument name="httpParameters" type="array" required="yes">
				<cfscript>
					var httpService = new http();
					httpService.setMethod(arguments.method); 
					httpService.setUrl(arguments.setUrl);
					httpService.addParam(type="header",name="Content-Type", value="text/xml; charset=utf-8"); 
					httpService.addParam(type="header",name="host", value="ws.123loadboard.com"); 
					httpService.addParam(type="header",name="SOAPAction", value="CancelLoad");
					if(arrayLen(arguments.httpParameters)){
						for(var parameter = 1; parameter <= arrayLen(arguments.httpParameters); parameter++) {
							httpService.addParam(type = arguments.httpParameters[parameter].type,value = arguments.httpParameters[parameter].value);  			
						}	
					}
					var httpResponse = httpService.send().getPrefix();
					return httpResponse;
				</cfscript>
			</cffunction>		
			<!-----------Live url processing for cancelload end----------------->	
		
	<!--- add load---> 
	<cffunction name="addLoad" access="public" returntype="any">
	<cfargument name="frmstruct" type="struct" required="yes">
	 	<cfscript>
			variables.objCustomerGatewayAdd = #request.cfcpath#&".loadgatewayadd";
		</cfscript>
		<cfinvoke component ="#variables.objCustomerGatewayadd#" method="addload" formStruct="#arguments.frmstruct#" idReturn="true" returnvariable="Msg"/>
		<cfreturn Msg>
	</cffunction>

	<cffunction name="getCommissionReportInfo" access="public" returntype="query">
	    <cfargument name="groupBy" type="string" required="yes">
	    <cfargument name="orderDateFrom" type="string" required="yes">
	    <cfargument name="orderDateTo" type="string" required="yes">
	    <cfargument name="salesRepFrom" type="string" required="yes">
	    <cfargument name="salesRepTo" type="string" required="yes">
	    <cfargument name="dispatcherFrom" type="string" required="yes">
	    <cfargument name="dispatcherTo" type="string" required="yes">
		<cfargument name="statusTo" type="string" required="yes">
		<cfargument name="statusFrom" type="string" required="yes">
		
	    <cfstoredproc procedure="USP_GetLoadsForCommissionReportNew" datasource="#variables.dsn#">
	    	<cfprocparam value="#groupBy#" cfsqltype="cf_sql_varchar">
	        <cfprocparam value="#orderDateFrom#" cfsqltype="cf_sql_varchar">
	        <cfprocparam value="#orderDateTo#" cfsqltype="cf_sql_varchar">
	        <cfprocparam value="#salesRepFrom#" cfsqltype="cf_sql_varchar">
	        <cfprocparam value="#salesRepTo#" cfsqltype="cf_sql_varchar">
	        <cfprocparam value="#dispatcherFrom#" cfsqltype="cf_sql_varchar">
	        <cfprocparam value="#dispatcherTo#" cfsqltype="cf_sql_varchar">
			<cfprocparam value="#statusTo#" cfsqltype="cf_sql_varchar">
			<cfprocparam value="#statusFrom#" cfsqltype="cf_sql_varchar">
	        
	        <cfprocresult name="qCommissionReportLoads">
	    </cfstoredproc>

		<cfreturn qCommissionReportLoads>

	</cffunction>


	<!--- A seperate Method is created because method:EditLoad has become too large and causing an Error because of its being extra large
	Logically this method is considered to be called from within the application via method:EditLoad
	Never call it alone otherwise you'll cause the DB inconsistancy --->
	<cffunction name="RunUSP_UpdateLoad" access="public" returntype="string">
		<cfargument name="frmstruct" type="struct" required="yes">
		
		<cfif isdefined('arguments.frmstruct.posttoloadboard')>
			<cfset posttoloadboard=True>
		<cfelse>
			<cfset posttoloadboard=False>
		</cfif> 
		<!--- <cfif isdefined('arguments.frmstruct.posttoTranscore')>
			<cfset posttoTranscore=True>
		<cfelse>
			<cfset posttoTranscore=False>
		</cfif> --->
		<cfset posttoTranscore=False><!--- Making default value to 0. If the post is success, then it will updated to 1 later. --->
		<cfif isdefined('arguments.frmstruct.posttoTranscore')>
			<cfset posttoTranscore=true>
		</cfif>
		
		<cfset PostTo123LoadBoard=False><!--- Making default value to 0. If the post is success, then it will updated to 1 later. --->
		<cfif isdefined('arguments.frmstruct.PostTo123LoadBoard')>
			<cfset PostTo123LoadBoard=true>
		</cfif>
		<cfif isdefined('arguments.frmstruct.ARExported')>
			<cfset ARExported="1">
		<cfelse>
			<cfset ARExported="0">
		</cfif>
		
		<cfif isdefined('arguments.frmstruct.APExported')>
			<cfset APExported="1">
		<cfelse>
			<cfset APExported="0">
		</cfif>
		
		<cfif NOT structKeyExists(arguments.frmstruct,"InvoiceNumber")>
			<cfset arguments.frmstruct.InvoiceNumber = 0>
		</cfif>
		<cftransaction>
			<cfquery name="getinvoiceNumber" datasource="#variables.dsn#">
				select invoiceNumber from loads 
				where 
					loadNumber =<cfqueryparam VALUE="#arguments.frmstruct.loadManualNo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif getinvoiceNumber.invoiceNumber NEQ "" AND getinvoiceNumber.invoiceNumber NEQ 0>
				<cfset variables.invoiceNumber = getinvoiceNumber.invoiceNumber>
			<cfelse>
				<cfquery name="getloadmanual" datasource="#variables.dsn#">
					SELECT MinimumLoadInvoiceNumber FROM SystemConfig
				</cfquery>
				<cfif getloadmanual.MinimumLoadInvoiceNumber NEQ 0>
					<cfquery name="getloadmanual" datasource="#variables.dsn#">
						SELECT invoiceNumber=[MinimumLoadInvoiceNumber]+1 FROM SystemConfig
					</cfquery>
					<cfquery name="qrySearchAllInvoiceNumbers" datasource="#variables.dsn#">
						select invoiceNumber from loads 
						where 
							invoiceNumber=<cfqueryparam VALUE="#getloadmanual.invoiceNumber#" cfsqltype="cf_sql_integer"> and
							loadNumber !=<cfqueryparam VALUE="#arguments.frmstruct.loadManualNo#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif qrySearchAllInvoiceNumbers.recordcount>
						<cfquery name="getloadmanual" datasource="#variables.dsn#">
							SELECT  max(invoiceNumber)+1 as invoiceNumber FROM Loads
						</cfquery>
					</cfif>
					<cfquery name="UpdateloadInvoiceNumber" datasource="#variables.dsn#">
						  update SystemConfig set MinimumLoadInvoiceNumber= <cfqueryparam value="#getloadmanual.invoiceNumber#" cfsqltype="cf_sql_integer" >
					</cfquery>
					<cfset variables.invoiceNumber = getloadmanual.invoiceNumber>
				<cfelse>
					<cfset variables.invoiceNumber = 0>
				</cfif>
			</cfif>
			
			<cfset loadManualNo=arguments.frmstruct.loadManualNo>
			
			<cfset PrevloadNo=arguments.frmstruct.LoadNumber>
			<cfset custRatePerMile = ReplaceNoCase(arguments.frmstruct.CustomerRatePerMile,'$','','ALL')>
			<cfset carRatePerMile = ReplaceNoCase(arguments.frmstruct.CarrierRatePerMile,'$','','ALL')>
			<cfset custRatePerMile = ReplaceNoCase(custRatePerMile,',','','ALL')>
			<cfset carRatePerMile = ReplaceNoCase(carRatePerMile,',','','ALL')>
			
			
			<cfset custMilesCharges = ReplaceNoCase(arguments.frmstruct.CustomerMiles,'$','','ALL')>
			<cfset custMilesCharges = ReplaceNoCase(custMilesCharges,',','','ALL')>
			<cfset carMilesCharges = ReplaceNoCase(arguments.frmstruct.CarrierMiles,'$','','ALL')>
			<cfset carMilesCharges = ReplaceNoCase(carMilesCharges,',','','ALL')>
			
			<cfset custCommodCharges = ReplaceNoCase(arguments.frmstruct.TotalCustcommodities,'$','','ALL')>
			<cfset custCommodCharges = ReplaceNoCase(custCommodCharges,',','','ALL')>
			<cfset carCommodCharges = ReplaceNoCase(arguments.frmstruct.TotalCarcommodities,'$','','ALL')>
			<cfset carCommodCharges = ReplaceNoCase(carCommodCharges,',','','ALL')>
			
			<cfset custFlatRate = ReplaceNoCase(arguments.frmstruct.CustomerRate,'$','','ALL')>
			<cfset custFlatRate = ReplaceNoCase(custFlatRate,',','','ALL')>
			<cfset carFlatRate = ReplaceNoCase(arguments.frmstruct.CarrierRate,'$','','ALL')>
			<cfset carFlatRate = ReplaceNoCase(carFlatRate,',','','ALL')>

			<cfset CustomerMilesCalc = ReplaceNoCase(CustomerMilesCalc,'$','','ALL')>
			<cfset CustomerMilesCalc = ReplaceNoCase(CustomerMilesCalc,',','','ALL')>
				
			<cfset CarrierMilesCalc = ReplaceNoCase(CarrierMilesCalc,'$','','ALL')>
			<cfset CarrierMilesCalc = ReplaceNoCase(CarrierMilesCalc,',','','ALL')>
				
			<cfif isdefined('arguments.frmstruct.shipBlind')>
				<cfset shipBlind=True>
			<cfelse>
				<cfset shipBlind=False>
			</cfif>
			<cfif isdefined('arguments.frmstruct.ConsBlind')>
				<cfset ConsBlind=True>
			<cfelse>
				<cfset ConsBlind=False>
			</cfif>
			<cfif isdefined('arguments.frmstruct.ISPARTIAL')>
				<cfset ISPARTIAL=1>
			<cfelse>
				<cfset ISPARTIAL=0>
			</cfif>
			
			<cfif structKeyExists(arguments.frmstruct,"readyDat") and isDate(arguments.frmstruct.readyDat)>
				<cfset readyDate = arguments.frmstruct.readyDat>
			<cfelse>
				<cfset readyDate = "">
			</cfif>
			
			<cfif structKeyExists(arguments.frmstruct,"arriveDat") and isDate(arguments.frmstruct.arriveDat)>
				<cfset arriveDate = arguments.frmstruct.arriveDat>
			<cfelse>
				<cfset arriveDate = "">
			</cfif>
			
			<cfif structKeyExists(arguments.frmstruct,"Excused")>
				<cfset isExcused = arguments.frmstruct.Excused>
			<cfelse>
				<cfset isExcused = "">
			</cfif>
			
			<cfif structKeyExists(arguments.frmstruct,"bookedBy")>
				<cfset bookedBy = arguments.frmstruct.bookedBy>
			<cfelse>
				<cfset bookedBy = "">
			</cfif>			
			<CFSTOREDPROC PROCEDURE="USP_UpdateLoad" DATASOURCE="#variables.dsn#" debug="true">
				<cfif isdefined('arguments.frmstruct.CARRIERINVOICENUMBER') and arguments.frmstruct.CARRIERINVOICENUMBER GT 0>
					<CFPROCPARAM VALUE="#val(arguments.frmstruct.CARRIERINVOICENUMBER)#" cfsqltype="cf_sql_integer">
				<cfelse>
					<CFPROCPARAM VALUE="0" cfsqltype="cf_sql_integer">
				</cfif>
				<CFPROCPARAM VALUE="#arguments.frmstruct.editid#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#loadManualNo#" cfsqltype="cf_sql_integer">
				<CFPROCPARAM VALUE="#PrevloadNo#" cfsqltype="cf_sql_integer">
				 
				<CFPROCPARAM VALUE="#arguments.frmstruct.cutomerIdAutoValueContainer#" cfsqltype="CF_SQL_VARCHAR">
				<cfif isdefined('arguments.frmstruct.SALESPERSON') and len(arguments.frmstruct.SALESPERSON) gt 1>
					<CFPROCPARAM VALUE="#arguments.frmstruct.SALESPERSON#" cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR" null="true">
				</cfif>
				<cfif isdefined('arguments.frmstruct.dispatcher') and len(arguments.frmstruct.dispatcher) gt 1>
					<CFPROCPARAM VALUE="#arguments.frmstruct.dispatcher#" cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<CFPROCPARAM VALUE="#arguments.frmstruct.LOADSTATUS#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#posttoloadboard#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#posttoTranscore#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#PostTo123LoadBoard#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.notes#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.dispatchnotes#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.carriernotes#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.pricingnotes#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.CUSTOMERPO#" cfsqltype="CF_SQL_VARCHAR">  
				<CFPROCPARAM VALUE="#arguments.frmstruct.CUSTOMERBOL#" cfsqltype="CF_SQL_VARCHAR">  

					<cfset totCarChg = replace(arguments.frmstruct.TotalCarrierCharges,'$',"")>
					<cfset totCustChg = replace(arguments.frmstruct.TotalCustomerCharges,'$',"")>	
				
					
				<CFPROCPARAM VALUE="#VAL(totCarChg)#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#VAL(totCustChg)#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#VAL(carFlatRate)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#VAL(custFlatRate)#" cfsqltype="cf_sql_money">
				<cfif isdefined('arguments.frmstruct.carrierID') and len(arguments.frmstruct.carrierID) gt 1>
					<CFPROCPARAM VALUE="#trim(listfirst(arguments.frmstruct.carrierID,','))#" cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<cfif isdefined('arguments.frmstruct.carrierOfficeID') and len(arguments.frmstruct.carrierOfficeID) gt 1>
					<CFPROCPARAM VALUE="#arguments.frmstruct.carrierOfficeID#" cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				<CFPROCPARAM VALUE="#arguments.frmstruct.equipment#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.driver#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.drivercell#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.TRUCKNO#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.trailerNo#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.BookedWith#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupNO1#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupDate#" cfsqltype="CF_SQL_dATE" null="#yesNoFormat(NOT len(arguments.frmstruct.shipperPickupDate))#">
				<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupTime#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeIn#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeOut#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupNO#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupDate#" cfsqltype="CF_SQL_dATE" null="#yesNoFormat(NOT len(arguments.frmstruct.consigneePickupDate))#">
				<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupTime#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeTimeIn#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeTimeOut#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#cgi.REMOTE_ADDR#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM value="#VAL(custRatePerMile)#"  cfsqltype="cf_sql_money">
				<CFPROCPARAM value="#VAL(carRatePerMile)#"  cfsqltype="cf_sql_money">
				<CFPROCPARAM value="#CustomerMilesCalc#"  cfsqltype="cf_sql_float">
				<CFPROCPARAM value="#CarrierMilesCalc#"  cfsqltype="cf_sql_float">
				<CFPROCPARAM VALUE="#session.officeid#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM value="#arguments.frmstruct.orderDate#"  cfsqltype="cf_sql_date">
				<CFPROCPARAM value="#arguments.frmstruct.BillDate#"  cfsqltype="cf_sql_date" null="#not len(arguments.frmstruct.BillDate)#">
				<cfset totalProfit = replace(arguments.frmstruct.totalProfit,'$',"")>
				<CFPROCPARAM value="#VAL(totalProfit)#"  cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#ARExported#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#APExported#" cfsqltype="CF_SQL_VARCHAR">
				
				<CFPROCPARAM VALUE="#custMilesCharges#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#carMilesCharges#" cfsqltype="CF_SQL_VARCHAR">
				
				<CFPROCPARAM VALUE="#custCommodCharges#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#custCommodCharges#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerAddress#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerCity#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerState#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerZipCode#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerContact#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerPhone#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerFax#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.customerCell#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.frmstruct.cutomerIdAuto#" cfsqltype="CF_SQL_VARCHAR">
				
				<CFPROCPARAM VALUE="#val(ISPARTIAL)#" cfsqltype="CF_SQL_INTEGER">
				
				<cfif len(trim(readyDate)) gt 0 and isdate(trim(readyDate))>
					<CFPROCPARAM VALUE="#trim(readyDate)#" cfsqltype="cf_sql_date">
				<cfelse>
					<CFPROCPARAM VALUE="#trim(readyDate)#" cfsqltype="cf_sql_date" null="true">
				</cfif>
				
				<cfif len(trim(arriveDate)) gt 0 and isdate(trim(arriveDate))>
					<CFPROCPARAM VALUE="#trim(arriveDate)#" cfsqltype="cf_sql_date">
				<cfelse>
					<CFPROCPARAM VALUE="#trim(arriveDate)#" cfsqltype="cf_sql_date" null="true">
				</cfif>
				
				<CFPROCPARAM VALUE="#val(isExcused)#" cfsqltype="CF_SQL_INTEGER">
				
				<cfif len(trim(bookedBy)) gt 0>
					<CFPROCPARAM VALUE="#trim(bookedBy)#" cfsqltype="CF_SQL_VARCHAR">
				<cfelse>
					<CFPROCPARAM VALUE="#trim(bookedBy)#" cfsqltype="CF_SQL_VARCHAR" null="true">
				</cfif>
				<CFPROCPARAM VALUE="#val(variables.invoiceNumber)#" cfsqltype="CF_SQL_Integer">
				<cfif structkeyexists(arguments.frmstruct,"weightStop1") and isnumeric(arguments.frmstruct.weightStop1)>
					<CFPROCPARAM VALUE="#arguments.frmstruct.weightStop1#" cfsqltype="CF_SQL_INTEGER">
				<cfelse>	
					<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">
				</cfif>	
				<CFPROCRESULT NAME="qInsertedLoadID">
		   </CFSTOREDPROC>
		</cftransaction>
		<cfreturn arguments.frmstruct.editid>
	</cffunction>


	<!--- Edit Load--->
	<cffunction name="EditLoad" access="public" returntype="any">
		<cfargument name="frmstruct" type="struct" required="yes">
		<cfscript>
			variables.objCustomerGatewaynew = #request.cfcpath#&".loadgatewaynew";
		</cfscript>
		<cfinvoke component ="#variables.objCustomerGatewaynew#" method="editload" formStruct="#arguments.frmstruct#" idReturn="true" returnvariable="Msg"/>
		<cfreturn Msg>
	</cffunction>

	<!--- Delete Load --->

	<cffunction name="deleteLoad" access="public" returntype="any">
		<cfargument name="loadid" required="yes" type="any">
		<cftransaction>
			<cfquery name="getAllStop" datasource="#variables.dsn#">
			   select loadstopid from loadstops where loadid = '#arguments.loadid#'
			</cfquery>
			<cfset LoadStopIDList=valueList(getAllStop.loadstopid,",")>
			<cfquery name="deleteAllStopItems" datasource="#variables.dsn#">
			   delete from LoadStopCommodities where loadstopid in ('#LoadStopIDList#')
			</cfquery>
			
			<cfquery name="deleteAllStop" datasource="#variables.dsn#">
			   delete from loadstops where loadid = '#arguments.loadid#'
			</cfquery>
			
			<cfquery name="deleteLoad" datasource="#variables.dsn#">
			   delete from loads where loadid = '#arguments.loadid#'
			</cfquery>
	  
			<cfreturn "Load has been deleted successfully.">
		</cftransaction>
		<cfreturn "Load have been deleted successfully.">
	</cffunction>



	<!--- QuickBooks Insert Record in Invoices Table --->
	<cffunction name="insertInInvoices" returntype="void">
		<cfargument name="qLoadsRow" required="yes" type="query">
		<cfargument name="QBdsn" required="yes" type="any">
	    <cfargument name="dsn" required="yes" type="any">
	    
	     <CFSTOREDPROC PROCEDURE="USP_GetCustomerDetails" DATASOURCE="#dsn#"> 
			<cfif isdefined('qLoadsRow.PayerID') and len(qLoadsRow.PayerID)>
				<CFPROCPARAM VALUE="#qLoadsRow.PayerID#" cfsqltype="CF_SQL_VARCHAR">  
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			</cfif>
			<CFPROCRESULT NAME="qCustomer"> 
		</CFSTOREDPROC>

	    
	    <CFSTOREDPROC PROCEDURE="USP_GetStateDetails" DATASOURCE="#dsn#"> 
	    	<cfif isdefined('qCustomer.StateID')>
				<CFPROCPARAM VALUE="#qCustomer.StateID#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
	        </cfif>
			 <CFPROCRESULT NAME="qState"> 
		</CFSTOREDPROC>
	    
	    <cfinvoke method="getNoOfStops" LOADID="#qLoadsRow.LoadID#" dsn="#dsn#" returnvariable="request.NoOfStops" />
		<cfinvoke method="getAllLoads" loadid="#qLoadsRow.LoadID#" dsn="#dsn#" stopNo="#request.NoOfStops#" returnvariable="qLoadsLastStop" />
	    
	    <cfset itemDescriptions = 'Miles: #DollarFormat(qLoadsRow.customerMilesCharges )#, Flate Rate: #DollarFormat(qLoadsRow.CustFlatRate )#, Commodities/Other: #DollarFormat(qLoadsRow.customerCommoditiesCharges )#'>
	    <cfset invTotal = qLoadsRow.customerMilesCharges + qLoadsRow.CustFlatRate + qLoadsRow.customerCommoditiesCharges>

	        <cfquery name="QInsertInInvoice" datasource="#QBdsn#">
	            INSERT INTO Invoices (LoadNum, InvDate, PONum, ItemNames, ItemDescriptions, ItemTotalAmount, ItemQuantities, ItemUnitPrice, ItemTaxable, TotalInvoiceAmount, DueDate, PaymentTerms, BookLoad, BillDate, CustomerName, Street, City, State, Zip, PickUpTelephone, BillToAddr)
	            VALUES ('#qLoadsRow.LoadNumber#', '#DateFormat(NOW(),'mm/dd/yyyy')#', '#qLoadsRow.CustomerPONo#', 'Load', '#itemDescriptions#', '#DollarFormat(invTotal)#', '1', '#DollarFormat(invTotal)#', 'N', '#DollarFormat(invTotal)#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', 'See Contract', '-1', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '#qCustomer.CustomerName#', '#qCustomer.Location#', '#qCustomer.City#', '#qState.StateCode#', '#qCustomer.Zipcode#', '#qCustomer.PhoneNo#', '#qCustomer.Location#, #qCustomer.City#, #qState.StateCode#.')
	        </cfquery>
	        
	<!--- 	DO NOT RESET BECAUSE ACTUAL DATA UPDATING AND DOWNLOAD IS
			NOW BEING HANDLED BY THE MDB SINCE THIS PROCEDURE IS NOT PULLING
			ANY DATA. THIS IS A TEMPORARY FIX        
	        <cfquery name="QLoadARStatusUpdate" datasource="#arguments.dsn#">
	            UPDATE Loads
	            SET ARExported = '1'
	            WHERE LoadID = '#qLoadsRow.LoadID#'
	        </cfquery>
	--->		
	</cffunction>


	<!--- QuickBooks Insert Record in Bills Table --->
	<cffunction name="insertInBills" returntype="void">
		<cfargument name="qLoadsRow" required="yes" type="query">
		<cfargument name="QBdsn" required="yes" type="any">
	    <cfargument name="dsn" required="yes" type="any">

	    
	    <CFSTOREDPROC PROCEDURE="USP_GetCustomerDetails" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('qLoadsRow.PayerID') and len(qLoadsRow.PayerID)>
				<CFPROCPARAM VALUE="#qLoadsRow.PayerID#" cfsqltype="CF_SQL_VARCHAR">  
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			</cfif>
			<CFPROCRESULT NAME="qCustomer"> 
		</CFSTOREDPROC>
	    
	    <cfinvoke method="getNoOfStops" LOADID="#qLoadsRow.LoadID#" dsn="#arguments.dsn#" returnvariable="request.NoOfStops" />
		<cfinvoke method="getAllLoads" loadid="#qLoadsRow.LoadID#" dsn="#arguments.dsn#" stopNo="#request.NoOfStops#" returnvariable="qLoadsLastStop" />
	    
	    <cfquery name="qCarrierID" datasource="#arguments.dsn#">
	    	SELECT CarrierID FROM Loads
	        WHERE LoadID = '#qLoadsRow.LoadID#'
	    </cfquery>
	    
	    <CFSTOREDPROC PROCEDURE="USP_GetCarrierDetails" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('qCarrierID.CarrierID') and len(qCarrierID.CarrierID)>
			 	<CFPROCPARAM VALUE="#qCarrierID.CarrierID#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qCarrier"> 
		</CFSTOREDPROC>
	    
	    
	    <cfset invTotal = qLoadsRow.carrierMilesCharges + qLoadsRow.carrFlatRate + qLoadsRow.carrierCommoditiesCharges>
	    
	    
	        <cfquery name="QInsertInBills" datasource="#QBdsn#">
	            INSERT INTO Bills (LoadNum, PickUpDate, DateDelv, DueDate, Carrier, Account, Total, BookLoad, FactorName, FactorMailTo, FactorCity, FactorSt, FactorZip, BilledDate, BillDate, Memo, Terms, CustomerCode, VendorCode, CarrierName, CarrierRemitAddr, CarrierRemitCity, CarrierRemitSt, CarrierRemitZip, TollFree)
	            VALUES ('#qLoadsRow.LoadNumber#', '#DateFormat(qLoadsRow.PickupDate,'mm/dd/yyyy')#', '#DateFormat(qLoadsRow.DeliveryDate,'mm/dd/yyyy')#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '#qCarrier.CarrierName#', 'Purchasing', '#DollarFormat(invTotal)#', '-1', '#qCarrier.CarrierName#', '#qCarrier.Address#', '#qCarrier.City#', '#qCarrier.statecode#', '#qCarrier.ZipCode#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '', 'See Contract', '#qCustomer.CustomerCode#', '#qCarrier.MCNumber#', '#qCarrier.CarrierName#', '#qCarrier.Address#', '#qCarrier.City#', '#qCarrier.statecode#', '#qCarrier.ZipCode#', '#qCarrier.TollFree#')
	        </cfquery>
	        
	<!--- 	DO NOT RESET BECAUSE ACTUAL DATA UPDATING AND DOWNLOAD IS
			NOW BEING HANDLED BY THE MDB SINCE THIS PROCEDURE IS NOT PULLING
			ANY DATA. THIS IS A TEMPORARY FIX      
	        <cfquery name="QLoadAPStatusUpdate" datasource="#arguments.dsn#">
	            UPDATE Loads
	            SET APExported = '1'
	            WHERE LoadID = '#qLoadsRow.LoadID#'
	        </cfquery>
	--->
	</cffunction>

	<!---  QuickBooks Export  --->
	<cffunction name="exportAllLoads" access="remote" returntype="array">
		<cfargument name="QBdsn" required="yes">
		<cfargument name="dsn" required="yes">
		<cfargument name="dateFrom" required="yes">
	    <cfargument name="dateTo" required="yes">
	    
		<cfset arrToReturn = '0,0,0'>
	    
		<cfinvoke method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions">
	    	<cfinvokeargument name="dsn" value="#arguments.dsn#">
	    </cfinvoke>

		<cfinvoke method="getSearchLoads" LoadStatus="#request.qGetSystemSetupOptions.ARAndAPExportStatusID#" searchText="" pageNo="-1" returnvariable="qLoads">
	    	<cfinvokeargument name="dsn" value="#arguments.dsn#">
	    </cfinvoke>

	        <cfquery name="qTruncateOldInvoiceData" datasource="#QBdsn#">
	            DELETE FROM Invoices
	            WHERE 1=1
	        </cfquery>
	        
	        <cfquery name="qTruncateOldBillsData" datasource="#QBdsn#">
	            DELETE FROM Bills
	            WHERE 1=1
	        </cfquery>
	        
	        <cfset customerTypeExportsCount = 0>
	        <cfset carrierTypeExportsCount = 0>
	        <cfset bothTypeExportsCount = 0>
	        
	        <cfloop query="qLoads">
	        	
	            <cfif not isdefined('request.qLoads.orderDate') OR request.qLoads.orderDate eq ''>
	            	<cfset orderDate = DateFormat(NOW(),'mm/dd/yyyy')>
	            <cfelse>
	            	<cfset orderDate = DateFormat(qLoads.orderDate,'mm/dd/yyyy')>
	            </cfif>
	            
	            <cfset dateFrom = DateFormat(arguments.dateFrom,'mm/dd/yyyy')>
	            <cfset dateTo = DateFormat(arguments.dateTo,'mm/dd/yyyy')>
	            
	            
	        	<cfif (qLoads.ARExportedNN eq '1' AND qLoads.APExportedNN eq '1') OR (orderDate LT dateFrom OR orderDate GT dateTo)>
	            	<cfcontinue>
	            <cfelseif qLoads.ARExportedNN eq '1'> <!--- Already Exported for Customer now just need to export for Client(Bills Table) --->
	            	<!--- Insert in Bills --->
	                <cfinvoke method="insertInBills">
	                	<cfinvokeargument name="qLoadsRow" value="#qLoads#">
						<cfinvokeargument name="QBdsn" value="#QBdsn#">
	                    <cfinvokeargument name="dsn" value="#dsn#">
	                </cfinvoke>
	            	<cfset customerTypeExportsCount = customerTypeExportsCount + 1>
	                
	            <cfelseif qLoads.APExportedNN eq '1'> <!--- Already Exported for Client now just need to export for Customer(Invoices Table) --->
	            	<!--- Insert in Invoices --->
	                <cfinvoke method="insertInInvoices">
	                	<cfinvokeargument name="qLoadsRow" value="#qLoads#">
						<cfinvokeargument name="QBdsn" value="#QBdsn#">
	                    <cfinvokeargument name="dsn" value="#dsn#">
	                </cfinvoke>
	            	<cfset carrierTypeExportsCount = carrierTypeExportsCount + 1>
	                
	            <cfelse> <!--- Not Exported yet for Client or Customer export to both tables(Invoices Table, Bills table) --->
	            	<!--- Insert in Invoices --->
	                <cfinvoke method="insertInBills">
	                	<cfinvokeargument name="qLoadsRow" value="#qLoads#">
						<cfinvokeargument name="QBdsn" value="#QBdsn#">
	                    <cfinvokeargument name="dsn" value="#dsn#">
	                </cfinvoke>
	                
	                <cfinvoke method="insertInInvoices">
	                	<cfinvokeargument name="qLoadsRow" value="#qLoads#">
						<cfinvokeargument name="QBdsn" value="#QBdsn#">
	                    <cfinvokeargument name="dsn" value="#dsn#">
	                </cfinvoke>
	            	<cfset bothTypeExportsCount = bothTypeExportsCount + 1>
	            </cfif>
	        </cfloop>
	        
			
			<cfset filePath = "#ExpandPath( './views/' )#templates">
			<cfset filePath = replace(filePath,"gateways\","","ALL")>
			
			<cfzip
				action="zip"
				source="#filePath#/"
				file="#filePath#/QBData.zip"
				filter="QBData.mdb"
				overwrite="true"
			/>
		<!--- index1: Loads Exported for Customer, index2: Loads Exported for Carrier, index3: Loads Exported for Both --->
	    <cfset arrToReturn = ListInsertAt(arrToReturn, 1, '#customerTypeExportsCount#')>
	    <cfset arrToReturn = ListInsertAt(arrToReturn, 2, '#carrierTypeExportsCount#')>
	    <cfset arrToReturn = ListInsertAt(arrToReturn, 3, '#bothTypeExportsCount#')>
	    <cfreturn ListToArray(arrToReturn)>
	</cffunction>

	<cffunction name="getLoadCarriersMails" access="public" returntype="any">
		<cfargument name="loadid" required="true" type="any">
		<cfargument name="dsn" required="no" type="any">
		<cfif isdefined('dsn')>
	    	<cfset activedsn = dsn>
	    <cfelse>
	    	<cfset activedsn = variables.dsn>
	    </cfif>
		<cfset maiList = "">
		<cfif isdefined('arguments.loadid') and len(arguments.loadid) gt 1>
			<cfquery datasource="#activedsn#" name="qrygetcarriers">
				SELECT 
	 				DISTINCT a.NewCarrierID,
	 				carr.EmailID
				FROM LoadStops a 
				JOIN LoadStops b ON a.LoadID = b.LoadID AND a.StopNo = b.StopNo
				LEFT OUTER JOIN (SELECT [CarrierID],[CarrierName], [EmailID] FROM [Carriers]) AS carr ON carr.CarrierID = a.NewCarrierID
				WHERE a.LoadID = <CFQUERYPARAM VALUE="#arguments.loadid#" cfsqltype="CF_SQL_VARCHAR"> 
				AND a.LoadType = 1
				AND b.LoadType = 2
				AND b.StopNo =a.StopNo
			</cfquery>
			
			<cfoutput query="qrygetcarriers">
				<cfif IsValid( "email", qrygetcarriers.EmailID)>
					<cfset maiList = ListAppend(maiList, qrygetcarriers.EmailID,';')>
				</cfif>
			</cfoutput>
		</cfif>
		<cfreturn maiList> 
	</cffunction>

	<cffunction name="getAllStopsCount" access="public" returntype="any">
		<cfargument name="loadid" required="true" type="any">
	    <cfargument name="dsn" required="no" type="any">
	    <cfif isdefined('dsn')>
	    	<cfset activedsn = dsn>
	    <cfelse>
	    	<cfset activedsn = variables.dsn>
	    </cfif>
	    <CFSTOREDPROC PROCEDURE="USP_GetLoadStopCount" DATASOURCE="#activedsn#"> 
			<CFPROCPARAM VALUE="#arguments.loadid#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCRESULT NAME="qrygetloadstopCount"> 
		</CFSTOREDPROC>
		<cfreturn qrygetloadstopCount.CNT>
	</cffunction>   
	<!--- Get All Loads--->
	<cffunction name="getAllLoads" access="public" returntype="query">
		<cfargument name="loadid" required="false" type="any">
		<cfargument name="stopNo" required="false" type="any">
		<cfargument name="sortorder" required="no" type="any">
		<cfargument name="sortby" required="no" type="any">
	    <cfargument name="dsn" required="no" type="any">
		
	    <cfif isdefined('dsn')>
	    	<cfset activedsn = dsn>
	    <cfelse>
	    	<cfset activedsn = variables.dsn>
	    </cfif>
		
		<CFSTOREDPROC PROCEDURE="USP_GetLoadDetails" DATASOURCE="#activedsn#"> 
			<cfif isdefined('arguments.loadid') and len(arguments.loadid) gt 1>
				
				<CFPROCPARAM VALUE="#arguments.loadid#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#arguments.stopNo#" cfsqltype="CF_SQL_INTEGER">
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
		    <CFPROCRESULT NAME="qrygetload"> 
		</CFSTOREDPROC>
		<cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
			<cfquery datasource="#activedsn#" name="qrygetload">
				SELECT l.Loadid,l.LoadNumber,l.IsPartial,l.CarrierID AS CarrierID,
				ISNULL(l.CustomerRatePerMile,0) AS CustomerRatePerMile,
				ISNULL(l.CarrierRatePerMile,0) AS CarrierRatePerMile,
				ISNULL(l.CustomerTotalMiles,0) AS CustomerTotalMiles,
				ISNULL(l.CarrierTotalMiles,0) AS CarrierTotalMiles,
				ISNULL(l.ARExported,'0') AS ARExportedNN,
				ISNULL(l.APExported,'0') AS APExportedNN,
				ISNULL(l.orderDate, '') AS orderDate,
				ISNULL(l.customerMilesCharges, 0) AS customerMilesCharges,
				ISNULL(l.carrierMilesCharges, 0) AS carrierMilesCharges,
				ISNULL(l.customerCommoditiesCharges, 0) AS customerCommoditiesCharges,
				ISNULL(l.carrierCommoditiesCharges, 0) AS carrierCommoditiesCharges,
				ISNULL(l.CustFlatRate, 0) AS CustFlatRate,
				ISNULL(l.carrFlatRate, 0) AS carrFlatRate,
				l.readyDate,
				l.arriveDate,
				l.isExcused,
				ISNULL(l.posttoITS,0) AS posttoITS,
				l.bookedBy,
				CustomerPONo,
				StatusTypeID,
				statusText,
				colorCode,
				PayerID,
				TotalCustomerCharges,
				<!--- shipperStateID, --->
				shipperState,
				shipperCity,
				<!--- consigneeStateID, --->
				consigneeState,
				consigneeCity,
				CarrierName,
				[custName] as CustomerName,
				LoadStopID,
				StopNo,
				[NewPickupDate] as PickupDate ,
				[NewDeliveryDate] as DeliveryDate ,
				NewOfficeID,
				NewNotes,
				isPost,
				IsTransCorePst,
				TotalCarrierCharges,
				TotalCustomerCharges,
				NewCarrierID,
				carrierNotes,
				NewDispatchNotes,
				DispatcherID,
				SalesRepID,
				shipperStopName,
				consigneeStopName,
				shipperLocation,
				consigneeLocation,
				shipperPostalCode,
				consigneePostalCode,
				shipperContactPerson,
				consigneeContactPerson,
				shipperPhone,
				consigneePhone,
				shipperFax,
				consigneeFax,
				shipperEmailID,
				consigneeEmailID,
				shipperReleaseNo,
				consigneeReleaseNo,
				shipperBlind,
				consigneeBlind,
				shipperInstructions,
				consigneeInstructions,
				shipperDirections,
				consigneeDirections,
				shipperLoadStopID,
				consigneeLoadStopID,
				shipperBookedWith,
				consigneeBookedWith,
				shipperEquipmentID,
				consigneeEquipmentID,
				shipperDriverName,
				consigneeDriverName,
				shipperDriverCell,
				consigneeDriverCell,
				shipperTruckNo,
				consigneeTruckNo,
				shipperTrailorNo,
				consigneeTrailorNo,
				shipperRefNo,
				consigneeRefNo,
				shipperMiles,
				consigneeMiles,
				shipperCustomerID,
				consigneeCustomerID, 			
				EmergencyResponseNo,
				CODAmt,
				CODFee,
				DeclaredValue,
				postto123loadboard,
				Notes,invoiceNumber,weight,userDefinedFieldTrucking,CarrierInvoiceNumber
	ROW_NUMBER() OVER (ORDER BY 
	                  #arguments.sortBy# #arguments.sortOrder#,l.LoadNumber
	                            
	                    ) AS Row
	      				FROM LOADS l
	      				left outer join (select 
						a.LoadID,
						a.LoadStopID,a.StopNo,
						a.NewCarrierID,
						a.NewOfficeID,
						
						a.City AS shipperCity,
						b.City AS consigneeCity,
						a.custName AS shipperStopName,
						b.custName AS consigneeStopName,
						a.Address AS shipperLocation,
						b.Address AS consigneeLocation,
						a.PostalCode AS shipperPostalCode,
						b.PostalCode AS consigneePostalCode,
						a.ContactPerson AS shipperContactPerson,
						b.ContactPerson AS consigneeContactPerson,
						a.Phone AS shipperPhone,
						b.Phone AS consigneePhone,
						a.fax AS shipperFax,
						b.fax AS consigneeFax,
						a.EmailID AS shipperEmailID,
						b.EmailID AS consigneeEmailID,
						
						a.ReleaseNo AS shipperReleaseNo,
						b.ReleaseNo AS consigneeReleaseNo,
						a.Blind AS shipperBlind,
						b.Blind AS consigneeBlind,
						a.Instructions AS shipperInstructions,
						b.Instructions AS consigneeInstructions,
						a.Directions AS shipperDirections,
						b.Directions AS consigneeDirections,
						a.LoadStopID AS shipperLoadStopID,
						b.LoadStopID AS consigneeLoadStopID,
						a.NewBookedWith AS shipperBookedWith,
						b.NewBookedWith AS consigneeBookedWith,
						a.NewEquipmentID AS shipperEquipmentID,
						b.NewEquipmentID AS consigneeEquipmentID,
						a.NewDriverName AS shipperDriverName,
						b.NewDriverName AS consigneeDriverName,
						a.NewDriverCell AS shipperDriverCell,
						b.NewDriverCell AS consigneeDriverCell,
						a.NewTruckNo AS shipperTruckNo,
						b.NewTruckNo AS consigneeTruckNo,
						a.NewTrailorNo AS shipperTrailorNo,
						b.NewTrailorNo AS consigneeTrailorNo,
						a.RefNo AS shipperRefNo,
						b.RefNo AS consigneeRefNo,
						a.Miles AS shipperMiles,
						b.Miles AS consigneeMiles,
						a.CustomerID AS shipperCustomerID,
						b.CustomerID AS consigneeCustomerID,
						
						a.StateCode as shipperState,
						b.StateCode as consigneeState,
						a.userDef1 as userDef1,
						a.userDef2 as userDef2,
						a.userDef3 as userDef3,
						a.userDef4 as userDef4,
						a.userDef5 as userDef5,
						a.userDef6 as userDef6
						FROM LoadStops a 
						JOIN LoadStops b on a.LoadID = b.LoadID and a.StopNo = b.StopNo
						<!--- left outer join (SELECT [CustomerName], CustomerID, location, city, StateID, zipcode, contactPerson, email, PhoneNo, Fax FROM [Customers]) AS shpCust ON a.CustomerID = shpCust.CustomerID
						left outer join (SELECT [stateID] as shipperStateID,[stateCode] as shipperState FROM [states]) as ShipState on ShipState.shipperStateID = a.StateCode
						left outer join (SELECT [CustomerName], CustomerID, location, city, StateID, zipcode, contactPerson, email, PhoneNo, Fax FROM [Customers]) AS conCust ON b.CustomerID = conCust.CustomerID
						left outer join (SELECT [stateID] as consigneeStateID,[stateCode] as consigneeState FROM [states]) as ConsState on ConsState.consigneeStateID = b.StateCode--->
	      				where b.LoadID = a.LoadID
	      				and a.LoadType = 1
						and b.LoadType = 2) as stops  on stops.loadid = l.loadid
						
						left outer join (SELECT [CarrierID],[CarrierName] FROM [Carriers]) as carr on carr.CarrierID = stops.NewCarrierID
						left outer join (SELECT [CarrierOfficeID],[Manager]  FROM [CarrierOffices]) as office on office.CarrierOfficeID = stops.NewOfficeID
						left outer join (SELECT [StatusTypeID] as stTypeId,[statusText], colorCode FROM [loadStatusTypes]) as loadStatus on loadStatus.stTypeId = l.StatusTypeID
						<!--- left outer join (SELECT [CustomerName],[CustomerID] FROM [Customers]) as cust on cust.CustomerID = l.PayerID --->
						left outer join (SELECT [StatusTypeID] as lststType,[StatusText] as lStatusText FROM [LoadStatusTypes]) as LStatusTypes on LStatusTypes.lststType = l.StatusTypeID
	      				where l.LoadID = l.LoadID
					order by #arguments.sortby# #arguments.sortorder#;
			</cfquery>
			<cfreturn qrygetload>
		</cfif>
		
		<cfreturn qrygetload>	
	</cffunction>

	<!--- Get All Loads by Carriers--->
	<cffunction name="getAllLoadsByCarrier" access="public" returntype="query">
		<cfargument name="carrierID" required="false" type="any">
		<cfargument name="stopNo" required="false" type="any">
		<CFSTOREDPROC PROCEDURE="USP_GetLoadDetailsByCarrier" DATASOURCE="#variables.dsn#"> 
			<cfif isdefined('arguments.carrierID') and len(arguments.carrierID) gt 1>
				<CFPROCPARAM VALUE="#arguments.carrierID#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
			</cfif> 
		    <CFPROCRESULT NAME="qrygetload"> 
		</CFSTOREDPROC>
	    <cfreturn qrygetload>
		<!--- f859dcc1-2e18-4b49-8a5b-25b5592d257d --->
	</cffunction>

	<!--- Get All Items--->

	<cffunction name="getAllItems" access="public" returntype="query">
		<cfargument name="LOADSTOPID" required="false" type="any">
		
		<CFSTOREDPROC PROCEDURE="USP_GetLoadItems" DATASOURCE="#variables.dsn#"> 
			<cfif isdefined('arguments.LOADSTOPID') and len(arguments.LOADSTOPID) gt 1>
				<CFPROCPARAM VALUE="#arguments.LOADSTOPID#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
			</cfif> 
		    <CFPROCRESULT NAME="qrygetloadItems"> 
		</CFSTOREDPROC>
	    <cfreturn qrygetloadItems>
	</cffunction>

	<!--- Get No of Stops--->

	<cffunction name="getNoOfStops" access="public" returntype="numeric">
		<cfargument name="LOADID" required="true" type="any">
	    <cfargument name="dsn" required="no" type="any">
	    
	    <cfif isdefined('dsn')>
	    	<cfset activedsn = dsn>
	    <cfelse>
	    	<cfset activedsn = variables.dsn>
	    </cfif>
	    
		<cfquery name="toTalNoOfStops" datasource="#activedsn#">
			select max(stopNo) as totStop from LoadStops
			where loadId=<CFQUERYPARAM VALUE="#arguments.LOADID#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		<cfif toTalNoOfStops.recordcount gt 0>
		    <cfreturn toTalNoOfStops.totStop>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>

	<!--- get dispatcher and sales person of selected customer --->
	<cffunction name="getAjaxLoadSalesperson_Dispatcher" access="remote" returntype="array">
	<cfargument name="dsn" type="string" required="yes" />	
	<cfargument name="CustomerID" required="No" type="any">
	<!--- Call stored procedure for Get Sales person & Dispatcher ID --->
		
		<cfset CustArray = ArrayNew(1)>
		<cfset CustArray[1]="">
		<cfset CustArray[2]="">	
		
		<cfquery name="qrygetcustomers" datasource="#arguments.dsn#">
			select SalesRepID,AcctMGRID from customers
			where customerId = '#arguments.CustomerID#'
		</cfquery>
		<cfif len(qrygetcustomers.SalesRepID)>
			<cfquery name="qrygetSalesP" datasource="#arguments.dsn#">
				select employeeID from employees where employeeid = '#qrygetcustomers.SalesRepID#' and isActive = 'True'
			</cfquery> 
			<cfif qrygetSalesP.recordcount>
				<cfset CustArray[1]=ucase(qrygetSalesP.employeeID)>
			</cfif>
		</cfif>
		
		<cfif len(qrygetcustomers.AcctMGRID)>
			<cfquery name="qrygetDispatcher" datasource="#arguments.dsn#">
				select employeeID from employees where employeeid = '#qrygetcustomers.AcctMGRID#' 
			</cfquery> 
			<cfif qrygetDispatcher.recordcount>
				<cfset CustArray[2]=ucase(qrygetDispatcher.employeeID)>
			</cfif>
		</cfif>
		
		<!--- <CFSTOREDPROC PROCEDURE="USP_GetCustomerDetails" DATASOURCE="#arguments.dsn#"> 
			<cfif isdefined('arguments.CustomerID') and len(arguments.CustomerID)>
			 	<CFPROCPARAM VALUE="#arguments.CustomerID#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
			 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCRESULT NAME="qrygetcustomers"> 
		</CFSTOREDPROC> --->
	         
	<cfreturn CustArray>
	</cffunction>
	<!--- Delete Stops--->
	<cffunction name="deleteStops" access="remote" returntype="string">
	<cfargument name="dsn" type="string" required="yes" />	
	<cfargument name="stopID" required="No" type="any">
	<cfargument name="stopNo" required="No" type="any">
	<cfargument name="LoadID" required="No" type="any">
	<cftry>
	 <cftransaction>
		<cfquery name="deleteItems" datasource="#arguments.dsn#">
			delete from loadStopCommodities where LoadStopID = '#arguments.stopID#'
		</cfquery>
		
		<cfquery name="deleteStop" datasource="#arguments.dsn#">
			delete from loadStops where LoadId = '#arguments.LoadID#' and stopNo = #arguments.stopNo#
		</cfquery>
	 </cftransaction>
	<cfreturn true>
	<cfcatch type="any">
		<cfreturn cfcatch.Detail>
	</cfcatch>
	</cftry>
	</cffunction>
	  
	<cffunction name="ajaxDeleteStops" access="remote" output="yes" returnformat="json">
	<cfargument name="dsn" type="string" required="yes" />	
	<cfargument name="stopID" required="No" type="any">
	<cfargument name="stopNo" required="No" type="any">
	<cfargument name="LoadID" required="No" type="any">
	<cftry>
	 <cftransaction>
		<cfquery name="deleteItems" datasource="#arguments.dsn#">
			delete from loadStopCommodities where LoadStopID = '#arguments.stopID#'
		</cfquery>
		
		<cfquery name="deleteStop" datasource="#arguments.dsn#">
			delete from loadStops where LoadId = '#arguments.LoadID#' and stopNo = #arguments.stopNo#
		</cfquery>
	 </cftransaction>
	<cfscript>
	 transaction = StructNew();
	 StructInsert(transaction, "transaction", "true");
	</cfscript>
	#SerializeJSON(transaction)#
	<cfcatch type="any">
		#cfcatch.Detail#
	</cfcatch>
	</cftry>
	</cffunction>

	<cffunction name="getAllStop" access="public" output="false" returntype="any">
	    <cfargument name="CustomerStopID" required="no" type="any">
	         	<CFSTOREDPROC PROCEDURE="USP_GetStopDetailsforLoads" DATASOURCE="#variables.dsn#"> 
					<cfif isdefined('arguments.CustomerStopID') and len(arguments.CustomerStopID)>
					 	<CFPROCPARAM VALUE="#arguments.CustomerStopID#" cfsqltype="CF_SQL_VARCHAR">  
					 <cfelse>
					 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
					 </cfif>
					 <CFPROCRESULT NAME="qrygetStops"> 
				</CFSTOREDPROC>
	            
	             <cfreturn qrygetStops>
	</cffunction>


	<!---<cffunction name="getStopsByLoadId" access="public" output="false" returntype="any">
	    <cfargument name="LoadID" required="yes" type="any">
	         	<CFSTOREDPROC PROCEDURE="USP_GetStopsByLoadId" DATASOURCE="#variables.dsn#"> 
				<CFPROCPARAM VALUE="#arguments.LoadID#" cfsqltype="CF_SQL_VARCHAR">  

					 <CFPROCRESULT NAME="qrygetStops"> 
				</CFSTOREDPROC>
	             <cfreturn qrygetStops>
	</cffunction>--->


	<!---Get Sales Person with auth level---->
	<cffunction name="getSalesPerson" access="remote" returntype="any">
	 <cfargument name="AuthLevelId" required="no">
		 <cfquery name="getSalesperson" datasource="#variables.dsn#">
			 SELECT * FROM employees
	         WHERE ( roleid = #arguments.AuthLevelID# OR  roleid = '4' ) and isActive = 'True'
	         ORDER BY Name
		 </cfquery>
	 <cfreturn getSalesperson>
	</cffunction>
	<!--------get load add/edit sales persion--->
	<cffunction name="getloadSalesPerson" access="remote" returntype="any">
	 <cfargument name="AuthLevelId" required="no">
		 <cfquery name="getSalesperson" datasource="#variables.dsn#">
			 SELECT EmployeeID,Name FROM employees
	         WHERE ( roleid <cfif IsNumeric(arguments.AuthLevelID)> = #arguments.AuthLevelID#<cfelse>in (<cfqueryparam list="true" value="#arguments.AuthLevelID#">) </cfif> OR  roleid = '4' ) and isActive = 'True'
	         ORDER BY Name
		 </cfquery>
	 <cfreturn getSalesperson>
	</cffunction>
	<!---Set Session---->
	<cffunction name="setSession" access="remote" returntype="any">
	 <cfargument name="isSession" required="yes">
		<cfif arguments.isSession is 1>
			<cfset session.checkUnload ='add'>
		<cfelse>
			<cfset session.checkUnload =''>
		</cfif>
	 <cfreturn session.checkUnload>
	</cffunction>
	      
	 <!--- Set Session Ajax version--->     
	<cffunction name="setAjaxSession" access="remote" output="yes" returnformat="json">
	 <cfargument name="isSession" required="yes">
		<cfif arguments.isSession is 1>
			<cfset session.checkUnload ='add'>
		<cfelse>
			<cfset session.checkUnload =''>
		</cfif>
	    <cfscript>
	     sessionCheck = StructNew();
	     StructInsert(sessionCheck, "sessionCheck", session.checkUnload);
	    </cfscript>
	    #SerializeJSON(sessionCheck)#
	</cffunction>

	<cffunction name="getSession" access="remote" returntype="any">
	  	<cfif not isdefined('session.checkUnload')>
			<cfset session.checkUnload = 'no'>
		</cfif>
		<cfreturn session.checkUnload>
	</cffunction>
	      
	<!--- Get Session Ajax version--->      
	<cffunction name="getAjaxSession" access="remote" output="yes" returnformat="json">
		<cfargument name="UnlockStatus" type="any" required="no">
		<cfargument name="loadid" type="any" required="no">
		<cfargument name="dsn" type="any" required="no">
		<cfargument name="sessionid" type="any" required="no">
		<cfargument name="userid" type="any" required="no">
		<cfargument name="tabid" type="any" required="no">
		<cfif structkeyexists(arguments,"tabid")>
			<!----query to delete -corresponding rows of tabid--->
			<cfquery name="qryGetBrowserTabDetails" datasource="#arguments.dsn#">
				delete from  UserBrowserTabDetails 
				where tabID=<cfqueryparam value="#arguments.tabid#" cfsqltype="cf_sql_varchar">	
			</cfquery>
		</cfif>
		<cfif structkeyexists(arguments,"UnlockStatus") and structkeyexists(arguments,"loadid") and arguments.UnlockStatus eq false and len(trim(arguments.loadid)) gt 1 and structkeyexists(arguments,"dsn") and structkeyexists(arguments,"sessionid") and structkeyexists(arguments,"userid")>
			<!---Query to select browser tab details--->
			<cfquery name="qryGetBrowsertabDetails" datasource="#arguments.dsn#">
				select id from UserBrowserTabDetails
				where 
					loadid=<cfqueryparam value="#arguments.loadid#" cfsqltype="cf_sql_varchar">	
				and sessionid=<cfqueryparam value="#arguments.sessionid#" cfsqltype="cf_sql_varchar">	
				and userid=<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">	
			</cfquery>
			<cfif not qryGetBrowsertabDetails.recordcount>
				<!---Query to remove lock --->
				<cfquery name="qryGetInuseBy" datasource="#arguments.dsn#">
					update loads 
					set 
						InUseBy=null,
						InUseOn=null,
						sessionId=null
					where loadid=<cfqueryparam value="#arguments.loadid#" cfsqltype="cf_sql_varchar">	
				</cfquery>
			</cfif>	
		</cfif>
	  	<cfif not isdefined('session.checkUnload')>
			<cfset session.checkUnload = 'no'>
		</cfif>
		<cfscript>
	      sessionCheck = StructNew();
	      StructInsert(sessionCheck, "sessionCheck", session.checkUnload);
	    </cfscript>
	      #SerializeJSON(sessionCheck)#
	</cffunction>
	<!---function to insert UserBrowserTabDetails--->
	<cffunction name="insertTabDetails" access="remote" output="yes" returnformat="json">
		<cfargument name="tabID" type="any" required="yes">
		<cfargument name="loadid" type="any" required="yes">
		<cfargument name="sessionid" type="any" required="yes">
		<cfargument name="userid" type="any" required="yes">
		<cfargument name="dsn" type="any" required="yes">
		<!---query to select UserBrowserTabDetails--->
		<cfquery name="qryGetBrowserTabDetails" datasource="#arguments.dsn#">
			select * from  UserBrowserTabDetails 
			where 1=1 
			and loadid=<cfqueryparam value="#arguments.loadid#" cfsqltype="cf_sql_varchar">	
			and sessionid=<cfqueryparam value="#arguments.sessionid#" cfsqltype="cf_sql_varchar">	
			and userid=<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">	
			and tabID=<cfqueryparam value="#arguments.tabID#" cfsqltype="cf_sql_varchar">	
		</cfquery>
		<cfif not qryGetBrowserTabDetails .recordcount>
			<!---Query to insert UserBrowserTabDetails--->
			<cfquery name="qryInsertGetBrowserTabDetails" datasource="#arguments.dsn#">
				INSERT INTO UserBrowserTabDetails (userid, loadid, tabid, sessionid, createddate)
	            VALUES (<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.loadid#" cfsqltype="cf_sql_varchar">,	
						<cfqueryparam value="#arguments.tabID#" cfsqltype="cf_sql_varchar">	,
						<cfqueryparam value="#arguments.sessionid#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)
			</cfquery>				
		</cfif>
	</cffunction>
	
	<!---function to delete BrowserTabDetails--->
	<cffunction name="deleteTabDetails" access="remote" output="yes" returnformat="json">
		<cfargument name="tabID" type="any" required="yes">
		<cfargument name="sessionid" type="any" required="yes">
		<cfargument name="userid" type="any" required="yes">
		<cfargument name="dsn" type="any" required="yes">
		<!---query to delete UserBrowserTabDetails--->
		<cfquery name="qryGetBrowserTabDetails" datasource="#arguments.dsn#">
			delete from  UserBrowserTabDetails 
			where 
			 sessionid=<cfqueryparam value="#arguments.sessionid#" cfsqltype="cf_sql_varchar">	
			and userid=<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">	
			and tabID=<cfqueryparam value="#arguments.tabID#" cfsqltype="cf_sql_varchar">	
		</cfquery>
	</cffunction>
		
	<!--- get Bimdable Value Shipper--->
	<cffunction name="getShipperBindable" output="false" access="remote" returntype="array">
			<cfargument name="customerid" type="any" required="yes">
			<cfargument name="dsn" type="any" required="yes">
			<cfset var dtResult = ArrayNew(2)>	
			<cfset shipperStop = "">
				<cfquery name="getshipperStops" datasource="#arguments.dsn#">
					SELECT
					LoadStopID,CustomerStopName,Location,City,
					(cs.statecode) as [state],
					PostalCode,ContactPerson,EmailID,Phone,	Fax,ReleaseNo ReleaseNo,
					Blind Blind,StopDate StopDate,StopTime StopTime,TimeIn TimeIn,
					TimeOut TimeOut,Instructions Instructions,Directions Directions
					FROM LoadStops cs
					where CustomerID = '#arguments.customerid#'
					AND LoadType = 1
					AND LoadID IS NOT NULL
	                ORDER BY (SELECT UPPER(LTRIM(RTRIM(CustomerStopName))))
				</cfquery>
				
				<cfset shipperStopId = "">
				<cfset shipperStopNameList="">
				<cfset tempList = "">
				<cfloop query="getshipperStops">
					<!---<cfset tempList="#getshipperStops.CustomerStopName#" & chr(9) & "#getshipperStops.City#" & "       "& "#getshipperStops.State#">--->
	                
	                <cfset tempList = "#getshipperStops.CustomerStopName#" & chr(9) & "#getshipperStops.Location#" & chr(9) & "#getshipperStops.City#" & chr(9) & "#getshipperStops.State#" & chr(9) & "#getshipperStops.PostalCode#">
					<cfif isdefined('getshipperStops.Instructions') AND Trim(getshipperStops.Instructions) neq ''>
	                	<cfset tempList = tempList &chr(9) & "#Left(getshipperStops.Instructions,10)# ...">
	                </cfif>
	                
	                
					<cfset shipperStopId = ListAppend(shipperStopId,getshipperStops.LoadStopID)>
					<cfset shipperStopNameList = ListAppend(shipperStopNameList,tempList)>
				</cfloop>
				
				
				<!--- Convert results to array --->
				<cfif listlen(shipperStopId) gt 0>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "CHOOSE A SHIPPER OR ENTER ONE BELOW">
					<cfloop from="1" to="#listlen(shipperStopId)#" index="k">
						<cfset dtResult[k+1][1] = listgetat(shipperStopId,k)>
						<cfset dtResult[k+1][2] = "#listgetat(shipperStopNameList,k)#">
					</cfloop>
				<cfelse>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "Customer's Shipper stop not available">
				</cfif>
				
			<cfreturn dtResult>
		</cffunction>

	<!--- get Bimdable Value for Consignee  --->
	<cffunction name="getConsigneeBindable" output="false" access="remote" returntype="array">
			<cfargument name="customerid" type="any" required="yes">
			<cfargument name="dsn" type="any" required="yes">
			<cfset var dtResult = ArrayNew(2)>	
			<cfset shipperStop = "">
				<cfquery name="getshipperStops" datasource="#arguments.dsn#">
					SELECT
					LoadStopID,CustomerStopName,Location,City,
					(cs.statecode) as [state],
					PostalCode,ContactPerson,EmailID,Phone,	Fax,ReleaseNo ReleaseNo,
					Blind Blind,StopDate StopDate,StopTime StopTime,TimeIn TimeIn,
					TimeOut TimeOut,Instructions Instructions,Directions Directions
					FROM LoadStops cs
					where CustomerID = '#arguments.customerid#'
					AND LoadType = 2
					AND LoadID IS NOT NULL
	                ORDER BY (SELECT UPPER(LTRIM(RTRIM(CustomerStopName))))
				</cfquery>
				
				<cfset shipperStopId = "">
				<cfset shipperStopNameList="">
				<cfset tempList = "">
				<cfloop query="getshipperStops">
					<!---<cfset tempList="#getshipperStops.CustomerStopName#" & chr(9) & "#getshipperStops.City#" & "       "& "#getshipperStops.State#">--->
	                <cfset spaces = "			">
	                <cfset tempList = "#getshipperStops.CustomerStopName#  " & "#spaces#" & "  #getshipperStops.Location#  " & "#spaces#" & "  #getshipperStops.City#  " & "#spaces#" & "  #getshipperStops.State#  " & "#spaces#" & "  #getshipperStops.PostalCode#  ">
					<cfif isdefined('getshipperStops.Instructions') AND Trim(getshipperStops.Instructions) neq ''>
	                	<cfset tempList = tempList & "#spaces#" & "  #Left(getshipperStops.Instructions,10)# ...">
	                </cfif>
	                
					<cfset shipperStopId = ListAppend(shipperStopId,getshipperStops.LoadStopID)>
					<cfset shipperStopNameList = ListAppend(shipperStopNameList,tempList)>
				</cfloop>
				
				
				<!--- Convert results to array --->
				<cfif listlen(shipperStopId) gt 0>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "CHOOSE A CONSIGNEE OR ENTER ONE BELOW">
					<cfloop from="1" to="#listlen(shipperStopId)#" index="k">
						<cfset dtResult[k+1][1] = listgetat(shipperStopId,k)>
						<cfset dtResult[k+1][2] = "#listgetat(shipperStopNameList,k)#">
					</cfloop>
				<cfelse>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "Customer's Consignee Stop not available">
				</cfif>
				
			<cfreturn dtResult>
		</cffunction>
		
		<!----Get All Stop Information By Customer---->
	<cffunction name="getAllStopByCustomer" access="public" output="false" returntype="any">
	    <cfargument name="CustomerID" required="no" type="any">
		<cfargument name="StopType" required="no" type="any">
	         	<CFSTOREDPROC PROCEDURE="USP_GetShipperInfoByCustomer" DATASOURCE="#variables.dsn#"> 
					<cfif isdefined('arguments.CustomerID') and len(arguments.CustomerID)>
					 	<CFPROCPARAM VALUE="#arguments.CustomerID#" cfsqltype="CF_SQL_VARCHAR">
					 	<CFPROCPARAM VALUE="#arguments.StopType#" cfsqltype="CF_SQL_inTEGER">  
					 <cfelse>
					 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
					 </cfif>
					 <CFPROCRESULT NAME="qrygetStops"> 
				</CFSTOREDPROC>
	                        
	<cfreturn qrygetStops>
	</cffunction>
	<!-----Get Loads By Advanced Search ---------------->
	<cffunction name="getSearchLoads" access="public" output="false" returntype="any">
	    <cfargument name="LoadStatus" type="any" required="no">
	    <cfargument name="LoadNumber" type="any" required="no">
	    <cfargument name="Office" type="any" required="no">
		<cfargument name="consigneeCity" type="any" required="no">	
	    <cfargument name="shipperCity" type="any" required="no">
	    <cfargument name="ShipperState" type="any" required="no">
	    <cfargument name="ConsigneeState" type="any" required="no">
	    <cfargument name="CustomerName" type="any" required="no">
	    <cfargument name="StartDate" type="any" required="no">
	    <cfargument name="EndDate" type="any" required="no">
	    <cfargument name="CarrierName" type="any" required="no">
	    <cfargument name="CustomerPO" type="any" required="no">
	    <cfargument name="lastweek" type="any" required="no">
	    <cfargument name="thisweek" type="any" required="no">
	    <cfargument name="thismonth" type="any" required="no">
	    <cfargument name="lastmonth" type="any" required="no">
		<cfargument name="searchText" type="any" required="no">
	    <cfargument name="pageNo" required="yes" type="any">
	    <cfargument name="sortOrder" required="no" type="any">
	    <cfargument name="sortBy" required="no" type="any">
	    <cfargument name="dsn" required="no" type="any">
		<cfargument name="agentUsername" required="no" type="any">
		<cfargument name="rowsperpage" required="no" type="numeric">
		
		<cfargument name="bol" required="no" type="any">
		<cfargument name="dispatcher" required="no" type="any">
		<cfargument name="agent" required="no" type="any">
	   		 <cfset setter="123456789">
	<!--- <cfdump var="#arguments#" /><cfabort> --->
		<cfset var counterForDatefinding=0>
		<cfif isdefined('ARGUMENTS.SEARCHTEXT')>
			<cfif findnocase('/',ARGUMENTS.SEARCHTEXT) or findnocase('-',ARGUMENTS.SEARCHTEXT)>
				<cfset var counterForDatefinding=1>
			</cfif>	
		</cfif>		
		<cfif isdefined('arguments.dsn')>
	    	<cfset activedsn = arguments.dsn>
	    <cfelse>
	    	<cfset activedsn = variables.dsn>
	    </cfif>
		
	    <cfif not isdefined('arguments.pageNo') or len(arguments.pageNo) eq 0>
		 	<cfset arguments.pageNo=1>
		</cfif>

	    <cfset pageSize = 30 > <!--- Page Size --->
	    <cfif structKeyExists(arguments, "rowsperpage") AND isNumeric(arguments.rowsperpage)>
	    	<cfset pageSize = arguments.rowsperpage >
	    </cfif>   
	         
	    <cfif not isdefined('arguments.sortOrder') or len(arguments.sortOrder) eq 0>
		 	<cfset arguments.sortOrder="ASC">
		</cfif>
	         
	    <cfif not isdefined('arguments.sortBy') or len(arguments.sortBy) eq 0>
		 	<cfset arguments.sortBy = "statusText, l.LoadNumber">
		</cfif>
	    
	    
		  <cfif isDefined("arguments.lastweek") and len(arguments.lastweek) gt 1>
		  <!---
		  	Get today's date; but then subtract 7 days from it so that
		  	we have "this" day of last week. The Fix() method simply
		  	removes the time stamp (and converts date to numeric date).
		  --->
		  <cfset dtLastWeek = (Fix( Now() ) - 7) />
		  <!---
		  	Now that we have a day in last week, we can easily grab the
		  	start and end of the week.
		  --->
		  
		  <cfset objLastWeek = StructNew() />
		     
		  <!--- Get start of week. --->
		  <cfset objLastWeek.Start = DateFormat(
		  	dtLastWeek - DayOfWeek( dtLastWeek ) + 1
		  	) />
		   
		  <!--- Get end of week by adding to start date. --->
		  <cfset objLastWeek.End = DateFormat( objLastWeek.Start + 6 ) />
		  
		  <cfset arguments.StartDate = objLastWeek.Start> 
		  <cfset arguments.enddate = objLastWeek.End> 
		  
	  
		  </cfif>
		  <cfif isDefined("arguments.thisweek") and len(arguments.thisweek) gt 1>
		      <cfset dtToday = Fix( Now() ) />
		
		      <!--- Get the week start date. --->
		      <cfset dtWeekStart = (dtToday - DayOfWeek( dtToday ) + 1) />
		       
		      <!--- Get the week end date. --->
		      <cfset dtWeekEnd = (dtToday + (7 - DayOfWeek( dtToday ))) />
		      <cfset arguments.StartDate = dtWeekStart> 
		      <cfset arguments.enddate = dtWeekEnd> 
		  </cfif>  
		  <cfif isDefined("arguments.thismonth") and len(arguments.thismonth) gt 1 >
		
		      <!--- Getting Start and end date of Month --->
		
		      <cfset dtToday = Fix( Now() ) />
		       <!--- Get the month start date. --->
		       <cfset dtMonthStart = (dtToday - Day( dtToday ) + 1) />
		        
		       <!--- Get the month end date. --->
		       <cfset dtMonthEnd = (
		       dtToday + (DaysInMonth( dtToday ) - Day( dtToday ))
		       ) />
		      <cfset arguments.StartDate = dtMonthStart> 
		      <cfset arguments.enddate = dtMonthEnd> 
		  </cfif>  
		  <cfif isDefined("arguments.lastmonth")   and len(arguments.lastmonth)>
		      <!--- Getting Start and end date of Month --->
		      <cfset dtToday = Fix( Now() ) />
		      <cfset dtToday = DateAdd("m",-1,dtToday)>
		       <!--- Get the month start date. --->
		       <cfset dtMonthStart = (dtToday - Day( dtToday ) + 1) />
		        
		       <!--- Get the month end date. --->
		       <cfset dtMonthEnd = (
		       dtToday + (DaysInMonth( dtToday ) - Day( dtToday ))
		       ) />
		      <cfset arguments.StartDate = dtMonthStart> 
		      <cfset arguments.enddate = dtMonthEnd> 
		  </cfif>
		<cfquery  name="qryGetInvoiceNumberStatus" datasource="#activedsn#">
			select MinimumLoadInvoiceNumber from SystemConfig
		</cfquery>
		<cfquery  name="qryGetFreightBrokerStatus" datasource="#activedsn#">
			select FreightBroker from SystemConfig
		</cfquery>
	      <cfquery datasource="#activedsn#" name="qrygetload" result="txtQryGetLoad">
	      			<!--- PageNo -1 means return all the records, no Pagination is desired. --->
	      			<cfif arguments.pageNo neq -1>WITH page AS (</cfif>
	      			SELECT l.Loadid,l.LoadNumber,l.CarrierID AS CarrierID,
					ISNULL(l.CustomerRatePerMile,0) AS CustomerRatePerMile,
					ISNULL(l.CarrierRatePerMile,0) AS CarrierRatePerMile,
					ISNULL(l.CustomerTotalMiles,0) AS CustomerTotalMiles,
					ISNULL(l.CarrierTotalMiles,0) AS CarrierTotalMiles,
					ISNULL(l.ARExported,'0') AS ARExportedNN,
					ISNULL(l.APExported,'0') AS APExportedNN,
					ISNULL(l.orderDate, '') AS orderDate,
					ISNULL(l.customerMilesCharges, 0) AS customerMilesCharges,
					ISNULL(l.carrierMilesCharges, 0) AS carrierMilesCharges,
					ISNULL(l.customerCommoditiesCharges, 0) AS customerCommoditiesCharges,
					ISNULL(l.carrierCommoditiesCharges, 0) AS carrierCommoditiesCharges,
					ISNULL(l.CustFlatRate, 0) AS CustFlatRate,
					ISNULL(l.carrFlatRate, 0) AS carrFlatRate,
					invoiceNumber,
					CustomerPONo,
					StatusTypeID,
					statusText,
					colorCode,
					PayerID,
					TotalCustomerCharges,
					shipperState,
					shipperCity,
					consigneeState,
					consigneeCity,
					CarrierName,
					[custName] as CustomerName,
					LoadStopID,
					StopNo,
					[NewPickupDate] as PickupDate ,
					[NewDeliveryDate] as DeliveryDate ,
					NewOfficeID,
					NewNotes,
					isPost,
					IsTransCorePst,
					TotalCarrierCharges,
					NewCarrierID,
					carrierNotes,
					NewDispatchNotes,
					DispatcherID,
					SalesRepID,
					shipperStopName,
					consigneeStopName,
					shipperLocation,
					consigneeLocation,
					shipperPostalCode,
					consigneePostalCode,
					shipperContactPerson,
					consigneeContactPerson,
					shipperPhone,
					consigneePhone,
					shipperFax,
					consigneeFax,
					shipperEmailID,
					consigneeEmailID,
					shipperReleaseNo,
					consigneeReleaseNo,
					shipperBlind,
					consigneeBlind,
					shipperInstructions,
					consigneeInstructions,
					shipperDirections,
					consigneeDirections,
					shipperLoadStopID,
					consigneeLoadStopID,
					shipperBookedWith,
					consigneeBookedWith,
					shipperEquipmentID,
					consigneeEquipmentID,
					shipperDriverName,
					consigneeDriverName,
					shipperDriverCell,
					consigneeDriverCell,
					shipperTruckNo,
					consigneeTruckNo,
					shipperTrailorNo,
					consigneeTrailorNo,
					shipperRefNo,
					consigneeRefNo,
					shipperMiles,
					consigneeMiles,
					shipperCustomerID,
					empDispatch,
					empAgent,
					userDefinedFieldTrucking,
					Equipments1.EquipmentName,
					l.DriverName,
					consigneeCustomerID, ROW_NUMBER() OVER (ORDER BY 
	                           #arguments.sortBy#  #arguments.sortOrder#,l.LoadNumber
	                            
	                    ) AS Row
	      				FROM LOADS l
	      				left outer join (select 
						a.LoadID,	
						a.LoadStopID,a.StopNo,	
						a.NewCarrierID,
						a.NewOfficeID,
						
						a.City AS shipperCity,
						a.CustName as shipperStopName,
						a.Address AS shipperLocation,
						a.PostalCode AS shipperPostalCode,
						a.ContactPerson AS shipperContactPerson,
						a.Phone AS shipperPhone,
						a.fax AS shipperFax,
						a.EmailID AS shipperEmailID,
						a.ReleaseNo AS shipperReleaseNo,
						a.Blind AS shipperBlind,
						a.Instructions AS shipperInstructions,
						a.Directions AS shipperDirections,
						a.LoadStopID AS shipperLoadStopID,
						a.NewBookedWith AS shipperBookedWith,
						a.NewEquipmentID AS shipperEquipmentID,
						a.NewDriverName AS shipperDriverName,
						a.NewDriverCell AS shipperDriverCell,
						a.NewTruckNo AS shipperTruckNo,
						a.NewTrailorNo AS shipperTrailorNo,
						a.RefNo AS shipperRefNo,
						a.Miles AS shipperMiles,
						a.CustomerID AS shipperCustomerID,
						a.statecode as shipperState,
						a.userDef1 as userDef1,
						a.userDef2 as userDef2,
						a.userDef3 as userDef3,
						a.userDef4 as userDef4,
						a.userDef5 as userDef5,
						a.userDef6 as userDef6
						from LoadStops a 
	      				where a.LoadType = 1
						and a.StopNo =0	) as stops  on stops.loadid = l.loadid
						left outer join (select loadtype,loadid,stopno as finalstop,City AS consigneeCity,CustName as consigneeStopName,Address AS consigneeLocation,PostalCode AS consigneePostalCode,ContactPerson AS consigneeContactPerson,Phone AS consigneePhone,fax AS consigneeFax,EmailID AS consigneeEmailID,ReleaseNo AS consigneeReleaseNo,Blind AS consigneeBlind,Instructions AS consigneeInstructions,Directions AS consigneeDirections,LoadStopID AS consigneeLoadStopID,NewBookedWith AS consigneeBookedWith,NewEquipmentID AS consigneeEquipmentID,NewDriverName AS consigneeDriverName,NewDriverCell AS consigneeDriverCell,NewTruckNo AS consigneeTruckNo,NewTrailorNo AS consigneeTrailorNo,RefNo AS consigneeRefNo,Miles AS consigneeMiles,CustomerID AS consigneeCustomerID,statecode as consigneeState from loadstops) as finalconsignee on finalconsignee.loadid =l.loadid and finalconsignee.loadtype=2 and finalconsignee.finalstop = (select max(stopno) from loadstops where loadid=l.loadid)
						left outer join (SELECT [CarrierID],[CarrierName] FROM [Carriers]) as carr on carr.CarrierID = stops.NewCarrierID
						left outer join (SELECT [CarrierOfficeID],[Manager]  FROM [CarrierOffices]) as office on office.CarrierOfficeID = stops.NewOfficeID
						left outer join (SELECT [StatusTypeID] as stTypeId,[statusText],colorCode FROM [loadStatusTypes]) as loadStatus on loadStatus.stTypeId = l.StatusTypeID
						left outer join (SELECT [CustomerName],[CustomerID],[OFFICEID] FROM [Customers]) as cust on cust.CustomerID = l.PayerID
						left outer join (SELECT [StatusTypeID] as lststType,[StatusText] as lStatusText FROM [LoadStatusTypes]) as LStatusTypes on LStatusTypes.lststType = l.StatusTypeID
						left outer join (SELECT [Name] as empDispatch,[EmployeeID] FROM [Employees]) as Employees on Employees.EmployeeID =l.DispatcherID 	
						left outer join (SELECT [Name] as empAgent,[EmployeeID] FROM [Employees]) as Employees1 on Employees1.EmployeeID = l.SalesRepID
						left outer join (SELECT [EquipmentID],EquipmentName,Driver as EquipDriver FROM [Equipments]) as Equipments1 on Equipments1.EquipmentID = l.EquipmentID								
	      				where l.LoadID = l.LoadID	
					<cfif structkeyexists(session,"currentusertype") >
						<cfset variables.currentusertype = lcase(session.currentusertype) >
						
						<cfif variables.currentusertype eq "sales representative" AND structKeyExists(session, "empid" ) >
							and (SalesRepID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#"> or DispatcherID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#">) 
							and cust.officeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.officeid#"> 
						<cfelseif variables.currentusertype eq "dispatcher" or variables.currentusertype eq "manager">
							and cust.officeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.officeid#">
						<cfelseif structKeyExists(session, "isCustomer") AND session.isCustomer>
							and cust.CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.CustomerID#"> 
						</cfif>
		            </cfif>
					
		            <cfif isDefined("arguments.LoadStatus") and len(arguments.LoadStatus) gt 1>
		            and StatusTypeID='#arguments.LoadStatus#'
		            </cfif>
	                     <cfif isDefined("arguments.LoadNumber") and len(arguments.LoadNumber)>
	                      and l.LoadNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.LoadNumber)#">
	                     </cfif> 
	                    <cfif isDefined("arguments.CustomerPO") and len(arguments.CustomerPO)>
	                      and CustomerPONo like '%#arguments.CustomerPO#%'
	                    </cfif>					
						<cfif isDefined("arguments.shipperCity") and len(arguments.shipperCity)>
	                      and shipperCity like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.shipperCity#%">
	                    </cfif>					
						<cfif isDefined("arguments.consigneeCity") and len(arguments.consigneeCity)>
	                      and consigneeCity like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.consigneeCity#%">
	                    </cfif>					
	                    <cfif isDefined("arguments.ShipperState") and len(arguments.ShipperState)>
	                      and shipperState=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ShipperState#">
	                    </cfif>                                              
	                    <cfif isDefined("arguments.ConsigneeState") and len(arguments.ConsigneeState)>
	                      and consigneeState=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ConsigneeState#">
	                    </cfif>  
	                    <cfif isDefined("arguments.CustomerName") and len(arguments.CustomerName)>
	                      and CustomerName like '%#arguments.CustomerName#%'
	                    </cfif>  
	                    <cfif isDefined("arguments.CustomerName") and len(arguments.CustomerName)>
	                      and CustomerName like '%#arguments.CustomerName#%'
	                    </cfif>  
	                    <cfif isDefined("arguments.StartDate") and len(arguments.StartDate)>
	                      and NewPickupDate >=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.StartDate#">
	                    </cfif> 
	                    <cfif isDefined("arguments.EndDate") and len(arguments.EndDate)>
	                      and NewPickupDate <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.EndDate#">
	                    </cfif> 
	                    <cfif isDefined("arguments.CarrierName") and len(arguments.CarrierName)>
	                      and CarrierName like '%#arguments.CarrierName#%'
	                    </cfif> 
	                    <cfif isDefined("arguments.bol") and len(arguments.bol)>
	                      and BOLNum like '%#arguments.bol#%'
	                    </cfif> 					
	                    <cfif isDefined("arguments.dispatcher") and len(arguments.dispatcher)>
	                      and empDispatch like '%#arguments.dispatcher#%'
	                    </cfif> 
	                    <cfif isDefined("arguments.agent") and len(arguments.agent)>
	                      and empAgent like '%#arguments.agent#%'
	                    </cfif> 								
						<cfif isDefined("arguments.searchText") and len(arguments.searchText)>
						 and (
						 	   CustomerName like '%#arguments.searchText#%'
						 	   or CarrierName like '%#arguments.searchText#%'
						 	   or statusText like '%#arguments.searchText#%'
							   or LoadNumber like '%#arguments.searchText#%'
						 	   or CustomerPONo like '%#arguments.searchText#%'
						 	   or TotalCustomerCharges like '%#arguments.searchText#%'
						 	   or shipperState like '%#arguments.searchText#%'
						 	   or shipperCity like '%#arguments.searchText#%' 
						 	   or consigneeState like '%#arguments.searchText#%'
						 	   or consigneeCity like '%#arguments.searchText#%'
							   or BOLNum like '%#arguments.searchText#%'
							   or empDispatch like '%#arguments.searchText#%'
							   or empAgent like '%#arguments.searchText#%'
							   <cfif isValid("date",#arguments.searchText#) and counterForDatefinding>
							   		or NewPickupDate = '#DateFormat(arguments.searchText,'yyyy-mm-dd')#'
							   </cfif>
							   <cfif qryGetInvoiceNumberStatus.MinimumLoadInvoiceNumber neq 0>
								or invoiceNumber like '%#arguments.searchText#%'
							   </cfif>
							   <cfif qryGetInvoiceNumberStatus.MinimumLoadInvoiceNumber neq 0>
								or invoiceNumber like '%#arguments.searchText#%'
							   </cfif>
							   <cfif not qryGetFreightBrokerStatus.FreightBroker>
							   	or userDefinedFieldTrucking like '%#arguments.searchText#%'
							   </cfif>
						 	  )
						</cfif>
						 <cfif IsDefined('agentUsername') AND agentUsername NEQ ''>
							AND StatusTypeID IN (
								SELECT loadStatusTypeID
								FROM AgentsLoadTypes
								WHERE AgentID = (
									SELECT EmployeeID
									FROM Employees
									WHERE loginid = <cfqueryparam value="#agentUsername#" cfsqltype="cf_sql_varchar">
								)
							)
						</cfif>
	                    <cfif isDefined("arguments.Office") and len(arguments.Office)>
	                        AND NewOfficeID='#arguments.Office#'
	                    </cfif>
						<cfif arguments.pageNo neq -1>
	                         )
	                         SELECT * FROM page WHERE Row between (#arguments.pageNo# - 1) * #pageSize# + 1 and #arguments.pageNo# * #pageSize#
	                     </cfif>
	      		</cfquery>
	       <cfreturn qrygetload>    
	</cffunction>

	<!--- Check MC Number--->
	<cffunction name="checkMCNumber" access="remote" output="false" returntype="boolean">
	    <cfargument name="McNumber" required="no" type="any">
		<cfargument name="dsn" required="no" type="any">
		 
		 <cfquery name="checkMc" datasource="#arguments.dsn#">
	    	select * from carriers where MCNumber ='#arguments.McNumber#'
		 </cfquery>    
		 <cfif checkMc.recordcount gt 0>
		 	<cfreturn true>
		 <cfelse>
		 	<cfreturn false>
		 </cfif>               
	</cffunction>

	<!--- Check Agent Login--->
	<cffunction name="checkLoginId" access="remote" output="false" returntype="any">
	    <cfargument name="Loginid" required="no" type="any">
		<cfargument name="dsn" required="no" type="any">
		<cfargument name="empID" required="no" type="any">


		 <cfquery name="checkMc" datasource="#arguments.dsn#">
	    	select * from employees 
	    	where 1=1 AND loginid = '#arguments.Loginid#'
	    	-- <cfif NOT structKeyExists(arguments,"empID")>
	    	-- 	AND loginid = '#arguments.Loginid#'
	    	-- </cfif>
	    	<cfif structKeyExists(arguments,"empID")>
	    		AND EmployeeID != '#arguments.empID#' 
	    	</cfif>
		 </cfquery>    
		 <cfif checkMc.recordcount gt 0>
		 	<cfreturn true>
		 <cfelse>
		 	<cfreturn false>
		 </cfif>               
	</cffunction>

	<!--- get Bimdable Value Sattelite office--->
	<cffunction name="getSatelliteOfficeBindable" output="false" access="remote" returntype="array">
			<cfargument name="carrierid" type="any" required="yes">
			<cfargument name="dsn" type="any" required="yes">
			<cfset var dtResult = ArrayNew(2)>	
			<cfset carrierOfficeId ="">
			<cfset carrierOfficeLoacation = "">
			<cfset tempCarrOffId="">
			<cfset tempCarrOffLoc="">
				<cfquery name="getcarrieroffices" datasource="#arguments.dsn#">
					select * from carrieroffices  where location <> '' and carrierID='#arguments.carrierid#'
				</cfquery>
				<cfset tempCarrOffId="#valuelist(getcarrieroffices.CarrierOfficeID)#">
				<cfset tempCarrOffLoc="#valuelist(getcarrieroffices.location)#">
				<cfoutput query="getcarrieroffices">
					<cfset carrierOfficeId = ListAppend(carrierOfficeId,getcarrieroffices.CarrierOfficeID)>
					<cfset carrierOfficeLoacation = ListAppend(carrierOfficeLoacation,getcarrieroffices.location)>
				</cfoutput>
				<!--- Convert results to array --->
				<cfif listlen(tempCarrOffId) gt 0>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "Choose a Satellite Office Contact">
					<cfloop from="1" to="#listlen(tempCarrOffId)#" index="k">
						<cfset dtResult[k+1][1] = listgetat(tempCarrOffId,k)>
						<cfset dtResult[k+1][2] = "#listgetat(tempCarrOffLoc,k)#">
					</cfloop>
				<cfelse>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "Satellite office not available">
				</cfif>
				
			<cfreturn dtResult>
		</cffunction>
	                  
	    <!--- get AJAX Bindable Value Sattelite office--->
	<cffunction name="getAjaxSatelliteOfficeBindable" access="remote" output="yes" returnformat="json">
			<cfargument name="carrierid" type="any" required="yes">
			<cfargument name="dsn" type="any" required="yes">
			<cfset var dtResult = ArrayNew(2)>	
			<cfset carrierOfficeId ="">
			<cfset carrierOfficeLoacation = "">
			<cfset tempCarrOffId="">
			<cfset tempCarrOffLoc="">
				<cfquery name="getcarrieroffices" datasource="#arguments.dsn#">
					select * from carrieroffices  where location <> '' and carrierID='#arguments.carrierid#'
				</cfquery>
				<cfset tempCarrOffId="#valuelist(getcarrieroffices.CarrierOfficeID)#">
				<cfset tempCarrOffLoc="#valuelist(getcarrieroffices.location)#">
				<cfoutput query="getcarrieroffices">
					<cfset carrierOfficeId = ListAppend(carrierOfficeId,getcarrieroffices.CarrierOfficeID)>
					<cfset carrierOfficeLoacation = ListAppend(carrierOfficeLoacation,getcarrieroffices.location)>
				</cfoutput>
				<!--- Convert results to array --->
				<cfif listlen(tempCarrOffId) gt 0>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "Choose a Satellite Office Contact">
					<cfloop from="1" to="#listlen(tempCarrOffId)#" index="k">
						<cfset dtResult[k+1][1] = listgetat(tempCarrOffId,k)>
						<cfset dtResult[k+1][2] = "#listgetat(tempCarrOffLoc,k)#">
					</cfloop>
				<cfelse>
					<cfset dtResult[1][1] = "">
					<cfset dtResult[1][2] = "Satellite office not available">
				</cfif>
				
			<!---<cfreturn dtResult>--->
	        #SerializeJSON(dtResult)#
		</cffunction>
	<!---  Check MC Number for new carrier entry----------->

	<cffunction name="checkcarrierMCNumber" access="remote" output="false" returntype="query">
	    <cfargument name="McNumber" required="no" type="any">
	    <cfargument name="DotNumber" required="no" type="any">
		<cfargument name="dsn" required="no" type="any">
		 	<cfif structKeyExists(arguments, "McNumber")>
				 <cfquery name="checkMc" datasource="#arguments.dsn#">
			    	select * from carriers where MCNumber ='#arguments.McNumber#'
				 </cfquery> 
			<cfelseif structKeyExists(arguments, "DotNumber")>	 
				<cfquery name="checkMc" datasource="#arguments.dsn#">
			    	select * from carriers where DOTNumber =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DotNumber#">
				 </cfquery> 
			</cfif>	 
		<cfreturn checkMc>
		             
	</cffunction>


	<cffunction name="getLoadStopInfo" access="public" returntype="any">
	    <cfargument name="StopNo" required="yes" type="any">
		<cfargument name="LoadType" required="yes" type="any">
		<cfargument name="loadID" required="yes" type="any">
		 
		 <cftry>
			 <cfquery name="qGetLoadStopInfo" datasource="#variables.dsn#">
		    	SELECT 
					*
				FROM 
					LoadStops
				WHERE 
					loadID = <cfqueryparam value="#loadID#" cfsqltype="cf_sql_varchar"> AND 
					LoadType = <cfqueryparam value="#LoadType#" cfsqltype="cf_sql_tinyint"> AND 
					StopNo = <cfqueryparam value="#StopNo#" cfsqltype="cf_sql_integer">
			 </cfquery>   
			<cfcatch>
				<cfset qGetLoadStopInfo.recordcount = 0>
			</cfcatch>
		 </cftry> 
		<cfreturn qGetLoadStopInfo>
		             
	</cffunction>

	<!-----------Check whether the Customer data exist or not---------------->
	<cffunction name="customerDataCheck" access="remote" hint="Check whether the Customer data exist or not" returnformat="json" >
		<cfargument name="dsnName" type="string" required="true">
		<cfargument name="customerName" type="string" required="true">
		<cfargument name="customerAddress" type="string" required="true">
		<cfargument name="customerCity" type="string" required="true">
		<cfargument name="customerState" type="string" required="true">
		<cfargument name="customerZipCode" type="string" required="true">
		<cfquery name="dataExistenseCheck" datasource="#arguments.dsnName#" >
			select customerID,isPayer  from customers 
				where customerName COLLATE Latin1_General_CS_AS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.customerName)#">
				and location COLLATE Latin1_General_CS_AS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customerAddress#">
				and city COLLATE Latin1_General_CS_AS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customerCity#">
				<cfif arguments.customerState neq "">
					and statecode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customerState#">
				</cfif>
				and zipCode COLLATE Latin1_General_CS_AS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customerZipCode#">	
				and customerName <> null
		</cfquery>
		<cfset checkResultStruct = '|'&dataExistenseCheck.recordcount & '|'& dataExistenseCheck.customerID &'|'& dataExistenseCheck.isPayer &'|'>
		<cfreturn checkResultStruct>
	</cffunction>
	<cffunction name="getIsPayer" access="public" returntype="any">
	<cfargument name="loadID" type="string" required="true">
		<cfquery name="payerValue" datasource="#variables.dsn#">
			select c.isPayer 
			from Customers c
			inner join Loads l on c.CustomerID=l.payerID
			WHERE l.loadID = <cfqueryparam value="#loadID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn payerValue> 
	</cffunction>
	<cffunction name="getIsPayerStop" access="public" returntype="query">
		<cfargument name="customerID" type="string" required="true">
		<cfquery name="qGetIsPayer" datasource="#variables.dsn#">
			select isPayer 
			from Customers
			WHERE CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customerID#">
		</cfquery>
		<cfreturn qGetIsPayer>
	</cffunction>

	<cffunction name="getPayerStop" access="public" returntype="query">
		<cfargument name="stopID" type="string" required="true">
		<cfquery name="qGetPayer" datasource="#variables.dsn#">
			select isPayer 
			from Customers 
			where customerid = (select customerID from loadstops where LoadStopID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.stopID#">)
		</cfquery>
		<cfreturn qGetPayer>
	</cffunction>

	<cffunction name="getQueryofQuery" access="public" returntype="query" hint="Filter query based on condition">
		<cfargument name="queryStruct" type="query" required="true">
		<cfargument name="conditionValue" type="numeric" required="true">
		<cfargument name="statusTypeId" type="string">
		<cfargument name="boardDirection" type="string">
			
		<cfif conditionValue eq 1>
			<cfquery name="filterQuery" dbtype="query">
				SELECT DISTINCT statusText, statustypeid, colorCode
				FROM queryStruct
			</cfquery>
		<cfelseif conditionValue eq 2>
			<cfquery  name="filterQuery" dbtype="query">
				SELECT *
				FROM queryStruct
				WHERE loadStatusTypeID = <cfqueryparam value="#arguments.statusTypeId#" cfsqltype="cf_sql_varchar">
				AND queryStruct.dispatchBoardDirection = <cfqueryparam value="#arguments.boardDirection#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>	
		<cfreturn filterQuery>
	</cffunction>	


	<!-----------Get distinct shipper or consignee---------------->
	<cffunction name="GetShipperConsignee" access="public" hint="Check whether the Customer data exist or not" returnType = "any" >
		<cfargument name="loadid" type="string" required="true">
		<cfargument name="loadtype" type="string" required="true">
		
		<cfquery name="qryShipperConsignee" datasource="#variables.dsn#" >
			select loadstopid,custname,customerID,Address,city,statecode,postalcode,blind,phone,fax,ForBOL from LoadStops where LoadID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
			and loadtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadtype#">
		</cfquery>
		<cfreturn qryShipperConsignee>
	</cffunction>
		
		
	<cffunction name="AddBOLDetails" access="public" returntype="any">
	<cfargument name="frmstruct" type="struct" required="yes">		
		
		
		
		<cfset frmstruct.DeclaredValue = replace(frmstruct.DeclaredValue, ",", "", "all")> 
		
		<cfif arguments.frmstruct.DeclaredValue eq ''>				
			<cfset DeclaredValue = 0>
		<cfelse>
			<cfset findpos = find("$",arguments.frmstruct.DeclaredValue)>	
			<cfif findpos neq 0>
				 <cfset DeclaredValue = #Removechars(arguments.frmstruct.DeclaredValue, findpos, 1)# > 
			<cfelse>
				<cfset DeclaredValue = arguments.frmstruct.DeclaredValue>
			</cfif>
		</cfif>		
		
		<cfif arguments.frmstruct.CODAmount eq ''>				
			<cfset CODAmt = 0>
		<cfelse>
			<cfset findlen = find("$",arguments.frmstruct.CODAmount)>	
			<cfif findlen neq 0>
				 <cfset CODAmt = #Removechars(arguments.frmstruct.CODAmount, findlen, 1)# > 
			 <cfelse>
			 	<cfset CODAmt = arguments.frmstruct.CODAmount>
			</cfif>
		</cfif>	
				
		<cftransaction> 
			<cfquery name="updateLoads" datasource="#variables.dsn#">
				update loads set EmergencyResponseNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.EmergencyResponseNo#">,
					CODAmt = <cfqueryparam cfsqltype="cf_sql_money" value="#CODAmt#">,
					CODFee = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.CODFee#">,
					DeclaredValue = <cfqueryparam cfsqltype="cf_sql_money" value="#DeclaredValue#">,
					Notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.Notes#">
					where loadid = '#arguments.frmstruct.loadid#'
			</cfquery>
				
			<cfquery name="resetAllLoadstops" datasource="#variables.dsn#">	
				update loadstops set ForBOL = 0 where loadid = '#arguments.frmstruct.loadid#'
			</cfquery>	
			<cfparam name="variables.customeridlist" default="">		
			<cfset variables.customeridlist=listAppend(variables.customeridlist, "#arguments.frmstruct.consignee#")>
			<cfset variables.customeridlist=listAppend(variables.customeridlist, "#arguments.frmstruct.shipper#")>
			<cfquery name="updatecheckedShipperConsignee" datasource="#variables.dsn#">	
				update loadstops set ForBOL = 1 where loadid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.loadid#"> 
					<cfif len(trim(variables.customeridlist))>
					and customerId in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.customeridlist#" list="true">)
					</cfif>
			</cfquery>			
							
			<cfquery name="deleteExisting" DATASOURCE="#variables.dsn#">
				delete from LoadStopsBOL where LoadStopIDBOL =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.loadid#">
			</cfquery>
						
							
			<cfloop from="1" to="5" index="Num">
			     <cfset desc=evaluate("arguments.frmstruct.description#num#")>
				 <cfset hazmat=evaluate("arguments.frmstruct.hazmat#num#")>
				 <cfset class=evaluate("arguments.frmstruct.class#num#")>
				 <cfset weight=VAL(evaluate("arguments.frmstruct.weight#num#"))>
				 <cfset pieces=VAL(evaluate("arguments.frmstruct.pieces#num#"))>
				 <cfif desc neq '' or hazmat neq '' or weight neq ''>	
					 <CFSTOREDPROC PROCEDURE="USP_InsertLoadStopsBOL" DATASOURCE="#variables.dsn#"> 
						<CFPROCPARAM VALUE="#arguments.frmstruct.loadid#" cfsqltype="CF_SQL_VARCHAR">
					 	<CFPROCPARAM VALUE="#num#" cfsqltype="CF_SQL_VARCHAR">
					 	<CFPROCPARAM VALUE="#pieces#" cfsqltype="CF_SQL_float">	
					 	<CFPROCPARAM VALUE="#desc#" cfsqltype="CF_SQL_VARCHAR">
					 	<CFPROCPARAM VALUE="#weight#" cfsqltype="CF_SQL_float">	
					 	<CFPROCPARAM VALUE="#class#" cfsqltype="CF_SQL_VARCHAR">
					 	<CFPROCPARAM VALUE="#hazmat#" cfsqltype="CF_SQL_VARCHAR">	
					 	<CFPROCRESULT NAME="qInsertedLoadBOL">
					</cfstoredproc> 
				</cfif>		
			</cfloop>		
						
			<cfquery name="updateSystemConfig" datasource="#variables.dsn#">
				update SystemConfig set carrierTerms = '#arguments.frmstruct.terms#'
			</cfquery>		
				
		</cftransaction>

	</cffunction>
		
			
	<cffunction name="GetBOLDetails" access="public" returntype="any">			
		<cfargument name="loadid" type="string" required="yes">	
		
		<cfquery name="getLoadStopBol" datasource="#variables.dsn#">
			select * from LoadStopsBOL where loadStopIdBOL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
			order by SrNo
		</cfquery>	
		
		<cfreturn getLoadStopBol>	
	</cffunction>			

	<cffunction name="getBolterms" access="public" returntype="any">

		<cfquery name="getCarrierTerms" datasource="#variables.dsn#">
			select carrierTerms from systemconfig
		</cfquery>		
			
		<cfreturn getCarrierTerms>	
	</cffunction>	

	<cffunction name="getAttachedFiles" access="public" returntype="query">
		<cfargument name="linkedid" type="string">
		<cfargument name="fileType" type="string">

		<cfquery name="getFilesAttached" datasource="#variables.dsn#">
			select * from FileAttachments where linked_id='#linkedid#' and linked_to='#filetype#'
		</cfquery>		
			
		<cfreturn getFilesAttached>	
	</cffunction>
	<!-----------get count for add/editload page-------->

	<cffunction name="getloadAttachedFiles" access="public" returntype="query">
		<cfargument name="linkedid" type="string">
		<cfargument name="fileType" type="string">

		<cfquery name="getFilesAttached" datasource="#variables.dsn#">
			select count(*) as recunt from FileAttachments where linked_id='#linkedid#' and linked_to='#filetype#'
		</cfquery>		
			
		<cfreturn getFilesAttached>	
	</cffunction>
	<!--- Delete Files--->
	<cffunction name="deleteAttachments" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="fileId" type="string" required="yes" />
		 <cfargument name="fileName" required="yes" type="string">
		<cfargument name="dsnName" required="yes" type="string"> 
		<cfargument name="newFlag" required="yes" type="numeric"> 
		

		<cfset fileString = "#expandPath('../fileupload/img/#arguments.fileName#')#">
		

		 <!---<cftry>---->
				<cfif arguments.newFlag eq 0>
					<cfquery name="deleteItems" datasource="#arguments.dsnName#">
						delete from FileAttachments where attachment_Id = '#arguments.fileId#'
					</cfquery>
				<cfelse>
					<cfquery name="deleteItems" datasource="#arguments.dsnName#">
						delete from FileAttachmentsTemp where attachment_Id = '#arguments.fileId#'
					</cfquery>
				</cfif>
				<!--- need to add code to remove the file from the directory aswell --->
				<cfif fileexists(fileString)>
					<cffile action="delete" file="#fileString#">
				</cfif>	
			     <cfreturn true> 
			<!--- <cfcatch type="any">
				 <cfreturn cfcatch.Detail> 
			</cfcatch>
		</cftry>--->
	</cffunction>

	<!--- Link attachments --->
	<cffunction name="linkAttachments">	
		<cfargument name="tempLoadId" type="string" required="yes" />
		<cfargument name="permLoadId" type="string" required="yes" />
		
		<cfquery name="retriveFromTemp" datasource="#application.dsn#">
			select * from fileattachmentstemp where linked_id ='#tempLoadId#';
		</cfquery>
		<cfquery name="qSystemSetupOptions" datasource="#application.dsn#">
			SELECT numberAttachments
			FROM SystemConfig
		</cfquery>
		<cfset flagFile = 0>
		
		<cfif retriveFromTemp.recordcount>
			<cfloop query="retriveFromTemp">
				<cfquery name="insertFilesUploaded" datasource="#application.dsn#" result="insertedId">
					insert into FileAttachments(linked_Id,linked_to,attachedFileLabel,attachmentFileName,uploadedBy,Billingattachments)
					values('#permLoadId#','#retriveFromTemp.linked_to#','#retriveFromTemp.attachedFileLabel#','#retriveFromTemp.attachmentFileName#','#retriveFromTemp.uploadedBy#',<cfqueryparam cfsqltype="cf_sql_bit" value="#retriveFromTemp.Billingattachments#" >)
				</cfquery>
				
				<cfif qSystemSetupOptions.numberAttachments eq true>
					
					
					<cfset variables.attachnumber=1>
					<cfif isnumeric(insertedId.GENERATEDKEY)>
						<cfset variables.attachnumber=insertedId.GENERATEDKEY>
					</cfif>
					
					<cfset variables.listlength=listlen(retriveFromTemp.attachmentFileName,'.')>
					<cfset listposition=2>
					<cfif isnumeric(variables.listlength)>
						<cfset listposition=val(variables.listlength)-1>
					</cfif>	
					<cfset variables.filenametempSecondLast=ListGetAt(retriveFromTemp.attachmentFileName, listposition,'.')>
					<cfset variables.filenameEdited1=Replace(retriveFromTemp.attachmentFileName, '#variables.filenametempSecondLast#', '#variables.attachnumber#' ,'.')>
				
					<CFSET UploadDir = "#expandPath('../fileupload/img/')#">
					<cfif not directoryExists(UploadDir)>
						<cfdirectory action="create" directory="#UploadDir#">
					</cfif>
					<cffile  action = "rename" destination = "#UploadDir##variables.filenameEdited1#"  source = "#UploadDir##retriveFromTemp.attachmentFileName#">
					<cfquery name="qryUpdate" datasource="#application.dsn#">
						update FileAttachments
						set attachmentFileName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.filenameEdited1#">
						where attachment_Id=<cfqueryparam cfsqltype="cf_sql_integer" value="#variables.attachnumber#">
					</cfquery>	
				</cfif>
			</cfloop>	
			<cfset flagFile =1>
		</cfif>	
		<cfif flagFile eq 1>
			<cfquery name="deleteTempFiles" datasource="#application.dsn#">
				delete from fileattachmentstemp where linked_id = '#tempLoadId#'
			</cfquery>
			
		</cfif>

	</cffunction>


	<!--- Function to avoid special characters that causing errors with webservice ---> 
	<cffunction name="escapeSpecialCharacters" access="public" returntype="String" >
		<cfargument name="filterString" required="true" type="string">
		
		<cfreturn replace(arguments.filterString, "&", "&amp;","ALL")>
	</cffunction>

	<!--- Function to get LoadStop Intermodal Import ---> 
	<cffunction name="getLoadStopIntermodalImport" access="public" returntype="query" >
		<cfargument name="loadstopid" default="">
		<cfquery name="qLoadStopIntermodalImport" datasource="#application.dsn#">
			select * from LoadStopIntermodalImport 
			where 
				loadstopid = <cfqueryparam value="#arguments.loadstopid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		<cfreturn qLoadStopIntermodalImport>
	</cffunction>

	<!--- Function to get LoadStop Intermodal Export ---> 
	<cffunction name="getLoadStopIntermodalExport" access="public" returntype="query" >
		<cfargument name="loadstopid" default="">
		<cfquery name="qLoadStopIntermodalExport" datasource="#application.dsn#">
			select * from LoadStopIntermodalExport
			where 
				loadstopid = <cfqueryparam value="#arguments.loadstopid#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		<cfreturn qLoadStopIntermodalExport>
	</cffunction>

	<!--- Function to add log for mails on Reports--->
	<cffunction name="setLogMails" access="public">
		<cfargument name="loadID" required="yes" type="string">
		<cfargument name="date" required="yes" type="string">
		<cfargument name="subject" required="yes" type="string">
		<cfargument name="emailBody" required="yes" type="string">
		<cfargument name="reportType" required="yes" type="string">
		<cfargument name="fromAddress" required="yes" type="string">
		<cfargument name="toAddress" required="yes" type="string">
		
		<cfset loadNo = "n/a" >
		<cfif arguments.loadID neq "n/a">
			<cfquery name="qryGetLoadNumber" datasource="#application.dsn#">
				SELECT LoadNumber FROM Loads WHERE LoadID = <cfqueryparam value="#arguments.loadID#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfset loadNo = qryGetLoadNumber.LoadNumber>
		</cfif>
			
		<cfquery name="qrySetEmailLog" datasource="#application.dsn#" result="qResult">
			INSERT INTO EmailLogs(loadID,loadno,date,subject,emailBody,reportType,createDate,fromAddress,toAddress)
			VALUES(
		    <cfqueryparam value="#arguments.loadID#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#loadNo#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_timestamp">,
		    <cfqueryparam value="#arguments.subject#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#arguments.emailBody#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#arguments.reportType#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" >,
		    <cfqueryparam value="#arguments.fromAddress#" cfsqltype="cf_sql_varchar">,
		    <cfqueryparam value="#arguments.toAddress#" cfsqltype="cf_sql_varchar">)
		</cfquery>
	</cffunction>

	<cffunction name="getCompanyInformation" access="remote" returntype="query">
		<cfargument name="dsn" type="any" required="no"/>
	    <cfif isdefined('dsn')>
	    	<cfset activedns = dsn>
	    <cfelse>
	    	<cfset activedns = variables.dsn>
	    </cfif>
		<cfquery name="qGetCompanyInformation" datasource="#activedns#">
	    	SELECT companyName, address, address2, city, state, zipCode, companyID,email,ccOnEmails,email
	        FROM companies
	    </cfquery>	
	    <cfreturn qGetCompanyInformation>
	</cffunction>

	<!---function to update companydetails--->
	<cffunction name="setCompanyInformationUpdate" access="public" returntype="string">
		<cfargument name="companyName" type="string" required="yes"/>
		<cfargument name="emailId" type="string" required="yes"/>
		<cfargument name="ccOnEmails" type="string" required="yes"/>
		<cfargument name="address" type="string" required="yes"/>
		<cfargument name="address2" type="string" required="yes"/>
		<cfargument name="city" type="string" required="yes"/>
		<cfargument name="zipCode" type="string" required="yes"/>
		<cfargument name="state" type="string" required="yes"/>
		
		<!---Query  to update companydetails--->
		<cfquery name="qrySetCompanyInformationUpdate" datasource="#Application.dsn#" result="qResult">
			SET NOCOUNT ON
			UPDATE Companies
			SET CompanyName = <cfqueryparam value="#arguments.companyName#" cfsqltype="cf_sql_varchar">,
		    email = <cfqueryparam value="#arguments.emailId#" cfsqltype="cf_sql_varchar">,
		    ccOnEmails = <cfqueryparam value="#arguments.ccOnEmails#" cfsqltype="cf_sql_bit">,
		    address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
			address2 = <cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar">,
			city = <cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
			zipCode = <cfqueryparam value="#arguments.zipCode#" cfsqltype="cf_sql_varchar">,
			state = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
			SELECT @@ROWCOUNT as updatedRows
			SET NOCOUNT OFF
		</cfquery>
		
		<cfreturn qrySetCompanyInformationUpdate.updatedRows>
	</cffunction>
	<cffunction name="loadBoardFlagStatus" access="public" returntype="query">
		<cfargument name="loadid" required="yes"/>
		<cfquery name="getLoads" datasource="#Application.dsn#">
			select loadnumber from Loads where loadid= <cfqueryparam value="#arguments.loadid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery name="LoadboardInsertTOEveryWhereCount" datasource="#Application.dsn#">
			select * from LoadPostEverywhereDetails where imprtref= <cfqueryparam value="#getLoads.loadnumber#" cfsqltype="cf_sql_integer"> and From_web=<cfqueryparam value="123LoadBoard" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn LoadboardInsertTOEveryWhereCount>
	</cffunction>

	<cffunction name="rememberSearchSession" access="remote" returnformat="plain" output="false">
		<cfargument name="isChecked" default="true">
		<cfargument name="searchText" default="">
		<cfif arguments.isChecked>		
			<cfset session.searchtext = '#arguments.searchText#'>
		<cfelse>
			<cfset session.searchtext = ''>
		</cfif>
		<cfset variables.sessionvalue=session.searchtext>
		
		<cfreturn variables.sessionvalue>
	</cffunction>

	<!---function to checkEditLoadId Exists--->
	<cffunction name="checkEditLoadIdExists" access="public" returntype="query">
		<cfargument name="loadid" required="yes"/>
		<cfquery name="qryGetUserEditLoad" datasource="#Application.dsn#">
			select user_id from UserEditingLoads
			where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
		</cfquery>
		<cfif structkeyexists (session,"empid")>			
			<cfif Session.empid neq "" >
				<cfset variables.userId=session.empid>
			</cfif>
		</cfif>	
		<cfif structkeyexists (session,"customerid")>			
			<cfif Session.customerid neq "" >
				<cfset variables.userId=session.customerid>
			</cfif>
		</cfif>	
		<cfif qryGetUserEditLoad.user_id eq variables.userId>
			<cfquery name="qryGetUserEditLoadforRefresh" datasource="#Application.dsn#">
				select user_id from UserEditingLoads
				where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
				AND user_id !=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.userId#">
			</cfquery>
			<cfreturn qryGetUserEditLoadforRefresh>
		<cfelse>
			<cfreturn qryGetUserEditLoad>
		</cfif>	
		
	</cffunction>
	<!---function to insert or update UserEditingLoads--->
	<cffunction name="insertUserEditingLoad" access="public" >
		<cfargument name="loadid" required="yes"/>
			<cfif structkeyexists (session,"empid")>		
				<cfif Session.empid neq "">
					<cfquery name="qryGetUsername" datasource="#application.dsn#">
						select name from Employees where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#">
					</cfquery>
					<cfquery name="qryGetLoadEdit" datasource="#application.dsn#">
						select * from UserEditingLoads 
						where 
							LoadId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
						and 
							user_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#">
					</cfquery>
					<cfif qryGetLoadEdit.recordcount and qryGetUsername.recordcount>
						<cfquery name="qryUpdateuserEdit" datasource="#Application.dsn#">
							update UserEditingLoads
							set 
								DateCreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
							where 
								LoadId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
							and 
								user_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#">
						</cfquery>
					<cfelse>
						<cfquery name="qryInsertUserEdit" datasource="#Application.dsn#">
							insert into UserEditingLoads(Username,LoadId,DateCreated,user_id)
								VALUES(
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetUsername.name#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#">
								) 
						</cfquery>
					</cfif>
				</cfif>
			</cfif>		
			<cfif structkeyexists (session,"customerid")>
				<cfif Session.customerid neq "">	
					<cfquery name="qryGetUsername" datasource="#application.dsn#">
						select CustomerName from Customers where CustomerID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.customerid#">
					</cfquery>
					<cfquery name="qryGetLoadEdit" datasource="#application.dsn#">
						select * from UserEditingLoads 
						where 
							LoadId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
						and 
							user_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.customerid#">
					</cfquery>
					<cfif qryGetLoadEdit.recordcount and qryGetUsername.recordcount>
						<cfquery name="qryUpdateuserEdit" datasource="#Application.dsn#">
							update UserEditingLoads
							set 
								DateCreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
							where 
								LoadId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
							and 
								user_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.customerid#">
						</cfquery>
					<cfelse>
						<cfquery name="qryInsertUserEdit" datasource="#Application.dsn#">
							insert into UserEditingLoads(Username,LoadId,DateCreated,user_id)
								VALUES(
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetUsername.CustomerName#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.customerid#">
								) 
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
	</cffunction>

	<!---function to checkEditLoadId Exists--->
	<cffunction name="stopInterChanging" access="remote" returntype="any" returnformat="plain">
		<cfargument name="loadid" required="yes" type="string"/>
		<cfargument name="dsn" required="yes" type="string"/>
		<cfargument name="action" required="yes" type="string"/>
		<cfargument name="stopNumber" required="yes" type="numeric"/>
		<cfquery name="qryGetLoadStops" datasource="#arguments.dsn#">
			select LoadID,StopNo,Loadtype from loadstops where LoadID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
			order by StopNo ASC,Loadtype ASC
		</cfquery>
		<cfif qryGetLoadStops.recordcount>
			<cfloop query="qryGetLoadStops">
				<cfquery name="qryGetLoadStopsUpdate" datasource="#arguments.dsn#">
					update  loadstops set 
					previous_StopNo=<cfqueryparam cfsqltype="cf_sql_integer" value="#qryGetLoadStops.StopNo#">	
					where LoadID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetLoadStops.loadid#">
					and StopNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetLoadStops.StopNo#">
				</cfquery>	 
			</cfloop>	
		</cfif>
		<cftransaction>
			<cfif len(trim(arguments.stopNumber)) and isNumeric(arguments.stopNumber)>	
				<cfif arguments.action eq 'down'>
					<cfquery name="qryUpadteLoadStopOnly" datasource="#arguments.dsn#" result="s">
						update  loadstops set 
						StopNo=<cfqueryparam cfsqltype="cf_sql_integer" value="#(arguments.stopNumber+1)#">	
						where LoadID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
						and previous_StopNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.stopNumber#">
					</cfquery>
					<cfquery name="qryUpdateLoadNextStopOnly" datasource="#arguments.dsn#" result="s">
						update loadstops set 
						StopNo=<cfqueryparam cfsqltype="cf_sql_integer" value="#(arguments.stopNumber)#">	
						where LoadID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
						and previous_StopNo=<cfqueryparam cfsqltype="cf_sql_integer" value="#(arguments.stopNumber+1)#">
					</cfquery>
				<cfelseif arguments.action eq 'up'>
					<cfquery name="qryUpadteLoadStopOnly" datasource="#arguments.dsn#" result="s">
						update  loadstops set 
						StopNo=<cfqueryparam cfsqltype="cf_sql_integer" value="#(arguments.stopNumber-1)#">	
						where LoadID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
						and previous_StopNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.stopNumber#">
					</cfquery>
					<cfquery name="qryUpdateLoadPrevStopOnly" datasource="#arguments.dsn#" result="s">
						update  loadstops set 
						StopNo=<cfqueryparam cfsqltype="cf_sql_integer" value="#(arguments.stopNumber)#">	
						where LoadID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
						and previous_StopNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#(arguments.stopNumber-1)#">
					</cfquery>	
					
				</cfif>	
			</cfif>
		</cftransaction>	
		<cfreturn 1 >
	</cffunction>
		<!---function to get advance paymentdetails--->
	<cffunction name="getAdvancepaymentDetails" access="public" returntype="query">
		<cfargument name="loadid" required="yes" type="string"/>
		<cfquery name="qryGetSalesRepCommissionCarrierPay" datasource="#application.dsn#" >
			select * from vwSalesRepCommissionCarrierPay where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
		</cfquery>	
		<cfreturn qryGetSalesRepCommissionCarrierPay>
	</cffunction>

	<cffunction name="updateLoadUserDef" access="remote" returntype="any">
		<cfargument name="loadid" required="yes" type="string"/>
		<cfargument name="loadstopid" required="yes" type="string"/>
		<cfargument name="fieldname" required="yes" type="string"/>
		<cfargument name="fieldValue" required="yes" type="string"/>
		<cfargument name="dsn" type="string" required="yes" />	
		<cfset local.returnValue = false>
	
		<cfquery name="qUpdateLoadUserDef" datasource="#arguments.dsn#" result="qUpdateLoadUserDefResult">
			UPDATE LoadStops
			SET #arguments.fieldname# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldValue#">
			where loadId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
			and LoadStopID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadstopid#">
		</cfquery>
		<cfif qUpdateLoadUserDefResult.recordcount>
			<cfset local.returnValue = true>
		</cfif>
		<cfreturn local.returnValue>
	</cffunction>
	
	<cffunction name="updateLoadDispatchNote" access="remote" returntype="any">
		<cfargument name="loadid" required="yes" type="string"/>
		<cfargument name="dispatchNote" required="yes" type="string"/>
		<cfargument name="dsn" type="string" required="yes" />	
		<cfset local.returnValue = false>
	
		<cfquery name="qUpdateLoadDispatchNote" datasource="#arguments.dsn#" result="qUpdateLoadDispatchNote">
			UPDATE LOADS
			SET NEWDISPATCHNOTES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dispatchNote#">
			where loadId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">			
		</cfquery>
		<cfif qUpdateLoadDispatchNote.recordcount>
			<cfset local.returnValue = true>
		</cfif>
		<cfreturn local.returnValue>
	</cffunction>
	
	<!---function to update the userid for corresponding loads--->
	<cffunction name="updateEditingUserId" access="public" returntype="void">
		<cfargument name="userid" type="string" required="yes"/>
		<cfargument name="loadid" type="string" required="yes"/>
		<cfargument name="status" type="boolean" required="yes"/>
		<cfif  arguments.status>
			<!---Query to update the userid for corresponding loads to null--->
			<cfquery name="qryUpdateEditingUserId" datasource="#Application.dsn#" result="result">
				UPDATE LoadS
				SET 
				InUseBy=null,
				InUseOn=null,
				sessionid=null
				where InUseBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
			</cfquery>
			<!---cfdump var="#result#"--->
		<cfelse>
			<!---Query to update the userid for corresponding loads--->
			<cfquery name="qryUpdateEditingUserId" datasource="#Application.dsn#" result="result">
				UPDATE LoadS
				SET 
				InUseBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">,
				InUseOn=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				sessionid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sessionid#">
				where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
			</cfquery>
			<!---cfdump var="#result#"--->
		</cfif>	
	</cffunction>
	<!---function to get the user editing details for corresponding loads--->
	<cffunction name="getUserEditingDetails" access="public" returntype="query">
		<cfargument name="loadid" type="string" required="yes"/>
		<!---Query to get the user editing details for corresponding loads--->
		<cfquery name="qryUpdateEditingUserId" datasource="#Application.dsn#">
			select  InUseBy,InUseOn from loads
			where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
		</cfquery>
		<cfreturn qryUpdateEditingUserId>
	</cffunction>
	<!---function to update the userid for corresponding loads--->
	<cffunction name="removeUserAccessOnLoad" access="remote" returntype="struct" returnformat="json">
		<cfargument name="dsn" type="string" required="yes"/>
		<cfargument name="loadid" type="string" required="yes"/>
			<cfset var loads=StructNew()>
			<!---Query to get the userid--->
			<cfquery name="qryGetUserId" datasource="#arguments.dsn#" result="result">
				select InUseBy,InUseOn,loadnumber from LoadS where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
			</cfquery>
			<!---Query to get editing User Name--->
			<cfquery name="qryGetUserName" datasource="#arguments.dsn#" result="result">
				SELECT NAME
				FROM employees
				WHERE employeeID = <cfqueryparam value="#qryGetUserId.inuseby#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset loads.userName=qryGetUserName.NAME>
			<cfset loads.loadnumber=qryGetUserId.loadnumber>
			<cfset loads.onDateTime=dateformat(qryGetUserId.InUseOn,"mm/dd/yy hh:mm:ss")>
			<cfset loads.dsn=arguments.dsn>
			<!---Query to update the userid for corresponding loads to null--->
			<cfquery name="qryUpdateEditingUserId" datasource="#arguments.dsn#" result="result">
				UPDATE LoadS
				SET 
				InUseBy=null,
				InUseOn=null
				where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.loadid#">
			</cfquery>
			<cfreturn loads>
	</cffunction>		
	
	<!--- GetChangedCarriers--->
	<cffunction name="GetChangedCarriers" access="public"  returntype="any">				
		<cfset msg =  "">
		<cfset risk_assessment = "">
		<cfquery name="qSystemSetupOptions" datasource="#variables.dsn#">
	    	SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey,SaferWatchUpdateCarrierInfo,SaferWatchCarrierUpdatedDate
			FROM SystemConfig
	    </cfquery>
		<cfif qSystemSetupOptions.SaferWatch EQ 1 AND  qSystemSetupOptions.SaferWatchUpdateCarrierInfo EQ  1 AND qSystemSetupOptions.SaferWatchCarrierUpdatedDate NEQ Dateformat(now()-1,'yyyy-mm-dd')>			
			<cftry>
				<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=GetChangedCarriers&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&pageIndex=BEGIN&fromDate=#Dateformat(qSystemSetupOptions.SaferWatchCarrierUpdatedDate,'yyyy-mm-dd')#&fromTime=00:00:00&toDate=#Dateformat(now()-1,'yyyy-mm-dd')#&toTime=00:00:00" method="get" >
				</cfhttp>	
				<cfif cfhttp.Statuscode EQ '200 OK'>	
					<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>							
					<cfloop from="1" to="#ArrayLen(variables.resStruct.CarrierList.CarrierDetails)#" index="i">				
							<cfset McNumber = right(variables.resStruct.CarrierList.CarrierDetails[i].docketNumber,len(variables.resStruct.CarrierList.CarrierDetails[i].docketNumber)-2)>
							<cfset dotNumber = variables.resStruct.CarrierList.CarrierDetails[i].dotNumber>
							<cfquery name="qrygetFilterCarriers" datasource="#Application.dsn#">
								SELECT MCNumber,DOTNumber,car.CarrierID
								FROM Carriers car
									LEFT  JOIN lipublicfmcsa li 	ON car.CarrierID=li.carrierId
								WHERE  car.MCNumber='#McNumber#'
								AND  car.DOTNumber= #dotNumber#
							</cfquery >
							
							<cfif valueList(qrygetFilterCarriers.CarrierID) NEQ "">
								<cfquery name="qryupdate" datasource="#Application.dsn#">				
											UPDATE Carriers 
											SET 
											CarrierName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.legalName#">,
											Address=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.businessStreet#">,
											StateCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.businessState#">,
											Zipcode=   <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.businessZipCode#">,	
											country	=   <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.businessCountry#">,											
											LastModifiedBy= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
											LastModifiedDateTime=<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
											City= <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.businessCity#">,
											Phone=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.businessPhone#">,
											Fax=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.businessFax#">,
											Cel=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.cellPhone#">,
											EmailID=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].Identity.emailAddress#">,				
											DOTNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#dotNumber#">			
											,MCNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#McNumber#">
											,RiskAssessment =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.resStruct.CarrierList.CarrierDetails[i].RiskAssessment.Overall#">
											,SaferWatch = 1
											WHERE  CarrierID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes"  value="#valueList(qrygetFilterCarriers.CarrierID)#">)	
								</cfquery >
							</cfif>													
						</cfloop>					
							<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=AddChangedCarriers&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&pageIndex=BEGIN&fromDate=#Dateformat(now()-3,'yyyy-mm-dd')#&fromTime=00:00:00&toDate=#Dateformat(now()-1,'yyyy-mm-dd')#&toTime=00:00:00" method="get" >
							</cfhttp>
						<cfset msg = "Changed carriers details updated successfully.">
						<cfquery name="qryupdateCarrierUpdateDate" datasource="#Application.dsn#">
							UPDATE SystemConfig SET SaferWatchCarrierUpdatedDate = '#Dateformat(now()-1,'yyyy-mm-dd')#'
						</cfquery >						
				<cfelse>
					<cfset msg =  "">
				</cfif>	
			<cfcatch>
				<cfset msg =  "Cannot Update changed carriers details.">
			</cfcatch>				
			</cftry>					
		</cfif>
		<cfif qSystemSetupOptions.SaferWatch EQ 1 >
			<cfquery name="qryCarrier" datasource="#Application.dsn#">
				SELECT *  FROM   Carriers
			</cfquery >
			<cfloop query="qryCarrier">
				<cfif qryCarrier.RiskAssessment EQ "">
					<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=CarrierLookup&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=MC#qryCarrier.MCNumber#" method="get" >
					</cfhttp>	
					<cfif cfhttp.Statuscode EQ '200 OK'>	
						<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>
						<cfif structKeyExists(variables.resStruct ,"CarrierDetails") AND variables.resStruct.CarrierDetails.dotNumber EQ  qryCarrier.DOTNumber AND variables.resStruct.CarrierDetails.docketNumber EQ "MC"&qryCarrier.MCNumber AND structKeyExists(variables.resStruct .CarrierDetails,"RiskAssessment") AND structKeyExists(variables.resStruct .CarrierDetails.RiskAssessment,"Overall")  >
							<cfset risk_assessment = variables.resStruct .CarrierDetails.RiskAssessment.Overall>
						</cfif>			
					</cfif>		
					<cfquery name="qryupdate" datasource="#Application.dsn#">				
							UPDATE Carriers 
							SET RiskAssessment = '#risk_assessment#'
							WHERE  CarrierID='#qryCarrier.carrierID#'		
					</cfquery >
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn msg >
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
	
	<cffunction name="UpdateCarrier" access="public" output="false" returntype="any">
		<cfargument name="formStruct" type="struct" required="yes">
		<cfquery name="qSystemSetupOptions" datasource="#Application.dsn#">
			SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey,FreightBroker,SaferWatchUpdateCarrierInfo
			FROM SystemConfig
	</cfquery>
		<cfif trim(arguments.formStruct.carrierID) NEQ ""  AND qSystemSetupOptions.SaferWatch EQ 1 AND qSystemSetupOptions.FreightBroker  EQ 1 AND SaferWatchUpdateCarrierInfo EQ 1>
			<cfquery name="qrygetFilterCarriers" datasource="#Application.dsn#">
				SELECT MCNumber,DOTNumber
				FROM Carriers car
					LEFT  JOIN lipublicfmcsa li 	ON car.CarrierID=li.carrierId
				WHERE  car.CarrierID='#arguments.formStruct.carrierID#'
			</cfquery >
			<cfif  qrygetFilterCarriers.DOTNumber NEQ "">
				 <cfset number = qrygetFilterCarriers.DOTNumber>
			<cfelseif  qrygetFilterCarriers.MCNumber NEQ ""  >
				<cfset number = "MC"&qrygetFilterCarriers.MCNumber >
			<cfelse>
				<cfset number = 0 >
			</cfif>
			<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=CarrierLookup&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
			</cfhttp> 
			
			<cfif cfhttp.Statuscode EQ '200 OK'>	
				<cfset variables.responsestatus = structNew()>		
				<cfset variables.responsestatus = ConvertXmlToStruct(cfhttp.Filecontent, StructNew()) >
				<cfif  variables.responsestatus.ResponseDO.action EQ "OK" AND structKeyExists(variables.responsestatus,"CarrierDetails")>
					<cfquery name="qryupdate" datasource="#Application.dsn#">				
								UPDATE Carriers 
								SET 
								CarrierName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.legalName#">,
								Address=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.businessStreet#">,
								StateCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.businessState#">,
								Zipcode=   <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.businessZipCode#">,				
								LastModifiedBy= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
								LastModifiedDateTime=<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
								City= <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.businessCity#">,
								Phone=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.businessPhone#">,
								Fax=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.businessFax#">,
								Cel=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.cellPhone#">,
								EmailID=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.Identity.emailAddress#">,				
								DOTNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.dotNumber #" null="#not len(variables.responsestatus.CarrierDetails.dotNumber )#">			
								,MCNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#right(variables.responsestatus.CarrierDetails.docketNumber,len(variables.responsestatus.CarrierDetails.docketNumber)-2)#">
								,RiskAssessment =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.responsestatus.CarrierDetails.RiskAssessment.Overall#">
								,SaferWatch = 1
								WHERE  CarrierID='#arguments.formStruct.carrierID#'		
					</cfquery >
				</cfif>
			</cfif>
			<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=AddWatch&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
			</cfhttp>
		</cfif>
	</cffunction>
</cfcomponent>