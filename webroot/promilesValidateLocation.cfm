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
	<cfsavecontent variable="myVariable2">
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		  <soap:Body>
			<ValidateLocation xmlns="http://promiles.com/">
			  <c>
				<Username>#variables.Username#</Username>
				<Password>#variables.Password#</Password>
				<CompanyCode>#variables.CompanyCode#</CompanyCode>
			  </c>
			  <LocationText>Tuskegee, AL 36083</LocationText>
			</ValidateLocation>
		  </soap:Body>
		</soap:Envelope>
	</cfsavecontent>
</cfoutput>
<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=ValidateLocation" method="post" result="httpResponse2">
	<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/ValidateLocation" />
	<cfhttpparam type="xml" value="#trim(myVariable2)#" />
</cfhttp>
<cfdump var="#httpResponse2#">
<cfset soapResponse2 = xmlParse(httpResponse2.fileContent) />
<cfdump var="#soapResponse2#" />