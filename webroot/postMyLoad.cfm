
	
	<cfscript>
		
		postMyLoad = postload ();
	//postMyLoad = CancelLoad ();
		 //output of soap api
		details=xmlParse(postMyLoad.filecontent);
		//writeDump(getHttpResponse);
		writeDump(details);
	</cfscript>
		<cffunction name="CancelLoad" access="public" returntype="any">	
		
			<cfscript>
				savecontent variable="myVariable" { 
					WriteOutput('<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
									<s:Header>
										<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
									</s:Header>
									<s:Body>
										<CancelLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
											<PostProviderID>LMGR428AP</PostProviderID>
											<UserName>scottw@webersystems.com</UserName>
											<Password>weber908</Password>
											<LoadIDs>
												<LoadID>1000225</LoadID>
											</LoadIDs>
										</CancelLoad>
									</s:Body>
								</s:Envelope>');
				}
				var getHttpResponse = "";
				var httpServiceParams = [
					{
						type = "xml",
						value = trim(myVariable)
					}
				];
				getHttpResponse = getHttpResponseLoadBoard ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
				//writedump(xmlparse(getHttpResponse.filecontent));
				writedump(getHttpResponse);abort;
				return getHttpResponse;
			</cfscript>
		</cffunction>
			<cffunction name="postload" access="public" returntype="any">	
			
			<cfscript>
				savecontent variable="myVariable" { 
					WriteOutput('<?xml version="1.0" encoding="UTF-8"?>
									<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
										<s:Header>
											<Action>http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0</Action>
										</s:Header>
										<s:Body>
											<PostLoad xmlns="http://schemas.123loadboard.com/2009/05/06">
												<PostProviderID>LMGR428AP</PostProviderID>
												<UserName>scottw@webersystems.com</UserName>
												<Password>weber908</Password>
												<Loads xmlns:i="http://www.w3.org/2001/XMLSchema-instance">l
													<Load>
														<AmountType i:nil="true" />
														<Commodity i:nil="true"></Commodity>
														<DelivDate>2015-10-26T00:07:00</DelivDate>
														<DestCity>TEXAS CITY</DestCity>
														<DestState>TX</DestState>
														<DispatcherEmail i:nil="true">Test1@test.com</DispatcherEmail>
														<DispatcherExt i:nil="true" />
														<DispatcherName i:nil="true">dsjnffi edfnjes</DispatcherName>
														<DispatcherPhone i:nil="true">123-456-7890</DispatcherPhone>
														<EquipCode>F</EquipCode>
														<EquipInfo i:nil="true" />
														<LoadID>1000225</LoadID>
														<LoadSize>TL</LoadSize>
														<OrigCity>TEXAS CITY</OrigCity>
														<OrigLatitude>0</OrigLatitude>
														<OrigLongitude>0</OrigLongitude>
														<OrigState>TX</OrigState>
														<OrigZipcode i:nil="true">77590</OrigZipcode>
														<PickUpDate>2015-10-26T00:07:00</PickUpDate>
														<RepeatDaily>false</RepeatDaily>
														<TeamLoad i:nil="true" />
														<Notes i:nil="true"></Notes>
														<TrackNo i:nil="true" />
														<DelivTime i:nil="true"></DelivTime>
														<DestZipcode i:nil="true">77590</DestZipcode>
														<LoadQty i:nil="true"></LoadQty>
														<PickUpTime i:nil="true"></PickUpTime>
														<Stops>1</Stops>
													</Load>
												</Loads>
											</PostLoad>
										</s:Body>
									</s:Envelope>');
				}
				
							var getHttpResponse = "";
							var httpServiceParams = [
								{
									type = "xml",
									value = trim(myVariable)
								}
							];
							getHttpResponse = getHttpResponseLoadBoard ( method = "post", setUrl = "http://ws.123loadboard.com/PostingWS/PostingServiceV00.svc?xsd=xsd0", httpParameters = httpServiceParams );
					
				writedump(getHttpResponse);
				writedump(myVariable);
				abort;
				return getHttpResponse;
			</cfscript>
		</cffunction>
		<cffunction name="getHttpResponseLoadBoard" access="public" returntype="any">	
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