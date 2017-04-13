<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qSystemSetupOptions" />
<cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qStates" />
<cfinvoke component="#variables.objequipmentGateway#" method="getloadEquipments" returnvariable="request.qEquipments" />
<cfinvoke component="#variables.objunitGateway#" method="getloadUnits" status="True" returnvariable="request.qUnits" />
<cfinvoke component="#variables.objclassGateway#" method="getloadClasses" status="True" returnvariable="request.qClasses" />
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>
<cfquery  name="request.qoffices" datasource="#application.dsn#">
   select CarrierOfficeID,location,carrierID from carrieroffices  where location <> '' and carrierID=null
   ORDER BY Location ASC
</cfquery> 
	<cfif isdefined("url.loadid") and len(trim(url.loadid)) gt 1 >
		<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#loadID#" stopNo="0" returnvariable="request.qLoads" />
		 <cfset loadStatus=request.qLoads.STATUSTYPEID>
		 <cfset impref=request.qLoads.LoadNumber>
		<cfset loadIDN = url.loadid>
	<cfelse>
		<cfset loadIDN = "">
		<cfset impref = "">
	</cfif>
	<!---<cfif isdefined("url.stopid") and len(trim(url.stopid)) gt 1 >
		<cfset stopNumber = url.stopid>
	</cfif>
	<cfif isdefined("url.stopno") and len(trim(url.stopno)) gt 1 >
		<cfset StopNoIs = url.stopno>
	</cfif>--->
	<cfif isdefined("url.totStops") and len(trim(url.totStops))>
		<cfset totStops = url.totStops>
		<cfset totalStops = totStops + 1>	
	</cfif>
	<cfif isdefined("url.LoadNumber") and len(trim(url.LoadNumber))>
	  	<cfset loadNumber = url.LoadNumber>
	<cfelse>
		<cfset loadNumber = "">
  	</cfif>
	<cfif isdefined("url.currentTab") and len(trim(url.currentTab))>
	  	<cfset currentTab = url.currentTab>
  	</cfif>
	<cfif request.qSystemSetupOptions.freightBroker>
		<cfset variables.freightBrokerReport = "Carrier">
	<cfelse>
		<cfset variables.freightBrokerReport = "Dispatch">
	</cfif>
	<cfset htmlString = "">
	<cfloop from="#totalStops#" to="10" index="stopNo">
		<cfset stopNumber = stopNo>
		<cfset StopNoIs = stopNumber - 1>
		<cfsavecontent variable="content">
			<cfoutput>
			<div class="white-con-area">
				<div id="stop#stopNumber#" style="display:none">
					<div id="tabs#stopNumber#" class="tabsload">
						<ul style="height:27px;">
							<li><a href="##tabs-1">Stop #stopNumber#</a></li>
							<li><a href="index.cfm?event=loadIntermodal&stopno=#stopNumber#&loadID=#loadID#&#Session.URLToken#">Intermodal</a></li>
							<div style="float: left;width: 23%;margin-left: 27px;">
								<div class="form-con" style="width:103%" id="StopNo#stopNumber#">
									<ul class="load-link" id="ulStopNo#stopNumber#" style="line-height:26px;">
										<cfif IsDefined("loadIDN")>
											<cfloop from="1" to="#totStops#" index='stpNoid'>
												<cfif stpNoid is 1>
													<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
												<cfelse>
													<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
												</cfif>
											</cfloop>
										<cfelse>
											<li><a href="##StopNo#stpNoid#">###stopNumber#</a></li>
										</cfif>
										<!--- <li><a href="##">##2</a></li><li><a href="##">##3</a></li> --->
									</ul>
									<div class="clear"></div>
								</div>
							</div>
							<div style="float: left; width: 56%;height: 26px;">
								<h2 style="color:white;font-weight:bold;margin-top: -8px;">Load###Ucase(loadnumber)#</h2>
							</div>
						</ul>
						<div id="tabs-1">
							<cfinclude template="loadStopAjax.cfm">
						</div>				
					</div>
					<div class="form-heading-loop">
						<div class="rt-button3">
							<input name="addstopButton" disabled="yes" type="button" class="green-btn" onclick="AddStop('stop#(stopNumber+1)#',#(stopNumber+1)#);setStopValue();" value="Add Stop" />
							<input name="" type="button" class="red-btn" onclick="deleteStop('stop#stopNumber#',#(stopNumber-1)#,#showItems#,'#nextLoadStopId#','#application.DSN#','#loadIDN#');setStopValue();" value="Delete Stop" /></p>
						</div>
						<div class="clear"></div>
						<cfif ListContains(session.rightsList,'runReports',',')>
							<cfset carrierReportOnClick = "window.open('../reports/loadReportForCarrierConfirmation.cfm?loadid=#loadIDN#&#session.URLToken#')">
						<cfelse>
							<cfset carrierReportOnClick = "">
						</cfif>
						<cfif isdefined("url.loadid") and len(trim(url.loadid)) gt 1>
							<cfset variables.statusDispatch="">
							<cfif loadStatus eq 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F45'>
								<cfset variables.statusDispatch='Rate Quote'>
							<cfelseif (loadStatus eq 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44') or (loadStatus eq 'B54D5427-A82E-4A7A-BAA1-DA95F4061EBE') or (loadStatus eq '74151038-11EA-47F7-8451-D195D73DE2E4') or(loadStatus eq 'C4C98C6D-018A-41BD-8807-58D0DE1BB0F8') or(loadStatus eq 'E62ACAA8-804B-4B00-94E0-3FE7B081C012') or(loadStatus eq 'C980CD90-F7CD-4596-B254-141EAEC90186')>
								<cfset variables.statusDispatch='Rate Conf'>	
							<cfelseif (loadStatus eq '6419693E-A04C-4ECE-B612-36D3D40CFC70') or (loadStatus eq 'CE991E00-404D-486F-89B7-6E16C61676F3') or (loadStatus eq '5C075883-B216-49FD-B0BF-851DCB5744A4') or (loadStatus eq 'C126B878-9DB5-4411-BE4D-61E93FAB8C95')>
								<cfset variables.statusDispatch='Invoice'>	
							</cfif>
							<cfset customerReportOnClick = "window.open('../reports/customerConfirmationReport.cfm?loadno=#impref#&loadid=#loadIDN#&dsn=#dsn#&#session.URLToken#')">
							<div class="rt-button">
								<input type="button" value="#variables.freightBrokerReport# Report" class="report-btn" onclick="#carrierReportOnClick#" <cfif carrierReportOnClick eq "">disabled="disabled"</cfif>/>
								<input name="submit" type="submit" class="green-btn" onClick="return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="disabled" />
								<input name="submit" type="submit" class="green-btn" onClick="return saveButExitPage('#url.loadid#');" onfocus="checkUnload();" value="Save & Exit" />
								<cfif variables.statusDispatch neq "">
									<input type="button"  value="#variables.statusDispatch#" class="report-btn" onclick="#customerReportOnClick#" <cfif customerReportOnClick eq ""> disabled="disabled"</cfif>/>
								</cfif>	
								<input type="button"  value="Copy Load" class="bttn" onclick="window.open('index.cfm?event=addload&loadToBeCopied=#url.loadid#&#session.URLToken#')"/>
								<input name="" type="button" class="bttn" onclick="javascript:history.back();" value="Back" />
							</div>
						<cfelse>
							<div class="rt-button">
								<input name="submit" type="submit" class="green-btn" onClick="return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="disabled"/>
								<input name="submit" type="submit" class="green-btn" onClick="return saveButExitPage('2');" onfocus="checkUnload();" value="Save & Exit"  disabled="disabled" />
								<input name="" type="button" class="bttn" onclick="javascript:history.back();" value="Back" />
							</div>
						</cfif>
						<input type="hidden" name="shipperFlag#stopNumber#" id="shipperFlag#stopNumber#" value="0">
						<input type="hidden" name="consigneeFlag#stopNumber#" id="consigneeFlag#stopNumber#" value="0">
						<br class="clear"/>
						<div class="clear"></div>
						<cfif #stopNumber# eq #totStops#>
							<cfif  loadIDN neq "">
								<cfif request.qLoads.RecordCount GT 0 AND IsDefined("request.qLoads.LastModifiedDate") AND IsDefined("request.qLoads.ModifiedBy")>
									<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;"> Last Updated:&nbsp;&nbsp;&nbsp; #request.qLoads.LastModifiedDate#&nbsp;&nbsp;&nbsp;#request.qLoads.ModifiedBy# </p>
								</cfif>
							</cfif>
						</cfif>
					</div>
					<div class="white-bottom">&nbsp;</div>
				</div>
			</div>
			<div class="gap"></div>
		</cfoutput>
		</cfsavecontent>
		<cfset htmlString &= "#content#">
	</cfloop>
		<cfset htmlString &= "<div class='gap'></div><div class='gap'></div>">
			
		<cfoutput>#htmlString#</cfoutput>	
		
		
		