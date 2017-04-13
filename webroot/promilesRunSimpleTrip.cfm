<!---Authorization Credentials--->
<cfset variables.Username="webrsys">
<cfset variables.Password="webr774">
<cfset variables.CompanyCode="weby">


<!--- run simple trip --->
<cfoutput>
	<cfsavecontent variable="myVariable">
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
					<BorderOpen>1</BorderOpen>
					<AvoidTollRoads>1</AvoidTollRoads>
					<AllowRelaxRestrictions>0</AllowRelaxRestrictions>
					<HasRelaxedRestrictions>1</HasRelaxedRestrictions>
					<TripLegs>
						<TripLeg>
							<Location>
								<ProMilesLocationID>109071</ProMilesLocationID>
								<City>Alabama</City>
								<State>NY</State>
								<PostalCode>14003</PostalCode>
								<Latitude>43.090000567441</Latitude>
								<Longitude>-78.3900046117189</Longitude>
								<Type>PROMILES</Type>
							</Location>
						</TripLeg>
						<TripLeg>
							<Location>
								<ProMilesLocationID>8056</ProMilesLocationID>
								<City>Tuskegee</City>
								<State>AL</State>							
								<PostalCode>36083</PostalCode>							
								<Latitude>32.4199927090845</Latitude>
								<Longitude>-85.6900033432533</Longitude>
								<Type>PROMILES</Type>								
							</Location>
						</TripLeg>
					</TripLegs>
				  </BasicTrip>
				</RunSimpleTrip>
			  </soap:Body>
			</soap:Envelope>
	</cfsavecontent>
</cfoutput>
<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=RunSimpleTrip" method="post" result="httpResponse">
	<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/RunSimpleTrip"/>
	<cfhttpparam type="xml" value="#trim(myVariable)#" />
</cfhttp>
<cfdump var="#httpResponse#">
<cfset soapResponse = xmlParse(httpResponse.fileContent) />
<cfdump var="#soapResponse#" />