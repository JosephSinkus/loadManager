<cfset intExpiryDaysLeft = Datediff("d", DateFormat(Now(), "dd mmm yyyy"), DateFormat(session.passport.currentSiteUser.getPasswordExpiry(), "dd mmm yyyy"))>

<cfoutput>
	<link rel="stylesheet" type="text/css" href="stylesheets/loginpage.css">
	<script language="JavaScript1.2" type="text/javascript">
		function Validation(objForm) {
			if(objForm.txtUserName.value == "") {
				alert("Please insert your user name");
				objForm.txtUserName.focus();
				return false;
			}
			if(objForm.txtOldPassword.value == "") {
				alert("Please insert your old password");
				objForm.txtOldPassword.focus();
				return false;
			}
			if(objForm.txtNewPassword.value == "") {
				alert("Please insert your New Password");
				objForm.txtNewPassword.focus();
				return false;
			}
			if(objForm.txtNewPassword.value.length < 6) {
				alert("Please fill in a New Password that is at least 6 characters long");
				objForm.txtNewPassword.select();
				return false;
			}
			if(objForm.txtConfNewPassword.value == "") {
				alert("Please insert your New confirmed password");
				objForm.txtConfNewPassword.focus();
				return false;
			}
			if(objForm.txtConfNewPassword.value != objForm.txtNewPassword.value) {
				alert("The confirmation password is not the same");
				objForm.txtConfNewPassword.select();
				return false;
			}
			return true;
		}
		
		function Initialize() {
			//frmLogin.txtUserName.focus();
			
			if(frmLogin.txtUserName.value == "") {
				frmLogin.txtUserName.readOnly = false;
			}
			
			if(top.document.location.href != document.location.href)
				top.document.location.href = document.location.href;
		}
		
		<cfif intExpiryDaysLeft GT 0>
			function ShowChangePwd() {
				document.getElementById('TR1').className = 'dspHiddenOn';
				document.getElementById('TR2').className = 'dspHiddenOff';
				document.getElementById('TR3').className = 'dspHiddenOff';
				document.getElementById('TR4').className = 'dspHiddenOff';
				document.getElementById('TR5').className = 'dspHiddenOff';
				document.getElementById('TR6').className = 'dspHiddenOff';
			}
			
			function ContinueRelocate() {
				document.location.href = '#URLSessionFormat('index.cfm?event=mainpage')#';
			}
		</cfif>
	</script>

<form action="index.cfm?event=changePassword:Process&#Session.URLToken#" method="post" name="frmLogin" id="frmLogin" onSubmit="JavaScript: return Validation(this)">
<table width="100%" border="0" cellspacing="0" cellpadding="0"  border="1">
	<tr>
		<td width="100%" height="97%" align="center" valign="middle">
			<table border="0" cellspacing="0" cellpadding="5" class="lightitemborder">
				<cfif isdefined('PasswordCheck.isLoggedIn')>
					<tr>
						<td colspan="3" align="center">The "Old Password" you entered is incorrect. Please try again.</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="requiredFieldLabel">User Name*</td>
					<td><input type="text" name="txtUserName" maxlength="50" style="width:250px;" value="#session.passport.CurrentSiteUser.getUsername()#" readonly></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="requiredFieldLabel">Old Password*</td>
					<td><input type="Password" name="txtOldPassword" maxlength="50" style="width:250px;"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="requiredFieldLabel">New Password*</td>
					<td><input type="Password" name="txtNewPassword" maxlength="50" style="width:250px;"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="requiredFieldLabel">Confirm New Password*</td>
					<td><input type="Password" name="txtConfNewPassword" maxlength="50" style="width:250px;"></td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" align="right">
						<input type="submit" value="UPDATE" class="button">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</cfoutput>