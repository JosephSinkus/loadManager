<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- DECLARE GATEWAYS --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->

<!--- e.g. variables.objCustomers = getGateway("gateways.customers.customergateway", MakeParameters("dsn=#Application.dsn#")); --->
<cfscript>
	variables.objSecurityGateway = getGateway("gateways.security.securitygateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objloadGateway = getGateway("gateways.loadgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objAgentGateway = getGateway("gateways.agentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objequipmentGateway = getGateway("gateways.equipmentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objPrivilegeXmlGateway = getGateway("gateways.security.privilegexmlgateway", MakeParameters("xmlFilePath=#ExpandPath('#request.strBase#../config/privileges.xml')#"));
</cfscript>

<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- MAIN SECTION - DEFINE YOUR EVENTS HERE --->
<!--------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--- <cfdump var="#request.event#" /><cfabort /> --->

<cfswitch expression="#request.event#">
	<cfcase value="noPrivileges">
		<cfset request.content = includeTemplate("views/security/noaccess.cfm", true) />
		<cfif IsDefined("URL.blnIsTab") And URL.blnIsTab>
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfelseif IsDefined("URL.blnIFrame") And URL.blnIFrame>
			<cfset request.blnIncludeBorder = False />
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfelse>
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		</cfif>
	</cfcase>
	<cfcase value="login">
		<cfset request.content = includeTemplate("views/security/loginform.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<cfcase value="login:process">

		<cfif StructKeyExists(Form, "txtUsername")>
			<cfquery name="qActiveUsers" datasource="#Application.dsn#" result="sample">
				DELETE FROM userCountCheck
				WHERE loginname like <cfqueryparam value="%#Form.txtUsername#%" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>	

		<cfquery name="qActiveUsers" datasource="#Application.dsn#">
			SELECT 	cutomerId
			FROM	userCountCheck
		</cfquery>

		<cfquery name="qGetAllowedUsers" datasource="#Application.dsn#">
			SELECT *
			FROM SystemConfig
		</cfquery>
		<cfif qGetAllowedUsers.recordcount>
			<cfset local.allowedUserLimit = qGetAllowedUsers.allowed_users>
		</cfif>

		<cfif qActiveUsers.recordcount LT local.allowedUserLimit>
			<!--- Check if the variables exists --->
			<cfif Not StructKeyExists(Form, "txtUsername")>
				<cfthrow errorcode="1001" message="Username Missing" detail="The Username has not been specified on the previous page" />
			</cfif>
			<cfif Not StructKeyExists(Form, "txtLoginPassword")>
				<cfthrow errorcode="1001" message="Password Missing" detail="The Password has not been specified on the previous page" />
			</cfif>
			<cfset session.passport = doLogin(strUsername=FORM.txtUsername, strPassword=FORM.txtLoginPassword) />
			
	        <cfif session.passport.isLoggedIn>
				<cfset session.AdminUserName = FORM.txtUsername>
				 
	            <cfinvoke component="#variables.objAgentGateway#" method="getUserRoleByUserName" returnvariable="request.qUserRole">
	            	<cfinvokeargument name="userName" value="#session.AdminUserName#">
	            </cfinvoke>
	            <cfinvoke component="#variables.objAgentGateway#" method="GetUserInfoUserName" returnvariable="request.qUserInfo">
	            	<cfinvokeargument name="userName" value="#session.AdminUserName#">
	            </cfinvoke>

				<!---USP_GetUserInfoUserName--->
	            <cfset session.currentUserType = request.qUserRole.RoleValue>
	            <cfset session.UserFullName = request.qUserInfo.Name>
	            <cfset session.rightsList = request.qUserRole.userRights>
	            <cfset session.userUniqueId = CreateUUID()>
	            <cfquery name="qInsertActiveStatus" datasource="#Application.dsn#" result="qInsertActiveStatus">
					insert into userCountCheck (cutomerId,currenttime,isactive,isLoggedIn,username,useruniqueid,loginname)
					VALUES(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.UserFullName#" null="#yesNoFormat(NOT len(session.UserFullName))#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.userUniqueId#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.AdminUserName#">
					) 
				</cfquery>
				<cfif session.passport.PasswordExpired Or session.passport.PasswordAlmostExpired>
					<cflocation url="index.cfm?event=passwordExpired" addtoken="yes" />
				<cfelse>
					<cfif CheckObjectAccess("navMainClients")>
						<cflocation url="index.cfm?event=SearchClient" addtoken="yes" />
					<cfelse>
						<cflocation url="index.cfm?event=Myload" addtoken="yes" />
					</cfif>
				</cfif>
			<cfelse>
				<cflocation url="index.cfm?event=login&AlertMessageID=1" addtoken="yes" />
			</cfif>
		<cfelse>
			<cflocation url="index.cfm?event=login&allowedUserFlagID=0" addtoken="yes" />
		</cfif>	

	</cfcase>
	<cfcase value="customerlogin">
		<cfset request.content = includeTemplate("views/security/Customerloginform.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>

	<cfcase value="Customerlogin:process">
		<!--- Check if the variables exists --->
		<cfif Not StructKeyExists(Form, "Username")>
			<cfthrow errorcode="1001" message="Username Missing" detail="The Username has not been specified on the previous page" />
		</cfif>
		<cfif Not StructKeyExists(Form, "LoginPassword")>
			<cfthrow errorcode="1001" message="Password Missing" detail="The Password has not been specified on the previous page" />
		</cfif>

		<cfset session.passport = CustomerdoLogin(strUsername=FORM.Username, strPassword=FORM.LoginPassword) />
        <cfif session.passport.isLoggedIn>
			<cfset session.AdminUserName = FORM.Username>
			<cfset request.qUserRole.RoleValue = 8>
			<cfset request.qUserRole.userRights = 'ViewLoad'>
            <cfquery name="request.qUserInfo" datasource="#Application.dsn#">
            	SELECT * FROM Customers 
            	WHERE CUSTOMERNAME = <cfqueryparam value="#session.AdminUserName#" cfsqltype="cf_sql_varchar">
            </cfquery>
			<!--- <cfif structkeyexists (session,"customerid")>
				<cfif Session.customerid neq "">
					<cfset cookie.userLogginID = Session.customerid>
					<!--- set your session var like normal --->
					<cfif NOT ListFindNoCase(Application.userLoggedInCount, Session.customerid)>
						<cfset Application.userLoggedInCount = ListAppend(Application.userLoggedInCount,
						Session.customerid)>
					</cfif>
				</cfif>	
			</cfif> --->
			
            <!---USP_GetUserInfoUserName--->
            
            <cfset session.currentUserType = request.qUserRole.RoleValue>
            <cfset session.UserFullName = request.qUserInfo.CUSTOMERNAME>
            <cfset session.rightsList = request.qUserRole.userRights>
			<cfif session.passport.PasswordExpired Or session.passport.PasswordAlmostExpired>
				<cflocation url="index.cfm?event=passwordExpired" addtoken="yes" />
			<cfelse>
				<cfif CheckObjectAccess("navMainClients")>
					<cflocation url="index.cfm?event=SearchClient" addtoken="yes" />
				<cfelse>
					<cflocation url="index.cfm?event=load" addtoken="yes" />
				</cfif>
			</cfif>
		<cfelse>
			<cflocation url="index.cfm?event=CustomerLogin&AlertMessageID=1" addtoken="yes" />
		</cfif>

	</cfcase>
    
	<cfcase value="passwordExpired">
		<cfset request.content = includeTemplate("views/security/passwordexpired.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
	<cfcase value="changePassword:Form">
		<cfset request.SubHeading = "Change Password">
		<cfset request.content = includeTemplate("views/security/loginchangepwd.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
	<cfcase value="lostpassword">		
		<!--- <cfset request.SubHeading = "Lost Password"> --->
		<cfset request.content = includeTemplate("views/security/lostpassword.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
    <cfcase value="recoveryEmailSuccess">
		<cfset request.content = includeTemplate("views/security/recoveryEmailSuccess.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>

	<cfcase value="lostpassword:process">
		<!--- <cfset NewPassword = GenerateRandomPassword()> --->
		<!--- <cfset request.UserDetails = variables.objSecurityGateway.checkLostPassword("#form.txtEmailAddress#","#NewPassword#")> --->
		
		<cfset SmtpAddress='smtpout.secureserver.net'>
		<cfset SmtpUsername='no-reply@loadmanager.com'>
		<cfset SmtpPort='3535'>
		<cfset SmtpPassword='wsi11787'>
		<cfset FA_SSL=0>
		<cfset FA_TLS=1>
		
		<cfif StructKeyExists(url,'type') and url.type eq 'c'>
			<cfset request.CustomerDetails = variables.objSecurityGateway.checkCustomerLostPassword("#form.txtEmailAddress#")>
			
			<cfif request.CustomerDetails.recordcount GT 0>
				<cfmail from="#SmtpUsername#" subject="Lost Password Retrieval" to="#form.txtEmailAddress#" type="html" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
					<table>
						<tr>
							<td>Dear #request.CustomerDetails.CustomerName#</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>You entered the "Lost Password" section of the system and have asked us to retrieve your password. If you have received this email in error please contact the system administrator immediately.</td>
						</tr>
						<tr>
							<td>Username: #request.CustomerDetails.userName#</td>
						</tr>
						<tr>
							<td>Password: #request.CustomerDetails.Password#</td>
						</tr>
					</table>
				</cfmail>
				<cflocation url="index.cfm?event=recoveryEmailSuccess&Success=y&type=c" addtoken="yes" />
			<cfelse>
				<cflocation url="index.cfm?event=lostpassword&Failed=y&type=c" addtoken="yes" />
			</cfif>
		<cfelse>
			<cfset request.UserDetails = variables.objSecurityGateway.checkLostPassword("#form.txtEmailAddress#")>
			
			<cfif request.UserDetails.recordcount GT 0>
				<cfmail from="#SmtpUsername#" subject="Lost Password Retrieval" to="#form.txtEmailAddress#" type="html" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
					<table>
						<tr>
							<td>Dear #request.UserDetails.Name#</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>You entered the "Lost Password" section of the system and have asked us to retrieve your password. If you have received this email in error please contact the system administrator immediately.</td>
						</tr>
						<tr>
							<td>Username: #request.UserDetails.loginid#</td>
						</tr>
						<tr>
							<td>Password: #request.UserDetails.Password#</td>
						</tr>
					</table>
				</cfmail>
				<cflocation url="index.cfm?event=recoveryEmailSuccess&Success=y" addtoken="yes" />
			<cfelse>
				<cflocation url="index.cfm?event=lostpassword&Failed=y" addtoken="yes" />
			</cfif>
		</cfif>
	</cfcase>
    
	<cfcase value="changePassword:Process">
		<cfset request.SubHeading = "Change Password">
		<cfset PasswordCheck = doLogin(strUsername=FORM.txtUsername, strPassword=FORM.txtOldPassword) />
		<cfset request.siteUserBean = GetBean("beans.siteuserbean") />
		<cfif PasswordCheck.isLoggedIn>
			<cfinvoke component="#variables.objSecurityGateway#" method="ChangeUserPassword" returnvariable="request.intSiteUserID">
				<cfinvokeargument name="intSiteUserID" value="#session.passport.CurrentSiteUser.getSiteUserID()#" />
				<cfinvokeargument name="strUsername" value="#session.passport.CurrentSiteUser.getUsername()#" />
				<cfinvokeargument name="strPassword" value="#FORM.txtNewPassword#" />
			</cfinvoke>
			<cfset Session.Passport.PasswordExpired = false>
			<cfset request.content = includeTemplate("views/security/loginchangepwdsuccess.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		<cfelse>
			<cfset request.content = includeTemplate("views/security/loginchangepwd.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		</cfif>
	</cfcase>
    
	<cfcase value="logout:process">
		<cfif structkeyexists(Session,"empid") and len(trim(Session.empid)) and structKeyExists(Session, "useruniqueid") and len(Session.useruniqueid)>			
			<cfif structKeyExists(url, "event") and url.event neq "addload" and url.event neq "nextStopLoad" and structkeyexists(session,"currentloadid") and len(trim(session.currentloadid))>
				<cfinvoke component="#variables.objloadGateway#" method="getUserEditingDetails" loadid="#session.currentloadid#" returnvariable="request.qryUserId"/>
				<cfif request.qryUserId.recordcount and request.qryUserId.inuseby eq  session.empid >
					<cfinvoke component="#variables.objloadGateway#" method="updateEditingUserId" loadid="" userid="#session.empid#" status="true"/>
				</cfif>	
			</cfif>
			<cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
				select cutomerId,currenttime 
				from userCountCheck
				where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
				AND useruniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.useruniqueid#">	
			</cfquery>	
			
			<cfif qGetUserLoggedInCount.recordcount>
				<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#" result="a">
					delete from userCountCheck
					where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">
					AND useruniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.useruniqueid#">						
				</cfquery>
			</cfif>
			<!---Query to delete UserBrowserTabDetails with corresponding employeeid--->
			<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#" result="a">
				delete from UserBrowserTabDetails
				where 	userid=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.empid#">			
			</cfquery>
			<cfset listPos = ListFindNoCase(Application.userLoggedInCount, Session.empid)>
			<cfif listPos>
				<cfset Application.userLoggedInCount = ListDeleteAt(Application.userLoggedInCount, listPos)>
				<!--- <cfquery name="update" datasource="#Application.dsn#">
					UPDATE SystemConfig
					set
					userCount =  <cfqueryparam cfsqltype="cf_sql_integer" value="#ListLen(Application.userLoggedInCount)#" />
				</cfquery> --->
				<cfset structDelete(cookie, "userLogginID") />
			</cfif>				
		</cfif>
		<!--- set your session var like normal --->
		<cfif structkeyexists(Session,"customerid") and len(trim(Session.customerid))>		
			<cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
				select cutomerId,currenttime 
				from userCountCheck
				where cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">
			</cfquery>			
			<cfif qGetUserLoggedInCount.recordcount>
				<cfquery name="qUpdateIsLoggin" datasource="#Application.dsn#">
					delete from userCountCheck
					where 	cutomerId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.customerid#">						
				</cfquery>
			</cfif>
			<cfset listPos = ListFindNoCase(Application.userLoggedInCount, Session.customerid)>
			
			<cfif listPos>
				<cfset Application.userLoggedInCount = ListDeleteAt(Application.userLoggedInCount, listPos)>
				<!--- <cfquery name="update" datasource="#Application.dsn#">
					UPDATE SystemConfig
					set
					userCount =  <cfqueryparam cfsqltype="cf_sql_integer" value="#ListLen(Application.userLoggedInCount)#" />
				</cfquery> --->
				<cfset structDelete(cookie, "userLogginID") />
			</cfif>
		</cfif>	
		
		
		<cfset logoutvar = logoutuser()>
		<cfset structDelete(session, "passport") />
		<cfset session.searchtext="" />
		<cfif StructKeyExists(session,"CustomerID") AND session.CustomerID NEQ "">
			<cfset structDelete(session, "CustomerID") />
			<cflocation url="index.cfm?event=customerlogin&AlertMessageID=3" addtoken="yes" />
		<cfelse>
			<cflocation url="index.cfm?event=login&AlertMessageID=3" addtoken="yes" />
		</cfif>
	</cfcase>
	<cfcase value="DashboardDefault">
		<cfset request.tabs = includeTemplate("views/general/tabs.cfm", true) />
		<!--- <cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) /> --->
		<cfset request.content = includeTemplate("views/pages/load/disp_load.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<!--- Site Users --->
	<cfcase value="SecurityMainPage">
		<cfset request.lstTabs = "">
		<cfif CheckObjectAccess('subNavSiteUserManagement')>
			<cfset request.lstTabs = ListAppend(request.lstTabs, "Site Users,index.cfm?event=SecurityMaintenance&#Session.URLToken#") />
		</cfif>
		<cfif checkObjectAccess('lnkGroupAccess')>
			<cfset request.lstTabs = ListAppend(request.lstTabs, "|Groups,index.cfm?event=GroupMaintenance&#Session.URLToken#") />
		</cfif>
		<cfset request.tabs = includeTemplate("views/general/tabs.cfm", true) />
		<cfset request.subnavigation = includeTemplate("views/admin/adminsubnav.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<cfcase value="SecurityMaintenance">
		<cfset request.structGroups = getGroupList() />
		<cfset request.SubHeading = "Search Site Users">
		<cfset request.initialFunctions = includeTemplate("views/admin/security/siteusers/initialfunctions.cfm", true) />
		<cfset request.content = includeTemplate("views/admin/security/securitymaintenance.cfm", true) />
		<cfif IsDefined("URL.blnIFrame") And URL.blnIFrame>
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		<cfelse>
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		</cfif>
	</cfcase>
	<cfcase value="ajax_GetSearchSiteUserForm">
		<cfsetting showdebugoutput="no" />	
		<cfset includeTemplate("views/admin/security/siteusers/searchsiteuserform.cfm") />
	</cfcase>
	<cfcase value="ajax_GetSiteUserList">
		<cfsetting showdebugoutput="no" />
		<cfset request.structSiteUsers = getSiteUserList() />
		
		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structSiteUsers.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="FirstName|sFirstName|left,Last Name|sLastName|left,Mobile Number|sMobileNumber|left,EmailAddress|sEmailAddress|left,Enabled?|bEnabled|center,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset includeTemplate("views/admin/security/siteusers/listsiteusers.cfm") />
	</cfcase>
	<cfcase value="ajax_ViewSiteUser">
		<cfsetting showdebugoutput="no" />
		<cfset request.SubHeading = "View Site User">
		<cfset request.siteUserBean = fetchCurrentSiteUser(intSiteUserID=URL.intSiteUserID) />
		<cfset request.content = includeTemplate("views/admin/security/siteusers/viewsiteuser.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	<cfcase value="ajax_GetAddEditSiteUserForm">
		<cfsetting showdebugoutput="no" />
		
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.siteUserBean = fetchCurrentSiteUser(intSiteUserID=URL.intSiteUserID) />	
		<cfelse>
			<cfset request.siteUserBean = CreateObject('component', 'beans.siteuserbean') />
			<cfset request.siteUserBean.setCreatedSiteUser(CreateObject('component', 'beans.siteuserbean')) />
			<cfset request.siteUserBean.setUpdatedSiteUser(CreateObject('component', 'beans.siteuserbean')) />
			<cfset request.siteUserBean.setDeletedSiteUser(CreateObject('component', 'beans.siteuserbean')) />
		</cfif>
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.SubHeading = "Edit Site User" />
		<cfelse>	
			<cfset request.SubHeading = "Add  Site User" />
		</cfif>
		<cfset request.content = includeTemplate("views/admin/security/siteusers/addeditsiteuser.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	<cfcase value="ajax_SaveSiteUser">
		<cfset request.siteUserBean = GetBean("beans.siteuserbean") />
		<cfsetting showdebugoutput="no" />
		<cfif FORM.hdnSiteUserID GT 0>
			<cfinvoke component="#variables.objSecurityGateway#" method="updateSiteUser" returnvariable="request.intSiteUserID">
				<cfinvokeargument name="intSiteUserID" value="#request.siteUserBean.getSiteUserID()#" />
				<cfinvokeargument name="strFirstName" value="#request.siteUserBean.getFirstName()#" />
				<cfinvokeargument name="strLastName" value="#request.siteUserBean.getLastName()#" />
				<cfinvokeargument name="strUsername" value="#request.siteUserBean.getUsername()#" />
				<cfinvokeargument name="strEmailAddress" value="#request.siteUserBean.getEmailAddress()#" />
				<cfinvokeargument name="strMobileNumber" value="#request.siteUserBean.getMobileNumber()#" />
				<cfinvokeargument name="blnEnabled" value="#request.siteUserBean.getEnabled()#" />
				<cfif LEN(request.siteUserBean.getPassword()) GT 0>
					<cfinvokeargument name="strPassword" value="#request.siteUserBean.getPassword()#" />
				</cfif>
				<cfinvokeargument name="intUpdatedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
			</cfinvoke>
		<cfelse>
		<!---<cfset request.structUserExists= getSiteUserList(#FORM.txtFirstName#) />
		<cfdump var="#request.structUserExists#"><cfabort>--->
			<cfinvoke component="#variables.objSecurityGateway#" method="addSiteUser" returnvariable="request.intSiteUserID">
				<cfinvokeargument name="strFirstName" value="#request.siteUserBean.getFirstName()#" />
				<cfinvokeargument name="strLastName" value="#request.siteUserBean.getLastName()#" />
				<cfinvokeargument name="strUsername" value="#request.siteUserBean.getUsername()#" />
				<cfinvokeargument name="strEmailAddress" value="#request.siteUserBean.getEmailAddress()#" />
				<cfinvokeargument name="strMobileNumber" value="#request.siteUserBean.getMobileNumber()#" />
				<cfinvokeargument name="blnEnabled" value="#request.siteUserBean.getEnabled()#" />
				<cfinvokeargument name="strPassword" value="#request.siteUserBean.getPassword()#" />
				<cfinvokeargument name="intCreatedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
			</cfinvoke>
		</cfif>

		<cfif IsDefined("FORM.chkResetOnNextLogin") And FORM.chkResetOnNextLogin>
			<cfinvoke component="#variables.objSecurityGateway#" method="expirePassword">
				<cfinvokeargument name="intSiteUserID" value="#request.intSiteUserID#" />
			</cfinvoke>
		</cfif>
		
		<cfif IsDefined("URL.strCriteria")>
			<cfset strExtraParams = "strCriteria=#URL.strCriteria#" />
		<cfelse>
			<cfset strExtraParams = "" />
		</cfif>
		<!---<cflocation url="index.cfm?event=ajax_GetSiteUserList&#strExtraParams#" addtoken="yes" />--->
	</cfcase>
	<cfcase value="ajax_DeleteSiteUser">
		<cfsetting showdebugoutput="no" />
		<cfinvoke component="#variables.objSecurityGateway#" method="deleteSiteUser">
			<cfinvokeargument name="intSiteUserID" value="#URL.intSiteUserID#" />
			<cfinvokeargument name="intDeletedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
		</cfinvoke>
		<cfif IsDefined("URL.strCriteria")>
			<cfset strExtraParams = "strCriteria=#URL.strCriteria#" />
		<cfelse>
			<cfset strExtraParams = "" />
		</cfif>
		<cflocation url="index.cfm?event=ajax_GetSiteUserList&#strExtraParams#" addtoken="yes" />
	</cfcase>
	
	<cfcase value="popup_SearchSiteUsers">
		<cfset request.content = includeTemplate("views/admin/security/siteusers/searchsiteuserform.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	

	<cfcase value="popup_SearchSiteUsers:Results">
		<cfset request.structSiteUsers = getSiteUserList() />

		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('URL.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#URL.intPageNumber#">
				<cfelseif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structSiteUsers.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="First Name|sFirstName|left,Last Name|sLastName|left,Mobile Number|sMobileNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset request.content = includeTemplate("views/admin/security/siteusers/listsiteusers.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	
	
	<!--- GROUPS --->
	<cfcase value="GroupMaintenance">
		<cfset request.SubHeading = "Search User Groups">
		<cfset request.initialFunctions = includeTemplate("views/admin/security/groups/initialfunctions.cfm", true) />
		<cfset request.content = includeTemplate("views/admin/security/securitymaintenance.cfm", true) />
		<!---<cfset request.content = includeTemplate("views/admin/security/groups/searchgroupform.cfm", true) />--->
		<cfif IsDefined("URL.blnIFrame") And URL.blnIFrame>
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		<cfelse>
			<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		</cfif>
	</cfcase>
	
	<cfcase value="ajax_GetSearchGroupForm">
		<cfsetting showdebugoutput="no" />	
		<cfset includeTemplate("views/admin/security/groups/searchgroupform.cfm") />
	</cfcase>	

	<cfcase value="ajax_GetGroupSelecter">
		<cfsetting showdebugoutput="no" />
		<cfparam name="URL.intParentGroupID" type="integer" default="-1" />
		<cfset request.structGroups = variables.objSecurityGateway.enumGroups(blnAllRecords=True,intParentGroupID=URL.intParentGroupID) />
		<cfset includeTemplate("views/admin/groups/groupselecter.cfm") />
	</cfcase>

	<cfcase value="ajax_GetGroupList">
		<cfsetting showdebugoutput="no" />
		<cfset request.SubHeading = "List Groups">
		<cfset request.structGroups = getGroupList() />

		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structGroups.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="Group|sGroup|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset includeTemplate("views/admin/security/groups/listgroups.cfm") />			
	</cfcase>
	
	<cfcase value="ajax_GetAddEditGroupForm">
		<cfsetting showdebugoutput="no" />
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.groupBean = fetchGroupAsBean(intGroupID=URL.intGroupID) />	
		<cfelse>
			<cfset request.groupBean = CreateObject('component', 'beans.groupbean') />
		</cfif>
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.SubHeading = "Edit Group" />
		<cfelse>	
			<cfset request.SubHeading = "Add Group" />
		</cfif>
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfset includeTemplate("views/admin/security/groups/addeditgroup.cfm") />
	</cfcase>

	<cfcase value="ajax_SaveGroup">
		<!--- Prepare Group Bean --->
		<cfset request.groupBean = GetBean("beans.groupbean") />
		<!--- Determine Add or Edit --->
		<cfif FORM.hdnGroupID GT 0>
			<cfset strMethod = "updateGroup" />
			<cfset strSiteUserArgumentName = "intUpdatedSiteUserID" />
		<cfelse>
			<cfset strMethod = "addGroup" />
			<cfset strSiteUserArgumentName = "intCreatedSiteUserID" />
		</cfif>
		<!--- Invoke Add / Update Function --->
		<cfinvoke component="#variables.objSecurityGateway#" method="#strMethod#">
			<cfif FORM.hdnGroupID GT 0>
				<cfinvokeargument name="intGroupID" value="#FORM.hdnGroupID#" />
			</cfif>
			<cfinvokeargument name="strGroup" value="#FORM.txtGroup#" />
			<cfinvokeargument name="blnAllowEdit" value="#FORM.cboAllowEdit#" />
			<cfinvokeargument name="blnAllowDelete" value="#FORM.cboAllowDelete#" />
			<cfinvokeargument name="#strSiteUserArgumentName#" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
		</cfinvoke>
		
		<!--- Get the list of Groups --->
		<!---<cflocation url="index.cfm?event=ajax_GetGroupList" addtoken="yes" />--->
	</cfcase>
	
	<cfcase value="ajax_ViewGroup">
		<cfsetting showdebugoutput="no" />
		<cfset request.groupBean = fetchGroupAsBean(intGroupID=URL.intGroupID) />	
		<cfset request.SubHeading = "View Group" />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
		<cfset includeTemplate("views/admin/security/groups/viewgroup.cfm") />
	</cfcase>

	<cfcase value="ajax_DeleteGroup">
		<cfsetting showdebugoutput="no" />
		<cfinvoke component="#variables.objSecurityGateway#" method="deleteGroup">
			<cfinvokeargument name="intGroupID" value="#URL.intGroupID#" />
			<cfinvokeargument name="intDeletedSiteUserID" value="#Session.passport.currentSiteUser.getSiteUserID()#" />
		</cfinvoke>
		<!--- Get the list of Groups --->
		<cflocation url="index.cfm?event=ajax_GetGroupList" addtoken="yes" />
	</cfcase>

	<cfcase value="popup_SearchGroups">
		<cfset request.content = includeTemplate("views/admin/groups/searchgroupform.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	

	<cfcase value="popup_SearchGroups:Results">
		<cfset request.structGroups = getGroupList() />

		<cfif Not (isdefined('URL.blnAllRecords') And URL.blnAllRecords)>
			<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
				<cfif isdefined('FORM.intPageNumber')>
					<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
				</cfif>
				<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
				<cfinvokeargument name="intTotalRecords" value="#request.structGroups.rstEnumTotalCount.iCount#">
				<cfinvokeargument name="strEvent" value="#request.event#">
			</cfinvoke>
		</cfif>
		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="&nbsp;,Group|sGroup|left,Code|sGroupCode|left,Telephone Number|sTelephoneNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset request.content = includeTemplate("views/admin/groups/listgroups.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_AddSiteUserToGroup">
		<cfsetting showdebugoutput="no">
		<!---<cfset request.SubHeading = "Add Site User to Group">--->
		<cfinvoke component="#variables.objSecurityGateway#" method="AddSiteUserToGroup">
				<cfinvokeargument name="SiteUserID" value="#URL.intSiteUserID#" />
				<cfinvokeargument name="intGroupID" value="#URL.intGroupID#"/>
		</cfinvoke>
		<cfinvoke component="#variables.objSecurityGateway#" method="GetGroupSiteUsers" returnvariable="request.structReturn">
			<cfinvokeargument name="GroupID" value="#URL.intGroupID#">
			<cfif IsDefined("FORM.strOrderBy")>
				<cfinvokeargument name="strOrderBy" value="#FORM.strOrderBy#" />
			</cfif>
			<cfif IsDefined("URL.blnAllRecords")>				
				<cfinvokeargument name="blnAllRecords" value="#URL.blnAllRecords#" />
			</cfif>
			<cfif IsDefined("FORM.intPageNumber")>
				<cfinvokeargument name="intPageNumber" value="#FORM.intPageNumber#" />
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#" />
		</cfinvoke>
		<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
			<cfif isdefined('FORM.intPageNumber')>
				<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
			<cfinvokeargument name="intTotalRecords" value="#request.structReturn.rstGetGroupSiteUsersTotalCount.iCount#">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="strExtraURLParams" value="">
		</cfinvoke>

		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="FirstName|sFirstName|left,LastName|sLastName|left,Mobile Number|sMobileNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		
		<cfset request.content = includeTemplate("views/admin/security/groups/listgroupSiteUsers.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_GetGroupSiteUsers">
		<cfsetting showdebugoutput="no">
		<cfset request.SubHeading = "List Group SiteUsers">
		<cfinvoke component="#variables.objSecurityGateway#" method="GetGroupSiteUsers" returnvariable="request.structReturn">
			<cfinvokeargument name="GroupID" value="#URL.intGroupID#">
			<cfif IsDefined("FORM.strOrderBy")>
				<cfinvokeargument name="strOrderBy" value="#FORM.strOrderBy#" />
			</cfif>
			<cfif IsDefined("URL.blnAllRecords")>				
				<cfinvokeargument name="blnAllRecords" value="#URL.blnAllRecords#" />
			</cfif>
			<cfif IsDefined("FORM.intPageNumber")>
				<cfinvokeargument name="intPageNumber" value="#FORM.intPageNumber#" />
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#" />
		</cfinvoke>
		
		<cfinvoke method="getRecordPages" returnvariable="request.structPageNumbers">
			<cfif isdefined('FORM.intPageNumber')>
				<cfinvokeargument name="intCurrentPageNumber" value="#FORM.intPageNumber#">
			</cfif>
			<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#">
			<cfinvokeargument name="intTotalRecords" value="#request.structReturn.rstGetGroupSiteUsersTotalCount.iCount#">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="strExtraURLParams" value="">
		</cfinvoke>

		<cfinvoke method="getListPageTableHeaders" returnvariable="request.structTableHeader">
			<cfinvokeargument name="lstHeaderNames" value="FirstName|sFirstName|left,LastName|sLastName|left,Mobile Number|sMobileNumber|left,Email Address|sEmailAddress|left,&nbsp;,&nbsp;,&nbsp;,&nbsp;">
			<cfinvokeargument name="strEvent" value="#request.event#">
			<cfinvokeargument name="FilterVariableName" value="strOrderBy">
		</cfinvoke>
		<cfset request.content = includeTemplate("views/admin/security/groups/listgroupSiteUsers.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_SearchPrivileges">
		<cfsetting showdebugoutput="no">
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.rstCurrentPrivileges = fetchGroupPrivilegeList(intGroupID=URL.intGroupID)>
		</cfif>
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.rstCurrentPrivileges = fetchSiteUserPrivilegeList(intSiteUserID=URL.intSiteUserID)>
		</cfif>
		<cfset request.SubHeading = "Add Privileges to Group">
		<cfset rstPrivilegeSearchResults = fetchAllPrivilegeList()>
		<cfset request.content = includeTemplate("views/admin/security/privileges/listPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_AddSiteUserPrivileges">
		<cfsetting showdebugoutput="no">
		<cfif IsDefined("URL.intGroupID")>
			<cfset request.rstCurrentPrivileges = fetchGroupPrivilegeList(intGroupID=URL.intGroupID)>
		</cfif>
		<cfif IsDefined("URL.intSiteUserID")>
			<cfset request.rstCurrentPrivileges = fetchSiteUserPrivilegeList(intSiteUserID=URL.intSiteUserID)>
		</cfif>
		<cfset request.SubHeading = "Add Privileges to Site User">
		<cfset rstPrivilegeSearchResults = fetchAllPrivilegeList()>
		<cfset request.content = includeTemplate("views/admin/security/privileges/listPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_ListGroupPrivileges">
		<cfsetting showdebugoutput="no">
		<cfset request.SubHeading = "Privileges for Group">
		<cfset rstGroupPrivileges= fetchGroupPrivilegeList(intGroupID=#URL.intGroupID#)>
		<cfset request.content = includeTemplate("views/admin/security/groups/listGroupPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>	
	
	<cfcase value="SavePrivilegesToGroup">
		<!---<cfsetting showdebugoutput="no">--->
		<cftransaction action="begin">
			<cfinvoke component="#variables.objSecurityGateway#" method="AddPrivilegeToGroup">
				<cfinvokeargument name="GroupID" value="#URL.GroupID#">
				<cfinvokeargument name="lstPrivilegeIDs" value="#Form.PrivilegeID#">
			</cfinvoke>
			<cftransaction action="commit" />
		</cftransaction>
	</cfcase>
	
	<cfcase value="SavePrivilegesToSiteUser">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="AddPrivilegeToSiteUser">
			<cfinvokeargument name="SiteUserID" value="#URL.SiteUserID#">
			<cfinvokeargument name="lstPrivilegeIDs" value="#Form.PrivilegeID#">
		</cfinvoke>
	</cfcase>
	
	<cfcase value="ajax_ListSiteUserPrivileges">
		<cfsetting showdebugoutput="no">
		<cfset request.SubHeading = "Privileges for SiteUser">
		<cfset rstSiteUserPrivileges= fetchSiteUserPrivilegeList(intSiteUserID=#URL.intSiteUserID#)>
		<cfset request.content = includeTemplate("views/admin/security/SiteUsers/listSiteUserPrivileges.cfm", true) />
		<cfset includeTemplate("views/templates/iframetemplate.cfm") />
	</cfcase>
	
	<cfcase value="ajax_DeleteSiteUserFromGroup">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="removeSiteUserFromGroup">
			<cfinvokeargument name="GroupID" value="#url.intGroupID#">
			<cfinvokeargument name="SiteUserID" value="#url.intSiteUserID#">
		</cfinvoke>
	</cfcase>
	
	<cfcase value="ajax_RemovePrivilegeFromGroup">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="RemovePrivilegeFromGroup">
			<cfinvokeargument name="GroupID" value="#url.intGroupID#">
			<cfinvokeargument name="PrivilegeID" value="#url.intPrivilegeID#">
		</cfinvoke>
	</cfcase>
	
	<cfcase value="ajax_RemovePrivilegeFromSiteUser">
		<cfsetting showdebugoutput="no">
		<cfinvoke component="#variables.objSecurityGateway#" method="RemovePrivilegeFromSiteUser">
			<cfinvokeargument name="SiteUserID" value="#url.intSiteUserID#">
			<cfinvokeargument name="PrivilegeID" value="#url.intPrivilegeID#">
		</cfinvoke>
	</cfcase>
    
	<cfcase value="systemsetup">
		<cfif StructKeyExists(session,"adminusername")>
			<cfset request.subnavigation = includeTemplate("views/admin/sysSetupSubnav.cfm", true) />
			<cfset request.content = includeTemplate("webroot/systemSetup.cfm", true) />
			<cfset includeTemplate("views/templates/maintemplate.cfm") />
		</cfif>
	</cfcase>
	
	<cfcase value="companyinfo">
    	<cfset request.subnavigation = includeTemplate("views/admin/sysSetupSubnav.cfm", true) />
    	<cfset request.content = includeTemplate("webroot/companyinfo.cfm", true) />
        <cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
    <cfcase value="reports">
    	<cfset request.subnavigation = includeTemplate("views/admin/reportsSubNav.cfm", true) />
    	<cfset request.content = includeTemplate("webroot/Reports.cfm", true) />
        <cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
    
    <!---<cfcase value="quickRateAndMilesCalc">
    	<cfset request.subnavigation = includeTemplate("webroot/sysSetupSubnav.cfm", true) />
    	<cfset request.content = includeTemplate("webroot/quickRateAndMilesCalc.cfm", true) />
        <cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>--->
    
	<!--- EXAMPLE EVENT
	<cfcase value="login">
		<cfset request.content = includeTemplate("views/securitylogin.cfm", true) />
		<cfset includeTemplate("views/templates/maintemplate.cfm") />
	</cfcase>
	<cfcase value="loginAction">
		<cfif Not StructKeyExists(Form, "txtUsername")>
			<cfthrow errorcode="1001" message="Username Missing" detail"The Username has not been specified on the previous page" />
		</cfif>
		<cfif Not StructKeyExists(Form, "txtPassword")>
			<cfthrow errorcode="1001" message="Password Missing" detail"The Password has not been specified on the previous page" />
		</cfif>
		<cfset request.rstLogin = variables.objSecurity.checkLogin(username=FORM.txtUsername, password=FORM.txtPassword) />
		<cfif request.rstLogin.RecordCount GT 0>
			<cflocation url="index.cfm?event=homepage" addtoken="yes" />
		<cfelse>
			<cflocation url="index.cfm?event=login&message=1" />
		</cfif>
	</cfcase>
	--->
</cfswitch>
