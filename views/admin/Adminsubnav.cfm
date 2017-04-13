<cfparam name="event" default="agent">
<cfoutput>
<div class="below-navleft">
	<ul>
		<li><a href="index.cfm?event=agent&sortorder=asc&sortby=Name&#session.URLToken#" <cfif event is 'agent' or event is 'addagent:process'> class="active" </cfif>>Users</a></li>
		<li><a href="index.cfm?event=addagent&#session.URLToken#" <cfif event is 'addagent'> class="active" </cfif>>Add&nbsp;User</a></li>
		<li><a href="index.cfm?event=office&#session.URLToken#" <cfif event is 'office' or event is 'addoffice:process'> class="active" </cfif>>Offices</a></li>
		<li><a href="index.cfm?event=addoffice&#session.URLToken#" <cfif event is 'addoffice'> class="active" </cfif>>Add&nbsp;Office</a></li>
	</ul>
<div class="clear"></div>
</div>
<div class="below-navright">
	<p align="right">Logged in :<cfif isdefined('session.AdminUserName')> #session.AdminUserName# </cfif></p>
</div>
<div style="float:right;margin-right:10px;margin-top:-55px;"><a href="index.cfm?event=feedback&#Session.URLToken#"><img src="images/fdbk.png" width="100px" border="0"></a></div>

</cfoutput>
<!--- <div class="sublinks">
	<table>
		<tr>
			<td>
				<form name="frmSiteUserForm" action="index.cfm?#Session.URLToken#" method="get" onsubmit="return showSearchForm();">
					<input type="hidden" name="event" value="searchSiteUser" />
					<input type="hidden" name="JSESSIONID" value="#cookie.jsessionID#" />
					<input type="submit" class="subnavButton" value="Search Site Users" /> |
				</form>
			</td>
			<td>
				<form name="frmSiteUserForm" action="index.cfm?#Session.URLToken#" method="get" onsubmit="return showAddForm();">
					<input type="hidden" name="event" value="addSiteUser" />
					<input type="hidden" name="JSESSIONID" value="#cookie.jsessionID#" />
					<input type="submit" class="subnavButton" value="Add Site User" /> |
				</form>
			</td>
		</tr>
	</table>
</div> --->
