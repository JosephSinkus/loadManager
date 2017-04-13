<cfcomponent output="true" extends="loadgateway">
<cfsetting showdebugoutput="true">
<cfif not structKeyExists(variables,"loadgatewayUpdate")>
	<cfscript>variables.objLoadgatewayUpdate = #request.cfcpath#&".loadgatewayUpdate";</cfscript>
</cfif>
<cfif not structKeyExists(variables,"objPromilesGateway")>
	<cfscript>variables.objPromilesGateway = #request.cfcpath#&".promile";</cfscript>
</cfif>
<cfif not structKeyExists(variables,"objPromilesGatewayTest")>
	<cfscript>variables.objPromilesGatewayTest = #request.cfcpath#&".promiles";</cfscript>
</cfif>

<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>

				
<!--- add load---> 
<cffunction name="addLoad" access="public" returntype="any">
		<cfargument name="frmstruct" type="struct" required="yes">
		<cfinvoke method="getLoadStatus" returnvariable="request.qLoadStatus" />
		<cfif isdefined('arguments.frmstruct.weightStop1') and  arguments.frmstruct.weightStop1 neq "">
			<cfif isnumeric(arguments.frmstruct.weightStop1)>
				<cfset variables.weight=arguments.frmstruct.weightStop1>
			<cfelse>
				<cfset variables.weight=0>
			</cfif>	
		<cfelse>	
			<cfset variables.weight=0>
		</cfif>	
		<cfif isdefined('arguments.frmstruct.posttoloadboard')>
			<cfset posttoloadboard=True>
		<cfelse>
			<cfset posttoloadboard=False>
		</cfif>
		<cfset posttoTranscore=False><!--- Making default value to 0. If the post is success, then it will updated to 1 later. --->
		<cfif isdefined('arguments.frmstruct.PostTo123LoadBoard')>
			<cfset PostTo123LoadBoard=True>
		<cfelse>
			<cfset PostTo123LoadBoard=False>
		</cfif>
		<cfif isdefined('arguments.frmstruct.ARExported')><cfset ARExported="1"><cfelse><cfset ARExported="0">d</cfif>
		<cfif isdefined('arguments.frmstruct.APExported')><cfset APExported="1"><cfelse><cfset APExported="0"></cfif>
		<cfif isdefined('arguments.frmstruct.shipBlind')><cfset shipBlind=True><cfelse><cfset shipBlind=False></cfif>
		<cfif isdefined('arguments.frmstruct.ConsBlind')><cfset ConsBlind=True><cfelse><cfset ConsBlind=False></cfif>
		<cfset custRatePerMile = ReplaceNoCase(arguments.frmstruct.CustomerRatePerMile,'$','','ALL')>
		<cfset custRatePerMile = ReplaceNoCase(custRatePerMile,',','','ALL')>
		<cfset carRatePerMile = ReplaceNoCase(arguments.frmstruct.CarrierRatePerMile,'$','','ALL')>
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
		<cftransaction>
			<cfquery name="getloadmanual" datasource="#variables.dsn#">
				SELECT MinimumLoadInvoiceNumber FROM SystemConfig
			</cfquery>
			<cfif getloadmanual.MinimumLoadInvoiceNumber NEQ 0>	
				<cfquery name="getloadmanual" datasource="#variables.dsn#">
					SELECT (MinimumLoadInvoiceNumber+1) as invoiceNumber FROM SystemConfig
				</cfquery>			
				<cfquery name="qrySearchAllInvoiceNumbers" datasource="#variables.dsn#">
					select invoiceNumber from loads 
					where 
						invoiceNumber=<cfqueryparam VALUE="#getloadmanual.invoiceNumber#" cfsqltype="cf_sql_integer">
				</cfquery>			
				<cfif qrySearchAllInvoiceNumbers.recordCount>
					<cfquery name="getloadmanual" datasource="#variables.dsn#">
						SELECT  max(invoiceNumber)+1 as invoiceNumber FROM Loads
					</cfquery>
				</cfif>			
				<cfquery name="UpdateloadInvoiceNumber" datasource="#variables.dsn#">
					update SystemConfig set MinimumLoadInvoiceNumber = <cfqueryparam value="#getloadmanual.invoiceNumber#">
				</cfquery>
				<cfset variables.invoiceNumber=getloadmanual.invoiceNumber>
			<cfelse>
				<cfset variables.invoiceNumber = 0>
			</cfif>	
			
			<cfif isdefined("arguments.frmstruct.loadManualNo") and arguments.frmstruct.loadManualNo eq "" >
				<cfif  arguments.frmstruct.ALLOWLOADENTRY eq 1>
					<cfquery name="getloadmanual" datasource="#variables.dsn#">
						SELECT loadManualNo=[MinimumLoadStartNumber]+1 FROM SystemConfig
					</cfquery>
				<cfelse>
					<cfquery name="getloadmanual" datasource="#variables.dsn#">
						SELECT  loadManualNo= MAX(LoadNumber)+1 FROM Loads
					</cfquery>
					<cfif getloadmanual.loadManualNo eq "null" or  getloadmanual.loadManualNo eq "" >
						<cfquery name="getloadmanual" datasource="#variables.dsn#">
							SELECT loadManualNo=[MinimumLoadStartNumber]+1 FROM SystemConfig
						</cfquery>
					</cfif>
				</cfif>
				<cfset loadManualNo=getloadmanual.loadManualNo>
			<cfelseif  isdefined("arguments.frmstruct.loadManualNo") and arguments.frmstruct.loadManualNo neq "">
				<cfset loadManualNo=arguments.frmstruct.loadManualNo>
			 </cfif> 
			
			 <!-----if allow manual load entry is true then update systemconfig-------->
			<cfif  arguments.frmstruct.ALLOWLOADENTRY eq 1>
				<cfquery name="Updateloadmanual" datasource="#variables.dsn#">
					  update SystemConfig set MinimumLoadStartNumber=MinimumLoadStartNumber+1
				</cfquery>
			</cfif>
			<!-----if allow manual load entry is true then update systemconfig-------->
			<cfinvoke component="#variables.objLoadgatewayUpdate#" method="InsertLoadAdd" loadManualNo="#loadManualNo#"  posttoloadboard="#posttoloadboard#" posttoTranscore="#posttoTranscore#" PostTo123LoadBoard="#PostTo123LoadBoard#" frmstruct="#arguments.frmstruct#" carFlatRate="#carFlatRate#" custFlatRate="#custFlatRate#" custRatePerMile="#custRatePerMile#" carRatePerMile="#carRatePerMile#" CustomerMilesCalc="#CustomerMilesCalc#" CarrierMilesCalc="#CarrierMilesCalc#" ARExported="#ARExported#" APExported="#APExported#" custMilesCharges="#custMilesCharges#" carMilesCharges="#carMilesCharges#" invoiceNumber="#invoiceNumber#" carCommodCharges="#carCommodCharges#" dsn="#variables.dsn#" custCommodCharges="#custCommodCharges#" returnvariable="qInsertedLoadID"/>
		  	<cfif isDefined("arguments.frmstruct.userDefinedForTrucking")>
			   	<cfquery name="UpdateUserDefinedFieldTrucking" datasource="#variables.dsn#">
					UPDATE  Loads SET 
					userDefinedFieldTrucking=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frmstruct.userDefinedForTrucking#">
					where loadid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#qInsertedLoadID.LASTLOADID#">
				</cfquery>
			</cfif>	
	   </cftransaction>
	   <cfset LastLoadId=qInsertedLoadID.LASTLOADID>
	   <cfset impref=qInsertedLoadID.IMPREF>
		<cfif isdefined('arguments.frmstruct.ISPARTIAL')>
			<cfset ISPARTIAL=1>
		<cfelse>
			<cfset ISPARTIAL=0>
		</cfif>
		<cfset readyDat = "">
		<cfif structKeyExists(arguments.frmstruct,"readyDat") and isDate(arguments.frmstruct.readyDat)>
			<cfset readyDat = arguments.frmstruct.readyDat>
		</cfif>
		<cfset arriveDat = "">
		<cfif structKeyExists(arguments.frmstruct,"arriveDat") and isDate(arguments.frmstruct.arriveDat)>
			<cfset arriveDat = arguments.frmstruct.arriveDat>
		</cfif>
		<cfset isExcused = "">
		<cfif structKeyExists(arguments.frmstruct,"Excused")>
			<cfset isExcused = arguments.frmstruct.Excused>
		</cfif>
		<cfset bookedBy = "">
		<cfif structKeyExists(arguments.frmstruct,"bookedBy")>
			<cfset bookedBy = arguments.frmstruct.bookedBy>
		</cfif>
		<cfquery name="Updatepartial_fld" datasource="#variables.dsn#">
			UPDATE  Loads SET ISPARTIAL=#ISPARTIAL#
			<cfif len(readyDat) gt 0>,readyDate = <cfqueryparam cfsqltype="cf_sql_date" value="#readyDat#">
			<cfelse>,readyDate = <cfqueryparam cfsqltype="cf_sql_date" value="#readyDat#" null="yes">
			</cfif>
			<cfif len(arriveDat) gt 0>,arriveDate = <cfqueryparam cfsqltype="cf_sql_date" value="#arriveDat#">
			<cfelse>,arriveDate = <cfqueryparam cfsqltype="cf_sql_date" value="#arriveDat#" null="yes">
			</cfif>
			<cfif len(isExcused) GT 0>,isExcused = <cfqueryparam cfsqltype="cf_sql_integer" value="#isExcused#">
			<cfelse>,isExcused = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			</cfif>
			<cfif len(bookedBy) GT 0>,bookedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bookedBy#">
			<cfelse>,bookedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bookedBy#" null="yes">
			</cfif>
			WHERE LoadID='#LastLoadId#' 
		</cfquery>
	   <!--- If there are any files attached to this load then move from temp table to the main table --->
	   <cfif structKeyExists(arguments.frmstruct,"tempLoadId")>
		   <cfinvoke method="linkAttachments" tempLoadId="#arguments.frmstruct.tempLoadId#" permLoadId="#LastLoadId#">
	   </cfif>
	   <cfset variables.shipperStatus=0>
		 <cfif arguments.frmstruct.shipper eq "" and arguments.frmstruct.shipperName eq "" and arguments.frmstruct.shipperlocation eq "" and arguments.frmstruct.shipperstate eq "" and arguments.frmstruct.shipperZipcode eq "" and arguments.frmstruct.shipperContactPerson eq "" and arguments.frmstruct.shipperPhone eq "" and arguments.frmstruct.shipperFax eq "" and arguments.frmstruct.shipperPickupNo1 eq "" and arguments.frmstruct.shipperPickupDate eq "" and arguments.frmstruct.shipperpickupTime eq "" and arguments.frmstruct.shipperTimeIn eq "" and arguments.frmstruct.shipperTimeOut eq "" and arguments.frmstruct.shipperEmail eq "" and shipBlind eq 'false' and arguments.frmstruct.shipperNotes eq "" and arguments.frmstruct.shipperDirection eq "">
			<cfset variables.shipperStatus=1>
		</cfif>
		
		<cfset lastUpdatedShipCustomerID ="">
		<cfif arguments.frmstruct.shipper neq "" and arguments.frmstruct.shipperName neq "">
			<!--- If Stop1 shipperFlag eq 2 then update customer details--->
		   <cfif structKeyExists(arguments.frmstruct,"shipperFlag") and  arguments.frmstruct.shipperFlag eq 2>
				<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="0" returnvariable="lastUpdatedShipCustomerID" />
			<cfelseif ((structKeyExists(arguments.frmstruct,"shipperFlag") and  arguments.frmstruct.shipperFlag eq 1) or (arguments.frmstruct.shipperValueContainer eq "")) and (variables.shipperStatus eq 0)>
				<cfscript>
					variables.objCustomerGateway = #request.cfcpath#&".customergateway";
				</cfscript>
				<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" returnvariable="shipperStruct" />
				<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
				<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
			<cfelseif (variables.shipperStatus eq 0)>
				<cfquery name="getEarlierCustName" datasource="#variables.dsn#">
					select CustomerName from Customers WHERE CustomerID = '#arguments.frmstruct.shipperValueContainer#'
				</cfquery>	
				<!--- If the customer name has changed then insert it --->		
				<cfif lcase(getEarlierCustName.CustomerName) neq lcase(arguments.frmstruct.shipperName)>
					<cfscript>
						variables.objCustomerGateway = #request.cfcpath#&".customergateway";
					</cfscript>
					<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" returnvariable="shipperStruct" />			
					<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
					<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
				<cfelse>	
					<cfset lastUpdatedShipCustomerID = arguments.frmstruct.shipperValueContainer>
				</cfif>
			<cfelse>
				<cfset lastUpdatedShipCustomerID = arguments.frmstruct.shipperValueContainer>
			 </cfif>
		</cfif>	 
		<cfif IsValid("date",arguments.frmstruct.shipperPickupDate) and IsValid("date",arguments.frmstruct.consigneePickupDate)>
			<cfset variables.dateCompareResult= DateCompare(arguments.frmstruct.shipperPickupDate,arguments.frmstruct.consigneePickupDate)>
			<cfif variables.dateCompareResult eq -1>
				<cfset variables.noOfDays1=dateDiff("d",arguments.frmstruct.shipperPickupDate, arguments.frmstruct.consigneePickupDate)>
			<cfelseif variables.dateCompareResult eq 0>
				<cfset variables.noOfDays1=0>
			<cfelseif variables.dateCompareResult eq 1>	
				<cfset variables.noOfDays1="">
			</cfif>
		<cfelse>
			<cfset variables.noOfDays1="">	
		</cfif>	
			
		<CFSTOREDPROC PROCEDURE="USP_InsertLoadStop" DATASOURCE="#variables.dsn#"> 
			<CFPROCPARAM VALUE="#LastLoadId#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.BookedWith#" cfsqltype="CF_SQL_VARCHAR">  
			<CFPROCPARAM VALUE="#arguments.frmstruct.equipment#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.driver#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.drivercell#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.truckNo#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.trailerNo#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.refNo#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.milse#" cfsqltype="cf_sql_float">
			<CFPROCPARAM VALUE="#arguments.frmstruct.carrierid#" cfsqltype="CF_SQL_VARCHAR">
			<cfif len(arguments.frmstruct.stOffice) gt 1>
				<CFPROCPARAM VALUE="#arguments.frmstruct.stOffice#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="Null" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupNO1#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupDate#" cfsqltype="CF_SQL_dATE"  null="#yesNoFormat(NOT len(arguments.frmstruct.shipperPickupDate))#">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupTime#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeIn#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeOut#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#lastUpdatedShipCustomerID#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(lastUpdatedShipCustomerID))#">
			<CFPROCPARAM VALUE="#ShipBlind#" cfsqltype="CF_SQL_BIT">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperNotes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperDirection#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="1" cfsqltype="CF_SQL_INTEGER">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperlocation#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperCity#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperStateName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperZipCode#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperContactPerson#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPhone#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperFax#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperEmail#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef1#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef2#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef3#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef4#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef5#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef6#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">
			<CFPROCPARAM VALUE="#variables.noOfDays1#" cfsqltype="CF_SQL_INTEGER" null="#yesNoFormat(NOT len(variables.noOfDays1))#">
			<cfprocresult name="qLastInsertedShipper">
		</CFSTOREDPROC>
		<cfset lastInsertedStopId = qLastInsertedShipper.lastStopID>
		
		<!--- IMPORT Load Stop Starts Here ---->
		<cfif structKeyExists(arguments.frmstruct,"dateDispatched")>
			<cfquery name="qUpdateLoadStopIntermodalImport" datasource="#variables.dsn#">
				insert into LoadStopIntermodalImport
					(
						LoadStopID,
						StopNo,
						dateDispatched, 
						steamShipLine, 
						eta,
						oceanBillofLading,
						actualArrivalDate,
						seal,
						customersReleaseDate,
						vesselName,
						freightReleaseDate,
						dateAvailable,
						demuggageFreeTimeExpirationDate,
						perDiemFreeTimeExpirationDate,
						pickupDate,
						requestedDeliveryDate,
						requestedDeliveryTime,
						scheduledDeliveryDate,
						scheduledDeliveryTime,
						unloadingDelayDetentionStartDate,
						unloadingDelayDetentionStartTime,
						actualDeliveryDate,
						unloadingDelayDetentionEndDate,
						unloadingDelayDetentionEndTime,
						returnDate,
						pickUpAddress,
						deliveryAddress,
						emptyReturnAddress
					)
				values
					(
						<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="1" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.frmstruct.dateDispatched#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.steamShipLine#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.eta#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.oceanBillofLading#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.actualArrivalDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.seal#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.customersReleaseDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.vesselName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.freightReleaseDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.dateAvailable#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.demuggageFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.perDiemFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.pickupDate#" cfsqltype="cf_sql_date" null="#yesNoFormat(NOT len(arguments.frmstruct.pickupDate))#">,
						<cfqueryparam value="#arguments.frmstruct.requestedDeliveryDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.requestedDeliveryTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.requestedDeliveryTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.scheduledDeliveryDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.scheduledDeliveryTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.scheduledDeliveryTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionStartDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionStartTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.unloadingDelayDetentionStartTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.actualDeliveryDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionEndDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionEndTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.unloadingDelayDetentionEndTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.returnDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.pickUpAddress#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.deliveryAddress#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.emptyReturnAddress#" cfsqltype="cf_sql_varchar">
					)
			</cfquery>
			
			<cfinvoke method="getLoadStopAddress" tablename="LoadStopCargoPickupAddress"
						address="#arguments.frmstruct.pickUpAddress#" returnvariable="qLoadStopCargoPickupAddressExists" />
			<cfif qLoadStopCargoPickupAddressExists.recordcount>
				<cfquery name="qUpdateCargoPickupAddress" datasource="#variables.dsn#">
					update 
						LoadStopCargoPickupAddress
					set
						address = <cfqueryparam value="#arguments.frmstruct.pickUpAddress#" cfsqltype="cf_sql_varchar">,
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
					where ID = <cfqueryparam value="#qLoadStopCargoPickupAddressExists.ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery name="qInsertCargoPickupAddress" datasource="#variables.dsn#">
					insert into LoadStopCargoPickupAddress
						(address, LoadStopID, dateAdded, dateModified)
					values
						(
							<cfqueryparam value="#arguments.frmstruct.pickUpAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
						)
				</cfquery>
			</cfif>
			<cfinvoke method="getLoadStopAddress" tablename="LoadStopCargoDeliveryAddress"
						address="#arguments.frmstruct.deliveryAddress#" returnvariable="qLoadStopCargoDeliveryAddressExists" />
			<cfif qLoadStopCargoDeliveryAddressExists.recordcount>
				<cfquery name="qUpdateCargoDeliveryAddress" datasource="#variables.dsn#">
					update 
						LoadStopCargoDeliveryAddress
					set
						address = <cfqueryparam value="#arguments.frmstruct.deliveryAddress#" cfsqltype="cf_sql_varchar">,
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
					where ID = <cfqueryparam value="#qLoadStopCargoDeliveryAddressExists.ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery name="qInsertCargoDeliveryAddress" datasource="#variables.dsn#">
					insert into LoadStopCargoDeliveryAddress
						(address, LoadStopID, dateAdded, dateModified)
					values
						(
							<cfqueryparam value="#arguments.frmstruct.deliveryAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
						)
				</cfquery>
			</cfif>
			<cfinvoke method="getLoadStopAddress" tablename="LoadStopEmptyReturnAddress"
						address="#arguments.frmstruct.emptyReturnAddress#" returnvariable="qLoadStopEmptyReturnAddressExists" />
			<cfif qLoadStopEmptyReturnAddressExists.recordcount>
				<cfquery name="qUpdateEmptyReturnAddress" datasource="#variables.dsn#">
					update 
						LoadStopEmptyReturnAddress
					set
						address = <cfqueryparam value="#arguments.frmstruct.emptyReturnAddress#" cfsqltype="cf_sql_varchar">,
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
					where ID = <cfqueryparam value="#qLoadStopEmptyReturnAddressExists.ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery name="qInsertEmptyReturnAddress" datasource="#variables.dsn#">
					insert into LoadStopEmptyReturnAddress
						(address, LoadStopID, dateAdded, dateModified)
					values
						(
							<cfqueryparam value="#arguments.frmstruct.emptyReturnAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
						)
				</cfquery>
			</cfif>
			
		</cfif>
		<!--- IMPORT Load Stop Ends Here --->
		
		<!--- EXPORT Load Stop Starts Here ---->
		<cfif structKeyExists(arguments.frmstruct,"exportDateDispatched")>
			<cfquery name="qUpdateLoadStopIntermodalExport" datasource="#variables.dsn#">
				insert into LoadStopIntermodalExport
					(
						LoadStopID,
						StopNo,
						dateDispatched,
						DateMtAvailableForPickup,
						steamShipLine,
						DemurrageFreeTimeExpirationDate,
						vesselName,
						PerDiemFreeTimeExpirationDate,
						Voyage,
						EmptyPickupDate,
						seal,
						Booking,
						ScheduledLoadingDate,
						ScheduledLoadingTime,
						VesselCutoffDate,
						LoadingDate,
						VesselLoadingWindow,
						LoadingDelayDetectionStartDate,
						LoadingDelayDetectionStartTime,
						RequestedLoadingDate,
						RequestedLoadingTime,
						LoadingDelayDetectionEndDate,
						LoadingDelayDetectionEndTime,
						ETS,
						ReturnDate,
						emptyPickupAddress,
						loadingAddress,
						returnAddress
					)
				values
					(
						<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="1" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.frmstruct.exportDateDispatched#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportDateMtAvailableForPickup#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportsteamShipLine#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportDemurrageFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportvesselName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportPerDiemFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportVoyage#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportEmptyPickupDate#" cfsqltype="cf_sql_date" null="#yesNoFormat(NOT len(arguments.frmstruct.exportEmptyPickupDate))#">,
						<cfqueryparam value="#arguments.frmstruct.exportseal#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportBooking#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportScheduledLoadingDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportScheduledLoadingTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.exportScheduledLoadingTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.exportVesselCutoffDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportLoadingDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportVesselLoadingWindow#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionStartDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionStartTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.exportLoadingDelayDetectionStartTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.exportRequestedLoadingDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportRequestedLoadingTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.exportRequestedLoadingTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionEndDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionEndTime#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(trim(arguments.frmstruct.exportLoadingDelayDetectionEndTime)))#">,
						<cfqueryparam value="#arguments.frmstruct.exportETS#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportReturnDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.frmstruct.exportEmptyPickupAddress#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportLoadingAddress#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.frmstruct.exportReturnAddress#" cfsqltype="cf_sql_varchar">
					)
			</cfquery>
			
			<cfinvoke method="getLoadStopAddress" tablename="LoadStopEmptyPickupAddress"
						address="#arguments.frmstruct.exportEmptyPickUpAddress#" returnvariable="qLoadStopEmptyPickupAddressExists" />
			<cfif qLoadStopEmptyPickupAddressExists.recordcount>
				<cfquery name="qUpdateEmptyPickupAddress" datasource="#variables.dsn#">
					update 
						LoadStopEmptyPickupAddress
					set
						address = <cfqueryparam value="#arguments.frmstruct.exportEmptyPickUpAddress#" cfsqltype="cf_sql_varchar">,
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
					where ID = <cfqueryparam value="#qLoadStopEmptyPickupAddressExists.ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery name="qInsertEmptyPickupAddress" datasource="#variables.dsn#">
					insert into LoadStopEmptyPickupAddress
						(address, LoadStopID, dateAdded, dateModified)
					values
						(
							<cfqueryparam value="#arguments.frmstruct.exportEmptyPickUpAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
						)
				</cfquery>
			</cfif>
			<cfinvoke method="getLoadStopAddress" tablename="LoadStopLoadingAddress"
						address="#arguments.frmstruct.exportLoadingAddress#" returnvariable="qLoadStopLoadingAddressExists" />
			<cfif qLoadStopLoadingAddressExists.recordcount>
				<cfquery name="qUpdateLoadingAddress" datasource="#variables.dsn#">
					update 
						LoadStopLoadingAddress
					set
						address = <cfqueryparam value="#arguments.frmstruct.exportLoadingAddress#" cfsqltype="cf_sql_varchar">,
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
					where ID = <cfqueryparam value="#qLoadStopLoadingAddressExists.ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery name="qInsertLoadingAddress" datasource="#variables.dsn#">
					insert into LoadStopLoadingAddress
						(address, LoadStopID, dateAdded, dateModified)
					values
						(
							<cfqueryparam value="#arguments.frmstruct.exportLoadingAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
						)
				</cfquery>
			</cfif>
			<cfinvoke method="getLoadStopAddress" tablename="LoadStopReturnAddress"
						address="#arguments.frmstruct.exportReturnAddress#" returnvariable="qLoadStopReturnAddressExists" />
			<cfif qLoadStopReturnAddressExists.recordcount>
				<cfquery name="qUpdateReturnAddress" datasource="#variables.dsn#">
					update 
						LoadStopReturnAddress
					set
						address = <cfqueryparam value="#arguments.frmstruct.exportReturnAddress#" cfsqltype="cf_sql_varchar">,
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
						dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
					where ID = <cfqueryparam value="#qLoadStopReturnAddressExists.ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery name="qInsertReturnAddress" datasource="#variables.dsn#">
					insert into LoadStopReturnAddress
						(address, LoadStopID, dateAdded, dateModified)
					values
						(
							<cfqueryparam value="#arguments.frmstruct.exportReturnAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
						)
				</cfquery>
			</cfif>
			
		</cfif>
		<!--- EXPORT Load Stop Ends Here --->
		<cfset variables.consigneeFlagstatus=0>
		<cfif arguments.frmstruct.consignee eq "" and arguments.frmstruct.consigneeName eq "" and arguments.frmstruct.consigneelocation eq "" and  arguments.frmstruct.consigneestate eq "" and arguments.frmstruct.consigneecity eq "" and arguments.frmstruct.consigneeZipcode eq "" and arguments.frmstruct.consigneeContactPerson eq "" and arguments.frmstruct.consigneePhone eq "" and arguments.frmstruct.consigneeFax eq "" and arguments.frmstruct.consigneePickupNo eq "" and arguments.frmstruct.consigneePickupDate eq "" and arguments.frmstruct.consigneepickupTime eq "" and arguments.frmstruct.consigneeTimeIn eq "" and arguments.frmstruct.consigneeTimeOut eq "" and ConsBlind eq 'false' and arguments.frmstruct.consigneeEmail eq "" and arguments.frmstruct.consigneeNotes eq "" and  arguments.frmstruct.consigneeDirection eq "">
			<cfset variables.consigneeFlagstatus=1>
		</cfif>
		<cfset lastUpdatedConsCustomerID ="">
		<cfif arguments.frmstruct.consignee neq "" and arguments.frmstruct.consigneeName neq "">
			<!--- If Stop1 consigneeFlag  eq 2 then update customer details--->
			<cfif structKeyExists(arguments.frmstruct,"consigneeFlag") and  arguments.frmstruct.consigneeFlag eq 2>
				<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="0" returnvariable="lastUpdatedConsCustomerID" />
			<cfelseif ((structKeyExists(arguments.frmstruct,"consigneeFlag") and  arguments.frmstruct.consigneeFlag eq 1) or (arguments.frmstruct.consigneeValueContainer eq "")) and (variables.consigneeFlagstatus eq 0) >	
				<cfscript>
					variables.objCustomerGateway = #request.cfcpath#&".customergateway";
				</cfscript>
				<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" returnvariable="consigneeStruct" />				
				<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
				<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
		   <cfelseif (variables.consigneeFlagstatus eq 0)>
				<cfquery name="getEarlierCustName" datasource="#variables.dsn#">
					select CustomerName from Customers WHERE CustomerID = '#consigneeValueContainer#'
				</cfquery>	
				<!--- If the customer name has changed then insert it --->		
				<cfif lcase(getEarlierCustName.CustomerName) neq lcase(arguments.frmstruct.consigneeName)>
					<cfscript>
						variables.objCustomerGateway = #request.cfcpath#&".customergateway";
					</cfscript>
					<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" returnvariable="consigneeStruct" />					
					<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
					<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
				<cfelse>	
					<cfset lastUpdatedConsCustomerID = arguments.frmstruct.consigneeValueContainer>
				</cfif>
			<cfelse>
				<cfset lastUpdatedConsCustomerID = arguments.frmstruct.consigneeValueContainer>
			</cfif>
		</cfif>
		<CFSTOREDPROC PROCEDURE="USP_InsertLoadStop" DATASOURCE="#variables.dsn#"> 
			<CFPROCPARAM VALUE="#LastLoadId#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.BookedWith#" cfsqltype="CF_SQL_VARCHAR">  
			<CFPROCPARAM VALUE="#arguments.frmstruct.equipment#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.driver#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.drivercell#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.truckNo#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.trailerNo#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.refNo#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.milse#" cfsqltype="cf_sql_float">
			<CFPROCPARAM VALUE="#arguments.frmstruct.carrierid#" cfsqltype="CF_SQL_VARCHAR">
			<cfif len(arguments.frmstruct.stOffice) gt 1>
				<CFPROCPARAM VALUE="#arguments.frmstruct.stOffice#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="Null" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupNo#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupDate#" cfsqltype="CF_SQL_dATE" null="#yesNoFormat(NOT len(arguments.frmstruct.consigneePickupDate))#">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupTime#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneetimein#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneetimeout#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#lastUpdatedConsCustomerID#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(lastUpdatedConsCustomerID))#" >
			<CFPROCPARAM VALUE="#ConsBlind#" cfsqltype="CF_SQL_BIT">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeNotes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeDirection#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="2" cfsqltype="CF_SQL_INTEGER">
			<!---<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">  Stop Number --->
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneelocation#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeCity#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeStateName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeZipCode#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeContactPerson#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePhone#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeFax#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeEmail#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef1#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef2#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef3#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef4#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef5#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.userDef6#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">
			<CFPROCPARAM VALUE="#variables.noOfDays1#" cfsqltype="CF_SQL_INTEGER" null="#yesNoFormat(NOT len(variables.noOfDays1))#">
			<cfprocresult name="qLastInsertedConsignee">
		</CFSTOREDPROC>
		<!--- Insert Load Items---->
		
		<cfloop from="1" to="#val(arguments.frmstruct.totalResult1)#" index="Num">
		     <cfset qty=VAL(evaluate("arguments.frmstruct.qty_#num#"))>
			 <cfset unit=evaluate("arguments.frmstruct.unit_#num#")>
			 <cfset description=evaluate("arguments.frmstruct.description_#num#")>
			 <cfif isdefined("arguments.frmstruct.weight_#num#")>
				<cfset weight=VAL(evaluate("arguments.frmstruct.weight_#num#"))>
			<cfelse>
				<cfset weight=0>
			</cfif>
			 <cfset class=evaluate("arguments.frmstruct.class_#num#")>
			 <cfset CustomerRate=evaluate("arguments.frmstruct.CustomerRate_#num#")>
			 <cfset CustomerRate = replace( CustomerRate,"$","","ALL") > 
			 <cfset CarrierRate=evaluate("arguments.frmstruct.CarrierRate_#num#")>
			 <cfset CarrierRate = replace( CarrierRate,"$","","ALL") > 
			 <cfset custCharges=evaluate("arguments.frmstruct.custCharges_#num#")>
			 <cfset custCharges = replace( custCharges,"$","","ALL") > 
			 <cfset carrCharges=evaluate("arguments.frmstruct.carrCharges_#num#")>
			 <cfset carrCharges = replace( carrCharges,"$","","ALL") > 
			 <cfset CarrRateOfCustTotal=evaluate("arguments.frmstruct.CarrierPer_#num#")>
			 <cfset CarrRateOfCustTotal = replace( CarrRateOfCustTotal,"%","","ALL") > 
			 <cfif not IsNumeric(CarrRateOfCustTotal)><cfset CarrRateOfCustTotal = 0></cfif>
			 <cfif isdefined('arguments.frmstruct.isFee_#num#')><cfset isFee=true><cfelse><cfset isFee=false></cfif>		
			 <cfif not len(trim(CustomerRate))><cfset CustomerRate=0.00></cfif>
			 <cfif not len(trim(CarrierRate))><cfset CarrierRate=0.00></cfif>
			<CFSTOREDPROC PROCEDURE="USP_InsertLoadItem" DATASOURCE="#variables.dsn#"> 
				<CFPROCPARAM VALUE="#lastInsertedStopId#" cfsqltype="CF_SQL_VARCHAR">
			 	<CFPROCPARAM VALUE="#num#" cfsqltype="CF_SQL_VARCHAR">
			 	<CFPROCPARAM VALUE="#val(qty)#" cfsqltype="CF_SQL_float">
			 	<CFPROCPARAM VALUE="#unit#" cfsqltype="CF_SQL_VARCHAR">
			 	<CFPROCPARAM VALUE="#description#" cfsqltype="CF_SQL_NVARCHAR">
			 	<CFPROCPARAM VALUE="#weight#" cfsqltype="CF_SQL_float">
			 	<CFPROCPARAM VALUE="#class#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#Val(CustomerRate)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#Val(CarrierRate)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#val(custCharges)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#val(carrCharges)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#CarrRateOfCustTotal#" cfsqltype="cf_sql_decimal">
			 	<CFPROCPARAM VALUE="#isFee#" cfsqltype="CF_SQL_VARCHAR">
			 	<CFPROCRESULT NAME="qInsertedLoadItem">
			</cfstoredproc>
		</cfloop>
	    <!--- Insert 2nd and further Stops --->
		<!--- <cfif val(arguments.frmstruct.totalStop) gt 1> --->
		<cfif listLen(arguments.frmstruct.shownStopArray)>
			<!--- <cfloop from="2" to="#val(arguments.frmstruct.totalStop)#" index="stpID"> --->
			<!--- Looping through 2nd and further loads --->
			<cfloop list="#arguments.frmstruct.shownStopArray#" index="stpID">
				<cfif isdefined('arguments.frmstruct.shipBlind#stpID#')>
					<cfset shipBlind=True>
				<cfelse>
					<cfset shipBlind=False>
				</cfif>
				<cfif isdefined('arguments.frmstruct.ConsBlind#stpID#')>
					<cfset ConsBlind=True>
				<cfelse>
					<cfset ConsBlind=False>
				</cfif>
				<cfset evaluate("variables.shipperStatus#stpID#=0")>
				 <cfif  evaluate('arguments.frmstruct.shipper#stpID#') eq "" and evaluate('arguments.frmstruct.shipperName#stpID#') eq "" and evaluate('arguments.frmstruct.shipperlocation#stpID#') eq "" and evaluate('arguments.frmstruct.shipperstate#stpID#') eq "" and evaluate('arguments.frmstruct.shipperZipcode#stpID#')  eq "" and evaluate('arguments.frmstruct.shipperContactPerson#stpID#') eq "" and evaluate('arguments.frmstruct.shipperPhone#stpID#') eq "" and evaluate('arguments.frmstruct.shipperFax#stpID#') eq "" and evaluate('arguments.frmstruct.shipperPickupNo1#stpID#') eq "" and evaluate('arguments.frmstruct.shipperPickupDate#stpID#') eq "" and evaluate('arguments.frmstruct.shipperpickupTime#stpID#') eq "" and evaluate('arguments.frmstruct.shipperTimeIn#stpID#') eq "" and evaluate('arguments.frmstruct.shipperTimeOut#stpID#') eq "" and evaluate('arguments.frmstruct.shipperEmail#stpID#') eq "" and shipBlind eq 'false' and evaluate(' arguments.frmstruct.shipperNotes#stpID#') eq "" and evaluate('arguments.frmstruct.shipperDirection#stpID#') eq "">
					<cfset evaluate("variables.shipperStatus#stpID#=1")>
				</cfif>
				<cfset lastUpdatedShipCustomerID ="">
				<cfif evaluate("arguments.frmstruct.shipper#stpID#") neq "" and evaluate("arguments.frmstruct.shipperName#stpID#") neq "">
					<!--- If 2nd and further stops shipperFlag eq 2 then update customer details --->
					<cfif structKeyExists(arguments.frmstruct,"shipperFlag#stpID#") and  evaluate("arguments.frmstruct.shipperFlag#stpID#") eq 2>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="#stpID#" returnvariable="lastUpdatedShipCustomerID" />
					<cfelseif ((structKeyExists(arguments.frmstruct,"shipperFlag#stpID#") and  evaluate("arguments.frmstruct.shipperFlag#stpID#") eq 1) or (evaluate('arguments.frmstruct.shipperValueContainer#stpID#') eq "")) and ((evaluate('variables.shipperStatus#stpID#') eq 0))>	
						<cfscript>
							variables.objCustomerGateway = #request.cfcpath#&".customergateway";
						</cfscript>
						<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" stop="#stpID#" returnvariable="shipperStruct" />				
						<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
						<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
					<cfelseif (evaluate('variables.shipperStatus#stpID#') eq 0)>  
						<cfquery name="getEarlierCustName" datasource="#variables.dsn#">
							select CustomerName from Customers WHERE CustomerID = '#arguments.frmstruct.cutomerIdAutoValueContainer#'
						</cfquery>	
						<!--- If the customer name has changed then insert it --->		
						<cfif lcase(getEarlierCustName.CustomerName) neq lcase(evaluate("arguments.frmstruct.shipperName#stpID#"))>
							<cfscript>
								variables.objCustomerGateway = #request.cfcpath#&".customergateway";
							</cfscript>
							<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" stop="#stpID#" returnvariable="shipperStruct" />					
							<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
							<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
						<cfelse>
							<cfset lastUpdatedShipCustomerID = evaluate('arguments.frmstruct.shipperValueContainer#stpID#')>
						</cfif>
					<cfelse>
						<cfset lastUpdatedShipCustomerID = evaluate('arguments.frmstruct.shipperValueContainer#stpID#')>
					</cfif>	
				</cfif>
		 	<cfset variables.NewStopNo = 0>
	 		<cfloop from="1" to="10" index="index">
	 			<cfquery name="qryGetStopExists" datasource="#variables.dsn#">
					SELECT StopNo FROM LoadStops
					WHERE LoadID = <cfqueryparam value="#LastLoadId#" cfsqltype="cf_sql_varchar">
					AND StopNo = <cfqueryparam value="#index#" cfsqltype="cf_sql_integer">
					AND StopNo < <cfqueryparam value="#stpID-1#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif NOT qryGetStopExists.recordcount>
					<cfset variables.NewStopNo = index>
					<cfbreak>
				<cfelse>
					<cfset variables.NewStopNo = index>
				</cfif>						
	 		</cfloop>
	 			<cfif IsValid("date",#evaluate('arguments.frmstruct.shipperPickupDate#stpID#')#) and IsValid("date",#evaluate('arguments.frmstruct.consigneePickupDate#stpID#')#)>					<cfset variables.dateCompareResult= DateCompare(evaluate('arguments.frmstruct.shipperPickupDate#stpID#'), evaluate('arguments.frmstruct.consigneePickupDate#stpID#'))>
					<cfif variables.dateCompareResult eq -1>
						<cfset variables.noOfDays=dateDiff("d", evaluate('arguments.frmstruct.shipperPickupDate#stpID#'), evaluate('arguments.frmstruct.consigneePickupDate#stpID#'))>
					<cfelseif variables.dateCompareResult eq 0>
						<cfset variables.noOfDays=0>
					<cfelseif variables.dateCompareResult eq 1>	
						<cfset variables.noOfDays="">
					</cfif>
				<cfelse>
					<cfset variables.noOfDays="">	
				</cfif>	
	 			
				<CFSTOREDPROC PROCEDURE="USP_InsertLoadStop" DATASOURCE="#variables.dsn#">
					<CFPROCPARAM VALUE="#LastLoadId#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.BookedWith#stpID#')#" cfsqltype="CF_SQL_VARCHAR">  
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.equipment#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.driver#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.drivercell#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.truckNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.trailerNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.refNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.milse#stpID#')#" cfsqltype="cf_sql_float">
					<!------If the carrier for this stop is not selected and the carrier for the first stop is selected then add the first stop carrier for this stop------>
					<cfif arguments.frmstruct.carrierid neq "" and evaluate('arguments.frmstruct.carrierid#stpID#') eq "">	
						<CFPROCPARAM VALUE="#arguments.frmstruct.carrierid#" cfsqltype="CF_SQL_VARCHAR">
						<cfif len(arguments.frmstruct.stOffice) gt 1>
							<CFPROCPARAM VALUE="#arguments.frmstruct.stOffice#" cfsqltype="CF_SQL_VARCHAR">
						<cfelse>
							<CFPROCPARAM VALUE="Null" cfsqltype="CF_SQL_VARCHAR">
						</cfif>
					<cfelse>						
						<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.carrierid#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<cfif len(evaluate('arguments.frmstruct.stOffice#stpID#')) gt 1>
							<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.stOffice#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<cfelse>
							<CFPROCPARAM VALUE="Null" cfsqltype="CF_SQL_VARCHAR">
						</cfif>
					</cfif>
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperPickupNO1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperPickupDate#stpID#')#" cfsqltype="CF_SQL_dATE" null="#yesNoFormat(NOT len(evaluate('arguments.frmstruct.shipperPickupDate#stpID#')))#">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperPickupTime#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperTimeIn#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperTimeOut#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#lastUpdatedShipCustomerID#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(lastUpdatedShipCustomerID))#">
					<CFPROCPARAM VALUE="#ShipBlind#" cfsqltype="CF_SQL_BIT">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperNotes#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperDirection#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="1" cfsqltype="CF_SQL_INTEGER">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperlocation#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperCity#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperStateName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperZipCode#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperContactPerson#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperPhone#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperFax#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperEmail#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.shipperName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef2#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef3#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef4#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef5#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef6#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#variables.NewStopNo#" cfsqltype="CF_SQL_INTEGER">
					<CFPROCPARAM VALUE="#variables.noOfDays#" cfsqltype="CF_SQL_INTEGER" null="#yesNoFormat(NOT len(variables.noOfDays))#">
					<CFPROCRESULT NAME="qInsertedCustStopId"> 
				</cfstoredproc>
				<cfset lastInsertedStopId = qInsertedCustStopId.lastStopID>
				<cfset evaluate("variables.consigneeFlagstatus#stpID#=0")>
				<cfif  evaluate('arguments.frmstruct.consignee#stpID#') eq "" and evaluate('arguments.frmstruct.consigneeName#stpID#') eq "" and evaluate('arguments.frmstruct.consigneelocation#stpID#') eq "" and evaluate('arguments.frmstruct.consigneestate#stpID#') eq "" and evaluate('arguments.frmstruct.consigneecity#stpID#')  eq "" and evaluate('arguments.frmstruct.consigneeZipcode#stpID#') eq "" and evaluate('arguments.frmstruct.consigneeContactPerson#stpID#') eq "" and evaluate('arguments.frmstruct.consigneePhone#stpID#') eq "" and evaluate('arguments.frmstruct.consigneeFax#stpID#') eq "" and evaluate('arguments.frmstruct.consigneePickupNo#stpID#') eq "" and evaluate('arguments.frmstruct.consigneePickupDate#stpID#') eq "" and evaluate('arguments.frmstruct.consigneepickupTime#stpID#') eq "" and evaluate('arguments.frmstruct.consigneeTimeIn#stpID#') eq "" and evaluate('arguments.frmstruct.consigneeTimeOut#stpID#') eq "" and ConsBlind eq 'false' and evaluate(' arguments.frmstruct.consigneeEmail#stpID#') eq "" and evaluate('arguments.frmstruct.consigneeNotes#stpID#') eq ""  and evaluate('arguments.frmstruct.consigneeDirection#stpID#') eq "">
					<cfset evaluate("variables.consigneeFlagstatus#stpID#=1")>
				</cfif>
				<cfset lastUpdatedConsCustomerID ="">
				<cfif evaluate("arguments.frmstruct.consignee#stpID#") neq "" and evaluate("arguments.frmstruct.consigneeName#stpID#") neq "">
					<!--- If 2nd and further stops consigneeFlag eq 2 then update customer details--->
					<cfif structKeyExists(arguments.frmstruct,"consigneeFlag#stpID#") and  evaluate("arguments.frmstruct.consigneeFlag#stpID#") eq 2>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="#stpID#" returnvariable="lastUpdatedConsCustomerID" />
					<cfelseif ((structKeyExists(arguments.frmstruct,"consigneeFlag#stpID#") and  evaluate("arguments.frmstruct.consigneeFlag#stpID#") eq 1) or (evaluate('arguments.frmstruct.consigneeValueContainer#stpID#') eq "")) and (evaluate('variables.consigneeFlagstatus#stpID#') eq 0)  >	
						<cfscript>
							variables.objCustomerGateway = #request.cfcpath#&".customergateway";
						</cfscript>
						<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" stop="#stpID#" returnvariable="consigneeStruct" />					
						<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
						<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
				   <cfelseif (evaluate('variables.consigneeFlagstatus#stpID#') eq 0)>
						<cfquery name="getEarlierCustName" datasource="#variables.dsn#">
							select CustomerName from Customers WHERE CustomerID = '#arguments.frmstruct.cutomerIdAutoValueContainer#'
						</cfquery>	
						<!--- If the customer name has changed then insert it --->		
						<cfif lcase(getEarlierCustName.CustomerName) neq lcase(evaluate("arguments.frmstruct.consigneeName#stpID#"))>
							<cfscript>
								variables.objCustomerGateway = #request.cfcpath#&".customergateway";
							</cfscript>
							<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" stop="#stpID#" returnvariable="consigneeStruct" />		
							<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
							<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
						<cfelse>
							<cfset lastUpdatedConsCustomerID = evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>	
						</cfif>	
					<cfelse>
						<cfset lastUpdatedConsCustomerID = evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>	
					</cfif>
				</cfif>	
				<CFSTOREDPROC PROCEDURE="USP_InsertLoadStop" DATASOURCE="#variables.dsn#"> 
					<CFPROCPARAM VALUE="#LastLoadId#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="True" cfsqltype="CF_SQL_VARCHAR">					
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.BookedWith#stpID#')#" cfsqltype="CF_SQL_VARCHAR">  
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.equipment#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.driver#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.drivercell#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.truckNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.trailerNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.refNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.milse#stpID#')#" cfsqltype="cf_sql_float">
					<!------If the carrier for this stop is not selected and the carrier for the first stop is selected then add the first stop carrier for this stop------>		
					<cfif arguments.frmstruct.carrierid neq "" and evaluate('arguments.frmstruct.carrierid#stpID#') eq "">	
						<CFPROCPARAM VALUE="#arguments.frmstruct.carrierid#" cfsqltype="CF_SQL_VARCHAR">
						<cfif len(arguments.frmstruct.stOffice) gt 1>
							<CFPROCPARAM VALUE="#arguments.frmstruct.stOffice#" cfsqltype="CF_SQL_VARCHAR">
						<cfelse>
							<CFPROCPARAM VALUE="Null" cfsqltype="CF_SQL_VARCHAR">
						</cfif>
					<cfelse>						
						<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.carrierid#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<cfif len(evaluate('arguments.frmstruct.stOffice#stpID#')) gt 1>
							<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.stOffice#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<cfelse>
							<CFPROCPARAM VALUE="Null" cfsqltype="CF_SQL_VARCHAR">
						</cfif>
					</cfif>
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneePickupNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneePickupDate#stpID#')#" cfsqltype="CF_SQL_dATE" null="#yesNoFormat(NOT len(evaluate('arguments.frmstruct.consigneePickupDate#stpID#')))#">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneePickupTime#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneetimein#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneetimeout#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#lastUpdatedConsCustomerID#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(lastUpdatedConsCustomerID))#">
					<CFPROCPARAM VALUE="#ConsBlind#" cfsqltype="CF_SQL_BIT">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeNotes#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeDirection#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="2" cfsqltype="CF_SQL_INTEGER">
					<!---<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">  Stop Number --->
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneelocation#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeCity#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeStateName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeZipCode#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeContactPerson#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneePhone#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeFax#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeEmail#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.consigneeName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef2#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef3#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef4#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef5#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#evaluate('arguments.frmstruct.userDef6#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
					<CFPROCPARAM VALUE="#variables.NewStopNo#" cfsqltype="CF_SQL_INTEGER">
					<CFPROCPARAM VALUE="#variables.noOfDays#" cfsqltype="CF_SQL_INTEGER" null="#yesNoFormat(NOT len(variables.noOfDays))#">	
					<cfprocresult name="qLastInsertedConsignee">
				</CFSTOREDPROC>
				<cfset lastConsigneeStopId = qInsertedCustStopId.lastStopID>
				
				<!--- IMPORT Load Stop Starts Here ---->
				<cfif structKeyExists(arguments.frmstruct,"dateDispatched#stpID#")>
					<cfquery name="qUpdateLoadStopIntermodalImport" datasource="#variables.dsn#">
						insert into LoadStopIntermodalImport
							(
								LoadStopID,
								StopNo,
								dateDispatched, 
								steamShipLine, 
								eta,
								oceanBillofLading,
								actualArrivalDate,
								seal,
								customersReleaseDate,
								vesselName,
								freightReleaseDate,
								dateAvailable,
								demuggageFreeTimeExpirationDate,
								perDiemFreeTimeExpirationDate,
								pickupDate,
								requestedDeliveryDate,
								requestedDeliveryTime,
								scheduledDeliveryDate,
								scheduledDeliveryTime,
								unloadingDelayDetentionStartDate,
								unloadingDelayDetentionStartTime,
								actualDeliveryDate,
								unloadingDelayDetentionEndDate,
								unloadingDelayDetentionEndTime,
								returnDate,
								pickUpAddress,
								deliveryAddress,
								emptyReturnAddress
							)
						values
							(
								<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#stpID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.dateDispatched#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.steamShipLine#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.eta#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.oceanBillofLading#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.actualArrivalDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.seal#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.customersReleaseDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.vesselName#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.freightReleaseDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.dateAvailable#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.demuggageFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.perDiemFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.pickupDate#stpID#')#" cfsqltype="cf_sql_date" null="#yesNoFormat(NOT len(EVALUATE('arguments.frmstruct.pickupDate#stpID#')))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.requestedDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset requestedDeliveryTime = EVALUATE('arguments.frmstruct.requestedDeliveryTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.requestedDeliveryTime#stpID#')#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(requestedDeliveryTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.scheduledDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset scheduledDeliveryTime = EVALUATE('arguments.frmstruct.scheduledDeliveryTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.scheduledDeliveryTime#stpID#')#" cfsqltype="cf_sql_time"  null="#yesNoFormat(NOT len(scheduledDeliveryTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionStartDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset unloadingDelayDetentionStartTime = EVALUATE('arguments.frmstruct.unloadingDelayDetentionStartTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionStartTime#stpID#')#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(unloadingDelayDetentionStartTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.actualDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionEndDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset unloadingDelayDetentionEndTime = EVALUATE('arguments.frmstruct.unloadingDelayDetentionEndTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionEndTime#stpID#')#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(unloadingDelayDetentionEndTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.returnDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.pickUpAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.deliveryAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.emptyReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">
							)
					</cfquery>
					
					<cfinvoke method="getLoadStopAddress" tablename="LoadStopCargoPickupAddress"
						address="#EVALUATE('arguments.frmstruct.pickUpAddress#stpID#')#" returnvariable="qLoadStopCargoPickupAddressExists" />
					<cfif qLoadStopCargoPickupAddressExists.recordcount>
						<cfquery name="qUpdateCargoPickupAddress" datasource="#variables.dsn#">
							update 
								LoadStopCargoPickupAddress
							set
								address = <cfqueryparam value="#EVALUATE('arguments.frmstruct.pickUpAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
							where ID = <cfqueryparam value="#qLoadStopCargoPickupAddressExists.ID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
						<cfquery name="qInsertCargoPickupAddress" datasource="#variables.dsn#">
							insert into LoadStopCargoPickupAddress
								(address, LoadStopID, dateAdded, dateModified)
							values
								(
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.pickUpAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
								)
						</cfquery>
					</cfif>
					<cfinvoke method="getLoadStopAddress" tablename="LoadStopCargoDeliveryAddress" address="#EVALUATE('arguments.frmstruct.deliveryAddress#stpID#')#" returnvariable="qLoadStopCargoDeliveryAddressExists" />
					<cfif qLoadStopCargoDeliveryAddressExists.recordcount>
						<cfquery name="qUpdateCargoDeliveryAddress" datasource="#variables.dsn#">
							update 
								LoadStopCargoDeliveryAddress
							set
								address = <cfqueryparam value="#EVALUATE('arguments.frmstruct.deliveryAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
							where ID = <cfqueryparam value="#qLoadStopCargoDeliveryAddressExists.ID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
						<cfquery name="qInsertCargoDeliveryAddress" datasource="#variables.dsn#">
							insert into LoadStopCargoDeliveryAddress
								(address, LoadStopID, dateAdded, dateModified)
							values
								(
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.deliveryAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
								)
						</cfquery>
					</cfif>
					<cfinvoke method="getLoadStopAddress" tablename="LoadStopEmptyReturnAddress" address="#EVALUATE('arguments.frmstruct.emptyReturnAddress#stpID#')#" returnvariable="qLoadStopEmptyReturnAddressExists" />
					<cfif qLoadStopEmptyReturnAddressExists.recordcount>
						<cfquery name="qUpdateEmptyReturnAddress" datasource="#variables.dsn#">
							update 
								LoadStopEmptyReturnAddress
							set
								address = <cfqueryparam value="#EVALUATE('arguments.frmstruct.emptyReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
							where ID = <cfqueryparam value="#qLoadStopEmptyReturnAddressExists.ID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
						<cfquery name="qInsertEmptyReturnAddress" datasource="#variables.dsn#">
							insert into LoadStopEmptyReturnAddress
								(address, LoadStopID, dateAdded, dateModified)
							values
								(
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.emptyReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
								)
						</cfquery>
					</cfif>
					
				</cfif>
				<!--- IMPORT Load Stop Ends Here --->
				
				<!--- EXPORT Load Stop Starts Here ---->
				<cfif structKeyExists(arguments.frmstruct,"exportDateDispatched#stpID#")>
					<cfquery name="qUpdateLoadStopIntermodalExport" datasource="#variables.dsn#">
						insert into LoadStopIntermodalExport
							(
								LoadStopID,
								StopNo,
								dateDispatched,
								DateMtAvailableForPickup,
								steamShipLine,
								DemurrageFreeTimeExpirationDate,
								vesselName,
								PerDiemFreeTimeExpirationDate,
								Voyage,
								EmptyPickupDate,
								seal,
								Booking,
								ScheduledLoadingDate,
								ScheduledLoadingTime,
								VesselCutoffDate,
								LoadingDate,
								VesselLoadingWindow,
								LoadingDelayDetectionStartDate,
								LoadingDelayDetectionStartTime,
								RequestedLoadingDate,
								RequestedLoadingTime,
								LoadingDelayDetectionEndDate,
								LoadingDelayDetectionEndTime,
								ETS,
								ReturnDate,
								emptyPickupAddress,
								loadingAddress,
								returnAddress
							)
						values
							(
								<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#stpID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportDateDispatched#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportDateMtAvailableForPickup#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportsteamShipLine#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportDemurrageFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportvesselName#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportPerDiemFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVoyage#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportEmptyPickupDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportseal#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportBooking#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportScheduledLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset exportScheduledLoadingTime = EVALUATE('arguments.frmstruct.exportScheduledLoadingTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportScheduledLoadingTime#stpID#')#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(exportScheduledLoadingTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVesselCutoffDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVesselLoadingWindow#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionStartDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset exportLoadingDelayDetectionStartTime = EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionStartTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionStartTime#stpID#')#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(exportLoadingDelayDetectionStartTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportRequestedLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset exportRequestedLoadingTime = EVALUATE('arguments.frmstruct.exportRequestedLoadingTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportRequestedLoadingTime#stpID#')#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(exportRequestedLoadingTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionEndDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfset exportLoadingDelayDetectionEndTime = EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionEndTime#stpID#')>
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionEndTime#stpID#')#" cfsqltype="cf_sql_time" null="#yesNoFormat(NOT len(exportLoadingDelayDetectionEndTime))#">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportETS#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnDate#stpID#')#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportEmptyPickupAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">
							)
					</cfquery>
					
					<cfinvoke method="getLoadStopAddress" tablename="LoadStopEmptyPickupAddress" address="#EVALUATE('arguments.frmstruct.exportEmptyPickUpAddress#stpID#')#" returnvariable="qLoadStopEmptyPickupAddressExists" />
					<cfif qLoadStopEmptyPickupAddressExists.recordcount>
						<cfquery name="qUpdateEmptyPickupAddress" datasource="#variables.dsn#">
							update 
								LoadStopEmptyPickupAddress
							set
								address = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportEmptyPickUpAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
							where ID = <cfqueryparam value="#qLoadStopEmptyPickupAddressExists.ID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
						<cfquery name="qInsertEmptyPickupAddress" datasource="#variables.dsn#">
							insert into LoadStopEmptyPickupAddress
								(address, LoadStopID, dateAdded, dateModified)
							values
								(
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportEmptyPickUpAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
								)
						</cfquery>
					</cfif>
					
					<cfinvoke method="getLoadStopAddress" tablename="LoadStopLoadingAddress" address="#EVALUATE('arguments.frmstruct.exportLoadingAddress#stpID#')#" returnvariable="qLoadStopLoadingAddressExists" />
					<cfif qLoadStopLoadingAddressExists.recordcount>
						<cfquery name="qUpdateLoadingAddress" datasource="#variables.dsn#">
							update 
								LoadStopLoadingAddress
							set
								address = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
							where ID = <cfqueryparam value="#qLoadStopLoadingAddressExists.ID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
						<cfquery name="qInsertLoadingAddress" datasource="#variables.dsn#">
							insert into LoadStopLoadingAddress
								(address, LoadStopID, dateAdded, dateModified)
							values
								(
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
								)
						</cfquery>
					</cfif>
					<cfinvoke method="getLoadStopAddress" tablename="LoadStopReturnAddress" address="#EVALUATE('arguments.frmstruct.exportReturnAddress#stpID#')#" returnvariable="qLoadStopReturnAddressExists" />
					<cfif qLoadStopReturnAddressExists.recordcount>
						<cfquery name="qUpdateReturnAddress" datasource="#variables.dsn#">
							update 
								LoadStopReturnAddress
							set
								address = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
								dateModified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
							where ID = <cfqueryparam value="#qLoadStopReturnAddressExists.ID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
						<cfquery name="qInsertReturnAddress" datasource="#variables.dsn#">
							insert into LoadStopReturnAddress
								(address, LoadStopID, dateAdded, dateModified)
							values
								(
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
								)
						</cfquery>
					</cfif>
					
				</cfif>
				
				<!--- Insert Load Items---->
				<cfloop from="1" to="#val(evaluate("arguments.frmstruct.totalResult#stpID#"))#" index="Num">
					<cfset qty=evaluate("arguments.frmstruct.qty#stpID#_#num#")>
					<cfset unit=evaluate("arguments.frmstruct.unit#stpID#_#num#")>
					<cfset description=evaluate("arguments.frmstruct.description#stpID#_#num#")>
					<cfif isdefined("arguments.frmstruct.weight#stpID#_#num#")>
						<cfset weight=VAL(evaluate("arguments.frmstruct.weight#stpID#_#num#"))>
					<cfelse>
						<cfset weight=0>
					</cfif>
					<cfset class=evaluate("arguments.frmstruct.class#stpID#_#num#")>
					<cfset CustomerRate=evaluate("arguments.frmstruct.CustomerRate#stpID#_#num#")>
					<cfset CustomerRate = replace( CustomerRate,"$","","ALL") > 
					<cfset CarrierRate=evaluate("arguments.frmstruct.CarrierRate#stpID#_#num#")>
					<cfset CarrierRate = replace( CarrierRate,"$","","ALL") > 
					<cfset custCharges=evaluate("arguments.frmstruct.custCharges#stpID#_#num#")>
					<cfset custCharges = replace( custCharges,"$","","ALL") > 
					<cfset carrCharges=evaluate("arguments.frmstruct.carrCharges#stpID#_#num#")>
					<cfset carrCharges = replace( carrCharges,"$","","ALL") > 
					<cfset CarrRateOfCustTotal=evaluate("arguments.frmstruct.CarrierPer#stpID#_#num#")>
					<cfset CarrRateOfCustTotal = replace( CarrRateOfCustTotal,"%","","ALL") > 
					<cfif not IsNumeric(CarrRateOfCustTotal)>
						<cfset CarrRateOfCustTotal = 0>
					</cfif>
					<cfif isdefined('arguments.frmstruct.isFee#stpID#_#num#')>
						<cfset isFee=true>
					<cfelse>
						<cfset isFee=false>
					</cfif>
					<cfif not len(trim(CustomerRate))>
						<cfset CustomerRate="0.00">
			 		</cfif>
			 
					 <cfif not len(trim(CarrierRate))>
						<cfset CarrierRate="0.00">
					 </cfif>
					<CFSTOREDPROC PROCEDURE="USP_InsertLoadItem" DATASOURCE="#variables.dsn#"> 
						<CFPROCPARAM VALUE="#lastInsertedStopId#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#num#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#val(qty)#" cfsqltype="CF_SQL_float">
						<CFPROCPARAM VALUE="#unit#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#description#" cfsqltype="CF_SQL_NVARCHAR">
						<CFPROCPARAM VALUE="#weight#" cfsqltype="CF_SQL_float">
						<CFPROCPARAM VALUE="#class#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#Val(CustomerRate)#" cfsqltype="cf_sql_money">
						<CFPROCPARAM VALUE="#Val(CarrierRate)#" cfsqltype="cf_sql_money">
						<CFPROCPARAM VALUE="#val(custCharges)#" cfsqltype="cf_sql_money">
						<CFPROCPARAM VALUE="#val(carrCharges)#" cfsqltype="cf_sql_money">
						<CFPROCPARAM VALUE="#CarrRateOfCustTotal#" cfsqltype="cf_sql_decimal">
						<CFPROCPARAM VALUE="#isFee#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCRESULT NAME="qInsertedLoadItem">
					</CFSTOREDPROC>							
				</cfloop>
			</cfloop>
		</cfif>
		<cfset Msg0='1'> <cfset Msg1='1'><cfset msg2 ='1'>
		<cfset ITS_msg = 1>
		<cfset variables.promilesRes=1>
	  <!-------posteverywhere webservice calll---->  
		<cfif  structKeyExists(arguments.frmstruct,"integratewithPEP") and  #arguments.frmstruct.integratewithPEP# eq 1 and structKeyExists(arguments.frmstruct,"posttoloadboard")>
			<cfif arguments.frmstruct.loadStatus eq "c126b878-9db5-4411-be4d-61e93fab8c95">
				<cfset p_action='D'>
			<cfelse>
				<cfset p_action='A'>
			</cfif>
			<cfinvoke method="Posteverywhere" impref="#impref#" PEPcustomerKey="#arguments.frmstruct.PEPcustomerKey#" PEPsecretKey="#arguments.frmstruct.PEPsecretKey#" POSTACTION="#p_action#" returnvariable="request.postevrywhere" />
			<cfset Msg0=request.postevrywhere>
		</cfif> 
		<!-----Transcore 360 Webservice Call-------->
		<cfif  structKeyExists(arguments.frmstruct,"integratewithTran360") and  #arguments.frmstruct.integratewithTran360# eq 1 and structKeyExists(arguments.frmstruct,"posttoTranscore")>
			<cfset p_action='A'>
			<!--- END: Trans360 webservice changes Date:23 Sep 2013 --->
			<cfinvoke method="Transcore360Webservice" impref="#impref#" trans360Usename="#arguments.frmstruct.trans360Usename#" trans360Password="#arguments.frmstruct.trans360Password#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
			<!--- <cfdump var="#request.Transcore360Webservice#" /><cfabort /> --->
			<cfset Msg1=request.Transcore360Webservice>
			
		</cfif>
		<!--- Validation for Unauthorised users try to update on Transcore --->
		<cfif NOT structKeyExists(arguments.frmstruct,"integratewithTran360") AND structKeyExists(arguments.frmstruct,"posttoTranscore")>
			<cfset msg1 = "There is a problem in logging to Dat Loadboard">
		</cfif>
		<!--- BEGIN: ITS Webservice Integration --->
		<cfif structKeyExists(arguments.frmstruct,"integratewithITS") and  arguments.frmstruct.integratewithITS EQ 1 AND structKeyExists(arguments.frmstruct,"posttoITS")>
			<cfset p_action = 'A'>
			<cfset ITS_msg = ITSWebservice(impref, p_action, arguments.frmstruct.ITSUsername, arguments.frmstruct.ITSPassword, arguments.frmstruct.ITSIntegrationID)>
		</cfif>
		<!--- END: ITS Webservice Integration --->
		<!--- Validation for Unauthorised users try to update on Transcore --->
		<cfif NOT structKeyExists(arguments.frmstruct,"loadBoard123") AND structKeyExists(arguments.frmstruct,"PostTo123LoadBoard")>
			<cfset msg2 = "There is a problem in logging to 123loadBoard">
		</cfif>
		
		<!--- BEGIN: 123 Loadboard Webservice Integration --->
		
		<cfif structKeyExists(arguments.frmstruct,"loadBoard123") and  arguments.frmstruct.loadBoard123 EQ 1 AND structKeyExists(arguments.frmstruct,"PostTo123LoadBoard")>
			<cfset p_action = 'A'>
			<cfset variables.postProviderid='LMGR428AP'>
			<cfset variables.postingLoad = postTo123LoadBoardWebservice(p_action,variables.postProviderid,arguments.frmstruct.loadBoard123Username, arguments.frmstruct.loadBoard123Password,impref,arguments.frmstruct.appDsn)>
			<cfset msg2 = variables.postingLoad>
		</cfif>
		<!--- insert LoadIFTAMiles table start --->
		<cfif structKeyExists(session,"empid")>
			<cfquery name="getProMileDetails" datasource="#Application.dsn#">
				select proMilesStatus from Employees
				where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#"> 
			</cfquery>
			<cfinvoke method="getSystemSetupOptions" returnvariable="request.qSystemSetupOptions">
			<cfif request.qSystemSetupOptions.googlemapspcmiler AND getProMileDetails.proMilesStatus>
				<cfset arguments.frmstruct.loadnumber = loadManualNo>
				<cfset responsePromiles=1>
				<cfif arguments.frmstruct.loadStatus neq "">
					<cfquery name="qryGetStatusText" datasource="#Application.dsn#">
						select CAST(left( lst.StatusText, charindex(' ',  lst.StatusText) - 1) AS float)  as statustext from loads ld
						left join LoadStatusTypes  lst on ld.StatusTypeID=lst.StatusTypeID
						where lst.StatusTypeID =<cfqueryparam value="#arguments.frmstruct.loadStatus#" cfsqltype="cf_sql_varchar">
						and ld.loadnumber=<cfqueryparam value="#arguments.frmstruct.loadnumber#" cfsqltype="cf_sql_integer">
						and IsNumeric(left(lst.StatusText, charindex(' ', lst.StatusText) - 1)) = 1 AND lst.StatusText IS NOT NULL  and left(lst.StatusText, charindex(' ', lst.StatusText) - 1) !='.'
						GROUP BY lst.StatusText
					</cfquery>
					<cfset variables.counter=1>
					<!--- Create a new three-column query, specifying the column data types --->
					<cfset qryGetStatusTextNumbersSet = QueryNew("statusNumberText","Double")> 
					<!--- Make two rows in the query --->
					<cfif qryGetStatusText.recordcount>
						<cfset QueryAddRow(qryGetStatusTextNumbersSet, qryGetStatusText.recordcount)> 
					<cfelse>
						<cfset QueryAddRow(qryGetStatusTextNumbersSet, 1)> 
					</cfif>
					<!--- Set the values of the cells in the query --->
					<cfif qryGetStatusText.recordcount>
						<cfloop query="qryGetStatusText">
							<cfset QuerySetCell(qryGetStatusTextNumbersSet, "statusNumberText", "#qryGetStatusText.statustext#",variables.counter)> 
							<cfset variables.counter++>
						</cfloop>
					<cfelse>
						<cfset QuerySetCell(qryGetStatusTextNumbersSet, "statusNumberText", "0",1)> 
					</cfif>
					<cfquery dbtype="query" name="qryGetStatusTextNumbersExtactMain">  
						select statusNumberText from qryGetStatusTextNumbersSet where statusNumberText between 1 and 8.9
					</cfquery>
				</cfif>
				<cfquery name="qryGetStatusNumbers" datasource="#application.dsn#">
					SELECT CAST(left(statustext, charindex(' ', statustext) - 1) AS float)  as statustext
					FROM LoadStatusTypes  
					WHERE IsNumeric(left(statustext, charindex(' ', statustext) - 1)) = 1 AND statustext IS NOT NULL  and left(statustext, charindex(' ', statustext) - 1) !='.'
					GROUP BY statustext
				</cfquery>
				<cfset variables.count=1>
				<!--- Create a new three-column query, specifying the column data types --->
				<cfset qryGetStatusTextNumbers = QueryNew("statusNumber","Double")> 
				<!--- Make two rows in the query --->
				<cfset QueryAddRow(qryGetStatusTextNumbers, qryGetStatusNumbers.recordcount)> 
				<!--- Set the values of the cells in the query --->
				<cfif qryGetStatusNumbers.recordcount>
					<cfloop query="qryGetStatusNumbers">
						<cfset QuerySetCell(qryGetStatusTextNumbers, "statusNumber", "#qryGetStatusNumbers.statustext#",variables.count)> 
						<cfset variables.count++>
					</cfloop>
				</cfif>	
				<cfquery dbtype="query" name="qryGetStatusTextNumbersExtact">  
					select statusNumber from qryGetStatusTextNumbers where statusNumber between 1 and 8.9
				</cfquery>
				<cfset variables.statuslist = "">
				<cfloop query="qryGetStatusTextNumbersExtact">
					<cfset variables.statuslist = ListAppend(variables.statuslist, val(qryGetStatusTextNumbersExtact.statusNumber), ",")>
				</cfloop>
				<cfif ListFindNoCase(variables.statuslist,qryGetStatusTextNumbersExtactMain.statusNumberText)>
					<cfinvoke component="#variables.objPromilesGatewayTest#" method="promilesCalculation" frmstruct="#arguments.frmstruct#" returnvariable="responsePromiles"/>
				</cfif>	
				<cfset variables.promilesRes=responsePromiles>
			</cfif>	
		</cfif>	
		<cfset Msg0='#LastLoadId#'&'~~'&'#Msg0#'&'~~'&'#Msg1#'&'~~'&ITS_msg&'~~'&msg2&'~~'&variables.promilesRes>	 
		<cfreturn Msg0>
	
</cffunction>

<cffunction name="getLoadStopAddress" access="public" returntype="query">
	<cfargument name="tablename" default="0">
	<cfargument name="address" default="0">
	<cfquery name="qLoadStopEmptyPickupAddressExists" datasource="#variables.dsn#">
		SELECT ID FROM #arguments.tablename#
		WHERE address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfreturn qLoadStopEmptyPickupAddressExists>
</cffunction>


</cfcomponent>