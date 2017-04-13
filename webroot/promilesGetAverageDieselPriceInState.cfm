<!---Authorization Credentials--->
<cfset variables.Username="webrsys">
<cfset variables.Password="webr774">
<cfset variables.CompanyCode="weby">

<cfoutput>
	<cfsavecontent variable="GetAverageDieselPriceInState">
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		  <soap:Body>
			<GetAverageDieselPriceInState xmlns="http://promiles.com/">
			  <c>
				<Username>#variables.Username#</Username>
				<Password>#variables.Password#</Password>
				<CompanyCode>#variables.CompanyCode#</CompanyCode>
			  </c>
			  <StateAbbreviation>TX</StateAbbreviation>
			</GetAverageDieselPriceInState>
		  </soap:Body>
		</soap:Envelope>
	</cfsavecontent>
</cfoutput>


<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=GetAverageDieselPriceInState" method="post" result="httpResponse_GetAverageDieselPriceInState">
	<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/GetAverageDieselPriceInState" />
	<cfhttpparam type="xml" value="#trim(GetAverageDieselPriceInState)#" />
</cfhttp>
<cfdump var="#httpResponse_GetAverageDieselPriceInState#">
<cfset soapResponse_GetAverageDieselPriceInState = xmlParse(httpResponse_GetAverageDieselPriceInState.fileContent) />
<cfdump var="#soapResponse_GetAverageDieselPriceInState#" />

<cfoutput>
	<cfsavecontent variable="GetAverageDieselPriceInState2">
		<?xml version="1.0" encoding="utf-8"?>
		<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
		  <soap:Body>
			<GetAverageDieselPriceInState xmlns="http://promiles.com/">
			  <c>
				<Username>#variables.Username#</Username>
				<Password>#variables.Password#</Password>
				<CompanyCode>#variables.CompanyCode#</CompanyCode>
			  </c>
			  <StateAbbreviation>AZ</StateAbbreviation>
			</GetAverageDieselPriceInState>
		  </soap:Body>
		</soap:Envelope>
	</cfsavecontent>
</cfoutput>


<cfhttp url="http://prime.promiles.com/Webservices/v1_1/PRIMEStandardV1_1.asmx?op=GetAverageDieselPriceInState" method="post" result="httpResponse_GetAverageDieselPriceInState">
	<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	<cfhttpparam type="header" name="Content-Length" value="length" />
	<cfhttpparam type="header" name="SOAPAction" value="http://promiles.com/GetAverageDieselPriceInState" />
	<cfhttpparam type="xml" value="#trim(GetAverageDieselPriceInState)#" />
</cfhttp>
<cfdump var="#httpResponse_GetAverageDieselPriceInState#">
<cfset soapResponse_GetAverageDieselPriceInState2 = xmlParse(httpResponse_GetAverageDieselPriceInState.fileContent) />
<cfdump var="#soapResponse_GetAverageDieselPriceInState2#" />