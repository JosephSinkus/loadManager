<cfcomponent output="true" extends="loadgatewayupdate">
	<cffunction name="init" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="yes" />
		<cfset variables.dsn = Application.dsn />
	</cffunction>
	
	<cffunction name="updateshipdateAll" access="remote" output="yes" returntype="Any" returnformat="plain">
		<cfargument name="loadNumbers" type="array" required="yes" />
		<cfargument name="dsn" type="string" required="yes" />
		<cfargument name="shipperDateToUpdate"  required="yes" />
		<cfargument name="empId" type="string" required="yes" />
		<cfargument name="statustext" type="string" required="yes" />
		<cfargument name="postits" type="numeric" required="yes" />
		<cfargument name="posteverywhere" type="numeric" required="yes" />
		<cfargument name="post123loadboard" type="numeric" required="yes" />
		<cfargument name="postdatloadboard" type="numeric" required="yes" />
		<cfargument name="weekendRollOvercheck" type="numeric" required="yes" default="1"/>
		<cfset var local=structNew()>
		<cfset local.datLoadbord=structNew()>
		<cfset local.datLoadbordDeleted=structNew()>
		<cfset local.datLoadbordNotPosted=structNew()>
		<cfset local.Loadbord123=structNew()>
		<cfset local.posteveryWhere=structNew()>
		<cfset local.posteveryWhereDeleted=structNew()>
		<cfset local.Loadbord123Deleted=structNew()>
		<cfset local.UpdatedShipDate=structNew()>
		<cfset local.LoadStatus=structNew()>
		<cfset local.loadboardits=structNew()>
		<cfset local.loadboarditsDeleted=structNew()>
		<cfset local.Loadbord123NotPosted=structNew()>
		<cfset var frmstruct=structNew()>
		<cfset local.datLoadbord=arraynew(1)>
		<cfset local.datLoadbordDeleted=arraynew(1)>
		<cfset local.UpdatedShipDate=arraynew(1)>
		<cfset local.LoadStatus=arraynew(1)>
		<cfset local.loadboardits=arraynew(1)>
		<cfset local.loadboarditsDeleted=arraynew(1)>
		<cfset local.datLoadbordNotPosted=arraynew(1)>
		<cfset local.Loadbord123=arraynew(1)>
		<cfset local.posteveryWhere=arraynew(1)>
		<cfset local.posteveryWhereDeleted=arraynew(1)>
		<cfset local.Loadbord123Deleted=arraynew(1)>
		<cfset local.Loadbord123NotPosted=arraynew(1)>
		<cfset variables.TheKey = 'NAMASKARAM'>
		<cfset local.dsn = Decrypt(ToString(ToBinary(arguments.dsn)), variables.TheKey)>
		<cfset variables.cfcpath=local.dsn &'.www.gateways'>
		<cfif not structKeyExists(variables,"objLoadGateway")>
			<cfscript>variables.objLoadGateway = #variables.cfcpath#&".loadgateway";</cfscript>
		</cfif>
		<cfquery name="qryGetAgentdetails" datasource="#local.dsn#">
	    	SELECT integratewithTran360,trans360Usename,trans360Password,IntegrationID, PCMilerUsername, PCMilerPassword,loadBoard123,loadBoard123Usename,loadBoard123Password,proMilesStatus,companyCode,integrationID
	        FROM Employees
	        WHERE EmployeeID = <cfqueryparam cfsqltype="cf_sql_varchar"value="#arguments.empId#">
	    </cfquery>
	    <cfinvoke  method="getSystemSetupOptions" dsn="#local.dsn#" returnvariable="request.qSystemSetupOptions" />
		<cfset local.loadnumbers=ArrayToList(arguments.loadNumbers,", ")>
		<cfif listFindNoCase(local.loadnumbers, 'on', ",")>
			<cfset local.loadnumbers = ListDeleteAt( local.loadnumbers, ListFindnocase(local.loadnumbers,'on',","), ",") />
		</cfif>
		<cfloop list="#local.loadnumbers#" index="i">
			<cfquery name="qryGetLoadDetails" datasource="#local.dsn#">
				select * from loads where loadnumber=<cfqueryparam cfsqltype="cf_sql_integer"value="#i#">
			</cfquery>
			<cfquery name="qryloadstopResult" datasource="#local.dsn#">
				select stopdate,StopNo,LoadType from  loadstops  
				where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
				order by StopNo
			</cfquery>
			<cfset var dateComparison=structNew()>
			<cfset variables.loopcount=0>
			<cfset variables.countRryloadstopResult=(qryloadstopResult.recordcount/2)>
			<cfloop from="1" to="#variables.countRryloadstopResult#" index="i">
				<cfquery name="qryCompareshipdate" datasource="#local.dsn#">
					select stopdate,StopNo,LoadType,stopdateDifference from  loadstops  
					where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
					and stopno=<cfqueryparam cfsqltype="cf_sql_integer"value="#variables.loopcount#">
					and LoadType=1
				</cfquery>
				
				<cfquery name="qryComparedeliverydate" datasource="#local.dsn#">
					select stopdate,StopNo,LoadType from  loadstops  
					where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
					and stopno=<cfqueryparam cfsqltype="cf_sql_integer"value="#variables.loopcount#">
					and LoadType=2
				</cfquery>
				<cfset variables.noOfDays=qryCompareshipdate.stopdateDifference>
				<!--- <cfif isDate(qryCompareshipdate.stopdate) and isdate(qryComparedeliverydate.stopdate)>
					<cfset variables.dateCompareResult= DateCompare(qryCompareshipdate.stopdate, qryComparedeliverydate.stopdate)>
					<cfif variables.dateCompareResult eq -1>
						<cfset variables.noOfDays=dateDiff("d", qryCompareshipdate.stopdate, qryComparedeliverydate.stopdate)>
					<cfelseif variables.dateCompareResult eq 0>
						<cfset variables.noOfDays=0>
					</cfif>	
				</cfif>	 --->
				<cfset StructInsert(dateComparison,"stop#variables.loopcount#",#variables.noOfDays#,"yes")>
				<cfset StructInsert(dateComparison,"stop#variables.loopcount#_Date",#qryCompareshipdate.stopdate#,"yes")>
				<cfset variables.loopcount++>
			</cfloop>
			<cfquery name="qryUpdateShipDetailsInstops" datasource="#local.dsn#">
				select stopdate,StopNo from  loadstops  
				where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
				and LoadStops.LoadType =<cfqueryparam cfsqltype="cf_sql_integer"value="2">
				order by StopNo
			</cfquery>
			<cfset variables.dateList=valuelist(qryUpdateShipDetailsInstops.stopdate)>
			<cfset variables.count=0>
			<cfset variables.statutextLoadBoardDeletionOccured=true>
			<cfif len(trim(arguments.statustext))>
				<cfswitch expression="#arguments.statustext#">
					<cfcase value="FBE06AA0-0868-48A9-A353-2B7CF8DA9F45">
						<cfset variables.statusTextNumber=1>
					</cfcase>
					<cfcase value="EBE06AA0-0868-48A9-A353-2B7CF8DA9F45">
						<cfset variables.statusTextNumber=2>
					</cfcase>
					<cfcase value="EBE06AA0-0868-48A9-A353-2B7CF8DA9F44">
						<cfset variables.statusTextNumber=3>
					</cfcase>
					
					<cfcase value="B54D5427-A82E-4A7A-BAA1-DA95F4061EBE">
						<cfset variables.statusTextNumber=4>
					</cfcase>
					
					<cfcase value="d4c98c6d-018a-41bd-8807-58d0de1bb0f8">
						<cfset variables.statusTextNumber=4>
					</cfcase>
					
					<cfcase value="74151038-11EA-47F7-8451-D195D73DE2E4">
						<cfset variables.statusTextNumber=5>
					</cfcase>
					<cfcase value="C4C98C6D-018A-41BD-8807-58D0DE1BB0F8">
						<cfset variables.statusTextNumber=6>
					</cfcase>
					<cfcase value="E62ACAA8-804B-4B00-94E0-3FE7B081C012">
						<cfset variables.statusTextNumber=7>
					</cfcase>
					<cfcase value="C980CD90-F7CD-4596-B254-141EAEC90186">
						<cfset variables.statusTextNumber=8>
					</cfcase>
					
					<cfcase value="6419693E-A04C-4ECE-B612-36D3D40CFC70">
						<cfset variables.statusTextNumber=9>
					</cfcase>
					<cfcase value="cf991e00-404d-486f-89b7-6e16c61676f3">
						<cfset variables.statusTextNumber=9>
					</cfcase>
					<cfcase value="43535cd6-8a5a-4e73-a3a3-8211e623b21d">
						<cfset variables.statusTextNumber=9>
					</cfcase>
					
					<cfcase value="CE991E00-404D-486F-89B7-6E16C61676F3">
						<cfset variables.statusTextNumber=10>
					</cfcase>
					<cfcase value="5C075883-B216-49FD-B0BF-851DCB5744A4">
						<cfset variables.statusTextNumber=11>
					</cfcase>
					<cfcase value="C126B878-9DB5-4411-BE4D-61E93FAB8C95">
						<cfset variables.statusTextNumber=12>
					</cfcase>
				</cfswitch>	
				<cfset variables.loadNumberAssignment=0>
				<cfif len(trim(request.qSystemSetupOptions.Triger_loadStatus))>
					<cfswitch expression="#request.qSystemSetupOptions.Triger_loadStatus#">
						<cfcase value="FBE06AA0-0868-48A9-A353-2B7CF8DA9F45">
							<cfset variables.loadNumberAssignment=1>
						</cfcase>
						<cfcase value="EBE06AA0-0868-48A9-A353-2B7CF8DA9F45">
							<cfset variables.loadNumberAssignment=2>
						</cfcase>
						<cfcase value="EBE06AA0-0868-48A9-A353-2B7CF8DA9F44">
							<cfset variables.loadNumberAssignment=3>
						</cfcase>
						
						<cfcase value="B54D5427-A82E-4A7A-BAA1-DA95F4061EBE">
							<cfset variables.loadNumberAssignment=4>
						</cfcase>
						
						<cfcase value="d4c98c6d-018a-41bd-8807-58d0de1bb0f8">
							<cfset variables.loadNumberAssignment=4>
						</cfcase>
						
						<cfcase value="74151038-11EA-47F7-8451-D195D73DE2E4">
							<cfset variables.loadNumberAssignment=5>
						</cfcase>
                        
						<cfcase value="C4C98C6D-018A-41BD-8807-58D0DE1BB0F8">
							<cfset variables.loadNumberAssignment=6>
						</cfcase>
                        
						<cfcase value="c4d98c6d-018a-41bd-8807-58d0df1bb0f8">
							<cfset variables.loadNumberAssignment=6>
						</cfcase>
                        
						<cfcase value="E62ACAA8-804B-4B00-94E0-3FE7B081C012">
							<cfset variables.loadNumberAssignment=7>
						</cfcase>
                        
						<cfcase value="C980CD90-F7CD-4596-B254-141EAEC90186">
							<cfset variables.loadNumberAssignment=8>
						</cfcase>
						
						<cfcase value="6419693E-A04C-4ECE-B612-36D3D40CFC70">
							<cfset variables.loadNumberAssignment=9>
						</cfcase>
                        
						<cfcase value="cf991e00-404d-486f-89b7-6e16c61676f3">
							<cfset variables.loadNumberAssignment=9>
						</cfcase>
                        
						<cfcase value="43535cd6-8a5a-4e73-a3a3-8211e623b21d">
							<cfset variables.loadNumberAssignment=9>
						</cfcase>
						
						<cfcase value="CE991E00-404D-486F-89B7-6E16C61676F3">
							<cfset variables.loadNumberAssignment=10>
						</cfcase>
                        
						<cfcase value="5C075883-B216-49FD-B0BF-851DCB5744A4">
							<cfset variables.loadNumberAssignment=11>
						</cfcase>
                        
						<cfcase value="C126B878-9DB5-4411-BE4D-61E93FAB8C95">
							<cfset variables.loadNumberAssignment=12>
						</cfcase>
                        
					</cfswitch>	
				</cfif>	
				<cfif variables.statusTextNumber gte  variables.loadNumberAssignment >
					<cfset variables.statutextLoadBoardDeletionOccured=false>
				<cfelse>
					<cfset variables.statutextLoadBoardDeletionOccured=true>
				</cfif>
			</cfif>	
			<cfif len(trim(arguments.shipperDateToUpdate))>
				<cfquery name="qryUpdateShipDetailsInstops1" datasource="#local.dsn#">
					update loadstops set 
					stopdate=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.shipperDateToUpdate#">
					where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
					and LoadStops.LoadType =<cfqueryparam cfsqltype="cf_sql_integer"value="1">
				</cfquery>
				<cfquery name="qryUpdateShipDetails" datasource="#local.dsn#">
					update loads set 
					NewPickupDate=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.shipperDateToUpdate#">
					where loadnumber=<cfqueryparam cfsqltype="cf_sql_integer"value="#qryGetLoadDetails.loadnumber#">
				</cfquery>
				<cfset arrayappend(local.UpdatedShipDate,#qryGetLoadDetails.loadnumber#)>
			</cfif>	
			<cfloop query="qryUpdateShipDetailsInstops">
				<cfset variables.todayDate=#DateFormat(now(), "mm/dd/yyyy")#>

				<!--- <cfset variables.todayDate=#DateFormat(now(), "mm/dd/yyyy")#>
				<cfset variables.stopdate=#DateFormat(stopdate, "mm/dd/yyyy")#>
				<cfset variables.shipdate=DateFormat(evaluate("stop#variables.count#_date"),"mm/dd/yyyy")> --->
				<cfif len(trim(arguments.shipperDateToUpdate))>
					<cfif IsValid("date",#arguments.shipperDateToUpdate#)>
						<cfset variables.addingNumber=evaluate("dateComparison.stop#variables.count#")>
						<cfif len(trim(variables.addingNumber))>
							<cfset variables.deliverydateIncremented=DateAdd("d", variables.addingNumber, #arguments.shipperDateToUpdate#)>
							<cfif arguments.weekendRollOvercheck eq 1>
								<cfif DayOfWeek(variables.deliverydateIncremented) eq 7 >
									<cfset variables.deliverydateIncremented=DateAdd("d", 2, #variables.deliverydateIncremented#)>
								<cfelseif DayOfWeek(variables.deliverydateIncremented) eq 1>	
									<cfset variables.deliverydateIncremented=DateAdd("d", 1, #variables.deliverydateIncremented#)>
								</cfif>	
							</cfif>	
							<cfquery name="qryUpdateShipDetailsInstops2" datasource="#local.dsn#">
								update loadstops set 
								stopdate=<cfqueryparam cfsqltype="cf_sql_date" value="#variables.deliverydateIncremented#">
								where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
								and LoadStops.LoadType =<cfqueryparam cfsqltype="cf_sql_integer"value="2">
								and StopNo=<cfqueryparam cfsqltype="cf_sql_integer"value="#variables.count#">
							</cfquery>
						<cfelse>
							<cfif arguments.weekendRollOvercheck eq 1>
								<cfif DayOfWeek(variables.todayDate) eq 7 >
									<cfset variables.todayDate=DateAdd("d", 2, #variables.todayDate#)>
								<cfelseif DayOfWeek(variables.todayDate) eq 1>	
									<cfset variables.todayDate=DateAdd("d", 1, #variables.todayDate#)>
								</cfif>	
							</cfif>	
							<cfquery name="qryUpdateShipDetailsInstops2" datasource="#local.dsn#">
								update loadstops set 
								stopdate=<cfqueryparam cfsqltype="cf_sql_date" value="#variables.todayDate#">
								where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
								and LoadStops.LoadType =<cfqueryparam cfsqltype="cf_sql_integer"value="2">
								and StopNo=<cfqueryparam cfsqltype="cf_sql_integer"value="#variables.count#">
							</cfquery>
						</cfif>	
					</cfif>	
				</cfif>
				<cfset variables.count++>
			</cfloop>
			<cfquery name="qrygetDeliveryDate" datasource="#local.dsn#">
				Select  max(stopdate) as stopdate from loadstops
				where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
				and LoadStops.LoadType =<cfqueryparam cfsqltype="cf_sql_integer"value="2">
			</cfquery>
			<cfquery name="qryUpdateShipDetailsInstops3" datasource="#local.dsn#">
				update loads set 
				NEWDELIVERYdATE=<cfqueryparam cfsqltype="cf_sql_date" value="#qrygetDeliveryDate.stopdate#">
				where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
			</cfquery>
			
			<cfif len(trim(arguments.statustext))>
				<cfquery name="qryUpdateStatus" datasource="#local.dsn#">
					update loads set 
					StatusTypeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.statustext#">
					where loadid=<cfqueryparam cfsqltype="cf_sql_varchar"value="#qryGetLoadDetails.loadid#">
				</cfquery> 
				<cfset arrayappend(local.LoadStatus,#qryGetLoadDetails.loadnumber#)>
			</cfif>	
			<cfif request.qSystemSetupOptions.freightbroker eq 1>
				<cfif arguments.statustext neq 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44'>
					<cfif qryGetAgentdetails.loadBoard123 EQ 1>
						<cfif qryGetAgentdetails.loadBoard123Usename neq "" and qryGetAgentdetails.loadBoard123Password neq "">
							<cfif qryGetLoadDetails.postto123loadboard eq 1>	
								<cfset p_action = 'D'>
								<cfset StructInsert(frmstruct,"loadBoard123Username",#qryGetAgentdetails.loadBoard123Usename#,"yes")>
								<cfset StructInsert(frmstruct,"loadBoard123Password",#qryGetAgentdetails.loadBoard123Password#,"yes")>
								<cfset StructInsert(frmstruct,"loadnumber",#qryGetLoadDetails.loadnumber#,"yes")>
								<cfset StructInsert(frmstruct,"appDsn",#local.dsn#,"yes")>
								<cfinvoke method="callLoadboardWebservice"  p_action="#p_action#" frmstruct="#frmstruct#"  returnvariable="responseLoadboardWebserviceDelete"/>
								<cfif  variables.statutextLoadBoardDeletionOccured>
									<cfset p_action = 'A'>
									<cfinvoke method="callLoadboardWebservice" p_action="#p_action#" frmstruct="#frmstruct#"  returnvariable="responseLoadboardWebservice"/>
									<cfif responseLoadboardWebservice eq '123Loadboard Says : Your are successfully posted to 123 LoadBoard'>
										<cfset arrayappend(local.Loadbord123,#qryGetLoadDetails.loadnumber#)>
									<cfelse>
										<cfset arrayappend(local.LoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.responseLoadboardWebservice#)> 
									</cfif>	
								<cfelse>
									<cfif findNoCase("sucessfully deleted", "#responseLoadboardWebserviceDelete#")>
										<cfset arrayappend(local.Loadbord123Deleted,#qryGetLoadDetails.loadnumber#)>
									</cfif>
								</cfif>	
							</cfif>	
						</cfif>	
					</cfif>	
					<cfif qryGetAgentdetails.INTEGRATEWITHTRAN360 EQ 1>
						<cfif qryGetAgentdetails.TRANS360PASSWORD neq "" and qryGetAgentdetails.TRANS360USENAME neq "">
							<cfif qryGetLoadDetails.IsTransCorePst eq 1>
								<cfset p_action='D'>
								<cfinvoke method="Transcore360Webservice" impref="#qryGetLoadDetails.loadnumber#" dsn="#local.dsn#" trans360Usename="#qryGetAgentdetails.TRANS360USENAME#" trans360Password="#qryGetAgentdetails.TRANS360PASSWORD#" POSTACTION="#p_action#" returnvariable="request.Transcore360WebserviceDelete" />
								<cfif variables.statutextLoadBoardDeletionOccured>
									<cfset p_action = 'A'>
									<cfinvoke method="Transcore360Webservice" impref="#qryGetLoadDetails.loadnumber#" dsn="#local.dsn#" trans360Usename="#qryGetAgentdetails.TRANS360USENAME#" trans360Password="#qryGetAgentdetails.TRANS360PASSWORD#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
									<cfif request.Transcore360Webservice eq 'DAT Loadboard Says : You have successfully posted to Dat Loadboard'>
										<cfset arrayappend(local.datLoadbord,#qryGetLoadDetails.loadnumber#)>
									<cfelse>
										<cfset arrayappend(local.datLoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.Transcore360Webservice#)> 
									</cfif>	
								<cfelse>
									<cfif request.Transcore360WebserviceDelete eq 'DAT Loadboard Says : You have successfully deleted from Dat Loadboard'>
										<cfset arrayappend(local.datLoadbordDeleted,#qryGetLoadDetails.loadnumber#)>
									</cfif>
								</cfif>	
							</cfif>
						</cfif>		
					</cfif>
					<cfif request.qSystemSetupOptions.IntegrateWithITS EQ 1>
						<cfif request.qSystemSetupOptions.ITSUserName neq "" and request.qSystemSetupOptions.ITSPassword neq "">
							<cfif qryGetLoadDetails.posttoITS eq 1>
								<cfset p_action = 'D'>
								<cfset ITS_msgDelete = ITSWebservice(#qryGetLoadDetails.loadnumber#, p_action, #request.qSystemSetupOptions.ITSUserName#, #request.qSystemSetupOptions.ITSPassword#, #qryGetAgentdetails.IntegrationID#,#qryGetLoadDetails.loadnumber#,#local.dsn#)>
								<cfif  variables.statutextLoadBoardDeletionOccured>
									<cfset p_action = 'A'>
									<cfset ITS_msg = ITSWebservice(#qryGetLoadDetails.loadnumber#, p_action, #request.qSystemSetupOptions.ITSUserName#, #request.qSystemSetupOptions.ITSPassword#, #qryGetAgentdetails.IntegrationID#,#qryGetLoadDetails.loadnumber#,#local.dsn#)>
									<cfif ITS_msg eq 1>
										<cfset arrayappend(local.loadboardits,#qryGetLoadDetails.loadnumber#)>
									<cfelse>
										<!--- <cfset arrayappend(local.datLoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.ItsWebservice#)>  --->
									</cfif>	
								<cfelse>
									<cfif ITS_msgDelete eq 1>
										<cfset arrayappend(local.loadboarditsDeleted,#qryGetLoadDetails.loadnumber#)>
									</cfif>	
								</cfif>	
							</cfif>
						</cfif>		
					</cfif>
					<cfif request.qSystemSetupOptions.integratewithPEP eq 1>
						<cfif request.qSystemSetupOptions.PEPsecretKey neq "" and request.qSystemSetupOptions.PEPcustomerKey neq "">
							<cfif qryGetLoadDetails.ISPOST eq 1>
								<cfif variables.statutextLoadBoardDeletionOccured>
									<cfset p_action = 'A'>
									<cfinvoke method="Posteverywhere" impref="#qryGetLoadDetails.loadnumber#" PEPcustomerKey="#request.qSystemSetupOptions.PEPcustomerKey#" PEPsecretKey="#request.qSystemSetupOptions.PEPsecretKey#" POSTACTION="#p_action#" dsn="#local.dsn#"  returnvariable="request.postevrywhere" />
								
									<cfif request.postevrywhere eq 1>
										<cfset arrayappend(local.posteveryWhere,#qryGetLoadDetails.loadnumber#)>
									</cfif>	
								<cfelse>
									<!--- <cfif request.postevrywhereDelete eq 'DAT Loadboard Says : You have successfully deleted from Dat Loadboard'>
										<cfset arrayappend(local.posteveryWhereDeleted,#qryGetLoadDetails.loadnumber#)>
									</cfif> --->
								</cfif>	
							</cfif>
						</cfif>		
					</cfif>	
				<cfelse>
					<cfif arguments.postits eq 1>
						<cfif request.qSystemSetupOptions.IntegrateWithITS EQ 1>
							<cfif request.qSystemSetupOptions.ITSUserName neq "" and request.qSystemSetupOptions.ITSPassword neq "">
								<cfif  variables.statutextLoadBoardDeletionOccured>
									<cfif qryGetLoadDetails.posttoITS eq 1>
										<cfset p_action = 'U'>
										<cfset ITS_msg = ITSWebservice(#qryGetLoadDetails.loadnumber#, p_action, #request.qSystemSetupOptions.ITSUserName#, #request.qSystemSetupOptions.ITSPassword#, #qryGetAgentdetails.IntegrationID#,#qryGetLoadDetails.loadnumber#,#local.dsn#)>
										<cfif ITS_msg eq 1>
											<cfset arrayappend(local.loadboardits,#qryGetLoadDetails.loadnumber#)>
										<cfelse>
											<!--- <cfset arrayappend(local.datLoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.ItsWebservice#)>  --->
										</cfif>		
									<cfelse>
										<cfset p_action = 'A'>
										<cfset ITS_msg = ITSWebservice(#qryGetLoadDetails.loadnumber#, p_action, #request.qSystemSetupOptions.ITSUserName#, #request.qSystemSetupOptions.ITSPassword#, #qryGetAgentdetails.IntegrationID#,#qryGetLoadDetails.loadnumber#,#local.dsn#)>
										<cfif ITS_msg eq 1>
											<cfset arrayappend(local.loadboardits,#qryGetLoadDetails.loadnumber#)>
										<cfelse>
											<!--- <cfset arrayappend(local.datLoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.ItsWebservice#)>  --->
										</cfif>		
									</cfif>	
								</cfif>	
							</cfif>		
						</cfif>
					</cfif>	
					<cfif arguments.posteverywhere eq 1>
						<!--- <cfif request.qSystemSetupOptions.integratewithPEP eq 1>
							<cfif request.qSystemSetupOptions.PEPsecretKey neq "" and request.qSystemSetupOptions.PEPcustomerKey neq "">
								<cfif qryGetLoadDetails.ISPOST eq 1>
									<cfif variables.statutextLoadBoardDeletionOccured>
										<cfset p_action = 'A'>
										<cfinvoke method="Posteverywhere" impref="#qryGetLoadDetails.loadnumber#" PEPcustomerKey="#request.qSystemSetupOptions.PEPcustomerKey#" PEPsecretKey="#request.qSystemSetupOptions.PEPsecretKey#" POSTACTION="#p_action#" dsn="#local.dsn#"  returnvariable="request.postevrywhere" />
									
										<cfif request.postevrywhere eq 1>
											<cfset arrayappend(local.posteveryWhere,#qryGetLoadDetails.loadnumber#)>
										</cfif>	
									<cfelse>
										<!--- <cfif request.postevrywhereDelete eq 'DAT Loadboard Says : You have successfully deleted from Dat Loadboard'>
											<cfset arrayappend(local.posteveryWhereDeleted,#qryGetLoadDetails.loadnumber#)>
										</cfif> --->
									</cfif>	
								</cfif>
							</cfif>		
						</cfif>	 --->
					</cfif>	
					<cfif arguments.post123loadboard eq 1>
						<cfif qryGetAgentdetails.loadBoard123 EQ 1>
							<cfif qryGetAgentdetails.loadBoard123Usename neq "" and qryGetAgentdetails.loadBoard123Password neq "">
								<cfif  variables.statutextLoadBoardDeletionOccured>
									<cfset StructInsert(frmstruct,"loadBoard123Username",#qryGetAgentdetails.loadBoard123Usename#,"yes")>
									<cfset StructInsert(frmstruct,"loadBoard123Password",#qryGetAgentdetails.loadBoard123Password#,"yes")>
									<cfset StructInsert(frmstruct,"loadnumber",#qryGetLoadDetails.loadnumber#,"yes")>
									<cfset StructInsert(frmstruct,"appDsn",#local.dsn#,"yes")>	
									<cfif qryGetLoadDetails.postto123loadboard eq 1>
										<cfset p_action = 'U'>
										<cfinvoke method="callLoadboardWebservice" p_action="#p_action#" frmstruct="#frmstruct#"  returnvariable="responseLoadboardWebservice"/>
										<cfif responseLoadboardWebservice eq '123Loadboard Says : Your are successfully posted to 123 LoadBoard'>
											<cfset arrayappend(local.Loadbord123,#qryGetLoadDetails.loadnumber#)>
										<cfelse>
											<cfset arrayappend(local.LoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.responseLoadboardWebservice#)> 
										</cfif>	
									<cfelse>
										<cfset p_action = 'U'>
										<cfinvoke method="callLoadboardWebservice" p_action="#p_action#" frmstruct="#frmstruct#"  returnvariable="responseLoadboardWebservice"/>
										
										<cfif responseLoadboardWebservice eq '123Loadboard Says : Your are successfully posted to 123 LoadBoard'>
											<cfset arrayappend(local.Loadbord123,#qryGetLoadDetails.loadnumber#)>
										<cfelse>
											<cfset arrayappend(local.LoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.responseLoadboardWebservice#)> 
										</cfif>	
									</cfif>	
								</cfif>	
							</cfif>	
						</cfif>	
					</cfif>	
					<cfif arguments.postdatloadboard eq 1>
						<cfif qryGetAgentdetails.INTEGRATEWITHTRAN360 EQ 1>
							<cfif qryGetAgentdetails.TRANS360PASSWORD neq "" and qryGetAgentdetails.TRANS360USENAME neq "">
								<cfif variables.statutextLoadBoardDeletionOccured>
									<cfif qryGetLoadDetails.IsTransCorePst eq 1>
										<cfset p_action = 'U'>
										<cfinvoke method="Transcore360Webservice" impref="#qryGetLoadDetails.loadnumber#" dsn="#local.dsn#" trans360Usename="#qryGetAgentdetails.TRANS360USENAME#" trans360Password="#qryGetAgentdetails.TRANS360PASSWORD#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
										<cfif request.Transcore360Webservice eq 'DAT Loadboard Says : You have successfully posted to Dat Loadboard'>
											<cfset arrayappend(local.datLoadbord,#qryGetLoadDetails.loadnumber#)>
										<cfelse>
											<cfset arrayappend(local.datLoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.Transcore360Webservice#)> 
										</cfif>	
									<cfelse>
										<cfset p_action = 'A'>
										<cfinvoke method="Transcore360Webservice" impref="#qryGetLoadDetails.loadnumber#" dsn="#local.dsn#" trans360Usename="#qryGetAgentdetails.TRANS360USENAME#" trans360Password="#qryGetAgentdetails.TRANS360PASSWORD#" POSTACTION="#p_action#" returnvariable="request.Transcore360Webservice" />
										<cfif request.Transcore360Webservice eq 'DAT Loadboard Says : You have successfully posted to Dat Loadboard'>
											<cfset arrayappend(local.datLoadbord,#qryGetLoadDetails.loadnumber#)>
										<cfelse>
											<cfset arrayappend(local.datLoadbordNotPosted,#qryGetLoadDetails.loadnumber#&'$'&#request.Transcore360Webservice#)> 
										</cfif>	
									</cfif>	
								</cfif>	
							</cfif>		
						</cfif>
					</cfif>	
				</cfif>		
			</cfif> 
		</cfloop> 
		 <cfset local.datLoadbord=arraytolist(local.datLoadbord,", ")>
		 <cfset local.Loadbord123=arraytolist(local.Loadbord123,", ")>
		 <cfset local.UpdatedShipDate=arraytolist(local.UpdatedShipDate,", ")>
		 <cfset local.LoadStatus=arraytolist(local.LoadStatus,", ")>
		 <cfset local.loadboardits=arraytolist(local.loadboardits,", ")>
		 <cfset local.loadboarditsDeleted=arraytolist(local.loadboarditsDeleted,", ")>
		 <cfset local.datLoadbordDeleted=arraytolist(local.datLoadbordDeleted,", ")>
		 <cfset local.Loadbord123Deleted=arraytolist(local.Loadbord123Deleted,", ")>
		<cfset local.status=true>
		<cfset local.LoadBoardDeletionOccuredStatus=variables.statutextLoadBoardDeletionOccured>
		<cfreturn  serializeJSON(local)>
	</cffunction >
</cfcomponent>	