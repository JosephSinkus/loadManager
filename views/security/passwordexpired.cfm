<cfset intExpiryDaysLeft = Datediff("d", DateFormat(Now(), "dd mmm yyyy"), DateFormat(session.passport.currentSiteUser.getPasswordExpiry(), "dd mmm yyyy"))>

<cfoutput>
	<link rel="stylesheet" type="text/css" href="stylesheets/loginpage.css">
	<script language="JavaScript" type="text/javascript">		
	
		<cfif intExpiryDaysLeft GT 0>
			function ShowChangePwd() {
				document.getElementById('TR1').className = 'dspHiddenOn';
				document.getElementById('TR2').className = 'dspHiddenOff';
				document.getElementById('TR3').className = 'dspHiddenOff';
				document.getElementById('TR4').className = 'dspHiddenOff';
				document.getElementById('TR5').className = 'dspHiddenOff';
				document.getElementById('TR6').className = 'dspHiddenOff';
			}
		</cfif>
			function Relocate() {
				document.location.href = '#URLSessionFormat('index.cfm?event=mainpage')#';
			}
			function ChangePassword()
			{
				document.getElementById('frmLogin').submit();
			}

	</script>

<form action="index.cfm?event=changePassword:Form&#Session.URLToken#" method="post" name="frmLogin" id="frmLogin">
<table width="100%" border="0" cellspacing="0" cellpadding="0" border="1">
	<tr>
		<td width="100%" height="97%" align="center" valign="middle">
			<table border="0" cellspacing="0" cellpadding="5" class="lightitemborder">
				<!--- <tr>
					<td class="lightitemheading" colspan="3">Please enter your login details</td>
				</tr> --->
				<tr>
					<td class="tablelinespace"></td>
				</tr>
				<cfif IsDefined('URL.intMessageID')>
					<tr>
						<td class="failurealert" colspan="3" align="center">
							<cfswitch expression="#URL.intMessageID#">
								<cfcase value="2">
									The New Password has been used in the past.<br>
									Please choose another.
								</cfcase>
							</cfswitch>
						</td>
					</tr>
				</cfif>
				<tr>
					<td class="alert" colspan="3" align="center">
						<cfif intExpiryDaysLeft GT 0>
							Your password will expire in #intExpiryDaysLeft# day<cfif intExpiryDaysLeft NEQ 1>s</cfif>.<br>
							Would you like to change it now?
						<cfelse>
							Your password has expired.<br>
						</cfif>
					</td>
				</tr>
				<cfif intExpiryDaysLeft GT 0>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr id="TR1">
						<td colspan="4" align="center">
							<input type="button" value="Yes" class="button" title="Yes, I will change my password now." onclick="ChangePassword()">
							<input type="button" value="No" class="button" title="No, I will change my password later." onclick="Relocate()">
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
				<cfelse>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr id="TR1">
						<td colspan="4" align="center">
							<input type="button" value="Please click here to change it now" class="button" title="Please click here to change it now" onclick="ChangePassword()">
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
</form>
</cfoutput>