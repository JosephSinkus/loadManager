<cfparam name="event" default="agent">
<cfoutput>
<div class="below-navleft">
	<ul>
		<li><a href="index.cfm?event=systemsetup&#Session.URLToken#" <cfif event is 'systemsetup'> class="active" </cfif>>Configuration Options</a></li>
		<li><a href="index.cfm?event=companyinfo&#Session.URLToken#" <cfif event is 'companyinfo'> class="active" </cfif>>Company Info</a></li>
		<!---<li><a href="index.cfm?event=quickRateAndMilesCalc&#session.URLToken#" <cfif event is 'quickRateAndMilesCalc'> class="active" </cfif>>Quick Miles and Rate Calculation</a></li>--->
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
