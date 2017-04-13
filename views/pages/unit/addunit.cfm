<cfoutput>
	<cfsilent>
<!--- default value------->
		<cfparam name="UnitCode" default="">
		<cfparam name="UnitName" default="">
		<cfparam name="Status" default="">
		<cfparam name="IsFee" default="">
		<cfparam name="CustomerRate" default="0.00">
		<cfparam name="CarrierRate" default="0.00">
		<cfparam name="url.editid" default="0">
		<cfparam name="url.unitid" default="0">
		<cfparam name="variables.paymentAdvanceCheck" default="0">
		
		<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qSystemSetupOptions" /> 
		<cfif isdefined("url.unitid") and len(trim(url.unitid)) gt 1>
			<cfinvoke component="#variables.objunitGateway#" method="getAllUnits" UnitID="#url.unitid#" returnvariable="request.qUnits" />

			<cfif request.qUnits.recordcount eq 1>
				<cfset UnitCode=#request.qUnits.UnitCode#>
				<cfset UnitName=#request.qUnits.UnitName#>
				<cfset Status=#request.qUnits.IsActive#>
				<cfset IsFee =#request.qUnits.IsFee#>
				<cfset editid=#request.qUnits.UnitID#>
				<cfset CustomerRate=#DollarFormat(request.qUnits.CustomerRate)#>
				<cfset CarrierRate=#DollarFormat(request.qUnits.CarrierRate)#>
				<cfset variables.paymentAdvanceCheck =request.qUnits.PAYMENTADVANCE>
			</cfif>
		</cfif>
	</cfsilent>
	<cfif isdefined("url.unitid") and len(trim(url.unitid)) gt 1>
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
			<div class="search-panel"><div class="delbutton"><a href="index.cfm?event=unit&unitid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');">  Delete</a></div></div>	
			<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Edit Unit <span style="padding-left:180px;">#Ucase(UnitName)#</span></h2></div>
		</div>
		<div style="clear:left;"></div>
	<cfelse>
		<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
			<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Add New Unit</h2></div>
		</div>
		<div style="clear:left;"></div>
	</cfif>
	<div class="white-con-area">
		<div class="white-top"></div>
		<div class="white-mid">
			<cfform name="frmUnit" action="index.cfm?event=addunit:process&editid=#editid#&#session.URLToken#" method="post">
				<cfinput type="hidden" name="editid" value="#editid#">
				<div class="form-con">
					<fieldset>  
						<label><strong>Type*</strong></label>
						<cfinput type="text" name="UnitName" value="#UnitName#" size="25" required="yes" message="Please  enter the name">
						<div class="clear"></div>
						<label><strong>Description*</strong></label>
						<cfinput type="text" name="UnitCode" value="#UnitCode#" size="25" required="yes" message="Please  enter the unit code">  
						<div class="clear"></div>
						<label><strong>Active*</strong></label>
						<select name="Status" class="activeTextField">
							<option value="True"  <cfif Status eq 'true'>selected="selected" </cfif>>True</option>
							<option value="False" <cfif Status eq 'false'>selected="selected" </cfif>>False</option>
						</select>
						<span class="clear"></span>
						<label class="feetext"><strong>Fee*</strong></label>
						<select name="IsFee" class="activeTextField">
							<option value="true" <cfif IsFee eq 'true'>selected="selected" </cfif>>True</option>
							<option value="false" <cfif IsFee eq 'false'>selected="selected" </cfif>>False</option>
						</select>
						<label>Payment Advance</label>
						<cfif val(variables.paymentAdvanceCheck)>
							<cfinput type="checkbox" name="paymentAdvance" value="1" style="margin-left: -85px;" checked/>
						<cfelse>
							<cfinput type="checkbox" name="paymentAdvance" value="1" style="margin-left: -85px;" />
						</cfif>
					</fieldset>
				</div>
				<div class="form-con">
					<fieldset>
						<label class="ratefield"><strong>Customer Rate*</strong></label>
						<cfinput type="text" name="CustomerRate" value="#CustomerRate#" size="25" required="yes" message="Please  enter the Customer Rate" class="activeTextField">
						<div class="clear"></div>
						<label class="ratefield"><strong><cfif request.qSystemSetupOptions.freightBroker>Carrier<cfelse>Driver</cfif> Rate*</strong></label>
						<cfinput type="text" name="CarrierRate" value="#CarrierRate#" size="25" required="yes" message="Please  enter the Carrier Rate" class="activeTextField">
						<div class="clear"></div>
						<div style="padding-left:150px;"><input  type="submit" name="submit" onclick="return validateUnit(frmUnit);" class="bttn" value="Save Unit" style="width:112px;" /><input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" /></div>
						<div class="clear"></div>  		
					</fieldset>
				</div>
			</cfform>
			<div class="clear"></div>
			<cfif isDefined("url.unitid") and len(url.unitid) gt 1>
				<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qUnits")>&nbsp;&nbsp;&nbsp; #request.qUnits.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qUnits.LastModifiedBy#</cfif></p>
			</cfif>
		</div>
		<div class="white-bot"></div>
	</div>
</cfoutput>


