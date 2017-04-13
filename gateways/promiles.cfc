<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="yes" />
		<cfset variables.dsn = Application.dsn />
	</cffunction>

	<!--- insert IFT Miles function --->
	<cffunction name="insertLoadIFTAMiles" access="public" returntype="void" >
		<cfargument name="loadNum" type="any">
		<cfargument name="NonTollMiles" default="0">
		<cfargument name="TollMiles" default="0">
		<cfargument name="TotalMiles" default="0">
		<cfargument name="State" default="">
		<cfargument name="datasource" default="">
		<cfargument name="loadid" default="">
		<cfquery name="qryInsertLoadIFTAMiles" datasource="#arguments.datasource#">
			insert into LoadIFTAMiles
			(
				loadNumber,
				tollMiles,
				nonTollMiles,
				totalMiles,
				state,
				dateCreated,
				loadid
			) 
			VALUES
			(
				<cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#arguments.tollMiles#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#arguments.nonTollMiles#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#arguments.totalMiles#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#arguments.loadid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		
	</cffunction>

	<!--- delete IFT Miles function --->
	<cffunction name="deleteLoadIFTAMiles" access="public" returntype="void" >
		<cfargument name="datasource" default="">
		<cfargument name="loadNum" type="any" required="true">
		<cfquery name="qryDeleteLoadIFTAMiles" datasource="#arguments.datasource#">
			delete from 
				LoadIFTAMiles 
			where 
				loadNumber = <cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>

	<cffunction name="promilesCalculation" access="public" returntype="any">
		<cfargument name="frmstruct" type="struct" required="yes">
		<!---statusnumber getting from load calculation start--->
		<cfif arguments.frmstruct.loadStatus neq "">
			<cfquery name="qryGetStatusText" datasource="#Application.dsn#">
				select CAST(left( lst.StatusText, charindex(' ',  lst.StatusText) - 1) AS float)  as statustext from loads ld
				left join LoadStatusTypes  lst on ld.StatusTypeID=lst.StatusTypeID
				where lst.StatusTypeID =<cfqueryparam value="#arguments.frmstruct.loadStatus#" cfsqltype="cf_sql_varchar">
				and ld.loadnumber=<cfqueryparam value="#arguments.frmstruct.loadnumber#" cfsqltype="cf_sql_integer">
				and IsNumeric(left(lst.StatusText, charindex(' ', lst.StatusText) - 1)) = 1 AND lst.StatusText IS NOT NULL  and left(lst.StatusText, charindex(' ', lst.StatusText) - 1) !='.'
				GROUP BY lst.StatusText
			</cfquery>
		</cfif>
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
		<!---statusnumber getting from load calculation end--->
		
		<!---list of status number getting start--->
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
		<!---list of status number getting End--->
		<cfif structKeyExists(session,"empid")>
			<cfquery name="getProMileDetails" datasource="#Application.dsn#">
					select PCMilerUsername,PCMilerPassword,companyCode from Employees
					where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#"> 
			</cfquery>
		</cfif>
		<cfif getProMileDetails.recordcount>
			<cfset variables.Username=getProMileDetails.PCMilerUsername>
			<cfset variables.Password=getProMileDetails.PCMilerPassword>
			<cfset variables.CompanyCode=getProMileDetails.companyCode>
		</cfif>
		
			<cfif isdefined("arguments.frmstruct.shipperAddressLocation1")>
				<cfif not len(trim(Evaluate("arguments.frmstruct.shipperAddressLocation1")))>
					<cfif len(trim(arguments.frmstruct.SHIPPERCITY)) and len(trim(arguments.frmstruct.SHIPPERSTATE)) and len(trim(arguments.frmstruct.SHIPPERZIPCODE))>
						<cfset arguments.frmstruct.shipperAddressLocation1 = '#arguments.frmstruct.SHIPPERCITY#, #arguments.frmstruct.SHIPPERSTATE# #arguments.frmstruct.SHIPPERZIPCODE#'>
					</cfif>	
				</cfif>
			</cfif>
			
		<cfloop from="2" to="10" index="i">
			<cfif isdefined("arguments.frmstruct.shipperAddressLocation#i#")>
				<cfif not len(trim(Evaluate("arguments.frmstruct.shipperAddressLocation#i#")))>
					<cfif len(trim(Evaluate("arguments.frmstruct.SHIPPERCITY#i#"))) and len(trim(Evaluate("arguments.frmstruct.SHIPPERSTATE#i#"))) and len(trim(Evaluate("arguments.frmstruct.SHIPPERZIPCODE#i#")))>
						<cfset variables.shippercity=Evaluate("arguments.frmstruct.SHIPPERCITY#i#")>
						<cfset variables.shipperstate=Evaluate("arguments.frmstruct.shipperstate#i#")>
						<cfset variables.shipperzipcode=Evaluate("arguments.frmstruct.shipperzipcode#i#")>
						<cfset Evaluate( "arguments.frmstruct.shipperAddressLocation#i# = '#variables.shippercity#, #variables.shipperstate# #variables.shipperzipcode#'")>
					</cfif>	
				</cfif>
			</cfif>
		</cfloop>
		<cfif isdefined("arguments.frmstruct.consigneeAddressLocation1")>
			<cfif not len(trim(Evaluate("arguments.frmstruct.consigneeAddressLocation1")))>
				<cfif len(trim(arguments.frmstruct.CONSIGNEECITY)) and len(trim(arguments.frmstruct.CONSIGNEESTATE)) and len(trim(arguments.frmstruct.CONSIGNEEZIPCODE))>
					<cfset arguments.frmstruct.consigneeAddressLocation1 = '#arguments.frmstruct.CONSIGNEECITY#, #arguments.frmstruct.CONSIGNEESTATE# #arguments.frmstruct.CONSIGNEEZIPCODE#'>
				</cfif>	
			</cfif>
		</cfif>
		<cfloop from="2" to="10" index="i">
			<cfif isdefined("arguments.frmstruct.consigneeAddressLocation#i#")>
				<cfif not len(trim(Evaluate("arguments.frmstruct.consigneeAddressLocation#i#")))>
					<cfif len(trim(Evaluate("arguments.frmstruct.CONSIGNEECITY#i#"))) and len(trim(Evaluate("arguments.frmstruct.CONSIGNEESTATE#i#"))) and len(trim(Evaluate("arguments.frmstruct.CONSIGNEEZIPCODE#i#")))>
						<cfset variables.CONSIGNEECITY=Evaluate("arguments.frmstruct.CONSIGNEECITY#i#")>
						<cfset variables.CONSIGNEESTATE=Evaluate("arguments.frmstruct.CONSIGNEESTATE#i#")>
						<cfset variables.CONSIGNEEZIPCODE=Evaluate("arguments.frmstruct.CONSIGNEEZIPCODE#i#")>
						<cfset Evaluate( "arguments.frmstruct.consigneeAddressLocation#i# = '#variables.CONSIGNEECITY#, #variables.CONSIGNEESTATE# #variables.CONSIGNEEZIPCODE#'")>
					</cfif>	
				</cfif>
			</cfif>
		</cfloop>

		<cfset local.ProMilesUnitID = "">
		<cfif structKeyExists(session, "allinfo") and structKeyExists(session.allinfo, "LoadID") and len(session.allinfo.LoadID)>
			<cfquery name="qGetProMilesUnitID" datasource="#Application.dsn#">
					SELECT 	l.LoadNumber, 
							l.LoadID, 
							Eq.ProMilesUnitID, 
							Ls.LoadType, 
							Ls.StopNo
					FROM Loads l
					INNER JOIN LoadStops Ls ON l.LoadID = Ls.LoadID 
					INNER JOIN Equipments Eq ON Ls.NewEquipmentID = Eq.EquipmentID
					WHERE Ls.LoadType = 1 
					AND Ls.StopNo = 0
					AND l.LoadID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.allinfo.LoadID#"> 
			</cfquery>
		</cfif>
		<cfif qGetProMilesUnitID.recordcount>
			<cfset local.ProMilesUnitID = qGetProMilesUnitID.ProMilesUnitID>
		</cfif>

		<cfoutput>
			<cfsavecontent variable="myVariable">
				<?xml version="1.0" encoding="utf-8"?>
				<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
					<soap:Body>
						<RunTrip xmlns="http://promiles.com/">
							<c>
								<Username>#variables.Username#</Username>
								<Password>#variables.Password#</Password>
								<CompanyCode>#variables.CompanyCode#</CompanyCode>
							</c>
							<Trip>
								<Options>
									<Routing>
										<RoutingMethod>PRACTICAL</RoutingMethod>
										<SpeedOverrides xsi:nil="true" />
										<BorderOpen>0</BorderOpen>
										<DoRouteOptimization>1</DoRouteOptimization>
										<RouteOptimizationMethod>NO_OPTIMIZATION</RouteOptimizationMethod>
										<IsHUBMode>0</IsHUBMode>
										<IsHazmat>0</IsHazmat>
										<AvoidTollRoads>0</AvoidTollRoads>
										<AllowRelaxRestrictions>1</AllowRelaxRestrictions>
									</Routing>
								</Options>
								<FuelPurchases>
									<FuelPurchase>
										<PurchaseState>#arguments.frmstruct.consigneecity#, #arguments.frmstruct.consigneestate# #arguments.frmstruct.consigneezipcode#</PurchaseState>										
										<AmountPurchased>0.0</AmountPurchased>
										<IsLiters>1</IsLiters>
										<Station></Station>
										<City>#arguments.frmstruct.shippercity#, #arguments.frmstruct.shipperstate# #arguments.frmstruct.shipperzipcode#</City>
										<Invoice></Invoice>
										<FuelCost>0.0</FuelCost>
										<TypeOfFuel>DIESEL</TypeOfFuel>
									</FuelPurchase>
								</FuelPurchases>
								<TripLegs>
									<cfif isdefined("arguments.frmstruct.shipperAddressLocation1")>
										<cfif len(trim(arguments.frmstruct.shipperAddressLocation1))>
											<TripLeg>
												<LocationText>#arguments.frmstruct.shipperAddressLocation1#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>
									<cfif isdefined("arguments.frmstruct.consigneeAddressLocation1")>
										<cfif len(trim(arguments.frmstruct.consigneeAddressLocation1))>
											<TripLeg>
												<LocationText>#arguments.frmstruct.consigneeAddressLocation1#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>
									<cfloop from="2" to="10" index="i">
										<cfif isdefined("arguments.frmstruct.shipperAddressLocation#i#")>
											<cfif len(trim(Evaluate("arguments.frmstruct.shipperAddressLocation#i#")))>
												<cfset variables.count=i-1>
												<cfif Evaluate("arguments.frmstruct.shipperAddressLocation#i#") neq Evaluate("arguments.frmstruct.shipperAddressLocation#variables.count#")>
													<TripLeg>
														<LocationText>#Evaluate("arguments.frmstruct.shipperAddressLocation#i#")#</LocationText>
													</TripLeg>
												</cfif>	
											</cfif>
										</cfif>
									</cfloop>	
									<cfloop from="2" to="10" index="i">
										<cfif isdefined("arguments.frmstruct.consigneeAddressLocation#i#")>
											<cfif len(trim(Evaluate("arguments.frmstruct.consigneeAddressLocation#i#")))>
												<TripLeg>
													<LocationText>#Evaluate("arguments.frmstruct.consigneeAddressLocation#i#")#</LocationText>
												</TripLeg>
											</cfif>
										</cfif>
									</cfloop>	
								</TripLegs>	
								<VehicleAndLoadDescription>
									<UnitID>#local.ProMilesUnitID#</UnitID>
									<VehicleType>Tractor2AxleBobtail</VehicleType>
									<UseDefaultsForVehicleType>1</UseDefaultsForVehicleType>
								</VehicleAndLoadDescription>
								<GetDrivingDirections>0</GetDrivingDirections>
								<GetStateBreakout>1</GetStateBreakout>
								<GetFuelOptimization>0</GetFuelOptimization>
								<GetTripSummary>0</GetTripSummary>
								<GetItinerary>0</GetItinerary>
								<GetTruckStopsOnRoute>0</GetTruckStopsOnRoute>
								<GetTaxSummary>1</GetTaxSummary>
							</Trip>
						</RunTrip>
					</soap:Body>
				</soap:Envelope>
			</cfsavecontent>
		</cfoutput>
		<cfset variables.message = 1> 
		<cfif structKeyExists(local, "ProMilesUnitID") and local.ProMilesUnitID neq "">
			<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=RunTrip" method="post" result="httpResponse">
				<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
				<cfhttpparam type="header" name="Content-Length" value="length" />
				<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/RunTrip" />
				<cfhttpparam type="xml" value="#trim(myVariable)#" />
			</cfhttp>
			<cfif not FindNoCase("Failure",httpResponse.Statuscode)>
				<cfset soapResponse = xmlParse(httpResponse.fileContent) />
				<cfinvoke  method="ConvertXmlToStruct" xmlNode="#soapResponse#" str="#structNew()#" returnvariable="xmlToStruct"/>
				<cfif IsDefined('xmlToStruct.Body.RunTripResponse.RunTripResult.ResponseStatus') >	
					<cfif xmlToStruct.Body.RunTripResponse.RunTripResult.ResponseStatus eq 'SUCCESS'>
						<cfset message=1>
						<cfif IsDefined('xmlToStruct.Body.RunTripResponse.RunTripResult.Results')>
							<cfset xmlToStruct.Body.RunTripResponse.RunTripResult.Results.TaxSummary.FuelPurchases ="#xmlToStruct.Body.RunTripResponse.RunTripResult.FuelPurchases.FuelPurchase.AmountPurchased#">
							<cfinvoke method="AddIFTATaxSummary" datasource="#application.dsn#" TaxSummaryDetails="#xmlToStruct.Body.RunTripResponse.RunTripResult.Results#" loadNum="#arguments.frmstruct.loadnumber#" returnvariable="response"/>
							<cfset resultArray = xmlToStruct.Body.RunTripResponse.RunTripResult.Results.StateMileage.StateBreakoutRow>
							<cfset nonTollMiles = arraynew(1)>
							<cfset tollMiles = arraynew(1)>
							<cfset totalMiles = arraynew(1)>
							<!--- <cfset deleteLoadIFTAMiles(datasource="#variables.decryptedvar#")> --->
							<cfif isStruct(resultArray)>
								<cfset myStruct = resultArray>
								<cfset resultArray = arraynew(1)>
								<cfset ArrayAppend(resultArray,myStruct)>
							</cfif>
							
							<cfinvoke method="deleteLoadIFTAMiles" datasource="#application.dsn#" loadNum="#arguments.frmstruct.loadnumber#"/>
							<cfif ListFindNoCase(variables.statuslist,qryGetStatusTextNumbersExtactMain.statusNumberText)>
								<cfquery name="qryGetLoadid" datasource="#application.dsn#">
									select loadid from loads where loadnumber=<cfqueryparam value="#arguments.frmstruct.loadnumber#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif qryGetLoadid.recordcount>
									<cfloop from="1" to="#arraylen(resultArray)#" index="i">
									   <cfinvoke method="insertLoadIFTAMiles" loadNum="#arguments.frmstruct.loadnumber#" NonTollMiles="#resultArray[i].NonTollMiles#" TollMiles="#resultArray[i].TollMiles#" TotalMiles="#resultArray[i].TotalMiles#" State="#resultArray[i].State#"  datasource="#application.dsn#" loadid="#qryGetLoadid.loadid#"  returnvariable="xmlToStruct"/>
									</cfloop>
								</cfif>	
							</cfif>	
						</cfif>
						<cfreturn variables.message>
					<cfelse>
						<cfset variables.message='#xmlToStruct.Body.RunTripResponse.RunTripResult.ResponseStatus# For Promiles.'>
						<cfreturn variables.message>
					</cfif>	
				</cfif>	
			</cfif>	
		</cfif>
		<cfreturn variables.message>
	</cffunction>

	<!--- deleteIFTATaxSummary function --->
	<cffunction name="AddIFTATaxSummary" access="public" returntype="any" output="false" hint="Inserts all tax summary details">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfinvoke method="getIFTATaxSummary" datasource="#application.dsn#" loadNum="#arguments.loadNum#" returnvariable="qIFTATaxSummary"/>
		<cfif qIFTATaxSummary.recordCount>
			<cfif ListFindNoCase(variables.statuslist,qryGetStatusTextNumbersExtactMain.statusNumberText)>
				<cfinvoke method="UpdateIFTATaxSummary" TaxSummaryDetails="#arguments.TaxSummaryDetails#" datasource="#application.dsn#" loadNum="#arguments.loadNum#" returnvariable="qIFTATaxSummary"/>
			<cfelse>
				<cfquery name="qDeleteTaxSummaryRow" datasource="#application.dsn#">
					DELETE FROM IFTATaxSummary WHERE loadnumber = <cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
			<cfset TaxSummaryID = qIFTATaxSummary.TaxSummaryID>
			<cfinvoke method="DeleteTaxSummaryRows" datasource="#application.dsn#" loadNum="#arguments.loadNum#"/>
		<cfelse>
			<cfinvoke method="InsertIFTATaxSummary" TaxSummaryDetails="#arguments.TaxSummaryDetails#" datasource="#application.dsn#" loadNum="#arguments.loadNum#" returnvariable="TaxSummaryID"/>
		</cfif>
		<cfif ListFindNoCase(variables.statuslist,qryGetStatusTextNumbersExtactMain.statusNumberText)>
			<cfinvoke method="InsertIFTATaxSummaryRows" TaxSummaryDetails="#arguments.TaxSummaryDetails#" datasource="#application.dsn#" loadNum="#arguments.loadNum#" TaxSummaryID="#TaxSummaryID#"/>
		</cfif>
		<cfreturn true />
	</cffunction>

	<!--- getIFTATaxSummary function --->
	<cffunction name="getIFTATaxSummary" access="public" returntype="Query" output="false" hint="get all tax summary details of a loadID">
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfquery name="qGetIFTATaxSummary" datasource="#arguments.datasource#">
			SELECT * FROM IFTATaxSummary WHERE loadNumber = <cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfreturn qGetIFTATaxSummary />
	</cffunction>

	<!--- InsertIFTATaxSummary function --->
	<cffunction name="InsertIFTATaxSummary" access="public" returntype="any" output="false" hint="Insert tax summary details of a loadID">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">
		<cfquery name="qInsertIFTATaxSummary" datasource="#arguments.datasource#" result="result">
			INSERT INTO IFTATaxSummary(loadnumber
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.GallonsBurned")>
			,GallonsBurned
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.MPG")>
			, MPG
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalIFTASurcharge")>
			, TotalIFTASurcharge
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalIFTATax")>
			, TotalIFTATax
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalMileTax")>
			, TotalMileTax
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalMiles")>
			, TotalMiles
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalTaxDue")>
			, TotalTaxDue
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalTaxableMiles")>
			, TotalTaxableMiles
			</cfif>
			<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.FuelPurchases")>
			, FuelPurchases
			</cfif>
			)
			Values(
				<cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.GallonsBurned")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.GallonsBurned#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.MPG")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.MPG#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalIFTASurcharge")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTASurcharge#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalIFTATax")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTATax#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalMileTax")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMileTax#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalMiles")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMiles#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalTaxDue")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxDue#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalTaxableMiles")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxableMiles#" cfsqltype="cf_sql_float">
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.FuelPurchases")>
					,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.FuelPurchases#" cfsqltype="cf_sql_varchar">
				</cfif>	
				)
		</cfquery>
		
		<cfreturn result.generatedkey />
	</cffunction>

	<!--- InsertIFTATaxSummary function --->
	<cffunction name="UpdateIFTATaxSummary" access="public" returntype="any" output="false" hint="Update tax summary details of a loadID">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfquery name="qUpdateIFTATaxSummary" datasource="#arguments.datasource#">
			UPDATE IFTATaxSummary
			SET
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.GallonsBurned")>
					GallonsBurned = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.GallonsBurned#" cfsqltype="cf_sql_float">,
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.MPG")>
					MPG = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.MPG#" cfsqltype="cf_sql_float">,
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalIFTASurcharge")>
					TotalIFTASurcharge = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTASurcharge#" cfsqltype="cf_sql_float">,
				</cfif>
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalIFTATax")>
					TotalIFTATax = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalIFTATax#" cfsqltype="cf_sql_float">,
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalMileTax")>
					TotalMileTax = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMileTax#" cfsqltype="cf_sql_float">,
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalMiles")>
					TotalMiles = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalMiles#" cfsqltype="cf_sql_float">,
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalTaxDue")>
					TotalTaxDue = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxDue#" cfsqltype="cf_sql_float">,
				</cfif>	
				<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.TotalTaxableMiles")>
					TotalTaxableMiles = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.TotalTaxableMiles#" cfsqltype="cf_sql_float">,
				</cfif>	
				FuelPurchases = <cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.FuelPurchases#" cfsqltype="cf_sql_varchar">
			
			WHERE
				loadnumber = <cfqueryparam value="#arguments.loadnum#" cfsqltype="cf_sql_float">
		</cfquery>
		
		<cfreturn qGetIFTATaxSummary />
	</cffunction>

	<!--- getIFTATaxSummary function --->
	<cffunction name="DeleteTaxSummaryRows" access="public" returntype="void" output="false" hint="Deletes all tax summary details of a loadID">
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">

		<cfquery name="qDeleteTaxSummaryRow" datasource="#arguments.datasource#">
			DELETE FROM IFTATaxSummaryRow WHERE loadnumber = <cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>

	<!--- InsertIFTATaxSummaryRows function --->
	<cffunction name="InsertIFTATaxSummaryRows" access="public" returntype="void" output="false" hint="Insert Tax Summary Rows">
		<cfargument name="TaxSummaryDetails" type="struct" required="true" />
		<cfargument name="loadNum" type="numeric" required="true" />
		<cfargument name="TaxSummaryID" type="numeric" required="true" />
		<cfparam name="arguments.datasource" default="Iz0lOkkK">
		<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow")>
			<cfif isarray(arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow)>
			<cfloop array="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow#" index="rowDetails">
				<cfquery name="qInsertIFTATaxSummaryRows" datasource="#arguments.datasource#" result="result">
					INSERT INTO IFTATaxSummaryRow(loadnumber
						<cfif isdefined("arguments.TaxSummaryID")>
							,TaxSummaryID
						</cfif>	
						<cfif isdefined("rowDetails.FuelBurned")>
							, FuelBurned
						</cfif>	
						<cfif isdefined("rowDetails.GallonsPurchased")>
							, GallonsPurchased
						</cfif>	
						<cfif isdefined("rowDetails.IFTASurcharge")>
							, IFTASurcharge
						</cfif>	
						<cfif isdefined("rowDetails.IFTATax")>
							, IFTATax
						</cfif>	
						<cfif isdefined("rowDetails.IFTATaxRate")>
							, IFTATaxRate
						</cfif>	
						<cfif isdefined("rowDetails.MileTax")>
							, MileTax
						</cfif>	
						<cfif isdefined("rowDetails.PurchaseDifferenceGallons")>
							, PurchaseDifferenceGallons
						</cfif>	
						<cfif isdefined("rowDetails.StateAbbreviation")>
							, StateAbbreviation
						</cfif>	
						<cfif isdefined("rowDetails.TaxableMiles")>
							, TaxableMiles
						</cfif>	
						<cfif isdefined("rowDetails.TollMiles")>
							, TollMiles
						</cfif>	
						<cfif isdefined("rowDetails.TotalMiles")>
						, TotalMiles
						</cfif>
					)
					Values(
						<cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
						<cfif isdefined("arguments.TaxSummaryID")>
							,<cfqueryparam value="#arguments.TaxSummaryID#" cfsqltype="cf_sql_integer">
						</cfif>	
						<cfif isdefined("rowDetails.FuelBurned")>
							,<cfqueryparam value="#rowDetails.FuelBurned#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.GallonsPurchased")>
							,<cfqueryparam value="#rowDetails.GallonsPurchased#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.IFTASurcharge")>
							,<cfqueryparam value="#rowDetails.IFTASurcharge#" cfsqltype="cf_sql_float">
						</cfif>
						<cfif isdefined("rowDetails.IFTATax")>
							,<cfqueryparam value="#rowDetails.IFTATax#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.IFTATaxRate")>
							,<cfqueryparam value="#rowDetails.IFTATaxRate#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.MileTax")>
							,<cfqueryparam value="#rowDetails.MileTax#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.PurchaseDifferenceGallons")>
							,<cfqueryparam value="#rowDetails.PurchaseDifferenceGallons#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.StateAbbreviation")>
							,<cfqueryparam value="#rowDetails.StateAbbreviation#" cfsqltype="cf_sql_varchar">
						</cfif>	
						<cfif isdefined("rowDetails.TaxableMiles")>
							,<cfqueryparam value="#rowDetails.TaxableMiles#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.TollMiles")>
							,<cfqueryparam value="#rowDetails.TollMiles#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("rowDetails.TotalMiles")>
							,<cfqueryparam value="#rowDetails.TotalMiles#" cfsqltype="cf_sql_float">
						</cfif>	
						)
				</cfquery>
			</cfloop>
			<cfelse>
				<cfquery name="qInsertIFTATaxSummaryRows" datasource="#arguments.datasource#" result="result">
					INSERT INTO IFTATaxSummaryRow(loadnumber
					<cfif isdefined("arguments.TaxSummaryID")>
					,TaxSummaryID
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.FuelBurned")>
					, FuelBurned
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.GallonsPurchased")>
					, GallonsPurchased
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTASurcharge")>
					, IFTASurcharge
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTATax")>
					, IFTATax
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTATaxRate")>
					, IFTATaxRate
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.MileTax")>
					, MileTax
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.PurchaseDifferenceGallons")>
					, PurchaseDifferenceGallons
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.StateAbbreviation")>
					, StateAbbreviation
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TaxableMiles")>
					, TaxableMiles
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TollMiles")>
					, TollMiles
					</cfif>
					<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TotalMiles")>
					, TotalMiles
					</cfif>
					)
					Values(
						<cfqueryparam value="#arguments.loadNum#" cfsqltype="cf_sql_integer">
						<cfif isdefined("arguments.TaxSummaryID")>
							,<cfqueryparam value="#arguments.TaxSummaryID#" cfsqltype="cf_sql_integer">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.FuelBurned")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.FuelBurned#" cfsqltype="cf_sql_float">
						</cfif>
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.GallonsPurchased")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.GallonsPurchased#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTASurcharge")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTASurcharge#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTATax")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTATax#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTATaxRate")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.IFTATaxRate#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.MileTax")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.MileTax#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.PurchaseDifferenceGallons")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.PurchaseDifferenceGallons#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.StateAbbreviation")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.StateAbbreviation#" cfsqltype="cf_sql_varchar">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TaxableMiles")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TaxableMiles#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TollMiles")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TollMiles#" cfsqltype="cf_sql_float">
						</cfif>	
						<cfif isdefined("arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TotalMiles")>
							,<cfqueryparam value="#arguments.TaxSummaryDetails.TaxSummary.StateTaxSummary.TaxSummaryRow.TotalMiles#" cfsqltype="cf_sql_float">
						</cfif>
					)
				</cfquery>
			</cfif>
		</cfif>	
	</cffunction>

	<!--- ConvertXmlToStruct function --->
	<cffunction name="ConvertXmlToStruct" access="public" returntype="struct" output="false" hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
		<cfargument name="xmlNode" type="string" required="true" />
		<cfargument name="str" type="struct" required="true" />
		<cfset var i = 0 />
		<cfset var axml = arguments.xmlNode />
		<cfset var astr = arguments.str />
		<cfset var n = "" />
		<cfset var tmpContainer = "" />
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