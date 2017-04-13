<cfset SmtpAddress='smtpout.secureserver.net'>
<cfset SmtpUsername='no-reply@loadmanager.com'>
<cfset SmtpPort='3535'>
<cfset SmtpPassword='wsi11787'>
<cfset FA_SSL=0>
<cfset FA_TLS=1>
<!--- <cfset variables.timeOutPoint = DateAdd('s', -30, Now())> --->

<cfquery name="qDeleteUserLoggedInCount" datasource="#Application.dsn#">
	delete from userLoggedInCount
	where currenttime <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -30, Now())#">
</cfquery>
<cfquery name="qusercount" datasource="#Application.dsn#">
	select count(*) as count from userLoggedInCount
	where isactive=1
</cfquery>
<cfquery name="qUpdateUserCount" datasource="#Application.dsn#">
	update Employees set 
	userCount=<cfqueryparam cfsqltype="cf_sql_integer" value="#val(qUpdateUserCount.count)#">
</cfquery>
<!--- <cfquery name="qGetUserLoggedInCount" datasource="#Application.dsn#">
 select cutomerId,currenttime 
 from userLoggedInCount
 where isactive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>
<cfif qGetUserLoggedInCount.recordcount>
 <cfset variables.failedTime = 2>
 <cfset variables.userLoggedInCount = "">
 <cfloop query="qGetUserLoggedInCount">
  <cfif len(trim(qGetUserLoggedInCount.currenttime)) and isdate(qGetUserLoggedInCount.currenttime)>  
   <cfset variables.failedTime = abs(DateDiff("n",qGetUserLoggedInCount.currenttime,now()))>   
   <cfif variables.failedTime gte 2>
     <cfset listPos = ListFindNoCase(Application.userLoggedInCount, qGetUserLoggedInCount.cutomerId)>
    <cfif listPos>
		cfloop list="#Application.userLoggedInCount#" index="i">
			<cfquery name="qryGetEditingLoads" datasource="#Application.dsn#">
				select user_id
				from UserEditingLoads
				where  user_id =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#" />
			</cfquery>	
			<cfif qryGetEditingLoads.recordcount>
				<cfquery name="qryDeleteUserEditLoad" datasource="#Application.dsn#">
					delete  from UserEditingLoads
					where 
					user_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetEditingLoads.user_id#">
				</cfquery>
			</cfif>
		</cfloop
		<cfset Application.userLoggedInCount = ListDeleteAt(Application.userLoggedInCount, listPos)>
		<cfquery name="update" datasource="#Application.dsn#">
			DELETE 
			from userLoggedInCount
			where  cutomerId =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetUserLoggedInCount.cutomerId#" />
		</cfquery>	
		
    </cfif>
   </cfif>
  </cfif>
 </cfloop> 
</cfif>
<cfquery name="update" datasource="#Application.dsn#">
	UPDATE SystemConfig
	set
	userCount =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(Application.userLoggedInCount)#" />
</cfquery> --->

<!---<cfset Application.userLoggedInCount  = variables.userLoggedInCount>--->

<!--- <cfmail type="text" from="#SmtpUsername#" subject="Lost Password Retrieval" to="arunraj@spericorn.com" server="#SmtpAddress#" username="#SmtpUsername#" password="#SmtpPassword#" port="#SmtpPort#" usessl="#FA_SSL#" usetls="#FA_TLS#" >
	<cfquery name="qusercount" datasource="#Application.dsn#">
	select count(*) as count from userLoggedInCount
	where isactive=1
	</cfquery>

	<cfoutput>#qusercount.count#</cfoutput>
</cfmail>
 --->