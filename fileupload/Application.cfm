<!---
Written By: Weber Systems Inc. 
Date Started: 28-01-2011
Page Purpose: Main Application page
--->
<cfset strApplicationName = Right(ExpandPath('.'), 64) />
<cfapplication name="#strApplicationName#" clientmanagement="no" sessionmanagement="yes" setclientcookies="no" setdomaincookies="no" sessiontimeout="#CreateTimeSpan(0,2,0,0)#" applicationtimeout="#CreateTimeSpan(1,0,0,0)#">


<cfscript>
	//StructDelete(Session, "passport");
	//Application Variables
	Application.Name = strApplicationName;
	Application.QBdsn = "LMaccessQB";
	Application.gAPI='AIzaSyAMvv7YySXPntllOqj7509OH-9N3HgCJmw';

	//Application.dsn = "Lmdev";
		Application.dsn = trim(listFirst(cgi.SCRIPT_NAME,'/'));	
	Application.blnDebugMode = false;
	Application.strWebsiteTitle = "Load Manager"; //Remember this does not effect the error template title
	Application.strDeveloperEmailAddress = "ScottW@WeberSystems.com;scottnweber@gmail.com";
	Application.ExtrasFolder = ExpandPath("../../extras");
	Application.strDateFormat = "d MMMM YYYY";
	Application.strDateFormatForTextInput = "dd/MM/YYYY";
	Application.ResultsPerPage = 10;
	Application.ImportDSN = "";
	Application.SchedulerTimeout = 120;
	Application.pwdExpiryDays = 600; // How many days before the passwords expire (by default).
	Application.strTimeFormat = "HH:MM";
	Application.NoAuthEvents = "login|login:process|lostpassword|lostpassword:process"; // This is a Pipe(|) Separated List of events that do not require the user to be logged in first (e.g. login|login:process).
	Application.strSMSAddress = "ScottW@WeberSystems.com";
	Application.strEmailFromAddress = "ScottW@WeberSystems.com";
</cfscript>

	<cfset basepath = GetDirectoryFromPath(GetBaseTemplatePath())>
	<!--- publicRoot: the directory that Application.cfc resides in (the web root) --->
	<cfset publicRoot = GetDirectoryFromPath(GetCurrentTemplatePath())>
	<cfif len(basepath) gt len(publicRoot)>
		<!--- relativePath: the difference between basepath and publicRoot --->
		<cfset relativePath = right(basepath, len(basepath) - len(publicRoot))>
		<!--- publicRootRelative: the relative path from the current template to the web root --->
		<cfset publicRootRelative = ReReplace(relativePath, "[^\\\/]+", "..", "ALL")>
		<cfset publicRootParentRelative = iif(Len(publicRootRelative) GT 3, 'Left(publicRootRelative, Len(publicRootRelative) - 3)', DE(publicRootRelative))>
		<cfset publicRootGrandParentRelative = iif(Len(publicRootParentRelative) GT 3, 'Left(publicRootParentRelative, Len(publicRootParentRelative) - 3)', DE(publicRootParentRelative))>
	<cfelse>
		<!--- the current template resides in the web root, both these variables are empty --->
		<cfset relativePath = "">
		<cfset publicRootRelative = "">
	</cfif>
	<cfset session.checkUnload = ''>
	<cfset request.webpath = Replace("http://#cgi.http_host##cgi.script_name#", "\", "/", "ALL")>
	<cfset numDirectories = ListLen(relativePath, "\/") + 1>
	<cfloop from="1" to="#numDirectories#" index="i">
		<cfset request.webpath = left(request.webpath, len(request.webpath) - find("/", reverse(request.webpath)))>
	</cfloop>

	<cfset request.imagesPath = request.webpath & "/images/">
	<cfset request.fileUploadedtemp = request.webpath & "/fileupload/imgTemp/">  
	<cfset request.fileUploadedPer = request.webpath & "/filesUpload/imgPrmnt/">

  <!---cfset request.cfcpath = 'Lmdev.www.gateways'--->   
	 <cfset request.cfcpath = Application.dsn &'.www.gateways'>  

<!---Sample URL is http://www.loadmanager.biz/cfmps/www/webroot/index.cfm?strDebugMode=EntelDebug2012041106--->
<!---The 06 in the end is the hour of the current time in the timezone set on the server. This would need to change every hour.---> 
<cfif IsDefined("URL.strDebugMode")>
   <cfif URL.strDebugMode EQ "EntelDebug#DateFormat(Now(),"yyyyMMddHH")#">
       <cfset Application.blnDebugMode = True>
   </cfif>
</cfif>

<cfparam name="Session.blnDebugMode" default="#Application.blnDebugMode#">

<cfif Application.blnDebugMode Or Session.blnDebugMode>
	<cfsetting showdebugoutput="yes">
<cfelse>
	<cfsetting showdebugoutput="no">
	<!--- <cferror type="exception" template="templates/error_general.cfm" mailto="#Application.strDeveloperEmailAddress#">
	<cferror type="request" template="templates/error_general.cfm" mailto="#Application.strDeveloperEmailAddress#"> --->
</cfif>