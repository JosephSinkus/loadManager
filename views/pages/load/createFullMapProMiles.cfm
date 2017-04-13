<cfparam name="URL.frstConAdd" default="">
<cfparam name="URL.frstShpAdd" default="">

<cfoutput>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<div class="col-md-offset-1 col-md-10 col-md-offset-1" style="margin-top:50px;">
		
		<!---Authorization Credentials--->
		<cfset variables.Username="">
		<cfset variables.Password="">
		<cfset variables.CompanyCode="">
		<cfset local.ProMilesUnitID = ''>
		<cfif structKeyExists(session,"empid")>
			<cfquery name="getProMileDetails" datasource="#Application.dsn#">
					select PCMilerUsername,PCMilerPassword,companyCode from Employees
					where EmployeeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.empid#"> 
			</cfquery>
			<cfif getProMileDetails.recordcount>
				<cfset variables.Username=getProMileDetails.PCMilerUsername>
				<cfset variables.Password=getProMileDetails.PCMilerPassword>
				<cfset variables.CompanyCode=getProMileDetails.companyCode>
			</cfif>
		</cfif>
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
		<Cfset variables.decryptedvar = decrypt(toString(toBinary(url.dsn)), 'load')>
		
		<cfif isdefined("URL.fifthConAdd") and Len(trim(URL.fifthConAdd)) gt 3> 
			<cfset variables.desinationValue = URL.fifthConAdd>
		<cfelseif isdefined("URL.fifthShpAdd") and Len(trim(URL.fifthShpAdd)) gt 3> 
			<cfif (URL.fourthShpAdd) neq (URL.fifthShpAdd)> 
				<cfset variables.desinationValue = URL.fifthShpAdd>
			</cfif>
		<cfelseif isdefined("URL.fourthConAdd") and Len(trim(URL.fourthConAdd)) gt 3> 
			<cfset variables.desinationValue = URL.fourthConAdd>
		<cfelseif isdefined("URL.fourthShpAdd") and Len(trim(URL.fourthShpAdd)) gt 3> 
			<cfif (URL.thirdShpAdd) neq (URL.fourthShpAdd)> 
				<cfset variables.desinationValue = URL.fourthShpAdd>
			</cfif>
		<cfelseif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3> 
			<cfset variables.desinationValue = URL.thirdConAdd>
		<cfelseif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
			<cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> 
				<cfset variables.desinationValue = URL.thirdShpAdd>
			</cfif>
		<cfelseif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>
			<cfset variables.desinationValue = URL.secConAdd>
		<cfelseif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
			<cfif (URL.frstShpAdd) neq (URL.secShpAdd)> 
				<cfset variables.desinationValue = URL.secShpAdd>
			</cfif>
		<cfelse>
			<cfset variables.desinationValue = URL.frstConAdd>
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
										<PurchaseState>#URL.frstConAdd#</PurchaseState>
										<AmountPurchased>0.0</AmountPurchased>
										<IsLiters>1</IsLiters>
										<Station></Station>
										<City>#URL.frstShpAdd#</City>
										<Invoice></Invoice>
										<FuelCost>0.0</FuelCost>
										<TypeOfFuel>DIESEL</TypeOfFuel>
									</FuelPurchase>
								</FuelPurchases>
								<TripLegs>
									<TripLeg>
										<LocationText>#URL.frstShpAdd#</LocationText>
									</TripLeg>
									<cfset variables.locationContains = 0>
									<cfif variables.desinationValue NEQ URL.frstConAdd>
										<TripLeg>
											<LocationText>#URL.frstConAdd#</LocationText>
										</TripLeg>
										<cfset variables.locationContains = 1>
									</cfif>
									<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3 AND variables.desinationValue NEQ URL.secShpAdd> 
										<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#URL.secShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>
									<cfif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3 AND variables.desinationValue NEQ URL.secConAdd>
										<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
										<TripLeg>
											<LocationText>#URL.secConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<cfif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3 AND variables.desinationValue NEQ URL.thirdShpAdd> 
										<cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> 
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#URL.thirdShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>	
									<cfif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3 AND variables.desinationValue NEQ URL.thirdConAdd>
										<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
										<TripLeg>
											<LocationText>#URL.thirdConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<cfif isdefined("URL.fourthShpAdd") and Len(trim(URL.fourthShpAdd)) gt 3 AND variables.desinationValue NEQ URL.fourthShpAdd> 
										<cfif (URL.thirdShpAdd) neq (URL.fourthShpAdd)>
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#URL.fourthShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>	
									<cfif isdefined("URL.fourthConAdd") and Len(trim(URL.fourthConAdd)) gt 3 AND variables.desinationValue NEQ URL.fourthConAdd>
										<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
										<TripLeg>
											<LocationText>#URL.fourthConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<cfif isdefined("URL.fifthShpAdd") and Len(trim(URL.fifthShpAdd)) gt 3 AND variables.desinationValue NEQ URL.fifthShpAdd> 
										<cfif (URL.fourthShpAdd) neq (URL.fifthShpAdd)>
											<cfif variables.locationContains EQ 1> , </cfif> <cfset variables.locationContains = 1>
											<TripLeg>
												<LocationText>#URL.fifthShpAdd#</LocationText>
											</TripLeg>
										</cfif>
									</cfif>	
									<cfif isdefined("URL.fifthConAdd") and Len(trim(URL.fifthConAdd)) gt 3 AND variables.desinationValue NEQ URL.fifthConAdd> 
										<cfif variables.locationContains EQ 1> , </cfif>
										<TripLeg>
											<LocationText>#URL.fifthConAdd#</LocationText>
										</TripLeg>
									</cfif>
									<TripLeg>
										<LocationText>#variables.desinationValue#</LocationText>
									</TripLeg>
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
		<cfif structKeyExists(local, "ProMilesUnitID") and len(local.ProMilesUnitID) and local.ProMilesUnitID NEQ ''>
			<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=RunTrip" method="post" result="httpResponse">
				<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
				<cfhttpparam type="header" name="Content-Length" value="length" />
				<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/RunTrip" />
				<cfhttpparam type="xml" value="#trim(myVariable)#" />
			</cfhttp>
			<cfset soapResponse = xmlParse(httpResponse.fileContent) />
			<cfset xmlToStruct = variables.objProMileGateWay.ConvertXmlToStruct(soapResponse, structnew())>
			<cfif IsDefined('xmlToStruct.Body.RunTripResponse.RunTripResult.Results')>
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
				<cfloop from="1" to="#arraylen(resultArray)#" index="i">
				   <cfset arrayAppend(nonTollMiles, "#resultArray[i].NonTollMiles#") >
				   <cfset arrayAppend(tollMiles, "#resultArray[i].TollMiles#") >
				   <cfset arrayAppend(totalMiles, "#resultArray[i].TotalMiles#") >
				   <!--- <cfset insertLoadIFTAMiles(
												NonTollMiles="#resultArray[i].NonTollMiles#",
												TollMiles="#resultArray[i].TollMiles#",
												TotalMiles="#resultArray[i].TotalMiles#",
												State="#resultArray[i].State#",
												datasource="#variables.decryptedvar#"
												)> --->
				</cfloop>	
				<cfset variables.nonTollMiles = arraysum(nonTollMiles)>
				<cfset variables.tollMiles = arraysum(tollMiles)>
				<cfset variables.totalMiles = arraysum(totalMiles)>
			<cfelse>
				<cfset variables.nonTollMiles = 0>
				<cfset variables.tollMiles = 0>
				<cfset variables.totalMiles = 0>
			</cfif>
			<cfoutput>
				<b>Non Toll Miles</b> : #variables.nonTollMiles# <br><br>
				<b>Toll Miles</b>     : #variables.tollMiles# <br><br>
				<b>Total Miles</b>    : #variables.totalMiles#
			</cfoutput>
		</cfif>
	</div>
</cfoutput>

<cffunction name="insertLoadIFTAMiles" access="public" returntype="void" >
	<cfargument name="NonTollMiles" default="0">
	<cfargument name="TollMiles" default="0">
	<cfargument name="TotalMiles" default="0">
	<cfargument name="State" default="">
	<cfargument name="datasource" default="">
	
	<cfquery name="qryInsertLoadIFTAMiles" datasource="#arguments.datasource#">
		insert into LoadIFTAMiles
		(
			loadNumber,
			tollMiles,
			nonTollMiles,
			totalMiles,
			state,
			dateCreated
		) 
		VALUES
		(
			<cfqueryparam value="#URL.loadNum#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#arguments.tollMiles#" cfsqltype="cf_sql_double">,
			<cfqueryparam value="#arguments.nonTollMiles#" cfsqltype="cf_sql_double">,
			<cfqueryparam value="#arguments.totalMiles#" cfsqltype="cf_sql_double">,
			<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		)
	</cfquery>
</cffunction>
<cffunction name="deleteLoadIFTAMiles" access="public" returntype="void" >
	<cfargument name="datasource" default="">
	<cfquery name="qryDeleteLoadIFTAMiles" datasource="#arguments.datasource#">
		delete from 
			LoadIFTAMiles 
		where 
			loadNumber = <cfqueryparam value="#URL.loadNum#" cfsqltype="cf_sql_integer">
	</cfquery>
</cffunction>