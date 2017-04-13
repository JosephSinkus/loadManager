<cfoutput>
	<cfparam default=" " name="variables.deliveryDate">	
	<cfparam default="" name="risk_assessment">
	<cfparam default="" name="link">
	<cfquery name="qSystemSetupOptions" datasource="#Application.dsn#">
    	SELECT showExpiredInsuranceCarriers
        FROM SystemConfig
    </cfquery>
	<cfif url.loadid NEQ "">
		<cfquery name="qGetNewDeliveryDate" datasource="#Application.dsn#">
			SELECT NewDeliveryDate
			FROM loads 
			where 
				loadid =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.loadid#">
		</cfquery>
		<cfif qGetNewDeliveryDate.recordcount>
			<cfset variables.deliveryDate=qGetNewDeliveryDate.NewDeliveryDate>
		</cfif>
	</cfif>
	
	<cfquery name="qrygetFilterCarriers" datasource="#Application.dsn#">
		<!---
		SELECT upper(LTRIM(CarrierNAME)) Text , car.CarrierID Value,car.Cel AS cell, car.Fax,car.EmailID,upper(CarrierNAME)AS carrierName,
		car.City, GETDATE() AS currentDate, car.StateCode,car.zipcode,car.Address, car.InsExpDate,
		Phone phone,
		Case car.Status WHEN 1 THEN 'ACTIVE' ElSE 'INACTIVE' end Status
		FROM Carriers car
		where (ltrim(CarrierNAME) like '#url.q#%' OR MCNumber = '#url.q#' ) 
		AND car.Status = 1
		<cfif qSystemSetupOptions.showExpiredInsuranceCarriers EQ false>
			AND car.InsExpDate >= GETDATE()
		</cfif>
		--->
		SELECT upper(LTRIM(CarrierNAME)) Text , car.CarrierID Value,car.Cel AS cell, car.Fax,car.EmailID,upper(CarrierNAME)AS carrierName,
		car.City, GETDATE() AS currentDate, car.StateCode,car.zipcode,car.Address, car.InsExpDate,
		Phone phone,
		Case car.Status WHEN 1 THEN 'ACTIVE' ElSE 'INACTIVE' end Status,li.ExpirationDate as BIPDExpirationDate,li.CARGOExpirationDate,MCNumber,DOTNumber

		FROM Carriers car
		LEFT  JOIN lipublicfmcsa li
		ON car.CarrierID=li.carrierId
		where (ltrim(CarrierNAME) like '#url.term#%' OR MCNumber = '#url.term#' ) 
		
	</cfquery>
	<!--- <cfif qSystemSetupOptions.showExpiredInsuranceCarriers EQ false AND url.loadid NEQ "" AND len(trim(variables.deliveryDate))> 
			AND car.InsExpDate <= <cfqueryparam value="#variables.deliveryDate#">
			AND li.ExpirationDate <= <cfqueryparam value="#variables.deliveryDate#">
			AND li.CARGOExpirationDate <= <cfqueryparam value="#variables.deliveryDate#">
		</cfif> --->
</cfoutput>
<cfquery name="qSystemSetupOptions" datasource="#Application.dsn#">
		SELECT SaferWatch,SaferWatchWebKey,SaferWatchCustomerKey,FreightBroker
		FROM SystemConfig
</cfquery>
<cfoutput>
[
	<cfset isFirstIteration='yes'>
	<cfloop query="qrygetFilterCarriers">
		<cfif isFirstIteration EQ 'no'>,</cfif>
		<cfif NOT len(TRIM(qrygetFilterCarriers.InsExpDate)) OR NOT len(TRIM(variables.deliveryDate)) or not isdate(qrygetFilterCarriers.BIPDExpirationDate) or not isdate(qrygetFilterCarriers.CARGOExpirationDate)>
			<cfset insuranceExpired = 'yes'>
		<cfelseif url.loadid NEQ "">
			<cfset dateDif = DateCompare(DateFormat(qrygetFilterCarriers.InsExpDate,'yyyy/mm/dd'), DateFormat(variables.deliveryDate,'yyyy/mm/dd'))>
			<cfset dateDifBIPD = DateCompare(DateFormat(qrygetFilterCarriers.BIPDExpirationDate,'yyyy/mm/dd'), DateFormat(variables.deliveryDate,'yyyy/mm/dd'))>
			<cfset dateDifCargo = DateCompare(DateFormat(qrygetFilterCarriers.CARGOExpirationDate,'yyyy/mm/dd'), DateFormat(variables.deliveryDate,'yyyy/mm/dd'))>
			<cfif dateDif LTE 0 or dateDifBIPD LTE 0 or dateDifCargo LTE 0>
				<cfset insuranceExpired = 'yes'>
			<cfelse>
				<cfset insuranceExpired = 'no'>
			</cfif>
		<cfelse>
			<cfset insuranceExpired = 'no'>
		</cfif>
		<cfset qrygetFilterCarriers.Address = REReplace(qrygetFilterCarriers.Address, "\r\n|\n\r|\n|\r", "<br />", "all")>
		<cfif qSystemSetupOptions.SaferWatch EQ 1 AND qSystemSetupOptions.FreightBroker  EQ 1>
				<cfif  qrygetFilterCarriers.DOTNumber NEQ "">
					 <cfset number = qrygetFilterCarriers.DOTNumber>
				<cfelseif  qrygetFilterCarriers.MCNumber NEQ ""  >
					<cfset number = "MC"&qrygetFilterCarriers.MCNumber >
				<cfelse>
					<cfset number = 0 >
				</cfif>
				<cfhttp url="http://www.saferwatch.com/webservices/CarrierService32.php?Action=CarrierLookup&ServiceKey=#qSystemSetupOptions.SaferWatchWebKey#&CustomerKey=#qSystemSetupOptions.SaferWatchCustomerKey#&number=#variables.number#" method="get" >
				</cfhttp>	
				<cfif cfhttp.Statuscode EQ '200 OK'>	
					<cfset variables.resStruct = ConvertXmlToStruct(cfhttp.Filecontent, StructNew())>
					<cfif structKeyExists(variables.resStruct ,"CarrierDetails") AND structKeyExists(variables.resStruct .CarrierDetails,"RiskAssessment") AND structKeyExists(variables.resStruct .CarrierDetails.RiskAssessment,"Overall")  >
						<cfset risk_assessment = variables.resStruct .CarrierDetails.RiskAssessment.Overall>
					</cfif>			
				<cfelse>
					<cfset risk_assessment = "">
				</cfif>
				<cfset link = "http://www.saferwatch.com/swCarrierDetailsLink.php?&number=#number#">
				<cfif risk_assessment EQ "Unacceptable">
					<cfset risk_assessment = "images/SW-Red.png" >
				<cfelseif risk_assessment EQ "Moderate">
					<cfset risk_assessment = "images/SW-Yellow.png">
				<cfelseif risk_assessment EQ "Acceptable">
					<cfset risk_assessment = "images/SW-Green.png">
				<cfelse>   
					<cfset risk_assessment = "images/SW-Blank.png">
				</cfif>																
		</cfif>
		<cfif qSystemSetupOptions.SaferWatch EQ 1  AND qSystemSetupOptions.FreightBroker  EQ 1 AND  structKeyExists(variables.resStruct ,"CarrierDetails") >
			<cfset isFirstIteration='no'>			
			{
				"label": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.legalName),'"','&apos;','all')#",
				"value": "#replace(TRIM(qrygetFilterCarriers.value),'"','&apos;','all')#",
				"name" : "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.legalName),'"','&apos;','all')#",
				"location": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.businessStreet&","&variables.resStruct.CarrierDetails.Identity.businessCity&","&variables.resStruct.CarrierDetails.Identity.businessState&"-"&variables.resStruct.CarrierDetails.Identity.businessZipCode),'"','&apos;','all')#",
				"city" : "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.businessCity),'"','&apos;','all')#",
				"state": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.businessState),'"','&apos;','all')#",
				"zip": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.businessZipCode),'"','&apos;','all')#",
				"phoneNo": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.businessPhone),'"','&apos;','all')#", 
				"cell": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.cellPhone),'"','&apos;','all')#",
				"fax": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.businessFax),'"','&apos;','all')#",
				"InsExpDate": "#replace(TRIM(DateFormat(qrygetFilterCarriers.InsExpDate,'mm/dd/yyyy')),'"','&apos;','all')#",
				"email": "#replace(TRIM(variables.resStruct.CarrierDetails.Identity.emailAddress),'"','&apos;','all')#",
				"insuranceExpired" : "#replace(TRIM(insuranceExpired),'"','&apos;','all')#",
				"status" : "#replace(TRIM(qrygetFilterCarriers.Status),'"','&apos;','all')#",
				"link":"#link#",
				"risk_assessment":"#risk_assessment#"
			}
		<cfelse>
			<cfset isFirstIteration='no'>
			{
				"label": "#replace(TRIM(qrygetFilterCarriers.carrierName),'"','&apos;','all')#",
				"value": "#replace(TRIM(qrygetFilterCarriers.value),'"','&apos;','all')#",
				"name" : "#replace(TRIM(qrygetFilterCarriers.carrierName),'"','&apos;','all')#",
				"location": "#replace(TRIM(qrygetFilterCarriers.Address),'"','&apos;','all')#",
				"city" : "#replace(TRIM(qrygetFilterCarriers.City),'"','&apos;','all')#",
				"state": "#replace(TRIM(qrygetFilterCarriers.StateCode),'"','&apos;','all')#",
				"zip": "#replace(TRIM(qrygetFilterCarriers.zipCode),'"','&apos;','all')#",
				"phoneNo": "#replace(TRIM(qrygetFilterCarriers.phone),'"','&apos;','all')#",
				"cell": "#replace(TRIM(qrygetFilterCarriers.cell),'"','&apos;','all')#",
				"fax": "#replace(TRIM(qrygetFilterCarriers.fax),'"','&apos;','all')#",
				"InsExpDate": "#replace(TRIM(DateFormat(qrygetFilterCarriers.InsExpDate,'mm/dd/yyyy')),'"','&apos;','all')#",
				"email": "#replace(TRIM(qrygetFilterCarriers.emailID),'"','&apos;','all')#",
				"insuranceExpired" : "#replace(TRIM(insuranceExpired),'"','&apos;','all')#",
				"status" : "#replace(TRIM(qrygetFilterCarriers.Status),'"','&apos;','all')#",
				"link":"#link#",
				"risk_assessment":"#risk_assessment#"
			}
		</cfif>
	</cfloop>
	
]
</cfoutput>

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




