<cfparam name="event" default="agent">
<cfoutput>
<div class="below-navleft">
	<ul>
		<li><a href="index.cfm?event=Reports&#Session.URLToken#" <cfif event is 'Reports'> class="active" </cfif>>Reports</a></li>
		<!---<li><a href="index.cfm?event=quickRateAndMilesCalc&#session.URLToken#" <cfif event is 'quickRateAndMilesCalc'> class="active" </cfif>>Quick Miles and Rate Calculation</a></li>--->
	</ul>
<div class="clear"></div>
</div>
<div class="below-navright">
	<p align="right">Logged in :<cfif isdefined('session.AdminUserName')> #session.AdminUserName# </cfif></p>
</div>
<div style="float:right;margin-right:10px;margin-top:-55px;"><a href="index.cfm?event=feedback&#Session.URLToken#"><img src="images/fdbk.png" width="100px" border="0"></a></div>

</cfoutput>