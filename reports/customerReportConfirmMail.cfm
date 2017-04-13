<cfparam name="url.loadid" default="0">
<cfparam name="url.customerID" default="">
<cfparam name="MailTo" default="">
<cfparam name="MailFrom" default="">
<cfparam name="Subject" default="">
<cfparam name="body" default="">
<cfparam name="emailSignature" default="">
<cfset loadID = "">
<cfset customerID = "">
<cfset loadStatus = "">
<cfif  structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
	<cfset loadID = url.loadid>
	<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#loadID#" stopNo="0" returnvariable="request.qLoads" />
	<cfset loadStatus=request.qLoads.STATUSTYPEID>
</cfif>
<cfif  structkeyexists(url,"customerID") and len(trim(url.customerID)) gt 1>
	<cfset customerID = url.customerID>
	<cftry>
		<cfquery name="careerReport" datasource="#Application.dsn#">
				select customerID, Email
				from Customers
				where customerID='#customerID#'
		</cfquery>
		<cfset MailTo= careerReport.Email>
		<cfcatch>
			<cfset MailTo="">
		</cfcatch>
	</cftry>
</cfif>
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
<cfset Subject = request.qGetSystemSetupOptions.CustInvHead>
<cfset emailSignature = request.qcurAgentdetails.emailSignature>
<cfset variables.status=''>
<cfif loadStatus eq 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F45'>
	<cfset variables.status='Rate Quote'>				
<cfelseif (loadStatus eq 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44') or (loadStatus eq 'B54D5427-A82E-4A7A-BAA1-DA95F4061EBE') or (loadStatus eq '74151038-11EA-47F7-8451-D195D73DE2E4') or(loadStatus eq 'C4C98C6D-018A-41BD-8807-58D0DE1BB0F8') or(loadStatus eq 'E62ACAA8-804B-4B00-94E0-3FE7B081C012') or(loadStatus eq 'C980CD90-F7CD-4596-B254-141EAEC90186')>
	<cfset variables.status='Rate Confirmation'>						
<cfelseif (loadStatus eq '6419693E-A04C-4ECE-B612-36D3D40CFC70') or (loadStatus eq 'CE991E00-404D-486F-89B7-6E16C61676F3') or (loadStatus eq '5C075883-B216-49FD-B0BF-851DCB5744A4') or (loadStatus eq 'C126B878-9DB5-4411-BE4D-61E93FAB8C95')>
	<cfset variables.status='Invoice'>				
</cfif>	
<cfif IsDefined("form.send")>
	<cfif form.MailTo is not "" AND form.MailFrom is not "" AND form.Subject is not "">
		<cfquery name="careerReport" datasource="#Application.dsn#">
			SELECT *, 
				(SELECT sum(weight)  from vwCarrierConfirmationReport 
				   <cfif structkeyexists(url,"loadno")>
						WHERE  (LoadNumber = #url.loadno#)
					<cfelseif structkeyexists(url,"loadid")>
						WHERE  (LoadID = '#url.loadid#')
				   </cfif>
				 GROUP BY loadnumber) as TotalWeight 
			FROM vwCustomerInvoiceReport
		   <cfif structkeyexists(url,"loadno")>
				WHERE  (LoadNumber = #url.loadno#)
			<cfelseif structkeyexists(url,"loadid")>
				WHERE  (LoadID = '#url.loadid#')
		   </cfif>
			   ORDER BY stopnum 
		</cfquery>
		<cfoutput>
			<cfreport name="genPDF" format="PDF" template="../reports/CustomerInvoiceReport.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
				<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
			</cfreport>
			<cftry>
				<cfif request.qGetCompanyInformation.ccOnEmails EQ true>
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#"  CC="#request.qGetCompanyInformation.email#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
				#form.body#
				
						 <cfmailparam
							file="#careerReport.loadnumber#.#variables.status#.pdf"
							type="application/pdf"
							content="#genPDF#"
							/>
							<!--- See if the check box on the email form for including billing documents is checked --->
							<cfif structkeyexists(form,"billingDocument")>
								
								<!--- Loop through the attachment records for this load where the attached is marked as a billing document] --->
								<cfquery name="qrygetFileAttachments" datasource="#Application.dsn#">
									select * from FileAttachments where linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.loadid#"> and	BILLINGATTACHMENTS=<cfqueryparam cfsqltype="cf_sql_bit" value="1">
							   </cfquery>	
							   
							   <cfif qrygetFileAttachments.recordcount>
									<cfloop query="qrygetFileAttachments">
											<cfset variables.path=expandpath('../')&'fileupload\img\#qrygetFileAttachments.attachmentFileName#'>
										<!---	<div id="message" class="msg-area" style="width: 100%;display:block;"><p> <cfoutput>#variables.path#</cfoutput>.</p></div>--->
											<cfmailparam disposition="attachment" 
										file="#variables.path#" type ="application/msword,application/docx,application/pdf,application/octet-stream,application/msword,text/plain,binary/octet-stream, image/pjpeg,  image/gif, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/vnd.ms-word.document.12, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"/>
										 
									</cfloop>
								</cfif>
							</cfif>	
					</cfmail>
				<cfelse>
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
				#form.body#
			
						 <cfmailparam
							file="#careerReport.loadnumber#.#variables.status#.pdf"
							type="application/pdf"
							content="#genPDF#"
							/>
							<cfif structkeyexists(form,"billingDocument")>
								<cfquery name="qrygetFileAttachments" datasource="#Application.dsn#">
									select * from FileAttachments where linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.loadid#"> and	BILLINGATTACHMENTS=<cfqueryparam cfsqltype="cf_sql_bit" value="1">
							   </cfquery>	
							   <cfif qrygetFileAttachments.recordcount>
									<cfloop query="qrygetFileAttachments">
											<cfset variables.path=expandpath('../')&'fileupload\img\#qrygetFileAttachments.attachmentFileName#'>
											<cfmailparam disposition="attachment" 
										file="#variables.path#" type ="application/msword,application/docx,application/pdf,application/octet-stream,application/msword,text/plain,binary/octet-stream, image/pjpeg,  image/gif, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/vnd.ms-word.document.12, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"/>
										 
									</cfloop>
								</cfif>
							</cfif>	
					</cfmail>
				
				</cfif>	
				<cfinvoke component="#variables.objloadGateway#" method="setLogMails" loadID="#loadID#" date="#Now()#" subject="#form.Subject#" emailBody="#form.body#" reportType="customer" fromAddress="#SmtpUsername#" toAddress="#form.MailTo#" />
				<cfsavecontent variable="content">
					<div id="message" class="msg-area" style="width: 100%;display:block;"><p>Thank you, <cfoutput>#form.MailFrom#: your message has been sent</cfoutput>.</p></div>
				</cfsavecontent>
				<script>
					setTimeout(function(){ 
						var emailDisplayStatus='<cfoutput>#request.qGetSystemSetupOptions.AutomaticEmailReports#</cfoutput>';
						if(emailDisplayStatus == '1'){
							window.opener.document.getElementById('dispatchHiddenValue').value="Emailed #variables.status# >";
							window.opener.document.getElementById('dispatchNotes').focus();
						}	
						window.close(); 
					}, 2000);				
				</script>
				<cfcatch>
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
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
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
<form action = "index.cfm?event=loadMail&type=customer&customerID=#customerID#&loadid=#loadID#&#session.URLToken#" method="POST">
	<div class="white-mid" style=" border-top: 5px solid rgb(130, 187, 239);width: 100%;">
		<div class="form-con" style="width:auto;">
			<fieldset>
			<div style="color:##000000;font-size:14px;font-weight:bold;margin-bottom:20px;margin-top:10px;">#variables.status# Mail</div>
			<div class="clear"></div>
			<cfif variables.status eq 'Invoice'>
				<input id="billingDocument" class="" type="checkbox" value="" name="billingDocument" style="width: 10px; margin-left: 95px;" checked>
				<span style="font-size: 12px;">	Include all billing documents as attachments </span>
				<div class="clear"></div>
			</cfif>	
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
			<div class="clear"></div>
			<label style="margin-top: 3px;">Mesage:</label>
			<textarea style="width:500px;height:180px;" class="addressChange" rows="" name="body" id="body" cols="">#body#	 <cfif not IsDefined("form.send")>&##13;&##10;#emailSignature#</cfif></textarea>
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