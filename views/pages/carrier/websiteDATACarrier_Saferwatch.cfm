<cftry>
	<cfset session.AuthType_Common_status="">
	<cfset session.AuthType_Common_appPending="">
	<cfset session.AuthType_Contract_status="">
	<cfset session.AuthType_Contract_appPending="">
	<cfset session.AuthType_Broker_status="">
	<cfset session.AuthType_Broker_appPending="">
	<cfset session.household_goods="">
	<cfset session.bipd_Insurance_required="">
	<cfset session.bipd_Insurance_on_file="">
	<cfset session.cargo_Insurance_required="">
	<cfset session.cargo_Insurance_on_file="">
	<cfset SaferWatchWebKey 				= request.qGetSystemSetupOptions.SaferWatchWebKey>
	<cfset SaferWatchCustomerKey 	= request.qGetSystemSetupOptions.SaferWatchCustomerKey>

	<cfif isdefined('url.mcNo') and len(url.mcNo) gt 1>
		<cfset DOTNumber ="MC"& url.mcNo>  		
	<cfelseif isdefined('url.DOTNumber') and len(url.DOTNumber) gt 1>
		<cfset DOTNumber = url.DOTNumber> 
    </cfif>
	
	<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=CarrierLookup&ServiceKey=#SaferWatchWebKey#&CustomerKey=#SaferWatchCustomerKey#&number=#DOTNumber#" method="get" >
	</cfhttp>
	
	<cfif cfhttp.Statuscode EQ '200 OK'>	
		<cfset variables.responsestatus = structNew()>		
		<cfset variables.responsestatus = ConvertXmlToStruct(cfhttp.Filecontent, StructNew()) >
		<cfif  variables.responsestatus.ResponseDO.action EQ "OK" AND structKeyExists(variables.responsestatus,"CarrierDetails")>								
				<cfif structKeyExists(url,"dump")>
					<cfdump var="#responsestatus#">					
					<cfabort>
				</cfif>
				<cfset CarrierName 		= variables.responsestatus.CarrierDetails.Identity.legalName>		
				<cfset MCNumber    		= right(variables.responsestatus.CarrierDetails.docketNumber,len(variables.responsestatus.CarrierDetails.docketNumber)-2)>
				<cfset  Dotnumber 			= variables.responsestatus.CarrierDetails.dotNumber>				
				<cfset  Address 				= variables.responsestatus.CarrierDetails.Identity.businessStreet>				
				<cfset  City 						= variables.responsestatus.CarrierDetails.Identity.businessCity>
				<cfset  StateValCODE 	= variables.responsestatus.CarrierDetails.Identity.businessState>
				<cfset  State11					= StateValCODE>
				<cfset  Zipcode 				= variables.responsestatus.CarrierDetails.Identity.businessZipCode>
				<cfset  Country1				= variables.responsestatus.CarrierDetails.Identity.businessCountry>
				<cfset  Phone 					= variables.responsestatus.CarrierDetails.Identity.businessPhone>
				<cfset  businessPhone	= variables.responsestatus.CarrierDetails.Identity.businessPhone>
				<cfset  Fax 						= variables.responsestatus.CarrierDetails.Identity.businessFax>				
				<cfset  CellPhone 			= variables.responsestatus.CarrierDetails.Identity.cellPhone>
				<cfset  Email 					=  variables.responsestatus.CarrierDetails.Identity.emailAddress>				
				<cfset  InsExpDateLive =  variables.responsestatus.CarrierDetails.Identity.emailAddress>
				
				<cfif IsStruct(variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList)>
					<cfif IsArray(variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem)>
						<cfset insCarrier			= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].companyName>
						<cfset InsAgentPhone	= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].phone>
						<cfset insAgentName 	= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].attnToName>
						<cfset formatRequired  = variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].address&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].city&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].stateCode&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].postalCode&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].countryCode>
						<cfset insPolicy				= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem[1].policyNumber>
					<cfelse>
						<cfset insCarrier			= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.companyName>
						<cfset InsAgentPhone	= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.phone>
						<cfset insAgentName 	= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.attnToName>
						<cfset formatRequired  = variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.address&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.city&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.stateCode&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.postalCode&","&variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.countryCode>
						<cfset insPolicy				= variables.responsestatus.CarrierDetails.FMCSAInsurance.PolicyList.PolicyItem.policyNumber>
					</cfif>
				</cfif>
				<cfset bipd_Insurance_on_file	= variables.responsestatus.CarrierDetails.FMCSAInsurance.bipdOnFile>
				<cfset BIPDInsRequired 				= variables.responsestatus.CarrierDetails.FMCSAInsurance.bipdRequired>
				<cfset BIPDInsonFile					= variables.responsestatus.CarrierDetails.FMCSAInsurance.bipdOnFile>
				<cfset cargoInsRequired				= variables.responsestatus.CarrierDetails.FMCSAInsurance.cargoRequired>
				<cfset cargoInsonFile					= variables.responsestatus.CarrierDetails.FMCSAInsurance.cargoOnFile>
				<cfif variables.responsestatus.CarrierDetails.Authority.commonAuthority  NEQ "None">
					<cfset variables.commonStatus = 1>
				<cfelse>
					<cfset variables.commonStatus = 0>
				</cfif>
				<cfif variables.responsestatus.CarrierDetails.Authority.contractAuthority  NEQ "None">
					<cfset variables.contractStatus = 1>
				<cfelse>
					<cfset variables.contractStatus = 0>
				</cfif>
				<cfif variables.responsestatus.CarrierDetails.Authority.brokerAuthority  NEQ "None">
					<cfset variables.brokerStatus = 1>
				<cfelse>
					<cfset variables.brokerStatus = 0>
				</cfif>
				<cfif variables.responsestatus.CarrierDetails.Authority.brokerAuthority  NEQ "None">
					<cfset variables.brokerStatus = 1>
				<cfelse>
					<cfset variables.brokerStatus = 0>
				</cfif>
				<cfif variables.responsestatus.CarrierDetails.Authority.commonAuthorityPending  NEQ "No">
					<cfset variables.commonAppPending = 1>
				<cfelse>
					<cfset variables.commonAppPending = 0>
				</cfif>
				<cfif variables.responsestatus.CarrierDetails.Authority.contractAuthorityPending  NEQ "No">
					<cfset variables.contractAppPending = 1>
				<cfelse>
					<cfset variables.contractAppPending = 0>
				</cfif>
				<cfif variables.responsestatus.CarrierDetails.Authority.brokerAuthorityPending  NEQ "No">
					<cfset variables.BrokerAppPending = 1>
				<cfelse>
					<cfset variables.BrokerAppPending = 0>
				</cfif>	
				<cfset message="">
		<cfelse>
			<cfset CarrierName 		= "">					
			<cfset  Address 				= "">				
			<cfset  City 						= "">
			<cfset  StateValCODE 	= "">
			<cfset  State11					= "">
			<cfset  Zipcode 				= "">
			<cfset  Country1				= "">
			<cfset  Phone 					= "">
			<cfset  businessPhone	= "">
			<cfset  Fax 						= "">				
			<cfset  CellPhone 			= "">
			<cfset  Email 					=  "">	
			<cfif structkeyExists(url,"mcNo") >
				<cfset MCNumber = url.mcNo >
				<cfset message="Data not available. Please check the mc## and try again.">
			</cfif>
			<cfif structkeyExists(url,"DOTNumber") >
				<cfset Dotnumber = url.DOTNumber >
				<cfset message="Data not available. Please check the DOT## and try again.">
			</cfif>
		</cfif>     	
	</cfif>

	<cffunction name="ConvertXmlToStruct" access="public" returntype="struct" output="true"  hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
		<cfargument name="xmlNode" type="string" required="true" />
		<cfargument name="str" type="struct" required="true" />		
		<cfset var i 							= 0 />
		<cfset var axml						= arguments.xmlNode />
		<cfset var astr						= arguments.str />
		<cfset var n 							= "" />
		<cfset var tmpContainer 	= "" />

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
					<cfif IsStruct(aXml.XmlAttributes) AND StructCount(aXml.XmlAttributes)>
						<cfset at_list = StructKeyList(aXml.XmlAttributes)>
						<cfloop from="1" to="#listLen(at_list)#" index="atr">
							 <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">								 
								<cfset Structdelete(axml.XmlAttributes, listgetAt(at_list,atr))>
							 </cfif>
						 </cfloop>						
						 <cfif StructCount(axml.XmlAttributes) GT 0>
							 <cfset astr['_attributes'] = axml.XmlAttributes />
						</cfif>
					</cfif>					
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
	
	<cffunction name="formatPhoneNumber">
		<cfargument name="phoneNumber" required="true" />
		<cfif len(phoneNumber) EQ 10>
				<cfreturn "(#left(phoneNumber,3)#) #mid(phoneNumber,4,3)#-#right(phoneNumber,4)#" />
		<cfelse>
			<cfreturn phoneNumber />
		</cfif>
	</cffunction>

<cfcatch type="any">
	
	<cfif structkeyExists(url,"mcNo") >
		<cfset message="Data not available. Please check the mc## and try again.">
	</cfif>
	<cfif structkeyExists(url,"DOTNumber") >
		<cfset message="Data not available. Please check the DOT## and try again.">
	</cfif>
</cfcatch>

</cftry>