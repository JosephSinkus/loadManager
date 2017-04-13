<!DOCTYPE html><html dir="ltr" lang="en-US">
	<head>
		<meta charset="UTF-8" />
		<!-- Plupload Rules -->
		<title>Plupload: UI Widget</title>
		<meta name="msvalidate.01" content="CF6A500C2AC11792DD10D5D7A77C685D" />
		<link href="/favicon.ico" rel="shortcut icon" />
		<link type="text/css" rel="stylesheet" href="../css/bootstrap.css" media="screen" />
		<link type="text/css" rel="stylesheet" href="../css/font-awesome.min.css" media="screen" />
		<link type="text/css" rel="stylesheet" href="../css/my.css" media="screen" />
		<link type="text/css" rel="stylesheet" href="../css/prettify.css" media="screen" />
		<link type="text/css" rel="stylesheet" href="../css/shCore.css" media="screen" />
		<link type="text/css" rel="stylesheet" href="../css/shCoreEclipse.css" media="screen" />
		<link type="text/css" rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/themes/smoothness/jquery-ui.min.css" media="screen" />
		<link type="text/css" rel="stylesheet" href="../css/jquery.ui.plupload.css" media="screen" />
		<link href="../../webroot/styles/style.css" rel="stylesheet" type="text/css" />
		<!---style>
			.progress { position:relative; width:400px; border: 1px solid #ddd; padding: 1px; border-radius: 3px; }
			.bar { background-image:url("../../webroot/images/pbar-ani.gif"); width:0%; height:20px; border-radius: 3px; }
			.percent { position:absolute; display:inline-block; top:3px; left:48%; }
			
			input.alertbox{
			border-color:#dd0000;
		}
		</style--->
		<!--[if lte IE 7]>
		<link rel="stylesheet" type="text/css" href="http://www.plupload.com/css/my_ie_lte7.css" />
		<![endif]-->
		<link href="https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,400,600,700,300|Bree+Serif" rel="stylesheet" type="text/css">
		<!--[if IE]>
		<link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:300italic" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:400italic" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:600italic" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:700italic" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:300" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:400" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:600" rel="stylesheet" type="text/css">
		<link href="http://fonts.googleapis.com/css?family=Bree+Serif:400" rel="stylesheet" type="text/css">
		<![endif]-->
		<!--[if IE 7]>
			<link rel="stylesheet" href="http://www.plupload.com/css/font-awesome-ie7.min.css">
		<![endif]-->
		<!--[if lt IE 9]>
		<script src="http://www.plupload.com/js/html5shiv.js"></script>
		<![endif]-->
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js" charset="UTF-8"></script>
		<script language="javascript" type="text/javascript" src="../scripts/jquery.form.js"></script>	
	</head>
	<body >
		<cfoutput>
			<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
					<cfset fileLimit ='2mb'>
					<cfset fileLimitText = 'File size should be less than 2MB!'>
				<cfelse>
					<cfset fileLimit = '10mb'>
					<cfset fileLimitText = 'File size should be less than 10MB!'>
			</cfif>
			<cfif structkeyExists(url,"dsn")>
			<!--- Decrypt String --->
			<cfset TheKey = 'NAMASKARAM'>
			<cfset dsn = Decrypt(ToString(ToBinary(url.dsn)), TheKey)>
			</cfif>
			<cfparam name="url.attachtype" default="">
			<cfparam name="url.freightBroker" default="">
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
			<div class="container">
				<div class="clearfix"> </div>
				<div id="example">
					<div id="uploader" style="margin: 46px 46px 46px 56px;">
						<!---p>Your browser doesn't have Flash, Silverlight or HTML5 support.</p--->
					</div>
					<script type="text/javascript">
					// Initialize the widget when the DOM is ready
					$(function() {
						var counter=1;
						var filename="";
						$("##uploader").plupload({
							// General settings
							runtimes : 'html5,flash,silverlight,html4',
							url : "../com/cfheadshotuploader.cfc?method=Upload&qqfile='newfile'&flag=#newFlag#",

							// Maximum file size
							/*max_file_size : '#fileLimit#',*/

							/*chunk_size: '1mb',*/

							// Resize images on clientside if we can
							resize : {
								width : 200, 
								height : 200, 
								quality : 90,
								crop: true // crop to exact dimensions
							},

							// Specify what files to browse for
							/*filters : [
								{title : "Image files", extensions : "jpg,gif,png"}
								{title : "Zip files", extensions : "zip,avi"}
							],*/

							// Rename files by clicking on their titles
							rename: true,
							
							// Sort files
							sortable: true,

							// Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
							dragdrop: true,

							// Views to activate
							views: {
								list: true,
								thumbs: true, // Show thumbs
								active: 'thumbs'
							},

							// Flash settings
							flash_swf_url : '../js/Moxie.swf',
						
							// Silverlight settings
							silverlight_xap_url : '../js/Moxie.xap',
							init: {
								FilesAdded: function (up, files) {},
				
								UploadComplete: function (up, files) {
									// destroy the uploader and init a new one
								
									if(up.files.length){
										for(i=0;i<up.files.length;i++){
												var newRow = '<tr><td style="color:##000000;padding-left:10px;font-size:12px;padding-right:90px;">'+counter+'. Enter File Description </td><td><input type="hidden" name="file_'+counter+'" value="'+up.files[i].name+'"><input type="hidden" name="fileType_'+counter+'" value="'+$("##fileAttachment ##DocType").val()+'">'
					newRow += '<b>File Description for:</b> '+up.files[i].name+'<input type="text" name="filename_'+counter+'"></td></tr>';
					var nextLineRow='<tr><td></td><td ><input type="checkbox" name="billingDocument'+counter+'" id="billingDocument'+counter+'" style="margin-top: -2px;"/> <b>Billing Document</b></td></tr>'
												$("table##detail").append(newRow);
												$("table##detail").append(nextLineRow);
												newRow='';
												counter++;
										}
										var newRow1='<tr><td style="color:##000000;padding-left:10px;font-size:12px;padding-right:90px;">'+counter+'. Attach File to #url.attachtype#</td><td><input type="submit" name="Attach" value="Attach <cfif url.attachtype neq 'MaintTrans'>to #url.attachtype#</cfif>" style="width:150px !important;"></td></tr>';
										$("table##detail").append(newRow1);
										$("##newload").show();
										$("##step").show();
										$("##counter").val(up.files.length);
									}
								
								},
								  FileUploaded: function(up, file, info) {
									var response = $.parseJSON(info.response);
									if(filename == ""){
										filename=response.FILENAME;									
									}else{
										filename=filename +','+ response.FILENAME;
									}
									var newRow2='<tr><td><input type="hidden" name="fileNamesServer" value="'+filename+'"></td></tr>';
									var count=filename.split(',');
									if(up.files.length == count.length){
										$("table##detail").append(newRow2);
									}
								  },
							},
							preinit: {
										BeforeUpload: function (up) {
										   <cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
											if($("##fileAttachment ##DocType").val() =="0")
											{
												//failFieldDiv('fileAttachment','newfile','Please select file','div');
												alert('Please select Document Type');
												return false;
											}
											</cfif>
										}
									},
			
						});
													

					
					});
					function updateBillingDocument(id,ele){
						var chechedStatus=0;
						var dsnvalue='#dsn#';
						if($(ele).prop("checked") == true){
							chechedStatus=1;
						}
						else if($(ele).prop("checked") == false){
							chechedStatus=0;
						}
						$.ajax({
							type : 'POST',
							url:"../com/cfheadshotuploader.cfc?method=UpdateBillingDocument&flag=#newFlag#",
							data:{
								attachid:id,
								checkedStatus:chechedStatus,
								dsn:dsnvalue
							},
							success:function(data){
								var jsondata=$.parseJSON(data);
								var attachid=jsondata.attachid;
								var checkedStatus=jsondata.checkedStatus;
								if(attachid !=""){
									if (checkedStatus == 0){
										$('##'+attachid).html('InActive');
									}else{
										$('##'+attachid).html('Active');
									}	
								} 
								
							},
							error:function(error){
								
							}
						});
					}
				</script>
				</div>
			</div>
		
		<script type="text/javascript" src="../js/bootstrap.js" charset="UTF-8"></script>
		<script type="text/javascript" src="../js/shCore.js" charset="UTF-8"></script>
		<script type="text/javascript" src="../js/shBrushPhp.js" charset="UTF-8"></script>
		<script type="text/javascript" src="../js/shBrushjScript.js" charset="UTF-8"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js" charset="UTF-8"></script>
		<script type="text/javascript" src="../js/plupload.full.min.js" charset="UTF-8"></script>
		<script type="text/javascript" src="../js/jquery.ui.plupload.min.js" charset="UTF-8"></script>
		<script type="text/javascript" src="../js/themeswitcher.js" charset="UTF-8"></script>
		<script language="javascript">	
			var percentInt = 0;
			var progress;
			var bar;
			var percent;
			var counter=0;
		
			
			function passFieldDiv(form,id,elemtype){
				$('##alert-'+elemtype+'-'+form+'-'+id).remove();
				$('##'+form+' ##'+id).removeClass('alertbox');
			}	

			function removeFile(){
				$("##divNewFile").html('<input type="file" name="newfile" id="newfile" size="27" />');
				$("##chooseFile").show();
			}

			function popitup(filename,newFlag) {
				newwindow1=window.open('../showAttachment.cfm?file='+filename+'&newFlag='+newFlag,'subWindow', 'resizable=1,height=500,width=500');
				return false;
			}

			function DeleteFile(fileId,fileName,newFlag)
			{
				var deleteYN=false;
				deleteYN = confirm('Are you sure to delete this file');
				if (deleteYN)
					{	
									$.ajax({url:"../../gateways/loadgateway.cfc?method=deleteAttachments",
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
					<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
						<cfset variables.fileLimitCheck=2097152>
					<cfelse>
							<cfset variables.fileLimitCheck=10485760>
					</cfif>
					if(fileSize >= #variables.fileLimitCheck#){			
						alert('#fileLimitText#');
						$('##newfile').attr({ value: '' }); 
					}
				});
			});		
		</script>
		
		<cfif structKeyExists(form,"counter") and form.counter gt 0 and  structKeyExists(form,"fileNamesServer")>  
			<cfquery name="qSystemSetupOptions" datasource="#dsn#">
				SELECT numberAttachments
				FROM SystemConfig
			</cfquery>
			<cfset counter=1>
			<cfloop list="#form.fileNamesServer#" index="i">
				<cfif structKeyExists(form,"billingDocument#counter#")>
					<cfset variables.billingDocument=1>
				<cfelse>
					<cfset variables.billingDocument=0>
				</cfif>
				
				<cfif newFlag eq 0>
					<cfset tablename = "FileAttachments">
					<cfset isTempTable = "">
				<cfelse>
					<cfset tablename = "FileAttachmentsTemp">
					<cfset isTempTable = "">
				</cfif>
				<cfquery name="insertFilesUploaded" datasource="#dsn#" result="insertedId">
					insert into #tablename#
					(linked_Id,
					linked_to,
					attachedFileLabel,
					attachmentFileName,
					<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
					DocType,
					</cfif>
					uploadedBy,
					Billingattachments)
					values
					('#form.id#',
					'#form.attachTo#',
					'#evaluate("form.filename_"&counter)#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#" >,
					<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
					'#evaluate("form.fileType_"&counter)#',
					</cfif>
					'#user#',
					<cfqueryparam cfsqltype="cf_sql_bit" value="#variables.billingDocument#" >
					)
				</cfquery>
				<cfif qSystemSetupOptions.numberAttachments eq true>
					<cfset variables.attcahnumber=1>
					<cfif isnumeric(insertedId.GENERATEDKEY)>
						<cfset variables.attcahnumber=insertedId.GENERATEDKEY>
					</cfif>
					<cfset variables.filenameExt=listlast(evaluate("form.file_"&counter),'.')>
					<cfset variables.filenameEdited1=Replace(evaluate("form.file_"&counter), '#variables.filenameExt#', '#variables.attcahnumber#' ,'.')>
					<cfset variables.filenameEditedWithEXt=Replace(variables.filenameEdited1&''&isTempTable&'.'&variables.filenameExt,' ','','all')>
					<CFSET UploadDir = "#ExpandPath('../')#img\">
					<cfif not directoryExists(UploadDir)>
						<cfdirectory action="create" directory="#UploadDir#">
					</cfif>
					<cffile  action = "rename" destination = "#UploadDir##variables.filenameEditedWithEXt#"  source = "#UploadDir##i#" nameconflict="make unique">
					<cfquery name="qryUpdate" datasource="#dsn#">
						update #tablename#
						set attachmentFileName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.filenameEditedWithEXt#">
						where attachment_Id=<cfqueryparam cfsqltype="cf_sql_integer" value="#variables.attcahnumber#">
					</cfquery>	
				</cfif>
				<cfset counter++>
			</cfloop>
			<script language="javascript">
				//need to add code to update the div content of the opener window
				alert("File(s) linked to the #url.attachtype#");
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
								<th width="40px" align="center" valign="middle" class="head-bg"><p align="center">Billing Document</p></th>
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
							<td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" onclick="popitup('#fileId#',<cfif structkeyexists(url,"newFlag")>#newFlag#<cfelse>0</cfif>)" title="View"><img src="../../webroot/images/icon_view.png" alt="view" /></a></td>
							<td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">
								<form action="" method="POST"  name="Billingattachments" id="Billingattachments">	
									<input type="checkbox" name="billingAttachments_#filesLinked.attachment_Id#" id="billingAttachments_#filesLinked.attachment_Id#" onclick="updateBillingDocument(#filesLinked.attachment_Id#,this)"<cfif filesLinked.Billingattachments eq 1> checked <cfelse> </cfif> style="margin-top: -3px;"> <span id="#filesLinked.attachment_Id#" style="margin-left: 2px;"><cfif filesLinked.Billingattachments eq 1> Active <cfelse> InActive</cfif></span>
								</form>
							</td>
							<td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td"><a href="javascript:void(0);" onclick="DeleteFile('#fileslinked.attachment_Id#','#filesLinked.attachmentFileName#',<cfif structkeyexists(url,"newFlag")>#newFlag#<cfelse>0</cfif>)" title="Delete"><img src="../../webroot/images/icon_delete.png" alt="delete" /></a></td>
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
			<div style="color:##000000;padding-left:5px;font-size:14px;font-weight:bold;margin-top:20px;<cfif structkeyExists(url,"id") and url.id neq 'systemsetup'>display:none;</cfif>" id="step">Steps</div>
			<div id="upload">		
				<form action='MultipleUpload.cfm?dsn=#url.dsn#&id=#url.id#' method="POST"  name="fileAttachment" id="fileAttachment" enctype="multipart/form-data">	
					<table align="left" width="100%">
						<tr <cfif structkeyExists(url,"id") and url.id eq 'systemsetup'> height="40"</cfif>>
							<td colspan="3">
								<table width="100%">							
									<!---tr>
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
									</tr--->
									<cfif structkeyExists(url,"id") and url.id eq 'systemsetup'>
										<tr>
											<td style="color:##000000;padding-left:10px;font-size:12px;padding-right:5px;">
												Select The Document Type
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
				<!---table align="left">
					<tr>
						<td>
							<div align="left" id="progressbar" class="progress" style="display:none;">
								<div class="bar"></div >
								<div class="percent">0%</div >
							</div>
						</td>
					</tr>
				</table!--->
			</div>
			<div id="newload" align="left" style="display:none;">
				<form action='MultipleUpload.cfm?dsn=#url.dsn#&attachtype=#url.attachtype#&id=#url.id#' method="post">	
						<input type="hidden" name="attachTo" value="#attachTo#">
						<input type="hidden" name="id" value="#id#">
						<input type="hidden" id="counter" name="counter" value="0">
						<input type="hidden" id="user" name="user" value="#user#">
						<input type="hidden" id="newflag" name="newflag" value="#newflag#" >
						
						<table id="detail" align="left">
						</table>
					</form>
			</div>
			
		</td>
		</tr>
		</table>
		<table width="100%" >
			<tr>
				<td align="center">
					<input type="button" name="Close" value="Cancel" onClick="window.close();">
				</td>
			</tr>
		</table>
		</table>
		</cfif>
		</cfoutput>
	</body>
</html>
