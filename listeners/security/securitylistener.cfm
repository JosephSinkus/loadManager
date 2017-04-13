<!---
THIS TEMPLATE IS DEPENDANT ON THE EXISTANCE OF variables.objSecurityGateway
--->

<!--- Function used to return the session passport after login. --->
<cffunction name="doLogin" access="public" output="false" returntype="struct">
	<cfargument name="strUsername" required="yes" type="string" />
	<cfargument name="strPassword" required="yes" type="string" />
	
	<cfscript>
		//Select the data from the database
		var rstCurrentSiteUser = variables.objSecurityGateway.checkLogin(strUsername=arguments.strUsername, strPassword=arguments.strPassword);
		var structReturn = StructNew();
		var siteUserBean = GetBean("beans.siteuserbean");

		var trackUserLoginLog = variables.objSecurityGateway.UserLoginLog(strUsername=arguments.strUsername, strPassword=arguments.strPassword, rstCurrentSiteUser = rstCurrentSiteUser);
		structReturn.IsLoggedIn = False; // Default Guilty until proven innocent
			//Check if the user exists with those credentials
		
			if (rstCurrentSiteUser.RecordCount) {
				siteUserBean = fetchCurrentSiteUser(intSiteUserID=rstCurrentSiteUser.pkiadminUserID);

				// NOW... Is the user enabled? --->

				if (siteUserBean.getEnabled()) {
					structReturn.IsLoggedIn = True;
					structReturn.CurrentSiteUser = siteUserBean;
					// Check if the user's password has expired.
					structReturn.PasswordAlmostExpired = False;
					if ((siteUserBean.getPasswordExpiry() LT DateAdd('d', 14, Now())) And Not siteUserBean.getPasswordPermanent())
						structReturn.PasswordAlmostExpired = True;
					
					structReturn.PasswordExpired = False;
					if ((siteUserBean.getPasswordExpired() Or siteUserBean.getPasswordExpiry() LT Now()) And Not siteUserBean.getPasswordPermanent())
						structReturn.PasswordExpired = True;
				}
				else {
					structReturn.LoginError = "User is not enabled!";
				}
					
			}
			else {				
				structReturn.LoginError = "Invalid username or password!";
				
			}
			
		return structReturn;
	</cfscript>	
</cffunction>

<cffunction name="CustomerdoLogin" access="public" output="false" returntype="struct">
	<cfargument name="strUsername" required="yes" type="string" />
	<cfargument name="strPassword" required="yes" type="string" />
	
	<cfscript>
		//Select the data from the database

		var rstCurrentSiteUser = variables.objSecurityGateway.checkCustomerLogin(strUsername=arguments.strUsername, strPassword=arguments.strPassword);
		var structReturn = StructNew();
		var siteUserBean = GetBean("beans.siteuserbean");
		var trackUserLoginLog = variables.objSecurityGateway.UserLoginLog(strUsername=arguments.strUsername, strPassword=arguments.strPassword, rstCurrentSiteUser = rstCurrentSiteUser);
		structReturn.IsLoggedIn = False; // Default Guilty until proven innocent
		
		//Check if the user exists with those credentials
		if (rstCurrentSiteUser.RecordCount) {
			siteUserBean = fetchCurrentSiteUser(intSiteUserID=rstCurrentSiteUser.pkiadminUserID);

			// NOW... Is the user enabled? --->
			if (siteUserBean.getEnabled()) {
				structReturn.IsLoggedIn = True;
				structReturn.CurrentSiteUser = siteUserBean;
				// Check if the user's password has expired.
				structReturn.PasswordAlmostExpired = False;
				if ((siteUserBean.getPasswordExpiry() LT DateAdd('d', 14, Now())) And Not siteUserBean.getPasswordPermanent())
					structReturn.PasswordAlmostExpired = True;
				
				structReturn.PasswordExpired = False;
				if ((siteUserBean.getPasswordExpired() Or siteUserBean.getPasswordExpiry() LT Now()) And Not siteUserBean.getPasswordPermanent())
					structReturn.PasswordExpired = True;
			}
			else {
				structReturn.LoginError = "User is not enabled!";
			}
		}
		else {
			structReturn.LoginError = "Invalid username or password!";
		}
		
		return structReturn;
	</cfscript>	
</cffunction>

		<!---LOGOUT FUNCTION ADDED BY FURQAN --->

	<cffunction name="logoutuser" access="public" output="false">
	
	<cfscript>
		//Select the data from the database
		logoutuser = variables.objSecurityGateway.logoutuser();
	</cfscript>	
</cffunction>
       
       <!---LOGOUT CODE ENDED--->
<cffunction name="GenerateRandomPassword" access="public" output="no" returntype="string">

	<cfset var intNumberOfNumbers = 2 />
	<cfset var intNumberOfCapitals = 0 />
	<cfset var intNumberOfCharacters = 0 />
	<cfset var intFinalPasswordLength = 6 />

	<cfset var strPassword = "" />
	<cfset var intNumberCount = 0 />
	<cfset var intCapitalLetterCount = 0 />
	<cfset var intCharacterCount = 0 />
	<cfset var strNumberList = "0123456789" />
	<cfset var strCapitalList = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" />
	<cfset var strCharacterList = "!@##$_" />
	<cfset var strNormalList = "abcdefghijklmnopqrstuvwxyz" />
	
	<cfloop from="1" to="#intFinalPasswordLength#" index="i">
		<cfif (intFinalPasswordLength - Len(strPassword)) LTE (intNumberOfNumbers - intNumberCount)>
			<cfset intCharacterPos = RandRange(1, Len(strNumberList)) />
			<cfset strCharacterToAdd = Mid(strNumberList, intCharacterPos, 1) />
			<cfset intNumberCount = intNumberCount + 1 />
		<cfelseif (intFinalPasswordLength - Len(strPassword)) LTE (intNumberOfCapitals - intCapitalLetterCount)>
			<cfset intCharacterPos = RandRange(1, Len(strCapitalList)) />
			<cfset strCharacterToAdd = Mid(strCapitalList, intCharacterPos, 1) />
			<cfset intCapitalLetterCount = intCapitalLetterCount + 1 />
		<cfelseif (intFinalPasswordLength - Len(strPassword)) LTE (intNumberOfCharacters - intCharacterCount)>
			<cfset intCharacterPos = RandRange(1, Len(strCharacterList)) />
			<cfset strCharacterToAdd = Mid(strCharacterList, intCharacterPos, 1) />
			<cfset intCharacterCount = intCharacterCount + 1 />
		<cfelse>
			<cfset blnCharacterSuccessful = False />
			<cfloop condition="Not blnCharacterSuccessful">
				<cfswitch expression="#RandRange(1,4)#">
					<cfcase value="1">
						<cfif intNumberCount LT intNumberOfNumbers>
							<cfset intCharacterPos = RandRange(1, Len(strNumberList)) />
							<cfset strCharacterToAdd = Mid(strNumberList, intCharacterPos, 1) />
							<cfset blnCharacterSuccessful = True />
							<cfset intNumberCount = intNumberCount + 1 />
						</cfif>
					</cfcase>
					<cfcase value="2">
						<cfif intCapitalLetterCount LT intNumberOfCapitals>
							<cfset intCharacterPos = RandRange(1, Len(strCapitalList)) />
							<cfset strCharacterToAdd = Mid(strCapitalList, intCharacterPos, 1) />
							<cfset blnCharacterSuccessful = True />
							<cfset intCapitalLetterCount = intCapitalLetterCount + 1 />
						</cfif>
					</cfcase>
					<cfcase value="3">
						<cfif intCharacterCount LT intNumberOfCharacters>
							<cfset intCharacterPos = RandRange(1, Len(strCharacterList)) />
							<cfset strCharacterToAdd = Mid(strCharacterList, intCharacterPos, 1) />
							<cfset blnCharacterSuccessful = True />
							<cfset intCharacterCount = intCharacterCount + 1 />
						</cfif>
					</cfcase>
					<cfcase value="4">
						<cfset intCharacterPos = RandRange(1, Len(strNormalList)) />
						<cfset strCharacterToAdd = Mid(strNormalList, intCharacterPos, 1) />
						<cfset blnCharacterSuccessful = True />
					</cfcase>
				</cfswitch>
			</cfloop>
		</cfif>
		<cfset strPassword = strPassword & strCharacterToAdd />
	</cfloop>
	
	<cfreturn strPassword />
</cffunction>

<cffunction name="fetchCurrentSiteUser" access="public" output="false" returntype="any">
	<cfargument name="intSiteUserID" type="any" required="yes" />
	
	<cfscript>
		//Select the data from the database
		var rstCurrentSiteUser = variables.objSecurityGateway.getSiteUser(intSiteUserID=arguments.intSiteUserID);
		var siteUserBean = GetBean("beans.siteuserbean");
		var createdSiteUserBean = GetBean("beans.siteuserbean");
		var updatedSiteUserBean = GetBean("beans.siteuserbean");
		var deletedSiteUserBean = GetBean("beans.siteuserbean");
		var rstGroups = "";
		var rstSiteUser = "";

		//Check if the user exists with those credentials
		if (rstCurrentSiteUser.RecordCount GT 0) {
			//User Found, Populate the Site User Bean --->
			siteUserBean.init(rstSiteUser=rstCurrentSiteUser);
			
			// Get the Groups this site user is part of.
			

			//If the Created Site UserID exists, then populate that too --->
			if (Len(rstCurrentSiteUser.pkiAdminUserID) GT 0 And IsNumeric(rstCurrentSiteUser.pkiAdminUserID)) {
				rstSiteUser = variables.objSecurityGateway.getSiteUser(intSiteUserID=rstCurrentSiteUser.pkiAdminUserID);
				if (rstSiteUser.RecordCount GT 0)
					createdSiteUserBean.init(rstSiteUser=rstSiteUser);
			}
		
			siteUserBean.setCreatedSiteUser(createdSiteUserBean);

			//If the Updated Site UserID exists, then populate that too --->
			if (Len(rstCurrentSiteUser.pkiAdminUserID) GT 0 And IsNumeric(rstCurrentSiteUser.pkiAdminUserID)) {
				rstSiteUser = variables.objSecurityGateway.getSiteUser(intSiteUserID=rstCurrentSiteUser.pkiAdminUserID);
				if (rstSiteUser.RecordCount GT 0)
					updatedSiteUserBean.init(rstSiteUser=rstSiteUser);
			}
		
			siteUserBean.setUpdatedSiteUser(updatedSiteUserBean);

			//If the Deleted Site UserID exists, then populate that too --->
			/*if (Len(rstCurrentSiteUser.fkiDeletedSiteUserID) GT 0 And IsNumeric(rstCurrentSiteUser.fkiDeletedSiteUserID)) {
				rstSiteUser = variables.objSecurityGateway.getSiteUser(intSiteUserID=rstCurrentSiteUser.fkiDeletedSiteUserID);
				if (rstSiteUser.RecordCount GT 0)
					deletedSiteUserBean.init(rstSiteUser=rstSiteUser);
			}

			siteUserBean.setDeletedSiteUser(deletedSiteUserBean);
			
			// Get the site user's privileges
			siteUserBean.setPrivileges(Privileges=fetchSiteUserPrivileges(siteUserBean.getSiteUserID()));*/
		
		}
		
		return siteUserBean;
	</cfscript>	
</cffunction>

<cffunction name="getSiteUserList" access="public" output="false" returntype="struct">
	<cfset var structReturn = ""/>
	<cfset var rstSiteUserGroups = Session.passport.CurrentSiteUser.getGroups() />
	<cfset var lstSiteUserGroups = ValueList(rstSiteUserGroups.pkiGroupID) />
	
	<cfinvoke component="#variables.objSecurityGateway#" method="enumSiteUsers" returnvariable="structReturn">
		<cfif IsDefined("FORM.txtCriteria")>
			<cfinvokeargument name="strSearchCriteria" value="#FORM.txtCriteria#" />
		</cfif>
		<cfif IsDefined("FORM.txtUsername")>
			<cfinvokeargument name="strAddUserSearchCriteria" value="#FORM.txtUsername#" />
		</cfif>
		<cfif ListFind(lstSiteUserGroups, 1) GT 0>
			<cfinvokeargument name="blnIncludeSuperUser" value="true" />
		</cfif>
		<cfif ListFind(lstSiteUserGroups, 1) GT 0 Or ListFind(lstSiteUserGroups, 2) GT 0>
			<cfinvokeargument name="blnIncludeAdministrator" value="true" />
		</cfif>
		<cfif IsDefined("FORM.strOrderBy")>
			<cfinvokeargument name="strOrderBy" value="#FORM.strOrderBy#" />
		<cfelseif IsDefined("URL.strOrderBy")>
			<cfinvokeargument name="strOrderBy" value="#URL.strOrderBy#" />
		</cfif>
		<cfif IsDefined("FORM.blnAllRecords")>
			<cfinvokeargument name="blnAllRecords" value="#FORM.blnAllRecords#" />
		<cfelseif IsDefined("URL.blnAllRecords")>				
			<cfinvokeargument name="blnAllRecords" value="#URL.blnAllRecords#" />
		</cfif>
		<cfif IsDefined("FORM.intPageNumber")>
			<cfinvokeargument name="intPageNumber" value="#FORM.intPageNumber#" />
		<cfelseif IsDefined("URL.intPageNumber")>
			<cfinvokeargument name="intPageNumber" value="#URL.intPageNumber#" />
		</cfif>
		<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#" />
	</cfinvoke>

	<cfreturn structReturn />
</cffunction>

<cffunction name="fetchSiteUserPrivileges" access="private" output="false" returntype="struct">
	<cfargument name="intSiteUserID" type="numeric" required="true" />
	<cfset var structReturn = StructNew() />
	<cfset var rstSiteUserPrivileges = variables.objSecurityGateway.getSiteUserPrivileges(intSiteUserID=arguments.intSiteUserID, blnIncludeGroup=True) />
	<cfset var lstPrivilegeIDs = ValueList(rstSiteUserPrivileges.fkiPrivilegeID, ",") />
	<cfset var lstAllowedEvents = variables.objPrivilegeXmlGateway.getEventsFromPrivilegeIDs(lstPrivilegeIDs) />
	<cfset var lstAllowedObjects = variables.objPrivilegeXmlGateway.getObjectsFromPrivilegeIDs(lstPrivilegeIDs) />
	
	<cfset structReturn.AllowedEvents = lstAllowedEvents />
	<cfset structReturn.AllowedObjects = lstAllowedObjects />
	
	<cfreturn structReturn />
</cffunction>

<cffunction name="fetchSiteUserPrivilegeList" access="private" output="false" returntype="query">
	<cfargument name="intSiteUserID" type="numeric" required="true" />
	<cfset var structReturn = StructNew() />
	<cfset var rstSiteUserPrivileges = variables.objSecurityGateway.getSiteUserPrivileges(intSiteUserID=arguments.intSiteUserID, blnIncludeGroup=false) />
	<cfset var lstPrivilegeIDs = ValueList(rstSiteUserPrivileges.fkiPrivilegeID, ",") />
	<cfset var rstPrivileges = variables.objPrivilegeXmlGateway.getPrivileges(lstPrivilegeIDs=lstPrivilegeIDs) />
	
	<cfreturn rstPrivileges />
</cffunction>

<cffunction name="fetchGroupPrivilegeList" access="private" output="false" returntype="query">
	<cfargument name="intGroupID" type="numeric" required="true" />
	<cfset var structReturn = StructNew() />
	<cfset var rstGroupPrivileges = variables.objSecurityGateway.getGroupPrivileges(intGroupID=arguments.intGroupID) />
	<cfset var lstPrivilegeIDs = ValueList(rstGroupPrivileges.fkiPrivilegeID, ",") />
	<cfset var rstPrivileges = variables.objPrivilegeXmlGateway.getPrivileges(lstPrivilegeIDs=lstPrivilegeIDs) />
	
	<cfreturn rstPrivileges />
</cffunction>

<cffunction name="fetchAllPrivilegeList" access="private" output="false" returntype="query">
	<!---<cfargument name="intGroupID" type="numeric" required="true" />--->
	<cfset var structReturn = StructNew() />
	<cfset var rstAllPrivileges = variables.objPrivilegeXmlGateway.getPrivileges() />
	<cfset var lstPrivilegeIDs = ValueList(rstAllPrivileges.iPrivilegeID, ",") />
	<cfset var rstPrivileges = variables.objPrivilegeXmlGateway.getPrivileges() />
	
	<cfreturn rstPrivileges />
</cffunction>

<cffunction name="CheckObjectAccess" access="private" output="false" returntype="boolean">
	<cfargument name="strObjectName" type="string" required="yes" />

	<cfset var blnReturn = False />
	<cfif IsDefined("session.passport.CurrentSiteUser")>
		<cfif ListFindNoCase(session.passport.CurrentSiteUser.getPrivileges().AllowedObjects, arguments.strObjectName, "|") GT 0>
			<cfset blnReturn = True />
		</cfif>
	</cfif>
	
	<cfreturn blnReturn />
</cffunction>

<!--- Function Owner: Clive Munro (2007-09-12) --->
<cffunction name="fetchGroupAsBean" access="public" output="false" returntype="any">
	<cfargument name="intGroupID" type="numeric" required="yes" />
	
	<cfscript>
		//Select the data from the database
		var rstGroup = variables.objSecurityGateway.getGroup(intGroupID=arguments.intGroupID);
		var groupBean = GetBean("beans.groupbean");
		var parentGroupBean = GetBean("beans.groupbean");
		var createdSiteUserBean = GetBean("beans.siteuserbean");
		var updatedSiteUserBean = GetBean("beans.siteuserbean");
		var deletedSiteUserBean = GetBean("beans.siteuserbean");
		var rstSiteUser = "";
		var rstParentGroup = "";

		//Check if the group exists with those credentials
		if (rstGroup.RecordCount GT 0) {
			//Group Found, Populate the Site User Bean --->
			groupBean.init(rstGroup=rstGroup);
			
			//If the Created Site UserID exists, then populate that too --->
			if (Len(rstGroup.fkiCreatedSiteUserID) GT 0 And IsNumeric(rstGroup.fkiCreatedSiteUserID)) {
				rstSiteUser = variables.objSecurityGateway.getSiteUser(intSiteUserID=rstGroup.fkiCreatedSiteUserID);
				if (rstSiteUser.RecordCount GT 0)
					createdSiteUserBean.init(rstSiteUser=rstSiteUser);
			}
		
			groupBean.setCreatedSiteUser(createdSiteUserBean);

			//If the Updated Site UserID exists, then populate that too --->
			if (Len(rstGroup.fkiUpdatedSiteUserID) GT 0 And IsNumeric(rstGroup.fkiUpdatedSiteUserID)) {
				rstSiteUser = variables.objSecurityGateway.getSiteUser(intSiteUserID=rstGroup.fkiUpdatedSiteUserID);
				if (rstSiteUser.RecordCount GT 0)
					updatedSiteUserBean.init(rstSiteUser=rstSiteUser);
			}
		
			groupBean.setUpdatedSiteUser(updatedSiteUserBean);

			//If the Deleted Site UserID exists, then populate that too --->
			if (Len(rstGroup.fkiDeletedSiteUserID) GT 0 And IsNumeric(rstGroup.fkiDeletedSiteUserID)) {
				rstSiteUser = variables.objSecurityGateway.getSiteUser(intSiteUserID=rstGroup.fkiDeletedSiteUserID);
				if (rstSiteUser.RecordCount GT 0)
					deletedSiteUserBean.init(rstSiteUser=rstSiteUser);
			}

			groupBean.setDeletedSiteUser(deletedSiteUserBean);
		
		}
		
		return groupBean;
	</cfscript>	
</cffunction>

<!--- Function Owner: Clive Munro (2007-09-12) --->
<cffunction name="getGroupList" access="public" output="false" returntype="struct">
	<cfset var structReturn = ""/>
	
	<cfinvoke component="#variables.objSecurityGateway#" method="enumGroups" returnvariable="structReturn">
		<cfif IsDefined("FORM.txtCriteria")>
			<cfinvokeargument name="strSearchCriteria" value="#FORM.txtCriteria#" />
		</cfif>
		<cfif IsDefined("FORM.strOrderBy")>
			<cfinvokeargument name="strOrderBy" value="#FORM.strOrderBy#" />
		<cfelseif IsDefined("URL.strOrderBy")>
			<cfinvokeargument name="strOrderBy" value="#URL.strOrderBy#" />
		</cfif>
		<cfif IsDefined("FORM.blnAllRecords")>				
			<cfinvokeargument name="blnAllRecords" value="#FORM.blnAllRecords#" />
		<cfelseif IsDefined("URL.blnAllRecords")>				
			<cfinvokeargument name="blnAllRecords" value="#URL.blnAllRecords#" />
		</cfif>
		<cfif IsDefined("FORM.intPageNumber")>
			<cfinvokeargument name="intPageNumber" value="#FORM.intPageNumber#" />
		<cfelseif IsDefined("URL.intPageNumber")>
			<cfinvokeargument name="intPageNumber" value="#URL.intPageNumber#" />
		</cfif>
		<cfinvokeargument name="intResultsPerPage" value="#Application.ResultsPerPage#" />
	</cfinvoke>

	<cfreturn structReturn />
</cffunction>