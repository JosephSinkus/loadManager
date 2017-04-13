<cfoutput>
	<cfset variables.dateFrom= "">
	<cfset variables.dateTo= "">
	<cfset variables.start1 = createDate( #year(now())#,01, 01 )>
	<cfset variables.end1 = createDate( #year(now())#, 03, 31 )>
	<cfset variables.start2 = createDate( #year(now())#,04, 01 )>
    <cfset variables.end2 = createDate( #year(now())#, 06, 30 )>
	<cfset variables.start3 = createDate( #year(now())#,07, 01 )>
	<cfset variables.end3 = createDate( #year(now())#, 09, 30 )>
	<cfset variables.start4 = createDate( #year(now())#,10, 01 )>
    <cfset variables.end4 = createDate( #year(now())#, 12, 31 )>
	<cfset variables.today = now()>
	<cfset variables.dateFromCheck1=dateDiff("d", #variables.start1#, #variables.today#)>
	<cfset variables.dateToCheck1=dateDiff("d", #variables.today#, #variables.end1#)>
	<cfset variables.dateFromCheck2=dateDiff("d", #variables.start2#, #variables.today#)>
	<cfset variables.dateToCheck2=dateDiff("d", #variables.today#, #variables.end2#)>
	<cfset variables.dateFromCheck3=dateDiff("d", #variables.start3#, #variables.today#)>
	<cfset variables.dateToCheck3=dateDiff("d", #variables.today#, #variables.end3#)>
	<cfset variables.dateFromCheck4=dateDiff("d", #variables.start4#, #variables.today#)>
	<cfset variables.dateToCheck4=dateDiff("d", #variables.today#, #variables.end4#)>
	
    <cfif variables.dateFromCheck1 gte 0 AND variables.dateToCheck1 gte 0 >
		<cfset variables.dateFrom= DateAdd('yyyy',-1,variables.start4)>
		<cfset variables.dateTo= DateAdd('yyyy',-1,variables.end4)>
    </cfif>
	<cfif variables.dateFromCheck2 gte 0 AND variables.dateToCheck2 gte 0>
		<cfset variables.dateFrom= variables.start1>
		<cfset variables.dateTo= variables.end1>
    </cfif>
	<cfif variables.dateFromCheck3 gte 0 AND variables.dateToCheck3 gte 0>
		<cfset variables.dateFrom= variables.start2> 
		<cfset variables.dateTo= variables.end2>
    </cfif>
	<cfif variables.dateFromCheck4 gte 0 AND variables.dateToCheck4 gte 0>
		<cfset variables.dateFrom= variables.start3>
		<cfset variables.dateTo= variables.end3>
	</cfif>
	
<h1> IFTA Export</h1>
<div style="clear:left;"></div>
<div class="search-panel" style="width:100%;">
	<div class="form-search">
		<cfform id="disptaxSummary" name="disptaxSummary" action="index.cfm?event=iftaDownload&getExcel=1&#session.URLToken#" method="post" preserveData="yes">
			<fieldset>
				<cfif isdefined('url.event') AND url.event eq 'iftaDownload'>
					<label>Date From</label>
					<cfinput class="" name="DateFrom" id="DateFrom" value="#dateformat(variables.dateFrom,'mm/dd/yyyy')#" type="datefield" style="width:71px;" onblur="checkDateFormatAll(this)"/>
					
					<label>Date To</label>
					<cfinput class="" name="DateTo" id="DateTo" value="#dateformat(variables.dateTo,'mm/dd/yyyy')#" type="datefield" style="width:71px;" onblur="checkDateFormatAll(this)"/>
				</cfif>
				<div class="clear"></div>
			</fieldset>
		</cfform>
	</div>
   	<cfif isdefined('url.event') AND url.event eq 'iftaDownload'>
    	<div id="exportLink" class="exportbutton" style="margin-right: 154px;">
       		<a href="javascript:void(0);" onclick="exportTaxSummary();">Export ALL</a>
        </div>
    </cfif>
	<div class="clear"></div>
</div>
</cfoutput>