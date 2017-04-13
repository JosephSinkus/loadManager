<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">
<cfparam name="variables.maintenanceWithEquipment"  default="0">
<cfsilent>	
	<cfif structkeyexists(url,"EquipmentMaint") AND url.EquipmentMaint EQ 1>
		<cfif structkeyexists(url,"maintenanceWithEquipment") and url.maintenanceWithEquipment EQ 1>
			<cfset variables.maintenanceWithEquipment = 1>
		</cfif>
		<cfset variables.EquipmentMaint = 1>
	<cfelse>
		<cfset variables.EquipmentMaint = 0>
	</cfif>
	<cfif structkeyexists(form,"searchText") and len(searchText)>	
		<cfinvoke component="#variables.objequipmentGateway#" method="getSearchedEquipment" searchText="#form.searchText#" EquipmentMaint="#variables.EquipmentMaint#" maintenanceWithEquipment="#variables.maintenanceWithEquipment#" returnvariable="request.qEquipments" />	
	<cfelse>
		<cfif structkeyexists(url,"equipmentid") and len(url.equipmentid) gt 1>	
			<cfinvoke component="#variables.objequipmentGateway#" method="deleteEquipments" EquipmentID="#url.equipmentid#" returnvariable="message" />	
			<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
		</cfif>
	</cfif>
	<cfif request.qSystemSetupOptions1.freightBroker>
		<cfset variables.addEquipmentType = "addEquipment">
	<cfelse>
		<cfset variables.addEquipmentType = "addDriverEquipment">
	</cfif>
</cfsilent>
<cfoutput>
	<cfif structkeyexists(url,"EquipmentMaint") AND url.EquipmentMaint EQ 1>
		<cfif structkeyexists(url,"maintenanceWithEquipment") and url.maintenanceWithEquipment EQ 1>
			<h1>Equipments With Maintenance</h1>
		<cfelse>
			<h1>Maintenance Required Equipments</h1>
		</cfif>
	<cfelse>
		<h1>All Equipment</h1>
	</cfif>
	<cfif isdefined("message") and len(message)>
	<div class="msg-area" style="margin-left:10px;">#message#</div>
	</cfif>
	<cfif structkeyexists(url,"sortorder") and url.sortorder eq 'desc'>
		<cfset sortorder="asc">
	 <cfelse>
		<cfset sortorder="desc">
	</cfif>
	<cfif structkeyexists(url,"sortby")>
		<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" EquipmentMaint="#variables.EquipmentMaint#" maintenanceWithEquipment="#variables.maintenanceWithEquipment#" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qEquipments" />
	</cfif> 
	<div class="search-panel">
		<div class="form-search">
			<cfform action="index.cfm?event=equipment&#session.URLToken#&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#" method="post" preserveData="yes">
				<fieldset>
					<cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
					<input name="" type="submit" class="s-bttn" value="Search" style="width:56px;" />
					<div class="clear"></div>
				</fieldset>
			</cfform>
		</div>
		<cfif not (structkeyexists(url,"EquipmentMaint") AND url.EquipmentMaint EQ 1)>
			<div class="addbutton"><a href="index.cfm?event=#variables.addEquipmentType#&#session.URLToken#">Add New</a></div>
		</cfif>
	</div>  
    <table <cfif structkeyexists(url,"EquipmentMaint") AND url.EquipmentMaint EQ 1> width="100%"<cfelse> width="86%"</cfif> border="0" cellspacing="0" cellpadding="0" class="data-table" id="test">
		<thead>
			<tr>
				<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
				<th align="center" valign="middle" class="head-bg">&nbsp;</th>
				<th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=EquipmentCode&#session.URLToken#'">Equipment Code</th>
				<th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=EquipmentName&#session.URLToken#'">Name</th>
				<cfif structkeyexists(url,"EquipmentMaint") AND url.EquipmentMaint EQ 1>
				<th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=Description&#session.URLToken#'">Description</th>
				<th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=nextdate&#session.URLToken#'">Next Date</th>
				<th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=nextOdometer&#session.URLToken#'">Next Odometer</th>
				</cfif>	
		<!---     	<th align="center" width="10%" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&sortorder=#sortorder#&sortby=EquipmentName&#session.URLToken#'">Post Everywhere</th>	 --->
				<cfif request.qSystemSetupOptions1.freightBroker>
					<th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=Length&#session.URLToken#'">Length</th>	
				<cfelse>
					<th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=UnitNumber&#session.URLToken#'">Unit</th>	
				</cfif>
			<!---     <th align="center" valign="middle" class="head-bg"  onclick="document.location.href='index.cfm?event=equipment&sortorder=#sortorder#&sortby=EquipmentW&#session.URLToken#'">Width</th>		 --->		
				<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=IsActive&#session.URLToken#'">Status</th>
				<cfif request.qSystemSetupOptions1.freightBroker>
					<th align="center" valign="middle" class="head-bg" style="width:60px" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=ITSCode&#session.URLToken#'">ITS Code</th>
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&sortorder=#sortorder#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortby=TranscoreCode&#session.URLToken#'"  style="white-space:nowrap; padding:0px 5px; width:60px">DAT Load Board Code</th>
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&sortorder=#sortorder#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortby=PosteverywhereCode&#session.URLToken#'" style="white-space:nowrap; padding:0px 5px;">Posteverywhere Code</th>
					<th align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&sortorder=#sortorder#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortby=LoadBoardCode&#session.URLToken#'" style="white-space:nowrap; padding:0px 5px;">123LoadBoard Code</th>
				<cfelse>
					<th align="center" valign="middle" class="head-bg" style="width:60px" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=LicensePlate&#session.URLToken#'">Lic.Plate</th>
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=TagExpirationDate&#session.URLToken#'"  style="white-space:nowrap; padding:0px 5px; width:60px">Tag Expiration Date</th>
					<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=AnnualDueDate&#session.URLToken#'" style="white-space:nowrap; padding:0px 5px;">Annual Due Date</th>
					<th align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=equipment&EquipmentMaint=#variables.EquipmentMaint#&maintenanceWithEquipment=#variables.maintenanceWithEquipment#&sortorder=#sortorder#&sortby=Odometer&#session.URLToken#'" style="white-space:nowrap; padding:0px 5px;">Odometer</th>
				</cfif>
			  <!--- <th align="center" valign="middle" class="head-bg2">Action</th> --->
				<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="request.qEquipments">	
				<tr <cfif request.qEquipments.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
					<td height="20" class="sky-bg">&nbsp;</td>
					<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="center">#request.qEquipments.currentRow#</td>
					<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'"  align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.EquipmentCode#</a></td>
					<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.EquipmentName#</a></td>
					<!--- <td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">
					<cfif request.qEquipments.PEPCODE eq true><input type="checkbox" name="chk" checked > <cfelse><input type="checkbox" name="chk"  ></cfif>
					</a></td> --->
					<cfif structkeyexists(url,"EquipmentMaint") AND url.EquipmentMaint EQ 1>
						<td width="80px" class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.Description#</a></td>
						<td width="80px" align="center" class="normal-td" valign="center" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#DateFormat(request.qEquipments.NextDate, "mm-dd-yyyy")#</a></td>
						<td width="80px" align="center" class="normal-td" valign="center" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.NextOdometer#</a></td>
					</cfif>
					<cfif request.qSystemSetupOptions1.freightBroker>
						<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.length#</a></td>
					<cfelse>
						<td width="60px" align="center" class="normal-td" valign="center" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.UnitNumber#</a></td>
					</cfif>
					
					<td class="normal-td"  align="center" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'"  align="center"><a href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#"><cfif request.qEquipments.IsActive eq 1>Active<cfelse>Inactive</cfif></a></td>
					<cfif request.qSystemSetupOptions1.freightBroker>
						<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.ITSCode#</a></td>
						<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.TranscoreCode#</a></td>
						<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.PosteverywhereCode#</a></td>		
						<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.LoadBoardCode#</a></td>		
					<cfelse>
						<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.LicensePlate#</a></td>
						<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#DateFormat(request.qEquipments.TagExpirationDate, "mmm-dd-yyyy")#</a></td>
						<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#DateFormat(request.qEquipments.AnnualDueDate, "mmm-dd-yyyy")#</a></td>		
						<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=#variables.addEquipmentType#&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.Odometer#</a></td>		
					</cfif>
					<td class="normal-td3">&nbsp;</td> 
				</tr>
				<!--- <td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=equipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');"><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
			</cfloop>
    	</tbody>
		<tfoot>
			<tr>
			<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
			<td <cfif structkeyexists(url,"EquipmentMaint") AND url.EquipmentMaint EQ 1> colspan="10" <cfelse> colspan="8" </cfif> align="left" valign="middle" class="footer-bg">
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
</cfoutput>
    