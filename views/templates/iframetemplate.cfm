<cfparam name="request.blnIncludeBorder" default="True" />
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta http-equiv="X-UA-Compatible" content="IE=9" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title></title>
	<link href="stylesheets/default.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0px" cellpadding="0px" cellspacing="0px">
	<cfif request.blnIncludeBorder>
		<tr>
			<td background="images/sub_header_back.jpg" height="20px" style="height:20px;"><div class="subheading"><cfif StructKeyExists(request, "SubHeading")>#request.SubHeading#</cfif></div></td>
		</tr>
	</cfif>
	<tr>
		<td<cfif request.blnIncludeBorder> class="border"</cfif> valign="top"><div class="framecontent"><cfif StructKeyExists(request, "content")>#request.content#</cfif></div></td>
	</tr>
</table>        
</body>
</html>
</cfoutput>