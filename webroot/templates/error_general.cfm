<!---
Written By: Shardendu
Date Created: 2011-03-17
Page Purpose: Site Main Error Template
--->
<cftry>
	<cfparam name="userlogged" default="0">
	<cfset SmtpAddress='smtpout.secureserver.net'>
	<cfset SmtpUsername='no-reply@loadmanager.com'>
	<cfset SmtpPort='3535'>
	<cfset SmtpPassword='wsi11787'>
	<cfset FA_SSL=0>
	<cfset FA_TLS=1>
	<cfif IsDefined("Error.RootCause.Detail") And FindNoCase("Placement Conflict", Error.RootCause.Detail) GT 0>
		<cfheader statuscode="421" statustext="Placement Conflict" />
		<cfset blnSendEmail = False />
		<cfset strErrorTitle = "Placement Conflict" />
		<cfset strErrorMessage = "#Error.RootCause.Message#<br>#Error.RootCause.Detail#" />
	<cfelse>
		<cfheader statuscode="500" statustext="Internal Server Error" />
		<cfset blnSendEmail = True />
		<cfset strErrorTitle = "Unknown Error" />
		<cfset strErrorMessage = "There has been a temporary error on the site.<br>We have been notified of the problem, please try again later.<br>We apologise for any inconvenience." />
	</cfif>
	
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	<html>
		<head>
			<title><cfoutput><cftry>#CGI.HTTP_HOST# Error<cfcatch type="any">Unknown Error</cfcatch></cftry></cfoutput></title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<!---link rel="StyleSheet" href="stylesheets/default.css" type="text/css"--->
			<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
			<script src="https://code.jquery.com/ui/1.11.0/jquery-ui.min.js"></script>
		</head>
		<body>
			<table class="MainTable" width="100%" height="100%">
				<tr>
					<td align="center" valign="middle">
						<table>
							<tr>
								<td align="center" class="heading"><cfoutput>#strErrorTitle#</cfoutput></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td align="center" valign="middle"><cfoutput>#strErrorMessage#</cfoutput></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</body>
	</html>
	<cfflush>
	
		<!---cfmail from="errors@entelligence.co.za" to="errors@entelligence.co.za" subject="There was an error on #CGI.HTTP_HOST#" type="html"--->
		
		<cfmail from="#SmtpUsername#" subject="#trim(listFirst(cgi.SCRIPT_NAME,'/'))# website error" to="scottw@webersystems.com" cc="rojin.terrance@spericorn.com,arunraj@spericorn.com" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" type="html">
		<table width="100%">
		   <tr>
			   <td>There was an error on a website... Please see below for details</td>
		   </tr>
		   <tr>
			   <td>&nbsp;</td>
		   </tr>
		   <!---tr>
			   <td>Kind Regards,</td>
		   </tr>
		   <tr>
			   <td>Entelligence Support</td>
		   </tr--->
		   <tr>
			   <td>&nbsp;</td>
		   </tr>
		   <tr>
			   <td><hr></td>
		   </tr>
		   <cfif IsDefined("Error")>
			   <tr>
				   <td>&nbsp;</td>
			   </tr>
			   <tr>
				   <td>Error</td>
			   </tr>
			   <tr>
				   <td><cfdump var="#Error#"></td>
			   </tr>
		   </cfif>
		   <cfif IsDefined("CGI")>
			   <tr>
				   <td>&nbsp;</td>
			   </tr>
			   <tr>
				   <td>CGI Variables</td>
			   </tr>
			   <tr>
				   <td><cfdump var="#CGI#"></td>
			   </tr>
		   </cfif>
		   <cfif IsDefined("Session")>
		   	<cftry>
			   	<cfset structSessionDump = Duplicate(Session) />
				<cfif StructKeyExists(structSessionDump, "rstPastelFile")>
					<cfset StructDelete(structSessionDump, "rstPastelFile") />
				</cfif>
				<cfcatch type="any">
				   	<cfset structSessionDump = Session />
				</cfcatch>
			</cftry>
			   <tr>
				   <td>&nbsp;</td>
			   </tr>
			   <tr>
				   <td>Session</td>
			   </tr>
			   <tr>
				   <td><cfdump var="#structSessionDump#"></td>
			   </tr>
		   </cfif>
		   <cfif IsDefined("Form")>
			   <tr>
				   <td>&nbsp;</td>
			   </tr>
			   <tr>
				   <td>Form</td>
			   </tr>
			   <tr>
				   <td><cfdump var="#Form#"></td>
			   </tr>
		   </cfif>
		   <cfif IsDefined("URL")>
			   <tr>
				   <td>&nbsp;</td>
			   </tr>
			   <tr>
				   <td>URL</td>
			   </tr>
			   <tr>
				   <td><cfdump var="#URL#"></td>
			   </tr>
		   </cfif>
		</table>
		</cfmail>

	<cfif structkeyexists (session,"empid") and structkeyexists(session, "passport")>			
		<cfif Session.empid neq "" and session.passport.isLoggedIn>		
			<cfset userlogged=1>
		</cfif>
	</cfif>	
	<cfif structkeyexists (session,"customerid") and structkeyexists(session, "passport")>
		<cfif Session.customerid neq "" and session.passport.isLoggedIn>
			<cfset userlogged=1>
		</cfif>
	</cfif>	
	<cfif userlogged eq 1>
		<script>
			$(function(){
				window.heartBeat = setInterval(
				function(){
					$.get( "userCountRunning.cfm" );
				},
				(45 * 1000)
				);
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
	<cfcatch type="any">
	</cfcatch>
</cftry>