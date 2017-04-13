
	
	<cfscript>
		postMyLoad = postLoad ();
		writeDump(postMyLoad); //output of soap api
		//details=xmlParse(postMyLoad.filecontent);
		//writeDump(getHttpResponse);
		//writeDump(details);
	</cfscript>
		<cffunction name="postLoad" access="public" returntype="any">	
			
			<cfscript>
				
				var getHttpResponse = "";
				
				getHttpResponse = getHttpResponseMagnetMail ( method = "get", setUrl = "http://schemas.123loadboard.com/2009/05/06");
				return getHttpResponse;
			</cfscript>
		</cffunction>
		
		<cffunction name="getHttpResponseMagnetMail" access="public" returntype="any">	
			<cfargument name="method" type="string" required="yes"> 
			<cfargument name="setUrl" type="string" required="yes">
			
			<cfscript>
				var httpService = new http();
				httpService.setMethod(arguments.method); 
				httpService.setUrl(arguments.setUrl);
				httpService.addParam(type="header",name="Content-Type", value="text/xml; charset=utf-8"); 
				httpService.addParam(type="header",name="host", value="ws.123loadboard.com"); 
				httpService.addParam(type="header",name="SOAPAction", value="PostLoad");
				
				var httpResponse = httpService.send().getPrefix();
				return httpResponse;
			</cfscript>
		</cffunction>