
<cfcomponent hint="I handle AJAX File Uploads from Valum's AJAX file uploader library">
	
    <cffunction name="Upload" access="remote" output="false" returntype="any" returnformat="JSON">
		<cfargument name="qqfile" type="string" required="true">
		
		<cfset var local = structNew()>
		<cfset local.response = structNew()>
		<cfset local.requestData = GetHttpRequestData()>
		<cfset local.response.FILENAME = "">
		
		<CFSET UploadDir = "#ExpandPath('../')#img\">
		<cfif not directoryExists(UploadDir)>
			<cfdirectory action="create" directory="#UploadDir#">
		</cfif>
		
		<!--- check if XHR data exists --->
        <cfif len(local.requestData.content) GT 0>
			<cfset local.response = UploadFileXhr(arguments.qqfile,local.requestData.content)>       
		<cfelse>
		<!--- no XHR data process as standard form submission --->
			<cffile action="upload" file="#arguments.qqfile#" destination="#UploadDir#" nameConflict="makeunique">
			
    		<cfset local.response['success'] = true>
    		<cfset local.response['type'] = 'form'>
		<cfset local.response.FILENAME = '#cfFile.ServerFile#'>

		</cfif>
		
		<cfreturn local.response>
	</cffunction>
      
    
    <cffunction name="UploadFileXhr" access="private" output="false" returntype="struct">
		<cfargument name="qqfile" type="string" required="true">
		<cfargument name="content" type="any" required="true">
		<cfset var local = structNew()>
		<cfset local.response = structNew()>
		<cfset local.response.FILENAME ="">
		<CFSET UploadDir = "#ExpandPath('../')#img\">

        <!--- write the contents of the http request to a file.  
		The filename is passed with the qqfile variable --->
		<cffile action="write" file="#UploadDir#/#arguments.qqfile#" output="#arguments.content#">

		<!--- if you want to return some JSON you can do it here.  
		I'm just passing a success message	--->
    	<cfset local.response['success'] = true>
    	<cfset local.response['type'] = 'xhr'>
		<cfset local.response.FILENAME = '#arguments.qqfile#'>
		<cfreturn local.response>
    </cffunction>
    <cffunction name="UpdateBillingDocument" access="remote" output="false" returntype="any" returnformat="JSON">
		<cfargument name="attachid" type="numeric" required="true">
		<cfargument name="checkedStatus" type="boolean" required="true">
		<cfargument name="flag" type="boolean" required="true">
		<cfargument name="dsn" type="string" required="true">
		
		<cfif arguments.flag eq 0>
			<cfquery name="qryUpdate" datasource="#dsn#">
				update FileAttachments set 
				Billingattachments=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.checkedStatus#" >
				where attachment_Id=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attachid#" >
			</cfquery>
		<cfelse>
			<cfquery name="qSystemSetupOptions" datasource="#dsn#">
				update FileAttachmentsTemp set 
				Billingattachments=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.checkedStatus#">
				where  attachment_Id=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attachid#" >
			</cfquery>
		</cfif>
		<cfset var localresponse = structNew()>
		<cfset localresponse['attachid'] = arguments.attachid>
		<cfset localresponse['checkedStatus'] = arguments.checkedStatus>
		<cfreturn SerializeJSON(localresponse)>
	</cffunction>	
</cfcomponent>