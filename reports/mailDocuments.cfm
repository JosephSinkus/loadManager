<cfparam name="MailTo" default="">
<cfparam name="MailFrom" default="">
<cfparam name="Subject" default="">
<cfparam name="body" default="">
<cfparam name="attachto" default=10>
<cfparam name="docType" default="Other">
<cfparam name="attachText" default="">
<cfparam name="emailSignature" default="">
<cfif  structkeyexists(url,"attachto") and len(trim(url.attachto)) gt 1>
	<cfset attachto = url.attachto>
</cfif>
<cfif  structkeyexists(url,"docType") and len(trim(url.docType)) gt 1>
	<cfset docType = url.docType>
</cfif>

<cfif isDefined("url.id") and len(url.id)>
	<cfif docType eq 'carrier'>
		<cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier">
			<cfinvokeargument name="carrierid" value="#url.id#">
		</cfinvoke>
		<cfset MailTo=request.qCarrier.EmailID>
	</cfif>
	<cfif docType eq 'agent'>
		<cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" agentId="#url.id#" returnvariable="request.qAgent" />
		<cfset MailTo=request.qAgent.EmailID>
	</cfif>
	<cfif docType eq 'customer'>
		<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#url.id#" returnvariable="request.qCustomer" />
		<cfset MailTo=request.qCustomer.Email>
	</cfif>
</cfif>
<!---<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />--->
<CFQUERY NAME="filesLinked" DATASOURCE="#Application.dsn#">
	SELECT * FROM FileAttachments where linked_Id='systemsetup' and linked_to='#attachTo#' and Doctype in('other','#docType#')
</CFQUERY>
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurAgentdetails" employeID="#session.empid#" />
<cfset SmtpAddress=request.qcurAgentdetails.SmtpAddress>
<cfset SmtpUsername=request.qcurAgentdetails.SmtpUsername>
<cfset SmtpPort=request.qcurAgentdetails.SmtpPort>
<cfset SmtpPassword=request.qcurAgentdetails.SmtpPassword>
<cfset FA_SSL=request.qcurAgentdetails.useSSL>
<cfset FA_TLS=request.qcurAgentdetails.useTLS>
<cfset MailFrom=request.qcurAgentdetails.EmailID>
<cfset emailSignature = request.qcurAgentdetails.emailSignature>
<!---<cfset Subject = request.qGetSystemSetupOptions.CustInvHead>--->
	
<cfif IsDefined("form.send")>
	<cfif form.MailTo is not "" AND form.MailFrom is not "" AND form.Subject is not "">
		<cfoutput>
			<cftry>
				<cfmail from='"#SmtpUsername#" <#SmtpUsername#>' subject="#form.Subject#" to="#form.MailTo#" type="text/plain" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
					<cfif ListLen(form.FILE) gt 0>
						<cfquery dbtype="query" name="checkedFiles">
							select *
							from filesLinked
							where attachment_Id in (#form.FILE#)
						</cfquery>
						<cfset attachText = "Attachments">
						<cfloop query="checkedFiles">
							<cfset attachText= attachText & ' #checkedFiles.attachmentFileName# '>
							<cfmailparam
							file="#(expandPath('../fileupload/img/#checkedFiles.attachmentFileName#'))#"
							type="#FilegetMimeType(expandPath('../fileupload/img/#checkedFiles.attachmentFileName#'))#"
							/>
						</cfloop>
					</cfif>
					#form.body#
				</cfmail>
				<cfinvoke component="#variables.objloadGateway#" method="setLogMails" loadID="n/a" date="#Now()#" subject="#form.Subject#" emailBody="#attachText##form.body#" reportType="mailDoc" fromAddress="#SmtpUsername#" toAddress="#form.MailTo#" />
				<cfsavecontent variable="content">
					<div id="message" class="msg-area" style="width: 100%;display:block;"><p>Thank you, <cfoutput>#form.MailFrom#: your message has been sent</cfoutput>.</p></div>
				</cfsavecontent>
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
<form action = "index.cfm?event=loadMail&type=mailDoc&attachTo=10&docType=#docType#&#session.URLToken#" method="POST">
	<cfif filesLinked.recordcount neq 0>
	<div>
	 	<table style="width:100%; font-weight:bold; font-size:9px;"  border="0" cellspacing="0" cellpadding="0" class="data-table">
			  <thead>
				  <tr>
					<th width="40px" align="center" valign="middle" class="head-bg">&nbsp;</th> 
					<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">File Label</p></th>
                 	<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">File Name</p></th>
				 	<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">Uploaded On</p></th>
				    <th width="40px" align="center" valign="middle" class="head-bg"><p align="center">View</p></th>
                    <!---<th width="20px" align="center" valign="middle" class="head-bg"><p align="center">Delete</p></th>--->
             	</tr>
         	</thead>
         <tbody>
         	<cfloop query="filesLinked">
				<!--- Encrypt String --->
				<cfset Secret = filesLinked.attachment_Id>
				<cfset TheKey = 'NAMASKARAM'>
				<cfset Encrypted = Encrypt(Secret, TheKey)>
				<cfset fileId = URLEncodedFormat(ToBase64(Encrypted))>
			 <tr  onmouseover="this.style.background = '##FFFFFF';"  <cfif filesLinked.currentrow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><input type="checkbox" name="file" value="#fileslinked.attachment_Id#"></td>
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#filesLinked.attachedFileLabel#</td>
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#filesLinked.attachmentFileName#</td>
                 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#filesLinked.UploadedDateTime#</td>
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" onclick="popitup('#fileId#')" title="View"><img src="../webroot/images/icon_view.png" alt="view" /></a></td>
                 <!---<td width="20px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" onclick="DeleteFile('#fileslinked.attachment_Id#','#filesLinked.attachmentFileName#')" title="Delete"><img src="../webroot/images/icon_delete.png" alt="delete" /></a></td>--->
             </tr>
         	</cfloop>
         </tbody>
     	</table>
		</div>
		</cfif>
	<div class="white-mid" style=" border-top: 5px solid rgb(130, 187, 239);width: 100%;">
		<div class="form-con" style="width:auto;">
			<fieldset>
			<div style="color:##000000;font-size:14px;font-weight:bold;margin-bottom:20px;margin-top:10px;">Mail</div>
			<div class="clear"></div>
			<label style="margin-top: 3px;">To:</label>
			<input style="width:500px;" type="Text" name="MailTo" class="mid-textbox-1" id="MailTo" value="#MailTo#">
			<div class="clear"></div>
			<label style="margin-top: 3px;">From:</label>
			<input style="width:500px;" type="Text" name="MailFrom" class="mid-textbox-1 disabledLoadInputs" id="MailFrom" value="#MailFrom#" readonly>
			<div class="clear"></div>
			<label style="margin-top: 3px;">Subject:</label>
			<input style="width:500px;" type="Text" name="Subject" class="mid-textbox-1" id="Subject" value="#Subject#">
			<div class="clear"></div>
			<label style="margin-top: 3px;">Mesage:</label>
			<textarea style="width:500px;height:180px;max-height: 180px;max-width: 500px;" class="addressChange" rows="" name="body" id="body" cols="">#body#  <cfif not IsDefined("form.send")>&##13;&##10;#emailSignature#</cfif></textarea>
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
<script language="javascript">
function popitup(filename) {

    
    newwindow1=window.open('index.cfm?event=loadMail&type=viewDoc&file='+filename+'&#session.URLToken#','subWindow', 'resizable=1,height=500,width=500');
 	return false;
}

function DeleteFile(fileId,fileName)
{
	var deleteYN=false;
	deleteYN = confirm('Are you sure to delete this file');
	if (deleteYN)
	 	{	
	 					$.ajax({url:"../gateways/loadgateway.cfc?method=deleteAttachments",
						data:{fileId:fileId,
						      fileName:fileName,
						      dsnName:'#Application.dsn#'},
						success:function(response)
						{
						  if(response)
						  {
	 					   //opener.location.reload(true);
	 					   //need to add code to update the div content of the opener window
	 					   alert("File Deleted");
	 					   window.close();
						  }
                                                  else
                                                  {
						   alert("There was an error deleting");
						  }
						},
						error:function(response)
						{
						  alert("There was an error deleting");
						}
					    });
	 				/*}
	 				else
	 				{
	 					alert("There was an error deleting");
	 				}*/				
	 	}
	
}	
</script>
</html>
</cfoutput>