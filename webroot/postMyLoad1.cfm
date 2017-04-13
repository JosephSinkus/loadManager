	<cfset variables.Loads=arraynew(1)>
	<cfset variables.Loads=["2B9EC94E-E453-4B31-BE28-7D287A37519C}"]>
	
	<cfscript>
		postMyLoad = CancelLoad ('LMGR428AP', 'scottw@webersystems.com', 'weber908', variables.Loads );
		 //output of soap api
		//details=xmlParse(postMyLoad.filecontent);
		//writeDump(getHttpResponse);
		//writeDump(details);
	</cfscript>
		<cffunction name="CancelLoad" access="public" returntype="any">	
			<cfargument name="PostProviderID" type="string" required="yes"> 
			<cfargument name="username" type="string" required="yes">
			<cfargument name="password" type="string" required="yes">
			<cfargument name="LoadIds" type="array" required="yes">
			<cfscript>
				savecontent variable="myVariable" { 
					WriteOutput('<?xml version="1.0" encoding="UTF-8"?>
								<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
									<s:Header>
										<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
									</s:Header> 
									<s:Body>
										<CancelLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
											<PostProviderID>LMGR428AP</PostProviderID>
											<UserName>scottw@webersystems.com</UserName>
											<Password>weber908</Password>
											<LoadIDs xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
												<LoadID>2B9EC94E-E453-4B31-BE28-7D287A37519C</LoadID>
											</LoadIDs>
										</CancelLoad>
									</s:Body>
								</s:Envelope>
								');
				}
				var getHttpResponse = "";
				var httpServiceParams = [
					{
						type = "xml",
						value = trim(myVariable)
					}
				];
				getHttpResponse = getHttpResponseMagnetMail ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
				//writedump(xmlparse(getHttpResponse.filecontent));
				writedump(getHttpResponse);abort;
				return getHttpResponse;
			</cfscript>
		</cffunction>
		
		<cffunction name="getHttpResponseMagnetMail" access="public" returntype="any">	
			<cfargument name="method" type="string" required="yes"> 
			<cfargument name="setUrl" type="string" required="yes">
			<cfargument name="httpParameters" type="array" required="yes">
			<cfscript>
				var httpService = new http();
				httpService.setMethod(arguments.method); 
				httpService.setUrl(arguments.setUrl);
				httpService.addParam(type="header",name="Content-Type", value="text/xml; charset=utf-8"); 
				httpService.addParam(type="header",name="host", value="ws.123loadboard.com"); 
				httpService.addParam(type="header",name="SOAPAction", value="CancelLoad");
				if(arrayLen(arguments.httpParameters)){
					for(var parameter = 1; parameter <= arrayLen(arguments.httpParameters); parameter++) {
						httpService.addParam(type = arguments.httpParameters[parameter].type,value = arguments.httpParameters[parameter].value);  			
					}	
				}
				var httpResponse = httpService.send().getPrefix();
				return httpResponse;
			</cfscript>
		</cffunction>