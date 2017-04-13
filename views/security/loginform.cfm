<cfparam name="URL.allowedUserFlagID" default="1">
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
		document.getElementById('txtUserName').focus();

		if(top.document.location.href != document.location.href) {
			try {
				top.locateTimeout('index.cfm?event=loginPage&#Session.URLToken#');
				window.close();
			}
			catch (e) {
			}
		}
						
	}
	
	$(document).ready(function() {
        $('.getInactiveUser').click(function() {
            var customerId = $(this).val();
            var useruniqueid = $(this).attr( "data-useruniqueid" );
            if(customerId) {
	            $.ajax({
			   		type 	: 'POST',
				  	url		: "eliminateInactiveUsers.cfc?method=eliminateinactiveusers",
				  	data 	: {customerId : customerId, useruniqueid : useruniqueid},
				  	success	:function(data){
				  		$('.userLimitWarning').hide();
				  		$('.userListItem_'+customerId+'_'+useruniqueid).hide();
				  	}
				});
            }
        });
    });

</script>
<style type="text/css">
	.loggedUsersTd{
		width: 90px !important;
		text-align: center !important;
		padding: 5px !important;
	}
	.loggedUsers{
		width: 300px !important;
		margin: 0 auto !important;
	}
	.loggedUsers h3, .loggedUsers h4{
		text-align: center !important;
	}
	.loggedUsers h3 {
		color: red !important;
	}
</style>
<div class="login-bg">
	<div class="login-title">Login</div>
	<form action="index.cfm?event=login:process&#Session.URLToken#&reinit=true" method="post" name="frmLogin" id="frmLogin" onSubmit="JavaScript: return Validation(this)" autocomplete="off">
		<cfif IsDefined("URL.AlertMessageID") And IsDefined("Session.Passport.LoginError") And URL.AlertMessageID EQ 1>
			<div class="msg-area" style="width:360px;color:red;">#Session.Passport.LoginError#</div>
			<cfelseif IsDefined("URL.AlertMessageID") and URL.AlertMessageID eq 2>
			<div class="msg-area" style="width:360px;color:red;">Session has expired</div>
		</cfif>
		<fieldset>
		<label class="user">Username:</label>
		<!--- <td class="requiredFieldLabel" nowrap="true">User Name<cfif Session.blnDebugMode><a onclick="JavaScript:document.getElementById('txtUserName').value = 'super'; document.getElementById('txtPassword').value = '@super1';">*</a><cfelse>*</cfif></td> --->
		<input type="text" id="txtUserName" name="txtUsername" class="field">
		<div class="clear"></div>
		<label class="user">Password:</label>
		<input type="Password" id="txtPassword" name="txtLoginPassword" class="field">
		<div class="clear"></div>
		<label class="user">&nbsp;</label>
		<label class="fpass"><a href="index.cfm?event=lostPassword&#Session.URLToken#">Forgot your password?</a></label>
		<input name="btnSubmit" type="submit" class="loginbttn" value="Login">
		<div class="clear"></div>	
	</form>
</div>

<div class="clear"></div>
<cfif URL.allowedUserFlagID EQ 0>
	<cfquery name="qActiveUsers" datasource="#Application.dsn#">
		SELECT 	cutomerId,currenttime,isactive,username,isLoggedIn,useruniqueid
		FROM	userCountCheck
	</cfquery>

	<div class="loggedUsers">
		<h3 class="userLimitWarning">All Users are currently logged on. To Log on, please click on a red circle X below to log off a user and try again.</h3>
		<h4>Current User Status</h4>
		<table>
			<thead>
				<th class="loggedUsersTd">Name</th>
				<th class="loggedUsersTd">Status</th>
				<th class="loggedUsersTd">Last Active Date_time</th>
				<th class="loggedUsersTd">Action</th>
			</thead>
			<tbody>
				<cfif qActiveUsers.recordcount>
					<cfloop query="qActiveUsers">
						<tr class="userListItem_#qActiveUsers.cutomerId#_#qActiveUsers.useruniqueid#">
							<td class="loggedUsersTd">#qActiveUsers.username#</td>
							<td class="loggedUsersTd">
								<cfif qActiveUsers.isactive eq 0>
									<span style="color:red">Inactive</span>
								<cfelse>
									<span>Active</span>
								</cfif>
							</td>
							<td class="loggedUsersTd">#dateformat(qActiveUsers.currenttime,"mm/dd/yyyy_hh:mm:ss")#</td>
							<td class="loggedUsersTd"><button style="border: none; border-radius: 100%; color: white; background-color: red; margin-left: 10px;" value="#qActiveUsers.cutomerId#" data-useruniqueid="#qActiveUsers.useruniqueid#" class="getInactiveUser"> x </button>
							</td>
						<tr>
					</cfloop>	
				</cfif>		
			</tbody>
		</table>
	</div>

</cfif>


<script language="javascript" type="text/javascript">
	Initialize();
</script>
<!--LOGIN_PAGE--><!---Do not remove this HTML comment, it is used for ajax to detect when the session times out--->
</cfoutput>