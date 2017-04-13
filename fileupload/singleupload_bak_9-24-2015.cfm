<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="X-UA-Compatible" content="IE=8" >
<script language="javascript" type="text/javascript" src="scripts/jquery-1.6.2.min.js"></script>	
<script language="javascript" type="text/javascript" src="scripts/jquery.form.js"></script>	
<link href="../webroot/styles/style.css" rel="stylesheet" type="text/css" />
<style>
	.progress { position:relative; width:400px; border: 1px solid #ddd; padding: 1px; border-radius: 3px; }
	.bar { background-image:url("../webroot/images/pbar-ani.gif"); width:0%; height:20px; border-radius: 3px; }
	.percent { position:absolute; display:inline-block; top:3px; left:48%; }
	
	input.alertbox{
	border-color:#dd0000;
}
</style></head>
<body>
<cfoutput>

<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
		<cfset fileLimit = 2097152>
		<cfset fileLimitText = 'File size should be less than 2MB!'>
	<cfelse>
		<cfset fileLimit = 10485760>
		<cfset fileLimitText = 'File size should be less than 10MB!'>
</cfif>
<cfif structkeyExists(url,"dsn")>
<!--- Decrypt String --->
<cfset TheKey = 'NAMASKARAM'>
<cfset dsn = Decrypt(ToString(ToBinary(url.dsn)), TheKey)>
</cfif>

	
<cfparam name="url.attachtype" default="">
<cfparam name="url.freightBroker" default="">

<script language="javascript">	
	var percentInt = 0;
	var progress;
	var bar;
	var percent;
	var counter=0;
	
	$(document).ready(function() {
	bar = $('.bar');
	percent = $('.percent');

	$('##fileAttachment').ajaxForm({
		url:"com/cfheadshotuploader.cfc?method=Upload",
	
		data:{ 
			   qqfile:'newfile',
			   itemID:$("##itemID").val()
			   
		},
		beforeSend: function() {
			percentVal = '0%';
			bar.width(percentVal)
			percent.html(percentVal);
			browsername=navigator.appName;

			
			if (browsername.indexOf("Microsoft")!=-1)
			{
				progress = setInterval(function(){showProgress()},3000);
			}
		},
		beforeSubmit:function(){ 
			var bool=true;
			if($("##fileAttachment ##newfile").val() =="")
			{
				//failFieldDiv('fileAttachment','newfile','Please select file','div');
				alert('Please select file');
				bool=false;
			}
			<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
			else if($("##fileAttachment ##DocType").val() =="0")
			{
				//failFieldDiv('fileAttachment','newfile','Please select file','div');
				alert('Please select Document Type');
				bool=false;
			}
			</cfif>
			else
                { 
				//var my_car=newfile.value;
				var my_car= document.getElementById('newfile').value;
				var where_is_r=my_car.indexOf('##');
				if(where_is_r >0)
				{
				
			    alert("Your File Name Contains Hash sign Please Remove it to proceed further");
				window.close();
				}
				else
				{
				//passFieldDiv('fileAttachment','newfile','div');
				}}
				
			
		if(bool)
		{	
			$("##progressbar").show();
			$(".fileupload").attr('disabled','disabled');
			$(".fileupload").val("Uploading");
		}
		
		return bool;
		
		},
		uploadProgress: function(event, position, total, percentComplete) {
		
			var percentVal = percentComplete + '%';
			bar.width(percentVal)
			percent.html(percentVal);
		},
		success:function(response) { 
		
				bar.width(100);
				percentInt =0;
				if(progress)
				{
					clearInterval(progress);
				}
				removeFile();
				response =$.parseJSON(response);
				counter++
				var newRow = '<tr><td style="color:##000000;padding-left:10px;font-size:12px;padding-right:90px;">2. Enter File Description </td><td><input type="hidden" name="file_'+counter+'" value="'+response.FILENAME+'"><input type="hidden" name="fileType_'+counter+'" value="'+$("##fileAttachment ##DocType").val()+'">'
				newRow += '<b>File Description for:</b> '+response.FILENAME+'<input type="text" name="filename_'+counter+'"></td></tr><tr><td style="color:##000000;padding-left:10px;font-size:12px;padding-right:90px;">3. Attach File to #url.attachtype#</td><td><input type="submit" name="Attach" value="Attach <cfif url.attachtype neq 'MaintTrans'>to #url.attachtype#</cfif>" style="width:150px !important;"></td></tr>'
				$("table##detail").append(newRow);
				//$("##upload").hide();
				$("##newload").show();		
    
				$("##counter").val(counter);
				$("##imagebtns").css("display","");
				$("##newupload").hide();
												
				
				 $("##progressbar").hide();
				 $(".fileupload").removeAttr('disabled');
				 $(".fileupload").val("Upload");
				 
		 },
		error:function(){
		if(progress)
		{
			clearInterval(progress);
		}
		percentInt =0;
		$("##progressbar").hide();
		$(".fileupload").removeAttr('disabled');
		$(".fileupload").val("Upload Image");
		
		}
	}); 
	
	});
function showProgress()
{
var randomnumber=Math.floor(Math.random()*20);
var prevpercent = percentInt;
percentInt = percentInt+randomnumber;
var percentVal= percentInt+'%';
if(percentInt < 100)
{
bar.width(percentVal)
percent.html(percentVal);
}
else
{
if(prevpercent <98)
{
	bar.width('98%')
	percent.html('98%');
}
clearInterval(progress);
}
}

function failFieldDiv(form,id,message,elemtype)
{
	passFieldDiv(form,id,elemtype);
	console.log('##'+form+' ##'+id);
	$('##'+form+' ##'+id).after('<'+elemtype+' id="alert-'+elemtype+'-'+form+'-'+id+'" class="alertmsg">'+message+'</'+elemtype+'>');
	$('##'+form+' ##'+id).addClass('alertbox');
}

function passFieldDiv(form,id,elemtype)
{
	$('##alert-'+elemtype+'-'+form+'-'+id).remove();
	$('##'+form+' ##'+id).removeClass('alertbox');
}	

function removeFile()
		{
			$("##divNewFile").html('<input type="file" name="newfile" id="newfile" size="27" />');
			$("##chooseFile").show();
			
		}

function popitup(filename,newFlag) {

    
    newwindow1=window.open('showAttachment.cfm?file='+filename+'&newFlag='+newFlag,'subWindow', 'resizable=1,height=500,width=500');
 	return false;
}

function DeleteFile(fileId,fileName,newFlag)
{
	var deleteYN=false;
	deleteYN = confirm('Are you sure to delete this file');
	if (deleteYN)
	 	{	
	 					$.ajax({url:"../gateways/loadgateway.cfc?method=deleteAttachments",
						data:{fileId:fileId,
						      fileName:fileName,
						      dsnName:'#dsn#',
							  newFlag:newFlag},
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

$(function(){
	$('##newfile').change(function(){
		var f = this.files[0];
		var fileSize = parseFloat(f.size)-9210;
		if(fileSize >= #fileLimit#){			
			alert('#fileLimitText#');
			$('##newfile').attr({ value: '' }); 
		}
	})
})				
</script>
<cfparam name="user" default="">
<cfparam name="url.attachtype" default="">
	<cfif structkeyexists(url,user)>
		<cfset user="#url.user#">
	<cfelseif structkeyexists(form,user)>
		<cfset user="#form.user#">	
	</cfif>
	<cfparam name="newFlag" default="0">
	<cfif structkeyexists(url,newFlag)>
		<cfset newFlag="#url.newFlag#">
	<cfelseif structkeyexists(form,newFlag)>
		<cfset newFlag="#form.newFlag#">	
	</cfif>



 <cfif structKeyExists(form,"counter") and form.counter gt 0>  

	<cfloop from="1" to="#counter#" index="i">
		<cfif newFlag eq 0>
			<cfquery name="insertFilesUploaded" datasource="#dsn#">
				insert into FileAttachments
				(linked_Id,
				linked_to,
				attachedFileLabel,
				attachmentFileName,
				<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
				DocType,
				</cfif>
				uploadedBy)
				values
				('#form.id#',
				'#form.attachTo#',
				'#evaluate("form.filename_"&i)#',
				'#evaluate("form.file_"&i)#',
				<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
				'#evaluate("form.fileType_"&i)#',
				</cfif>
				'#user#')
			</cfquery>
		<cfelse>
			<cfquery name="insertFilesUploaded" datasource="#dsn#">
				insert into FileAttachmentsTemp
				(linked_Id,
				linked_to,
				attachedFileLabel,
				attachmentFileName,
				<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
				DocType,
				</cfif>
				uploadedBy)
				values
				('#form.id#',
				'#form.attachTo#',
				'#evaluate("form.filename_"&i)#',
				'#evaluate("form.file_"&i)#',
				<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
				'#evaluate("form.fileType_"&i)#',
				</cfif>
				'#user#')
			</cfquery>
		</cfif>	
	</cfloop>
	<script language="javascript">
		//need to add code to update the div content of the opener window
		alert("Files linked to the #url.attachtype#");
		opener.focus();
		window.close();
		
	</script>
	
<cfelse>
		<cfif newFlag eq 0>
			<CFQUERY NAME="filesLinked" DATASOURCE="#dsn#">
    			SELECT * FROM FileAttachments where linked_Id='#id#' and linked_to='#attachTo#'
			</CFQUERY>
		<cfelse>
			<CFQUERY NAME="filesLinked" DATASOURCE="#dsn#">
    			SELECT * FROM FileAttachmentsTemp where linked_Id='#id#' and linked_to='#attachTo#'
			</CFQUERY>
		</cfif>	
		
	<cfif filesLinked.recordcount>
	<div>
	 	<table style="width:100%; font-weight:bold; font-size:9px;"  border="0" cellspacing="0" cellpadding="0" class="data-table">
			  <thead>
				  <tr>
					<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">File Label</p></th>
                 	<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">File Name</p></th>
				 	<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">Uploaded On</p></th>
					<!---cfif not structkeyexists(url,"newFlag")--->
						<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">View</p></th>
						<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">Delete</p></th>
					<!---/cfif--->	
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
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#filesLinked.attachedFileLabel#</td>
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#filesLinked.attachmentFileName#</td>
                 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#filesLinked.UploadedDateTime#</td>
				 <!---cfif not structkeyexists(url,"newFlag")--->
					<td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" onclick="popitup('#fileId#',<cfif structkeyexists(url,"newFlag")>#newFlag#<cfelse>0</cfif>)" title="View"><img src="../webroot/images/icon_view.png" alt="view" /></a></td>
					<td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" onclick="DeleteFile('#fileslinked.attachment_Id#','#filesLinked.attachmentFileName#',<cfif structkeyexists(url,"newFlag")>#newFlag#<cfelse>0</cfif>)" title="Delete"><img src="../webroot/images/icon_delete.png" alt="delete" /></a></td>
				<!---/cfif--->
			 </tr>
         	</cfloop>
         </tbody>
     	</table>
		</div>
		</cfif>
	</cfif>	
	<cfif not structkeyexists(url,"notShowUpload")>
	<table align="left">
		<tr>
			<td>
	<div style="color:##000000;padding-left:5px;font-size:14px;font-weight:bold;margin-top:20px;">Steps</div>
	<div id="upload">		
		<form action='singleupload.cfm?dsn=#url.dsn#&id=#url.id#' method="POST"  name="fileAttachment" id="fileAttachment" enctype="multipart/form-data">	
			<table align="left" width="100%">
				<tr height="40">
					<td colspan="3">
						<table width="100%">							
							<tr>
								<td style="color:##000000;padding-left:10px;font-size:12px;padding-right:5px;">
									1. Browse file and click Upload
								</td>
								<td>
									<span id="chooseFile">
										<div id="divNewFile"><input type="file" name="newfile" id="newfile" size="27" > </div>
									</span>
									<div id="showFile"></div>	
								</td>
								<td id="newupload">
									<input type="submit"  style="width:110px !important;" name="fileUpload" id="fileUpload" class="newButtons fileupload"  value="Upload" />
								</td>
							</tr>
							<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
								<tr>
									<td style="color:##000000;padding-left:10px;font-size:12px;padding-right:5px;">
										2. Select The Document Type
									</td>
									<td>
										<span id="chooseFile">
											<div id="selectDocType">
												<select name="DocType" id="DocType">
													<option value="0">-- Select --</option> 
													<option value="Other">Other</option>
													<option value="Agent">Agent</option>
													<option value="Customer">Customer</option>
													<option value="#url.freightBroker#">#url.freightBroker#</option>
												</select>
											</div>
										</span>	
									</td>
									<td>&nbsp;</td>
								</tr>
							</cfif>
						</table>
					</td>
				</tr>					
			</table>
		</form>
		<table align="left">
			<tr>
				<td>
					<div align="left" id="progressbar" class="progress" style="display:none;">
						<div class="bar"></div >
						<div class="percent">0%</div >
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="newload" align="left" style="display:none;">
		<form action='singleupload.cfm?dsn=#url.dsn#&attachtype=#url.attachtype#&id=#url.id#' method="post">	
				<input type="hidden" name="attachTo" value="#attachTo#">
				<input type="hidden" name="id" value="#id#">
				<input type="hidden" id="counter" name="counter" value="0">
				<input type="hidden" id="user" name="user" value="#user#">
				<input type="hidden" id="newflag" name="newflag" value="#newflag#" >
				
				<table id="detail" align="left">
				</table>
			</form>
	</div>
	<table width="100%" >
	<tr>
		<td align="center">
			<input type="button" name="Close" value="Cancel" onClick="window.close();">
		</td>
	</tr>
	</table>
</td>
</tr>
</table>
</cfif>
</cfoutput></body></html>