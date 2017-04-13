<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">
<cfsilent>
	<cfif isdefined("form.searchText") and len(searchText)>	
		<cfinvoke component="#variables.objunitGateway#" method="getSearchedUnit" searchText="#form.searchText#" returnvariable="request.qUnits" />
	<cfelse>	
		<cfif isdefined("url.unitid") and len(url.unitid) gt 1>	
			<cfinvoke component="#variables.objunitGateway#" method="deleteUnits" UnitID="#url.unitid#" returnvariable="message" />	
			<cfinvoke component="#variables.objunitGateway#" method="getAllUnits" returnvariable="request.qUnits" />
		</cfif>
	</cfif>
</cfsilent>
<cfoutput>
	<h1>All Units</h1>
	<cfif isdefined("message") and len(message)>
		<div class="msg-area">#message#</div>
	</cfif>
	<cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
        <cfset sortorder="asc">
	<cfelse>
        <cfset sortorder="desc">
	</cfif>
	<cfif isDefined("url.sortby")>
        <cfinvoke component="#variables.objunitGateway#" method="getAllUnits" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qUnits" />
	</cfif> 
	<div class="search-panel">
		<div class="form-search">
			<cfform action="index.cfm?event=unit&#session.URLToken#" method="post" preserveData="yes">
				<fieldset>
					<cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
					<input name="" type="submit" class="s-bttn" value="Search" style="width:56px;" />
					<div class="clear"></div>
				</fieldset>
			</cfform>			
		</div>
		<div class="addbutton"><a href="index.cfm?event=addunit&#session.URLToken#">Add New</a></div>
	</div>  
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="data-table">
		<thead>
			<tr>
				<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
				<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>
				<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=unit&sortorder=#sortorder#&sortby=UnitName&#session.URLToken#'">Type</th>
				<th align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=unit&sortorder=#sortorder#&sortby=UnitCode&#session.URLToken#'">Description</th>
				<th align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=unit&sortorder=#sortorder#&sortby=IsActive&#session.URLToken#'">Status</th>
				<!--- <th align="center" valign="middle" class="head-bg2">Action</th> --->
				<th width="5" align="right" valign="top" ><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="request.qUnits">	
				<tr <cfif request.qUnits.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
					<td height="20" class="sky-bg">&nbsp;</td>
					<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#'" align="center">#request.qUnits.currentRow#</td>
					<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#'"  align="left"><a title="#request.qUnits.UnitCode# #request.qUnits.UnitName#" href="index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#">#request.qUnits.UnitName#</a></td>
					<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#'" align="left"><a title="#request.qUnits.UnitCode# #request.qUnits.UnitName#" href="index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#">#request.qUnits.UnitCode#</a></td>
					<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#'" align="center"><a href="index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#"><cfif request.qUnits.IsActive eq 1>Active<cfelse>Inactive</cfif></a></td>
					<!--- <td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addunit&unitid=#request.qUnits.UnitID#&#session.URLToken#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=unit&unitid=#request.qUnits.UnitID#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');"><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
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
    