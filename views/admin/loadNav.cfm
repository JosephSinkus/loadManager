<cfparam name="event" default="customer">
<cfoutput>
<!---<div class="below-navleft" style="width:85%;">--->

	<table class="below-navleft" style="border-collapse:collapse; border:none; width:72%;" border="0" cellpadding="0" cellspacing="0">
	<cfif Not structKeyExists(session, "IsCustomer")>
	<tr>
			<td>
			<a href="index.cfm?event=load&#session.URLToken#" <cfif event is 'load' or event is 'addload:process'> class="active" </cfif>>All Loads</a>
			</td>
			<td>
				<a href="index.cfm?event=addload&#session.URLToken#" <cfif event is 'addload'> class="active" </cfif>>Add&nbsp;Load</a>
			</td>        
			<td>
			<a href="index.cfm?event=quickRateAndMilesCalc&#session.URLToken#" <cfif event is 'quickRateAndMilesCalc'> class="active" </cfif>>Quick Miles and Rate Calculation</a>
			</td>
			
			<td>
			<a href="index.cfm?event=advancedsearch&#session.URLToken#" <cfif event is 'advancedsearch'> class="active"</cfif>>Advanced&nbsp;Search</a>
			</td>
			
			<td>
			<a href="index.cfm?event=unit&#session.URLToken#" <cfif event is 'unit' or event is 'addunit:process' or event is 'addunit'> class="active" </cfif>>Commodity Type</a>
			</td>
			
			<td>
			<a href="index.cfm?event=class&#session.URLToken#" <cfif event is 'class' or event is 'addclass:process' or event is 'addclass'> class="active" </cfif>> Commodity Class</a>
			</td>
			
			<!---td>
			<a href="index.cfm?event=exportData&#session.URLToken#" <cfif event is 'exportData'> class="active" </cfif>> Export Data To QuicBooks</a>
			</td--->
	</tr>
	</cfif>
	</table>

<!---</div>--->
<div class="below-navright" style="width:10%;">
	<p align="right">Logged in : <cfif isdefined('session.AdminUserName')> #session.AdminUserName# </cfif></p>
</div>
<div style="float:right;margin-right:10px;margin-top:-55px;"><a href="index.cfm?event=feedback&#Session.URLToken#"><img src="images/fdbk.png" width="100px" border="0"></a></div>
		
<div class="clear"></div> 
</cfoutput>