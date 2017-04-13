<cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	function Validation(objForm) {
		if(objForm.txtUserName.value == "") {
			alert('Please insert your user name');
			objForm.txtUserName.focus();
			return false;
		}
		if(objForm.txtPassword.value == "") {
			alert('Please insert your password');
			objForm.txtPassword.focus();
			return false;
		}
		return true;
	}

	function Initialize() {
		document.getElementById('frmLogin').txtUserName.focus();

		if(top.document.location.href != document.location.href) {
			try {
				top.locateTimeout('index.cfm?event=loginPage&#Session.URLToken#');
				window.close();
			}
			catch (e) {
			}
		}
						
	}
	
</script>

<form action="index.cfm?event=loginUser&#Session.URLToken#" method="post" name="frmLogin" id="frmLogin" onSubmit="JavaScript: return Validation(this)" autocomplete="off">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr>
		<td width="100%" height="97%" align="center" valign="middle">
			<table border="0" cellspacing="0" cellpadding="5" class="lightitemborder">
				<tr>
					<td class="lightitemheading" colspan="1">Please enter your login details</td>
				</tr>
				<tr>
					<td class="tablelinespace"></td>
				</tr>
				<cfif arguments.event.isArgDefined('intMessageID')>
					<tr>
						<cfswitch expression="#arguments.event.getArg('intMessageID')#">
							<cfcase value="1">
								<td class="failurealert" colspan="1">
									Incorrect User Name or Password
									<!--- <embed src="sounds/incorrectpassword.wav" autostart="true" loop="false" hidden="true" /> --->
								</td>
							</cfcase>
							<cfcase value="2">
								<td class="failurealert" colspan="1">
									You do not have permission to view that event
								</td>
							</cfcase>
							<cfcase value="3">
								<td class="failurealert" colspan="1">
									Either you are not logged in or your session has timed out. Please log in.
								</td>
							</cfcase>
							<cfcase value="4">
								<td class="failurealert" colspan="1">
									Your password is expiring. Please log in and change your password.
								</td>
							</cfcase>
							<cfcase value="5">
								<td class="successalert" colspan="1">
									Your password has been emailed to you.
								</td>
							</cfcase>
							<cfdefaultcase>
								<td class="failurealert" colspan="1">&nbsp;
									
								</td>
							</cfdefaultcase>
						</cfswitch>
					</tr>
				</cfif>
				<tr>
					<td>
						<table cellpadding="5" cellspacing="0">
							<tr>
								<td>&nbsp;</td>
								<td class="requiredFieldLabel" nowrap="true">User Name<cfif Session.blnDebugMode><a onclick="JavaScript:document.getElementById('txtUserName').value = 'super'; document.getElementById('txtPassword').value = '@super1';">*</a><cfelse>*</cfif><br />(e.g. domain\username)</td>
								<td><input type="text" id="txtUserName" name="txtUserName" maxlength="50" style="width:250px;" value="#GetAuthUser()#"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td class="requiredFieldLabel" nowrap="true">Password*</td>
								<td><input type="Password" id="txtPassword" name="txtPassword" maxlength="50" style="width:250px;"></td>
							</tr>
							<tr>
								<td colspan="3">
									<table cellpadding="0" cellspacing="0" width="100%">
										<tr>
											<td align="right" width="100%" nowrap="true"><a href="index.cfm?event=lostPassword&#Session.URLToken#">forgot your password?</a>&nbsp;</td>
											<td align="right"><input name="btnSubmit" type="submit" value="Login" class="button"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	Initialize();
</script>
</cfoutput>