<cfcomponent output="false" extends="loadgateway">
<cfsetting showdebugoutput="false">

<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>

<!--- Edit Load--->
<cffunction name="EditLoad" access="public" returntype="any">
	<cfargument name="frmstruct" type="struct" required="yes">
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
		
		<cfinvoke method="RunUSP_UpdateLoad" frmstruct="#frmstruct#" returnvariable="LastLoadId"> 
		 <!---<cfset LastLoadId=qInsertedLoadID.LASTLOADID> --->
	  	    
		<!--- Editing Stop1 Shipper Details--->
		
		
				<cfif structKeyExists(arguments.frmstruct,"shipperFlag") and  arguments.frmstruct.shipperFlag eq 2>
					<cfset lastUpdatedShipCustomerID = arguments.frmstruct.shipperValueContainer>
					<cfinvoke method="getIsPayerStop" customerID="#lastUpdatedShipCustomerID#" returnvariable="qGetIsPayer">
					<cfif qGetIsPayer.recordcount AND NOT qGetIsPayer.isPayer>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="0" returnvariable="lastUpdatedShipCustomerID" />
					<cfelseif evaluate('arguments.frmstruct.shipperValueContainer') EQ "">
						<cfif not structKeyExists(variables,"objCustomerGateway")>
							<cfscript>
								variables.objCustomerGateway = #request.cfcpath#&".customergateway";
							</cfscript>
						</cfif>
						<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" returnvariable="shipperStruct" />	
						<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
						<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
					<cfelse>
						<cfset lastUpdatedShipCustomerID = arguments.frmstruct.shipperValueContainer>
					</cfif>
					<!---<cfif not variables.ispayer>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="0" returnvariable="lastUpdatedShipCustomerID" />
					</cfif>--->
				
				
				
				<cfelseif (structKeyExists(arguments.frmstruct,"shipperFlag") and  arguments.frmstruct.shipperFlag eq 1) AND arguments.frmstruct.shipperValueContainer eq "">
				<!--- Adding New Stop1 Shipper --->
					<cfscript>
						variables.objCustomerGateway = #request.cfcpath#&".customergateway";
					</cfscript>
					<cfset shipperStruct = {}>
					
				   <!--- If the  shipper is not selected through autosuggest then insert a new shipper --->				
				   <cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" returnvariable="shipperStruct" />	
					<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
					<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
				<cfelse>
					<!---
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
					--->
					<cfset lastUpdatedShipCustomerID = arguments.frmstruct.shipperValueContainer>
				</cfif>	
		
		
		<CFSTOREDPROC PROCEDURE="USP_UpdateLoadStop" DATASOURCE="#variables.dsn#"> 
             
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
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupDate#" cfsqltype="CF_SQL_dATE">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupTime#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeIn#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeOut#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#lastUpdatedShipCustomerID#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#ShipBlind#" cfsqltype="CF_SQL_BIT">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperNotes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperDirection#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="1" cfsqltype="CF_SQL_INTEGER">
			<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER"> <!--- Stop Number --->
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
			<cfprocresult name="qLastInsertedShipper">
		</CFSTOREDPROC>
		<cfset lastInsertedStopId = qLastInsertedShipper.lastStopID>
		
		<!--- IMPORT Load Stop Starts Here ---->
		<cfif structKeyExists(arguments.frmstruct,"dateDispatched")>
			<cfquery name="qLoadStopIntermodalImportExists" datasource="#variables.dsn#">
				SELECT LoadStopID FROM LoadStopIntermodalImport
				WHERE LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">
				AND StopNo = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfif qLoadStopIntermodalImportExists.recordcount>
				<cfquery name="qUpdateLoadStopIntermodalImport" datasource="#variables.dsn#">
					update 
						LoadStopIntermodalImport
					set
						dateDispatched = <cfqueryparam value="#arguments.frmstruct.dateDispatched#" cfsqltype="cf_sql_date">,
						steamShipLine = <cfqueryparam value="#arguments.frmstruct.steamShipLine#" cfsqltype="cf_sql_varchar">,
						eta = <cfqueryparam value="#arguments.frmstruct.eta#" cfsqltype="cf_sql_date">,
						oceanBillofLading = <cfqueryparam value="#arguments.frmstruct.oceanBillofLading#" cfsqltype="cf_sql_varchar">,
						actualArrivalDate = <cfqueryparam value="#arguments.frmstruct.actualArrivalDate#" cfsqltype="cf_sql_date">,
						seal = <cfqueryparam value="#arguments.frmstruct.seal#" cfsqltype="cf_sql_varchar">,
						customersReleaseDate = <cfqueryparam value="#arguments.frmstruct.customersReleaseDate#" cfsqltype="cf_sql_date">,
						vesselName = <cfqueryparam value="#arguments.frmstruct.vesselName#" cfsqltype="cf_sql_varchar">,
						freightReleaseDate = <cfqueryparam value="#arguments.frmstruct.freightReleaseDate#" cfsqltype="cf_sql_date">,
						dateAvailable = <cfqueryparam value="#arguments.frmstruct.dateAvailable#" cfsqltype="cf_sql_date">,
						demuggageFreeTimeExpirationDate = <cfqueryparam value="#arguments.frmstruct.demuggageFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						perDiemFreeTimeExpirationDate = <cfqueryparam value="#arguments.frmstruct.perDiemFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						pickupDate = <cfqueryparam value="#arguments.frmstruct.pickupDate#" cfsqltype="cf_sql_date">,
						requestedDeliveryDate = <cfqueryparam value="#arguments.frmstruct.requestedDeliveryDate#" cfsqltype="cf_sql_date">,
						requestedDeliveryTime = <cfqueryparam value="#arguments.frmstruct.requestedDeliveryTime#" cfsqltype="cf_sql_varchar">,
						scheduledDeliveryDate = <cfqueryparam value="#arguments.frmstruct.scheduledDeliveryDate#" cfsqltype="cf_sql_date">,
						scheduledDeliveryTime = <cfqueryparam value="#arguments.frmstruct.scheduledDeliveryTime#" cfsqltype="cf_sql_varchar">,
						unloadingDelayDetentionStartDate = <cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionStartDate#" cfsqltype="cf_sql_date">,
						unloadingDelayDetentionStartTime = <cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionStartTime#" cfsqltype="cf_sql_varchar">,
						actualDeliveryDate = <cfqueryparam value="#arguments.frmstruct.actualDeliveryDate#" cfsqltype="cf_sql_date">,
						unloadingDelayDetentionEndDate = <cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionEndDate#" cfsqltype="cf_sql_date">,
						unloadingDelayDetentionEndTime = <cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionEndTime#" cfsqltype="cf_sql_varchar">,
						returnDate = <cfqueryparam value="#arguments.frmstruct.returnDate#" cfsqltype="cf_sql_date">,
						pickUpAddress = <cfqueryparam value="#arguments.frmstruct.pickUpAddress#" cfsqltype="cf_sql_varchar">,
						deliveryAddress = <cfqueryparam value="#arguments.frmstruct.deliveryAddress#" cfsqltype="cf_sql_varchar">,
						emptyReturnAddress = <cfqueryparam value="#arguments.frmstruct.emptyReturnAddress#" cfsqltype="cf_sql_varchar">
					WHERE 
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar"> AND 
						StopNo = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
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
							<cfqueryparam value="#arguments.frmstruct.pickupDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.requestedDeliveryDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.requestedDeliveryTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.scheduledDeliveryDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.scheduledDeliveryTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionStartDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionStartTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.actualDeliveryDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionEndDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.unloadingDelayDetentionEndTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.returnDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.pickUpAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.deliveryAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.emptyReturnAddress#" cfsqltype="cf_sql_varchar">
						)
				</cfquery>
			</cfif>
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
			<cfquery name="qLoadStopIntermodalExportExists" datasource="#variables.dsn#">
				SELECT LoadStopID FROM LoadStopIntermodalExport
				WHERE LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">
				AND StopNo = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfif qLoadStopIntermodalExportExists.recordcount>
				<cfquery name="qUpdateLoadStopIntermodalImport" datasource="#variables.dsn#">
					update 
						LoadStopIntermodalExport
					set
						dateDispatched = <cfqueryparam value="#arguments.frmstruct.exportDateDispatched#" cfsqltype="cf_sql_date">,
						DateMtAvailableForPickup = <cfqueryparam value="#arguments.frmstruct.exportDateMtAvailableForPickup#" cfsqltype="cf_sql_date">,
						steamShipLine = <cfqueryparam value="#arguments.frmstruct.exportsteamShipLine#" cfsqltype="cf_sql_varchar">,
						DemurrageFreeTimeExpirationDate = <cfqueryparam value="#arguments.frmstruct.exportDemurrageFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						vesselName = <cfqueryparam value="#arguments.frmstruct.exportvesselName#" cfsqltype="cf_sql_varchar">,
						PerDiemFreeTimeExpirationDate = <cfqueryparam value="#arguments.frmstruct.exportPerDiemFreeTimeExpirationDate#" cfsqltype="cf_sql_date">,
						Voyage = <cfqueryparam value="#arguments.frmstruct.exportVoyage#" cfsqltype="cf_sql_varchar">,
						EmptyPickupDate = <cfqueryparam value="#arguments.frmstruct.exportEmptyPickupDate#" cfsqltype="cf_sql_date">,
						seal = <cfqueryparam value="#arguments.frmstruct.exportseal#" cfsqltype="cf_sql_varchar">,
						Booking = <cfqueryparam value="#arguments.frmstruct.exportBooking#" cfsqltype="cf_sql_varchar">,
						ScheduledLoadingDate = <cfqueryparam value="#arguments.frmstruct.exportScheduledLoadingDate#" cfsqltype="cf_sql_date">,
						ScheduledLoadingTime = <cfqueryparam value="#arguments.frmstruct.exportScheduledLoadingTime#" cfsqltype="cf_sql_varchar">,
						VesselCutoffDate = <cfqueryparam value="#arguments.frmstruct.exportVesselCutoffDate#" cfsqltype="cf_sql_date">,
						LoadingDate = <cfqueryparam value="#arguments.frmstruct.exportLoadingDate#" cfsqltype="cf_sql_date">,
						VesselLoadingWindow = <cfqueryparam value="#arguments.frmstruct.exportVesselLoadingWindow#" cfsqltype="cf_sql_varchar">,
						LoadingDelayDetectionStartDate = <cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionStartDate#" cfsqltype="cf_sql_date">,
						LoadingDelayDetectionStartTime = <cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionStartTime#" cfsqltype="cf_sql_varchar">,
						RequestedLoadingDate = <cfqueryparam value="#arguments.frmstruct.exportRequestedLoadingDate#" cfsqltype="cf_sql_date">,
						RequestedLoadingTime = <cfqueryparam value="#arguments.frmstruct.exportRequestedLoadingTime#" cfsqltype="cf_sql_varchar">,
						LoadingDelayDetectionEndDate = <cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionEndDate#" cfsqltype="cf_sql_date">,
						LoadingDelayDetectionEndTime = <cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionEndTime#" cfsqltype="cf_sql_varchar">,
						ETS = <cfqueryparam value="#arguments.frmstruct.exportETS#" cfsqltype="cf_sql_date">,
						ReturnDate = <cfqueryparam value="#arguments.frmstruct.exportReturnDate#" cfsqltype="cf_sql_date">,
						emptyPickupAddress = <cfqueryparam value="#arguments.frmstruct.exportEmptyPickupAddress#" cfsqltype="cf_sql_varchar">,
						loadingAddress = <cfqueryparam value="#arguments.frmstruct.exportLoadingAddress#" cfsqltype="cf_sql_varchar">,
						returnAddress = <cfqueryparam value="#arguments.frmstruct.exportReturnAddress#" cfsqltype="cf_sql_varchar">
					WHERE 
						LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar"> AND 
						StopNo = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
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
							<cfqueryparam value="#arguments.frmstruct.exportEmptyPickupDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportseal#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportBooking#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportScheduledLoadingDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportScheduledLoadingTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportVesselCutoffDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportLoadingDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportVesselLoadingWindow#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionStartDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionStartTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportRequestedLoadingDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportRequestedLoadingTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionEndDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportLoadingDelayDetectionEndTime#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportETS#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportReturnDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#arguments.frmstruct.exportEmptyPickupAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportLoadingAddress#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#arguments.frmstruct.exportReturnAddress#" cfsqltype="cf_sql_varchar">
						)
				</cfquery>
			</cfif>
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
		
		<!---
		<!---June 3 by Rojin--->
		<cfinvoke method="getPayerStop" stopID="#lastInsertedStopId#" returnvariable="qGetPayer">
		<cfif qGetPayer.recordcount AND NOT qGetPayer.isPayer>
			<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="0" returnvariable="lastUpdatedShipCustomerID" />
		</cfif>
		--->
	  	<!--- <cfset Msg_postev='1'> 
	  	<cfset Msg='1'>
	  	<cfset ITS_msg = '1'>
		<cfset lastInsertedStopId = qLastInsertedShipper.lastStopID>
	 	<!---pep CALL---->
		<cfif  structKeyExists(arguments.frmstruct,"integratewithPEP") and  #arguments.frmstruct.integratewithPEP# eq 1 and structKeyExists(arguments.frmstruct,"posttoloadboard")>
			<cfif arguments.frmstruct.loadStatus eq "c126b878-9db5-4411-be4d-61e93fab8c95">
				<cfset p_action='D'>
			<cfelse>
				<cfset p_action='U'>
			</cfif>
			<cfinvoke method="Posteverywhere" impref="#arguments.frmstruct.LoadNumber#" PEPcustomerKey="#arguments.frmstruct.PEPcustomerKey#" PEPsecretKey="#arguments.frmstruct.PEPsecretKey#" POSTACTION="#p_action#" returnvariable="request.postevrywhere" />
			<cfset Msg_postev=#request.postevrywhere#>
		</cfif> 
		<!---pep CALL----> 
		--->
		
		<!-----transcore 360 webservice Call-------->
		
		<!---
		<cfif  structKeyExists(arguments.frmstruct,"integratewithTran360") and  #arguments.frmstruct.integratewithTran360# eq 1 and structKeyExists(arguments.frmstruct,"posttoTranscore")>
			<!--- BEGIN: Trans360 webservice changes Date:23 Sep 2013 --->
			<!--- <cfif arguments.frmstruct.loadStatus eq "c126b878-9db5-4411-be4d-61e93fab8c95"  or arguments.frmstruct.loadStatus eq arguments.frmstruct.Triger_loadStatus >
				<cfset p_action='D'>
			<cfelse>
				<cfset p_action='U'>
			</cfif> --->
			<cfif structKeyExists(arguments.frmstruct,"IsTransCorePst") AND arguments.frmstruct.IsTransCorePst EQ 1 AND structKeyExists(arguments.frmstruct,"posttoTranscore")>
				<cfset p_action='U'>
			<cfelseif structKeyExists(arguments.frmstruct,"IsTransCorePst") AND arguments.frmstruct.IsTransCorePst EQ 0 AND structKeyExists(arguments.frmstruct,"posttoTranscore")>
				<cfset p_action='A'>
			</cfif>
			<!--- END: Trans360 webservice changes Date:23 Sep 2013 --->
			<cfinvoke method="Transcore360Webservice" impref="#arguments.frmstruct.loadManualNo#" trans360Usename="#arguments.frmstruct.trans360Usename#" trans360Password="#arguments.frmstruct.trans360Password#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
			<cfset Msg=#request.Transcore360Webservice#>
			<!-----if post transcore false and previous true---->
	   	<cfelseif  structKeyExists(arguments.frmstruct,"integratewithTran360") and  #arguments.frmstruct.integratewithTran360# eq 1 and not structKeyExists(arguments.frmstruct,"posttoTranscore") and structKeyExists(arguments.frmstruct,"Trancore_DeleteFlag") and  #arguments.frmstruct.Trancore_DeleteFlag# eq 1 > 
			<cfset p_action='D'>
			<cfinvoke method="Transcore360Webservice" impref="#arguments.frmstruct.loadManualNo#" trans360Usename="#arguments.frmstruct.trans360Usename#" trans360Password="#arguments.frmstruct.trans360Password#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
			<cfset Msg=#request.Transcore360Webservice#>
	    <cfelseif  structKeyExists(arguments.frmstruct,"integratewithTran360") and  #arguments.frmstruct.integratewithTran360# eq 1 and not structKeyExists(arguments.frmstruct,"posttoTranscore") and structKeyExists(arguments.frmstruct,"Trancore_DeleteFlag") and  #arguments.frmstruct.Trancore_DeleteFlag# eq 0 > 
			<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
				update Loads SET IsTransCorePst=1,Trans_Sucess_Flag=1 where LoadNumber=#arguments.frmstruct.loadManualNo# 
			</cfquery> 
			<!--- update Loads SET IsTransCorePst=1,Trans_Sucess_Flag=1 where LoadNumber=#arguments.frmstruct.LoadNumber# --->
		</cfif>
		--->
		<!---
		<cfif structKeyExists(arguments.frmstruct,"posttoTranscore") >
			<cfquery name="TransFlaginsert" datasource="#variables.dsn#">
				update Loads SET IsTransCorePst=1,Trans_Sucess_Flag=1 where LoadNumber=#arguments.frmstruct.loadManualNo# 
			</cfquery>
		</cfif>
		--->
		
		<!---
		<!--- Validation for Unauthorised users try to update on Transcore --->
		<cfif NOT structKeyExists(arguments.frmstruct,"integratewithTran360") AND structKeyExists(arguments.frmstruct,"posttoTranscore")>
			<cfset msg = "There is a problem in logging to Transcore">
		</cfif>
		
		<!--- BEGIN: ITS Webservice Integration --->
		<cfif structKeyExists(arguments.frmstruct,"integratewithITS") and  arguments.frmstruct.integratewithITS EQ 1 AND structKeyExists(arguments.frmstruct,"posttoITS")>
			<cfif structKeyExists(arguments.frmstruct,"IsITSPst") AND arguments.frmstruct.IsITSPst EQ 1>
				<cfset p_action = 'U'>
			<cfelse>
				<cfset p_action = 'A'>
			</cfif>
			<cfset ITS_msg = ITSWebservice(arguments.frmstruct.LoadNumber, p_action, arguments.frmstruct.ITSUsername, arguments.frmstruct.ITSPassword, arguments.frmstruct.ITSIntegrationID)>
		<cfelseif structKeyExists(arguments.frmstruct,"integratewithITS") and  arguments.frmstruct.integratewithITS EQ 1 AND structKeyExists(arguments.frmstruct,"IsITSPst") AND arguments.frmstruct.IsITSPst EQ 1 AND NOT structKeyExists(arguments.frmstruct,"posttoITS")>
			<cfset p_action = 'D'>
			<cfset ITS_msg = ITSWebservice(arguments.frmstruct.LoadNumber, p_action, arguments.frmstruct.ITSUsername, arguments.frmstruct.ITSPassword, arguments.frmstruct.ITSIntegrationID)>
		</cfif>
		<!--- END: ITS Webservice Integration --->

		
		<cfset Msg='#Msg_postev#'&'~~'&'#Msg#' & '~~' & ITS_msg>  ---> 
			 
		<!--- Editing Stop1 Consignee Details--->
			
		
			<cfif structKeyExists(arguments.frmstruct,"consigneeFlag") and  arguments.frmstruct.consigneeFlag eq 2>
				<!---<cfif not variables.ispayer>
					<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="0" returnvariable="lastUpdatedConsCustomerID" />
				</cfif>
				<cfset custToEditId = Evaluate('arguments.formStruct.#updateType#ValueContainer#stopNo#')>
				--->
				<cfset lastUpdatedConsCustomerID = arguments.frmstruct.consigneeValueContainer>
				<cfinvoke method="getIsPayerStop" customerID="#lastUpdatedConsCustomerID#" returnvariable="qGetIsPayer">
				<cfif qGetIsPayer.recordcount AND NOT qGetIsPayer.isPayer>
					<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="0" returnvariable="lastUpdatedConsCustomerID" />
				<cfelseif arguments.frmstruct.consigneeValueContainer EQ "">
					<cfif not structKeyExists(variables,"objCustomerGateway")>
						<cfscript>
							variables.objCustomerGateway = #request.cfcpath#&".customergateway";
						</cfscript>
					</cfif>
					<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" returnvariable="consigneeStruct" />
					<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
					<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
				<cfelse>
					<cfset lastUpdatedConsCustomerID = arguments.frmstruct.consigneeValueContainer>
				</cfif>				
			<cfelseif (structKeyExists(arguments.frmstruct,"consigneeFlag") and  arguments.frmstruct.consigneeFlag eq 1) AND arguments.frmstruct.consigneeValueContainer eq "">
			<!-----Add New Stop 1 Consignee-------->				
				<cfif not structKeyExists(variables,"objCustomerGateway")>
					<cfscript>
						variables.objCustomerGateway = #request.cfcpath#&".customergateway";
					</cfscript>
				</cfif>
		 
				<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" returnvariable="consigneeStruct" />
				<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
				<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
			<cfelse>
			
				<!---
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
				--->
				<cfset lastUpdatedConsCustomerID = arguments.frmstruct.consigneeValueContainer>
				
	  		</cfif>
  		
		<CFSTOREDPROC PROCEDURE="USP_UpdateLoadStop" DATASOURCE="#variables.dsn#"> 
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
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupDate#" cfsqltype="CF_SQL_dATE">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupTime#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneetimein#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneetimeout#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#lastUpdatedConsCustomerID#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#ConsBlind#" cfsqltype="CF_SQL_BIT">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeNotes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeDirection#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="2" cfsqltype="CF_SQL_INTEGER">
			<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER"> <!--- Stop Number --->
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
			<cfprocresult name="qLastInsertedConsignee">
		</CFSTOREDPROC>
		<cfset lastConsigneeStopId = qLastInsertedConsignee.lastStopID>
		<!---
		<!---June 3 by Rojin--->
		<cfinvoke method="getPayerStop" stopID="#lastConsigneeStopId#" returnvariable="qGetPayer">
		<cfif qGetPayer.recordcount AND NOT qGetPayer.isPayer>
			<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="0" returnvariable="lastUpdatedConsCustomerID" />
		</cfif>
		--->
		<!--- Update Load Items---->
		<cfloop from="1" to="7" index="Num">
			 
		     <cfset qty=VAL(evaluate("arguments.frmstruct.qty#num#"))>
			 <cfset unit=evaluate("arguments.frmstruct.unit#num#")>
			 <cfset description='evaluate("arguments.frmstruct.description#num#")'>
			 <cfset weight=VAL(evaluate("arguments.frmstruct.weight#num#"))>
			 <cfset class=evaluate("arguments.frmstruct.class#num#")>
			 <cfset CustomerRate=evaluate("arguments.frmstruct.CustomerRate#num#")>
			 <cfset CustomerRate = replace( CustomerRate,"$","","ALL") > 
			 <cfset CarrierRate=evaluate("arguments.frmstruct.CarrierRate#num#")>
			 <cfset CarrierRate = replace( CarrierRate,"$","","ALL") > 
			 <cfset custCharges =evaluate("arguments.frmstruct.custCharges#num#")>
			 <cfset custCharges = replace( custCharges,"$","","ALL") > 
			 <cfset carrCharges=evaluate("arguments.frmstruct.carrCharges#num#")>
			 <cfset carrCharges = replace( carrCharges,"$","","ALL") > 
			 <cfset CarrRateOfCustTotal =evaluate("arguments.frmstruct.CarrierPer#num#")>
			 <cfset CarrRateOfCustTotal = replace( CarrRateOfCustTotal,"%","","ALL") >
			 <cfif not IsNumeric(CarrRateOfCustTotal)>
				<cfset CarrRateOfCustTotal = 0>
			</cfif>
			 <cfif isdefined('arguments.frmstruct.isFee#num#')>
			 	<cfset isFee=true>
			 <cfelse>
			 	<cfset isFee=false>
			 </cfif>		
			 <CFSTOREDPROC PROCEDURE="USP_UpdateLoadItem" DATASOURCE="#variables.dsn#">
				<CFPROCPARAM VALUE="#lastInsertedStopId#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#num#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#val(qty)#" cfsqltype="CF_SQL_float">
				<CFPROCPARAM VALUE="#unit#" cfsqltype="CF_SQL_VarCHAR">
				<CFPROCPARAM VALUE="#description#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCPARAM VALUE="#weight#" cfsqltype="CF_SQL_float">
				<CFPROCPARAM VALUE="#class#" cfsqltype="CF_SQL_VARCHAR"> 
				<CFPROCPARAM VALUE="#Val(CustomerRate)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#Val(CarrierRate)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#val(custCharges)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#val(carrCharges)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#CarrRateOfCustTotal#" cfsqltype="cf_sql_decimal"> 
				<CFPROCPARAM VALUE="#isFee#" cfsqltype="CF_SQL_VARCHAR">
				<CFPROCRESULT NAME="qInsertedLoadItem">
			 	<CFPROCRESULT NAME="qInsertedLoadItem">
			</cfstoredproc>
		</cfloop>
	  		
		<!--- EDIT 2nd and further Stops --->
		<cfif val(arguments.frmstruct.totalStop) gt 1>
			<cfloop from="2" to="#val(arguments.frmstruct.totalStop)#" index="stpID">
			   <cfset request.qLoads = getAllLoads(loadid="#arguments.frmstruct.editid#",stopNo="#(stpID-1)#")>
			   <cfset stopNo=stpID-1>
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
				
				<cfquery name="qStopExists" datasource="#variables.dsn#">
					SELECT * FROM LoadStops
					WHERE LoadID = <cfqueryparam value="#frmstruct.editID#" cfsqltype="cf_sql_varchar">
					AND StopNo = <cfqueryparam value="#stopNo#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<cfif qStopExists.RecordCount EQ 0>
				<!--- Editing Next Stops Shipper Details --->
					<cfif structKeyExists(arguments.frmstruct,"shipperFlag#stpID#") and  evaluate("arguments.frmstruct.shipperFlag#stpID#") eq 2>
						<cfset lastUpdatedShipCustomerID = Evaluate("arguments.frmstruct.shipperValueContainer#stpID#")>
						<cfinvoke method="getIsPayerStop" customerID="#lastUpdatedShipCustomerID#" returnvariable="qGetIsPayer">
						<cfif qGetIsPayer.recordcount AND NOT qGetIsPayer.isPayer>
							<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="#stpID#" returnvariable="lastUpdatedShipCustomerID" />
						<cfelseif evaluate('arguments.frmstruct.shipperValueContainer#stpID#') EQ "">
							<cfif not structKeyExists(variables,"objCustomerGateway")>
								<cfscript>
									variables.objCustomerGateway = #request.cfcpath#&".customergateway";
								</cfscript>
							</cfif>
							<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" returnvariable="shipperStruct" />	
							<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
							<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
						<cfelse>
							<cfset lastUpdatedShipCustomerID = evaluate('arguments.frmstruct.shipperValueContainer#stpID#')>
						</cfif>	
					<cfelseif (structKeyExists(arguments.frmstruct,"shipperFlag#stpID#") and  evaluate("arguments.frmstruct.shipperFlag#stpID#") eq 1) AND evaluate('arguments.frmstruct.shipperValueContainer#stpID#') eq "">	
					<!----Adding New Shipper-------->	
						<cfif not structKeyExists(variables,"objCustomerGateway")>
							<cfscript>
								variables.objCustomerGateway = #request.cfcpath#&".customergateway";
							</cfscript>
						</cfif>
	 					<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" stop="#stpID#" returnvariable="shipperStruct" />	
						<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
						<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
				  	<cfelse>  
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

						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPickupNO1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPickupDate#stpID#')#" cfsqltype="CF_SQL_dATE">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPickupTime#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperTimeIn#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperTimeOut#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#lastUpdatedShipCustomerID#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#ShipBlind#" cfsqltype="CF_SQL_BIT">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperNotes#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperDirection#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="1" cfsqltype="CF_SQL_INTEGER">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperlocation#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperCity#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperStateName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperZipCode#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperContactPerson#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPhone#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperFax#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperEmail#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef2#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef3#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef4#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef5#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef6#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<!---<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">  Stop Number --->
						<cfprocresult name="qLastInsertedShipper">
					</CFSTOREDPROC>
					<cfset lastInsertedStopId = qLastInsertedShipper.lastStopID>
					<!---
					<!---June 3 by Rojin--->
					<cfinvoke method="getPayerStop" stopID="#lastInsertedStopId#" returnvariable="qGetPayer">
					<cfif qGetPayer.recordcount AND NOT qGetPayer.isPayer>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="#stpID#" returnvariable="lastUpdatedShipCustomerID" />
					</cfif>
					--->
					<!--- Editing  Next Stops Consignee Details--->
					<cfif structKeyExists(arguments.frmstruct,"consigneeFlag#stpID#") and  evaluate("arguments.frmstruct.consigneeFlag#stpID#") eq 2>
						<cfset lastUpdatedConsCustomerID = Evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>
						<cfinvoke method="getIsPayerStop" customerID="#lastUpdatedConsCustomerID#" returnvariable="qGetIsPayer">
						<cfif qGetIsPayer.recordcount AND NOT qGetIsPayer.isPayer>
							<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="#stpID#" returnvariable="lastUpdatedConsCustomerID" />
						<cfelseif evaluate('arguments.frmstruct.consigneeValueContainer#stpID#') EQ "">
							<cfif not structKeyExists(variables,"objCustomerGateway")>
								<cfscript>
									variables.objCustomerGateway = #request.cfcpath#&".customergateway";
								</cfscript>
							</cfif>
							<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" returnvariable="consigneeStruct" />	
							<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
							<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
						<cfelse>
							<cfset lastUpdatedConsCustomerID = evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>	
						</cfif>						
					<cfelseif (structKeyExists(arguments.frmstruct,"consigneeFlag#stpID#") and  evaluate("arguments.frmstruct.consigneeFlag#stpID#") eq 1) AND evaluate('arguments.frmstruct.consigneeValueContainer#stpID#') eq "">		
						<cfif not structKeyExists(variables,"objCustomerGateway")>
							<cfscript>
								variables.objCustomerGateway = #request.cfcpath#&".customergateway";
							</cfscript>
						</cfif>
	 
	   					<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" stop="#stpID#" returnvariable="consigneeStruct" />
						<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
						<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
				   <!--- <cfelse>
						<cfset lastUpdatedConsCustomerID =	evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>  
					</cfif> --->
					<cfelse>
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
							
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePickupNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePickupDate#stpID#')#" cfsqltype="CF_SQL_dATE">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePickupTime#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneetimein#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneetimeout#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#lastUpdatedConsCustomerID#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#ConsBlind#" cfsqltype="CF_SQL_BIT">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeNotes#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeDirection#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="2" cfsqltype="CF_SQL_INTEGER">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneelocation#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeCity#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeStateName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeZipCode#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeContactPerson#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePhone#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeFax#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeEmail#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef2#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef3#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef4#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef5#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef6#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<!---<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">  Stop Number --->
						<cfprocresult name="qLastInsertedConsignee">
					</CFSTOREDPROC>
					<cfset lastConsigneeStopId = qLastInsertedConsignee.lastStopID>
					<!---
					<!---June 3 by Rojin--->
					<cfinvoke method="getPayerStop" stopID="#lastConsigneeStopId#" returnvariable="qGetPayer">
					<cfif qGetPayer.recordcount AND NOT qGetPayer.isPayer>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="#stpID#" returnvariable="lastUpdatedConsCustomerID" />
					</cfif>
					--->
				<cfelse>
					<!--- Adding Stop1 Shipper --->
					<cfif structKeyExists(arguments.frmstruct,"shipperFlag#stpID#") and  evaluate("arguments.frmstruct.shipperFlag#stpID#") eq 2>
						
						<cfset lastUpdatedShipCustomerID = evaluate('arguments.frmstruct.shipperValueContainer#stpID#')>
						<cfinvoke method="getIsPayerStop" customerID="#lastUpdatedShipCustomerID#" returnvariable="qGetIsPayer">
						<cfif qGetIsPayer.recordcount AND NOT qGetIsPayer.isPayer>
							<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="#stpID#" returnvariable="lastUpdatedShipCustomerID" />
						<cfelseif evaluate('arguments.frmstruct.shipperValueContainer#stpID#') EQ "">
							<cfif not structKeyExists(variables,"objCustomerGateway")>
								<cfscript>
									variables.objCustomerGateway = #request.cfcpath#&".customergateway";
								</cfscript>
							</cfif>
							<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" returnvariable="shipperStruct" />	
							<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
							<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
						<cfelse>
							<cfset lastUpdatedShipCustomerID = evaluate("arguments.frmstruct.shipperValueContainer#stpID#")>
						</cfif>
					<cfelseif (structKeyExists(arguments.frmstruct,"shipperFlag#stpID#") and  evaluate("arguments.frmstruct.shipperFlag#stpID#") eq 1) AND evaluate('arguments.frmstruct.shipperValueContainer#stpID#') eq "">
						<cfif not structKeyExists(variables,"objCustomerGateway")>
							<cfscript>
								variables.objCustomerGateway = #request.cfcpath#&".customergateway";
							</cfscript>
						</cfif>
	 
						<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="shipper" stop="#stpID#" returnvariable="shipperStruct" />		
					   	<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#shipperStruct#" idReturn="true" returnvariable="addedShipperResult"/>
						<cfset lastUpdatedShipCustomerID = addedShipperResult.id>
				   	<cfelse>
			  			<cfset lastUpdatedShipCustomerID = evaluate("arguments.frmstruct.shipperValueContainer#stpID#")>
				  	</cfif>
					  
				  	<CFSTOREDPROC PROCEDURE="USP_UpdateLoadStop" DATASOURCE="#variables.dsn#"> 
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
							
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPickupNO1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPickupDate#stpID#')#" cfsqltype="CF_SQL_dATE">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPickupTime#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperTimeIn#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperTimeOut#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#lastUpdatedShipCustomerID#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#ShipBlind#" cfsqltype="CF_SQL_BIT">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperNotes#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperDirection#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="1" cfsqltype="CF_SQL_INTEGER">
						<CFPROCPARAM VALUE="#stopNo#" cfsqltype="CF_SQL_INTEGER"> <!--- Stop Number --->
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperlocation#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperCity#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperStateName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperZipCode#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperContactPerson#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperPhone#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperFax#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperEmail#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.shipperName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef2#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef3#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef4#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef5#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef6#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<cfprocresult name="qLastInsertedShipper">
					</CFSTOREDPROC>
					<cfset lastInsertedStopId = qLastInsertedShipper.lastStopID>
					<!---
					<!---June 3 by Rojin--->
					<cfinvoke method="getPayerStop" stopID="#lastInsertedStopId#" returnvariable="qGetPayer">
					<cfif qGetPayer.recordcount AND NOT qGetPayer.isPayer>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="shipper" stopNo="#stpID#" returnvariable="lastUpdatedShipCustomerID" />
					</cfif>
					--->
					<!--- Adding Stop1 Consignee --->
					<cfif structKeyExists(arguments.frmstruct,"consigneeFlag#stpID#") and  evaluate("arguments.frmstruct.consigneeFlag#stpID#") eq 2>
						<cfset lastUpdatedConsCustomerID = Evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>
						<cfinvoke method="getIsPayerStop" customerID="#lastUpdatedConsCustomerID#" returnvariable="qGetIsPayer">
						<cfif qGetIsPayer.recordcount AND NOT qGetIsPayer.isPayer>
							<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="#stpID#" returnvariable="lastUpdatedConsCustomerID" />
						<cfelseif evaluate('arguments.frmstruct.consigneeValueContainer#stpID#') EQ "">
							<cfif not structKeyExists(variables,"objCustomerGateway")>
								<cfscript>
									variables.objCustomerGateway = #request.cfcpath#&".customergateway";
								</cfscript>
							</cfif>
							<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" returnvariable="consigneeStruct" />	
							<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
							<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
						<cfelse>
							<cfset lastUpdatedConsCustomerID = evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>	
						</cfif>
					<cfelseif (structKeyExists(arguments.frmstruct,"consigneeFlag#stpID#") and  evaluate("arguments.frmstruct.consigneeFlag#stpID#") eq 1) AND evaluate('arguments.frmstruct.consigneeValueContainer#stpID#') eq "">
						<cfif not structKeyExists(variables,"objCustomerGateway")>
							<cfscript>
								variables.objCustomerGateway = #request.cfcpath#&".customergateway";
							</cfscript>
						</cfif>
	 
	   					<cfinvoke method="formCustStruct" frmstruct="#arguments.frmstruct#" type="consignee" stop="#stpID#" returnvariable="consigneeStruct" />
						<cfinvoke component ="#variables.objCustomerGateway#" method="AddCustomer" formStruct="#consigneeStruct#" idReturn="true" returnvariable="addedConsigneeResult"/>
						<cfset lastUpdatedConsCustomerID = addedConsigneeResult.id>
			   		<cfelse>
						<cfset lastUpdatedConsCustomerID =	evaluate("arguments.frmstruct.consigneeValueContainer#stpID#")>  
					</cfif>
						
					<CFSTOREDPROC PROCEDURE="USP_UpdateLoadStop" DATASOURCE="#variables.dsn#"> 
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
							
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePickupNo#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePickupDate#stpID#')#" cfsqltype="CF_SQL_dATE">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePickupTime#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneetimein#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneetimeout#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#lastUpdatedConsCustomerID#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#ConsBlind#" cfsqltype="CF_SQL_BIT">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeNotes#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeDirection#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="2" cfsqltype="CF_SQL_INTEGER">
						<CFPROCPARAM VALUE="#stopNo#" cfsqltype="CF_SQL_INTEGER"> <!--- Stop Number --->
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneelocation#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeCity#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeStateName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeZipCode#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeContactPerson#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneePhone#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeFax#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeEmail#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.consigneeName#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef1#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef2#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef3#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef4#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef5#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<CFPROCPARAM VALUE="#EVALUATE('arguments.frmstruct.userDef6#stpID#')#" cfsqltype="CF_SQL_VARCHAR">
						<cfprocresult name="qLastInsertedConsignee">
					</CFSTOREDPROC>
					<cfset lastConsigneeStopId = qLastInsertedConsignee.lastStopID>
					<!---
					<!---June 3 by Rojin--->
					<cfinvoke method="getPayerStop" stopID="#lastConsigneeStopId#" returnvariable="qGetPayer">
					<cfif qGetPayer.recordcount AND NOT qGetPayer.isPayer>
						<cfinvoke method="updateCustomer" formStruct="#arguments.frmstruct#" updateType="consignee" stopNo="#stpID#" returnvariable="lastUpdatedConsCustomerID" />
					</cfif>
					--->
				</cfif>
				
				<!--- IMPORT Load Stop Starts Here ---->
				<cfif structKeyExists(arguments.frmstruct,"dateDispatched#stpID#")>
					<cfquery name="qLoadStopIntermodalImportExists" datasource="#variables.dsn#">
						SELECT LoadStopID FROM LoadStopIntermodalImport
						WHERE LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">
						AND StopNo = <cfqueryparam value="#stpID#" cfsqltype="cf_sql_integer">
					</cfquery>
					
					<cfif qLoadStopIntermodalImportExists.recordcount>
						<cfquery name="qUpdateLoadStopIntermodalImport" datasource="#variables.dsn#">
							update 
								LoadStopIntermodalImport
							set
								dateDispatched = <cfqueryparam value="#EVALUATE('arguments.frmstruct.dateDispatched#stpID#')#" cfsqltype="cf_sql_date">,
								steamShipLine = <cfqueryparam value="#EVALUATE('arguments.frmstruct.steamShipLine#stpID#')#" cfsqltype="cf_sql_varchar">,
								eta = <cfqueryparam value="#EVALUATE('arguments.frmstruct.eta#stpID#')#" cfsqltype="cf_sql_date">,
								oceanBillofLading = <cfqueryparam value="#EVALUATE('arguments.frmstruct.oceanBillofLading#stpID#')#" cfsqltype="cf_sql_varchar">,
								actualArrivalDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.actualArrivalDate#stpID#')#" cfsqltype="cf_sql_date">,
								seal = <cfqueryparam value="#EVALUATE('arguments.frmstruct.seal#stpID#')#" cfsqltype="cf_sql_varchar">,
								customersReleaseDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.customersReleaseDate#stpID#')#" cfsqltype="cf_sql_date">,
								vesselName = <cfqueryparam value="#EVALUATE('arguments.frmstruct.vesselName#stpID#')#" cfsqltype="cf_sql_varchar">,
								freightReleaseDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.freightReleaseDate#stpID#')#" cfsqltype="cf_sql_date">,
								dateAvailable = <cfqueryparam value="#EVALUATE('arguments.frmstruct.dateAvailable#stpID#')#" cfsqltype="cf_sql_date">,
								demuggageFreeTimeExpirationDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.demuggageFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								perDiemFreeTimeExpirationDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.perDiemFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								pickupDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.pickupDate#stpID#')#" cfsqltype="cf_sql_date">,
								requestedDeliveryDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.requestedDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
								requestedDeliveryTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.requestedDeliveryTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								scheduledDeliveryDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.scheduledDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
								scheduledDeliveryTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.scheduledDeliveryTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								unloadingDelayDetentionStartDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionStartDate#stpID#')#" cfsqltype="cf_sql_date">,
								unloadingDelayDetentionStartTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionStartTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								actualDeliveryDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.actualDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
								unloadingDelayDetentionEndDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionEndDate#stpID#')#" cfsqltype="cf_sql_date">,
								unloadingDelayDetentionEndTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionEndTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								returnDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.returnDate#stpID#')#" cfsqltype="cf_sql_date">,
								pickUpAddress = <cfqueryparam value="#EVALUATE('arguments.frmstruct.pickUpAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								deliveryAddress = <cfqueryparam value="#EVALUATE('arguments.frmstruct.deliveryAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								emptyReturnAddress = <cfqueryparam value="#EVALUATE('arguments.frmstruct.emptyReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">	
							WHERE 
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar"> AND 
								StopNo = <cfqueryparam value="#stpID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
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
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.pickupDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.requestedDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.requestedDeliveryTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.scheduledDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.scheduledDeliveryTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionStartDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionStartTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.actualDeliveryDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionEndDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.unloadingDelayDetentionEndTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.returnDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.pickUpAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.deliveryAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.emptyReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">
								)
						</cfquery>
					</cfif>
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
					<cfquery name="qLoadStopIntermodalExportExists" datasource="#variables.dsn#">
						SELECT LoadStopID FROM LoadStopIntermodalExport
						WHERE LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">
						AND StopNo = <cfqueryparam value="#stpID#" cfsqltype="cf_sql_integer">
					</cfquery>
					
					<cfif qLoadStopIntermodalExportExists.recordcount>
						<cfquery name="qUpdateLoadStopIntermodalExport" datasource="#variables.dsn#">
							update 
								LoadStopIntermodalExport
							set
								dateDispatched = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportDateDispatched#stpID#')#" cfsqltype="cf_sql_date">,
								DateMtAvailableForPickup = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportDateMtAvailableForPickup#stpID#')#" cfsqltype="cf_sql_date">,
								steamShipLine = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportsteamShipLine#stpID#')#" cfsqltype="cf_sql_varchar">,
								DemurrageFreeTimeExpirationDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportDemurrageFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								vesselName = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportvesselName#stpID#')#" cfsqltype="cf_sql_varchar">,
								PerDiemFreeTimeExpirationDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportPerDiemFreeTimeExpirationDate#stpID#')#" cfsqltype="cf_sql_date">,
								Voyage = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVoyage#stpID#')#" cfsqltype="cf_sql_varchar">,
								EmptyPickupDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportEmptyPickupDate#stpID#')#" cfsqltype="cf_sql_date">,
								seal = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportseal#stpID#')#" cfsqltype="cf_sql_varchar">,
								Booking = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportBooking#stpID#')#" cfsqltype="cf_sql_varchar">,
								ScheduledLoadingDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportScheduledLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
								ScheduledLoadingTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportScheduledLoadingTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								VesselCutoffDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVesselCutoffDate#stpID#')#" cfsqltype="cf_sql_date">,
								LoadingDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
								VesselLoadingWindow = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVesselLoadingWindow#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadingDelayDetectionStartDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionStartDate#stpID#')#" cfsqltype="cf_sql_date">,
								LoadingDelayDetectionStartTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionStartTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								RequestedLoadingDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportRequestedLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
								RequestedLoadingTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportRequestedLoadingTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								LoadingDelayDetectionEndDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionEndDate#stpID#')#" cfsqltype="cf_sql_date">,
								LoadingDelayDetectionEndTime = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionEndTime#stpID#')#" cfsqltype="cf_sql_varchar">,
								ETS = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportETS#stpID#')#" cfsqltype="cf_sql_date">,
								ReturnDate = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnDate#stpID#')#" cfsqltype="cf_sql_date">,
								emptyPickupAddress = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportEmptyPickupAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								loadingAddress = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
								returnAddress = <cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">
							WHERE 
								LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar"> AND 
								StopNo = <cfqueryparam value="#stpID#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelse>
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
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportScheduledLoadingTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVesselCutoffDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportVesselLoadingWindow#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionStartDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionStartTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportRequestedLoadingDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportRequestedLoadingTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionEndDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingDelayDetectionEndTime#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportETS#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnDate#stpID#')#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportEmptyPickupAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportLoadingAddress#stpID#')#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EVALUATE('arguments.frmstruct.exportReturnAddress#stpID#')#" cfsqltype="cf_sql_varchar">
								)
						</cfquery>
					</cfif>
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
				<cfloop from="1" to="7" index="Num">
					<cfset qty=evaluate("arguments.frmstruct.qty#num##stpID#")>
					<cfset unit=evaluate("arguments.frmstruct.unit#num##stpID#")>
					<cfset description=evaluate("arguments.frmstruct.description#num##stpID#")>
					<cfset weight=VAL(evaluate("arguments.frmstruct.weight#num##stpID#"))>
					<cfset class=evaluate("arguments.frmstruct.class#num##stpID#")>
					<cfset CustomerRate=evaluate("arguments.frmstruct.CustomerRate#num##stpID#")>
					<cfset CustomerRate = replace( CustomerRate,"$","","ALL") > 
					<cfset CarrierRate=evaluate("arguments.frmstruct.CarrierRate#num##stpID#")>
					<cfset CarrierRate = replace( CarrierRate,"$","","ALL") > 
					<cfset custCharges=evaluate("arguments.frmstruct.custCharges#num##stpID#")>
					<cfset custCharges = replace( custCharges,"$","","ALL") > 
					<cfset carrCharges=evaluate("arguments.frmstruct.carrCharges#num##stpID#")>
					<cfset carrCharges = replace( carrCharges,"$","","ALL") > 
					<cfset CarrRateOfCustTotal =evaluate("arguments.frmstruct.CarrierPer#num##stpID#")>
					<cfset CarrRateOfCustTotal = replace( CarrRateOfCustTotal,"%","","ALL") > 
					<cfif not IsNumeric(CarrRateOfCustTotal)>
						<cfset CarrRateOfCustTotal = 0>
					</cfif>
					<cfif isdefined('arguments.frmstruct.isFee#num##stpID#')>
						<cfset isFee=true>
					<cfelse>
						<cfset isFee=false>
					</cfif>
					 <cfif qStopExists.RecordCount EQ 0>
						 <CFSTOREDPROC PROCEDURE="USP_InsertLoadItem" DATASOURCE="#variables.dsn#"> 
							<CFPROCPARAM VALUE="#lastInsertedStopId#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCPARAM VALUE="#num#" cfsqltype="cf_sql_bigint">
							<CFPROCPARAM VALUE="#val(qty)#" cfsqltype="cf_sql_decimal">
							<CFPROCPARAM VALUE="#unit#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCPARAM VALUE="#description#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCPARAM VALUE="#weight#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCPARAM VALUE="#class#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCPARAM VALUE="#CustomerRate#" cfsqltype="cf_sql_decimal">
							<CFPROCPARAM VALUE="#CarrierRate#" cfsqltype="cf_sql_decimal">
							<CFPROCPARAM VALUE="#val(custCharges)#" cfsqltype="cf_sql_money">
							<CFPROCPARAM VALUE="#val(carrCharges)#" cfsqltype="cf_sql_money">
							<CFPROCPARAM VALUE="#CarrRateOfCustTotal#" cfsqltype="cf_sql_decimal">
							<CFPROCPARAM VALUE="#isFee#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCRESULT NAME="qInsertedLoadItem">
						</cfstoredproc>
					<cfelse>
						<CFSTOREDPROC PROCEDURE="USP_UpdateLoadItem" DATASOURCE="#variables.dsn#"> 
							<CFPROCPARAM VALUE="#lastInsertedStopId#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCPARAM VALUE="#num#" cfsqltype="CF_SQL_VARCHAR">
							<CFPROCPARAM VALUE="#val(qty)#" cfsqltype="CF_SQL_float">
							<CFPROCPARAM VALUE="#unit#" cfsqltype="CF_SQL_VarCHAR">
							<CFPROCPARAM VALUE="#description#" cfsqltype="CF_SQL_VARCHAR">
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
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>	

	<!--- Web service calls begins from here --->
	<cfset Msg_postev='1'> 
	<cfset Msg='1'>
	<cfset ITS_msg = '1'>
	
	<!-----------pep CALL---->
	<cfif  structKeyExists(arguments.frmstruct,"integratewithPEP") and  #arguments.frmstruct.integratewithPEP# eq 1 and structKeyExists(arguments.frmstruct,"posttoloadboard")>
		<cfif arguments.frmstruct.loadStatus eq "c126b878-9db5-4411-be4d-61e93fab8c95">
			<cfset p_action='D' />
		<cfelse>
			<cfset p_action='U' />
		</cfif>
		<cfinvoke method="Posteverywhere" impref="#arguments.frmstruct.LoadNumber#" PEPcustomerKey="#arguments.frmstruct.PEPcustomerKey#" PEPsecretKey="#arguments.frmstruct.PEPsecretKey#" POSTACTION="#p_action#" returnvariable="request.postevrywhere" />
		<cfset Msg_postev=#request.postevrywhere# />
	</cfif>
	<!-----------pep CALL---->

	<!-----transcore 360 webservice Call-------->

	<cfif  structKeyExists(arguments.frmstruct,"integratewithTran360") and  #arguments.frmstruct.integratewithTran360# eq 1 and structKeyExists(arguments.frmstruct,"posttoTranscore")>
		<!--- BEGIN: Trans360 webservice changes Date:23 Sep 2013 --->
		<!--- <cfif arguments.frmstruct.loadStatus eq "c126b878-9db5-4411-be4d-61e93fab8c95"  or arguments.frmstruct.loadStatus eq arguments.frmstruct.Triger_loadStatus >
			<cfset p_action='D'>
		<cfelse>
			<cfset p_action='U'>
		</cfif> --->
	<cfif structKeyExists(arguments.frmstruct,"IsTransCorePst") AND arguments.frmstruct.IsTransCorePst EQ 1 AND structKeyExists(arguments.frmstruct,"posttoTranscore")>
		
		<cfset p_action='U'>
		<cfif arguments.frmstruct.loadManualNo neq arguments.frmstruct.LoadNumber>
			<cfset p_action='A'>
		</cfif>
	
	<cfelseif structKeyExists(arguments.frmstruct,"IsTransCorePst") AND arguments.frmstruct.IsTransCorePst EQ 0 AND structKeyExists(arguments.frmstruct,"posttoTranscore")>
		<cfset p_action='A'>
	</cfif>
	
		
	
	
	
		<!--- END: Trans360 webservice changes Date:23 Sep 2013 --->
		<cfinvoke method="Transcore360Webservice" impref="#arguments.frmstruct.loadManualNo#" trans360Usename="#arguments.frmstruct.trans360Usename#" trans360Password="#arguments.frmstruct.trans360Password#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
		<cfset Msg=#request.Transcore360Webservice#>
		<!-----if post transcore false and previous true---->
	 	<cfelseif  structKeyExists(arguments.frmstruct,"integratewithTran360") and  #arguments.frmstruct.integratewithTran360# eq 1 and not structKeyExists(arguments.frmstruct,"posttoTranscore") and structKeyExists(arguments.frmstruct,"Trancore_DeleteFlag") and  #arguments.frmstruct.Trancore_DeleteFlag# eq 1 > 
		<cfset p_action='D'>
		<cfinvoke method="Transcore360Webservice" impref="#arguments.frmstruct.loadManualNo#" trans360Usename="#arguments.frmstruct.trans360Usename#" trans360Password="#arguments.frmstruct.trans360Password#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
		<cfset Msg=#request.Transcore360Webservice#>
		<cfelseif  structKeyExists(arguments.frmstruct,"integratewithTran360") and  #arguments.frmstruct.integratewithTran360# eq 1 and not structKeyExists(arguments.frmstruct,"posttoTranscore") and structKeyExists(arguments.frmstruct,"Trancore_DeleteFlag") and  #arguments.frmstruct.Trancore_DeleteFlag# eq 0 > 
		
		 
	</cfif>
		
		<!--- Validation for Unauthorised users try to update on Transcore --->
	<cfif NOT structKeyExists(arguments.frmstruct,"integratewithTran360") AND structKeyExists(arguments.frmstruct,"posttoTranscore")>
		<cfset msg = "There is a problem in logging to Transcore">
	</cfif>
		
	<!--- BEGIN: ITS Webservice Integration --->
	<!--- add by sp --->
	<cfset variables.loadNumber ="">
	<cfif StructKeyExists(form,"loadManualNo")>
		<cfset variables.loadNumber = form.loadManualNo>
	</cfif>
	<!--- add by sp --->
	
	<cfif structKeyExists(arguments.frmstruct,"integratewithITS") and  arguments.frmstruct.integratewithITS EQ 1 AND structKeyExists(arguments.frmstruct,"posttoITS")>
		<cfif structKeyExists(arguments.frmstruct,"IsITSPst") AND arguments.frmstruct.IsITSPst EQ 1>
			<cfset p_action = 'U'>
		<cfelse>
			<cfset p_action = 'A'>
		</cfif>
		<!--- change by sp --->
		<cfset ITS_msg = ITSWebservice(arguments.frmstruct.LoadNumber, p_action, arguments.frmstruct.ITSUsername, arguments.frmstruct.ITSPassword, arguments.frmstruct.ITSIntegrationID,variables.loadNumber)>
		<!--- change by sp --->
	<cfelseif structKeyExists(arguments.frmstruct,"integratewithITS") and  arguments.frmstruct.integratewithITS EQ 1 AND structKeyExists(arguments.frmstruct,"IsITSPst") AND arguments.frmstruct.IsITSPst EQ 1 AND NOT structKeyExists(arguments.frmstruct,"posttoITS")>
		<cfset p_action = 'D'>
		<cfset ITS_msg = ITSWebservice(arguments.frmstruct.LoadNumber, p_action, arguments.frmstruct.ITSUsername, arguments.frmstruct.ITSPassword, arguments.frmstruct.ITSIntegrationID,variables.loadNumber)>
	</cfif>
	<!--- END: ITS Webservice Integration --->

	<cfset Msg='#Msg_postev#'&'~~'&'#Msg#' & '~~' & ITS_msg>
	<cfreturn Msg>
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