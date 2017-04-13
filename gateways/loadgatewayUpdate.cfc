<cfcomponent output="true" extends="loadgateway">
	<cfsetting showdebugoutput="true">
	<cffunction name="callLoadboardWebservice" access="public" returntype="any">
		<cfargument name="frmstruct" required="yes">
		<cfargument name="p_action" required="yes">
		<cfset variables.postProviderid='LMGR428AP'>
		<cfset var postLoadResponse = postTo123LoadBoardWebservice(arguments.p_action,variables.postProviderid,arguments.frmstruct.loadBoard123Username,arguments.frmstruct.loadBoard123Password,arguments.frmstruct.loadnumber,arguments.frmstruct.appDsn)>
		<cfreturn postLoadResponse>
	</cffunction>
	
	
	<cffunction name="getLoadStopAddress" access="public" returntype="query">
		<cfargument name="tablename" default="0">
		<cfargument name="address" default="0">
		<cfquery name="qLoadStopEmptyPickupAddressExists" datasource="#Application.dsn#">
			SELECT ID FROM #arguments.tablename#
			WHERE address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn qLoadStopEmptyPickupAddressExists>
	</cffunction>
	
	<cffunction name="getlastStopId" access="public" returntype="query">
		<cfargument name="ShipBlind" required="yes">
		<cfargument name="lastUpdatedShipCustomerID">
		<cfargument name="LastLoadId" required="yes">
		<cfargument name="frmstruct" required="yes">
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
		<CFSTOREDPROC PROCEDURE="USP_UpdateLoadStop" datasource="#Application.dsn#">              
			<CFPROCPARAM VALUE="#arguments.LastLoadId#" cfsqltype="CF_SQL_VARCHAR">
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
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupDate#" cfsqltype="CF_SQL_dATE" null="#yesNoFormat(NOT len(arguments.frmstruct.shipperPickupDate))#">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupTime#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeIn#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeOut#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.lastUpdatedShipCustomerID#" cfsqltype="CF_SQL_VARCHAR" null="#yesNoFormat(NOT len(arguments.lastUpdatedShipCustomerID))#">
			<CFPROCPARAM VALUE="#arguments.ShipBlind#" cfsqltype="CF_SQL_BIT">
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
			<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">
			<CFPROCPARAM VALUE="#variables.noOfDays1#" cfsqltype="CF_SQL_INTEGER" null="#yesNoFormat(NOT len(variables.noOfDays1))#">	
			<cfprocresult name="qLastInsertedShipper">
		</CFSTOREDPROC>
		<cfreturn qLastInsertedShipper>
	</cffunction>
	<cffunction name="InsertLoadAdd" access="public" returntype="any">
		<cfargument name="loadManualNo" required="yes">
		<cfargument name="posttoloadboard" required="yes">
		<cfargument name="posttoTranscore" required="yes">
		<cfargument name="PostTo123LoadBoard" required="yes">
		<cfargument name="carFlatRate" required="yes">
		<cfargument name="custFlatRate" required="yes">
		<cfargument name="custRatePerMile" required="yes">
		<cfargument name="carRatePerMile" required="yes">
		<cfargument name="CustomerMilesCalc" required="yes">
		<cfargument name="CarrierMilesCalc" required="yes">
		<cfargument name="ARExported" required="yes">
		<cfargument name="APExported" required="yes">
		<cfargument name="custMilesCharges" required="yes">
		<cfargument name="carMilesCharges" required="yes">
		<cfargument name="carCommodCharges" required="yes">
		<cfargument name="custCommodCharges" required="yes">
		<cfargument name="frmstruct" required="yes">
		<cfargument name="invoiceNumber" required="yes">
		<cfargument name="dsn" required="yes"> 
		
		<CFSTOREDPROC PROCEDURE="USP_InsertLoad" DATASOURCE="#arguments.dsn#"> 
			<CFPROCPARAM VALUE="#arguments.loadManualNo#" cfsqltype="cf_sql_integer">
			<CFPROCPARAM VALUE="#arguments.frmstruct.cutomerIdAutoValueContainer#" cfsqltype="CF_SQL_VARCHAR">
			<cfif isdefined('arguments.frmstruct.SALESPERSON') and len(arguments.frmstruct.SALESPERSON) gt 1>
				<CFPROCPARAM VALUE="#arguments.frmstruct.SALESPERSON#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR" null="true">
			</cfif>
			<cfif isdefined('arguments.frmstruct.CARRIERINVOICENUMBER') and val(arguments.frmstruct.CARRIERINVOICENUMBER) gt 0>
				<CFPROCPARAM VALUE="#arguments.frmstruct.CARRIERINVOICENUMBER#" cfsqltype="cf_sql_integer">
			<cfelse>
				<CFPROCPARAM VALUE="0" cfsqltype="cf_sql_integer" >
			</cfif>
			<cfif isdefined('arguments.frmstruct.dispatcher') and len(arguments.frmstruct.dispatcher) gt 1>
				<CFPROCPARAM VALUE="#arguments.frmstruct.dispatcher#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<CFPROCPARAM VALUE="#arguments.frmstruct.LOADSTATUS#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.posttoloadboard#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.posttoTranscore#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.PostTo123LoadBoard#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.notes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.dispatchnotes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.carriernotes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.pricingNotes#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.CUSTOMERPO#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerBOL#" cfsqltype="CF_SQL_VARCHAR">	
				<cfset totCarChg = replace(arguments.frmstruct.TotalCarrierCharges,'$',"")>
				<cfset totCustChg = replace(arguments.frmstruct.TotalCustomerCharges,'$',"")>	
				<CFPROCPARAM VALUE="#totCarChg#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#val(totCustChg)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#val(arguments.carFlatRate)#" cfsqltype="cf_sql_money">
				<CFPROCPARAM VALUE="#val(arguments.custFlatRate)#" cfsqltype="cf_sql_money">
			<cfif isdefined('arguments.frmstruct.carrierID') and len(trim(arguments.frmstruct.carrierID)) gt 1>
				<CFPROCPARAM VALUE="#trim(arguments.frmstruct.carrierID)#" cfsqltype="CF_SQL_VARCHAR">
			<cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<cfif isdefined('arguments.frmstruct.carrierOfficeID') and len(arguments.frmstruct.carrierOfficeID) gt 1>
				<CFPROCPARAM VALUE="#trim(arguments.frmstruct.carrierOfficeID)#" cfsqltype="CF_SQL_VARCHAR">
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
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupDate#" cfsqltype="cf_sql_date" null="#yesNoFormat(NOT len(arguments.frmstruct.shipperPickupDate))#">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperPickupTime#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeIn#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.shipperTimeOut#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupNO#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupDate#" cfsqltype="cf_sql_date" null="#yesNoFormat(NOT len(arguments.frmstruct.consigneePickupDate))#">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneePickupTime#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeTimeIn#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.consigneeTimeOut#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#session.adminUserName#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#cgi.REMOTE_ADDR#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#cgi.HTTP_USER_AGENT#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM value="#arguments.custRatePerMile#"  cfsqltype="cf_sql_money">
			<CFPROCPARAM value="#arguments.carRatePerMile#"  cfsqltype="cf_sql_money">
			<CFPROCPARAM value="#arguments.CustomerMilesCalc#"  cfsqltype="cf_sql_float">
			<CFPROCPARAM value="#arguments.CarrierMilesCalc#"  cfsqltype="cf_sql_float">
			<CFPROCPARAM VALUE="#session.officeid#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM value="#arguments.frmstruct.orderDate#" cfsqltype="cf_sql_date">
			<CFPROCPARAM value="#arguments.frmstruct.BillDate#" cfsqltype="cf_sql_date" null="#not len(arguments.frmstruct.BillDate)#">
			<CFPROCPARAM VALUE="#arguments.ARExported#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.APExported#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.custMilesCharges#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.carMilesCharges#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.custCommodCharges#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.carCommodCharges#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerAddress#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerCity#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerState#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerZipCode#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerContact#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerPhone#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerFax#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.customerCell#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#arguments.frmstruct.cutomerIdAuto#" cfsqltype="CF_SQL_VARCHAR">
			<CFPROCPARAM VALUE="#val(arguments.invoiceNumber)#" cfsqltype="CF_SQL_INTEGER">
			<cfif structkeyexists(arguments.frmstruct,"weightStop1") and isnumeric(arguments.frmstruct.weightStop1)>
				<CFPROCPARAM VALUE="#arguments.frmstruct.weightStop1#" cfsqltype="CF_SQL_INTEGER">
			<cfelse>	
				<CFPROCPARAM VALUE="0" cfsqltype="CF_SQL_INTEGER">
			</cfif>	
			<CFPROCRESULT NAME="qInsertedLoadID"> 
	   </CFSTOREDPROC>
	   <cfreturn qInsertedLoadID>
	</cffunction>  

	<cffunction name="UpdateLoadAddNew" access="public" returntype="any">
		<cfargument name="frmstruct" required="yes" type="struct">
		<cfargument name="lastInsertedStopId" required="yes">
		
			<cfquery name="qLoadStopIntermodalExportExists" datasource="#variables.dsn#">
				SELECT LoadStopID FROM LoadStopIntermodalExport
				WHERE LoadStopID = <cfqueryparam value="#lastInsertedStopId#" cfsqltype="cf_sql_varchar">
				AND StopNo = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfif qLoadStopIntermodalExportExists.recordcount>
				<cfquery name="qUpdateLoadStopIntermodalImport" datasource="#variables.dsn#">
					update LoadStopIntermodalExport
					set dateDispatched = <cfqueryparam value="#arguments.frmstruct.exportDateDispatched#" cfsqltype="cf_sql_date">,
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
						LoadStopID = <cfqueryparam value="#arguments.lastInsertedStopId#" cfsqltype="cf_sql_varchar"> AND 
						StopNo = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfquery name="qUpdateLoadStopIntermodalExport" datasource="#variables.dsn#">
					insert into LoadStopIntermodalExport(
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
							returnAddress)
					values(
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
							<cfqueryparam value="#arguments.frmstruct.exportReturnAddress#" cfsqltype="cf_sql_varchar">)
				</cfquery>
			</cfif>

		<cfreturn 1>
	</cffunction> 

</cfcomponent>