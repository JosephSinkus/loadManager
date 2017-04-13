

<cfoutput>
<script language="javascript" type="text/javascript">
	function Validation()
	{
		if(document.getElementById('txtEmailAddress').value.length == 0)
		{
			alert("Please enter your email address");
			document.getElementById('txtEmailAddress').focus();
			return false;
		}
	}
</script>
<div class="login-bg">
<div class="login-title">Email Sent</div>
<form action="index.cfm?event=lostpassword:process&#Session.URLToken#<cfif structkeyexists(url,'type')>&type=c</cfif>" method="post" name="frmLostPassword" id="frmLostPassword" onSubmit="JavaScript: return Validation(this)" autocomplete="off">
				<fieldset>
				<!--- <label class="user">Please enter your email address and we will send your login details to you</label> --->
				<cfif isdefined('URL.Success')>
					<div id="alertmsg">
						<!--- <h4 style="color:red;">Email Address Not Found</h4> --->
						<!--- <h2 style="color:##287E0D;">
							Email Sent
						</h2> --->
						<h4 style="color:##287E0D;margin-bottom: 15px;margin-right: 40px;">
							Username and password is send to your email address. Please check your email.<br>
							Click <a href="index.cfm<cfif isdefined('URL.Type')>?event=customerlogin</cfif>" title="login" style="text-decoration: underline;">here</a>
							to login.
						</h4>
					</div>
				</cfif>
				<!--- <div class="clear"></div>
				<div style="padding-left:124px;"><input type="button" value="Login" class="loginbttn" style="margin-right:15px;" onclick="document.location.href='index.cfm';" /></div> --->
				<div class="clear"></div>
				</fieldset>			
</form>
<div class="clear"></div>
</div>
</cfoutput>