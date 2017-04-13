<cfcomponent>
	<cfscript>
		variables.SiteUserID = 0;
		variables.FirstName = "";
		variables.LastName = "";
		variables.UserName = "";
		variables.Password = "";
		variables.EmailAddress = "";
		variables.MobileNumber = "";
		variables.Enabled = false;
		variables.DateCreated = CreateDate(1900,1,1);
		variables.CreatedSiteUser = "";
		variables.DateUpdated = CreateDate(1900,1,1);
		variables.UpdatedSiteUser = "";
		variables.Deleted = false;
		variables.DateDeleted = CreateDate(1900,1,1);
		variables.DeletedSiteUser = "";
		variables.PasswordExpiry = DateAdd('m', 1, Now());
		variables.PasswordPermanent = false;
		variables.PasswordExpired = false;
		variables.Privileges = StructNew();
		variables.Privileges.AllowedEvents = "";
		variables.Privileges.AllowedObjects = "";
		variables.Groups = QueryNew("pkiGroupID, sGroup");
	</cfscript>
	
	<cffunction name="init" access="public" output="false" returntype="siteuserbean">
		<cfargument name="SiteUserID" type="numeric" required="false" default="0" />
		<cfargument name="FirstName" type="string" required="false" default="" />
		<cfargument name="LastName" type="string" required="false" default="" />
		<cfargument name="UserName" type="string" required="false" default="" />
		<cfargument name="Password" type="string" required="false" default="" />
		<cfargument name="EmailAddress" type="string" required="false" default="" />
		<cfargument name="MobileNumber" type="string" required="false" default="" />
		<cfargument name="Enabled" type="boolean" required="false" default="false" />
		<cfargument name="DateCreated" type="date" required="false" />
		<cfargument name="CreatedSiteUser" type="siteuserbean" required="false" />
		<cfargument name="DateUpdated" type="date" required="false" />
		<cfargument name="UpdatedSiteUser" type="siteuserbean" required="false" />
		<cfargument name="Deleted" type="boolean" required="false" default="false" />
		<cfargument name="DateDeleted" type="date" required="false" />
		<cfargument name="DeletedSiteUser" type="siteuserbean" required="false" />
		<cfargument name="PasswordExpiry" type="date" required="false" />
		<cfargument name="PasswordPermanent" type="boolean" required="false" default="false" />
		<cfargument name="PasswordExpired" type="boolean" required="false" default="false" />
		<cfargument name="AllowedEvents" type="string" required="false" />
		<cfargument name="AllowedObjects" type="string" required="false" />
		<cfargument name="rstSiteUser" type="query" required="false" />

		<cfscript>
			if (Not StructKeyExists(arguments, "rstSiteUser")) {
				setSiteUserID(arguments.SiteUserID);
				setFirstName(arguments.FirstName);
				setLastName(arguments.LastName);
				setUserName(arguments.UserName);
				setPassword(arguments.Password);
				setEmailAddress(arguments.EmailAddress);
				setMobileNumber(arguments.MobileNumber);
				setEnabled(arguments.Enabled);
				setDeleted(arguments.Deleted);
				if (StructKeyExists(arguments, "DateCreated"))
					if (Len(arguments.DateCreated) GT 0)
						setDateCreated(arguments.DateCreated);
				if (StructKeyExists(arguments, "CreatedSiteUser"))
					setCreatedSiteUser(arguments.CreatedSiteUser);
				if (StructKeyExists(arguments, "DateUpdated"))
					if (Len(arguments.DateUpdated) GT 0)
						setDateUpdated(arguments.DateUpdated);
				if (StructKeyExists(arguments, "UpdatedSiteUser"))
					setUpdatedSiteUser(arguments.UpdatedSiteUser);
				if (StructKeyExists(arguments, "DateDeleted"))
					if (Len(arguments.DateDeleted) GT 0)
						setDateDeleted(arguments.DateDeleted);
				if (StructKeyExists(arguments, "DeletedSiteUser"))
					setDeletedSiteUser(arguments.DeletedSiteUser);
				if (StructKeyExists(arguments, "PasswordExpiry"))
					if (Len(arguments.PasswordExpiry) GT 0)
						setPasswordExpiry(arguments.PasswordExpiry);
				if (StructKeyExists(arguments, "PasswordPermanent"))
					setPasswordPermanent(arguments.PasswordPermanent);
				if (StructKeyExists(arguments, "PasswordExpired"))
					setPasswordExpired(arguments.PasswordExpired);
				if (StructKeyExists(arguments, "AllowedEvents"))
					setPrivileges(AllowedEvents=arguments.AllowedEvents);
				if (StructKeyExists(arguments, "AllowedObjects"))
					setPrivileges(AllowedObjects=arguments.AllowedObjects);
			}
			else {
				if (rstSiteUser.RecordCount GT 0) {
					if (StructKeyExists(rstSiteUser, "pkiSiteUserID"))
						setSiteUserID(rstSiteUser.pkiSiteUserID);
					if (StructKeyExists(rstSiteUser, "sFirstName"))
						setFirstName(rstSiteUser.sFirstName);
					if (StructKeyExists(rstSiteUser, "sLastName"))
						setLastName(rstSiteUser.sLastName);
					if (StructKeyExists(rstSiteUser, "sUserName"))
						setUserName(rstSiteUser.sUserName);
					if (StructKeyExists(rstSiteUser, "sEmailAddress"))
						setEmailAddress(rstSiteUser.sEmailAddress);
					if (StructKeyExists(rstSiteUser, "sMobileNumber"))
						setMobileNumber(rstSiteUser.sMobileNumber);
					if (StructKeyExists(rstSiteUser, "bEnabled"))
						setEnabled(rstSiteUser.bEnabled);
					if (StructKeyExists(rstSiteUser, "bDeleted"))
						setDeleted(rstSiteUser.bDeleted);
					if (StructKeyExists(rstSiteUser, "dtCreated"))
						if (Len(rstSiteUser.dtCreated) GT 0)
							setDateCreated(rstSiteUser.dtCreated);
					if (StructKeyExists(rstSiteUser, "dtUpdated"))
						if (Len(rstSiteUser.dtUpdated) GT 0)
							setDateUpdated(rstSiteUser.dtUpdated);
					if (StructKeyExists(rstSiteUser, "dtDeleted"))
						if (Len(rstSiteUser.dtDeleted) GT 0)
							setDateDeleted(rstSiteUser.dtDeleted);
					if (StructKeyExists(rstSiteUser, "dtExpiry"))
						if (Len(rstSiteUser.dtExpiry) GT 0)
							setPasswordExpiry(rstSiteUser.dtExpiry);
					if (StructKeyExists(rstSiteUser, "bPermanent"))
						setPasswordPermanent(rstSiteUser.bPermanent);
					if (StructKeyExists(rstSiteUser, "bExpired"))
						setPasswordExpired(rstSiteUser.bExpired);
				}
			}
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setSiteUserID" access="public" output="false" returntype="void">
		<cfargument name="SiteUserID" type="numeric" required="true" />
		<cfset variables.SiteUserID = arguments.SiteUserID />
	</cffunction>
	<cffunction name="getSiteUserID" access="public" output="false" returntype="numeric">
		<cfreturn variables.SiteUserID />
	</cffunction>

	<cffunction name="setFirstName" access="public" output="false" returntype="void">
		<cfargument name="FirstName" type="string" required="true" />
		<cfset variables.FirstName = arguments.FirstName />
	</cffunction>
	<cffunction name="getFirstName" access="public" output="false" returntype="string">
		<cfreturn variables.FirstName />
	</cffunction>

	<cffunction name="setLastName" access="public" output="false" returntype="void">
		<cfargument name="LastName" type="string" required="true" />
		<cfset variables.LastName = arguments.LastName />
	</cffunction>
	<cffunction name="getLastName" access="public" output="false" returntype="string">
		<cfreturn variables.LastName />
	</cffunction>

	<cffunction name="setUserName" access="public" output="false" returntype="void">
		<cfargument name="UserName" type="string" required="true" />
		<cfset variables.UserName = arguments.UserName />
	</cffunction>
	<cffunction name="getUserName" access="public" output="false" returntype="string">
		<cfreturn variables.UserName />
	</cffunction>

	<cffunction name="setPassword" access="public" output="false" returntype="void">
		<cfargument name="Password" type="string" required="true" />
		<cfset variables.Password = arguments.Password />
	</cffunction>
	<cffunction name="getPassword" access="public" output="false" returntype="string">
		<cfreturn variables.Password />
	</cffunction>

	<cffunction name="setEmailAddress" access="public" output="false" returntype="void">
		<cfargument name="EmailAddress" type="string" required="true" />
		<cfset variables.EmailAddress = arguments.EmailAddress />
	</cffunction>
	<cffunction name="getEmailAddress" access="public" output="false" returntype="string">
		<cfreturn variables.EmailAddress />
	</cffunction>

	<cffunction name="setMobileNumber" access="public" output="false" returntype="void">
		<cfargument name="MobileNumber" type="string" required="true" />
		<cfset variables.MobileNumber = arguments.MobileNumber />
	</cffunction>
	<cffunction name="getMobileNumber" access="public" output="false" returntype="string">
		<cfreturn variables.MobileNumber />
	</cffunction>

	<cffunction name="setEnabled" access="public" output="false" returntype="void">
		<cfargument name="Enabled" type="boolean" required="true" />
		<cfset variables.Enabled = arguments.Enabled />
	</cffunction>
	<cffunction name="getEnabled" access="public" output="false" returntype="boolean">
		<cfreturn variables.Enabled />
	</cffunction>

	<cffunction name="setDeleted" access="public" output="false" returntype="void">
		<cfargument name="Deleted" type="boolean" required="true" />
		<cfset variables.Deleted = arguments.Deleted />
	</cffunction>
	<cffunction name="getDeleted" access="public" output="false" returntype="boolean">
		<cfreturn variables.Deleted />
	</cffunction>

	<cffunction name="setDateCreated" access="public" output="false" returntype="void">
		<cfargument name="DateCreated" type="date" required="true" />
		<cfset variables.DateCreated = arguments.DateCreated />
	</cffunction>
	<cffunction name="getDateCreated" access="public" output="false" returntype="date">
		<cfreturn variables.DateCreated />
	</cffunction>

	<cffunction name="setCreatedSiteUser" access="public" output="false" returntype="void">
		<cfargument name="CreatedSiteUser" type="siteuserbean" required="true" />
		<cfset variables.CreatedSiteUser = arguments.CreatedSiteUser />
	</cffunction>
	<cffunction name="getCreatedSiteUser" access="public" output="false" returntype="siteuserbean">
		<cfif IsObject(variables.CreatedSiteUser)>
			<cfreturn variables.CreatedSiteUser />
		<cfelse>
			<cfreturn CreateObject("component", "siteuserbean") />
		</cfif>
	</cffunction>

	<cffunction name="setDateUpdated" access="public" output="false" returntype="void">
		<cfargument name="DateUpdated" type="date" required="true" />
		<cfset variables.DateUpdated = arguments.DateUpdated />
	</cffunction>
	<cffunction name="getDateUpdated" access="public" output="false" returntype="date">
		<cfreturn variables.DateUpdated />
	</cffunction>

	<cffunction name="setUpdatedSiteUser" access="public" output="false" returntype="void">
		<cfargument name="UpdatedSiteUser" type="siteuserbean" required="true" />
		<cfset variables.UpdatedSiteUser = arguments.UpdatedSiteUser />
	</cffunction>
	<cffunction name="getUpdatedSiteUser" access="public" output="false" returntype="siteuserbean">
		<cfif IsObject(variables.UpdatedSiteUser)>
			<cfreturn variables.UpdatedSiteUser />
		<cfelse>
			<cfreturn CreateObject("component", "siteuserbean") />
		</cfif>
	</cffunction>

	<cffunction name="setDateDeleted" access="public" output="false" returntype="void">
		<cfargument name="DateDeleted" type="date" required="true" />
		<cfset variables.DateDeleted = arguments.DateDeleted />
	</cffunction>
	<cffunction name="getDateDeleted" access="public" output="false" returntype="date">
		<cfreturn variables.DateDeleted />
	</cffunction>

	<cffunction name="setDeletedSiteUser" access="public" output="false" returntype="void">
		<cfargument name="DeletedSiteUser" type="siteuserbean" required="true" />
		<cfset variables.DeletedSiteUser = arguments.DeletedSiteUser />
	</cffunction>
	<cffunction name="getDeletedSiteUser" access="public" output="false" returntype="siteuserbean">
		<cfif IsObject(variables.DeletedSiteUser)>
			<cfreturn variables.DeletedSiteUser />
		<cfelse>
			<cfreturn CreateObject("component", "siteuserbean") />
		</cfif>
	</cffunction>

	<cffunction name="setPasswordExpiry" access="public" output="false" returntype="void">
		<cfargument name="PasswordExpiry" type="date" required="true" />
		<cfset variables.PasswordExpiry = arguments.PasswordExpiry />
	</cffunction>
	<cffunction name="getPasswordExpiry" access="public" output="false" returntype="date">
		<cfreturn variables.PasswordExpiry />
	</cffunction>

	<cffunction name="setPasswordPermanent" access="public" output="false" returntype="void">
		<cfargument name="PasswordPermanent" type="boolean" required="true" />
		<cfset variables.PasswordPermanent = arguments.PasswordPermanent />
	</cffunction>
	<cffunction name="getPasswordPermanent" access="public" output="false" returntype="boolean">
		<cfreturn variables.PasswordPermanent />
	</cffunction>

	<cffunction name="setPasswordExpired" access="public" output="false" returntype="void">
		<cfargument name="PasswordExpired" type="boolean" required="true" />
		<cfset variables.PasswordExpired = arguments.PasswordExpired />
	</cffunction>
	<cffunction name="getPasswordExpired" access="public" output="false" returntype="boolean">
		<cfreturn variables.PasswordExpired />
	</cffunction>

	<cffunction name="setPrivileges" access="public" output="false" returntype="void">
		<cfargument name="AllowedEvents" type="String" required="false" />
		<cfargument name="AllowedObjects" type="String" required="false" />
		<cfargument name="Privileges" type="struct" required="false" />
		
		<cfif StructKeyExists(arguments, "Privileges") And StructKeyExists(arguments.Privileges, "AllowedEvents") And StructKeyExists(arguments.Privileges, "AllowedObjects")>
			<cfset variables.Privileges = arguments.Privileges />
		<cfelse>		
			<cfif StructKeyExists(arguments, "AllowedEvents")>
				<cfset variables.Privileges.AllowedEvents = arguments.AllowedEvents />
			</cfif>
			<cfif StructKeyExists(arguments, "AllowedObjects")>
				<cfset variables.Privileges.AllowedObjects = arguments.AllowedObjects />
			</cfif>
		</cfif>
	</cffunction>
	<cffunction name="getPrivileges" access="public" output="false" returntype="struct">
		<cfreturn variables.Privileges />
	</cffunction>

	<cffunction name="setGroups" access="public" output="false" returntype="void">
		<cfargument name="Groups" type="query" required="true" />
		<cfset variables.Groups = arguments.Groups />
	</cffunction>
	<cffunction name="getGroups" access="public" output="false" returntype="query">
		<cfreturn variables.Groups />
	</cffunction>

	<cffunction name="dump" access="public" output="false" returntype="struct">
		<cfset var structVars = StructNew() />
		<cfset var structDump = "" />
		<cfset var objComponent = "" />
		<cfset var objKey = "" />
		<cfset var strKey = "" />
		
		<cfloop list="#StructKeyList(variables)#" index="strKey">
			<cfif Not ListFindNoCase ("this", strKey) GT 0>
				<cfif IsDefined("variables.#strKey#.init")>
					<cfset objComponent = Evaluate("variables.#strKey#") />
					<cfif GetMetaData(objComponent).path NEQ GetMetaData(this).path>
						<cfset structDump = objComponent.dump() />
						<cfset structInsert(structVars, strKey, structDump) />
					<cfelse>
						<cfset structInsert(structVars, strKey, objComponent) />
					</cfif>
				<cfelse>
					<cfset objKey = Evaluate("variables.#strKey#") />
					<cfif IsCustomFunction(objKey)>
						<cfif Not StructKeyExists(structVars, "Methods")>
							<cfset structVars.Methods = StructNew() />
						</cfif>
						<cfset structInsert(structVars.Methods, strKey, Duplicate(Evaluate("variables.#strKey#"))) />
					<cfelse>
						<cfset structInsert(structVars, strKey, Duplicate(Evaluate("variables.#strKey#"))) />
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn structVars />
	</cffunction>
	
</cfcomponent>