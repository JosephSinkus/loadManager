
<cfoutput>
	<cfsilent>
		<cfimport taglib="../../../plugins/customtags/mytag/" prefix="myoffices" >	
		<!---Init Default Value------->
		<cfparam name="EquipmentCode" default="">
		<cfparam name="ITSCode" default="">
		<cfparam name="TranscoreCode" default="">
		<cfparam name="PosteverywhereCode" default="">
		<cfparam name="loadboardcode" default="">
		<cfparam name="Length" default="">
		<cfparam name="Width" default="">
		<cfparam name="PEPcode" default="0">
		<cfparam name="EquipmentName" default="">
		<cfparam name="Status" default="">
		<cfparam name="url.editid" default="0">
		<cfparam name="url.equipmentid" default="0">
		<cfparam name="unitNumber" default="">
		<cfparam name="vin" default="">
		<cfparam name="licensePlate" default="">
		<cfparam name="tagexpirationdate" default="">
		<cfparam name="annualDueDate" default="">
		<cfparam name="Driver" default="">
		<cfparam name="driverowned" default="0">
		<cfparam name="Notes" default="">
		<cfparam name="Odometer" default="">
		<cfparam name="url.sortorder" default="desc">
		<cfparam name="sortby"  default="">
		<cfparam name="tempEquipmentId"  default="">
		<cfset Secret = application.dsn>
		<cfset TheKey = 'NAMASKARAM'>
		<cfset Encrypted = Encrypt(Secret, TheKey)>
		<cfset dsn = ToBase64(Encrypted)>
		<cfif structkeyexists(url,"equipmentid")and structkeyexists(url,"equipmentMaintId") and structkeyexists(url,"deleteMaintItem")>
			<cfif len(trim(url.equipmentid)) gt 1 and len(trim(url.equipmentMaintId)) and url.deleteMaintItem eq 1>
				<cfinvoke component="#variables.objequipmentGateway#" method="deleteEquipmentsMaint" equipmentID="#url.equipmentid#" equipmentMaintID="#url.equipmentMaintId#" returnvariable="message">
			</cfif>
		</cfif>
		<cfinvoke component="#variables.objloadGateway#" method="getLoadSystemSetupOptions" returnvariable="request.qSystemSetupOptions1" />
		<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformation" returnvariable="request.qGetMaintenanceInformation" />
		<cfif isdefined("url.equipmentid") and len(trim(url.equipmentid)) gt 1>
			<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" EquipmentID="#url.equipmentid#" returnvariable="request.qEquipments" />
			<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformationForSelect" EquipmentID="#url.equipmentid#" returnvariable="request.qGetMaintenanceselect" />
			<cfif request.qEquipments.recordcount>
				<cfset EquipmentCode=request.qEquipments.EquipmentCode>
				<cfset EquipmentName=request.qEquipments.EquipmentName>
				<cfset PEPcode=request.qEquipments.PEPcode>
				<cfset Width=request.qEquipments.Width>
				<cfset Status=request.qEquipments.IsActive>
				<cfset editid=request.qEquipments.EquipmentID>
				<cfset unitNumber=request.qEquipments.unitNumber>
				<cfset vin=request.qEquipments.vin>
				<cfset licensePlate=request.qEquipments.licensePlate>
				<cfset tagexpirationdate=request.qEquipments.tagexpirationdate>
				<cfset annualDueDate=request.qEquipments.annualDueDate>
				<cfset Driver=request.qEquipments.Driver>
				<cfset driverowned=request.qEquipments.driverowned>
				<cfset Notes=request.qEquipments.Notes>	
				<cfset Odometer = request.qEquipments.Odometer>	
				<cfset Length=request.qEquipments.Length>
				<cfif request.qSystemSetupOptions1.freightBroker>
					<cfset ITSCode=request.qEquipments.ITSCode>
					<cfset TranscoreCode=request.qEquipments.TranscoreCode>
					<cfset PosteverywhereCode=request.qEquipments.PosteverywhereCode>
					<cfset LoadboardCode=request.qEquipments.LoadboardCode>	
				</cfif>
			</cfif>
		</cfif>
		<cfquery name="getDrivers" datasource="#application.DSN#">
			select DISTINCT carrierid, CarrierName from carriers
		</cfquery>
	</cfsilent>
	<cfif structkeyexists(url,"equipmentid") and len(trim(url.equipmentid)) gt 1>
		<cfinvoke component="#variables.objequipmentGateway#" method="getEquipmentMaintTable" editid="#editid#" returnvariable="request.qEquipmentMaint" />
		<div class="search-panel">
			<div class="delbutton">
				<cfif PEPcode neq 1>
					<a href="index.cfm?event=equipment&equipmentid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');">
					Delete 
					</a>
				</cfif>
			</div>
		</div>	
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
			<div style="float: left; width: 20%;" id="divUploadedFiles">
				&nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;margin-top:-5px;" href="##" onclick="popitupEquip('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#editid#&attachTo=57&user=#session.adminusername#&dsn=#dsn#&attachtype=Equipment')">
				<img style="vertical-align:bottom;" src="images/attachment.png">
				View/Attach Files</a>
			</div>
			<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Edit Equipment <span style="padding-left:180px;">#Ucase(EquipmentName)#</span></h2></div>
		</div>
		<div style="clear:left;"></div>
	<cfelse>
		<cfset tempEquipmentId = #createUUID()#>
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		<div style="float: left; width: 20%;" id="divUploadedFiles">
			&nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;margin-top:-5px;" href="##" onclick="popitupEquip('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempEquipmentId#&attachTo=57&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=Equipment')">
			<img style="vertical-align:bottom;" src="images/attachment.png">
			Attach Files</a>
		</div>
		<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Add New Equipment</h2></div>
	</div>
	<div style="clear:left;"></div>
	</cfif>
	<cfif structkeyexists(url,"sortorder") and url.sortorder eq 'desc'>
		<cfset sortorder="asc">
	 <cfelse>
		<cfset sortorder="desc">
	</cfif>
	<cfif structkeyexists(url,"sortby")>
		<cfinvoke component="#variables.objequipmentGateway#" method="getEquipmentMaintTable" editid="#editid#" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qEquipmentMaint" />
	</cfif> 
	<div class="white-con-area">
		<div class="white-top"></div>
		<div class="white-mid">
		<cfform name="frmEquipment" action="index.cfm?event=addequipment:process&editid=#editid#&#session.URLToken#" method="post">
			<cfinput type="hidden" name="editid" value="#editid#">
			<div class="form-con">
				<fieldset>    
					<label><strong>Equipment Code*</strong></label>
					<cfif PEPcode neq 1>
						<cfinput type="text" name="EquipmentCode"    value="#EquipmentCode#" size="25" required="yes" message="Please  enter the equipment code">
						<div class="clear"></div>  
						<label><strong>Description*</strong></label>
						<cfinput type="text" name="EquipmentName" value="#EquipmentName#" size="25" required="yes" message="Please  enter the equipment name">
					<cfelse>
						<cfinput type="text" name="EquipmentCode"    readonly  value="#EquipmentCode#" size="25" required="yes" message="Please  enter the equipment code">
						<div class="clear"></div>  
						<label><strong>Description*</strong></label>
						<cfinput type="text" name="EquipmentName"   readonly  value="#EquipmentName#" size="25" required="yes" message="Please  enter the description">
					</cfif>
					<div class="clear"></div>
					<label><strong>Length</strong></label>
					<cfinput type="text" name="Length" value="#Length#" size="4" maxlength="4" validate="integer"  style="width:40px" message="Please  enter the valid Length">
					<label style="width:84px;"> <strong>Width</strong> </label>
					<cfinput type="text" name="Width" value="#Width#" size="4" maxlength="4" validate="integer" style="width:40px" message="Please  enter the valid Width">
					<div class="clear"></div>
							
					<label><strong>Unit Number</strong></label>
					<cfinput type="text" name="unitNumber" value="#unitNumber#" size="25" message="Please enter the unit number">
					<div class="clear"></div>
					
					<label><strong>VIN</strong></label>
					<cfinput type="text" name="vin" value="#vin#" size="25" message="Please enter the vin">
					<div class="clear"></div>
					
					<label><strong>License Plate##</strong></label>
					<cfinput type="text" name="licensePlate" value="#licensePlate#" size="25" message="Please enter the license plate">
					<div class="clear"></div>
					
					<label><strong>Tag Expiration Date</strong></label>
					<cfinput class="" name="tagexpirationdate" id="tagexpirationdate" value="#dateformat(tagexpirationdate,'mm/dd/yyyy')#" type="datefield" style="width:75px;" validate="date" readOnly />
					<div class="clear"></div>
					
					<label><strong>Annual Due Date</strong></label>
					<cfinput class="" name="annualDueDate" id="annualDueDate" value="#dateformat(annualDueDate,'mm/dd/yyyy')#" type="datefield" style="width:75px;" validate="date" readOnly />
					<div class="clear"></div>
					
					<label><strong>Driver</strong></label>
					<select name="Driver" style="width:65px;">
						<cfloop query="getDrivers">
							<option value="#getDrivers.carriername#" <cfif Driver EQ getDrivers.carriername> selected </cfif> >#getDrivers.carriername#</option>
						</cfloop>
					</select>
					
					<label><strong>Driver Owned?</strong></label>
					<input type="checkbox" name="driverowned" id="driverowned" value="1" <cfif driverowned EQ 1> checked="checked" </cfif>  style="width:20px;">
					<div class="clear"></div>
					
					<label><strong>Active*</strong></label>
					<select name="Status">
					  <option value="1" <cfif Status eq '1'>selected="selected" </cfif>>Active</option>
					  <option value="0" <cfif Status eq '0'>selected="selected" </cfif>>InActive</option>
					</select>

					<label for="Odometer"><strong>Odometer</strong></label>
					<input type="text" name="Odometer" id="Odometer" value="#Odometer#">
					<input type="hidden" name="tempEquipmentId" id="tempEquipmentId" value="#tempEquipmentId#">
					
				 <!---  <div class="clear"></div>
					<label><strong>Post Everwhere</strong></label>
					 <input name="PEPcode" ID="PEPcode" type="checkbox"  style="border:none; float:left;width: 20px " <cfif PEPcode eq 1> checked="checked" </cfif> value=""  />
					<div class="clear"></div> --->
				</fieldset>
			</div>
			<div class="form-con">
				<fieldset>
					<label style="text-align:left;"><strong>Notes</strong></label>
					<div class="clear"></div>
					<textarea name="notes" id="notes" <cfif request.qSystemSetupOptions1.freightBroker> style="width:300px;"<cfelse> style="width: 311px;margin: 0px 0px 8px;height: 240px;" </cfif>  >#notes#</textarea>
					<div class="clear"></div>
					<div style="padding-left:150px;"><input  type="submit" name="submit" onclick="return validateEquipment(frmEquipment);" class="bttn" value="Save Equipment" style="width:112px;"     /><input  type="button" onclick="document.location.href='index.cfm?event=equipment&#session.URLToken#'"  name="back" class="bttn" value="Back" style="width:70px;" /></div>
					<div class="clear"></div>  		
				</fieldset>
			</div>
		</cfform>
		<div class="clear"></div>
		<cfif structkeyexists(url,"equipmentid") and len(url.equipmentid) gt 1>
		<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qEquipments")>&nbsp;&nbsp;&nbsp; #request.qEquipments.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qEquipments.LastModifiedBy#</cfif></p>
		</cfif> 
	</div>
	<div class="white-bot"></div>
	<cfif structkeyexists(url,"equipmentid") and len(url.equipmentid) gt 1>
		<div class="addbutton"  style="cursor: pointer;padding-bottom: 8px;"><a href="index.cfm?event=addNewMaintenance&equipmentid=#url.equipmentid#&#session.URLToken#">Add Maintenance</a></div>
		<cfif request.qEquipmentMaint.recordcount>
			<div class="white-con-area" style="height: 36px;background-color: ##82bbef;margin-bottom: 14px; margin-top: 33px;">
				<div style="float: left; width: 20%;" id="divUploadedFiles">
				</div>
				<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Equipment Maintenance List</h2></div>
			</div>
			<div style="clear:left;"></div>
		</cfif>	
		<cfif isdefined("message") and len(message)>
			<div class="msg-area" style="margin-top:35px;margin-bottom:11px;">#message#</div>
		</cfif>
		</div>
		<cfif request.qEquipmentMaint.recordcount>
			<table width="85%" border="0" cellspacing="0" cellpadding="0" class="data-table" id="test">
				<thead>
					<tr>
						<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
						<th align="center" valign="middle" class="head-bg">&nbsp;</th>
						<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&sortorder=#sortorder#&sortby=Description&#session.URLToken#'">Description</th>
						<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&sortorder=#sortorder#&sortby=MilesInterval&#session.URLToken#'">Miles Interval</th>
						<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&sortorder=#sortorder#&sortby=NextOdometer&#session.URLToken#'">Next Odometer</th>		
						<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&sortorder=#sortorder#&sortby=DateInterval&#session.URLToken#'">Date Interval</th>
						<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&sortorder=#sortorder#&sortby=NextDate&#session.URLToken#'">NextDate</th>
						<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&sortorder=#sortorder#&sortby=Notes&#session.URLToken#'">Notes</th>
						<!---th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&sortorder=#sortorder#&sortby=FileAttachments&#session.URLToken#'">Attachments</th--->
						<th width="100px" align="center" valign="middle" class="head-bg2" >Transactions</th>
						<th  align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="request.qEquipmentMaint">	
						<tr <cfif request.qEquipmentMaint.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
							<td height="20" class="sky-bg">&nbsp;</td>
							<td class="sky-bg2" valign="middle" align="center">#request.qEquipmentMaint.currentRow#</td>
							<td class="normal-td" valign="middle" align="left" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#'" ><a title="#request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#">#request.qEquipmentMaint.Description#</a></td>
							<td class="normal-td" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#'" ><a title="#request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#">#request.qEquipmentMaint.MilesInterval#</a></td>
							<td class="normal-td" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#'" ><a title="#request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#">#request.qEquipmentMaint.NextOdometer#</a></td>
							<td class="normal-td" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#'" ><a title="#request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#"><cfif len(trim(request.qEquipmentMaint.DateInterval))><cfif request.qEquipmentMaint.DateInterval eq 1>#request.qEquipmentMaint.DateInterval#-Month<cfelseif request.qEquipmentMaint.DateInterval eq 0><cfelse>#request.qEquipmentMaint.DateInterval#-Months</cfif><cfelse></cfif></a></td>
							<td class="normal-td" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#'" ><a title="#request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#">#DateFormat(request.qEquipmentMaint.NextDate, "mmm-dd-yyyy")#</a></td>
							<td width="150px"  class="normal-td" valign="middle" align="left" onclick="document.location.href='index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#'" ><a title="#request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#">
							<cfif len(trim(request.qEquipmentMaint.Notes)) gt 30>
								#left(request.qEquipmentMaint.Notes,15)#...#right(request.qEquipmentMaint.Notes,14)#
							<cfelse>
								#request.qEquipmentMaint.Notes#
							</cfif>
							</a>
							</td>	
							<!---td class="normal-td" valign="middle" align="left">
								<a title="#request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenance&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&#session.URLToken#">
								<cfif len(trim(request.qEquipmentMaint.FileAttachments)) gt 30>
									#left(request.qEquipmentMaint.FileAttachments,15)#...#right(request.qEquipmentMaint.FileAttachments,14)#
								<cfelse>
									#request.qEquipmentMaint.FileAttachments#
								</cfif>
								</a>
							</td--->	
							<td height="30px" class="normal-td2" valign="middle" align="center"><a title="Add Maintenance Transaction for #request.qEquipmentMaint.Description#" href="index.cfm?event=addNewMaintenanceTransaction&equipmentid=#request.qEquipments.EquipmentID#&equipmentMaintId=#request.qEquipmentMaint.EquipMainID#&pageDirection=0&#session.URLToken#"><button>Add Trans</button></a></td>	
							<td class="normal-td3">&nbsp;</td> 
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
						<td colspan="6" align="left" valign="middle" class="footer-bg">
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
		</div>
	</cfif>
</cfoutput>