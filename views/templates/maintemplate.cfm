<cfoutput> 
  <cfif request.event NEQ "addload" and request.event NEQ "addloadnew"><cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer"></cfif>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	  
		<title>Load Management</title>
		<!---<cfif cgi.query_string DOES NOT CONTAIN 'addload'>
        <cfif request.event NEQ "addload">
			<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false&v=3"></script>
		</cfif>--->
          <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false&v=3"></script>
		<link rel="stylesheet" type="text/css" href="styles/jquery.autocomplete.css" />
          <cfset urlCfcPath = Replace(request.cfcpath, '.', '/','All')/>
		<script>
          urlComponentPath  = "/#urlCfcPath#/";
        </script>
       
		 
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
		<link href="styles/style.css?#now()#" rel="stylesheet" type="text/css" />
        <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
	    <script src="https://code.jquery.com/ui/1.11.0/jquery-ui.min.js"></script>
        <script src="https://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.min.js"></script>
		<script src="javascripts/Validation.js?#now()#" language="javascript" type="text/javascript"></script>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
		<script>
			var tabID = sessionStorage.tabID && sessionStorage.closedLastTab !== '2' ? sessionStorage.tabID : sessionStorage.tabID = Math.random();
			$(document).ready(function(){
				if($("##tabid").length){
					$("##tabid").val(tabID);
				}
			});	
		</script>
		<!---Condition to check the user is not in loadedit page--->
		<cfif structKeyExists(url, "event") and url.event neq "addload" and url.event neq "nextStopLoad" and structkeyexists(session,"empid") and len(trim(session.empid)) and structkeyexists(session,"currentloadid") and len(trim(session.currentloadid))>
			<cfoutput>
				<script type="text/javascript">
					$(document).ready(function(){
						var path = urlComponentPath+"loadgateway.cfc?method=deleteTabDetails";
						$.ajax({
						type: "Post",
						url: path,		
						dataType: "json",
						async: false,
						data: {
							tabID:tabID,userid:'#session.empid#',sessionid:'#session.sessionid#',dsn:'#application.dsn#'
						},
						success: function(data){
						 console.log(data);
						}
					  });
					});
				</script>
			</cfoutput>	
		</cfif>
		<cfinclude template="getActiveUsersList.cfm">

		<cfif (isdefined("url.loadid") and len(trim(url.loadid)) gt 1) OR (isdefined("url.loadToBeCopied") and len(trim(url.loadToBeCopied)) gt 1)>
        
		<cfparam name="NewcustomerID" default="">
			<script>
				$('.CustInfo1').ready(function(){
					getCutomerForm('#NewcustomerID#','#application.DSN#','#session.URLToken#');
				});
			</script>
          </cfif>
		  <cfparam name="userlogged" default="0">
		 <cfif structkeyexists (session,"empid") and structkeyexists(session, "passport")>			
			<cfif Session.empid neq "" and session.passport.isLoggedIn>		
				<cfset userlogged=1>
			</cfif>
		</cfif>	
		<!--- <cfif structkeyexists (session,"customerid") and structkeyexists(session, "passport")>
			<cfif Session.customerid neq "" and session.passport.isLoggedIn>
				<cfset userlogged=1>
			</cfif>
		</cfif>	 --->
		<!--- <cfif userlogged eq 1>
			<script>
				$(function(){
					window.heartBeat = setInterval(
					function(){
						$.ajax({
								url : "userCountRunning.cfm",
								 cache: false
								});
					},
					(30 * 1000)
					);
				setTimeout(
					function(){
								// Clear the heart beat.
								clearInterval( window.heartBeat );
							},
							(30 * 60 * 1000)
						);
				});
			</script>
		</cfif>	 --->
		  <style>
			.unReadMessage{
				background-color: ##d21f1f;
				border-radius: 50%;
				color: ##fff;
				display: inline-block;
				float: right;
				height: 20px;
				margin-left: 31px;
				position: absolute;
				text-align: center;
				top: 60px;
				width: 20px;
			}
			.unread {
				font-size: 11px;
				position: relative;
				right: 0;
				top: -7px;
			}
		  </style>
		</head>
		<body>
		<cfparam name="url.thnks" default="0">
			<!---time stame code added by Furqan--->
    	<cfset todayDate = #Now()#> 
		<cfset logindate = #DateFormat(todayDate, "yyyy-mm-dd")# >
		<cfinvoke component="#variables.objSecurityGateway#" method="timeuser"/>
    <!---Time stame code added by Furqan--->
		<!-----<div style="margin-top: 6%; margin-left: 80%; position: absolute; width:14%"><a href="index.cfm?event=feedback&#Session.URLToken#"><img src="images/fdbk.png" width="100px" border="0"></a></div>----->
		<cfif structkeyexists(url,"thnks") and url.thnks eq 1>
				<script>
				alert('Thank you for giving us your feedback');
				
				</script>
	 </cfif>
		
		<cfinvoke component="#variables.objequipmentGateway#" method="getCountEquipments" returnvariable="request.qryCountEquipments" />
	
		<cfinvoke component="#variables.objloadGateway#" method="getLoadSystemSetupOptions" returnvariable="request.qSystemSetupOptions1" />
			<!------posteverywhere & transcore alert messages---------->
			<cfif structkeyexists(url,"AlertvarP") and url.AlertvarP neq "1"  and url.AlertvarP neq "" and  request.qSystemSetupOptions1.integratewithPEP  neq 0 >
				
				<cfset test=#findnocase("APPROVED",url.AlertvarP)# >
				<cfoutput>
					<cfif test eq 0>
						<script>
							var #toScript(AlertvarP, "jsVar")#;
							alert(jsVar);
						</script> 
					</cfif>
				</cfoutput> 
			 </cfif>
			<cfif structkeyexists(url,"AlertvarT") and url.AlertvarT neq "1"   and url.AlertvarT neq "" and  request.qSystemSetupOptions1.integratewithPEP  neq 0 >
				
				<cfset test=#findnocase("APPROVED",url.AlertvarT)# >
				<cfset Testprev=#findnocase("!!!",url.AlertvarT)# >
				<cfset TestDel=#findnocase("sucessfully deleted",url.AlertvarT)# >
				<cfoutput>
					<cfif test eq 0 and Testprev eq 0 and TestDel eq 0>
						<script>
							var #toScript(AlertvarT, "jsVar")#;
							alert('Your Load has been saved however it could not be posted to Transcore because of the following error ['+jsVar+']');
						</script> 
					<cfelseif  test eq 0 and Testprev gt 0 and TestDel eq 0>
					
					<cfset AlertvarT=#replace(AlertvarT,"1!!!",'')# ><cfset AlertvarT=#replace(AlertvarT,"!!!",'')# >
						<script>
							var #toScript(AlertvarT, "jsVar")#;
							alert('Display the error message as you are now but modify it as follows: Your Load has been saved however it could not be Updated on the Transcore Load board because of the following error  ['+jsVar+']');
						</script> 
					<cfelseif TestDel gt 0>
					<!---	<script>
							var #toScript(AlertvarT, "jsVar")#;
							alert(jsVar);
						</script> --->
					</cfif>
				</cfoutput> 
			 </cfif>
			 <cfif structkeyexists(url,"AlertvarI") and url.AlertvarI neq "1"  and url.AlertvarI neq "" and  request.qSystemSetupOptions1.integratewithITS  neq 0 >
				
				
				<cfoutput>
					
						<script>
							var #toScript(url.AlertvarI, "jsVar")#;
							alert(jsVar);
						</script> 
					
				</cfoutput> 
			</cfif>
			 <cfif structkeyexists(url,"AlertvarM") and url.AlertvarM neq "1">
				<cfoutput>
						<script>
							var settingloadboardStatus=<cfoutput>'#url.AlertvarM#'</cfoutput>;
							if(settingloadboardStatus != '1'){
								$("##PostTo123LoadBoard").attr('checked', false);
							}else{
								$("##PostTo123LoadBoard").attr('checked', true);
							}
							var #toScript(url.AlertvarM,"jsVar")#;
							alert(jsVar);
						</script> 
				</cfoutput> 
			</cfif>	
			 <cfif structkeyexists(url,"AlertvarN") and url.AlertvarN neq "1">
				<cfoutput>
						
						<script>
							var settingloadboard=<cfoutput>'#url.AlertvarN#'</cfoutput>;
							if(settingloadboard != '1'){
								$("##PostTo123LoadBoard").attr('checked', true);
							}
							var #toScript(url.AlertvarN,"jsVar")#;
							alert(jsVar);
						</script> 
					
				</cfoutput> 
			</cfif>	
			<cfif structkeyexists(url,"Ialert") and url.Ialert neq 1>
				<cfoutput>
						
						<script>
							
							var #toScript(url.Ialert,"jsVar")#;
							alert(jsVar);
						</script> 
					
				</cfoutput> 
			</cfif>	
			<cfif structkeyexists(url,"Alertvarq") and url.Alertvarq neq 1>
				<cfoutput>
						
						<script>
							
							var #toScript(url.Alertvarq,"jsVar")#;
							alert(jsVar);
						</script> 
					
				</cfoutput> 
			</cfif>	
			<!---------end post & transcore alert message------> 
			<cfparam name="event" default="home">
			<cfparam name="variables.ClassName" default="">
			<cfif StructKeyExists(url,"event")>
				<cfif url.event eq "Myload" >
					<cfset variables.ClassName = "MyloadTableWrap" >
				<cfelseif url.event eq "load">
					<cfset variables.ClassName = "MyloadTableWrap AllLoadTableWrap" >
				</cfif>
			</cfif>
			
			
			<div class="container">

				<div class="top-head" style="float:left; width:14%; margin-left:14%;"><a href="##"><img src="images/logo.jpg" alt="Freight Agent Tracking System" /></a></div>
				<div style="float:left; width:42%; text-align:center; margin-top:5px;">
				 
				<cfif request.qSystemSetupOptions1.companyLogoName NEQ ''>
					<img src="images/logo/#request.qSystemSetupOptions1.companyLogoName#" width="120px;" /><br>
				</cfif>
				<cfif request.qSystemSetupOptions1.companyName NEQ ''>
					<strong>#request.qSystemSetupOptions1.companyName#</strong>
				</cfif>
				</div>
				 
				<div style="width:5%; float:left; margin-top:2%;"> Version 2.79.161012</div>
				<div style="clear:left;"></div>
				<table width="100%" border="0px" cellpadding="0px" style="height:100%;" cellspacing="0px"<cfif Not StructKeyExists(request, "content") And StructKeyExists(request, "tabs")> style="height:100%;"</cfif>>
					<tr>
						<td><table width="100%" border="0px" cellpadding="0px" cellspacing="0px">
								<!--- <tr>
							<td rowspan="2" width="79px" height="86px" valign="top"><img src="images/newlogo.jpg" width="79" height="86"></td>
							<td height="13px" valign="top"><img src="images/new_logo_text.jpg"></td>
						</tr> --->
								<tr>
									<td><cfif isdefined('session.passport.isLoggedIn') and session.passport.isLoggedIn>
											<table class="navigation" style="border-collapse:collapse; border:none;" border="0" cellpadding="0" cellspacing="0">
												<tr>
													<cfif Not structKeyExists(session, "IsCustomer")>
														<td><a href="index.cfm?event=myLoad&#Session.URLToken#" <cfif event is 'home'> class="active" </cfif>>Home</a></td>
														<cfif ListContains(session.rightsList,'addEditDeleteAgents',',')>
															<cfset agentUrl = "index.cfm?event=agent&sortorder=asc&sortby=Name&#Session.URLToken#">
														<cfelse>
															<cfset agentUrl = "javascript: alert('Sorry!! You do not have rights to the Agent screen.');">
														</cfif>
														<td><a href="#agentUrl#" <cfif event is 'agent' or event is 'addagent:process' or event is 'addagent'> class="active" </cfif>>Users</a></td>
														<td><a href="index.cfm?event=customer&#Session.URLToken#" <cfif event is 'customer' or event is 'addcustomer:process' or event is 'addcustomer' or event is 'stop' or event is 'addstop' or event is 'addstop:process'> class="active" </cfif>>Customers</a></td>
														<td>
															<a href="index.cfm?event=carrier&#Session.URLToken#" <cfif event is 'carrier' or event is 'addcarrier:process' or event is 'addcarrier' or event is 'equipment' or event is 'equipment:process' or event is 'addequipment'> class="active" </cfif>>
																<cfif request.qSystemSetupOptions1.freightBroker>
																	Carriers
																<cfelse>
																	Drivers
																	
																</cfif>
															</a>
															<cfif not request.qSystemSetupOptions1.freightBroker>
																<cfif request.qryCountEquipments.COMPUTED_COLUMN_1  gt 0>
																	<a href="index.cfm?event=equipment&EquipmentMaint=1&#Session.URLToken#">
																		<span class="unReadMessage">
																			<span title="#request.qryCountEquipments.COMPUTED_COLUMN_1# Equipments Need maintenance" class="unread">#request.qryCountEquipments.COMPUTED_COLUMN_1#</span>
																		</span>
																	</a>
																</cfif>
															</cfif>	
														</td>
													</cfif>
													<td><a href="index.cfm?event=load&#Session.URLToken#" <cfif event is 'load' or event is 'addload:process' or event is 'unit' or event is 'class' or event is 'addload' or event is 'addunit:process' or event is 'addunit' or event is 'addclass:process' or event is 'addclass' or event is 'advancedsearch'> class="active" </cfif>>All Loads</a></td>
													<cfif Not structKeyExists(session, "IsCustomer")>
														<td><a href="index.cfm?event=myLoad&#Session.URLToken#" <cfif event is 'myLoad'> class="active" </cfif>>My Loads</a></td>
	                                                    <td><a href="index.cfm?event=dispatchboard&#Session.URLToken#" <cfif event is 'dispatchboard'> class="active" </cfif>>Dispatch Board</a></td>
	                                                    <!--- <cfif cgi.REMOTE_ADDR eq "202.88.244.203">
	                                                    	<cfdump var="#session.rightsList#" /><cfabort />
	                                                    </cfif> --->
														<cfif ListContains(session.rightsList,'runReports',',')>
															<cfset reportUrl = "index.cfm?event=reports&#Session.URLToken#">
														<cfelse>
															<cfset reportUrl = "javascript: alert('Sorry!! You don\'t have rights to run any reports.');">
														</cfif>
														<td><a href="#reportUrl#" <cfif event is 'reports'> class="active" </cfif>>Reports</a></td>
														<cfif ListContains(session.rightsList,'modifySystemSetup',',')>
															<cfset sysSetupUrl = "index.cfm?event=systemsetup&#Session.URLToken#">
														<cfelse>
															<cfset sysSetupUrl = "javascript: alert('Sorry!! You don\'t have rights to modify System Setup.');">
														</cfif>
														<td><a href="#sysSetupUrl#" <cfif event is 'systemsetup'> class="active" </cfif>>System Setup</a></td>
													</cfif>
													<td class="nobg"><a href="index.cfm?event=logout:process&#Session.URLToken#">Logout</a></td>
													
												</tr>
											</table>
									 
											<div class="below-nav"> #request.subnavigation#
												<div class="clear"></div>
											</div>
										</cfif>
										
										</td>
										
								</tr>
							</table></td>
					</tr>
					 
					<tr>
						<td valign="top"><cfif StructKeyExists(request, "content") Or Not StructKeyExists(request, "tabs")>
								<!--- <table width="100%" border="0px" cellpadding="0px" cellspacing="0px">
							<tr>
								<td background="images/header_back.jpg" height="25">
									<div class="heading">
										<cfif StructKeyExists(request, "TopHeading")>#request.TopHeading#</cfif>
									</div>
								</td>
							</tr>
							<tr>
								<td class="border" valign="top"> --->
								<!--- <div class="content-area" style="height:100%;"> --->
								<div class="content"></div>
								<cfif StructKeyExists(request, "alertMessage")>
									#request.alertMessage#
								</cfif>
								<div class="subheading">
									<cfif StructKeyExists(request, "SubHeading")>
										#request.SubHeading#
									</cfif>
								</div>
                      <!---Content Area for Dispatcher Board Tab--->          
                                <cfif event eq 'dispatchboard'>
									<div class="content-area-for-dispatcher-board" style="height:100%;">
                                
                                <cfelse>
                       <!---Content Area for other Tabs--->                   
                                	<div class="content-area #variables.ClassName#" style="height:100%;">
                                </cfif>
									<cfif StructKeyExists(request, "content")>
										#request.content#
									</cfif>
								</div>
								<!--- </div> --->
								<!--- </td>
							</tr>
						</table> --->
								<cfelseif StructKeyExists(request, "tabs")>
									#request.tabs#
							</cfif></td>
					</tr>
				</table>
			</div>
			<cfif Session.blnDebugMode>
				<br>
				<br>
				<cfset structToDump = StructNew() />
				<cfif IsDefined("Session.Passport")>
					<cfloop list="#StructKeyList(Session.Passport, ',')#" index="strKey">
						<cfif strKey NEQ "CurrentSiteUser">
							<cfset structToDump[strKey] = Duplicate(Session.Passport[strKey]) />
						</cfif>
					</cfloop>
				</cfif>
				<cfif IsDefined("Session.Passport.CurrentSiteUser")>
					<cfset structToDump.CurrentSiteUser = Session.Passport.CurrentSiteUser.dump() />
				</cfif>
			</cfif>
		</body>
	</html>
	<cfif (isdefined("url.loadid") and len(trim(url.loadid)) gt 1) OR (isdefined("url.loadToBeCopied") and len(trim(url.loadToBeCopied)) gt 1)>
		<cfparam name="NewcustomerID" default="">
		<script>
	<cfif isdefined('carrierID') and (len(carrierID) gt 1 or len(carrierIDNew) gt 1)>
		//useCarrier('#application.DSN#',0,'#session.URLToken#');
	</cfif>
	<cfif isdefined('totStops')>
		<cfloop from="2" to="#totStops#" index="stpNo"> 
			useCarrierNext('#application.dsn#',0,#stpNo#,'#session.URLToken#');
		</cfloop> 
	</cfif>
//	getCutomerForm('#NewcustomerID#','#application.DSN#','#session.URLToken#');
</script>
	</cfif>
	<script>
//	{
		
		window.onbeforeunload = function (evt) 
		{
//			var getSession = new ajaxLoadCutomer();
//			var confirmSession = getSession.getSession();  
			
			var unlockCreatedStatus=true;
			if($("##loaddisabledStatus").length){
				unlockCreatedStatus=$("##loaddisabledStatus").val();
			}
			if(unlockCreatedStatus == true){	
				var path = urlComponentPath+"loadgateway.cfc?method=getAjaxSession";
			} else{
				if($("##editid").length){
					var editid=$("##editid").val();
					if($("##appDsn").length && $("##tabid").length){
						var dsn=$("##appDsn").val();
						var tabid=$("##tabid").val();
						console.log($("##tabid").val());
						<cfif structkeyexists(session,"sessionid") and structKeyExists(session,"empid")>
							var path = urlComponentPath+"loadgateway.cfc?method=getAjaxSession&UnlockStatus="+unlockCreatedStatus+"&loadid="+editid+"&dsn="+dsn+"&sessionid=#session.sessionid#&userid=#session.empid#&tabid="+tabid;
						</cfif>	
					}else{
						var path = urlComponentPath+"loadgateway.cfc?method=getAjaxSession";
					}
				}else{
					var path = urlComponentPath+"loadgateway.cfc?method=getAjaxSession";
				}
				
			}
            var confirmSession = "";
            $.ajax({
                type: "get",
                url: path,		
                dataType: "json",
                async: false,
                success: function(data){
                  confirmSession = data.sessionCheck;
                }
              });
          

			<cfif isdefined('session.checkUnload') and session.checkUnload eq 'add'>
				if (chkLoad==0){
				var message = 'Are you sure you want to leave? Your work is not saved!';
				if (typeof evt == 'undefined') 
				{//IE
					evt = window.event;
				}
				if (evt) 
				{
					evt.returnValue = message;
				}
				<cfset session.checkUnload = ''>
				}
				console.log(message);
				console.log(evt);
			return message;
			</cfif> 
		 }
		<!---  <cfif isdefined('session.checkUnload') and session.checkUnload eq 'add'>
			checkval = 1;
			<cfset session.checkUnload = ''>
		</cfif> --->
		//alert('#session.checkUnload#');
  // }
</script>
<cfif structKeyExists(variables,"testTime")>
	<!---------To display the time taken to load-------->
	<div style="position:absolute;right:439px;margin-top:-15px;"><font size="4" weight="bold">Time taken to load: #testTime# milliseconds</font></div>
</cfif>
</cfoutput>