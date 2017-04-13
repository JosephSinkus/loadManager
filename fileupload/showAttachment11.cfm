<!------<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">----------->
<html>
<head>
<cfoutput> 
<cfif fileexists(expandpath('img/#url.file#'))>
	<cfif listlast(url.file,".") eq 'docx'>
		<cfcontent type="application/msword; charset=utf-8" file="#expandpath('img/#url.file#')#">

	<cfelseif listlast(url.file,".") eq 'doc'>
		<cfcontent type="application/msword; charset=utf-8" file="#expandpath('img/#url.file#')#">
				
	<cfelseif listlast(url.file,".") eq 'xlsx'>
		<cfcontent type="application/excel" file="#expandpath('img/#url.file#')#">
		
	<cfelseif listlast(url.file,".") eq 'txt'>
		<cfcontent type="text/plain" file="#expandpath('img/#url.file#')#">
		     
      <cfelseif listlast(url.file,".") eq 'pdf'>
		<cfcontent type="application/pdf" file="#expandpath('img/#url.file#')#">  

	<cfelseif listlast(url.file,".") eq 'htm' or listlast(url.file,".") eq 'html'>
		<cfcontent type="application/text/html" file="#expandpath('img/#url.file#')#">
	<cfelse>
		<img src="img/#url.file#">
	</cfif>
<cfelse>
	<h2 align="center">File does not exist</h2>
</cfif>
</cfoutput>
</body></html>