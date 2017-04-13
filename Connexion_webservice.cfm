
<cfoutput>#REReplaceNoCase('AUTO CARRIER', "([[:alpha:]])([[:alpha:]]*)", "\U\1\L\2", "ALL")# </cfoutput>



 <!--------login request---------------->
 <cfsavecontent variable="soapHeaderTransCoreTxt">
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
  <soapenv:Header>
      <tcor:sessionHeader soapenv:mustUnderstand="1">
        <tcor:sessionToken>
            <tcor1:primary></tcor1:primary>
            <tcor1:secondary></tcor1:secondary>
        </tcor:sessionToken>
      </tcor:sessionHeader>
      <tcor:correlationHeader soapenv:mustUnderstand="0">
      </tcor:correlationHeader>
      <tcor:applicationHeader soapenv:mustUnderstand="0">
        <tcor:application>TFMI</tcor:application>
        <tcor:applicationVersion>1</tcor:applicationVersion>
      </tcor:applicationHeader>
  </soapenv:Header>
  <soapenv:Body>
      <tfm:loginRequest>
        <tfm:loginOperation>
            <tfm:loginId>weber_cxn2</tfm:loginId>
            <tfm:password>webersystems</tfm:password>
            <tfm:thirdPartyId>TFMI</tfm:thirdPartyId>
            <tfm:apiVersion>2</tfm:apiVersion>
        </tfm:loginOperation>
      </tfm:loginRequest>
  </soapenv:Body>
</soapenv:Envelope>
</cfsavecontent>

<cfhttp method="post" url=" http://cnx.test.dat.com:9280/TfmiRequest" result="TranscoreData360">
 
<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTxt )#" /> 
</cfhttp>
<cfset  TranscoreData360 =  TranscoreData360.filecontent >
 
  
 <cfset soapResponse = xmlParse( TranscoreData360 ) />
 
 
 <cfoutput>
 <cfset primaryKey = XmlSearch(soapResponse,"//*[name()='tcor:primary']") />
  <cfset SeconKey = XmlSearch(soapResponse,"//*[name()='tcor:secondary']") />
 <!----------post asset request-------->
 <cfsavecontent variable="soapHeaderTransCoreTokenTxt">
  
  
  <Envelope 
    xmlns="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" 
    xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" 
    xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
  <Header>
    <tcor:sessionHeader>
      <tcor:sessionToken>
        <tcor1:primary>#primaryKey[1].XmlText#</tcor1:primary>
        <tcor1:secondary>#SeconKey[1].XmlText#</tcor1:secondary>
      </tcor:sessionToken>
    </tcor:sessionHeader>
  </Header>
  <Body>
     <tfm:postAssetRequest>
	  <tfm:postAssetOperations>
	  
        <tfm:shipment>
          <tfm:equipmentType>Auto Carrier4</tfm:equipmentType>
          <tfm:origin>
            <tfm:cityAndState>
              <tfm:city>Alberta</tfm:city>
              <tfm:stateProvince>AB</tfm:stateProvince>
            </tfm:cityAndState>
          </tfm:origin>
          <tfm:destination>
		    <tfm:cityAndState>
              <tfm:city>Mojave Desert</tfm:city> 
              <tfm:stateProvince>CA</tfm:stateProvince>
            </tfm:cityAndState>
          </tfm:destination>
		   <tfm:truckStops> 
			 <tfm:truckStopIds>
			  <tfm:ids>1</tfm:ids>
			  </tfm:truckStopIds>
			 </tfm:truckStops>
		 <tfm:rate>
			  <tfm:baseRateDollars>0.00</tfm:baseRateDollars>
			  <tfm:rateBasedOn>Flat</tfm:rateBasedOn>
			 
		 </tfm:rate>
        </tfm:shipment>
	     <tfm:postersReferenceId>14457</tfm:postersReferenceId>
		 <tfm:ltl>true</tfm:ltl>
		   <tfm:dimensions>
		  <tfm:lengthFeet>50</tfm:lengthFeet>
		  <tfm:weightPounds>50</tfm:weightPounds>
		  </tfm:dimensions>
		   <tfm:availability>
		  <tfm:earliest>#dateformat("2013-06-01","yyyy-mm-dd")#T00:00:00.000Z</tfm:earliest> 
		   <tfm:latest>#dateformat("2013-09-01","yyyy-mm-dd")#T00:00:00.000Z</tfm:latest> 
		  </tfm:availability>
        <tfm:includeAsset>false</tfm:includeAsset>
		 
      </tfm:postAssetOperations>
    </tfm:postAssetRequest> 
  </Body>
</Envelope>
</cfsavecontent>
<cfhttp method="post" url=" http://cnx.test.dat.com:9280/TfmiRequest" result="TranscoreTokenData360">
 
<cfhttpparam type="xml"  value="#trim( soapHeaderTransCoreTokenTxt )#" /> 
</cfhttp>
<cfset  TranscoreTokenData360 =  TranscoreTokenData360.filecontent >
 <cfset TranscoreTokenData3601 = xmlParse( TranscoreTokenData360 ) />
 <cfset msg ="">
  <cfset postAssetSuccess_res = XmlSearch(TranscoreTokenData3601,"//*[name()='tfm:postAssetSuccessData']") />
  <cfset msg = XmlSearch(TranscoreTokenData3601,"//*[name()='message']") />
  <cfif arraylen(msg) eq 0>
  <cfset msg ="">
  
  <cfset msg1 = XmlSearch(TranscoreTokenData3601,"//*[name()='tcor:message']") />
    <cfif arraylen(msg1) eq 0>
	 <cfset msg ="">
	 <cfelse>
	 <cfset msg=replace(#msg1[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"")>
	 </cfif>
  <cfelse>
  
 <cfset msg=replace(#msg[1].XmlText#,"http://www.tcore.com/TcoreTypes.xsd" ,"")>
 </cfif>
 #msg#
   <cfdump var="#TranscoreTokenData3601#">
 <cfdump var="#postAssetSuccess_res#">
 <cfif arraylen(postAssetSuccess_res) eq 0>ff
 </cfif>
  <!------------search lookup request--------->
 
 
  <cfsavecontent variable="soapHeaderDelAsstCoreTxt">
 
  
  <Envelope 
    xmlns="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" 
    xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" 
    xmlns:tfmi="http://www.tcore.com/TfmiFreightMatching.xsd">
  <Header>
    <tcor:sessionHeader>
      <tcor:sessionToken>
        <tcor1:primary>#primaryKey[1].XmlText#</tcor1:primary>
        <tcor1:secondary>#SeconKey[1].XmlText#</tcor1:secondary>
      </tcor:sessionToken>
    </tcor:sessionHeader>
  </Header>
  <Body>
     <tfmi:LookupSearchRequest>
	  <tfmi:LookupSearchOperation >
	         <tfmi:queryAllMySearches></tfmi:queryAllMySearches>
		</tfmi:LookupSearchOperation >
    </tfmi:LookupSearchRequest> 
  </Body>
</Envelope>
</cfsavecontent>

<cfhttp method="post" url=" http://cnx.test.dat.com:9280/TfmiRequest" result="searchlookup_res">
 
<cfhttpparam type="xml"  value="#trim( soapHeaderDelAsstCoreTxt )#" /> 
</cfhttp>
<cfset  searchlookup_res1 =  searchlookup_res.filecontent >
 
  
 <cfset soapResponse1 = xmlParse( searchlookup_res1 ) />
 <cfdump var="#soapResponse1#"> 
</cfoutput> 