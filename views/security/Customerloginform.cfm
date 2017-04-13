<cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	function Validation(objForm) {
		if(objForm.UserName.value == "") {
			alert('Please insert your user name');
			objForm.UserName.focus();
			return false;
		}
		if(objForm.Password.value == "") {
			alert('Please insert your password');
			objForm.Password.focus();
			return false;
		}
		return true;
	}

	function Initialize() {
		document.getElementById('UserName').focus();

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

<div class="login-bg">
<div class="login-title">Customer Login</div>
<form action="index.cfm?event=Customerlogin:process&#Session.URLToken#&reinit=true" method="post" name="frmLogin" id="frmLogin" onSubmit="JavaScript: return Validation(this)" autocomplete="off">
	<cfif IsDefined("URL.AlertMessageID") And IsDefined("Session.Passport.LoginError") And URL.AlertMessageID EQ 1>
		<div class="msg-area" style="width:360px;color:red;">#Session.Passport.LoginError#</div>
		<cfelseif IsDefined("URL.AlertMessageID") and URL.AlertMessageID eq 2>
		<div class="msg-area" style="width:360px;color:red;">Session has expired</div>
	</cfif>
	<fieldset>
	<label class="user">Username:</label>
	<!--- <td class="requiredFieldLabel" nowrap="true">User Name<cfif Session.blnDebugMode><a onclick="JavaScript:document.getElementById('UserName').value = 'super'; document.getElementById('Password').value = '@super1';">*</a><cfelse>*</cfif></td> --->
	<input type="text" id="UserName" name="Username" class="field">
	<div class="clear"></div>
	<label class="user">Password:</label>
	<input type="Password" id="Password" name="LoginPassword" class="field">
	<div class="clear"></div>
	<label class="user">&nbsp;</label>
	<label class="fpass"><a href="index.cfm?event=lostPassword&#Session.URLToken#&type=c">Forgot your password?</a></label>
	<input name="btnSubmit" type="submit" class="loginbttn" value="Login">
	<div class="clear"></div>	
</form>
</div>
<div class="clear"></div>

<script language="javascript" type="text/javascript">
	Initialize();
</script>
<!--LOGIN_PAGE--><!---Do not remove this HTML comment, it is used for ajax to detect when the session times out--->
</cfoutput>