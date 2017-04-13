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
	<cfset key='af068b8c47236c9fadffa5791dc95a6515801b91'>
<!--- <cftry>
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
	<cfset key='af068b8c47236c9fadffa5791dc95a6515801b91'>
	<cfif isdefined('url.mcNo') and len(url.mcNo) gt 1>
		<cfset MCNumber=url.mcNo>  
		<cfhttp url="http://safer.fmcsa.dot.gov/query.asp" method="post" >
			<cfhttpparam type="formfield" NAME="query_param" value="MC_MX">
			<cfhttpparam type="formfield" NAME="query_string" value='#MCNumber#'>
			<cfhttpparam type="formfield" NAME="searchtype" value='ANY'>
			<cfhttpparam type="formfield" NAME="query_type" value='queryCarrierSnapshot'>
		</cfhttp>
		<cfset variables.myStr1=tagStripper(cfhttp.FileContent,"strip","table,tr,td,a,input")>
		 <cfset variables.getUSDOTFromMc=findnocase('http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_carrlist?n_dotno',variables.myStr1,1)>

		 <cfset variables.getUSDOTTomc=findnocase('&s_prefix=MC',myStr1,variables.getUSDOTFromMc)>
		 <cfdump var="#variables.getUSDOTTomc#" />
		<cfset variables.USDOTLenmc = variables.getUSDOTTomc - (variables.getUSDOTFromMc)>
		<cfset variables.dotnumberstring = trim(mid(myStr1,(variables.getUSDOTFromMc),variables.USDOTLenmc))>
		<cfset variables.dotnumber=replacenocase(variables.dotnumberstring,'http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_carrlist?n_dotno=',"","all")>
		<cfset DOTNumber=#trim(variables.dotnumber)#> 
	<cfelseif isdefined('url.DOTNumber') and len(url.DOTNumber) gt 1>
		<cfset DOTNumber=#url.DOTNumber#> 
    </cfif>
	<cfhttp url="https://mobile.fmcsa.dot.gov/qc/services/carriers/#DOTNumber#?webKey=#key#" method="get" >
	</cfhttp>
	<cfif cfhttp.Statuscode eq '200 OK'>	
		<cfset variables.retStruct = structNew()>
		<cfset variables.retStruct = deserializeJson(cfhttp.Filecontent) >
		<cfhttp url="https://mobile.fmcsa.dot.gov/qc/services/carriers/#DOTNumber#/docket-numbers?webKey=#key#" method="get" >
		<cfif cfhttp.Statuscode eq '200 OK'>
			<cfset variables.mcnumberResponse = structNew()>
			<cfset variables.mcnumberResponse = deserializeJson(cfhttp.Filecontent) >
			<cfif not ArrayIsEmpty(variables.mcnumberResponse.content)>
				<cfset mcnumber=variables.mcnumberResponse.content[1].docketNumber >
				<cfhttp  method="get" 
				url="https://mobile.fmcsa.dot.gov/qc/services/carriers/#DOTNumber#/authority?webKey=#key#">
				</cfhttp>
				<cfset variables.responsestatus = structNew()>
				<cfset variables.responsestatus = deserializeJson(cfhttp.Filecontent) >
				<cfif isdefined("variables.retStruct.content.carrier.legalName")>
			     	<cfset CarrierName=variables.retStruct.content.carrier.legalName>
			     </cfif>
			<cfelse>
				<cfif structkeyExists(url,"mcNo") >
					<cfset message="Data not available. Please check the mc## and try again.">
				</cfif>
				<cfif structkeyExists(url,"DOTNumber") >
					<cfset message="Data not available. Please check the DOT## and try again.">
				</cfif>
			</cfif>     
		<cfelse>
			<cfif structkeyExists(url,"mcNo") >
				<cfset message="Data not available. Please check the mc## and try again.">
			</cfif>
			<cfif structkeyExists(url,"DOTNumber") >
				<cfset message="Data not available. Please check the DOT## and try again.">
			</cfif>	
		</cfif>     
	<cfelse>
	    <cfif structkeyExists(url,"mcNo") >
			<cfset message="Data not available. Please check the mc## and try again.">
		</cfif>
		<cfif structkeyExists(url,"DOTNumber") >
			<cfset message="Data not available. Please check the DOT## and try again.">
		</cfif> 	
	</cfif>   
    <cfif isdefined('variables.responsestatus')>
	    <cfif not ArrayIsEmpty(variables.responsestatus.content)>
			<cfset variables.pv_apcant_id=trim(variables.responsestatus.content[1].carrierAuthority.applicantID)>
			<cfset variabls.pv_legal_name=replacenocase(CarrierName,"^",' ','all')>
			<cfset variabls.pv_legal_name=replacenocase(variabls.pv_legal_name,"&",'and','all')>
		    <cfhttp url="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_activeinsurance?pv_apcant_id=#trim(variables.pv_apcant_id)#&pv_legal_name=#variabls.pv_legal_name#&pv_pref_docket=MC#trim(mcnumber)#&pv_usdot_no=#trim(DOTNumber)#&pv_vpath=LIVIEW%201" METHOD="get">
			</cfhttp>
		  	<cfif  not cfhttp.FileContent contains 'No Data Available'>
				<cfset myStr1=tagStripper(cfhttp.FileContent,"strip","table,tr,td,a,input")>
				<cfset getUSDOTFrom=findnocase('pv_vpath=LIVIEW">',myStr1,1)>
				<cfset getUSDOTTo=findnocase('</a>',myStr1,getUSDOTFrom)>
				<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+17)>
				<cfset insCarrier = trim(mid(myStr1,(getUSDOTFrom+17),USDOTLen))>
				<cfset getUSDOTFrom=findnocase('pv_inser_id=',myStr1,1)>
				<cfset getUSDOTTo=findnocase('&',myStr1,getUSDOTFrom)>
				<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+12)>
				<cfset pv_inser_id = trim(mid(myStr1,(getUSDOTFrom+12),USDOTLen))>
			    <cfif findnocase('<TD headers="34 policy_surety ">',myStr1,1) neq 0>
			    	<cfset getUSDOTFrom=findnocase('<TD headers="34 policy_surety ">',myStr1,1)>
					<cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
			        <cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+34)>
			        <cfset insPolicy = trim(mid(myStr1,(getUSDOTFrom+34),USDOTLen))>
			    <cfelse>
			    	<cfset getUSDOTFrom=findnocase('<TD headers="91X policy_surety ">',myStr1,1)>
					<cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
			        <cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+34)>
			        <cfset insPolicy = trim(mid(myStr1,(getUSDOTFrom+34),USDOTLen))>
			    </cfif>
			    <cfif findnocase('headers="34 effective_date ">',myStr1,1) neq 0>
				   	<cfset getUSDOTFrom=findnocase('headers="34 effective_date ">',myStr1,1)>
					<cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
			        <cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+30)>
			        <cfset InsExpDateLive = trim(mid(myStr1,(getUSDOTFrom+30),USDOTLen))>
			        <cfif isdate(InsExpDateLive)>
			        	<cfset InsExpDateLive = dateadd("yyyy",1,InsExpDateLive)>
			        </cfif>	
			    <cfelse>
			    	<cfset getUSDOTFrom=findnocase('headers="91X effective_date ">',myStr1,1)>
					<cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
					<cfif (getUSDOTFrom neq 0) and (getUSDOTTo neq 0)>
						<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+30)>
					    <cfset InsExpDateLive = trim(mid(myStr1,(getUSDOTFrom+30),USDOTLen))>
			        	<cfset InsExpDateLive = dateadd("yyyy",1,InsExpDateLive)>
					<cfelse>
						<cfset USDOTLen = "">
					    <cfset InsExpDateLive = "">
			        	<cfset InsExpDateLive = "">
					</cfif>		
			    </cfif>
				<cfhttp url="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_insfiler_details?pv_inser_id=#trim(pv_inser_id)#&pv_apcant_id=#variables.pv_apcant_id#&pv_legal_name=#variabls.pv_legal_name#&pv_pref_docket=MC#mcnumber#&pv_dot_no=#DOTNumber#&pv_prc_back=prc_activeinsurance&pv_vpath=LIVIEW" METHOD="get" timeout="2">
				</cfhttp>
				<cfset myStr1=tagStripper(cfhttp.FileContent,"strip","table,tr,td,a,input,div")>
				<cfset getUSDOTFrom=findnocase('<TD headers="icd_title">',myStr1,1)>
				<cfset getUSDOTTo=findnocase('<a href="pkg_carrquery',myStr1,getUSDOTFrom)>
				<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+24+len(insCarrier)+20)>
				<cfset insCarrierDetails = trim(mid(myStr1,(getUSDOTFrom+24+len(insCarrier)+20),USDOTLen))>
				<cfset insCarrierDetails=replace(insCarrierDetails,"<TD>",'<br/>','all')>
				<cfset insCarrierDetails=replace(insCarrierDetails,'</TD>','<br/>','all')>
				<cfset insCarrierDetails=replace(insCarrierDetails,'STE:','STE','all')>
				<cfif len(insCarrierDetails) gt 200>
					<cfset insCarrierDetails = "">
				</cfif>
				<cfset loopId=1>
				<cfloop list="#insCarrierDetails#" delimiters=":" index="tt">
					<cfif loopId is 2>
					 <cfset insAgentName = #tt#>
					 <cfset insAgentName = replacenocase(insAgentName,'Address',"","all")>
					</cfif>
					<cfif loopId is 3>
						<cfset variables.InsAddress = #tt#>
						<cfset variables.InsAddress = replacenocase(variables.InsAddress,'<br/>',"","all")>
						<cfset variables.InsAddress = replacenocase(variables.InsAddress,'Telephone',"","all")>
						<cfset variables.InsAddress = replacenocase(variables.InsAddress,'<div>',"&##13;&##10","all")>
						<cfset variables.arrangedlastRecord=listLast(variables.InsAddress)>
						<cfset variables.country=mid(trim(variables.arrangedlastRecord),4,2)>
						<cfset variables.rearrangedString=replacenocase(variables.arrangedlastRecord,'#mid(trim(variables.arrangedlastRecord),4,3)#',"","all")>
						<cfset variables.stringLength=len(variables.rearrangedString)-1>
						<cfset variables.formattedString=Insert("#variables.country#", variables.rearrangedString, variables.stringLength)>
						<cfset variables.lastelementwithoutString=ListDeleteAt(variables.InsAddress,listlen(variables.InsAddress))>
						<cfset variables.formatRequired=listAppend(variables.lastelementwithoutString,variables.formattedString)>
					</cfif>	
					<cfif loopId is 4>
						<cfset InsAgentPhone = #tt#>
						<cfset InsAgentPhone = replacenocase(InsAgentPhone,'Fax',"","all")>
						<cfset InsAgentPhone = replacenocase(InsAgentPhone,'(',"","all")>
						<cfset InsAgentPhone = replacenocase(InsAgentPhone,') ',"-","all")>
					</cfif>	
					<cfset loopId=loopId+1>
				</cfloop>
			</cfif>
		</cfif>	
		<cfif isdefined("variables.retStruct.content.carrier.Phone")>
			<cfset CleanPhoneNumber = REReplace(variables.retStruct.content.carrier.Phone, "[^0-9]", "", "ALL") />
			<cfset businessPhone=formatPhoneNumber(CleanPhoneNumber)>	
		</cfif>	
		<cfset city=variables.retStruct.content.carrier.phyCity>
		<cfset State11=variables.retStruct.content.carrier.phyState>
		<cfset Address=variables.retStruct.content.carrier.phyStreet>
		<cfset Zipcode=variables.retStruct.content.carrier.phyZipcode>
		<cfif not ArrayIsEmpty(variables.responsestatus.content)>
			<cfset AuthType_Common_status = trim(variables.responsestatus.content[1].carrierAuthority.commonAuthorityStatus)>
			<cfif len(trim(AuthType_Common_status))>
				<cfif AuthType_Common_status eq 'N'>
					<cfset variables.commonStatus=0>
				<cfelse>
					<cfset variables.commonStatus=1>
				</cfif>	
			</cfif>
			<cfset session.AuthType_Common_status = trim(AuthType_Common_status)>
			<cfset AuthType_Contract_status = trim(variables.responsestatus.content[1].carrierAuthority.contractAuthorityStatus)>
			<cfif len(trim(AuthType_Contract_status))>
				<cfif AuthType_Contract_status eq 'N'>
					<cfset variables.contractStatus=0>
				<cfelse>
					<cfset variables.contractStatus=1>
				</cfif>	
			</cfif>
			<cfset session.AuthType_Contract_status = trim(AuthType_Contract_status)>
			<cfset AuthType_Broker_status = trim(variables.responsestatus.content[1].carrierAuthority.brokerAuthorityStatus)>
			
			<cfif len(trim(AuthType_Broker_status))>
				<cfif AuthType_Broker_status eq 'N'>
					<cfset variables.brokerStatus=0>
				<cfelse>
					<cfset variables.brokerStatus=1>
				</cfif>	
			</cfif>
			<cfset household_goods = trim(variables.responsestatus.content[1].carrierAuthority.authorizedForHouseholdGoods)>
			<cfif len(trim(household_goods))>
				<cfif  household_goods eq 'N'>
					<cfset variables.householdGoods=0>
				<cfelse>
					<cfset variables.householdGoods=1>
				</cfif>	
			</cfif>
			<cfset session.household_goods = trim(variables.responsestatus.content[1].carrierAuthority.authorizedForHouseholdGoods)>
		</cfif>	
		<cfset session.AuthType_Broker_status = trim(AuthType_Broker_status)>
		<cfif isdefined("variables.retStruct.content.carrier.bipdInsuranceRequired")>
			<cfset bipd_Insurance_required=variables.retStruct.content.carrier.bipdInsuranceRequired>	
			<cfif len(trim(bipd_Insurance_required))>
				<cfif bipd_Insurance_required eq 'N'>
					<cfset variables.BIPDInsRequired=0>
				<cfelse>
					<cfset variables.BIPDInsRequired=1>
				</cfif>	
			</cfif>
		</cfif>	
		<cfif isdefined("variables.retStruct.content.carrier.bipdInsuranceRequired")>
			<cfset bipd_Insurance_required=variables.retStruct.content.carrier.bipdInsuranceRequired>	
			<cfset session.bipd_Insurance_required = trim(variables.retStruct.content.carrier.bipdInsuranceRequired)>
		</cfif>	
		<cfif isdefined("variables.retStruct.content.carrier.bipdInsuranceOnFile")>
			<cfset bipd_Insurance_on_file = trim(variables.retStruct.content.carrier.bipdInsuranceOnFile)>
			<cfif len(trim(bipd_Insurance_on_file))>
				<cfif not bipd_Insurance_on_file gt 0>
					<cfset variables.BIPDInsonFile=0>
				<cfelse>
					<cfset variables.BIPDInsonFile=1>
				</cfif>	
			</cfif>
			<cfset session.bipd_Insurance_on_file = trim(variables.retStruct.content.carrier.bipdInsuranceOnFile)>
		</cfif>	
		<cfif isdefined("variables.retStruct.content.carrier.cargoInsuranceRequired")>
			<cfset cargo_Insurance_required = trim(variables.retStruct.content.carrier.cargoInsuranceRequired)>
			<cfif len(trim(cargo_Insurance_required))>
				<cfif cargo_Insurance_required eq 'N'>
					<cfset variables.cargoInsRequired=0>
				<cfelse>
					<cfset variables.cargoInsRequired=1>
				</cfif>	
			</cfif>
			<cfset session.cargo_Insurance_required = trim(variables.retStruct.content.carrier.cargoInsuranceRequired)>
		</cfif>	
		<cfif isdefined("variables.retStruct.content.carrier.cargoInsuranceOnFile")>
			<cfset cargo_Insurance_on_file = trim(variables.retStruct.content.carrier.cargoInsuranceOnFile)>
			<cfset session.cargo_Insurance_on_file = trim(variables.retStruct.content.carrier.cargoInsuranceOnFile)>
			<cfif len(trim(cargo_Insurance_on_file))>
				<cfif not cargo_Insurance_on_file gt 0>
					<cfset variables.cargoInsonFile=0>
				<cfelse>
					<cfset variables.cargoInsonFile=1>
				</cfif>	
			</cfif>
		</cfif>
	</cfif>
	<cffunction name="tagStripper" access="public" output="no" returntype="string">
	    <cfargument name="source" required="YES" type="string">
	    <cfargument name="action" required="No" type="string" default="strip">
	    <cfargument name="tagList" required="no" type="string" default="">
	    <cfscript>
	    var str = arguments.source;
	    var i = 1;
	   
	    if (trim(lcase(action)) eq "preserve")
	    {
	        // strip only the exclusions
	        for (i=1;i lte listlen(arguments.tagList); i = i + 1)
	        {
	            tag = listGetAt(tagList,i);
	            str = REReplaceNoCase(str,"</?#tag#.*?>","","ALL");
	        }
	    } else {
	        // if there are exclusions, mark them with NOSTRIP
	        if (tagList neq "")
	        {
	            for (i=1;i lte listlen(tagList); i = i + 1)
	            {
	                tag = listGetAt(tagList,i);
	                str = REReplaceNoCase(str,"<(/?#tag#.*?)>","___TEMP___NOSTRIP___\1___TEMP___ENDNOSTRIP___","ALL");
	            }
	        }
	        str = reReplaceNoCase(str,"</?[A-Z].*?>","","ALL");
	        // convert excluded tags back to normal
	        str = replace(str,"___TEMP___NOSTRIP___","<","ALL");
	        str = replace(str,"___TEMP___ENDNOSTRIP___",">","ALL");
	    }
	   
	    return str; 
	    </cfscript>
	</cffunction>
	

<cffunction name="formatPhoneNumber">

   <cfargument name="phoneNumber" required="true" />

   <cfif len(phoneNumber) EQ 10>
       <!--- This only works with 10-digit US/Canada phone numbers --->
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

</cftry> --->