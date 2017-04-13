<cfparam name="description" default="">
<cfparam name="milesInterval" default="">
<cfparam name="dateInterval" default="">
<cfparam name="notes" default="">
<cfparam name="Nextdate" default="">
<cfparam name="url.editid" default="">
<cfparam name="editEquipmentmMaintId" default="">
<cfparam name="tempEquipmentMaint" default="">
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>
<cfoutput>
	<cfif structkeyexists(url,"equipmentid") and len(trim(url.equipmentid)) gt 0>
		<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformationForSelect" EquipmentID="#url.equipmentid#" returnvariable="request.qGetMaintenanceselect" />
		<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" EquipmentID="#url.equipmentid#" returnvariable="request.qEquipments" />
		<cfif request.qEquipments.recordcount>
			<cfset editid=request.qEquipments.equipmentid>
			<cfset Odometer = request.qEquipments.Odometer>
			<cfset EquipmentName=request.qEquipments.EquipmentName>
		</cfif>
		<cfif structkeyexists(url,"equipmentMaintId") and len(trim(url.equipmentMaintId)) gt 0>
			<cfinvoke component="#variables.objequipmentGateway#" method="getEquipmentMaintTable" editid="#url.equipmentid#" equipmentmaintid="#url.equipmentMaintId#" returnvariable="request.qEquipmentMaint" />
			<cfif request.qEquipmentMaint.recordcount>
				<cfset  description = request.qEquipmentMaint.description>
				<cfset  milesInterval = request.qEquipmentMaint.milesInterval>
				<cfset  dateInterval = request.qEquipmentMaint.dateInterval>
				<cfset  notes = request.qEquipmentMaint.notes>
				<cfset  editEquipmentmMaintId = request.qEquipmentMaint.EquipMainID>
				<cfset  Nextdate = request.qEquipmentMaint.Nextdate>
				<cfinvoke component="#variables.objequipmentGateway#" method="getEquipmentMainTransaction" editid="#editid#" equipmentMaint="#editEquipmentmMaintId#"  returnvariable="request.qryEquipmentMainTransaction" />
				<cfif structkeyexists(url,"sortorder") and url.sortorder eq 'desc'>
					<cfset sortorder="asc">
				 <cfelse>
					<cfset sortorder="desc">
				</cfif>
				<cfif structkeyexists(url,"sortby")>
					<cfinvoke component="#variables.objequipmentGateway#" method="getEquipmentMainTransaction" editid="#editid#" equipmentMaint="#editEquipmentmMaintId#" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qryEquipmentMainTransaction" />
				</cfif> 
			</cfif>
		</cfif>
	</cfif>	
	
	<cfif structkeyexists(url,"equipmentMaintId") and structkeyexists(url,"equipmentid") and len(trim(url.equipmentMaintId)) and len(trim(url.equipmentid)) gt 1>
		<cfset notesMarginTop = "margin-top:-11px;">
		<h1>Edit Maintenance</h1>
		<div class="search-panel">
			<div class="delbutton">
				<a href="index.cfm?event=addDriverEquipment&equipmentid=#editid#&equipmentMaintId=#editEquipmentmMaintId#&deleteMaintItem=1&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');">
				Delete </a>
			</div>
		</div>	
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
			<div style="float:left; width: 20%;" id="divUploadedFiles">
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;margin-top:-5px;" href="##" onclick="popitupEquip('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#editEquipmentmMaintId#&attachTo=58&user=#session.adminusername#&dsn=#dsn#&attachtype=EquipMaint')">
					<img style="vertical-align:bottom;" src="images/attachment.png">
					View/Attach Files</a>
			</div>
			<div style="float: left; width: 600px;margin-top:11px">
			    <div style="float:left;color:white;font-weight:bold;font-size: 1.5em;width:290px"><cfif len(trim(description)) lt 27>#ucase(description)#<cfelse><cfset variables.descriptionEdited=left(description,27)>#ucase(variables.descriptionEdited)#</cfif></div>
			    <div style="float:right;color:white;font-weight:bold;font-size: 1.5em;margin-left:50px;text-align:right;width:240px"><cfif len(trim(EquipmentName)) lt 24>#Ucase(EquipmentName)#<cfelse><cfset variables.EquipmentNameEdited=left(EquipmentName,24)>#ucase(variables.EquipmentNameEdited)#</cfif></div>
			</div>
			<!--div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">#ucase(description)# <span style="padding-left:180px;">#Ucase(EquipmentName)#</span></h2></div--->
			<!---div style="float: left; width: 34%;"><h2 style="color:white;font-weight:bold;">Information</h2></div--->
		</div>
	<cfelse>
		<cfset notesMarginTop = "">
		<cfset tempEquipmentMaint = #createUUID()#>
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
			<div style="float:left; width:20%;" id="divUploadedFiles">
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;margin-top:-5px;" href="##" onclick="popitupEquip('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempEquipmentMaint#&attachTo=58&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=EquipMaint')">
					<img style="vertical-align:bottom;" src="images/attachment.png">
					Attach Files</a>
			</div>
			<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Add Maintenance<span style="padding-left:180px;">#Ucase(EquipmentName)#</span></h2></div>
			<!---div style="float: left; width: 34%;"><h2 style="color:white;font-weight:bold;">Information</h2></div--->
		</div>
	</cfif>
	<div style="clear:left;"></div>
	<div class="white-con-area">
		<div class="white-top"></div>
		<div class="white-mid">
			<cfform name="frmPopUpMaintenance" action="index.cfm?event=addNewMaintenance:process&#session.URLToken#" method="post" enctype="multipart/form-data">
				<div class="form-con">
					<fieldset>
						<cfif not len(trim(description)) or not len(trim(editEquipmentmMaintId))>
							<label>Description</label>
							<select onchange="getmaintenancesetUpValues('#dsn#');" tabindex="1" style="width:194px;" id="description" name="description">
								<option value="">Select</option>
								<cfloop query="request.qGetMaintenanceselect">
									<option value="#request.qGetMaintenanceselect.description#" >#request.qGetMaintenanceselect.description#</option>
								</cfloop>
							</select>
						<cfelse>
							
						</cfif>
						<div class="clear"></div>
						<label>Miles Interval</label>
						<input type="text" name="MilesInterval" id="MilesInterval" value="#milesInterval#" tabindex="2">
						<div class="clear"></div>
						<label>Date Interval</label>
						<select name="DateInterval" id="DateInterval" tabindex="3" style="width:194px;">
							<option value="0" <cfif 0 eq dateInterval> selected="selected"</cfif>>select</option>
							<option value="1" <cfif 1 eq dateInterval> selected="selected"</cfif>>1-Month</option>
							<cfloop index = "LoopCount" from = "2" to = "36"> 
								<option value="#LoopCount#" <cfif LoopCount eq dateInterval> selected="selected"</cfif>>#LoopCount#-Months</option>
							</cfloop>
						</select>
						<div class="clear"></div>
						<label>Next Date</label>
							<cfinput name="nextDate" type="datefield" id="Date" onblur="checkDateFormatAll(this);" value="#Dateformat(Nextdate,'mm/dd/yyyy')#" tabindex="4" >
						<div class="clear"></div>
						<div class="clear" style="border-top: 1px solid ##E6E6E6;margin-top: 21px;" >&nbsp;</div>	
						<input  type="submit" name="submitMaintenanceInformation" class="bttn" value="Save" style="width:80px;margin-left:55px;margin-top:5px;" onclick="return checkValidation();" tabindex="6" />
						<input  type="button" onclick="document.location.href='index.cfm?event=addNewMaintenance:process&equipmentid=#editid##session.URLToken#'"  name="back" class="bttn" value="Back" style="width:70px;margin-top: 5px;" tabindex="7" />
						
						<input type="hidden" name="equipmentId" id="equipmentId" value="#editid#">
						<input type="hidden" name="editEquipmentmMaintId" id="editEquipmentmMaintId" value="#editEquipmentmMaintId#">
						<input type="hidden" name="Odometer" value="#Odometer#">
						<input type="hidden" name="tempEquipmentMaint" value="#tempEquipmentMaint#">
					</fieldset>
				</div>
				<div class="form-con">
					<fieldset>
						<label style="text-align:left;#notesMarginTop#">Notes</label>
						<div class="clear"></div>
						<textarea name="Notes" id="Notes" style="width: 311px;margin: 0px 0px 8px;height: 90px;" tabindex="5">#notes#</textarea>
						<div class="clear"></div>
					</fieldset>
				</div>
				<div class="clear"></div>
			</cfform>
			<div class="clear"></div>
			<cfif structkeyexists(url,"equipmentMaintId") and len(url.equipmentMaintId) gt 1>
			<p id="footer" style="padding-top: 31px;padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qEquipmentMaint")>&nbsp;&nbsp;&nbsp; #request.qEquipmentMaint.ModifiedDate#&nbsp;&nbsp;&nbsp;</cfif></p>
			</cfif> 
		</div>
		<div class="white-bot"></div>
		<cfif structkeyexists(url,"equipmentMaintId") and  structkeyexists(url,"equipmentid") and len(trim(url.equipmentMaintId)) and len(trim(url.equipmentid)) gt 1>
			<div class="addbutton"  style="cursor: pointer;padding-bottom: 8px;"><a href="index.cfm?event=addNewMaintenanceTransaction&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&pageDirection=1&#session.URLToken#">Add Trans</a></div>
			<cfif request.qryEquipmentMainTransaction.recordcount>
				<div class="white-con-area" style="height: 36px;background-color: ##82bbef;margin-bottom: 14px; margin-top: 33px;">
					<div style="float: left; width: 20%;" id="divUploadedFiles">
					</div>
					<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Equipment Maintenance Transaction List</h2></div>
				</div>
				<div style="clear:left;"></div>
			</cfif>
			<cfif isdefined("message") and len(message)>
				<div class="msg-area" style="margin-top:35px;margin-bottom:11px;">#message#</div>
			</cfif>
			</div>
			<cfif request.qryEquipmentMainTransaction.recordcount>
				<table width="85%" border="0" cellspacing="0" cellpadding="0" class="data-table">
					<thead>
						<tr>
							<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
							<th width="12" align="center" valign="middle" class="head-bg">&nbsp;</th>
							<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#url.equipmentid#&equipmentMaintId=#url.equipmentMaintId#&sortorder=#sortorder#&sortby=Odometer&#session.URLToken#'">Odometer</th>
							<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#url.equipmentid#&equipmentMaintId=#url.equipmentMaintId#&sortorder=#sortorder#&sortby=Date&#session.URLToken#'">Date</th>
							<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#url.equipmentid#&equipmentMaintId=#url.equipmentMaintId#&sortorder=#sortorder#&sortby=Notes&#session.URLToken#'">Notes</th>
							<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#url.equipmentid#&equipmentMaintId=#url.equipmentMaintId#&sortorder=#sortorder#&sortby=CreatedDate&#session.URLToken#'">CreatedDate</th>
							<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#url.equipmentid#&equipmentMaintId=#url.equipmentMaintId#&sortorder=#sortorder#&sortby=Odometer&#session.URLToken#'">Attachments</th>
							<th width="100px" align="center" valign="middle" class="head-bg2" >Actions</th>
							<th  align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="request.qryEquipmentMainTransaction">
							<cfinvoke component="#variables.objequipmentGateway#" method="getFileAttachmentDetails" EquipmentTransID="#request.qryEquipmentMainTransaction.EquipMainID#" returnvariable="request.qTransAttachments" />
							<tr <cfif request.qryEquipmentMainTransaction.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
								<td height="20" class="sky-bg">&nbsp;</td>
								<td class="sky-bg2" valign="middle" align="center" style="cursor:default;">#request.qryEquipmentMainTransaction.currentRow#</td>
								<td width="110px" class="normal-td" valign="middle" align="center" style="cursor:default;"><a href="javascript:void(0)">#request.qryEquipmentMainTransaction.Odometer#</a></td>
								<td width="110px"  class="normal-td" valign="middle" align="center" style="cursor:default;"><a href="javascript:void(0)">#DateFormat(request.qryEquipmentMainTransaction.Date, "mm-dd-yyyy")#</a></td>
								<td class="normal-td" valign="middle" align="center" style="cursor:default;"><a href="javascript:void(0)">
									<cfif len(trim(request.qryEquipmentMainTransaction.Notes)) gt 30>
										#left(request.qryEquipmentMainTransaction.Notes,15)#...#right(request.qryEquipmentMainTransaction.Notes,14)#
									<cfelse>
										#request.qryEquipmentMainTransaction.Notes#
									</cfif>
								</td>	
								<td width="110px"  class="normal-td" valign="middle" align="center" style="cursor:default;"><a href="javascript:void(0)">#DateFormat(request.qryEquipmentMainTransaction.createdDate, "mm-dd-yyyy")#</a></td>
								<td width="110px"  class="normal-td" valign="middle" align="center" style="cursor:default;">
									<cfif request.qTransAttachments.recordcount and fileexists(expandpath('../fileupload/img/#request.qTransAttachments.attachmentFileName#'))>
										<img style="cursor:pointer;" title="View Attachment of Row #request.qryEquipmentMainTransaction.currentRow#" src="../webroot/images/icon_view.png" onclick="popitupEquip('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#request.qryEquipmentMainTransaction.EquipMainID#&attachTo=59&user=#session.adminusername#&dsn=#dsn#&attachtype=MaintTrans&notShowUpload');">
									</cfif>
								</td>
								<td height="30px" class="normal-td2" valign="middle" align="center" style="cursor:default;">
									<img style="cursor:pointer;" title="Delete Row #request.qryEquipmentMainTransaction.currentRow#" src="../webroot/images/delete-icon.gif" onclick="deleteEquipmaintTrans(this,'#request.qryEquipmentMainTransaction.EquipMainID#','#dsn#','#request.qryEquipmentMainTransaction.EquipMaintID#');">
								</td>
								<td class="normal-td3">&nbsp;</td> 
							</tr>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
							<td colspan="5" align="left" valign="middle" class="footer-bg">
							<div class="up-down">
							<div class="arrow-top"><a href="##"><img src="images/arrow-top.gif" alt="" /></a></div>
							<div class="arrow-bot"><a href="##"><img src="images/arrow-bot.gif" alt="" /></a></div>
							</div>
							<div class="gen-left"><a href="##">View More</a></div>
							<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
							<div class="clear"></div>
							</td><td width="5" align="right" valign="top"  class="footer-bg">&nbsp;</td><td  class="footer-bg" width="5" align="right" valign="top">&nbsp;</td>
							<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
						</tr>	
					</tfoot>	  
				</table>
			</cfif>
		</cfif>
	</div>	
</cfoutput>
