<cfoutput>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<div class="col-md-offset-1 col-md-10 col-md-offset-1" style="margin-top:50px;">
		<form class="form-inline" name="getMiles" id="getMiles" action="" method="post">
			<div class="form-group">
				<label for="From">From</label>
				<input type="text" class="form-control" id="From" name="From" placeholder="From">
			</div>
			<div class="form-group">
				<label for="exampleInputEmail2">To</label>
				<input type="text" class="form-control" id="To" name="To" placeholder="To">
			</div>
			<button type="submit" name="submit" class="btn btn-info">Submit</button>
		</form>	
		<cfif structkeyexists(form,"submit")>
			<cffunction name="ConvertXmlToStruct" access="public" returntype="struct" output="false"
						hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
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
			<!---Authorization Credentials--->
			<cfset variables.Username="webrsys">
			<cfset variables.Password="webr774">
			<cfset variables.CompanyCode="weby">
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
									<TripLegs>
										<TripLeg>
											<LocationText>#form.from#</LocationText>
										</TripLeg>
										<TripLeg>
											<LocationText>#form.to#</LocationText>
										</TripLeg>
										<TripLeg>
											<LocationText>#form.from#</LocationText>
										</TripLeg>
									</TripLegs> 
									<VehicleAndLoadDescription>
										<VehicleType>Truck2Axle</VehicleType>
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
			<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=RunTrip" method="post" result="httpResponse">
				<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
				<cfhttpparam type="header" name="Content-Length" value="length" />
				<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/RunTrip" />
				<cfhttpparam type="xml" value="#trim(myVariable)#" />
			</cfhttp>
			<cfset soapResponse = xmlParse(httpResponse.fileContent) />
			<cfset xmlToStruct = ConvertXmlToStruct(soapResponse, structnew())>
			<cfset resultArray = xmlToStruct.Body.RunTripResponse.RunTripResult.Results.StateMileage.StateBreakoutRow>
			<cfset nonTollMiles = arraynew(1)>
			<cfset tollMiles = arraynew(1)>
			<cfset totalMiles = arraynew(1)>
			<cfloop from="1" to="#arraylen(resultArray)#" index="i">
			   <cfset arrayAppend(nonTollMiles, "#resultArray[i].NonTollMiles#") >
			   <cfset arrayAppend(tollMiles, "#resultArray[i].TollMiles#") >
			   <cfset arrayAppend(totalMiles, "#resultArray[i].TotalMiles#") >
			</cfloop>
			<cfoutput>
				<b>From</b>           : #form.from#<br><br>
				<b>To</b>             : #form.to#<br><br>
				<b>Non Toll Miles</b> : #arraysum(nonTollMiles)# <br><br>
				<b>Toll Miles</b>     : #arraysum(tollMiles)# <br><br>
				<b>Total Miles</b>    : #arraysum(totalMiles)#
			</cfoutput>    
		</cfif>
	</div>
</cfoutput>