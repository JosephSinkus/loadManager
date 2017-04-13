<cfparam name="url.loadid" default="0">
<cfparam name="MailTo" default="">
<cfparam name="MailFrom" default="">
<cfparam name="Subject" default="">
<cfparam name="body" default="">
<cfparam name="emailSignature" default="">
<cfset loadID = "">
<cfif  structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
	<cfset loadID = url.loadid>
</cfif>
<cfinvoke component="#variables.objloadGateway#" method="getCompanyInformation" returnvariable="request.qGetCompanyInformation" />
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
<cfinvoke component="#variables.objloadGateway#" method="getLoadCarriersMails" loadid="#loadID#" returnvariable="request.qcarriers" />
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurAgentdetails" employeID="#session.empid#" />
<cfset SmtpAddress=request.qcurAgentdetails.SmtpAddress>
<cfset SmtpUsername=request.qcurAgentdetails.SmtpUsername>
<cfset SmtpPort=request.qcurAgentdetails.SmtpPort>
<cfset SmtpPassword=request.qcurAgentdetails.SmtpPassword>
<cfset FA_SSL=request.qcurAgentdetails.useSSL>
<cfset FA_TLS=request.qcurAgentdetails.useTLS>
<cfset MailFrom=request.qcurAgentdetails.EmailID>
<cfset MailTo=request.qcarriers>
<cfset Subject = request.qGetSystemSetupOptions.WorkImpHead>
<cfset emailSignature = request.qcurAgentdetails.emailSignature>	
<cfif IsDefined("form.send")>
	<cfif form.MailTo is not "" AND form.MailFrom is not "" AND form.Subject is not "">
		<cfquery name="careerReport" datasource="#Application.dsn#">
				SELECT *, 
					(SELECT sum(weight)  from vwCarrierInterWOImport
					   <cfif structkeyexists(url,"loadno")>
							WHERE  (LoadNumber = #url.loadno#)
						<cfelseif structkeyexists(url,"loadid")>
							WHERE  (LoadID = '#url.loadid#')
					   </cfif>
					 GROUP BY loadnumber) as TotalWeight 
				FROM vwCarrierInterWOImport
			   <cfif structkeyexists(url,"loadno")>
					WHERE  (LoadNumber = #url.loadno#)
				<cfelseif structkeyexists(url,"loadid")>
					WHERE  (LoadID = '#url.loadid#')
			   </cfif>
				   ORDER BY stopnum 
		</cfquery>
		<cfoutput>
			<cfreport name="genPDF" format="PDF" template="CarrierWorkOrderImport.cfr" style="../webroot/styles/reportStyle.css" query="#careerReport#"> 
				<cfreportParam name="ReportDate" value="#DateFormat(Now(),'mm/dd/yyyy')#"> 
			</cfreport>
			<cftry>
				<cfif request.qGetCompanyInformation.ccOnEmails EQ true>
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#"  CC="#request.qGetCompanyInformation.email#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
				#form.body#
						 <cfmailparam
							file="#careerReport.loadnumber#.Import.pdf"
							type="application/pdf"
							content="#genPDF#"
							/>

					</cfmail>
				<cfelse>
					<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
			#form.body#
					 <cfmailparam
						file="#careerReport.loadnumber#.Import.pdf"
						type="application/pdf"
						content="#genPDF#"
						/>

				</cfmail>
				</cfif>
				<cfinvoke component="#variables.objloadGateway#" method="setLogMails" loadID="#loadID#" date="#Now()#" subject="#form.Subject#" emailBody="#form.body#" reportType="importWork" fromAddress="#SmtpUsername#" toAddress="#form.MailTo#" />
				<cfsavecontent variable="content">
					<div id="message" class="msg-area" style="width: 100%;display:block;"><p>Thank you, <cfoutput>#form.MailFrom#: your message has been sent</cfoutput>.</p></div>
				</cfsavecontent>
				<script>
					setTimeout(function(){
						var emailDisplayStatus='<cfoutput>#request.qGetSystemSetupOptions.AutomaticEmailReports#</cfoutput>';
						if(emailDisplayStatus == '1'){
							window.opener.document.getElementById('dispatchHiddenValue').value="Emailed Import Work Order >";
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
<form action = "index.cfm?event=loadMail&type=importWork&loadid=#loadID#&#session.URLToken#" method="POST">
	<div class="white-mid" style=" border-top: 5px solid rgb(130, 187, 239);width: 100%;">
		<div class="form-con" style="width:auto;">
			<fieldset>
			<div style="color:##000000;font-size:14px;font-weight:bold;margin-bottom:20px;margin-top:10px;">Carrier Work Order Import Mail</div>
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