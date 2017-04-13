<cfparam name="description" default="">
<cfparam name="milesInterval" default="">
<cfparam name="dateInterval" default="">
<cfparam name="notes" default="">
<cfparam name="url.editid" default="">
<cfoutput>
<cfsilent>
	<cfif structkeyexists(url,"EquipmentMaintSetupId") and len(trim(url.EquipmentMaintSetupId)) gt 0>
		<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformation" EquipmentMaintSetupId="#url.EquipmentMaintSetupId#"returnvariable="request.qGetMaintenanceInformation" />
		<cfif request.qGetMaintenanceInformation.recordcount>
			<cfset  description = request.qGetMaintenanceInformation.description>
			<cfset  milesInterval = request.qGetMaintenanceInformation.milesInterval>
			<cfset  dateInterval = request.qGetMaintenanceInformation.dateInterval>
			<cfset  notes = request.qGetMaintenanceInformation.notes>
			<cfset  editid = request.qGetMaintenanceInformation.id>
		</cfif>
	</cfif>	
</cfsilent>
<cfif structkeyexists(url,"EquipmentMaintSetupId") and len(trim(url.EquipmentMaintSetupId)) gt 0>
	<div class="search-panel">
		<div class="delbutton">
			<a href="index.cfm?event=maintenanceSetUp&equimentMaintSetUpId=#url.EquipmentMaintSetupId#&EquipmentMaintSetupId=#url.EquipmentMaintSetupId#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');">
			Delete 
			</a>
		</div>
	</div>	
	<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		<div style="float: left; width: 20%;" id="divUploadedFiles">
		</div>
		<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Edit Maintenance Setup</h2></div>
	</div>
	<div style="clear:left;"></div>
<cfelse>
	<div class="white-con-area" style="height: 36px;background-color: ##82bbef;margin-top: 25px;">
		<div style="float: left; width: 20%;" id="divUploadedFiles">
		</div>
		<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Add Maintenance Setup</h2></div>
	</div>
	<div style="clear:left;"></div>
</cfif>
<div class="white-con-area">
	<div class="white-top"></div>
	<div class="white-mid">
		<cfform name="frmMaintenance" id="frmMaintenance" action="index.cfm?event=addmaintenance:process&editid=#editid#&#session.URLToken#" method="post">
			<div class="form-con">
				<fieldset style="margin-top: 16px;">
					<label>Description</label>
					<INPUT TYPE="text" class="medium-textbox applynotesPl" name="description" id="description" tabindex="1" style="margin-bottom: 10px;" value="#description#">
					<div class="clear"></div>
					
					<label>Miles Interval</label>
					<input type="text" name="milesInterval" id="milesInterval" tabindex="2" value="#milesInterval#">
					<div class="clear"></div>
					
					<label>Date Interval</label>
					<select name="dateInterval" id="dateInterval" tabindex="3" style="width:191px;">
						<option value="0" <cfif 0 eq #dateInterval#>selected="selected"</cfif>>select</option>	
						<option value="1" <cfif 1 eq #dateInterval#>selected="selected"</cfif>>1-Month</option>	
						<cfloop index = "LoopCount" from = "2" to = "60"> 
							<option value="#LoopCount#"<cfif LoopCount is '#dateInterval#'>selected="selected"</cfif>>#LoopCount#-Months</option>
						</cfloop>
					</select>
					<div class="clear"></div>
					<input type="hidden" name="editid" id="editid" value="#editid#">
					<cfset Secret = application.dsn>
					<cfset TheKey = 'NAMASKARAM'>
					<cfset Encrypted = Encrypt(Secret, TheKey)>
					<cfset dsn = ToBase64(Encrypted)>		
					<input  type="button" name="submitMaintenanceInformation" tabindex="5" class="bttn" value="Save" style="width:80px;margin-left:55px;margin-top:5px;" onclick="return validationMaintenance('#dsn#');" />
					<input  type="button" onclick="javascript:history.back();" tabindex="6" name="back" class="bttn" value="Back" style="width:70px;margin-top: 5px;" />
					<div id="errorShow" class="msg-area" style="width: 181px;margin-left: 96px; margin-top: 36px;">
						<FONT COLOR="##ba151c">Description already exists</FONT>
					</div>			
				</fieldset>
			</div>
			<div class="form-con">
				<fieldset>
					<label style="text-align:left;">Notes</label>
					<div class="clear"></div>
					<textarea name="notes" id="notes" tabindex="3" style="width: 311px;margin: 0px 0px 8px;height: 89px;">#notes#</textarea>
					<div class="clear"></div>
				</fieldset>
			</div>
			<div class="clear"></div>
		</cfform>
		<div class="clear"></div>
		<cfif structkeyexists(url,"EquipmentMaintSetupId") and len(url.EquipmentMaintSetupId) gt 1>
		<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qGetMaintenanceInformation")>&nbsp;&nbsp;&nbsp; #request.qGetMaintenanceInformation.ModifiedDate#&nbsp;&nbsp;&nbsp;</cfif></p>
		</cfif> 
	</div>
	<div class="white-bot"></div>
</cfoutput>









