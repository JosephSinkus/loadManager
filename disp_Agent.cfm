<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">
<cfoutput>
<cfif isdefined("form.searchText") and len(searchText)>	
   	<cfinvoke component="#variables.objAgentGateway#" method="getSearchedAgent" searchText="#form.searchText#" returnvariable="request.qAgent" />
	<cfif request.qAgent.recordcount lte 0>
		<cfset message="No match found">
	</cfif>
<cfelse>
<cfif isdefined("url.agentID") and len(url.agentID) gt 1>	
	<cfinvoke component="#variables.objAgentGateway#" method="deleteAgent" agentid="#url.agentID#" returnvariable="message" />	
	<cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" returnvariable="request.qAgent" />
</cfif>
</cfif>
<h1>All Users</h1>
<cfif isdefined("message") and len(message)>
<div class="msg-area">#message#</div>
</cfif>
    <cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
        <cfset sortorder="asc">
     <cfelse>
        <cfset sortorder="desc">
    </cfif>
    <cfif isDefined("url.sortby")>
        <cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" sortorder="#url.sortorder#" sortby="#url.sortby#"  returnvariable="request.qAgent" />
    </cfif> 
<div class="search-panel"><div class="form-search">
<cfform action="index.cfm?event=agent&#session.URLToken#" method="post" preserveData="yes">
	<fieldset>
		<cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
		<input name="" type="submit" class="s-bttn" value="Search" style="width:56px;" />
		<div class="clear"></div>		
	</fieldset>

</cfform>			
</div>

<cfif ListContains(session.rightsList,'addEditDeleteAgents',',')>
	<cfset newAgentUrl = "index.cfm?event=addagent&#session.URLToken#">
<cfelse>
	<cfset newAgentUrl = "javascript: alert('Sorry!! You don\'t have rights to add new Agents.');">
</cfif>

<div class="addbutton"><a href="#newAgentUrl#">Add New</a></div></div>

<table width="100%" border="0" class="data-table" cellspacing="0" cellpadding="0">
  <thead>
  <tr>
	<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
	<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>
	<th width="120" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=agent&sortorder=#sortorder#&sortby=Name&#session.URLToken#'">User Name</th>
	<th width="169" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=agent&sortorder=#sortorder#&sortby=emailId&#session.URLToken#'">Email</th>
	<th width="120" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=agent&sortorder=#sortorder#&sortby=loginid&#session.URLToken#'">Login</th>
<!---	<th width="139" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=agent&sortorder=#sortorder#&sortby=password&#session.URLToken#'">Password</th>--->
	<th width="109" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=agent&sortorder=#sortorder#&sortby=location&#session.URLToken#'">Office</th>
	<th width="100" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=agent&sortorder=#sortorder#&sortby=roleValue&#session.URLToken#'">Auth Level</th>
	<th width="78" align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=agent&sortorder=#sortorder#&sortby=isActive&#session.URLToken#'">Status</th>
<!--- 	<th width="129" align="center" valign="middle" class="head-bg2">Action</th> --->
	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
  </tr>
  </thead>
  <tbody>
	<cfloop query="request.qAgent">	
		<cfinvoke component="#variables.objAgentGateway#" method="getOffices" officeID ="#request.qAgent.officeID#" returnvariable="request.qoffices"/>
		<cfinvoke component="#variables.objAgentGateway#" method="getAllRole" roleID = "#request.qAgent.RoleId#" returnvariable="request.qRoles"/>
	<tr <cfif request.qAgent.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
		<td height="20" class="sky-bg">&nbsp;</td>
		<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="center">#request.qAgent.currentRow#</td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="left"><a title="#request.qAgent.name# #request.qAgent.emailId# #request.qAgent.loginid# #request.qAgent.password# #request.qoffices.location# #request.qRoles.roleValue#" href="index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#">#request.qAgent.name#</a></td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="left"><a title="#request.qAgent.name# #request.qAgent.emailId# #request.qAgent.loginid# #request.qAgent.password# #request.qoffices.location# #request.qRoles.roleValue#" href="mailto:#request.qAgent.emailId#">#request.qAgent.emailId#</a></td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="left"><a title="#request.qAgent.name# #request.qAgent.emailId# #request.qAgent.loginid# #request.qAgent.password# #request.qoffices.location# #request.qRoles.roleValue#" href="index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#">#request.qAgent.loginid#</a></td>
<!---		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="left"><a title="#request.qAgent.name# #request.qAgent.emailId# #request.qAgent.loginid# #request.qAgent.password# #request.qoffices.location# #request.qRoles.roleValue#" href="index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#">#request.qAgent.password#</a></td>--->
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="left"><cfif request.qoffices.recordcount><a title="#request.qAgent.name# #request.qAgent.emailId# #request.qAgent.loginid# #request.qAgent.password# #request.qoffices.location# #request.qRoles.roleValue#" href="index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#">#request.qoffices.location#</a></cfif></td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="left"><cfif request.qRoles.recordcount><a title="#request.qAgent.name# #request.qAgent.emailId# #request.qAgent.loginid# #request.qAgent.password# #request.qoffices.location# #request.qRoles.roleValue#" href="index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#">#request.qRoles.roleValue#</a></cfif></td>
		<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#'" align="left"><a href="index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#"><cfif request.qAgent.isActive is True>Active<cfelse>Inactive</cfif></a></td>
		<!--- <td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addagent&agentId=#request.qAgent.employeeID#&#session.URLToken#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=agent&agentId=#request.qAgent.employeeID#" onclick="return confirm('Are you sure to delete this record ?')";><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
		<td class="normal-td3">&nbsp;</td>
	 </tr>
	 </cfloop>
	 </tbody>
	 <tfoot>
	 <tr>
		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
		<td colspan="8" align="left" valign="middle" class="footer-bg">
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