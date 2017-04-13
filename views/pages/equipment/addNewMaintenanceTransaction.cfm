<cfparam name="url.editid" default="">
<cfparam name="variables.pageDirectionFlag" default="0">
<cfparam name="equipmaintid" default="">
<cfparam name="EquipmentName" default="">
<cfparam name="description" default="">
<cfoutput>
	<cfset Secret = application.dsn>
	<cfset TheKey = 'NAMASKARAM'>
	<cfset Encrypted = Encrypt(Secret, TheKey)>
	<cfset dsn = ToBase64(Encrypted)>

	<cfif structkeyexists(url,"equipmentid") and len(trim(url.equipmentid)) gt 0>
		<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" EquipmentID="#url.equipmentid#" returnvariable="request.qEquipments" />
		<cfif request.qEquipments.recordcount>
			<cfset EquipmentName=request.qEquipments.EquipmentName>
			<cfset EquipmentOdometer=request.qEquipments.odometer>
		</cfif>
		<cfif structkeyexists(url,"equipmentMaintId") and len(trim(url.equipmentMaintId)) gt 0>
			<cfinvoke component="#variables.objequipmentGateway#" method="getEquipmentMaintTable" editid="#url.equipmentid#" equipmentmaintid="#url.equipmentMaintId#" returnvariable="request.qEquipmentMaint" />
			<cfif request.qEquipmentMaint.recordcount>
				<cfset  description = request.qEquipmentMaint.description>
				<cfset  milesinterval = request.qEquipmentMaint.milesinterval>
				<cfset variables.odometerUpdateValue=val(EquipmentOdometer)+val(milesinterval)>
			</cfif>	
		</cfif>
	</cfif>	
	<cfif structkeyexists(url,"pageDirection")>
		<cfif url.pageDirection eq 1>
			<cfset variables.pageDirection=1>
		<cfelse>
			<cfset variables.pageDirection=0>
		</cfif>
	</cfif>

	<cfset tempEquipmentMaintTransId = #createUUID()#>
	<h1>Add Maintenance Transaction</h1>
	<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		<div style="float: left; width: 20%;" id="divUploadedFiles">
					&nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;margin-top:-5px;" href="##" onclick="popitupEquip('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempEquipmentMaintTransId#&attachTo=59&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=MaintTrans')">
				<img style="vertical-align:bottom;" src="images/attachment.png">
				Attach Files</a>
		</div>
		<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;"> #ucase(description)#<span style="padding-left:180px;">#Ucase(EquipmentName)#</span></h2></div>
	</div>
	<div style="clear:left;"></div>
	<div class="white-con-area">
		<div class="white-top"></div>
		<div class="white-mid">
			<cfform name="frmPopUpMaintenance" action="index.cfm?event=addDriverEquipment&equipmentid=#url.equipmentid#&#session.URLToken#" method="post" enctype="multipart/form-data">
				<cfset TheKey = "NAMASKARAM">
				<cfset encrypted = encrypt(application.dsn, theKey, 'CFMX_COMPAT', 'Base64')>
				<div class="form-con">
					<fieldset  style="margin-top: 25px;">
						<label>Odometer</label>
						<input type="text" name="Odometer" id="Odometer" value="#variables.odometerUpdateValue#">
						<div class="clear"></div>
						<label>Date</label>
							<cfinput name="Date" type="datefield" id="Date" onblur="checkDateFormatAll(this);" value="" >
						<div class="clear"></div>
						<div class="clear" style="border-top: 1px solid ##E6E6E6;margin-top: 21px;" >&nbsp;</div>	
						<input  type="submit" name="submitMaintenanceTransctionInformation" class="bttn" value="Save" style="width:80px;margin-left:55px;margin-top:5px;" onclick="return checkValidationTransaction();" />
						<input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;margin-top: 5px;" />
						<input type="hidden" name="equipmentIdForMainTrans" value="#url.equipmentid#">
						<input type="hidden" name="equipmentMainT" value="#url.equipmentMaintId#">	
						<input type="hidden" name="pageDirection" value="#variables.pageDirection#">	
						<input type="hidden" name="tempEquipmentMaintTransId" value="#tempEquipmentMaintTransId#">	
					</fieldset>
				</div>
				<div class="form-con">
					<fieldset>
						<label style="text-align:left;">Notes</label>
						<div class="clear"></div>
						<textarea name="Notes" id="Notes" style="width: 311px;margin: 0px 0px 8px;height: 89px;"></textarea>
						<div class="clear"></div>
					</fieldset>
				</div>
				<div class="clear"></div>
			</cfform>
			<div class="clear"></div>
			<div class="white-bot"></div>
		</div>
	</div>
</cfoutput>
