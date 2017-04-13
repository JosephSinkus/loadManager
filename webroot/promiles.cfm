<!---Authorization Credentials--->
<cfset variables.Username="webrsys">
<cfset variables.Password="webr774">
<cfset variables.CompanyCode="weby">

<cfoutput>
	<cfsavecontent variable="myVariable">
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		  <soap:Body>
			<ValidateLocation xmlns="http://promiles.com/">
			  <c>
				<Username>#variables.Username#</Username>
				<Password>#variables.Password#</Password>
				<CompanyCode>#variables.CompanyCode#</CompanyCode>
			  </c>
			  <LocationText>Alabama</LocationText>
			</ValidateLocation>
		  </soap:Body>
		</soap:Envelope>
	</cfsavecontent>
</cfoutput>
<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=ValidateLocation" method="post" result="httpResponse">
	<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/ValidateLocation" />
	<cfhttpparam type="xml" value="#trim(myVariable)#" />
</cfhttp>
<cfdump var="#httpResponse#">
<cfset soapResponse = xmlParse(httpResponse.fileContent) />
<cfdump var="#soapResponse#" />


<cfoutput>
	<cfsavecontent variable="myVariable">		
		<?xml version="1.0" encoding="utf-8"?>
		<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
			<soap12:Body>
				<RunQuickTrip xmlns="http://www.promiles.com/">
					<c>
						<Username>#variables.Username#</Username>
						<Password>#variables.Password#</Password>
						<CompanyCode>#variables.CompanyCode#</CompanyCode>
					</c>
					<Stop1>Alabama</Stop1>
					<Stop2>Tuskegee, AL 36083</Stop2>
					<Stop3>Montgomery, AB</Stop3>
					<RouteMethod>PRACTICAL</RouteMethod>
					<BorderOpen>0</BorderOpen>
					<ReduceToll>1</ReduceToll>
					<MPG>6.0</MPG>
				</RunQuickTrip>
			</soap12:Body>
		</soap12:Envelope>		  
	</cfsavecontent>
</cfoutput>
<cfhttp url="http://v4.promilesonline.com/Process/TruckRoutingService.asmx?op=RunQuickTrip" method="post" result="httpResponse">
	<cfhttpparam type="header" name="Content-Type" value="application/soap+xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="xml" value="#trim(myVariable)#" />
</cfhttp>


<cfdump var="#httpResponse#">
<cfset soapResponse = xmlParse(httpResponse.fileContent) />
<cfdump var="#soapResponse#" />


<cfoutput>
	<cfsavecontent variable="myVariable3">
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		<soap:Body>
			<RunSimpleTrip xmlns="http://promiles.com/">
			  <c>
				<Username>#variables.Username#</Username>
				<Password>#variables.Password#</Password>
				<CompanyCode>#variables.CompanyCode#</CompanyCode>
			  </c>
			  <BasicTrip>
				<RoutingMethod>PRACTICAL</RoutingMethod>
				<BorderOpen>0</BorderOpen>
				<AvoidTollRoads>0</AvoidTollRoads>
				<TripMiles>1.00</TripMiles>
				<TripMinutes>5</TripMinutes>				
				<StateMileage>
				  <StateBreakoutRow>
					<State>AL</State>
					<TotalMiles>241.0</TotalMiles>
					<TollMiles>0.0</TollMiles>					
				  </StateBreakoutRow>
				  <StateBreakoutRow>
					<State>GA</State>
					<TotalMiles>22.06</TotalMiles>
					<TollMiles>0.00</TollMiles>
				  </StateBreakoutRow>
				</StateMileage>				
				<VehicleType>Tractor2AxleTrailer2Axle</VehicleType>
				<AllowRelaxRestrictions>0</AllowRelaxRestrictions>
				<HasRelaxedRestrictions>0</HasRelaxedRestrictions>
				<TollCharges>0.00</TollCharges>
				<TripCharges>0.00</TripCharges>
			  </BasicTrip>
			</RunSimpleTrip>
		</soap:Body>
		</soap:Envelope>
	</cfsavecontent>
</cfoutput>

<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=RunSimpleTrip" method="post" result="httpResponse">
	<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/RunSimpleTrip" />
	<cfhttpparam type="xml" value="#trim(myVariable3)#" />
</cfhttp>
<cfdump var="#httpResponse#">
<cfset soapResponse = xmlParse(httpResponse.fileContent) />
<cfdump var="#soapResponse#" />




<!---

<cfoutput>
	<cfsavecontent variable="myVariable58">
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		  <soap:Body>
			<GetTripDistance xmlns="http://promiles.com/">
			  <c>
				<Username>#variables.Username#</Username>
				<Password>#variables.Password#</Password>
				<CompanyCode>#variables.CompanyCode#</CompanyCode>
			  </c>
			  <Trip>
				<RoutingMethod>PRACTICAL</RoutingMethod>
				<BorderOpen>0</BorderOpen>
				<AvoidTollRoads>0</AvoidTollRoads>
				<TripMiles>1.00</TripMiles>
				<TripMinutes>1</TripMinutes>
				<DrivingDirections>
				  <DirectionRow>
					<Maneuver>fhfgh</Maneuver>
					<DistanceAtStart>1.00</DistanceAtStart>
					<LegDistance>1.00</LegDistance>
					<LegIndex>1</LegIndex>
					<Time>1</Time>
					<Road>hkjkh</Road>
					<IsToll>0</IsToll>
					<Latitude>1.00</Latitude>
					<Longitude>1.00</Longitude>
					<TollCharge>1.00</TollCharge>
				  </DirectionRow>
				  <DirectionRow>
					<Maneuver>gjghj</Maneuver>
					<DistanceAtStart>1.00</DistanceAtStart>
					<LegDistance>1.00</LegDistance>
					<LegIndex>2</LegIndex>
					<Time>int</Time>
					<Road>ghjhj</Road>
					<IsToll>0</IsToll>
					<Latitude>1.00</Latitude>
					<Longitude>1.00</Longitude>
					<TollCharge>1.00</TollCharge>
				  </DirectionRow>
				</DrivingDirections>
				<StateMileage>
				  <StateBreakoutRow>
					<State>fgfh</State>
					<TotalMiles>1.00</TotalMiles>
					<TollMiles>1.00</TollMiles>
					<NonTollMiles>1.00</NonTollMiles>
				  </StateBreakoutRow>
				  <StateBreakoutRow>
					<State>fgfg</State>
					<TotalMiles>1.00</TotalMiles>
					<TollMiles>1.00</TollMiles>
					<NonTollMiles>1.00</NonTollMiles>
				  </StateBreakoutRow>
				</StateMileage>
				<MapPoints>
				  <MapPoint>
					<Lat>1.00</Lat>
					<Lon>1.00</Lon>
				  </MapPoint>
				  <MapPoint>
					<Lat>1.00</Lat>
					<Lon>1.00</Lon>
				  </MapPoint>
				</MapPoints>
				<VehicleType>Tractor2AxleDouble</VehicleType>
				<AllowRelaxRestrictions>0</AllowRelaxRestrictions>
				<HasRelaxedRestrictions>0</HasRelaxedRestrictions>
				<TollCharges>1.00</TollCharges>
				<TripCharges>1.00</TripCharges>
			  </Trip>
			</GetTripDistance>
		  </soap:Body>
		</soap:Envelope>
	</cfsavecontent>
</cfoutput>

<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=GetTripDistance" method="post" result="httpResponse">
	<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/GetTripDistance" />
	<cfhttpparam type="xml" value="#trim(myVariable58)#" />
</cfhttp>
<cfdump var="#httpResponse#">
<cfset soapResponse = xmlParse(httpResponse.fileContent) />
<cfdump var="#soapResponse#" /><cfabort>

--->


