<cfoutput>
<cfhttp url="https://mobile.fmcsa.dot.gov/qc/services/carriers/456789?webKey=af068b8c47236c9fadffa5791dc95a6515801b91" method="get" >

</cfhttp>
<cfset variables.retStruct = structNew()>
<cfset variables.retStruct = deserializeJson(cfhttp.Filecontent) >
<!--- <cfdump var="#variables.retStruct.content.carrier.allowedToOperate#" /><cfabort> --->
<style type="text/css">
table {
    border-collapse: collapse;
}
table, th, td {
    border: 1px solid black;
}
</style>
	<table>
		<thead>
			<tr>
				<th>allowedToOperate</th>
				<th>bipdInsuranceOnFile</th>
				<th>bipdInsuranceRequired</th>
				<th>bipdRequiredAmount</th>
				<th>bondInsuranceOnFile</th>
				<th>bondInsuranceRequired</th>
				<th>brokerAuthorityStatus</th>
				<th>cargoInsuranceOnFile</th>
				<th>cargoInsuranceRequired</th>
				<th>carrierOperationCode</th>
				<th>carrierOperationDesc</th>
				<th>commonAuthorityStatus</th>
				<th>contractAuthorityStatus</th>
				<th>crashTotal</th>
				<th>dbaName</th>
				<th>dotNumber</th>
				<th>driverInsp</th>
				<th>driverOosInsp</th>
				<th>driverOosRate</th>
				<th>driverOosRateNationalAverage</th>
				<!--- <th>ein</th> --->
				<th>fatalCrash</th>
				<th>hazmatInsp</th>
				<th>hazmatOosInsp</th>
				<th>hazmatOosRate</th>
				<th>hazmatOosRateNationalAverage</th>
				<th>injCrash</th>
				<th>isPassengerCarrier</th>
				<!--- <th>issScore</th> --->
				<th>legalName</th>
				<!--- <th>oosDate</th> --->
				<th>oosRateNationalAverageYear</th>
				<!--- <th>phone</th> --->
				<th>phyCity</th>
				<th>phyCountry</th>
				<th>phyState</th>
				<th>phyZipcode</th>
				<th>phyStreet</th>
				<th>phyZipcode</th>
				<!--- <th>reviewDate</th>
				<th>reviewType</th>
				<th>safetyRating</th>
				<th>safetyRatingDate</th>
				<th>safetyReviewDate</th>
				<th>safetyReviewType</th> --->
				<th>snapshotDate</th>
				<th>statusCode</th>
				<th>totalDrivers</th>
				<th>totalPowerUnits</th>
				<th>towawayCrash</th>
				<th>vehicleInsp</th>
				<th>vehicleOosInsp</th>
				<th>vehicleOosRate</th>
				<th>vehicleOosRateNationalAverage</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>#variables.retStruct.content.carrier.allowedToOperate#</td>
				<td>#variables.retStruct.content.carrier.bipdInsuranceOnFile#</td>
				<td>#variables.retStruct.content.carrier.bipdInsuranceRequired#</td>
				<td>#variables.retStruct.content.carrier.bipdRequiredAmount#</td>
				<td>#variables.retStruct.content.carrier.bondInsuranceOnFile#</td>
				<td>#variables.retStruct.content.carrier.bondInsuranceRequired#</td>
				<td>#variables.retStruct.content.carrier.brokerAuthorityStatus#</td>
				<td>#variables.retStruct.content.carrier.cargoInsuranceOnFile#</td>
				<td>#variables.retStruct.content.carrier.cargoInsuranceRequired#</td>
				<td>#variables.retStruct.content.carrier.carrierOperation.carrierOperationCode#</td>
				<td>#variables.retStruct.content.carrier.carrierOperation.carrierOperationDesc#</td>
				<td>#variables.retStruct.content.carrier.commonAuthorityStatus#</td>
				<td>#variables.retStruct.content.carrier.contractAuthorityStatus#</td>
				<td>#variables.retStruct.content.carrier.crashTotal#</td>
				<td>#variables.retStruct.content.carrier.dbaName#</td>
				<td>#variables.retStruct.content.carrier.dotNumber#</td>
				<td>#variables.retStruct.content.carrier.driverInsp#</td>
				<td>#variables.retStruct.content.carrier.driverOosInsp#</td>
				<td>#variables.retStruct.content.carrier.driverOosRate#</td>
				<td>#variables.retStruct.content.carrier.driverOosRateNationalAverage#</td>
				<!--- <td>#variables.retStruct.content.carrier.ein#</td> --->
				<td>#variables.retStruct.content.carrier.fatalCrash#</td>
				<td>#variables.retStruct.content.carrier.hazmatInsp#</td>
				<td>#variables.retStruct.content.carrier.hazmatOosInsp#</td>
				<td>#variables.retStruct.content.carrier.hazmatOosRate#</td>
				<td>#variables.retStruct.content.carrier.hazmatOosRateNationalAverage#</td>
				<td>#variables.retStruct.content.carrier.injCrash#</td>
				<td>#variables.retStruct.content.carrier.isPassengerCarrier#</td>
				<!--- <td>#variables.retStruct.content.carrier.issScore#</td> --->
				<td>#variables.retStruct.content.carrier.legalName#</td>
				<!--- <td>#variables.retStruct.content.carrier.oosDate#</td> --->
				<td>#variables.retStruct.content.carrier.oosRateNationalAverageYear#</td>
				<!--- <td>#variables.retStruct.content.carrier.phone#</td> --->
				<td>#variables.retStruct.content.carrier.phyCity#</td>
				<td>#variables.retStruct.content.carrier.phyCountry#</td>
				<td>#variables.retStruct.content.carrier.phyState#</td>
				<td>#variables.retStruct.content.carrier.phyStreet#</td>
				<td>#variables.retStruct.content.carrier.phyZipcode#</td>
				<td>#variables.retStruct.content.carrier.phyStreet#</td>
				<!--- <td>#variables.retStruct.content.carrier.reviewDate#</td>
				<td>#variables.retStruct.content.carrier.reviewType#</td> 
				<td>#variables.retStruct.content.carrier.safetyRating#</td>
				<td>#variables.retStruct.content.carrier.safetyRatingDate#</td>
				<td>#variables.retStruct.content.carrier.safetyReviewDate#</td>
				<td>#variables.retStruct.content.carrier.safetyReviewType#</td>--->
				<td>#variables.retStruct.content.carrier.snapshotDate#</td>
				<td>#variables.retStruct.content.carrier.statusCode#</td>
				<td>#variables.retStruct.content.carrier.totalDrivers#</td>
				<td>#variables.retStruct.content.carrier.totalPowerUnits#</td>
				<td>#variables.retStruct.content.carrier.towawayCrash#</td>
				<td>#variables.retStruct.content.carrier.vehicleInsp#</td>
				<td>#variables.retStruct.content.carrier.vehicleOosInsp#</td>
				<td>#variables.retStruct.content.carrier.vehicleOosRate#</td>
				<td>#variables.retStruct.content.carrier.vehicleOosRateNationalAverage#</td>
			</tr>
		</tbody>
		
	</table>
</cfoutput>
<!--- <cfhttp url="https://mobile.fmcsa.dot.gov/qc/services/carriers?webKey=af068b8c47236c9fadffa5791dc95a6515801b91" method="post" timeout="2">
<cfhttpparam type="formfield" NAME="n_dotno" value='' >
<cfhttpparam type="formfield" NAME="s_prefix" value="MC">
<cfhttpparam type="formfield" NAME="n_docketno" value='761894'>
<cfhttpparam type="formfield" NAME="s_legalname" value=''>
<cfhttpparam type="formfield" NAME="s_dbaname" value=''>
<cfhttpparam type="formfield" name="s_state" value="~~">
<cfhttpparam type="formfield" name="pv_vpath" value="LIVIEW">
</cfhttp>
<cfdump var="#cfhttp#" /> --->
<!--- <cfquery name="qrygetLoadid" datasource="#application.dsn#">
 select distinct(loadid) from loadstops
 order by loadid asc
</cfquery>

<cfloop query="qrygetLoadid"> --->
	<!--- 
	<cfquery name="qryGetstopNoDistinct" datasource="#application.dsn#">
		select distinct(stopNo) from loadstops
	 	where loadid='#qrygetLoadid.loadid#'
	</cfquery>	
	<cfloop query="qryGetstopNoDistinct">
		<cfquery name="qryGetshipper" datasource="#application.dsn#">
			select LoadStopID,loadid,stopdate,stopNo,loadType from loadstops
		 	where loadid='#qrygetLoadid.loadid#' and stopno=#qryGetstopNoDistinct.stopno# and loadtype=1
		</cfquery>	
		<cfquery name="qryGetconsignee" datasource="#application.dsn#">
			select LoadStopID,loadid,stopdate,stopNo,loadType from loadstops
		 	where loadid='#qrygetLoadid.loadid#' and stopno=#qryGetstopNoDistinct.stopno# and loadtype=2
		</cfquery>	
		<cfif IsValid("date",#qryGetshipper.stopdate#) and IsValid("date",#qryGetconsignee.stopdate#)>
				<!--- <cfif isDate(qryGetshipper.stopdate) and isdate(qryGetconsignee.stopdate)> --->
					<cfset variables.dateCompareResult= DateCompare(qryGetshipper.stopdate, qryGetconsignee.stopdate)>
					<cfif variables.dateCompareResult eq -1>
						<cfset variables.noOfDays=dateDiff("d", qryGetshipper.stopdate, qryGetconsignee.stopdate)>
					<cfelseif variables.dateCompareResult eq 0>
						<cfset variables.noOfDays=0>
					<cfelseif variables.dateCompareResult eq 1>	
						<cfdump var="3" />
						<cfset variables.noOfDays="">
					</cfif>
				<!--- <cfelse>
					<cfset variables.noOfDays="">		
				</cfif>	 --->
		<cfelse>
			<cfset variables.noOfDays="">	
		</cfif>	
		<cfquery name="qryGetupdatestopdateDifference" datasource="#application.dsn#">
			update loadstops set 
			stopdateDifference=<cfqueryparam cfsqltype="cf_sql_integer" value="#variables.noOfDays#" null="#yesNoFormat(NOT len(variables.noOfDays))#">	
		where loadid='#qrygetLoadid.loadid#' and stopno=#qryGetstopNoDistinct.stopno#
		</cfquery>
	</cfloop>	
</cfloop>

stopDifference field is updated<cfabort> --->
<!--- <cfquery name="qryGetStatusNumbers" datasource="#application.dsn#">
 select LoadStopID,loadid,stopdate,stopNo,loadType from loadstops
 order by loadid asc,loadtype asc ,stopno asc
</cfquery>
<cfdump var="#qryGetStatusNumbers#" /><cfabort>
<cfquery name="qryGetStatusNumbers" datasource="#application.dsn#">
	SELECT statustext,StatusTypeID
	FROM LoadStatusTypes  
	WHERE statustext between n'1'and n'9'
	GROUP BY statustext,StatusTypeID
</cfquery>
<cfabort> --->
<!---cfquery name="qryGetStatusNumbers" datasource="#application.dsn#">
	SELECT CAST(left(statustext, charindex(' ', statustext) - 1) AS float)  as statustext,StatusTypeID
	FROM LoadStatusTypes  
	WHERE IsNumeric(left(statustext, charindex(' ', statustext) - 1)) = 1 AND statustext IS NOT NULL  and left(statustext, charindex(' ', statustext) - 1) !='.'
	GROUP BY statustext,StatusTypeID
</cfquery>
<cfset variables.count=1>
<!--- Create a new three-column query, specifying the column data types --->
<cfset qryGetStatusTextNumbers = QueryNew("statusNumber,StatusTypeID","Double,varchar")> 
<!--- Make two rows in the query --->
<cfset QueryAddRow(qryGetStatusTextNumbers, qryGetStatusNumbers.recordcount)> 
<!--- Set the values of the cells in the query --->
<cfif qryGetStatusNumbers.recordcount>
	<cfloop query="qryGetStatusNumbers">
		<cfset QuerySetCell(qryGetStatusTextNumbers, "statusNumber", "#qryGetStatusNumbers.statustext#",variables.count)> 
		<cfset QuerySetCell(qryGetStatusTextNumbers, "StatusTypeID", "#qryGetStatusNumbers.StatusTypeID#",variables.count)> 
		<cfset variables.count++>
	</cfloop>
</cfif>	
<cfquery dbtype="query" name="qryGetStatusTextNumbersExtact">  
	select statusNumber,StatusTypeID from qryGetStatusTextNumbers where statusNumber between 1 and 8.9
</cfquery>

<cfdump var="#qryGetStatusNumbers#">
<cfdump var="#qryGetStatusTextNumbersExtact#"><cfabort--->

<!---cfquery name="qryGetStatusNumbers" datasource="#application.dsn#">
	SELECT CAST(left(statustext, charindex(' ', statustext) - 1) AS float)  as statustext
	FROM LoadStatusTypes  
	WHERE IsNumeric(left(statustext, charindex(' ', statustext) - 1)) = 1 AND statustext IS NOT NULL  and left(statustext, charindex(' ', statustext) - 1) !='.'
	GROUP BY statustext
</cfquery>
<cfset variables.count=1>

	<!--- Create a new three-column query, specifying the column data types --->
<cfset qryGetStatusTextNumbers = QueryNew("statusNumber","Double")> 
	<!--- Make two rows in the query --->
	<cfset QueryAddRow(qryGetStatusTextNumbers, qryGetStatusNumbers.recordcount)> 
	<!--- Set the values of the cells in the query --->
	<cfloop query="qryGetStatusNumbers">
		<cfset variables.statusTextValue=val(qryGetStatusNumbers.statustext)>
		<cfset QuerySetCell(qryGetStatusTextNumbers, "statusNumber","#val(qryGetStatusNumbers.statustext)#",variables.count)> 
		<cfset variables.count++>
	</cfloop>
	<cfquery dbtype="query" name="qryGetStatusTextNumbersExtact">  
		select statusNumber from qryGetStatusTextNumbers where statusNumber between 1 and 8.9
	</cfquery>
	<cfset variables.sete = "">
	<cfloop query="qryGetStatusTextNumbersExtact">
		<cfset variables.sete = ListAppend(variables.sete, val(qryGetStatusTextNumbersExtact.statusNumber), ",")>
	</cfloop>
	<cfdump var="#variables.sete#">
	<cfabort>
<cfset variables.sete=valuelist(qryGetStatusTextNumbersExtact.statusNumber)>
<cfdump var="#variables.sete#">
<cfdump var="#qryGetStatusTextNumbersExtact#">
<cfquery name="qryGetStatusText" datasource="#Application.dsn#">
	select CAST(left( lst.StatusText, charindex(' ',  lst.StatusText) - 1) AS float)  as statustext from loads ld
	left join LoadStatusTypes  lst on ld.StatusTypeID=lst.StatusTypeID
	where lst.StatusTypeID =<cfqueryparam value="EBE06AA0-0868-48A9-A353-2B7CF8DA9F44" cfsqltype="cf_sql_varchar">
	and ld.loadnumber=<cfqueryparam value="1000604" cfsqltype="cf_sql_integer">
	and IsNumeric(left(lst.StatusText, charindex(' ', lst.StatusText) - 1)) = 1 AND lst.StatusText IS NOT NULL  and left(lst.StatusText, charindex(' ', lst.StatusText) - 1) !='.'
	GROUP BY lst.StatusText
</cfquery>
<cfset variables.counter=1>
<!--- Create a new three-column query, specifying the column data types --->
<cfset qryGetStatusTextNumbersSet = QueryNew("statusNumberText","Double")> 
<!--- Make two rows in the query --->
<cfset QueryAddRow(qryGetStatusTextNumbersSet, qryGetStatusText.recordcount)> 
<!--- Set the values of the cells in the query --->
<cfif qryGetStatusText.recordcount>
	<cfloop query="qryGetStatusText">
		<cfset QuerySetCell(qryGetStatusTextNumbersSet, "statusNumberText", "#qryGetStatusText.statustext#",variables.counter)> 
		<cfset variables.counter++>
	</cfloop>
</cfif>	
<cfquery dbtype="query" name="qryGetStatusTextNumbersExtactMain">  
	select statusNumberText from qryGetStatusTextNumbersSet where statusNumberText between 1 and 8.9
</cfquery>
<cfdump var="#qryGetStatusTextNumbersExtactMain.statusNumberText#">
<cfset variables.set=qryGetStatusTextNumbersExtactMain.statusNumberText--->
<!---dat Api--->
<!--- <cfoutput>
	<cfsavecontent variable="soapHeaderDelAsstCoreTxt">
		<?xml version="1.0" encoding="UTF-8"?>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tcor="http://www.tcore.com/TcoreHeaders.xsd" xmlns:tcor1="http://www.tcore.com/TcoreTypes.xsd" xmlns:tfm="http://www.tcore.com/TfmiFreightMatching.xsd">
			<soapenv:Header>
				<tcor:sessionHeader soapenv:mustUnderstand="1">
				<tcor:sessionToken>
				<tcor1:primary>tfxiKq1alEZ6pMbtKa+2CmUhSzRHEna8zZh5Xd0sJpU=</tcor1:primary>
				<tcor1:secondary>uX5s6PlIJlSu06JEfT2NM3vtF4axlJIIMXPLg5ym07w=</tcor1:secondary>
				</tcor:sessionToken>
				</tcor:sessionHeader>
				<tcor:correlationHeader soapenv:mustUnderstand="0"></tcor:correlationHeader>
				<tcor:applicationHeader soapenv:mustUnderstand="0">
				<tcor:application></tcor:application>
				<tcor:applicationVersion></tcor:applicationVersion>
				</tcor:applicationHeader>
			</soapenv:Header>
			<soapenv:Body>
				<tfm:updateAssetRequest>
				<tfm:updateAssetOperation>
				<!--You have a CHOICE of the next 2 items at this level-->
				<tfm:assetId>DS18LNTC</tfm:assetId>
				<!--You have a CHOICE of the next 2 items at this level-->
				<tfm:shipmentUpdate>
					<tfm:stops>1</tfm:stops>
					<tfm:truckStops>
					<!--You have a CHOICE of the next 3 items at this level-->
					<tfm:truckStopIds>
					<!--1 or more repetitions:-->
					<tfm:ids>1</tfm:ids>
					</tfm:truckStopIds>
					<tfm:alternateClosest>
						<!--You have a CHOICE of the next 5 items at this level-->
						 <tfm:namedCoordinates>
                           <tfm:latitude></tfm:latitude>
                           <tfm:longitude></tfm:longitude>
                           <tfm:city>SMITHTOWN</tfm:city>
                           <tfm:stateProvince>NY</tfm:stateProvince>
                        </tfm:namedCoordinates>
					</tfm:alternateClosest>
					<tfm:enhancements>Highlight</tfm:enhancements>
					</tfm:truckStops>
				</tfm:shipmentUpdate>
				</tfm:updateAssetOperation>
				</tfm:updateAssetRequest>
			</soapenv:Body>
		</soapenv:Envelope>
	</cfsavecontent>
</cfoutput>
			
<cfhttp method="post" url="http://www.transcoreservices.com:8000/TfmiRequest" result="objGet">
	<cfhttpparam type="xml"  value="#trim( soapHeaderDelAsstCoreTxt )#" />
</cfhttp>
<cfdump var="#objGet#"> --->