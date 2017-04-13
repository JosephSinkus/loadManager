<cfsetting requestTimeOut = "24000">
<cfparam name="url.orderDateFrom" default="">
<cfparam name="url.orderDateTo" default="">
<cfparam name="url.billDateFrom" default="">
<cfparam name="url.billDateTo" default="">

<cfset groupBy = url.groupBy>
<cfif structKeyExists(url, "orderDateFrom") and len(url.orderDateFrom)>
	<cfset orderDateFrom = url.orderDateFrom>
</cfif>
<cfif structKeyExists(url, "orderDateTo") and len(url.orderDateTo)>
	<cfset orderDateTo = url.orderDateTo>
</cfif>
<cfif structKeyExists(url, "billDateFrom") and len(url.billDateFrom)>
	<cfset billDateFrom = url.billDateFrom>
</cfif>
<cfif structKeyExists(url, "billDateTo") and len(url.billDateTo)>
	<cfset billDateTo = url.billDateTo>
</cfif>
<cfset datetype = url.datetype>
<cfset deductionPercentage = url.deductionPercentage>
<cfset salesRepFrom = url.salesRepFrom>
<cfset salesRepFromForQuery = url.salesRepFrom>
<cfset salesRepTo = url.salesRepTo>
<cfset salesRepToForQuery = url.salesRepTo>
<cfset dispatcherFrom = url.dispatcherFrom>
<cfset dispatcherFromForQuery = url.dispatcherFrom>
<cfset dispatcherTo = url.dispatcherTo>
<cfset dispatcherToForQuery = url.dispatcherTo>
<cfset marginRangeFrom = url.marginRangeFrom>
<cfset marginRangeTo = url.marginRangeTo>
<cfset deductionPercentage = url.deductionPercentage>
<cfset commissionPercentage = url.commissionPercentage>
<cfset reportType = url.reportType>
<cfset statusTo = url.statusTo>
<cfset statusFrom = url.statusFrom>
<cfset equipmentFrom = url.equipmentFrom>
<cfset equipmentFromForQuery = url.equipmentFrom>
<cfset equipmentTo= url.equipmentTo>
<cfset equipmentToForQuery= url.equipmentTo>
<cfset salesRepFromId = url.salesRepFromId>
<cfset salesRepToId = url.salesRepToId>
<cfset dispatcherFromId= url.dispatcherFromId>
<cfset dispatcherToId= url.dispatcherToId>
<cfset customerFrom = url.customerLimitFrom>
<cfset customerFromForQuery = url.customerLimitFrom>
<cfset customerTo = url.customerLimitTo>
<cfset customerToForQuery = url.customerLimitTo>
<cfset customerStatus = url.customerStatus>
<cfset freightBroker= url.freightBroker>
<cfif structKeyExists(url, "ShowSummaryStatus")>
	<cfif url.ShowSummaryStatus eq 1>
		<cfset variables.ShowSummaryStatus=1>
	<cfelse>
		<cfset variables.ShowSummaryStatus=0>	
	</cfif>	
</cfif>	
<cfif structKeyExists(url, "ShowProfit")>
	<cfif url.ShowProfit eq 1>
		<cfset variables.ShowProfit=1>
	<cfelse>
		<cfset variables.ShowProfit=0>	
	</cfif>	
</cfif>	
<cfif freightBroker eq 'Driver'>
	<cfif salesRepFrom eq "">
		<cfset salesRepFrom = "########">
	    <cfset salesRepFromForQuery = "(BLANK)">
	</cfif>
	<cfif salesRepTo eq "">
		<cfset salesRepTo = "########">
	    <cfset salesRepToForQuery = "(BLANK)">
	</cfif>
<cfelse>
	<cfif salesRepFrom eq "AAAA">
		<cfset salesRepFrom = "########">
	    <cfset salesRepFromForQuery = "(BLANK)">
	</cfif>
	<cfif salesRepTo eq "AAAA">
		<cfset salesRepTo = "########">
	    <cfset salesRepToForQuery = "(BLANK)">
	</cfif>
</cfif>	
<cfset urlMail = 'groupBy=#url.groupBy#&orderDateFrom=#url.orderDateFrom#&datetype=#url.datetype#&billDateFrom=#url.billDateFrom#&billDateTo=#url.billDateTo#&orderDateTo=#url.orderDateTo#&deductionPercentage=#url.deductionPercentage#&salesRepFrom=#url.salesRepFrom#&salesRepTo=#url.salesRepTo#&dispatcherFrom=#url.dispatcherFrom#&dispatcherTo=#url.dispatcherTo#&marginRangeFrom=#url.marginRangeFrom#&marginRangeTo=#url.marginRangeTo#&commissionPercentage=#url.commissionPercentage#&reportType=#url.reportType#&statusTo=#url.statusTo#&statusFrom=#url.statusFrom#&equipmentFrom=#url.equipmentFrom#&equipmentTo=#url.equipmentTo#&salesRepFromId=#url.salesRepFromId#&salesRepToId=#url.salesRepToId#&dispatcherFromId=#url.dispatcherFromId#&dispatcherToId=#url.dispatcherToId#&customerLimitFrom=#url.customerLimitFrom#&customerLimitTo=#customerLimitTo#&customerStatus=#customerStatus#&freightBroker=#freightBroker#&ShowSummaryStatus=#ShowSummaryStatus#&pageBreakStatus=#pageBreakStatus#&ShowProfit=#variables.ShowProfit#'>

<cfif dispatcherFrom eq "AAAA">
	<cfset dispatcherFrom = "########">
    <cfset dispatcherFromForQuery = "">
</cfif>
<cfif dispatcherTo eq "AAAA">
	<cfset dispatcherTo = "########">
    <cfset dispatcherToForQuery = "">
</cfif>

<cfif equipmentFrom eq "AAAA">
	<cfset equipmentFrom = "########">
    <cfset equipmentFromForQuery = "(BLANK)">
</cfif>
<cfif equipmentTo eq "AAAA">
	<cfset equipmentTo = "########">
    <cfset equipmentToForQuery = "(BLANK)">
</cfif>
<cfif customerFrom eq "AAAA">
	<cfset customerFrom = "########">
    <cfset customerFromForQuery = "(BLANK)">
</cfif>
<cfif customerTo eq "AAAA">
	<cfset customerTo = "########">
    <cfset customerToForQuery = "(BLANK)">
</cfif>
<cfif groupBy eq "salesAgent">
	<cfset groupBy = "Sales Agent">
	<cfset groupsBy = "SALESAGENT">
<cfelseif groupBy eq "Driver">	
	<cfset groupBy = "Driver">
	<cfset groupsBy = "Driver">
<cfelseif groupBy eq "Carrier">	
	<cfset groupBy = "Carrier">
	<cfset groupsBy = "Carrier">	
<cfelseif groupBy eq "CustName">	
	<cfset groupBy = "CustName">
	<cfset groupsBy = "CUSTOMERNAME">
<cfelseif groupBy eq "userDefinedFieldTrucking">	
	<cfset groupBy = "userDefinedFieldTrucking">
	<cfset groupsBy = "userDefinedFieldTrucking">				
<cfelseif  groupBy eq "dispatcher">
	<cfset groupBy = "Dispatcher">
	<cfset groupsBy = "DISPATCHER">
<cfelse>
	<cfset groupBy = "none">
	<cfset groupsBy = "none">
</cfif>
<cfparam name="MailTo" default="">
<cfparam name="MailFrom" default="">
<cfparam name="Subject" default="">
<cfparam name="body" default="">
<cfparam name="emailSignature" default="">
<cfinvoke component="#variables.objloadGateway#" method="getCompanyInformation" returnvariable="request.qGetCompanyInformation" />
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurAgentdetails" employeID="#session.empid#" />
<cfset SmtpAddress=request.qcurAgentdetails.SmtpAddress>
<cfset SmtpUsername=request.qcurAgentdetails.SmtpUsername>
<cfset SmtpPort=request.qcurAgentdetails.SmtpPort>
<cfset SmtpPassword=request.qcurAgentdetails.SmtpPassword>
<cfset FA_SSL=request.qcurAgentdetails.useSSL>
<cfset FA_TLS=request.qcurAgentdetails.useTLS>
<cfset MailFrom=request.qcurAgentdetails.EmailID>
<cfset Subject = request.qGetSystemSetupOptions.SalesHead>
<cfset emailSignature = request.qcurAgentdetails.emailSignature>

<cfinvoke component="#variables.objloadGateway#" AuthLevelId="1" method="getSalesPerson" returnvariable="request.qSalesPerson" />
<cfinvoke component="#variables.objloadGateway#" AuthLevelId="3" method="getSalesPerson" returnvariable="request.qDispatcher" />
<cfif groupBy eq "Sales Agent" and (salesRepFromId eq salesRepToId)>
	<cfloop query="request.qSalesPerson">
		<cfif salesRepFromId eq request.qSalesPerson.EmployeeID>
			<cfset MailTo=request.qSalesPerson.emailid>
		</cfif>
	</cfloop>
</cfif>
	
<cfif groupBy eq "Dispatcher" and (dispatcherFromId eq dispatcherToId)>
	<cfloop query="request.qDispatcher">
		<cfif dispatcherFromId eq request.qDispatcher.EmployeeID>
			<cfset MailTo=request.qDispatcher.emailid>
		</cfif>
	</cfloop>
</cfif>
	
<cfif IsDefined("form.send")>
	<cfif form.MailTo is not "" AND form.MailFrom is not "" AND form.Subject is not "">
			<cfif structkeyExists(form,"dsn")>
				<!--- Decrypt String --->
				<cfset TheKey = 'NAMASKARAM'>
				<cfset dsn = Decrypt(ToString(ToBinary(form.dsn)), TheKey)>
			</cfif>
			<cfstoredproc procedure="USP_GetLoadsForCommissionReport" datasource="#dsn#">
				<cfprocparam value="#datetype#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#orderDateFrom#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#orderDateTo#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#billDateFrom#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#billDateTo#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#groupsBy#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#groupBy#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#salesRepFromForQuery#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#salesRepToForQuery#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#dispatcherFromForQuery#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#dispatcherToForQuery#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#statusTo#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#statusFrom#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#deductionPercentage#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#equipmentFromForQuery#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#equipmentToForQuery#" cfsqltype="cf_sql_varchar">
				 <cfprocparam value="#customerFromForQuery#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#customerToForQuery#" cfsqltype="cf_sql_varchar">
				<cfprocparam value="#freightBroker#" cfsqltype="cf_sql_varchar">
				<cfprocresult name="qCommissionReportLoads">
			</cfstoredproc>
		<cfoutput>
	
			<cfif structKeyExists(url, "customerStatus")>
				<cfif url.customerStatus eq 1>
					<cfif structKeyExists(url, "pageBreakStatus")>
						<cfif url.pageBreakStatus eq 1>
							<cfset tempRootPath = expandPath("../reports/loadCommissionReportPageBreak.cfr")>
						<cfelse>
							<cfset tempRootPath = expandPath("../reports/loadCommissionReport.cfr")>
						</cfif>
					</cfif>		
				<cfelse>
					<!--- Show Customer Info,--->
					<cfif structKeyExists(url, "pageBreakStatus")>
						<cfif url.pageBreakStatus eq 1>
							<cfif url.GroupBy eq "Carrier">
								<cfset tempRootPath = expandPath("../reports/loadCommissionReportSCIPageBreakCarrierPay.cfr")>
							<cfelse>
								<cfset tempRootPath = expandPath("../reports/loadCommissionReportSCIPageBreak.cfr")>
							</cfif>
						
						<cfelse>
							<cfset tempRootPath = expandPath("../reports/loadCommissionReportSCI.cfr")> 
						</cfif>
					</cfif>	
				</cfif>	
			</cfif>	
			<cftry>
				<cfreport name="genPDF" format="pdf" template="#tempRootPath#" query="#qCommissionReportLoads#">
					<cfreportParam name="ReportType" value="#reportType#">
					<cfreportParam name="orderDateFrom" value="#orderDateFrom#">
					<cfreportParam name="orderDateTo" value="#orderDateTo#">
					<cfreportParam name="billDateFrom" value="#billDateFrom#">
					<cfreportParam name="billDateTo" value="#billDateTo#">
					<cfreportParam name="salesRepFrom" value="#salesRepFrom#">
					<cfreportParam name="salesRepTo" value="#salesRepTo#">
					<cfreportParam name="dispatcherFrom" value="#dispatcherFrom#">
					<cfreportParam name="dispatcherTo" value="#dispatcherTo#">
					<cfreportParam name="customerFrom" value="#customerFrom#">
					<cfreportParam name="customerTo" value="#customerTo#">
					<cfreportParam name="marginRangeFrom" value="#marginRangeFrom#">
					<cfreportParam name="marginRangeTo" value="#marginRangeTo#">
					<cfreportParam name="paramgroupBy" value="#groupBy#">
					<cfreportParam name="deductionPercentage" value="#deductionPercentage#">
					<cfreportParam name="equipmentFrom" value="#equipmentFrom#">
					<cfreportParam name="equipmentTo" value="#equipmentTo#">
					<cfreportParam name="freightBroker" value="#freightBroker#">
					<cfreportParam name="ShowSummaryStatus" value="#variables.ShowSummaryStatus#">
					<cfreportParam name="ShowProfit" value="#variables.ShowProfit#">
				</cfreport>
				<cfcatch>
					<cfsavecontent variable="content">
						<div id="message" class="msg-area" style="width: 100%;display:block;background: none repeat scroll 0 0 ##f4cbc8;border: 1px solid ##f2867a;"><p>Sorry! Unexpected error occurred creating pdf. Please try again later.</p></div>
					</cfsavecontent>
				</cfcatch> 
			</cftry>

			<cftry>
				<cfif url.type eq 'sales'>
					<cfset variables.sales='Sales.#DateFormat(Now(),'mm-dd-yy')#.pdf'>
				<cfelseif url.type eq 'commission'>
					<cfset variables.sales='Comm.#DateFormat(Now(),'mm-dd-yy')#.pdf'>
				</cfif> 
				<cfif request.qGetCompanyInformation.ccOnEmails EQ true>
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#"  CC="#request.qGetCompanyInformation.email#"  type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
				#form.body#
						 <cfmailparam
							file="#variables.sales#"
							type="application/pdf"
							content="#genPDF#"
							/>

					</cfmail>
				<cfelse>	
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
				#form.body#
						 <cfmailparam
							file="#variables.sales#"
							type="application/pdf"
							content="#genPDF#"
							/>

					</cfmail>
				</cfif>
				<cfinvoke component="#variables.objloadGateway#" method="setLogMails" loadID="n/a" date="#Now()#" subject="#form.Subject#" emailBody="#form.body#" reportType="sales" fromAddress="#SmtpUsername#" toAddress="#form.MailTo#" />
				
				<cfsavecontent variable="content">
					<div id="message" class="msg-area" style="width: 100%;display:block;"><p>Thank you, <cfoutput>#form.MailFrom#: your message has been sent</cfoutput>.</p></div>
				</cfsavecontent>
				<script>
					setTimeout(function(){ window.close(); }, 2000);				
				</script>
				<cfcatch>		
				<cfdump var="#cfcatch#"><cfabort>			
					<cfsavecontent variable="content">
						<div id="message" class="msg-area" style="width: 100%;display:block;background: none repeat scroll 0 0 ##f4cbc8;border: 1px solid ##f2867a;"><p>The mail is not sent.</p></div>
					</cfsavecontent>
				</cfcatch>
			</cftry>
		</cfoutput>
	<cfelse>
		<cfoutput>		
		<cfsavecontent variable="content">
			<div id="message" class="msg-area" style="width: 100%;display:block;background: none repeat scroll 0 0 ##f4cbc8;border: 1px solid ##f2867a;"><p>Please provide details like 'From', 'To' and 'Subject'.</p></div>
		</cfsavecontent>
		</cfoutput>
	</cfif>
</cfif>
					   
<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="X-UA-Compatible" content="IE=8" >
<script language="javascript" type="text/javascript" src="scripts/jquery-1.6.2.min.js"></script>	
<script language="javascript" type="text/javascript" src="scripts/jquery.form.js"></script>	
<link href="../webroot/styles/style.css" rel="stylesheet" type="text/css" />
<style>
	.progress { position:relative; width:400px; border: 1px solid ##ddd; padding: 1px; border-radius: 3px; }
	.bar { background-image:url("../webroot/images/pbar-ani.gif"); width:0%; height:20px; border-radius: 3px; }
	.percent { position:absolute; display:inline-block; top:3px; left:48%; }
	
	input.alertbox{
	border-color:##dd0000;
}
</style></head>
<body>
</body>  

<cfif isDefined('content')>
#content#
</cfif>
<p> 
<form action = "index.cfm?event=loadMail&#urlMail#&type=#url.type#&#session.URLToken#" method="POST">
	<div class="white-mid" style=" border-top: 5px solid rgb(130, 187, 239);width: 100%;">
		<div class="form-con" style="width:auto;">
			<fieldset>
			<div style="color:##000000;font-size:14px;font-weight:bold;margin-bottom:20px;margin-top:10px;">Sales Report Mail</div>
			<div class="clear"></div>
			<label style="margin-top: 3px;">To:</label>
			<input style="width:500px;" type="Text" name="MailTo" class="mid-textbox-1" id="MailTo" value="#MailTo#">
			<div class="clear"></div>
			<label style="margin-top: 3px;">From:</label>
			<input style="width:500px;" type="Text" name="MailFrom" class="mid-textbox-1 disabledLoadInputs" id="MailFrom" value="#MailFrom#" readonly>
			<div class="clear"></div>
			<cfif request.qGetCompanyInformation.ccOnEmails EQ true>
				<label style="margin-top: 3px;">Cc:</label>
				<input style="width:500px;" type="Text" name="cCMail" class="mid-textbox-1 disabledLoadInputs" id="cCMail" value="#request.qGetCompanyInformation.email#" readonly>
				<div class="clear"></div>
			</cfif>
			<label style="margin-top: 3px;">Subject:</label>
			<input style="width:500px;" type="Text" name="Subject" class="mid-textbox-1" id="Subject" value="#Subject#">
			<cfif structkeyExists(url,"dsn")>
				<input  type="hidden" name="dsn" value="#url.dsn#">
			</cfif>	
			<div class="clear"></div>
			<label style="margin-top: 3px;">Mesage:</label>
			<textarea style="width:500px;height:180px;" class="addressChange" rows="" name="body" id="body" cols="">#body# <cfif not IsDefined("form.send")>&##13;&##10;#emailSignature#</cfif></textarea>
			<div class="clear"></div>
			</fieldset>
		</div>
	</div>
	<div class="white-mid" style="width:auto;">
		<div class="form-con" style="bottom: 0px; position: absolute; background-color: rgb(130, 187, 239); width: 100%; padding: 2px 5px;">
			<fieldset>
				<div style="width:auto;">
					<input type = "Submit" name = "send" value="Send">
				</div>
			</fieldset>
		</div>
	</div>
</p> 
</form> 
</html>
</cfoutput>