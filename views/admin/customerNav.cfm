<cfparam name="event" default="customer">
<cfoutput>
<div class="below-navleft">
	<ul>
		<li><a href="index.cfm?event=customer&#session.URLToken#" <cfif (event is 'customer' or event is 'addcustomer:process') and not structKeyExists(url,'payer')> class="active" </cfif>>Payers/Shippers/Consignees</a></li>
		<li><a href="index.cfm?event=addcustomer&#session.URLToken#" <cfif event is 'addcustomer'> class="active" </cfif>>Add&nbsp;Customer</a></li>
		<li><a href="index.cfm?event=customer&#session.URLToken#&payer=1" <cfif event is 'customer' and structKeyExists(url,'payer') and url.payer is '1'> class="active" </cfif>>Payers</a></li>
		<li><a href="index.cfm?event=customer&#session.URLToken#&payer=0" <cfif event is 'customer' and structKeyExists(url,'payer') and url.payer is '0'> class="active" </cfif>>Shippers/Consignees</a></li>
		<!---<li><a href="index.cfm?event=consignee&#session.URLToken#" <cfif event is 'consignee' or event is 'addconsignee:process'> class="active" </cfif>>Consignee</a></li>
		<li><a href="index.cfm?event=addconsignee&#session.URLToken#" <cfif event is 'addconsignee'> class="active" </cfif>>Add&nbsp;Consignee</a></li> --->
	</ul>
<div class="clear"></div>
</div>
<div class="below-navright">
	<p align="right">Logged in : <cfif isdefined('session.AdminUserName')> #session.AdminUserName# </cfif></p>
</div>
<div style="float:right;margin-right:10px;margin-top:-55px;"><a href="index.cfm?event=feedback&#Session.URLToken#"><img src="images/fdbk.png" width="100px" border="0"></a></div>

</cfoutput>