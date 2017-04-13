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


<cfhttp url="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_carrlist" method="post" timeout="2">
<cfhttpparam type="formfield" NAME="n_dotno" value='' >
<cfhttpparam type="formfield" NAME="s_prefix" value="MC">
<cfhttpparam type="formfield" NAME="n_docketno" value='#MCNumber#'>
<cfhttpparam type="formfield" NAME="s_legalname" value=''>
<cfhttpparam type="formfield" NAME="s_dbaname" value=''>
<cfhttpparam type="formfield" name="s_state" value="~~">
<cfhttpparam type="formfield" name="pv_vpath" value="LIVIEW">
</cfhttp>
<cfoutput>	
<cfset Mystr=cfhttp.FileContent>

<cfset myStr1=tagStripper(Mystr,"strip","table,tr,td,a,input")>

<cfset getUSDOTFrom=findnocase('NAME="p_apcant" VALUE="',myStr1,1)>
 <cfset getUSDOTTo=findnocase('">',myStr1,getUSDOTFrom)>
<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+23)>
<cfset pv_apcant_id = trim(mid(myStr1,(getUSDOTFrom+23),USDOTLen))>

<cfif len(pv_apcant_id) gt 10>
  <cfset message ="Data not available">
  <cfexit>
</cfif>

<cfhttp url="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_getdetail" METHOD="POST" timeout="2">
<cfhttpparam TYPE="formfield" NAME="pv_apcant_id" VALUE="#pv_apcant_id#">
<cfhttpparam TYPE="formfield" NAME="pv_vpath" VALUE="LIVIEW">
</cfhttp>


<cfset Mystr=cfhttp.FileContent>

<cfset myStr1=tagStripper(Mystr,"strip","table,tr,td,a,input")>
   
 <cfset getUSDOTFrom=findnocase('US DOT:',myStr1,1)>
 <cfset getUSDOTFrom=findnocase('>&nbsp;',myStr1,getUSDOTFrom)>
 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+7)>
<cfset pv_usdot_no = trim(mid(myStr1,(getUSDOTFrom+7),USDOTLen))>

<cfif len(pv_usdot_no) lt 10>
	<cfset getUSDOTFrom=findnocase('Docket Number:',myStr1,1)>
	 <cfset getUSDOTFrom=findnocase('>&nbsp;',myStr1,getUSDOTFrom)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+7)>
	<cfset pv_pref_docket = trim(mid(myStr1,(getUSDOTFrom+7),USDOTLen))>
	
	<cfset getUSDOTFrom=findnocase('<TD COLSPAN="3" headers="lname">&nbsp;',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+38)>
	<cfset pv_legal_name = trim(mid(myStr1,(getUSDOTFrom+38),USDOTLen))>
	
	<cfset getUSDOTFrom=findnocase('<TD headers="common authority_status" width="33.3%">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+52)>
	<cfset AuthType_Common_status = trim(mid(myStr1,(getUSDOTFrom+52),USDOTLen))>
	<cfset session.AuthType_Common_status = trim(mid(myStr1,(getUSDOTFrom+52),USDOTLen))>
	
	<cfset getUSDOTFrom=findnocase('<TD headers="common application_pending" width="33.3%">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+55)>
	<cfset AuthType_Common_appPending = trim(mid(myStr1,(getUSDOTFrom+55),USDOTLen))>
	<cfset session.AuthType_Common_appPending = trim(mid(myStr1,(getUSDOTFrom+55),USDOTLen))>
	
	<cfset getUSDOTFrom=findnocase('<TD headers="contract authority_status" width="33.3%">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+54)>
	<cfset AuthType_Contract_status = trim(mid(myStr1,(getUSDOTFrom+54),USDOTLen))>
	<cfset session.AuthType_Contract_status = trim(mid(myStr1,(getUSDOTFrom+54),USDOTLen))>
	<cfset getUSDOTFrom=findnocase('<TD headers="contract application_pending" width="33.3%">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+57)>
	<cfset AuthType_Contract_appPending = trim(mid(myStr1,(getUSDOTFrom+57),USDOTLen))>
	<cfset session.AuthType_Contract_appPending = trim(mid(myStr1,(getUSDOTFrom+57),USDOTLen))>
	<cfset getUSDOTFrom=findnocase('<TD headers="broker authority_status" width="33.3%">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+52)>
	<cfset AuthType_Broker_status = trim(mid(myStr1,(getUSDOTFrom+52),USDOTLen))>
	<cfset session.AuthType_Broker_status = trim(mid(myStr1,(getUSDOTFrom+52),USDOTLen))>
	<cfset getUSDOTFrom=findnocase('<TD headers="broker application_pending" width="33.3%">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+55)>
	<cfset AuthType_Broker_appPending = trim(mid(myStr1,(getUSDOTFrom+55),USDOTLen))>
	<cfset session.AuthType_Broker_appPending = trim(mid(myStr1,(getUSDOTFrom+55),USDOTLen))>
	
	<cfset getUSDOTFrom=findnocase('<TD headers="household_goods">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+30)>
	<cfset household_goods = trim(mid(myStr1,(getUSDOTFrom+30),USDOTLen))>
	<cfset session.household_goods = trim(mid(myStr1,(getUSDOTFrom+30),USDOTLen))>
	
	<cfset getUSDOTFrom=findnocase('<TD headers="bipd Insurance_required">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+38)>
	<cfset bipd_Insurance_required = trim(mid(myStr1,(getUSDOTFrom+38),USDOTLen))>
	<cfset session.bipd_Insurance_required = trim(mid(myStr1,(getUSDOTFrom+38),USDOTLen))>
	<cfset getUSDOTFrom=findnocase('<TD headers="bipd Insurance_on_file">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+37)>
	<cfset bipd_Insurance_on_file = trim(mid(myStr1,(getUSDOTFrom+37),USDOTLen))>
	<cfset session.bipd_Insurance_on_file = trim(mid(myStr1,(getUSDOTFrom+37),USDOTLen))>
	<cfset getUSDOTFrom=findnocase('<TD headers="cargo Insurance_required">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+39)>
	<cfset cargo_Insurance_required = trim(mid(myStr1,(getUSDOTFrom+39),USDOTLen))>
	<cfset session.cargo_Insurance_required = trim(mid(myStr1,(getUSDOTFrom+39),USDOTLen))>
	
	<cfset getUSDOTFrom=findnocase('<TD headers="cargo Insurance_on_file">',myStr1,1)>
	 <cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+38)>
	<cfset cargo_Insurance_on_file = trim(mid(myStr1,(getUSDOTFrom+38),USDOTLen))>
	<cfset session.cargo_Insurance_on_file = trim(mid(myStr1,(getUSDOTFrom+38),USDOTLen))>
	<cfset getUSDOTFrom=findnocase('<TD headers="business_address">',myStr1,1)>
	<cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+31)>
	<cfset businessAddress = trim(mid(myStr1,(getUSDOTFrom+31),USDOTLen))>
	
	
	<cfset getUSDOTFrom=findnocase('<TD headers="business_tel_and_fax">',myStr1,1)>
	<cfset getUSDOTTo=findnocase('</TD>',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+35)>
	<cfset businessPhone = trim(mid(myStr1,(getUSDOTFrom+35),USDOTLen))>
	<cfset businessPhone = trim(mid(businessPhone,1,14))>
			
	<cfhttp url="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_activeinsurance" METHOD="POST" timeout="2">
	<cfhttpparam TYPE="formfield" NAME="pv_apcant_id" VALUE="#pv_apcant_id#">
	<cfhttpparam TYPE="formfield" NAME="pv_vpath" VALUE="LIVIEW">
	</cfhttp>
     
   
      
	<cfif  cfhttp.FileContent contains 'No Data Available'>
	
	<cfelse>
		
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
        <cfset InsExpDateLive = dateadd("yyyy",1,InsExpDateLive)>
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
	 
	<cfhttp url="http://li-public.fmcsa.dot.gov/LIVIEW/pkg_carrquery.prc_insfiler_details" METHOD="POST" timeout="2">
	<cfhttpparam TYPE="formfield" NAME="pv_inser_id" VALUE="#pv_inser_id#">
	<cfhttpparam TYPE="formfield" NAME="pv_apcant_id" VALUE="#pv_apcant_id#">
	<cfhttpparam TYPE="formfield" NAME="pv_vpath" VALUE="LIVIEW">
	</cfhttp>
	
	
	
	<cfset myStr1=tagStripper(cfhttp.FileContent,"strip","table,tr,td,a,input")>
	
	<cfset getUSDOTFrom=findnocase('<TD headers="icd_title">',myStr1,1)>
	<cfset getUSDOTTo=findnocase('<a href="pkg_carrquery',myStr1,getUSDOTFrom)>
	<cfset USDOTLen = getUSDOTTo - (getUSDOTFrom+24+len(insCarrier)+20)>
	<cfset insCarrierDetails = trim(mid(myStr1,(getUSDOTFrom+24+len(insCarrier)+20),USDOTLen))>
	<cfset insCarrierDetails=replace(insCarrierDetails,"<TD>",'<br/>','all')>
	<cfset insCarrierDetails=replace(insCarrierDetails,'</TD>','<br/>','all')>
	<cfif len(insCarrierDetails) gt 200>
		<cfset insCarrierDetails = "">
	</cfif>
	

	<cfset loopId=1>
	<cfloop list="#insCarrierDetails#" delimiters=":" index="tt">
		<cfif loopId is 2>
		 <cfset insAgentName = #tt#>
		 <cfset insAgentName = replacenocase(insAgentName,'Address',"","all")>
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
	
<cfelse>
	<cfset pv_usdot_no = "">
</cfif>
 </cfoutput>

	   
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
<cfcatch type="any">
	<cfif structkeyExists(url,"mcNo")>
		<cfset message="Data not available">
	</cfif>
</cfcatch>

</cftry>