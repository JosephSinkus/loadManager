<cfparam name="Description" default="">
<cfparam name="MilesInterval" default="">
<cfparam name="DateInterval" default="">
<cfparam name="Notes" default="">
	<cfsilent>
		<cfif isdefined('form.submitMaintenanceInformation')>
			<cfinvoke component="#variables.objequipmentGateway#" method="setMaintenanceInformation" Description="#form.Description#" MilesInterval="#form.MilesInterval#" DateInterval="#DateInterval#" Notes="#form.Notes#" returnvariable="maintenanceInformation" />
		</cfif>
		<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformation" returnvariable="request.qGetMaintenanceInformation" />
		<cfset  Description = request.qGetMaintenanceInformation.Description>
		<cfset  MilesInterval = request.qGetMaintenanceInformation.MilesInterval>
		<cfset  DateInterval = request.qGetMaintenanceInformation.DateInterval>
		<cfset  Notes = request.qGetMaintenanceInformation.Notes>
	</cfsilent>
<cfoutput>
	<div class="white-con-area" style="height: 40px;background-color: ##82bbef;">
		<div style="float: left; width: 100%; min-height: 40px;">
			<h1 style="color:white;font-weight:bold;margin-left:279px;">Equipment Maintenance Setup</h1>
		</div>
	</div>
	<div style="clear:left"></div>
	<div class="white-con-area">
		<div class="white-top"></div>
		<div class="white-mid">
			<cfform action="" name="frmMaintenanceInformation" method="post">
				<div class="form-con">
					<fieldset>
						<label>Description</label>
						<textarea class="medium-textbox applynotesPl" name="Description" tabindex=5 cols="" rows="" style="margin-bottom: 10px;">#Description#</textarea>
						<div class="clear"></div>
						
						<label>Miles Interval</label>
						<input type="text" name="MilesInterval" id="MilesInterval" value="#MilesInterval#">
						<div class="clear"></div>
						
						<label>Date Interval</label>
						<select name="DateInterval" id="DateInterval" tabindex="6" style="width:191px;">
							<option value="">Select</option>
							<cfloop index = "LoopCount" from = "0" to = "36"> 
								<option value="#LoopCount#"<cfif LoopCount is '#DateInterval#'>selected="selected"</cfif>>#LoopCount#-Month</option>
							</cfloop>
					   </select>
						<div class="clear"></div>
						
						<div class="clear"></div>
						<label>Notes</label>
						<textarea class="medium-textbox applynotesPl" name="Notes" tabindex=5 cols="" rows="">#Notes#</textarea>
						<div class="clear"></div>
						
						
						<div class="clear"></div>
						<!---label>CreatedDate</label>
						<input type="datefield" name="CreatedDate" id="CreatedDate" value="" onblur="checkDateFormat(this);">
						<div class="clear"></div--->
						
						<div class="clear" style="border-top: 1px solid ##E6E6E6;margin-top: 21px;" >&nbsp;</div>	
						<input type="hidden" name="companyID" id="companyID" value="">
						<input  type="submit" name="submitMaintenanceInformation" class="bttn" value="Save" style="width:80px;margin-left:136px;margin-top:5px;" onclick="return validationFields();" />
						
						<div id="message" class="msg-area" style="width: 181px;margin-left: 96px;margin-top: 36px; display:<cfif isDefined('maintenanceInformation')>block;<cfelse>none;</cfif>">
							<cfif isDefined('maintenanceInformation') AND maintenanceInformation GT 0>
								Information saved successfully
							<cfelseif isDefined('maintenanceInformation')>
								unknown <b>Error</b> occured while saving
							</cfif>
						</div>
						
					</fieldset>
				</div>
				<div class="clear"></div>
			</cfform>
		</div>
		<div class="white-bot"></div>
	</div>
</cfoutput>