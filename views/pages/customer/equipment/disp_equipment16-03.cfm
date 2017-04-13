<cfparam name="message" default="">

<cfsilent>	
<cfif isdefined("form.searchText") and len(searchText)>	
	<cfinvoke component="#variables.objequipmentGateway#" method="getSearchedEquipment" searchText="#form.searchText#" returnvariable="request.qEquipments" />
<cfelse>
	<cfif isdefined("url.equipmentid") and len(url.equipmentid) gt 1>	
		<cfinvoke component="#variables.objequipmentGateway#" method="deleteEquipments" EquipmentID="#url.equipmentid#" returnvariable="message" />	
		<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
	</cfif>
</cfif>
</cfsilent>
<cfoutput>
<h1>All Equipment</h1>
<cfif isdefined("message") and len(message)>
<div class="msg-area">#message#</div>
</cfif>
<div class="search-panel">
<div class="form-search">
<cfform action="index.cfm?event=equipment&#session.URLToken#" method="post" preserveData="yes">
	<fieldset>
	<cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
	<input name="" type="submit" class="s-bttn" value="Search" style="width:56px;" />
	<div class="clear"></div>
	</fieldset>
</cfform>			
</div>
<div class="addbutton"><a href="index.cfm?event=addequipment&#session.URLToken#">Add New</a></div></div>  
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="data-table">
      <thead>
      <tr>
    	<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
    	<th align="center" valign="middle" class="head-bg">&nbsp;</th>
    	<th align="center" valign="middle" class="head-bg">Equipment Code</th>
    	<th align="center" valign="middle" class="head-bg">Name</th>
    	<th align="center" valign="middle" class="head-bg2">Status</th>
    	<!--- <th align="center" valign="middle" class="head-bg2">Action</th> --->
    	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
      </tr>
      </thead>
      <tbody>
    	<cfloop query="request.qEquipments">	
    	<tr <cfif request.qEquipments.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
    		<td height="20" class="sky-bg">&nbsp;</td>
    		<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="center">#request.qEquipments.currentRow#</td>
    		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'"  align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.EquipmentCode#</a></td>
    		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'" align="left"><a title="#request.qEquipments.EquipmentCode# #request.qEquipments.EquipmentName#" href="index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#">#request.qEquipments.EquipmentName#</a></td>
    		<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#'"  align="center"><a href="index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#"><cfif request.qEquipments.IsActive eq 1>Active<cfelse>Inactive</cfif></a></td>
    		<!--- <td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addequipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=equipment&equipmentid=#request.qEquipments.EquipmentID#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');"><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
    		<td class="normal-td3">&nbsp;</td>
    	 </tr>
    	 </cfloop>
    	 </tbody>
    	 <tfoot>
    	 <tr>
    		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
    		<td colspan="4" align="left" valign="middle" class="footer-bg">
    			<div class="up-down">
    				<div class="arrow-top"><a href="##"><img src="images/arrow-top.gif" alt="" /></a></div>
    				<div class="arrow-bot"><a href="##"><img src="images/arrow-bot.gif" alt="" /></a></div>
    			</div>
    			<div class="gen-left"><a href="##">View More</a></div>
    			<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
    			<div class="clear"></div>
    		</td>
    		<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
    	 </tr>	
    	 </tfoot>	  
    </table>
    </cfoutput>
    