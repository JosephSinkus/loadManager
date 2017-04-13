
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://code.jquery.com/ui/1.11.0/jquery-ui.min.js"></script>
<cfset SmtpAddress='smtpout.secureserver.net'>
<cfset SmtpUsername='no-reply@loadmanager.com'>
<cfset SmtpPort='3535'>
<cfset SmtpPassword='wsi11787'>
<cfset FA_SSL=0>
<cfset FA_TLS=1>
<cfoutput>
<!---cfmail type="text" from="#SmtpUsername#" subject="Lost Password Retrieval" to="arunraj@spericorn.com" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
 <cfoutput>#Application.userLoggedInCount#
  
 </cfoutput>
</cfmail--->
	Error occured
</cfoutput>
<cfif structkeyexists (session.passport,"isLoggedIn") >		
	<cfif session.passport.isLoggedIn>
		<script>
			// When the DOM is ready to be interacted with, let's
			// set up our heartbeat.
			
			$(function(){
				// When setting up the interval for our heartbeat,
				// we want it to fire every 90 seconds so that it
				// doesn't allow the session to timeout. Because
				// AJAX passes back all the same cookies, the server
				// will see this as a normal page request.
				//
				// Save a handle on the interval in our window scope
				// so that we can clear it when needbe.
			   window.heartBeat = setInterval(
					function(){
						$.get( "userCountRunning.cfm" );
					},
					
					(45 * 1000)
					);
				// If someone leaves their window open, we might not
				// want their session to stay open indeterminetly. As
				// such, let's kill the heart beat after a certain
				// amount of time (ex. 20 minutes).
				setTimeout(
					function(){
						// Clear the heart beat.
						clearInterval( window.heartBeat );
					},
					(120 * 60 * 1000)
					);
			});
		</script>
	</cfif>
</cfif>
		