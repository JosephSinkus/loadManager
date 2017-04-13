<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoad">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<link href="../webroot/styles/style.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
var counter=0

function handleComplete(res) {
     if(res.STATUS==200) {
        counter++
        var newRow = '<tr><td><input type="hidden" name="file_'+counter+'" value="'+res.FILENAME+'">'
        newRow += 'Label the file: '+res.FILENAME+' <input type="text" name="filename_'+counter+'"></td></tr>'
        $("table#detail").append(newRow)
    }
    document.getElementById("counter").value=counter;
   }

function popitup(url) {
	newwindow1=window.open(url,'subWindow','height=200,width=200');
	return false;
}

function DeleteFile(fileId,fileName)
{
	var deleteYN=false;
	deleteYN = confirm('Are you sure to delete this file');
	if (deleteYN)
	 	{	
	 				var deleteFiles = new ajaxLoad();
	 				var confirmDeleteFile = deleteFiles.deleteAttachments(fileId,fileName);
	 				if(confirmDeleteFile)
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
	 	}
	
}

</script>

	<cfparam name="user" default=" ">
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
			<cfquery name="insertFilesUploaded" datasource="#application.dsn#">
				insert into FileAttachments(linked_Id,linked_to,attachedFileLabel,attachmentFileName,uploadedBy)
				values('#form.id#','#form.attachTo#','#evaluate("form.filename_"&i)#','#evaluate("form.file_"&i)#','#user#')
			</cfquery>
		<cfelse>
			<cfquery name="insertFilesUploaded" datasource="#application.dsn#">
				insert into FileAttachmentsTemp(linked_Id,linked_to,attachedFileLabel,attachmentFileName,uploadedBy)
				values('#form.id#','#form.attachTo#','#evaluate("form.filename_"&i)#','#evaluate("form.file_"&i)#','#user#')
			</cfquery>
		</cfif>	
	</cfloop>
	<script language="javascript">
		//opener.location.reload(true);
		//need to add code to update the div content of the opener window
		alert("Files linked to the load");
		opener.focus();
		window.close();
		
	</script>
	
<cfelse>
		<cfif newFlag eq 0>
			<CFQUERY NAME="filesLinked" DATASOURCE="#application.dsn#">
    			SELECT * FROM FileAttachments where linked_Id='#id#' and linked_to='#attachTo#'
			</CFQUERY>
		<cfelse>
			<CFQUERY NAME="filesLinked" DATASOURCE="#application.dsn#">
    			SELECT * FROM FileAttachmentsTemp where linked_Id='#id#' and linked_to='#attachTo#'
			</CFQUERY>
		</cfif>	
		
	<cfif filesLinked.recordcount neq 0>
	 	<table style="width:100%; font-weight:bold; font-size:9px;"  border="0" cellspacing="0" cellpadding="0" class="data-table">
			  <thead>
				  <tr>
					<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">File Label</p></th>
                 	<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">File Name</p></th>
				 	<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">Uploaded On</p></th>
				    <th width="40px" align="center" valign="middle" class="head-bg"><p align="center">View</p></th>
                    <th width="40px" align="center" valign="middle" class="head-bg"><p align="center">Delete</p></th>
             	</tr>
         	</thead>
         <tbody>
         	<cfoutput query="filesLinked">
             <tr style="cursor:pointer;" onmouseover="this.style.background = '##FFFFFF';"  <cfif filesLinked.currentrow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" >#filesLinked.attachedFileLabel#</a></td>
				 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" >#filesLinked.attachmentFileName#</a></td>
                 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" >#filesLinked.UploadedDateTime#</a></td>
                 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="##" onclick="popitup('img/#filesLinked.attachmentFileName#')" title="View"><img src="img/icon_view.png" alt="view" /></a></td>
                 <td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="##" onclick="DeleteFile('#fileslinked.attachment_Id#','#filesLinked.attachmentFileName#')" title="Delete"><img src="img/icon_bad.png" alt="delete" /></a></td>
             </tr>
         	</cfoutput>
         </tbody>
     	</table>
		</cfif>
	
	<cfoutput>
			
			<cfform action="index.cfm" method="post">
				<input type="hidden" name="attachTo" value="#attachTo#">
				<input type="hidden" name="id" value="#id#">
				<input type="hidden" id="counter" name="counter" value="0">
				<input type="hidden" id="user" name="user" value="#user#">
				<input type="hidden" id="newflag" name="newflag" value="#newflag#" >
				<cffileupload url="upload.cfm" name="files" oncomplete="parent.handleComplete" ><br/>
				
				<table id="detail">
				</table>
				<table width="100%">
					<tr>
						<td>
							<input type="submit" name="Attach" value="Attach to Load ">
						</td>
						<td>
							<input type="button" name="Close" value="Close">
						</td>
					</tr>
				</table>
			</cfform>
		</cfoutput>
</cfif>

