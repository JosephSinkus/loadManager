<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">
<cfoutput>
	<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		<div style="float: left; width: 20%;" id="divUploadedFiles">
		</div>
		<div style="float: left; width: 46%;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">All Maintenance Setup</h2></div>
	</div>
	<div style="clear:left;"></div>
	<cfif structkeyexists(url,"equimentMaintSetUpId") and len(url.equimentMaintSetUpId)>
		<cfinvoke component="#variables.objequipmentGateway#" method="deleteEquipmentMainsetUp" EquipmentMainsetUp="#url.equimentMaintSetUpId#" returnvariable="message" />
	</cfif>
	<cfif structkeyexists(url,"EquipmentMaintSetupId") and len(url.EquipmentMaintSetupId) gt 1>	
		<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformation" returnvariable="request.qGetMaintenanceInformation" />
	</cfif>
	<cfif isdefined("message") and len(message)>
	<div class="msg-area" style="margin-left: 10px;margin-top: 10px;">#message#</div>
	</cfif>
	<cfif structkeyexists(url,"sortorder") and url.sortorder eq 'desc'>
		<cfset sortorder="asc">
	 <cfelse>
		<cfset sortorder="desc">
	</cfif>
	<cfif structkeyexists(url,"sortby")>
		<cfinvoke component="#variables.objequipmentGateway#" method="getMaintenanceInformation" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qGetMaintenanceInformation" />
	</cfif> 
	<div class="search-panel">
		<div class="form-search">
		</div>
		<div class="addbutton"><a href="index.cfm?event=addMaintenanceSetUp&#session.URLToken#">Add New</a></div>
	</div>
	<cfif request.qGetMaintenanceInformation.recordcount>
		<table width="86%" border="0" cellspacing="0" cellpadding="0" class="data-table" id="test">
			<thead>
				<tr>
					<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
					<th align="center" valign="middle" class="head-bg">&nbsp;</th>
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=maintenanceSetUp&sortorder=#sortorder#&sortby=Description&#session.URLToken#'">Description</th>
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=maintenanceSetUp&sortorder=#sortorder#&sortby=MilesInterval&#session.URLToken#'">Miles Interval</th>
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=maintenanceSetUp&sortorder=#sortorder#&sortby=DateInterval&#session.URLToken#'">Date Interval</th>		
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=maintenanceSetUp&sortorder=#sortorder#&sortby=Notes&#session.URLToken#'">Notes</th>
					<th width="110" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=maintenanceSetUp&sortorder=#sortorder#&sortby=ModifiedDate&#session.URLToken#'">Date Created</th>
					<th width="110" align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=maintenanceSetUp&sortorder=#sortorder#&sortby=createdDate&#session.URLToken#'">Date Modified</th>
					<th align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="request.qGetMaintenanceInformation">	
					<tr <cfif request.qGetMaintenanceInformation.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
						<td height="20" class="sky-bg">&nbsp;</td>
						<td class="sky-bg2" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#'" ><a title="#request.qGetMaintenanceInformation.Description#" href="index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#">#request.qGetMaintenanceInformation.currentRow#</a></td>
						<td class="normal-td" valign="middle" align="left" onclick="document.location.href='index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#'"><a title="#request.qGetMaintenanceInformation.Description#" href="index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#">#request.qGetMaintenanceInformation.Description#</a></td>
						<td class="normal-td" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#'"><a title="#request.qGetMaintenanceInformation.Description#" href="index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#">#request.qGetMaintenanceInformation.MilesInterval#</a></td>
						<td class="normal-td" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#'"><a title="#request.qGetMaintenanceInformation.Description#" href="index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#"><cfif len(trim(request.qGetMaintenanceInformation.DateInterval))><cfif request.qGetMaintenanceInformation.DateInterval eq 1>#request.qGetMaintenanceInformation.DateInterval#-Month<cfelseif request.qGetMaintenanceInformation.DateInterval eq 0><cfelse>#request.qGetMaintenanceInformation.DateInterval#-Months</cfif><cfelse></cfif></a></td>
						<td class="normal-td" valign="middle" align="left" onclick="document.location.href='index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#'"><a title="#request.qGetMaintenanceInformation.Description#" href="index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#"><cfif len(request.qGetMaintenanceInformation.Notes) gt 50>#left(request.qGetMaintenanceInformation.Notes,50)#...<cfelse>#request.qGetMaintenanceInformation.Notes#</cfif></a></td>
						<td class="normal-td" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#'"><a title="#request.qGetMaintenanceInformation.Description#" href="index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#"> #DateFormat(request.qGetMaintenanceInformation.createdDate, "mm-dd-yyyy")#</a></td>
						<td class="normal-td2" valign="middle" align="center" onclick="document.location.href='index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#'"><a title="#request.qGetMaintenanceInformation.Description#" href="index.cfm?event=addMaintenanceSetUp&EquipmentMaintSetupId=#request.qGetMaintenanceInformation.id#&#session.URLToken#"> #DateFormat(request.qGetMaintenanceInformation.modifiedDate, "mm-dd-yyyy")#</a></td>
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
</cfoutput>	