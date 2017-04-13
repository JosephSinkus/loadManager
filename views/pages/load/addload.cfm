
<!--- ::::: 
---------------------------------
Changing 571 Line Extra line comment of consigneeZipcode already use in getdistance.cfm page
---------------------------------
::::: --->
<!--- Start timing test ---> 
<cfoutput>
    <script type="text/javascript">
        $( document ).ready(function() {
            for(i=2;i<11;i++){
                $("##totalResult"+i).val(0);
            }  
        });
    </script> 

    <style>
        span.iconediting {
            position: absolute;
            right: -10px;
            top: 3px;
            font-size: 20px;
        }
    </style>
	<cfparam name="variables.totalStopcount" default="2">
	<cfparam name="variables.totalStopcounts" default="1">
	<cfset includeTemplate("views/pages/load/cleanJavaScriptData.cfm") />
	<cfparam name="url.loadid" default="0">
	
	<cfset variables.loaddisabledStatus=false>
	<cfif ( structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1 )>
		<cfset session.currentloadid=url.loadid>
		<script>
			$(document).ready(function(){
				//when the page loads for load edit ajax call for inserting tab id of the page details
				var path = urlComponentPath+"loadgateway.cfc?method=insertTabDetails";
				$.ajax({
                type: "Post",
                url: path,		
                dataType: "json",
                async: false,
				data: {
					tabID:tabID,loadid:'#url.loadid#',userid:'#session.empid#',sessionid:'#session.sessionid#',dsn:'#application.dsn#'
				},
                success: function(data){
                 console.log(data);
                }
              });
			});
		</script>
		<!---Object to get corresponding roleid of user--->
		<cfinvoke component="#variables.objAgentGateway#" method="getRoleid" returnvariable="request.qryGetRoleId" employeID="#session.empid#" />
		<!---Object to get corresponding user edited the load--->
		<cfinvoke component="#variables.objloadGateway#" method="getUserEditingDetails" loadid="#loadID#" returnvariable="request.qryUserEditingDetails"/>
		<!---Condition to check user edited the load or not--->
		<cfif not len(trim(request.qryUserEditingDetails.InUseBy))>
			<!---Object to update corresponding user edited the load--->
			<cfinvoke component="#variables.objloadGateway#" method="updateEditingUserId" loadid="#loadID#" userid="#session.empid#" status="false"/>
		<cfelse>
			<!---Object to get corresponding Previously edited---->
			<cfinvoke component="#variables.objAgentGateway#" method="getEditingUserName" returnvariable="request.qryGetEditingUserName" employeID="#request.qryUserEditingDetails.inuseby#" />
			<!---Condition to check current employee and previous editing employee are not same--->
			<cfif session.empid neq request.qryUserEditingDetails.inuseby>
				<cfif request.qryGetEditingUserName.recordcount>
					<cfset variables.loaddisabledStatus=true>
					<div class="msg-area" style="margin-left:10px;margin-bottom:10px">
						<span style="color:##d21f1f">This load locked because it is currently being edited by #request.qryGetEditingUserName.Name# #dateformat(request.qryUserEditingDetails.inuseon,"mm/dd/yy hh:mm:ss")#.
							An Administrator can manually override this lock by clicking the unlock button.
						</span>	
					</div>
				</cfif>	
			</cfif>	
		</cfif>
	</cfif>
</cfoutput>
<cfinvoke component="#variables.objloadGateway#" method="getLoadSystemSetupOptions" returnvariable="request.qSystemSetupOptions1" />
<cfinvoke component="#variables.objloadGateway#" method="getCompanyInformation" returnvariable="request.qGetCompanyInformation" />
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qSystemSetupOptions" /> 
<cfinvoke component="#variables.objloadGateway#" method="getLoadCarriersMails" loadid="#url.loadid#" returnvariable="request.qcarriers" />
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentdetails" returnvariable="request.qcurAgentdetails" employeID="#session.empid#" />
<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurMailAgentdetails" employeID="#session.empid#" />
<cfset tickBegin = GetTickCount()>
<cfoutput>
    <cfif request.qcurMailAgentdetails.recordcount gt 0 and (request.qcurMailAgentdetails.SmtpAddress eq "" or request.qcurMailAgentdetails.SmtpUsername eq "" or request.qcurMailAgentdetails.SmtpPort eq "" or request.qcurMailAgentdetails.SmtpPassword eq "" or request.qcurMailAgentdetails.SmtpPort eq 0)>
        <cfset mailsettings = "false">
    <cfelse>
        <cfset mailsettings = "true">
    </cfif>
    <cfset variables.statusDispatch='Customer Invoice'>
    <cfif request.qSystemSetupOptions.freightBroker>
        <cfset variables.freightBroker = "Carrier">
        <cfset variables.freightBrokerShortForm = "Carr">
        <cfset variables.freightBrokerReport = "Carrier">
    <cfelse>
        <cfset variables.freightBroker = "Driver">
        <cfset variables.freightBrokerShortForm = "Driv">
        <cfset variables.freightBrokerReport = "Dispatch">
    </cfif>

    <cfparam name="url.editid" default="0">
    <cfparam name="url.loadToBeCopied" default="0">
    <cfparam name="LoadNumber" default="">
    <cfparam name="NewcustomerID" default="0">
    <cfparam name="LOADSTOPID" default="">
    <cfparam name="loadStatus" default="">
    <cfparam name="Salesperson" default="">
    <cfparam name="Dispatcher" default="">
    <cfparam name="Notes" default="">
    <cfparam name="IsPartial" default="0">
    <cfparam name="posttoITS" default="">
    <cfparam name="posttoloadboard" default="0">
    <cfparam name="postto123loadboard" default="0">
    <cfparam name="postFlagStatus" default="0">
    <cfparam name="posttoTranscore" default="0">
    <cfparam name="ARExported" default="0">
    <cfparam name="APExported" default="0">
    <cfparam name="CustomerRatePerMile" default="0">
    <cfparam name="CarrierRatePerMile" default="0">
    <cfparam name="TotalCustomerCharges" default="0">
    <cfparam name="TotalCarrierCharges" default="0">
    <cfparam name="TotalCustcommodities" default="0">
    <cfparam name="TotalCarcommodities" default="0">
    <cfparam name="dispatchNotes" default="">
    <cfparam name="carrierNotes" default="">
    <cfparam name="StatusDispatchNotes" default="">
    <cfparam name="customerID" default="">
    <cfparam name="isPayer" default="">
    <cfparam name="shipIsPayer" default="">
    <cfparam name="carrierID" default="">
    <cfparam name="customerPO" default="">
    <cfparam name="BOLNum" default="">
    <cfparam name="loadCustomerName" default="">
    <cfparam name="ShipCustomerStopName" default="">
    <cfparam name="ShipIsPayer" default="">
    <cfparam name="ConsineeCustomerStopName" default="">
    <cfparam name="shipperCustomerID" default="">
    <cfparam name="consigneeCustomerID" default="">
    <cfparam name="Invoicenumber" default="0">
	<cfparam name="CarrierInvoiceNumber" default="">
    <cfparam name="consigneeLoadStopId" default="">
    <cfparam name="totalProfit" default="0">
    <cfparam name="PricingNotes" default="">
    <cfparam name="perc" default="0">
    <cfparam name="Shiplocation" default="">
    <cfparam name="Shipcity" default="">
    <cfparam name="Shipstate1" default="">
    <cfparam name="Shipzipcode" default="">
    <cfparam name="ShipcontactPerson" default="">
    <cfparam name="ShipPhone" default="">
    <cfparam name="Shipfax" default="">
    <cfparam name="Shipemail" default="">
    <cfparam name="ShipPickupNo" default="">
    <cfparam name="ShippickupDate" default="">
    <cfparam name="ShippickupTime" default="">
    <cfparam name="ShiptimeIn" default="">
    <cfparam name="ShiptimeOut" default="">
    <cfparam name="ShipInstructions" default="">
    <cfparam name="Shipdirection" default="">
    <cfparam name="Consigneelocation" default="">
    <cfparam name="Consigneecity" default="">
    <cfparam name="Consigneestate1" default="">
    <cfparam name="Consigneezipcode" default="">
    <cfparam name="ConsigneecontactPerson" default="">
    <cfparam name="ConsigneePhone" default="">
    <cfparam name="Consigneefax" default="">
    <cfparam name="Consigneeemail" default="">
    <cfparam name="ConsigneePickupNo" default="">
    <cfparam name="ConsigneepickupDate" default="">
    <cfparam name="ConsigneepickupTime" default="">
    <cfparam name="ConsigneetimeIn" default="">
    <cfparam name="ConsigneetimeOut" default="">
    <cfparam name="ConsigneeInstructions" default="">
    <cfparam name="Consigneedirection" default="">
    <cfparam name="shipBlind" default="False">
    <cfparam name="ConsBlind" default="False">
    <cfparam name="bookedwith1" default="">
    <cfparam name="equipment1" default="">
    <cfparam name="driver" default="">
    <cfparam name="driverCell" default="">
    <cfparam name="truckNo" default="">
    <cfparam name="TrailerNo" default="">
    <cfparam name="refNo" default="">
    <cfparam name="milse" default="0">
    <cfparam name="stofficeid" default="">
    <cfparam name="editid" default="0">
    <cfparam name="statename" default="0">
    <cfparam name="rdyDate" default="">
    <cfparam name="ariveDate" default="">
    <cfparam name="isExcused" default="0">
    <cfparam name="bookedBy" default="">
    <cfparam name="IsITSPst" default="0">
    <cfparam name="Is123LoadBoardPst" default="0">
    <cfparam name="customerrate" default="">
    <cfparam name="carrierrate" default="0">
    <cfparam name="consigneeIsPayer" default="0">
    <cfparam name="request.LoadStopInfoShipper.userDef1" default="">
    <cfparam name="request.LoadStopInfoShipper.userDef2" default="">
    <cfparam name="request.LoadStopInfoShipper.userDef3" default="">
    <cfparam name="request.LoadStopInfoShipper.userDef4" default="">
    <cfparam name="request.LoadStopInfoShipper.userDef5" default="">
    <cfparam name="request.LoadStopInfoShipper.userDef6" default="">
    <cfparam name="variables.flagstatus" default="0">
    <cfparam name="variables.flagstatusConsignee" default="0">
    <cfparam name="weight1" default="0">
    <cfparam name="userDefinedFieldTrucking" default="">
    <cfparam name="variables.custAdvancepayments" default="0">
    <cfparam name="variables.carrierAdvancepayments" default="0">

<!--- Encrypt String --->
    <cfset Secret = application.dsn>
    <cfset TheKey = 'NAMASKARAM'>
    <cfset Encrypted = Encrypt(Secret, TheKey)>
    <cfset dsn = ToBase64(Encrypted)>
    <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qStates" />
    <cfinvoke component="#variables.objequipmentGateway#" method="getloadEquipments" returnvariable="request.qEquipments" />
    <cfinvoke component="#variables.objunitGateway#" method="getloadUnits" status="True" returnvariable="request.qUnits" />
    <cfinvoke component="#variables.objclassGateway#" method="getloadClasses" status="True" returnvariable="request.qClasses" />
    <cfinvoke component="#variables.objCarrierGateway#" method="getCarrierOffice" returnvariable="qoffices"/>

    <cfquery  name="request.qoffices" datasource="#application.dsn#">
        select CarrierOfficeID,location,carrierID from carrieroffices  where location <> '' and carrierID=null
        ORDER BY Location ASC
    </cfquery>
   
    <cfinvoke component="#variables.objloadGateway#" AuthLevelId="1,3,4" method="getloadSalesPerson" returnvariable="request.qSalesPerson" />
    <cfinvoke component="#variables.objloadGateway#" AuthLevelId="3" method="getloadSalesPerson" returnvariable="request.qDispatcher" />
    <cfinvoke component="#variables.objloadGateway#" AuthLevelId="4" method="getloadSalesPerson" returnvariable="request.qBookedBy" />
  
  
    <cfset NoOfStopsToShow = 0>
    <cfset loadID = "">

    <cfif  structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
        <cfset loadID = url.loadid>
    <cfelseif structkeyexists(url,"loadToBeCopied") and len(trim(url.loadToBeCopied)) gt 1>
        <cfset loadID = url.loadToBeCopied>
    </cfif>
    <cfset DispatchNotesToShow = request.qSystemSetupOptions.DispatchNotes>
    <cfset CarrierNotesToShow = request.qSystemSetupOptions.CarrierNotes>
    <cfset PricingNotesToShow = request.qSystemSetupOptions.PricingNotes>
    <cfset NotesToShow = request.qSystemSetupOptions.Notes>
    <cfset StatusDispatchNotesToShow = request.qSystemSetupOptions.statusdispatchnotes>
    <cfif ( structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1 ) OR ( structkeyexists(url,"loadToBeCopied")  and len(trim(url.loadToBeCopied)) gt 1 )>
        <cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#loadID#" stopNo="0" returnvariable="request.qLoads" />
        <cfinvoke component="#variables.objloadGateway#" method="getAllStopsCount" loadid="#loadID#"  returnvariable="request.loadstopcount" />
        <cfinvoke component="#variables.objloadGateway#" method="getAdvancepaymentDetails" loadid="#loadID#"  returnvariable="request.loadAdvancePayment" />
    	<cfinvoke component="#variables.objloadGateway#" method="getAllItems" LOADSTOPID="#request.qLoads.shipperLoadStopID#" returnvariable="request.qItems" />
        <cfinvoke component="#variables.objloadGateway#" method="getNoOfStops" LOADID="#loadID#" returnvariable="request.NoOfStops" />
    	<cfinvoke component="#variables.objloadGateway#" method="getIsPayer"  loadid="#loadID#"  returnvariable="request.payer" />
    	<cfinvoke component="#variables.objloadGateway#" method="loadBoardFlagStatus"  loadid="#loadID#"  returnvariable="request.loadBoardFlag" />

        <cfif request.loadAdvancePayment.recordcount>
            <cfset variables.custAdvancepayments=request.loadAdvancePayment.CUSTPAYMENTS>
            <cfset variables.carrierAdvancepayments=request.loadAdvancePayment.PAYMENTS>
        </cfif>

        <cfset isPayer = request.payer.isPayer>
        <cfset NoOfStopsToShow = request.NoOfStops>
        <cfset url.editid=loadID>
        <cfset session.AllInfo.editid = loadid>
        <cfset loadID=loadID>
        <cfset session.AllInfo.loadid=loadID>
        <cfset LoadNumber = request.qLoads.LoadNumber>
        <cfset session.AllInfo.loadnumber = request.qLoads.LoadNumber>
        <cfset LOADSTOPID = request.qLoads.LOADSTOPID>
        <cfset session.AllInfo.LOADSTOPID = request.qLoads.LOADSTOPID>
        <cfset loadStatus=request.qLoads.STATUSTYPEID>
        <cfset Salesperson=request.qLoads.SALESREPID>
        <cfset Dispatcher=request.qLoads.DISPATCHERID>
        <cfset Notes=request.qLoads.NEWNOTES>
        <cfset posttoTranscore=request.qLoads.IsTransCorePst>
        <cfset userDefinedFieldTrucking=request.qLoads.userDefinedFieldTrucking>
        <cfset weight1=request.qLoads.weight>
        <cfset posttoloadboard=request.qLoads.ISPOST>
        <cfset postto123loadboard=request.qLoads.postto123loadboard>
        <cfset ARExported=request.qLoads.ARExportedNN>
        <cfset APExported=request.qLoads.APExportedNN>
        <cfset CustomerRate=request.qLoads.CUSTFLATRATE>
        <cfset CarrierRate=request.qLoads.CARRFLATRATE>
        <cfset customerID = request.qLoads.payerID>
        <cfset CustomerRatePerMile = request.qLoads.CustomerRatePerMile>
        <cfset CarrierRatePerMile = request.qLoads.CarrierRatePerMile>
        <cfset TotalCustomerCharges=request.qLoads.TotalCustomerCharges>
        <cfset session.AllInfo.TotalCustomerCharges=request.qLoads.TotalCustomerCharges>
        <cfset TotalCarrierCharges=request.qLoads.TotalCarrierCharges>
        <cfset session.AllInfo.TotalCarrierCharges=request.qLoads.TotalCarrierCharges>
        <cfset dispatchNotes=request.qLoads.NEWDISPATCHNOTES>
        <cfset NewcustomerID=request.qLoads.PAYERID>
        <cfset session.AllInfo.NewcustomerID=request.qLoads.PAYERID>
        <cfset carrierID=request.qLoads.NEWCARRIERID>
        <cfset IsPartial=request.qLoads.IsPartial>
        <cfset carrierNotes=request.qLoads.carrierNotes>
        <cfset PricingNotes=request.qLoads.PricingNotes>
        <cfset ariveDate = request.qLoads.arriveDate>
        <cfset rdyDate = request.qLoads.readyDate>
        <cfset isExcused = request.qLoads.isExcused>
        <cfset bookedBy = request.qLoads.bookedBy>
        <cfset posttoITS = request.qLoads.posttoITS>
        <cfset postFlagStatus=request.loadBoardFlag.flag>

        <cfquery name="qryGetLoadNumberAssignment" datasource="#application.dsn#">
            SELECT loadNumberAssignment FROM SystemConfig
        </cfquery>

        <cfif qryGetLoadNumberAssignment.loadNumberAssignment gt 0>
            <cfswitch expression="#loadStatus#">
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
                
    			<cfcase value="C4d98C6D-018A-41BD-8807-58D0DE1BB0F8">
    				<cfset variables.loadNumberAssignment=6>
    			</cfcase>
                
    			<cfcase value="E62ACAA8-804B-4B00-94E0-3FE7B081C012">
    				<cfset variables.loadNumberAssignment=7>
    			</cfcase>
                
    			<cfcase value="c4d98c6d-018a-41bd-8807-58d0df1bb0f8">
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
    	<cfif variables.loadNumberAssignment gte qryGetLoadNumberAssignment.loadNumberAssignment>
    		<cfset Invoicenumber=request.qLoads.invoiceNumber>
    	<cfelse>
    		<cfset Invoicenumber=0>
    	</cfif>
		
		<cfif val(request.qLoads.CarrierInvoiceNumber) GT 0 >
			<cfset CarrierInvoiceNumber = request.qLoads.CarrierInvoiceNumber >
		</cfif>
		
        <cfif len(carrierID) gt 1>
            <cfquery  name="request.qoffices"  dbtype="query">
                select CarrierOfficeID,location from request.qoffices  where location <> '' and carrierID='#carrierID#'
                ORDER BY Location ASC
            </cfquery>
        </cfif>

        <cfset carrierIDNew=request.qLoads.NEWCARRIERID>
        <cfset session.AllInfo.carrierID=request.qLoads.NEWCARRIERID>
        <cfset customerPO=request.qLoads.CUSTOMERPONO>
        <cfset session.AllInfo.customerPO=request.qLoads.CUSTOMERPONO>
        <cfset stofficeid = request.qLoads.NEWofficeID>
        <cfset BOLNum=request.qLoads.BOLNum>
        <cfset request.ShipperStop = request.qLoads>
        <cfinvoke component="#variables.objloadGateway#" method="getLoadStopInfo" StopNo="0" LoadType="1" loadID="#loadID#" returnvariable="request.LoadStopInfoShipper" />
        <cfset ShipCustomerStopName=request.ShipperStop.ShipperStopName>
        <cfset shipperCustomerID=request.ShipperStop.shipperCustomerID>
        <cfset shiplocation=trim(request.ShipperStop.shipperLocation)>
        <cfset session.AllInfo.shiplocation=trim(request.ShipperStop.shipperLocation)>
        <cfset shipcity=request.ShipperStop.ShipperCity>
        <cfset shipstate1=request.ShipperStop.shipperState>
        <cfset shipzipcode=request.ShipperStop.shipperPostalcode>
        <cfset shipcontactPerson=request.ShipperStop.shipperContactPerson>
        <cfset session.AllInfo.shipcontactPerson=request.ShipperStop.shipperContactPerson>
        <cfset shipPhone=request.ShipperStop.shipperPhone>
        <cfset session.AllInfo.shipPhone=request.ShipperStop.shipperPhone>
        <cfset shipfax=request.ShipperStop.shipperFax>
        <cfset session.AllInfo.shipfax=request.ShipperStop.shipperFax>
        <cfset shipemail=request.ShipperStop.shipperemailId>
        <cfset shipPickupNo=request.ShipperStop.ShipperReleaseNo>
        <cfset session.AllInfo.shipPickupNo=request.ShipperStop.ShipperReleaseNo>
        <cfset shippickupDate=request.LoadStopInfoShipper.StopDate>
        <cfset session.AllInfo.shippickupDate=request.LoadStopInfoShipper.StopDate>
        <cfset shippickupTime=request.LoadStopInfoShipper.StopTime>
        <cfset shiptimeIn=request.LoadStopInfoShipper.TimeIn>
        <cfset shiptimeOut=request.LoadStopInfoShipper.TimeOut>
        <cfinvoke component="#variables.objloadGateway#" method="getPayerStop" stopID="#request.LoadStopInfoShipper.loadstopid#" returnvariable="request.shipIsPayer" />

        <cfif request.shipIsPayer.recordcount>
            <cfset shipIsPayer = request.shipIsPayer.IsPayer>
        <cfelse>
            <cfset shipIsPayer = 0>
        </cfif>

        <cfset shipBlind=request.ShipperStop.ShipperBlind>
        <cfset shipInstructions=trim(request.ShipperStop.ShipperInstructions)>
        <cfset session.AllInfo.shipInstructions=trim(request.ShipperStop.ShipperInstructions)>
        <cfset Shipdirection =trim(request.ShipperStop.ShipperDirections)>
        <cfset consigneeLoadStopId=request.qLoads.consigneeLoadStopID>
        <cfset loadCustomerName = request.qLoads.CustomerName>
        <cfset request.ConsineeStop = request.qLoads>

        <cfinvoke component="#variables.objloadGateway#" method="getLoadStopInfo" StopNo="0"  LoadType="2" loadID="#loadID#" returnvariable="request.LoadStopInfoConsignee" />

        <cfset ConsineeCustomerStopName=request.ConsineeStop.consigneeStopName>
        <cfset consigneeCustomerID=request.ConsineeStop.consigneeCustomerID>
        <cfset consigneelocation=trim(request.ConsineeStop.consigneeLocation)>
        <cfset session.AllInfo.consigneelocation=trim(request.ConsineeStop.consigneeLocation)>
        <cfset consigneecity=request.ConsineeStop.consigneecity>
        <cfset consigneestate1=request.ConsineeStop.consigneeState>
        <cfset consigneezipcode=request.ConsineeStop.consigneepostalcode>
        <cfset consigneecontactPerson=request.ConsineeStop.consigneeContactPerson>
        <cfset session.AllInfo.consigneecontactPerson=request.ConsineeStop.consigneeContactPerson>
        <cfset consigneePhone=request.ConsineeStop.consigneePhone>
        <cfset session.AllInfo.consigneePhone=request.ConsineeStop.consigneePhone>
        <cfset consigneefax=request.ConsineeStop.consigneefax>
        <cfset session.AllInfo.consigneefax=request.ConsineeStop.consigneefax>
        <cfset consigneeemail=request.ConsineeStop.consigneeemailId>
        <cfset consigneePickupNo=request.ConsineeStop.consigneeReleaseNo>
        <cfset session.AllInfo.consigneePickupNo=request.ConsineeStop.consigneeReleaseNo>
        <cfset consigneepickupDate=request.LoadStopInfoConsignee.StopDate>
        <cfset session.AllInfo.consigneepickupDate=request.LoadStopInfoConsignee.StopDate>
        <cfset consigneepickupTime=request.LoadStopInfoConsignee.StopTime>
        <cfset consigneetimeIn=request.LoadStopInfoConsignee.TimeIn>
        <cfset consigneetimeOut=request.LoadStopInfoConsignee.TimeOut>

        <cfinvoke component="#variables.objloadGateway#" method="getPayerStop" stopID="#request.LoadStopInfoConsignee.loadstopid#" returnvariable="request.ConsigneeIsPayer" />

        <cfif request.ConsigneeIsPayer.recordcount>
            <cfset consigneeIsPayer = request.ConsigneeIsPayer.IsPayer>
        <cfelse>
            <cfset consigneeIsPayer = 0>
        </cfif>

        <cfset ConsBlind=request.ConsineeStop.consigneeBlind>
        <cfset consigneeInstructions=trim(request.ConsineeStop.consigneeInstructions)>
        <cfset session.AllInfo.consigneeInstructions=trim(request.ConsineeStop.consigneeInstructions)>
        <cfset consigneedirection=trim(request.ConsineeStop.consigneeDirections)>
        <cfset bookedwith1=request.ConsineeStop.consigneeBookedWith>
        <cfset session.AllInfo.bookedwith1 = request.ConsineeStop.consigneeBookedWith>
        <cfset equipment1=request.ConsineeStop.ConsigneeEquipmentId>
        <cfset session.AllInfo.equipment1=request.ConsineeStop.ConsigneeEquipmentId>
        <cfset driver=request.ConsineeStop.consigneeDriverName>
        <cfset driverCell=request.ConsineeStop.consigneeDRIVERCELL>
        <cfset truckNo=request.ConsineeStop.consigneeTRUCKNO>
        <cfset TrailerNo=request.ConsineeStop.consigneeTRAILORNO>
        <cfset refNo=request.ConsineeStop.consigneeREFNO>
        <cfset milse=request.ConsineeStop.consigneeMILES>
        <cfset editid=loadID>
    </cfif>
 
	<cfif ShipCustomerStopName neq "" or shiplocation neq "" or shipcity neq "" or (shipstate1 neq 0 AND shipstate1 neq "") or shipzipcode neq "" or shipcontactPerson neq "" or shipPhone neq "" or shipfax neq "" or shipemail neq "" or shipPickupNo neq "" or shippickupDate neq "" or shippickupTime neq "" or shiptimeIn neq "" or shiptimeOut neq "" or shipInstructions neq "" or Shipdirection neq "">
		<cfset variables.flagstatus=1>
	</cfif>

	<cfif ConsineeCustomerStopName neq "" or consigneelocation neq "" or consigneecity neq "" or (consigneestate1 neq 0 AND consigneestate1 neq "") or consigneezipcode neq "" or consigneecontactPerson neq "" or consigneePhone neq "" or consigneefax neq "" or consigneeemail neq "" or consigneePickupNo neq "" or consigneepickupDate neq "" or consigneepickupTime neq "" or consigneetimeIn neq "" or consigneetimeOut neq "" or consigneeInstructions neq "" or consigneedirection neq "">
		<cfset variables.flagstatusConsignee=1>
	</cfif> 

    <script type="text/javascript">
        $(document).ready(function(){
            setStopValue();
        	var loadidExists='<cfoutput>#loadID#</cfoutput>';
        	var shipperValue='<cfoutput>#clean_javascript_data(ShipCustomerStopName)#</cfoutput>';
        	var shiplocation='<cfoutput>#clean_javascript_data(shiplocation)#</cfoutput>';
        	var shipcity='<cfoutput>#clean_javascript_data(shipcity)#</cfoutput>';
        	var shipstate1='<cfoutput>#clean_javascript_data(shipstate1)#</cfoutput>';
        	var shipzipcode='<cfoutput>#clean_javascript_data(shipzipcode)#</cfoutput>';
        	var shipcontactPerson='<cfoutput>#clean_javascript_data(shipcontactPerson)#</cfoutput>';
        	var shipPhone='<cfoutput>#clean_javascript_data(shipPhone)#</cfoutput>';
        	var shipfax='<cfoutput>#clean_javascript_data(shipfax)#</cfoutput>';
        	var shipemail='<cfoutput>#clean_javascript_data(shipemail)#</cfoutput>';
        	var shipPickupNo='<cfoutput>#clean_javascript_data(shipPickupNo)#</cfoutput>';
        	var shippickupDate='<cfoutput>#clean_javascript_data(shippickupDate)#</cfoutput>';
        	var shippickupTime='<cfoutput>#clean_javascript_data(shippickupTime)#</cfoutput>';
        	var shiptimeOut='<cfoutput>#clean_javascript_data(shiptimeOut)#</cfoutput>';
        	var shiptimeIn='<cfoutput>#clean_javascript_data(shiptimeIn)#</cfoutput>';
        	var shipInstructions="<cfoutput>#clean_javascript_data(shipInstructions)#</cfoutput>";
        	var Shipdirection='<cfoutput>#clean_javascript_data(Shipdirection)#</cfoutput>';
        	var consineeValue='<cfoutput>#clean_javascript_data(ConsineeCustomerStopName)#</cfoutput>';	
        	var consigneelocation='<cfoutput>#clean_javascript_data(consigneelocation)#</cfoutput>';
        	var consigneecity='<cfoutput>#clean_javascript_data(consigneecity)#</cfoutput>';
        	var consigneestate1='<cfoutput>#clean_javascript_data(consigneestate1)#</cfoutput>';
        	var consigneezipcode='<cfoutput>#clean_javascript_data(consigneezipcode)#</cfoutput>';
        	var consigneecontactPerson='<cfoutput>#clean_javascript_data(consigneecontactPerson)#</cfoutput>';
        	var consigneePhone='<cfoutput>#clean_javascript_data(consigneePhone)#</cfoutput>';
        	var consigneefax='<cfoutput>#clean_javascript_data(consigneefax)#</cfoutput>';
        	var consigneeemail='<cfoutput>#clean_javascript_data(consigneeemail)#</cfoutput>';
        	var consigneePickupNo='<cfoutput>#clean_javascript_data(consigneePickupNo)#</cfoutput>';
        	var consigneetimeIn='<cfoutput>#clean_javascript_data(consigneetimeIn)#</cfoutput>';
        	var consigneetimeOut='<cfoutput>#clean_javascript_data(consigneetimeOut)#</cfoutput>';
        	var consigneepickupTime='<cfoutput>#clean_javascript_data(consigneepickupTime)#</cfoutput>';
        	var consigneepickupDate='<cfoutput>#clean_javascript_data(consigneepickupDate)#</cfoutput>';
        	var consigneeInstructions='<cfoutput>#clean_javascript_data(consigneeInstructions)#</cfoutput>';
        	var consigneedirection='<cfoutput>#clean_javascript_data(consigneedirection)#</cfoutput>';

        	if(loadidExists !=""){
        		if (shipstate1=='<![CDATA[0]]>'){
        			shipstate1='<![CDATA[]]>';
        		}
        		if(shipperValue !="<![CDATA[]]>" || shiplocation !="<![CDATA[]]>" || shipcity !="<![CDATA[]]>" || shipstate1 !='<![CDATA[]]>' || shipzipcode !="<![CDATA[]]>" || shipPhone !="<![CDATA[]]>" || shipfax !="<![CDATA[]]>" || shipemail !="<![CDATA[]]>" || shipPickupNo !="<![CDATA[]]>" || shippickupDate !="<![CDATA[]]>" || shippickupTime !="<![CDATA[]]>" || shiptimeIn !="<![CDATA[]]>" || shiptimeOut !="<![CDATA[]]>" || shipInstructions!="<![CDATA[]]>"){
        			$(".InfoShipping1").show();
        		}else{
        			$(".InfoShipping1").hide();
        		}
        		if(consineeValue !="<![CDATA[]]>" || consigneelocation !="<![CDATA[]]>" || consigneecity !="<![CDATA[]]>" || consigneestate1 !="<![CDATA[]]>" || consigneezipcode !="<![CDATA[]]>" || consigneecontactPerson !="<![CDATA[]]>" || consigneePhone !="<![CDATA[]]>" || consigneefax !="<![CDATA[]]>" || consigneeemail !="<![CDATA[]]>" || consigneePickupNo !="<![CDATA[]]>" || consigneetimeIn !="<![CDATA[]]>" || consigneetimeOut !="<![CDATA[]]>" || consigneetimeOut !="<![CDATA[]]>" || consigneepickupTime !="<![CDATA[]]>" || consigneepickupDate !="<![CDATA[]]>" || consigneeInstructions !="<![CDATA[]]>"|| consigneedirection!="<![CDATA[]]>"){
        			$(".InfoConsinee1").show();
        		}else{
        			$(".InfoConsinee1").hide();
        		}
        	}	
        });

        var initialization=false;
        function changeValueStatus(){
        	if(initialization==true){
        		if(($('##StatusDispatchNotesToShowHidden').val())=='1'){
        			var onChangeFlagStatusVal = $("##loadStatus option:selected").text();
					onChangeFlagStatusVal=$.trim(onChangeFlagStatusVal);
        			$("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ " >" +' Status changed to '+onChangeFlagStatusVal+'\n');
        		}
        	} else{
        		initialization=true;
        	}	
        }

        function popitup(url) {
            newwindow=window.open(url,'Map','height=600,width=800');
            if (window.focus) {newwindow.focus()}
            return false;
        }

        function changeQuantityWithtype(ele,stop){
            if($(ele).find('option:selected').text()==='FSC M(FUEL SURCHARGE MILES)'){
                var mileValue=$('##milse'+stop).val();
                $(ele).parents('tr:first').find('input[name*=qty]').val(mileValue);
            }
        }

        function changeQuantityWithValue(ele, stop){
        	var mileValue = $(ele).val();
        	$.each($('.typeSelect'+stop).find('option:selected'), function(){
                if($(this).html()== 'FSC M(FUEL SURCHARGE MILES)'){
                    $(this).parents('tr:first').find('input[name*=qty]').val(mileValue);
                }
        	});
        }

        function changeQuantity(id,milevalue,type){
        	var itemno = id.replace("milse","");
        	var fsctext = "milse";
        	for(i=1;i<=7;i++){
        		try {
        			var index = document.getElementById(type+i+''+itemno).selectedIndex;
        		}
        		catch(e){
        			type='unit';
        			try{
        			var unittype = document.getElementById(type+i+''+itemno).options[index].text;
        			}catch(e){}
        		}
        		try{
        			if(unittype.indexOf("FSC Mxxx") > -1){			
        				document.getElementById('qty'+i+''+itemno).value = milevalue;
        			}
        		}
        		catch(e) {
        		}
        	}
        	CalculateTotal('#Application.dsn#');
        }

        function autoloaddescription(self, loadnumber, itemRowNo, dsn) {
            var unitId = self.value;
            var attrname = $(self).attr('name');
            attrname = attrname.replace('unit','');
            $.ajax({
                type    : 'POST',
                url     : "../gateways/unitgateway.cfc?method=getloadUnitsForAutoLoading",
                data    : {UnitID : unitId, dsn : dsn},
                success :function(data){
                    $('[name=description'+attrname+']').val(data);
                }
            });
        }

        function showfullmap(url,form, type, dsn) {
        	var thisFrom = document.forms["load"];
        	if (thisFrom.shipperName.value != null) {
        		var data = "ShpNm="+thisFrom.shipperName.value;
        		var ShipName = 0;
        	} else {
        		var data = "ShpNm=";
        		var ShipName = 1; 
        	}
        	if(thisFrom.shipperlocation.value == null) {
        		thisFrom.shipperlocation.value = "";
        	}
        	if(thisFrom.shippercity.value == null) {
        		thisFrom.shippercity.value = "";
        	}
        	if(thisFrom.shipperstate.value == null) {
        		thisFrom.shipperstate.value = "";
        	}
        	if(thisFrom.shipperZipcode.value == null) {
        		thisFrom.shipperZipcode.value = "";
        	}
        	
        	
        	if(thisFrom.consigneeName.value == null) {
        		thisFrom.consigneeName.value = "";
        		var ConName = 0;
        	} else {
        		var ConName = 1;
        	}
        	
        	if(thisFrom.consigneelocation.value == null) {
        		thisFrom.consigneelocation.value = "";
        	}
        	if(thisFrom.consigneecity.value == null) {
        		thisFrom.consigneecity.value = "";
        	}
        	if(thisFrom.consigneestate.value == null) {
        		thisFrom.consigneestate.value = "";
        	}
        	if(thisFrom.consigneeZipcode.value == null) {
        		thisFrom.consigneeZipcode.value = "";
        	}
        	if(type == 'promiles') {
        		data += "ShpAdd=" + encodeURIComponent(thisFrom.shippercity.value+", "+thisFrom.shipperstate.value+" "+thisFrom.shipperZipcode.value); 
        		data += "&ConNm="+encodeURIComponent(thisFrom.consigneeName.value);
        		data += "&ConAdd="+encodeURIComponent(thisFrom.consigneecity.value+", "+thisFrom.consigneestate.value+" "+thisFrom.consigneeZipcode.value);
        	} else {
        		data += "&ShpAdd=" + encodeURIComponent(thisFrom.shipperlocation.value+" "+thisFrom.shippercity.value+", "+thisFrom.shipperstate.value+" "+thisFrom.shipperZipcode.value); 
        		data += "&ConNm="+encodeURIComponent(thisFrom.consigneeName.value);
        		data += "&ConAdd="+encodeURIComponent(thisFrom.consigneelocation.value+" "+thisFrom.consigneecity.value+", "+thisFrom.consigneestate.value+" "+thisFrom.consigneeZipcode.value);
        	}
        	
        	<cfloop from="2" to="10" index="i">

        		if(thisFrom.shipperName#i#.value == null) {
        			thisFrom.shipperName#i#.value = "";
        			var ShipName#i# = 0;
        		} else {
        			var ShipName#i# = 1;
        		}

        		if(thisFrom.shipperlocation#i#.value == null) {
        			thisFrom.shipperlocation#i#.value = "";
        		}
        		if(thisFrom.shippercity#i#.value == null) {
        			thisFrom.shippercity#i#.value = "";
        		}
        		if(thisFrom.shipperstate#i#.value == null) {
        			thisFrom.shipperstate#i#.value = "";
        		}
        		if(thisFrom.shipperZipcode#i#.value == null) {
        			thisFrom.shipperZipcode#i#.value = "";
        		}
        		if(ShipName#i# == 1) {
        			data += "&ShpNm#i#="+thisFrom.shipperName#i#.value;
        			if(type == 'promiles'){
        				data += "&ShpAdd#i#=" +thisFrom.shippercity#i#.value+", "+thisFrom.shipperstate#i#.value+" "+thisFrom.shipperZipcode#i#.value; 
        			} else {
        				data += "&ShpAdd#i#=" + thisFrom.shipperlocation#i#.value+" "+thisFrom.shippercity#i#.value+", "+thisFrom.shipperstate#i#.value+" "+thisFrom.shipperZipcode#i#.value; 
        			}
        		}
        		
        		if(thisFrom.consigneeName#i#.value == null) {
        			thisFrom.consigneeName#i#.value = "";
        			var ConName#i# = 0;
        		} else {
        			var ConName#i# = 1;
        		}
        		if(thisFrom.consigneelocation#i#.value == null) {
        			thisFrom.consigneelocation#i#.value = "";
        		}
        		if(thisFrom.consigneecity#i#.value == null) {
        			thisFrom.consigneecity#i#.value = "";
        		}
        		if(thisFrom.consigneestate#i#.value == null) {
        			thisFrom.consigneestate#i#.value = "";
        		}
        		if(thisFrom.consigneeZipcode#i#.value == null) {
        			thisFrom.consigneeZipcode#i#.value = "";
        		}	
        		if(ConName#i# == 1) {
        			data += "&ConNm#i#="+thisFrom.consigneeName#i#.value;
        			if(type == 'promiles'){
        				data += "&ConAdd#i#="+thisFrom.consigneecity#i#.value+", "+thisFrom.consigneestate#i#.value+" "+thisFrom.consigneeZipcode#i#.value;	
        			} else {
        				data += "&ConAdd#i#="+thisFrom.consigneelocation#i#.value+" "+thisFrom.consigneecity#i#.value+", "+thisFrom.consigneestate#i#.value+" "+thisFrom.consigneeZipcode#i#.value;	
        			}
        		}
        	</cfloop>
    	
            if(type == 'promiles'){
                data += "&dsn="+dsn;
            }

            if(type == 'promiles'){	
                url = 'index.cfm?event=' + url + '&' +'loadNum=#loadnumber#&' + data;	
            } else {
                url = '../views/pages/load/' + url + '?' +'loadNum=#loadnumber#&' + data;
            }
    	
            newwindow=window.open(url,'name','height=560,width=965,toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0');
    	
            if (window.focus) {newwindow.focus()}
                return false;
            }

        	function ConfirmMessage(index,stopno){
        		if(stopno !=0){
        			index=index+""+stopno;
        		}
        		percentagedata=$('##CarrierPer'+index).val();
        		percentagedata=percentagedata.replace("%", "");	
        		if(percentagedata.indexOf("%")==-1){
        			if(percentagedata<1){
        				percentagedata=percentagedata*100;			
        			}
        			$('##CarrierPer'+index).val(percentagedata+"%");
        		}
        		if(percentagedata.indexOf("%")>-1){
        			$('##CarrierPer'+index).val(percentagedata+"%");
        		}
        		data = $('##CarrierRate'+index).val();
        		data=data.replace("$", "");	
        		if(parseFloat(data)>0){
        			if (confirm("Do you want to set #variables.freightBroker# rate to 0 ?")) { 		
        				$('##CarrierRate'+index).val('$0.00');	
        			}
        		}
        		CalculateTotal('#Application.dsn#');
        	}
      
            function setStopValue(){
                var shownStopArray = [];
                var nonShownStopArray = [];
                for(i=2;i<11;i++){
                    ($('##stop'+i).css('display')=="block" ? shownStopArray.push(i):nonShownStopArray.push(i));
                    $('##stop'+i+'h2').text('Stop '+i);
                }
                $('##shownStopArray').val(shownStopArray);
                $('##nonShownStopArray').val(nonShownStopArray);
                var c = ''
                $.each(shownStopArray,function(index, value){
                    var index = index+2;
                    c = c+'<li><a href="##StopNo'+value+'">##'+index+'</a></li>';
                    $('##StopNo'+value+' h2').html('Stop '+index);
                    $('##tabs'+value+' ul li:eq(0) a').html('Stop '+index);
                })
                var c = '<li><a href="##StopNo1">##1</a></li>'+c
                for(j=0;j<=shownStopArray.length;j++){
                    $('##ulStopNo1').html(c);
                    $('##ulStopNo'+shownStopArray[j]).html(c);
                }

                for(g=0;g<=shownStopArray.length;g++){
                    if(g!=shownStopArray.length){
                        k = g+1
                        $('##stop'+k+' .green-btn[value="Add Stop"]').hide();
                    }
                        if(shownStopArray.length != 0){
                        $('##tabs1 .green-btn[value="Add Stop"]').hide();
                    }
                }
            }  
    </script>

    <style type="text/css">
    	.ui-widget, .ui-widget input, .ui-widget select, .ui-widget textarea, .ui-widget button{
            font:11px/16px Arial,Helvetica,sans-serif !important;
        }
    	.typeAddress{
    		color:##ccc;
    		z-index:-1;
    	}
    	.ui-widget textarea {
            width:190px;
        }
    	.carriertextbox {
            width:110px !important; float:left;
        }
    	.carrierrightdiv label.carrierrightlabel {
            width:65px !important;float:left;
        }
    	##tabs1, ##tabs2, ##tabs3, ##tabs4, ##tabs5, ##tabs6, ##tabs7, ##tabs8, ##tabs9, ##tabs10 {
            width:852px;
        }
    	.ui-tabs .ui-tabs-panel{ 
            padding:0 !important;
        }
    	.white-bottom {
    		background-color: white;
    		border-bottom-left-radius: 4px;
    		border-bottom-right-radius: 4px;
    		height: 8px;
    		width: 857px;
    	}
    	.ui-widget-content{
            border:0px !important;
        }
    	.ui-corner-all, .ui-corner-bottom, .ui-corner-left, .ui-corner-bl {
            border-bottom-left-radius:0px !important;
        }
    	.ui-corner-all, .ui-corner-bottom, .ui-corner-right, .ui-corner-br {
            border-bottom-right-radius:0px !important;
        }
    	.form-heading-loop {
    		background: none repeat scroll 0 0 ##ffffff;
    		margin: 0 auto;
    		padding: 0 10px;
    		width: 837px;
    	}
    	input[type="button"],input[type="submit"] {
    		font-family:Arial,Helvetica,sans-serif !important;
    		font-size:11px !important;
    		font-weight:bold !important;
    	}
    	li.ui-menu-item{
    		background:##EDEEF2 !important;
    		color:black !important;
    	}
    	li.ui-state-focus{
    		background:##20358A !important;
    		color:##fff  !important;
    	}
    	li.ui-tabs-active{
    		background:##ffffff !important;
    	}
    	.lineBreak{
    		background: none repeat scroll 0 0 ##9fcef5;
    		height: 3px;
    		margin-bottom: 15px;
    		margin-top: 15px;
    	}
        .overlay {
            display: none;
            z-index: 2;
            background: ##000;
            position: fixed;
            text-align: center;
            opacity: 0.3; 
            overflow: hidden;
             width: 100%;
            height: 100%;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0; 
        }
        .dispatchNotesPopup {
            position: absolute;
            z-index: 3;
            width: 400px; 
            height: auto;
            background: ##dfeffc;
            color: ##000;
            top: 189.5px;
            left: 378.5px;
            display:none;
            padding: 2px;
            border:1px solid ##ccc;
            border-radius: 2px;
        }
        .modalHead {
            background: ##fff;
            background-color: ##82BBEF !important;
            border: 1px solid ##aaaaaa;
            color: ##fff;
            font-weight: bold;
            padding: 5px;
            border-radius: 2px;
            margin-bottom: 5px;
        }
        .closModal {
            float: right;
            padding: 2px;
            color: ##fff;
            cursor: pointer;
        }
        .modalBody {
            border-bottom: 1px solid ##ccc;
            width: 100%;
            text-align: center;
            padding: 20px;
        }
        .modalBody textarea {
            float: left;
            width: 90% !important;
            height: 100px;
            border: 1px solid ##b3b3b3;
            padding: 0px !important; 
            margin: 0px !important;
        }
        .clear {
            clear: both;
        }
        .noteAdd {
            border: 1px solid ##999999;
            background: ##dadada url(images/ui-bg_glass_75_dadada_1x400.png) 50% 50% repeat-x;
            font-weight: normal;
            color: ##212121;
            padding: 5px 10px;
            cursor: pointer;
        }
        .modalFooter{
            padding: 10px;
        }
    </style>

    <div class="overlay"></div>
    <cfset local.selectedLockStatus = ''>
    <!--- Assigning the lock load status --->
    <cfloop query="request.qLoadStatus">
        <cfif not len(trim(url.loadToBeCopied)) gt 2>
            <cfif loadStatus is request.qLoadStatus.value AND url.loadToBeCopied EQ 0>
                <cfset local.selectedLockStatus = request.qLoadStatus.value>
            </cfif>
        <cfelse>
            <cfif request.qLoadStatus.value is 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44'>
                <cfset local.selectedLockStatus = request.qLoadStatus.value>
            </cfif>
        </cfif>
    </cfloop>

    <cfset local.lockStartFlag = false>
    <cfset local.loclList = "">

    <cfloop query="request.qLoadStatus">
        <cfif request.qSystemSetupOptions1.lockloadstatus EQ request.qLoadStatus.value>
            <cfset local.lockStartFlag = true>  
        </cfif>
        <cfif local.lockStartFlag>
            <cfset local.loclList = ListAppend(local.loclList, "#request.qLoadStatus.value#")>
        </cfif>
    </cfloop>
    <!--- <cfif ListContains(session.rightsList,'EditLockedLoad',',')> --->
    <cfset local.lockloadStatsFlag = false>
    <cfif not ListContains(session.rightsList,'EditLockedLoad',',') AND local.selectedLockStatus NEQ 'none'>
        <cfset local.isInTheList = ListFindNoCase(local.loclList, local.selectedLockStatus, ",")>
        <cfif local.isInTheList>
          <cfset local.lockloadStatsFlag = true>
        </cfif>
    </cfif>

    <cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
    	<cfinvoke component="#variables.objloadGateway#" method="getloadAttachedFiles" linkedid="#url.loadID#" fileType="1" returnvariable="request.filesAttached" /> 
        <div class="search-panel">
        </div>

<!---Color Change #82bbef --->
        <div class="white-con-area" style="height: 40px;background-color: ##82bbef;">
            <div style="float: left; min-height: 40px; <cfif local.lockloadStatsFlag> width: 17%;<cfelse> width: 43%; </cfif>" id="divUploadedFiles">
                <cfif request.filesAttached.recunt neq 0>
                    &nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.loadid#&attachTo=1&user=#session.adminusername#&dsn=#dsn#&attachtype=Load')">
                    <img style="vertical-align:bottom;" src="images/attachment.png">
                    View/Attach Files
                    </a>
                <cfelse>
                    &nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#url.loadid#&attachTo=1&user=#session.adminusername#&dsn=#dsn#&attachtype=Load')">
                    <img style="vertical-align:bottom;" src="images/attachment.png">
                    Attach Files
                    </a> 
                </cfif>
            </div>
            <cfif local.lockloadStatsFlag>	
                <h2 style="float:left;color: red;font-size: 25px;font-weight: bold;padding-right: 60px;">VIEW ONLY</h2>
                <div style="float: left; width: 57%; min-height: 40px;"><h1 style="color:white;font-weight:bold;display:inline-block;">Load###Ucase(loadnumber)#</h1><h2 style="color: red;float: right;margin-right: 60px;font-size: 25px;font-weight: bold;">EDIT NOT ALLOWED</h2></div>
            <cfelse>      
                <div style="float: left; width: 57%; min-height: 40px;"><h1 style="color:white;font-weight:bold;">Load###Ucase(loadnumber)#</h1></div>
            </cfif>
        </div>
    <cfelse>
		<cfset tempLoadId = #createUUID()#>
		<cfset session.checkUnload ='add'>

<!---Color Change #82bbef --->
		<div class="white-con-area" style="height: 40px;background-color: ##82bbef;">
			<div style="float: left; min-height: 40px; width: 43%;" id="divUploadedFiles">
					&nbsp;<a style="display:block;font-size: 13px;padding-left: 10px;color:white;" href="##" onclick="popitup('../fileupload/multipleFileupload/MultipleUpload.cfm?id=#tempLoadId#&attachTo=1&user=#session.adminusername#&newFlag=1&dsn=#dsn#&attachtype=Load')">
					<img style="vertical-align:bottom;" src="images/attachment.png">
					Attach Files</a>
			</div>
			<div style="float: left; width: 57%; min-height: 40px;"><h1 style="color:white;font-weight:bold;">Add New Load</h1></div>
		</div>
    </cfif>

    <cfset totStops = NoOfStopsToShow +1>
    <div id="dialog-confirm"></div>
    <form name="load"  class="addLoadWrap" id="load" action="index.cfm?event=addload:process&#session.URLToken#" method="post">
    <input type="hidden" name="inputChanged" id="inputChanged" value="0">
    <input type="hidden" name="loaddisabledStatus" id="loaddisabledStatus" value="#variables.loaddisabledStatus#">
	 <input type="hidden" name="tabid" id="tabid" value=">

    <cfif #request.qSystemSetupOptions.integratewithPEP# eq true>
    <input type="hidden" name="integratewithPEP" id="integratewithPEP" value="#request.qSystemSetupOptions.integratewithPEP#"> 
	   <input type="hidden" name="PEPsecretKey" id="PEPsecretKey" value="#request.qSystemSetupOptions.PEPsecretKey#"> 
	   <input type="hidden" name="PEPcustomerKey" id="PEPcustomerKey" value="#request.qSystemSetupOptions.PEPcustomerKey#"> 
    </cfif>

    <cfif #request.qcurAgentdetails.integratewithTran360# eq true>
    	<input type="hidden" name="integratewithTran360" id="integratewithTran360" value="#request.qcurAgentdetails.integratewithTran360#"> 
    	<input type="hidden" name="trans360Usename" id="trans360Usename" value="#request.qcurAgentdetails.trans360Usename#"> 
    	<input type="hidden" name="trans360Password" id="trans360Password" value="#request.qcurAgentdetails.trans360Password#">
    	<input type="hidden" name="Triger_loadStatus" id="Triger_loadStatus" value="#request.qSystemSetupOptions.Triger_loadStatus#">
    	<input type="hidden" name="IsTransCorePst" id="IsTransCorePst" value="#posttoTranscore#">
    <cfelse>
	   <input type="hidden" name="IsTransCorePst" id="IsTransCorePst" value="0">
    </cfif>
    <cfif request.qSystemSetupOptions.IntegrateWithITS EQ 1 >
        <input type="hidden" name="integratewithITS" id="integratewithITS" value="#request.qSystemSetupOptions.IntegrateWithITS#">
        <input type="hidden" name="ITSUsername" id="ITSUsename" value="#request.qSystemSetupOptions.ITSUserName#"> 
        <input type="hidden" name="ITSPassword" id="ITSPassword" value="#request.qSystemSetupOptions.ITSPassword#">
        <input type="hidden" name="ITSIntegrationID" id="ITSIntegrationID" value="#request.qcurAgentdetails.IntegrationID#">
        <input type="hidden" name="IsITSPst" id="IsITSPst" value="#posttoITS#">
    </cfif>
	
	<cfif request.qcurAgentdetails.loadBoard123 EQ 1 >
		<input type="hidden" name="loadBoard123Username" id="loadBoard123Username" value="#request.qcurAgentdetails.loadBoard123Usename#"> 
		<input type="hidden" name="loadBoard123" id="loadBoard123" value="#request.qcurAgentdetails.loadBoard123#"> 
		<input type="hidden" name="loadBoard123Password" id="loadBoard123Password" value="#request.qcurAgentdetails.loadBoard123Password#">
		<input type="hidden" name="Is123LoadBoardPst" id="Is123LoadBoardPst" value="#PostTo123LoadBoard#">
	<cfelse>	
		<input type="hidden" name="loadBoard123" id="loadBoard123" value="0"> 
	</cfif>
    <div class="white-con-area">
        <div class="white-mid">
            <cfif (not  structkeyexists(url,"loadToBeCopied") OR url.loadToBeCopied eq 0) AND ( structkeyexists(url,"loadid") )>
                <input type="hidden" id="editid" name="editid" value="#editid#">
            </cfif>
    		<cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1 and LoadNumber neq "">
    			<cfquery name="GetTranceCoreDBSucesscount" datasource="#application.dsn#">
    				select imprtref,Postrequest_text from LoadPostEverywhereDetails where imprtref='#LoadNumber#' and From_web='Tc360' and status='sucess'
    			</cfquery>
    			 <input type="hidden" name="Trancore_checkDelete"  id="Trancore_checkDelete" value="#GetTranceCoreDBSucesscount.recordcount#">
    		<cfelse>
    			<input type="hidden" name="Trancore_checkDelete"  id="Trancore_checkDelete" value="0">
    		</cfif>
            <input type="hidden" name="Trancore_DeleteFlag"  id="Trancore_DeleteFlag" value="">
            <input type="hidden" name="LoadNumber"  id="LoadNumber" value="#LoadNumber#">
            <input type="hidden" name="nextLoadStopId" value="#loadstopid#">
            <input type="hidden" name="LOADSTOPID" value="#LOADSTOPID#">
            <input type="hidden" name="totalStop" id="totalStop" value="#totStops#">
            <input type="hidden" name="custChk" id="custChk" value="">
            <input type="hidden" name="Loggedin_Person" id="Loggedin_Person" value="#session.UserFullName#">
	  
            <div class="form-con">
                <fieldset>
                    <div class="clear"></div>
          	        <input type="hidden" name="allowloadentry" value="#request.qSystemSetupOptions.AllowLoadentry#"  />
                    <div class="right_billdate_area">
                        <cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1 and LoadNumber neq "">
                            <cfif #request.qSystemSetupOptions.AllowLoadentry# eq true >
                                <div class="clear"></div><span id="myDiv"></span>
                                <label class="space_it">Load Number</label>
                                <input type="Text" name="loadManualNo" class="mid-textbox-1" style="text-align:left;margin: 0 0 8px 0;"  id="loadManualNo" value="#LoadNumber#"  maxlength="9" onkeyup="checkloadNUmberDB(this.value,'#application.dsn#');"  onblur="checkloadNUmberDB(this.value,'#application.dsn#');" />
                                <div class="clear"></div>
                            <cfelse>
                                <input type="hidden" name="loadManualNo" class="mid-textbox-1" style="text-align:left;margin: 0 0 8px 0;"  id="loadManualNo"  value="#LoadNumber#"   style="display:none" />  
                            </cfif>
                        <cfelse>
                            <cfif #request.qSystemSetupOptions.AllowLoadentry# eq true >
                                <div class="clear"></div>
                                <span id="myDiv"></span>
                                <label class="space_it">Load Number</label>
                                <input type="Text" name="loadManualNo" class="mid-textbox-1" style="text-align:left;margin: 0 0 8px 0;"  id="loadManualNo" value=""  maxlength="9" onkeyup="checkloadNUmberDB(this.value,'#application.dsn#');"  onblur="checkloadNUmberDB(this.value,'#application.dsn#');" />
                                <div class="clear"></div>
                            <cfelse>
                                <input type="hidden" name="loadManualNo" class="mid-textbox-1" style="text-align:left;margin: 0 0 8px 0;"  id="loadManualNo"  style="display:none" /> 
                            </cfif>
                        </cfif>
						
                        <input type="hidden" name="loadManualNoExists" id="loadManualNoExists" value=""   />
                        <label class="space_it">Status*</label>

                        <select name="loadStatus" id="loadStatus" tabindex=1 class="medium " onchange="changeValueStatus();" style="margin: 0 0 8px 0;">
                            <option value="">Select Status</option>
                            <cfloop query="request.qLoadStatus">
                                <cfif not len(trim(url.loadToBeCopied)) gt 2>
                                    <option value="#request.qLoadStatus.value#" 
                                        <cfif loadStatus is request.qLoadStatus.value AND url.loadToBeCopied EQ 0> selected="selected" </cfif>>
                                        #request.qLoadStatus.Text#
                                    </option>
                                <cfelse>
                                    <option value="#request.qLoadStatus.value#" 
                                        <cfif request.qLoadStatus.value is 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44'> selected="selected" </cfif>>
                                        #request.qLoadStatus.Text#
                                    </option>
                                </cfif>
                            </cfloop>
                        </select>
                        <cfset reqSetStatus="#request.qSystemSetupOptions.ARAndAPExportStatusID#">
                        <input type="hidden" name="qLoadDefaultSystemStatus" id="qLoaDefaultSystemStatus" value="#reqSetStatus#" />
                        <input type="hidden" name="StatusDispatchNotesToShowHidden" id="StatusDispatchNotesToShowHidden" value="#StatusDispatchNotesToShow#" />
                        <div class="clear"></div>
                        <div id="slsP" style="color:red;display:none;padding-left:150px;"></div>
                        <div class="clear"></div>
                        <label class="space_it">Dispatchers*</label>

                        <select id="Dispatcher" name="Dispatcher" tabindex=3 class="medium" style="margin: 0 0 8px 0;">
                            <option value="">Select</option>
                            <cfloop query="request.qSalesPerson">
                                <option value="#request.qSalesPerson.EmployeeID#" <cfif request.qSalesPerson.EmployeeID eq  Dispatcher> selected="selected" </cfif>>#request.qSalesPerson.Name#</option>
                            </cfloop>
                        </select>

                        <div class="clear"></div>
                        <cfif request.qSystemSetupOptions.freightBroker>
                            <label class="space_it">Sales Agent*</label>
                            <select id="Salesperson" name="Salesperson" tabindex=2 class="medium" style="margin: 0 0 8px 0;">
                                <option value="">Select</option>
                                <cfloop query="request.qSalesPerson">
                                    <option value="#request.qSalesPerson.EmployeeID#" <cfif request.qSalesPerson.EmployeeID eq  Salesperson> selected="selected" </cfif>>#request.qSalesPerson.Name#</option>
                                </cfloop>
                            </select>
                        <cfelse>
                            <label class="space_it_little" style="margin-left: 6px;">#left(request.qSystemSetupOptions.userdef7,12)#</label>
                            <input class="sm-input" tabindex="4" name="userDefinedForTrucking" id="userDefinedForTrucking" value="#userDefinedFieldTrucking#" type="text" style="margin-left: 30px;width: 105px;" maxlength="250">
                            <div class="clear"></div>
                        </cfif>  
						<div class="notes" style="<cfif not request.qSystemSetupOptions.freightBroker AND #request.qSystemSetupOptions.AllowLoadentry# NEQ true >margin-top: 32px;<cfelseif  request.qSystemSetupOptions.freightBroker AND NOT request.qSystemSetupOptions.AllowLoadentry>margin-top: 60px;</cfif>">
							<label class="space_it_little">Notes</label>
							<textarea class="medium-textbox <cfif NotesToShow eq true>applynotesPl</cfif>" name="Notes" tabindex=5 cols="" rows="" style="margin-left: 6px;
							<cfif not request.qSystemSetupOptions.freightBroker>width: 394px;<cfelse>width: 224px;</cfif>"><cfif url.loadToBeCopied EQ 0>#Notes#</cfif></textarea>
							<div class="clear"></div>
							<cfif not request.qSystemSetupOptions.freightBroker>
								<input name="statusfreightBroker" ID="statusfreightBroker" type="hidden" value="0" />
							</cfif>
							<label class="space_it">&nbsp;</label>
						</div>
                    </div>
                    <div class="left_billdate_area" style="height:228px;">
                        <cfif not isdefined('request.qLoads.orderDate') OR request.qLoads.orderDate eq "01/01/1900" >
                        <!--- SQL returns this when date is null --->
                            <cfset orderDate = dateformat(NOW(),'mm/dd/yyyy')>
                        <cfelse>
                            <cfset orderDate = dateformat(request.qLoads.orderDate,'mm/dd/yyyy')>
                        </cfif>
        				<cfif  structkeyexists(url,"loadToBeCopied") and url.loadToBeCopied neq 0 >
        					 <cfset orderDate = dateformat(NOW(),'mm/dd/yyyy')>
        				</cfif>
                        <label class="space_it">Order Date</label>
                        <div style="position:relative;float:left;">
                            <div style="float:left;">
                                <input class="sm-input datefield" tabindex=4 name="orderDate" id="orderDate" value="#dateformat(orderDate,'mm/dd/yyyy')#" validate="date" required="yes" message="Please enter a valid date" type="datefield" /> 
                            </div>
                        </div>
				        <div id="BillDate_Area" style="height: 120px;">
                            <cfif not isdefined('request.qLoads.BillDate') OR request.qLoads.BillDate eq "01/01/1900">
                                <cfset BillDate = "">
                            <cfelse>
                                <cfset BillDate = dateformat(request.qLoads.BillDate,'mm/dd/yyyy')>
                            </cfif>
                            <cfif  structkeyexists(url,"loadToBeCopied") and url.loadToBeCopied neq 0 >
                                <cfset BillDate = ''>
                                <cfset Invoicenumber=0>
                            </cfif>

                            <label class="space_it">Invoice Date</label>
                            <cfif request.qSystemSetupOptions.ARAndAPExportStatusID neq loadStatus>
                                <cfset abc = "yes">
                            <cfelse>
                                <cfset abc = "no">
                            </cfif>

                            <div style="position:relative;float:left;">
        						<div style="float:left;">
        							<input class="sm-input datefield" tabindex=4 name="BillDate" id="BillDate"  value="#dateformat(BillDate,'mm/dd/yyyy')#" type="text" /> 
        							<input type="hidden"  id="BillDate_Static" value="#dateformat(BillDate,'mm/dd/yyy')#" />
        						</div>
                            </div>
                            <cfif request.qSystemSetupOptions.MinimumLoadInvoiceNumber neq 0>
                                <label class="space_it">Invoice##</label>
                                <input class="sm-input " tabindex=4 name="InvoiceNumber" id="InvoiceNumber" value="#Invoicenumber#" type="text" readonly/> 
                            </cfif>
							<cfif request.qSystemSetupOptions.showCarrierInvoiceNumber EQ 1>
								<div style="padding-bottom:10px;">
									<label class="space_it" >Carrier Invoice ##</label>
									<input class="sm-input " tabindex=4 name="CarrierInvoiceNumber" id="CarrierInvoiceNumber" value="#CarrierInvoiceNumber#" type="text" onkeyup="this.value=this.value.replace(/[^\d]/,'')"  /> 
								</div>
							</cfif>
							<div class="clear"></div>							
                        </div>
				        <div class="clear"></div>
			            <cfif request.qSystemSetupOptions.freightBroker>
    						<div class="load_opt" style="padding-left: 34px;margin-top: 15px;">Post to ITS<input style="margin-right: 16px !important;" name="posttoITS" ID="posttoITS" type="checkbox" tabindex=6 class="small_chk" <cfif posttoITS is 1> checked="checked" </cfif> value="" />
        					</div>
        					<div class="clear"></div>  
        						<div class="load_opt" style="padding-left: 34px;">Post Everywhere?<input style="margin-right: 16px !important;" name="posttoloadboard" ID="posttoloadboard" type="checkbox" tabindex=6 class="small_chk" <cfif posttoloadboard is 1> checked="checked" </cfif> value="1" />
        					</div>
        					<div class="clear"></div>
        						<div class="load_opt" style="padding-left: 34px;">Post DAT Load Board?<input style="margin-right: 16px !important;" name="posttoTranscore" ID="posttoTranscore" type="checkbox" tabindex=6 class="small_chk" <cfif posttoTranscore is 1> checked="checked" </cfif> value="#posttoTranscore#" />
        					</div>
        					<div class="clear"></div>
        						<div class="load_opt" style="padding-left: 34px;">Post 123Load Board?<input style="margin-right: 16px !important;" name="PostTo123LoadBoard" ID="PostTo123LoadBoard" type="checkbox" tabindex=6 class="small_chk" <cfif PostTo123LoadBoard is 1>checked="checked" </cfif> value="#PostTo123LoadBoard#" />
        					</div>
                            <div class="clear"></div>
                            <input name="statusfreightBroker" ID="statusfreightBroker" type="hidden" value="1" />
                        </cfif>                        
                    </div>
                    <div class="clear"></div>
					
					<div class="clear"></div>
					<div class="load_opt" style="text-align: right;<cfif not request.qSystemSetupOptions.freightBroker>padding-left: 58px;margin-right: -20px;<cfelse>padding-left:34px;</cfif>">
						Less than truck load&nbsp;<input name="IsPartial" ID="IsPartial" type="checkbox" tabindex=6 class="small_chk" <cfif IsPartial is 1> checked="checked" </cfif> value="" style="margin-right: 23px !important;" />
					</div>
					  <cfif NOT request.qSystemSetupOptions.freightBroker><div class="clear"></div></cfif>
                    <input type="hidden" name="dispatchHiddenValue" id="dispatchHiddenValue" value=""/>
                    <label class="space_it_medium dispatch_note" <cfif not request.qSystemSetupOptions.freightBroker> style="margin-top:-8px;"</cfif>>Dispatch Notes</label>
                    <div class="clear"></div>
                    <textarea class="carrier-textarea-big <cfif DispatchNotesToShow eq true>applynotesPl</cfif> <cfif request.qSystemSetupOptions1.editdispatchnotes EQ 0>displayDispatchNotesPopup</cfif>" data-username="#session.userfullname#"name="dispatchNotes" id="dispatchNotes" tabindex=7 cols="" rows="" data-loadid="#url.loadid#"><cfif url.loadToBeCopied EQ 0>#dispatchNotes#</cfif></textarea>
                    <div class="dispatchNotesPopup">
                        <div class="modalHead">
                            <p>Dispatch Notes<span class="closModal">X</span></p>
                        </div>
                        <div class="modalBody">
                            <textarea class="dispatchPopupNotes" placeholder="Enter Dispatch Notes..."></textarea>
                            <div class="clear"></div>
                        </div>
                        <div class="modalFooter">
                            <span class="noteAdd">Add</span>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <label class="space_it_medium">#variables.freightBroker# Notes</label>
                    <div class="clear"></div>
                    <textarea <cfif (request.qSystemSetupOptions.freightBroker )>style="margin-top: -4px;"</cfif> class="carrier-textarea-medium <cfif CarrierNotesToShow eq true>applynotesPl</cfif>" name="carrierNotes" id="carrierNotes" tabindex=8 cols="" rows="" >#carrierNotes#</textarea>
                    <div class="clear"></div>
                </fieldset>
            </div>
            <div class="form-con">
                <fieldset>
                    <div class="right" style="height:72px">
                        <input type="hidden" value="#request.qSystemSetupOptions.minimumMargin#" id="minimumMargin">
                        <cfset carrierReportOnClick = "window.open('../reports/loadReportForCarrierConfirmation.cfm?loadid=#editid#&#session.URLToken#')">
                        <cfset CarrierWorkOrderImportOnClick = "window.open('../reports/CarrierWorkOrderImport.cfm?loadid=#editid#&#session.URLToken#')">
                        <cfset CarrierWorkOrderExportOnClick = "window.open('../reports/CarrierWorkOrderExport.cfm?loadid=#editid#&#session.URLToken#')">
                        <cfset customerReportOnClick = "window.open('../reports/CustomerInvoiceReport.cfm?loadid=#editid#&#session.URLToken#')">
                        <cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
				            <div>
                				<div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 3px 0;text-align: center;">
                					<img id="carrierReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
                				</div>
                                <input id="carrierReportLink" style="width:110px !important;" type="button" class="black-btn tooltip"  value="#variables.freightBrokerReport# Report" <cfif carrierReportOnClick eq ""> disabled </cfif><cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif> />
				                <div style="cursor:pointer;width:27px;float: left;margin: 3px 0;text-align: center;">&nbsp;</div>
				                <input style="width:110px !important;" type="button" class="black-btn" value="B.O.L. Report" onClick="self.location='index.cfm?event=BOLReport&loadid=#url.loadid#&#session.URLToken#'"/>
				                <input type="button" class="blue-btn"  value="Copy Load"  onClick="window.open('index.cfm?event=addload&loadToBeCopied=#url.loadid#&#session.URLToken#')" style="width:101px !important;float:right;">
				            </div>
                            <div class="clear"></div>
                            <div>
                				<div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 3px 0;text-align: center;">
                					<img id="impWorkReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
                				</div>
				                <input id="impWorkReportLink" style="width:110px !important;" type="button" class="black-btn tooltip" value="Import Work Order" <cfif CarrierWorkOrderImportOnClick eq ""> disabled </cfif> <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
				                <!--- END: Prevent already transcore synced load update from Agent has no Transcore Login setup in their profile Date:20 Sep 2013  --->
				                <cfif loadStatus eq 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F45'>
                                    <cfset variables.statusDispatch='Rate Quote'>	
                                    <div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 3px 0;text-align: center;">
                                        <img id="custInvReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
                                    </div>
                                    <input id="custInvReportLink" style="width:110px !important;" type="button" class="black-btn tooltip custInvReportLink" value="Rate Quote"  <cfif customerReportOnClick eq "">  disabled </cfif> <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
				                <cfelseif (loadStatus eq 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44') or (loadStatus eq 'B54D5427-A82E-4A7A-BAA1-DA95F4061EBE') or (loadStatus eq 'd4c98c6d-018a-41bd-8807-58d0de1bb0f8') or (loadStatus eq '74151038-11EA-47F7-8451-D195D73DE2E4') or(loadStatus eq 'C4C98C6D-018A-41BD-8807-58D0DE1BB0F8')  or(loadStatus eq 'C4d98C6D-018A-41BD-8807-58D0DE1BB0F8') or(loadStatus eq 'c4d98c6d-018a-41bd-8807-58d0df1bb0f8') or(loadStatus eq 'E62ACAA8-804B-4B00-94E0-3FE7B081C012') or(loadStatus eq 'C980CD90-F7CD-4596-B254-141EAEC90186')>
				
                                    <cfset variables.statusDispatch='Rate Confirmation'>	
                                    <div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 3px 0;text-align: center;">
                                        <img id="custInvReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
                                    </div>
                                        <input id="custInvReportLink" style="width:110px !important;" type="button" class="black-btn tooltip custInvReportLink" value="Rate Conf"  <cfif customerReportOnClick eq "">  disabled </cfif> <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
                                <cfelseif (loadStatus eq '6419693E-A04C-4ECE-B612-36D3D40CFC70') or (loadStatus eq 'CE991E00-404D-486F-89B7-6E16C61676F3') or (loadStatus eq 'cf991e00-404d-486f-89b7-6e16c61676f3') or (loadStatus eq '43535cd6-8a5a-4e73-a3a3-8211e623b21d') or (loadStatus eq '5C075883-B216-49FD-B0BF-851DCB5744A4') or (loadStatus eq 'C126B878-9DB5-4411-BE4D-61E93FAB8C95')>
                                    <cfset variables.statusDispatch='Invoice'>	
                                    <div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 3px 0;text-align: center;">
                                    <img id="custInvReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
                                    </div>
                                    <input id="custInvReportLink" style="width:110px !important;" type="button" class="black-btn tooltip custInvReportLink" value="Invoice"  <cfif customerReportOnClick eq "">  disabled </cfif> <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
                                </cfif>
				                    <!--- BEGIN: Prevent already transcore synced load update from Agent has no Transcore Login setup in their profile Date:20 Sep 2013  --->
                				<cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
									<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
										<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
									<cfelse>
										<cfif local.lockloadStatsFlag>
											<input  name="save" type="button" class="green-btn" value="Save" disabled="yes" style="width:101px !important;float:right;" />
										<cfelse>
											<input id="saveLoad" name="save" type="submit" class="green-btn"   onClick="alert('Any changes you make will not be updated to the DAT Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" style="width:100px !important;float:right;">
										</cfif> 
									</cfif>	
                                <cfelseif request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
									<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
										<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
									<cfelse>
										<cfif local.lockloadStatsFlag>
											<input  name="save" type="button" class="green-btn" value="Save" disabled="yes" style="width:101px !important;float:right;" />
										<cfelse>
											<input id="saveLoad" name="save" type="submit" class="green-btn"  disabled onClick="alert('Any changes you make will not be updated to the 123Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" style="width:100px !important;float:right;">
										</cfif> 
									</cfif>		
                                        <input name="notpostingTo123LoadBoard" value="1" type="hidden">
                                <cfelse>
									<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
										<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
									<cfelse>
										<cfif local.lockloadStatsFlag>
											<input name="save" type="button" class="green-btn" value="Save" disabled="yes" style="width:101px !important;float:right;" />
										<cfelse>
											<input id="saveLoad" name="save" type="submit"  class="green-btn"  onClick="return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="yes" style="width:101px !important;float:right;" />
										</cfif>
									</cfif>	
                				</cfif>
		                    </div>
			                <div class="clear"></div>
			                <div>
                                <div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 3px 0;text-align: center;">
            						<img id="expWorkReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
            					</div>
                                <input id="expWorkReportLink" style="width:110px !important;" type="button" class="black-btn tooltip"  value="Export Work Order" <cfif CarrierWorkOrderExportOnClick eq ""> disabled </cfif> <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
                                <!--- Promiles condition is blocked due to map issue using 1 EQ 2 --->
                                <cfif len(trim(request.qSystemSetupOptions.googleMapsPcMiler)) and len(trim(request.qcurAgentdetails.proMilesStatus))>
                  					<cfif request.qSystemSetupOptions.googleMapsPcMiler AND request.qcurAgentdetails.proMilesStatus>
                  						<div style="cursor:pointer;width:27px;float: left;margin: 3px 0;text-align: center;">&nbsp;</div>
                  						<Cfset encryptedDsn = ToBase64(Encrypt(application.DSN, 'load')) >
                  						<input style="width:110px !important;" name="map-button" type="button" class="black-btn" onClick="showfullmap('ProMile',this.form, 'promiles', '#encryptedDsn#');" value="ProMiles Map" />
                  					<cfelse>
                  						<div style="cursor:pointer;width:27px;float: left;margin: 3px 0;text-align: center;">&nbsp;</div>
                  						<input style="width:110px !important;" name="map-button" type="button" class="black-btn" onClick="showfullmap('createFullMap.cfm',this.form, 'googlemap');" value="Google Map" />
                  					</cfif>
                                <cfelse>
                                    <div style="cursor:pointer;width:27px;float: left;margin: 3px 0;text-align: center;">&nbsp;</div>
                                    <input style="width:110px !important;" name="map-button" type="button" class="black-btn" onClick="showfullmap('createFullMap.cfm',this.form, 'googlemap');" value="Google Map" />
                                </cfif>
    				            <!--- BEGIN: Prevent already transcore synced load update from Agent has no Transcore Login setup in their profile Date:20 Sep 2013  --->
    				            <cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
									<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
										<cfif local.lockloadStatsFlag>
										  <input id="saveexit" name="saveexit" type="button" class="green-btn" value="Save & Exit" style="width:101px !important;float:right;"/>
										<cfelse>
										  <input name="saveexit" type="submit" class="green-btn"   onClick="alert('Any changes you make will not be updated to the DAT Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButExitPage('#url.loadid#');" onfocus="checkUnload();"  value="Save & Exit" style="width:100px !important;float:right;"/>
										</cfif> 
									</cfif>	
                                <cfelseif request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
									<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
                                        <cfif local.lockloadStatsFlag>
                                            <input id="saveexit" name="saveexit" type="button" class="green-btn" value="Save & Exit" style="width:101px !important;float:right;"/>
                                        <cfelse>
                                            <input name="saveexit" type="submit" class="green-btn"   onClick="alert('Any changes you make will not be updated to the 123Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButExitPage('#url.loadid#');" onfocus="checkUnload();"  value="Save & Exit" style="width:100px !important;float:right;"/>  
                                        </cfif>
									</cfif>	
                                <cfelse>
									<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
										<cfif local.lockloadStatsFlag>
											<input id="saveexit" name="saveexit" type="button" class="green-btn" value="Save & Exit" style="width:101px !important;float:right;"/>
										<cfelse>
											<input name="saveexit" type="submit" class="green-btn"  onclick="javascript:return saveButExitPage('#url.loadid#');" onFocus="checkUnload();" value="Save & Exit" disabled="yes" style="width:100px !important;float:right;">
										</cfif>
									</cfif>	
                                </cfif>
                                <div class="clear"></div>
                            </div>
                        <cfelse>
                        <!--- temploadid added for fileattachment --->
			                <input type="hidden" name="tempLoadId" value="#tempLoadId#">
							<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
								<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
							<cfelse>
								<cfif local.lockloadStatsFlag>
									<input id="save" name="save" type="button" class="green-btn" value="Save" />
								<cfelse>
									<input name="save" type="submit" class="green-btn"  onClick="return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="yes" />
								</cfif>
							</cfif>	
							<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
								<cfif local.lockloadStatsFlag>
									<input id="saveexit" name="saveexit" type="button" class="green-btn" value="Save & Exit" />
								<cfelse>
									<input name="saveexit" type="submit" class="green-btn" <cfif local.lockloadStatsFlag > disabled </cfif> onClick="return saveButExitPage('2');" onFocus="checkUnload();" value="Save & Exit" disabled="yes"/>
								</cfif>
							</cfif>	
                        </cfif>
                        <input type="hidden" name="loadToSaveWithoutExit" id="loadToSaveWithoutExit" value="0" />
                        <input type="hidden" name="loadToSaveAndExit" id="loadToSaveAndExit" value="0" />
                        <input type="hidden" name="loadToSaveToCarrierPage" id="loadToSaveToCarrierPage" value="" />
                        <input type="hidden" name="loadToCarrierFilter" id="loadToCarrierFilter" value="0" />
                        <input type="hidden" name="loadToCarrierURL" id="loadToCarrierURL" value="" />
                        <input type="hidden" name="frieghtBroker" id="frieghtBroker" value="#request.qSystemSetupOptions.freightBroker#" />
                    </div>
                    <div class="clear"></div>
                    <div class="calculationblock">
                        <table style="border-collapse: collapse;border-spacing: 0;">
                            <colgroup>
                                <col width="15%">
                                <col width="10%">
                                <col width="3%" >
                                <col width="10%">
                                <col width="5%" >
                                <col>
                            </colgroup>
                            <thead>
                                <tr style="height: 25px;">
                                    <th>&nbsp;</th>
                                    <th><label class="custlabel" style="text-align: center;padding:0px; margin:0px;">Miles</label></th>
                                    <th>&nbsp;</th>
                                    <th><label class="custlabel2" style="text-align: center;padding:0px; margin:0px;">Rate</label></th>
                                    <th>&nbsp;</th>
                                    <th><label class="custlabel1" style="text-align: left;padding:0px; margin:0px;">Total Amount</label></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><label>Customer Miles</label></td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" value="#DecimalFormat(0.00)#" id="CustomerMilesCalc" name="CustomerMilesCalc" type="text" disabled required="no" /></td>
                                    <td>x</td>
                                    <td><input class="mid-textbox-1 dollarField" style="text-align:right;" id="CustomerRatePerMile" name="CustomerRatePerMile" type="text" value="#DollarFormat(CustomerRatePerMile)#" required="no" onBlur="customerRatePerMileChanged();"/></td>
                                    <td>=</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="CustomerMilesTotalAmount" name="CustomerMilesTotalAmount" value="$0.00" type="text" required="yes" disabled message="Please enter Customer Rate for calculation of Total Amount of Customer Miles" /></td>
                                    </tr>
                                    <tr>
                                    <td><label>#variables.freightBroker# Miles</label></td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" value="0.00" id="CarrierMilesCalc" name="CarrierMilesCalc" type="text" disabled required="no" /></td>
                                    <td>x</td>
                                    <td><input class="mid-textbox-1 dollarField" style="text-align:right;" id="CarrierRatePerMile" name="CarrierRatePerMile" type="text" value="#DollarFormat(CarrierRatePerMile)#" required="no" onBlur="carrierRatePerMileChanged();" /></td>
                                    <td>=</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="CarrierMilesTotalAmount" name="CarrierMilesTotalAmount" type="text" value="$0.00" required="yes" disabled message="Please enter #variables.freightBroker# Rate for calculation of Total Amount of #variables.freightBroker# Miles" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="clear"></div>
                    <cfif TotalCustomerCharges gt 0>
                        <cfset perc=(1-(TotalCarrierCharges/TotalCustomerCharges))>
                        <cfelse>
                        <cfset perc=0>
                    </cfif>
                    <div class="calculationCustomerBlock">
                        <table style="border-collapse: collapse;border-spacing: 0;">
                            <colgroup>
                                <col width="15%">
                                <col width="10%">
                                <col width="3%" >
                                <col width="10%">
                                <col width="5%" >
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>&nbsp;</th>
                                    <th><label class="custlabel" style="text-align: center;">Customer</label></th>
                                    <th>&nbsp;</th>
                                    <th><label class="custlabel2" style="text-align: center;">#variables.freightBroker#</label></th>
                                    <th>&nbsp;</th>
                                    <th><label id="percentageProfit" class="custlabel" style="width: auto;">x% Profit</label></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><label>Flat Rate*</label></td>
                                    <td><input class="mid-textbox-1 dollarField" style="text-align:right;" id="CustomerRate" name="CustomerRate" type="text" required="yes" onblur="updateTotalAndProfitFields();" validate="float" message="Please endter customer rate." value="#DollarFormat(CustomerRate)#"/></td>
                                    <td>&nbsp;</td>
                                    <td><input class="mid-textbox-1 dollarField" style="text-align:right;" id="CarrierRate" name="CarrierRate" type="text" required="yes" onblur="updateTotalAndProfitFields();" validate="float" message="Please enter #variables.freightBroker# rate." value="#DollarFormat(CarrierRate)#"/></td>
                                    <td>&nbsp;</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="flatRateProfit" name="flatRateProfit" type="text" value="#DollarFormat(0)#" disabled /></td>
                                </tr>
                                <tr>
                                    <td><label>Commodities</label></td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="TotalCustcommodities" name="TotalCustcommodities" value="#DollarFormat(0)#" disabled type="text"  /></td>
                                    <td>&nbsp;</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="TotalCarcommodities" name="TotalCarcommodities" value="#DollarFormat(0)#" disabled type="text"  /></td>
                                    <td>&nbsp;</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="carcommoditiesProfit" name="carcommoditiesProfit" type="text" value="#DollarFormat(0)#" disabled  /></td>
                                </tr>
                                <tr>
                                    <td><label>Miles Charge</label></td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="CustomerMiles" name="CustomerMiles" disabled type="text" value="#DollarFormat(0)#"  /></td>
                                    <td>&nbsp;</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="CarrierMiles" name="CarrierMiles" type="text" disabled value="#DollarFormat(0)#"  /></td>
                                    <td>&nbsp;</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="amountOfMilesProfit" name="amountOfMilesProfit" type="text" value="#DollarFormat(0)#" disabled /></td>
                                </tr>
                                <tr>
                                    <td><label style="color:##0fbc65">Advance Payment(s)</label></td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;color:##0fbc65 !important;" id="AdvancePaymentsCustomer" name="AdvancePaymentsCustomer" disabled type="text" value="#DollarFormat(variables.custAdvancepayments)#"  /></td>
                                    <td>&nbsp;</td>
                                    <cfif variables.carrierAdvancepayments lt 0>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;color:##0fbc65 !important;" id="AdvancePaymentsCarrier" name="AdvancePaymentsCarrier" type="text" disabled value="$#Numberformat(variables.carrierAdvancepayments,"___.__")#"  /></td>
                                    <input type="hidden" name="AdvancePaymentsCarrierhidden" id="AdvancePaymentsCarrierhidden" value="#variables.carrierAdvancepayments#">
                                    <cfelse>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;color:##0fbc65 !important;" id="AdvancePaymentsCarrier" name="AdvancePaymentsCarrier" type="text" disabled value="#DollarFormat(variables.carrierAdvancepayments)#"  /></td>
                                    <input type="hidden" name="AdvancePaymentsCarrierhidden" id="AdvancePaymentsCarrierhidden" value="#variables.carrierAdvancepayments#">
                                    </cfif> 
                                    <td>&nbsp;</td>
                                </tr>
                                <tr style="line-height: 2px;"><td colspan="6">&nbsp;</td></tr>
                                <tr style="border-bottom: 1px solid ##b3b3b3; border-top: 1px solid ##b3b3b3; line-height: 2px;"><td colspan="6">&nbsp;</td></tr>
                                <tr style="line-height: 3px;"><td colspan="6">&nbsp;</td></tr>
                                <tr>
                                    <td><label>TOTAL</label></td>
                                    <td>
                                    <input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="TotalCustomerCharges" name="TotalCustomerChargesDisplay" value="#DollarFormat(TotalCustomerCharges)#" disabled type="text"  />
                                    <input id="TotalCustomerChargesHidden" name="TotalCustomerCharges" value="#TotalCustomerCharges#" type="hidden"  />
                                    </td>
                                    <td>&nbsp;</td>
                                    <td>
                                    <input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="TotalCarrierCharges" name="TotalCarrierChargesDisplay" value="#DollarFormat(TotalCarrierCharges)#" disabled type="text"  />
                                    <input id="TotalCarrierChargesHidden" name="TotalCarrierCharges" value="#TotalCarrierCharges#" type="hidden"  />
                                    </td>

                                    <td>&nbsp;</td>
                                    <td><input class="mid-textbox-1 <CFIF not FindNoCase('ipad;','#CGI.HTTP_USER_AGENT#') GREATER THAN 0>  disabledLoadInputs </cfif>" style="text-align:right;" id="totalProfit" name="totalProfit"  value="#DollarFormat(totalProfit)#" disabled type="text"  /></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="clear"></div>
                    <input class="mid-textbox-1" id="perc" name="perc" value="#DollarFormat(perc)#" readonly="true" type="hidden"/>
                    <div class="clear"></div>
                    <cfif not request.qSystemSetupOptions.commodityWeight>
                        <div style="float:right">
                            <label style="margin-left: -59px; margin-top: 10px;">Weight</label>
                            <input id="weightStop1" type="text" name="weightStop1" value="#weight1#" tabindex="" style="margin-top: 6px; width: 50px;">
                        </div>	
                        <div class="clear"></div>
                    </cfif>	
                    <label class="space_it_medium margin_top" style="<cfif not request.qSystemSetupOptions.commodityWeight> margin-top: 2px; <cfelse> margin-top: 3px;</cfif>">Pricing Notes</label>
                    <div class="clear"></div>
                    <textarea class="carrier-textarea-medium <cfif PricingNotesToShow eq true>applynotesPricing</cfif>" name="pricingNotes" tabindex=8 cols="" rows="" style="margin-left:0px; width:391px;" >#PricingNotes#</textarea>          
                    <!---Chek Boxes For City/State And Zip--->
                    <label class="ch-box" style="margin-left:80px;"><input name="CityState" id="CityState" type="checkbox" class="check"  disabled/>City/State</label>
                    <label class="ch-box"><input name="Zip" id="Zip" type="checkbox" class="check"  disabled />Zip</label>
                    <div class="clear"></div>
                </fieldset>
            </div>
            <input name="customerID" id="customerID" type="hidden" value="#customerID#" />
            <input name="isPayer" id="isPayer" type="hidden" value="#isPayer#" />
            <div class="clear"></div>

<!---Color Change #82bbef --->
            <div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
                <div style="float: left; width: 100%;padding-left:18px;"><h2 style="color:white;font-weight:bold;">Customer</h2></div>
            </div>
            <div class="form-con">
                <fieldset>
                    <label class="bold">Select Customer</label>
                    <input name="cutomerIdAuto" id="cutomerIdAuto" value="#loadCustomerName#" tabindex=9 title="Type text here to display list." />
                    <input type="hidden" name="cutomerIdAutoValueContainer" id="cutomerIdAutoValueContainer" value="#customerID#" required="yes" message="Please select a Customer" />
                    <img src="images/information.png" class="InfotoolTip" style="width:22px;cursor:pointer;" title="Customers with Payer = True in the customer screen will appear on the customer drop down list">
                    <div class="clear"></div>
                    <label>Customer Info</label>
                    <div id="CustInfo1">
                        <label class="field-textarea" tabindex=10 style="width:188px;"><b><a href="" >&nbsp;&nbsp;</a></b><br/>
                        &nbsp;&nbsp;</label>
                        <div class="clear"></div>
                        <label>Contact</label>
                        <label class="field-text" tabindex=11></label>
                        <div class="clear"></div>
                        <label>Tel</label>
                        <label class="cellnum-text" tabindex=12></label>
                        <!---  <div class="clear"></div>--->
                        <label class="space_load">Cell</label>
                        <label class="cellnum-text" tabindex=13></label>
                        <div class="clear"></div>
                        <label>Fax</label>
                        <label class="field-text" tabindex=14 style="width:247px"></label>
                        <div class="clear"></div>
                        <label>Email</label>
                        <label class="field-text" tabindex=15 style="width:247px"></label>
                        <div class="clear"></div>
                    </div>
                    <label>PO##</label>
                    <input name="customerPO" type="text" value="#customerPO#" tabindex=16 class="sm-input" style="width:93px;"/>
                    <label class="space_it_little">BOL##</label>
                    <input name="customerBOL" type="text" value="#BOLNum#" tabindex=16 class="sm-input" style="width:92px;"/>
                    <div class="clear"></div>
                    <cfif request.qSystemSetupOptions.showReadyArriveDate eq true>
                        <label>Ready Date</label>
                        <div style="position:relative;float:left;">
                        <div style="float:left;">
                        <input type="datefield" name="readyDat" id="readyDat" class="sm-input datefield" value="#dateformat(rdyDate,'mm/dd/yyyy')#">
                        </div></div>
                        <label class="space_it_little">Arrive</label>
                        <div style="position:relative;float:left;">
                        <div style="float:left;">
                        <input type="datefield" name="arriveDat" id="arriveDat" class="sm-input datefield" value="#dateformat(ariveDate,'mm/dd/yyyy')#">
                        </div></div>
                        <label>Excused</label>
                        <input type="checkbox" name="Excused" class="small_chk" value="1" <cfif isExcused EQ 1>checked</cfif> style="float:left;">
                    <cfelse>
                        <label>&nbsp;</label>
                    </cfif>
                </fieldset>
            </div>
            <div>
                <div class="form-con">
                    <div id="CustInfo2">
                        <fieldset>
                			<div style="width:100%">
                				<table style="border-collapse: collapse;border-spacing: 0;">
                					<tbody>
                						<tbody>
                						<tr>
                						  <td><label style="text-align: left !important;width: 65px !important;">Credit Limit</label></td>
                						  <td><input type="text" class="mid-textbox-1" style="text-align:right;" tabindex=17></td>
                						  <td><label style="text-align: left !important;width: 40px !important;">Balance</label></td>
                						  <td><input type="text" class="mid-textbox-1" style="text-align:right;" tabindex=18></td>
                						  <td><label style="text-align: left !important;width: 50px !important;">Available</label></td>
                						  <td><input type="text" class="mid-textbox-1" style="text-align:right;" tabindex=19></td>
                						</tr>
                					</tbody>
                					</tbody>
                				</table>
                			</div>
                            <div class="clear"></div>
                            <label class="space_it_medium margin_top">Notes</label>
                            <div class="clear"></div>
                            <textarea class="carrier-textarea-medium" name="" tabindex=20 cols="" rows="" ></textarea>
                            <div class="clear"></div>
                            <label class="space_it_medium margin_top">Dispatch Notes</label>
                            <div class="clear"></div>
                            <textarea class="carrier-textarea-medium" name="" tabindex=21 cols="" rows=""></textarea>
                            <div class="clear"></div>
                        </fieldset>
                    </div>
                    <fieldset>
                        <label class="ch-box" style="margin-left:80px;">
                        <input name="ARExported" id="ARExported" type="checkbox" class="check"  disabled  <cfif ARExported is 1 AND url.loadToBeCopied EQ 0> checked="checked" </cfif>/>
                        A/R Exported
                        </label>
                        <label class="ch-box">
                        <input name="APExported" id="APExported" type="checkbox" class="check"  disabled  <cfif APExported is 1 AND url.loadToBeCopied EQ 0> checked="checked" </cfif>/>
                        A/P Exported
                        </label>
                        <div class="clear"></div>
                    </fieldset>
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <div class="white-bot"></div>
    </div>
    <!--- Set shown stop and non shown stop on every delete stop and add stop  --->
    <input type="hidden" name="shownStopArray" id="shownStopArray" value="">
    <input type="hidden" name="nonShownStopArray" id="nonShownStopArray" value="">
    <div class="gap"></div>
	<!-- stop block-->
	<div id="tabs1" class="tabsload ui-tabs ui-widget ui-widget-content ui-corner-all">
		<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all" style="height:27px;">
			<li class="ui-state-default ui-corner-top ui-tabs-active ui-state-active"><a class="ui-tabs-anchor" href="##tabs-1">Stop 1</a></li>
			<li class="ui-state-default ui-corner-top"><a class="ui-tabs-anchor" href="index.cfm?event=loadIntermodal&stopno=&loadID=#loadID#&#Session.URLToken#">Intermodal</a></li>
			<div style="float: left;width: 23%; margin-left: 27px;">
				<div class="form-con" style="width:103%" id="StopNo1">
					<ul class="load-link" id="ulStopNo1" style="line-height:26px;">
						<cfloop from="1" to="#totStops#" index='stpNoid'>
							<cfif stpNoid is 1>
								<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>

								<cfelse>
								<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
							</cfif>
						</cfloop>
					</ul>
					<div class="clear"></div>
				</div>
			</div>
			<div style="float: left; width: 56%; height:6px;">
				<h2 id="loadNumber" style="color:white;font-weight:bold;margin-top: -11px;">Load###Ucase(loadnumber)#</h2>
			</div>
		</ul>
		
		<div id="tabs-1">
			<div class="white-con-area">
				<div class="white-mid">
					<div>						
                        <div class="rt-button1">
                            <cfif ( structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1 ) OR ( structkeyexists(url,"loadToBeCopied")  and len(trim(url.loadToBeCopied)) gt 1 )>
                                <cfset variables.totalStopcount=request.loadstopcount/2>
                                <cfset variables.totalStopcounts=request.loadstopcount>
                                <cfif variables.totalStopcounts gt 2> 
                                    <a href="javascript:void(0);"><img src="images/upButton.png" style="position:absolute;margin-left: 197px;margin-top: 27px; -ms-transform: rotate(180deg);-webkit-transform: rotate(180deg);transform: rotate(180deg);" onclick="return stopInterChanging('down','#url.loadid#','#application.dsn#',0);" title="By clicking this  stop 1 and stop 2 get swaped "></a>
                                </cfif>
                            </cfif> 
                        </div>
						<div id="ShipperInfo"  style="clear:both">						
							<div class="">
								<div class="fa fa-<cfif not len(loadID) gt 1>minus<cfelse><cfif variables.flagstatus>minus<cfelse>plus</cfif></cfif>-circle PlusToggleButton" onclick="showHideIcons(this,1);" style="position:relative;"></div>
								<span class="ShipperHead" style="margin-left: 6px;">Shipper</span>
							</div>
							<div style="position: absolute;right: 0;line-height: 25px;width: 475px;">
								<span style="display:inline-block;text-aligh:right;" name="span_Shipper" id="span_Shipper"></span>
							</div>	
							<div class="form-heading-carrier">
								<div class="rt-button"></div>
								<div class="clear"></div>
							</div>
							
							<div class="form-con InfoShipping1" style="margin-top:-25px;">
								<cfset shipperStopId = "">
								<cfset shipperStopNameList="">
								<cfset tempList = "">
								<input name="appDsn" id="appDsn" type="hidden" value="#application.dsn#">
								<fieldset>
									<input class="myElements" name="shipper" style="margin-left:112px;" id="shipper" value="#ShipCustomerStopName#" onkeyup="ChkUpdteShipr(this.value,'Shipper',''); showChangeAlert('shipper',''); " onchange="updateIsPayer(shipperValueContainer);"  title="Type text here to display list." tabindex="22"/><img src="images/clear.gif" style="height:14px;width:14px;"  title="Click here to clear shipper information"  onclick="ChkUpdteShipr('','Shipper1','');">
									<input type="hidden" name="shipperValueContainer" id="shipperValueContainer" value="#shipperCustomerID#"/>
									<input type="hidden" name="shipIsPayer" class="updateCreateAlert" id="shipIsPayer" value="#shipIsPayer#">
									<div class="clear"></div>
									<input type="hidden" name="shipperIsPayer" id="shipperIsPayer" value="#ShipIsPayer#">
									<div class="clear"></div>

									<label>Name*</label>
									<input name="shipperName" id="shipperName" value="#ShipCustomerStopName#" onkeyup="ChkUpdteShipr(this.value,'Shipper',''); showChangeAlert('shipper',''); "   type="text" tabindex="23" />
									<input type="hidden" name="shipperNameText" id="shipperNameText" value="#ShipCustomerStopName#">
									<input type="hidden" name="shipperUpAdd" id="shipperUpAdd" value="">
									<div class="clear"></div>

									<label>
    									Address
    									<div class="clear"></div>
    									<span class="float_right">
    										<cfif request.qSystemSetupOptions.googleMapsPcMiler AND request.qcurAgentdetails.proMilesStatus>
    											<a href="##" onclick="Mypopitup('create_map.cfm?loc=#shiplocation#&city=#shipcity#&state=#shipstate1# #shipzipcode#&stopNo=1&shipOrConsName=#ShipCustomerStopName#&loadNum=#loadnumber#' );"><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="Pro Miles Map"  /></a>
    										<cfelse>
    											<a href="##" onclick="Mypopitup('create_map.cfm?loc=#shiplocation#&city=#shipcity#&state=#stateName# #shipzipcode#&stopNo=1&shipOrConsName=#ShipCustomerStopName#&loadNum=#loadnumber#' );"><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="Google Map"  /></a>
    										</cfif>
    									</span>
									</label>
									<textarea class="addressChange" rows="" name="shipperlocation" id="shipperlocation" cols=""   onkeydown="ChkUpdteShiprAddress(this.value,'Shipper','');" data-role=""  tabindex="24">#shiplocation#</textarea>
									<div class="clear"></div>

									<label>City</label>
									<input class="addressChange" name="shippercity" id="shippercity" value="#shipcity#" type="text" data-role="" onkeydown="ChkUpdteShiprCity(this.value,'Shipper','');" <cfif len(url.loadid) gt 1> tabindex="26" <cfelse> tabindex="25" </cfif>/>
									<div class="clear"></div>

									<label>State</label>
									<select name="shipperstate" id="shipperstate" onChange="addressChanged('');loadState(this,'shipper','');" <cfif len(url.loadid) gt 1> tabindex="27" <cfelse> tabindex="26" </cfif>>
    									<option value="">Select</option>
    									<cfloop query="request.qStates">
        									<option value="#request.qStates.statecode#" <cfif request.qStates.statecode is shipstate1> selected="selected" </cfif> >#request.qStates.statecode#</option>
        									<cfif request.qStates.statecode is shipstate1>
        									<cfset variables.stateName = #request.qStates.statecode#>
        									</cfif>
    									</cfloop>
									</select>
									<input type="hidden" name="shipperStateName" id="shipperStateName" value ="<cfif structKeyExists(variables,"stateName")>#variables.stateName#</cfif>">
									<div class="clear"></div>

									<label>Zip</label>
									<input name="shipperZipcode" id="shipperZipcode" value="#shipzipcode#" type="text" <cfif len(url.loadid) gt 1> tabindex="25" <cfelse> tabindex="27" </cfif>/>
									<div class="clear"></div>

									<!---for promiles--->
									<input type="hidden" name="shipperAddressLocation1" id="shipperAddressLocation1" value="#shipcity#<cfif len(shipcity)>,</cfif> #shipstate1# #shipzipcode#"> 
									<cfif len(url.loadid) gt 1>
										<cfset currentTab = "27">
                                    <cfelse>
										<cfset currentTab = "27">
									</cfif>

									<label>Contact</label>
									<input name="shipperContactPerson" id="shipperContactPerson" value="#shipcontactPerson#" type="text" tabindex="#evaluate(currentTab+1)#"/>
									<div class="clear"></div>

									<label>Phone</label>
									<input class="phoneFormatValid" name="shipperPhone" id="shipperPhone" value="#shipPhone#" type="text" onChange="ParseUSNumber(this);" tabindex="#evaluate(currentTab+2)#"/>
									<div class="clear"></div>

									<label>Fax</label>
									<input name="shipperFax" id="shipperFax" value="#shipfax#" type="text" tabindex="#evaluate(currentTab+3)#"/>
									<div class="clear"></div>

									<script>
										var thisFrom = document.forms["load"];
										function Mypopitup(url) {
											newwindow=window.open(url,'name','height=600,width=600');
											if (window.focus) {newwindow.focus()}
											return false;
										}
									</script>

								</fieldset>		
							</div>
							
							<div class="form-con InfoShipping1">				
								<fieldset>
									<label class="stopsLeftLabel">Pickup##</label>
									<input name="shipperPickupNo1" id="shipperPickupNo1" value="#shipPickupNo#" type="text" tabindex="#evaluate(currentTab+4)#"/>
									<div class="clear"></div>

									<label class="stopsLeftLabel">Pickup Date *</label>
									<div style="position:relative;float:left;">
    									<div style="float:left;">
    									   <input class="sm-input datefield" name="shipperPickupDate" id="shipperPickupDate" value="#dateformat(ShippickupDate,'mm/dd/yyyy')#"  type="datefield" tabindex="#evaluate(currentTab+5)#"/> 
                                        </div>
                                    </div> 

									<label class="sm-lbl">Pickup Time</label>
									<input class="pick-input" name="shipperpickupTime" id="shipperpickupTime" value="#shippickupTime#" type="text" tabindex="#evaluate(currentTab+6)#" style="width:78px;"/>
									<div class="clear"></div>

									<label class="stopsLeftLabel">Time In</label>
									<input class="sm-input" name="shipperTimeIn" id="shipperTimeIn" value="#shiptimeIn#" type="text" tabindex="#evaluate(currentTab+7)#"/>
									<label class="sm-lbl" style="margin-left:14px;">Time Out</label>
									<input class="pick-input" name="shipperTimeOut" id="shipperTimeOut" value="#shipTimeOut#" type="text" tabindex="#evaluate(currentTab+8)#"/>
									<div class="clear"></div>

									<label class="stopsLeftLabel">Email</label>
									<input name="shipperEmail" id="shipperEmail" value="#shipemail#" type="text" tabindex="#evaluate(currentTab+9)#" style="width:139px;"/>

									<label class="ch-box">
									<input name="shipBlind" id="shipBlind" type="checkbox" <cfif shipBlind is true> checked="checked" </cfif> class="check" tabindex="#evaluate(currentTab+10)#"/>
									Ship Blind</label>
									<div class="clear"></div>

									<label class="space_it_medium margin_top">Instructions</label>
									<div class="clear"></div>
									<textarea rows="" name="shipperNotes" id="shipperNotes" class="carrier-textarea-medium" cols="" tabindex="#evaluate(currentTab+11)#">#shipInstructions#</textarea>
									<div class="clear"></div>

									<label class="space_it_medium margin_top">Directions</label>
									<div class="clear"></div>
									<textarea rows="" name="shipperDirection" id="shipperDirection" class="carrier-textarea-medium" cols="" tabindex="#evaluate(currentTab+12)#">#shipdirection#</textarea>
									<div class="clear"></div>
								</fieldset>
							</div>
						</div>
						<div class="clear"></div>
						<div align="center">
							<div style="border-bottom:1px solid ##e6e6e6; padding-top:7px;margin-bottom: 8px;"></div>
						</div>
						<div class="clear"></div>
					</div>	
					<div>
						<div id="ConsigneeInfo" style="height:15px;">
							<div class="" style="clear:both;">
								<div class="fa fa-<cfif not len(loadID) gt 1>minus<cfelse><cfif variables.flagstatusConsignee>minus<cfelse>plus</cfif></cfif>-circle PlusToggleButton" onclick="showHideConsineeIcons(this,1);" style="position:absolute;left:-16px;margin-top: -4px;"></div>
								<span class="ShipperHead" style="position:absolute;left:26px;margin-top: -10px;">Consignee</span>
							</div>
							<div style="position: absolute;right: 0;line-height: 25px;width: 475px;">
								<span style="display:inline-block;" name="span_Consignee" id ="span_Consignee"></span>
							</div>	
							<div class="form-con InfoConsinee1" style="margin-top:-6px;">
								<fieldset>
									<cfset shipperStopId = "">
									<cfset shipperStopNameList="">
									<cfset tempList = "">
									<input name="consignee" class="myElements" style="margin-left:112px;" id="consignee"  value="#ConsineeCustomerStopName#" onkeyup="ChkUpdteShipr(this.value,'consignee',''); showChangeAlert('consignee',''); "     title="Type text here to display list." tabindex="#evaluate(currentTab+13)#"/><img src="images/clear.gif" style="height:14px;width:14px"  title="Click here to clear consignee information"  onclick="ChkUpdteShipr('','consignee1','');">
									<input type="hidden" name="consigneeValueContainer" id="consigneeValueContainer" value="#consigneeCustomerID#"  message="Please select a Consignee"/>
									<input type="hidden" name="consigneeIsPayer" class="updateCreateAlert" id="consigneeIsPayer" value="#consigneeIsPayer#">
									<div class="clear"></div>

									<label>Name</label>
									<input name="consigneeName" id="consigneeName" value="#ConsineeCustomerStopName#" type="text" onkeyup="ChkUpdteShipr(this.value,'consignee',''); showChangeAlert('consignee',''); " tabindex="#evaluate(currentTab+14)#"/>
									<input type="hidden" name="consigneeNameText" id="consigneeNameText" value="#ConsineeCustomerStopName#">
									<div class="clear"></div>
									<input type="hidden" name="consigneeUpAdd" id="consigneeUpAdd" value="">

									<label>Address
    									<div class="clear"></div>
    									<span class="float_right">
    									   <script>var thisFromC = document.forms["load"]; </script>
        									<cfif request.qSystemSetupOptions.googleMapsPcMiler AND request.qcurAgentdetails.proMilesStatus>
        										<a href="##" onclick="Mypopitup('create_map.cfm?loc=#Consigneelocation#&city=#Consigneecity#&state=#Consigneestate1# #Consigneezipcode#&stopNo=1&shipOrConsName=#ConsineeCustomerStopName#&loadNum=#loadnumber#');" ><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="Pro Miles Map"/></a>
        									<cfelse>
        										<a href="##" onclick="Mypopitup('create_map.cfm?loc=#Consigneelocation#&city=#Consigneecity#&state=#Consigneestate1# #Consigneezipcode#&stopNo=1&shipOrConsName=#ConsineeCustomerStopName#&loadNum=#loadnumber#');" ><img style="float:left;" align="absmiddle" src="./map.jpg" width="24" height="24" alt="Google Map"/></a>
        									</cfif>
    									</span>
									</label>

									<textarea class="addressChange"  rows="" name="consigneelocation" id="consigneelocation" cols=""   data-role="" onkeydown="ChkUpdteShiprAddress(this.value,'consignee','');"  tabindex="#evaluate(currentTab+15)#">#Consigneelocation#</textarea>
									<div class="clear"></div>

									<label>City</label>
									<input class="addressChange" name="consigneecity" id="consigneecity" value="#Consigneecity#" type="text"  data-role=""  onkeydown="ChkUpdteShiprCity(this.value,'consignee','');" <cfif len(trim(url.loadid)) gt 1> tabindex="#evaluate(currentTab+17)#" <cfelse> tabindex="#evaluate(currentTab+16)#"</cfif>/>
									<div class="clear"></div>

									<label>State</label>
                                        <select name="consigneestate" id="consigneestate" onChange="addressChanged('');loadState(this,'consignee','');" <cfif len(trim(url.loadid)) gt 1> tabindex="#evaluate(currentTab+18)#"<cfelse> "#evaluate(currentTab+17)#"</cfif>>
                                            <option value="">Select</option>
                                            <cfloop query="request.qStates">
                                                <option value="#request.qStates.statecode#" <cfif request.qStates.statecode is Consigneestate1> selected="selected" </cfif> >#request.qStates.statecode#</option>
                                                <cfif request.qStates.statecode is Consigneestate1>
                                                    <cfset variables.statecode = #request.qStates.statecode#>
                                                </cfif>
                                            </cfloop>
                                        </select>
									<input type="hidden" name="consigneeStateName" id="consigneeStateName" value ="<cfif structKeyExists(variables,"statecode")>#variables.statecode#</cfif>">
									<div class="clear"></div>

									<label>Zip</label>
									<cfinclude template="getdistance.cfm">
									<input name="consigneeZipcode" id="consigneeZipcode" value="#Consigneezipcode#" type="text" <cfif len(trim(url.loadid)) gt 1> tabindex="#evaluate(currentTab+16)#"<cfelse> tabindex="#evaluate(currentTab+18)#"</cfif> />  
									<div class="clear"></div>

									<label>Contact</label>
									<input name="consigneeContactPerson" id="consigneeContactPerson" value="#ConsigneecontactPerson#" type="text" tabindex="#evaluate(currentTab+19)#"/>
									<div class="clear"></div>

									<label>Phone</label>
									<input class="phoneFormatValid" name="consigneePhone" id="consigneePhone" value="#ConsigneePhone#" onChange="ParseUSNumber(this);" type="text" tabindex="#evaluate(currentTab+20)#" />
									<div class="clear"></div>

									<label>Fax</label>
									<input name="consigneeFax" id="consigneeFax" value="#Consigneefax#" type="text" tabindex="#evaluate(currentTab+21)#"/>
									<div class="clear"></div>
								</fieldset>
							</div>
							<!---for promiles--->
							<input type="hidden" name="consigneeAddressLocation1" id="consigneeAddressLocation1" value="#Consigneecity#<cfif len(Consigneecity)>,</cfif> #Consigneestate1# #Consigneezipcode#">
							<div class="form-con InfoConsinee1" style="margin-top: 27px;">
								<fieldset>
									<label class="stopsLeftLabel">Delivery##</label>
									<input name="consigneePickupNo" id="consigneePickupNo" value="#ConsigneePickupNo#" type="text" tabindex="#evaluate(currentTab+22)#"/>
									<div class="clear"></div>
									<label class="stopsLeftLabel">Delivery Date *</label>
                                    <div style="position:relative;float:left;">
                                        <div style="float:left;">
									       <input class="sm-input datefield" name="consigneePickupDate" id="consigneePickupDate" value="#dateformat(ConsigneepickupDate,'mm/dd/yyyy')#" validate="date" message="Please enter a valid date" type="datefield" tabindex="#evaluate(currentTab+23)#"/> 
                                       </div>
                                    </div>
                                    <label class="sm-lbl" style="width: 77px;">Delivery Time</label>
                                    <input class="pick-input" name="consigneepickupTime" id="consigneepickupTime" value="#ConsigneepickupTime#" type="text" tabindex="#evaluate(currentTab+24)#" style="width:78px;"/>
                                    <div class="clear"></div>
                                    <label class="stopsLeftLabel">Time In</label>
									<input class="sm-input" name="consigneeTimeIn" id="consigneeTimeIn" value="#ConsigneetimeIn#" type="text" tabindex="#evaluate(currentTab+25)#"/>
									<label class="sm-lbl" style="margin-left:23px;">Time Out</label>
									<input class="pick-input" name="consigneeTimeOut" id="consigneeTimeOut" value="#ConsigneeTimeOut#" type="text" tabindex="#evaluate(currentTab+26)#"/>
									<div class="clear"></div>
									<label class="stopsLeftLabel">Email</label>
									<input name="consigneeEmail" id="consigneeEmail" value="#Consigneeemail#" type="text" tabindex="#evaluate(currentTab+27)#" style="width:139px;"/>
									<label class="ch-box">
									<input name="ConsBlind" id="ConsBlind" type="checkbox" <cfif ConsBlind is true> checked="checked" </cfif> class="check" tabindex="#evaluate(currentTab+28)#"/>
                                    Cons. Blind</label>
                                    <div class="clear"></div>
                                    <label class="space_it_medium margin_top">Instructions</label>
                                    <div class="clear"></div>
                                    <textarea rows="" name="consigneeNotes" id="consigneeNotes" class="carrier-textarea-medium"cols="" tabindex="#evaluate(currentTab+29)#">#ConsigneeInstructions#</textarea>
                                    <div class="clear"></div>
                                    <label class="space_it_medium margin_top">Directions</label>
                                    <div class="clear"></div>
                                    <textarea rows="" name="consigneeDirection" id="consigneeDirection" class="carrier-textarea-medium" cols="" tabindex="#evaluate(currentTab+30)#">#Consigneedirection#</textarea>
                                    <div class="clear"></div>
								</fieldset>
							</div>
						</div>
						<div class="clear"></div>
						<div align="center">
                            <div style="border-bottom:1px solid ##e6e6e6; padding-top:7px;"></div>
                        </div>
						<div class="clear"></div>
					</div>	

<!---Color Change #82bbef --->
					<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
						<div class="pg-title-carrier" style="float: left; width: 100%;padding-left:18px;">
							<h2 style="color:white;font-weight:bold;">#variables.freightBroker#</h2>
						</div>
					</div>

					<div class="form-heading-carrier">
						<div class="rt-button">
						</div>
						<div class="form-con" style="font-weight:bold;text-transform:uppercase;">
							<cfset carrierLinksOnClick = "">
							<a href="javascript:void(0);" onClick="chooseCarrier();" style="color:##236334">
								<img style="vertical-align:bottom;" src="images/change.png">
								Remove/Change #variables.freightBroker#
							</a>
						</div>
						<div class="clear"></div>
					</div>

					<div class="form-con">
						<input name="carrierID" id="carrierID" type="hidden" value="#carrierID#" />
						<fieldset>
							<div id="choosCarrier" style="<cfif len(carrierID) gt 0>display:none<cfelse>display:block</cfif>;"><input type="hidden" name="carrier_id" id="carrier_id" value="#carrierID#">
							<div class="clear"></div>
							<cfset CarrierFilter = "openCarrierFilter();">
							<label class="stopsLeftLabel" style="width: 102px !important;">Choose #variables.freightBroker#</label>
							<input name="selectedCarrier" id="selectedCarrierValue" class="carrier-box" style="margin-left: 0;width: 230px !important;" type="text" <cfif carrierLinksOnClick NEQ ''> disabled </cfif> tabindex="#evaluate(currentTab+31)#" title="Type text here to display list."/>
							<input name="selectedCarrierValueContainer" id="selectedCarrierValueValueContainer" type="hidden" />
							<div class="clear"></div>
							<div class="clear"></div>
							</div>
							<div id="CarrierInfo" style="<cfif len(carrierID) gt 0>display:block<cfelse>display:none</cfif>;">
							<cfinvoke component="#variables.objloadGateway#" method="getCarrierInfoForm" returnvariable="formHTML" carrierId="#carrierID#" urlToken="#session.URLToken#"  /> 
							#formHTML#
							</div>
							<label class="stopsLeftLabel" style="width: 102px !important;">Satellite Office</label>
							<select name="stOffice" id="stOffice" tabindex="#evaluate(currentTab+32)#">
    							<option value="">Choose a Satellite Office Contact</option>
                                <cfloop query="request.qOffices">
                                    <option value="#request.qOffices.CarrierOfficeID#" <cfif stofficeid is request.qOffices.CarrierOfficeID>selected ="selected"</cfif>>#request.qOffices.location#</option>
                                </cfloop>
							</select>
						</fieldset>
					</div>

					<div class="form-con">
						<fieldset>
							<div style="width:100%" class="carrierrightdiv">
                                <div style="width:200px;float:left;">
                                    <label class="carrierrightlabel">Booked With</label>
                                    <input name="bookedWith" value="#bookedWith1#" type="text" tabindex="#evaluate(currentTab+33)#" class="carriertextbox"/>
							    </div>
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Booked By</label>
							<select name="bookedBy" tabindex="#evaluate(currentTab+34)#" class="carriertextbox">
							<option value="">Select</option>
							<cfloop query="request.qSalesPerson">
							<option value="#request.qSalesPerson.EmployeeID#" <cfif request.qSalesPerson.EmployeeID eq  bookedBy> selected="selected" </cfif>>#request.qSalesPerson.Name#</option>
							</cfloop>
							</select>
							</div>
							</div>
							<div class="clear"></div>
							<div style="width:100%" class="carrierrightdiv">
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Equipment</label>
							<select name="equipment" id="equipment" tabindex="#evaluate(currentTab+35)#" class="carriertextbox">
							<option value="">Select</option>
							<cfloop query="request.qEquipments">
							<option value="#request.qEquipments.equipmentID#" <cfif equipment1 is request.qEquipments.equipmentID> selected="selected" </cfif>>#request.qEquipments.equipmentname#</option>
							</cfloop>
							</select>
							</div>
							<div style="width:200px;float:left;position: relative;">
							<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef1#</label>
							<input name="userDef1" value="#request.LoadStopInfoShipper.userDef1#" type="text" tabindex="#evaluate(currentTab+36)#" class="carriertextbox userOnchageUpdate" data-loadid="#url.loadid#" data-inputname="userDef1"/>
							</div>
							</div>
							<div class="clear"></div>
							<div style="width:100%" class="carrierrightdiv">
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Driver</label>
							<input name="driver" value="#driver#" type="text" tabindex="#evaluate(currentTab+37)#" class="carriertextbox"/>
							</div>
							<div style="width:200px;float:left;position: relative;">
							<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef2#</label>
							<input name="userDef2" value="#request.LoadStopInfoShipper.userDef2#" type="text" tabindex="#evaluate(currentTab+38)#" class="carriertextbox userOnchageUpdate" data-loadid="#url.loadid#" data-inputname="userDef2"/>
							</div>
							</div>
							<div class="clear"></div>
							<div style="width:100%" class="carrierrightdiv">
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Driver Cell</label>
							<input name="driverCell" value="#driverCell#" type="text" tabindex="#evaluate(currentTab+39)#" class="carriertextbox"/>
							</div>
							<div style="width:200px;float:left;position: relative;">
							<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef3#</label>
							<input name="userDef3" value="#request.LoadStopInfoShipper.userDef3#" type="text" tabindex="#evaluate(currentTab+40)#" class="carriertextbox userOnchageUpdate" data-loadid="#url.loadid#" data-inputname="userDef3"/>
							</div>
							</div>
							<div class="clear"></div>
							<div style="width:100%" class="carrierrightdiv">
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Truck##</label>
							<input name="truckNo" value="#truckNo#" type="text" tabindex="#evaluate(currentTab+41)#" class="carriertextbox"/>
							</div>
							<div style="width:200px;float:left;position: relative;">
							<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef4#</label>
							<input name="userDef4" value="#request.LoadStopInfoShipper.userDef4#" type="text" tabindex="#evaluate(currentTab+42)#" class="carriertextbox userOnchageUpdate" data-loadid="#url.loadid#" data-inputname="userDef4"/>
							</div>
							</div>
							<div class="clear"></div>
							<div style="width:100%" class="carrierrightdiv">
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Trailer##</label>
							<input name="TrailerNo" value="#TrailerNo#" type="text" tabindex="#evaluate(currentTab+43)#" class="carriertextbox"/>
							</div>
							<div style="width:200px;float:left;position: relative;">
							<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef5#</label>
							<input name="userDef5" value="#request.LoadStopInfoShipper.userDef5#" type="text" tabindex="#evaluate(currentTab+44)#" class="carriertextbox userOnchageUpdate" data-loadid="#url.loadid#" data-inputname="userDef5"/>
							</div>
							</div>
							<div class="clear"></div>
							<div style="width:100%" class="carrierrightdiv">
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Ref##</label>
							<input name="refNo" value="#refNo#" type="text" tabindex="#evaluate(currentTab+45)#" class="carriertextbox"/>
							</div>
							<div style="width:200px;float:left;position: relative;">
							<label class="carrierrightlabel">#request.qSystemSetupOptions.userDef6#</label>
							<input name="userDef6" value="#request.LoadStopInfoShipper.userDef6#" type="text" tabindex="#evaluate(currentTab+46)#" class="carriertextbox userOnchageUpdate" data-loadid="#url.loadid#" data-inputname="userDef6"/>
							</div>
							</div>
							<div class="clear"></div> 
							<div style="width:100%" class="carrierrightdiv">
							<div style="width:200px;float:left;">
							<label class="carrierrightlabel">Miles##</label>
							<input name="milse" class="careermilse carriertextbox" id="milse" tabindex="#evaluate(currentTab+47)#" value="#milse#" type="text" onClick="showWarningEnableButton('block','');" onBlur="showWarningEnableButton('none','');CalculateTotal('#Application.dsn#');changeQuantityWithValue(this, 1);" onChange="changeQuantity(this.id,this.value,'type');calculateTotalRates('#application.DSN#');" style="width:168px;" />
							</div>
							<div style="width:200px;float:left;">
							<input id="refreshBtn" value="" type="button" <!---  disabled  ---> onClick="refreshMilesClicked('');" style="width:17px; height:22px; background: url('images/refresh.png') no-repeat left top;"/>
							<input id="milesUpdateMode" name="milesUpdateMode" type="hidden" value="auto">
							</div>			
							</div>

							<div class="clear"></div>
							<div id="warning" class="msg-area" style="display:none; width:180px;">Warning!! Mannual Miles change has disabled automatic miles update on address change for Stop1. After changing an address use<b>Recalculate Miles</b>button to calculate miles again.</div>
						</fieldset>
					</div>
					<div class="clear"></div>
					<div class="carrier-gap">&nbsp;</div>
					<div class="clear"></div>
          <div class="addcommodityButton"><input type="button" onclick="addNewRowCommodities(this,1)" value="Add New Row" ></div>
					<div class="carrier-mid">
						<table width="100%" class="noh carrierCalTable" border="0" cellspacing="0" cellpadding="0" id="commodity_1">
							<thead>
								<tr>
								<th width="5" align="right" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
								<th align="right" valign="middle" class="head-bg">Fee</th>
								<th align="right" valign="middle" width="10%" class="head-bg">Qty</th>
								<th align="right" valign="middle" class="head-bg textalign">Type</th>
								<th align="right" valign="middle" class="head-bg" <cfif request.qSystemSetupOptions.commodityWeight> width="30%"<cfelse> width="71%" </cfif>>Description</th>
								<cfif request.qSystemSetupOptions.commodityWeight>
									<th align="right" valign="middle" class="head-bg">Wt(lbs)</th>
								</cfif>
								<th align="right" valign="middle" class="head-bg">Class</th>
								<th align="right" valign="middle" class="head-bg">Cust. Rate</th>
								<th align="right" valign="middle" class="head-bg textalign">#variables.freightBrokerShortForm#. Rate</th>
								<th align="right" valign="middle" class="head-bg textalign">#variables.freightBrokerShortForm#.% of Cust Total</th>
								<th align="right" valign="middle" class="head-bg textalign">Cust. Total</th>
								<th align="right" valign="middle" class="head-bg2 textalign">#variables.freightBrokerShortForm#. Total</th>
								<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
								</tr>
							</thead>
							<tbody>
								<cfif (structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1) OR (structkeyexists(url,"loadToBeCopied") and len(trim(url.loadToBeCopied)) gt 1)>
								<!---<cfdump var="#request.qItems#" abort="true"/>--->
                <cfset countCommodities=1>
                <cfset currentTab = 47>

								<cfloop query="request.qItems">
									<tr <cfif request.qItems.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> id="commodities1_#countCommodities#">
										<td height="20" class="lft-bg">&nbsp;</td>
										<td class="lft-bg2" valign="middle" align="center"><input name="isFee_#countCommodities#" id="isFee_#countCommodities#" class="check isFee" <cfif request.qItems.fee is 1> checked="checked" </cfif> type="checkbox" tabindex="#evaluate(currentTab+1)#" /></td>
										<td class="normaltdC" valign="middle" align="left"><input name="qty_#countCommodities#" id="qty_#countCommodities#" onchange="CalculateTotal('#Application.dsn#')" class="q-textbox qty" type="text" value="#request.qItems.qty#"  tabindex="#evaluate(currentTab+1)#" /></td>

                                        <td class="normaltdC" valign="middle" align="left">
                                            <select name="unit_#countCommodities#" id="unit_#countCommodities#" class="t-select unit typeSelect1" onChange="changeQuantityWithtype(this,'');checkForFee(this.value,'#request.qItems.currentRow#','','#application.dsn#');CalculateTotal('#Application.dsn#'); autoloaddescription(this, '', '#countCommodities#','#application.dsn#');" tabindex="#evaluate(currentTab+1)#">
                                                <option value=""></option>
                                                <cfloop query="request.qUnits">
                                                    <option value="#request.qUnits.unitID#" <cfif request.qUnits.unitID is request.qItems.unitid> selected="selected" </cfif>>#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
                                                </cfloop>
                                            </select>
                                        </td>

										<td class="normaltdC" valign="middle" align="left"><input name="description_#countCommodities#" id="description_#countCommodities#" class="t-textbox" value="#replace(request.qItems.description,'"','&quot;','all')#" type="text" tabindex="#evaluate(currentTab+1)#" <cfif not request.qSystemSetupOptions.commodityWeight> style="width:220px;" </cfif> /></td>
										<cfif request.qSystemSetupOptions.commodityWeight>
											<td class="normaltdC" valign="middle" align="left"><input name="weight_#countCommodities#" class="wt-textbox" value="#request.qItems.weight#" type="text" tabindex="#evaluate(currentTab+1)#" /></td>
										</cfif>
										<td class="normaltdC" valign="middle" align="left" >
										<select name="class_#countCommodities#" style="width:60px;" class="t-select sel_class" tabindex="#evaluate(currentTab+1)#" >
										<option value=""></option>
										<cfloop query="request.qClasses">
										<option value="#request.qClasses.classId#" <cfif request.qClasses.classId is request.qItems.classid> selected="selected" </cfif>>#request.qClasses.className#</option>
										</cfloop>
										</select>
										</td>
										
										<cfset variables.CUSTRATE = request.qItems.CUSTRATE>
										<cfset variables.CARRRATE = request.qItems.CARRRATE>
										<cfif request.qItems.CUSTRATE eq "">
										<cfset variables.CUSTRATE = '0.00' >
										</cfif>
										<cfif request.qItems.CARRRATE eq "">
										<cfset variables.CARRRATE = '0.00' >
										</cfif>					
										<td class="normaltdC" valign="middle" align="left"><input name="CustomerRate_#countCommodities#" id="CustomerRate_#countCommodities#" class="q-textbox CustomerRate" value="#replace(myCurrencyFormatter(variables.CUSTRATE),",","","ALL")#" onChange="CalculateTotal('#Application.dsn#');formatDollar(this.value, this.id);"  type="text" tabindex="#evaluate(currentTab+1)#"/></td>
										<td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate_#countCommodities#" id="CarrierRate_#countCommodities#" class="q-textbox CarrierRate" value="#replace(myCurrencyFormatter(variables.CARRRATE),",","","ALL")#" onChange="CalculateTotal('#Application.dsn#');formatDollar(this.value, this.id);"  type="text" tabindex="#evaluate(currentTab+1)#" /></td>

										<cfif request.qItems.CarrRateOfCustTotal EQ "">
										<cfset variables.CarrRateOfCustTotal = 0.00>
										<cfelse>
										<cfset variables.CarrRateOfCustTotal = request.qItems.CarrRateOfCustTotal>
										</cfif>
										<td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer_#countCommodities#" id="CarrierPer_#countCommodities#" style="width:105px;" class="q-textbox CarrierPer" value="#variables.CarrRateOfCustTotal#%" onChange="ConfirmMessage('#request.qItems.currentRow#',0)"  type="text" tabindex="#evaluate(currentTab+1)#" /></td>
										<td class="normaltdC" valign="middle" align="left"><input name="custCharges_#countCommodities#" id="custCharges_#countCommodities#" class="q-textbox custCharges" value="#request.qItems.CUSTCHARGES#" onChange="CalculateTotal('#Application.dsn#');" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
										<td class="normaltd2C" valign="middle" align="left"><input name="carrCharges_#countCommodities#" id="carrCharges_#countCommodities#" class="q-textbox carrCharges" value="#request.qItems.CARRCHARGES#" onChange="CalculateTotal('#Application.dsn#');" type="text" tabindex="#evaluate(currentTab+1)#" /></td>
										<td class="normal-td3">&nbsp;</td>
									</tr>
                  <cfset countCommodities++>
								</cfloop>
                <cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
                    <input type="hidden" value="#request.qItems.Recordcount#" name="TotalrowCommodities1"  id="TotalrowCommodities1">
                  <input type="hidden" value="#request.qItems.Recordcount#" name="totalResult1"  id="totalResult1">
                  <input type="hidden" value="#request.qItems.Recordcount#" name="commoditityAlreadyCount1"  id="commoditityAlreadyCount1">
                </cfif> 
                <cfif structkeyexists(url,"loadToBeCopied") and len(trim(url.loadToBeCopied)) gt 1>
                    <input type="hidden" value="#request.qItems.Recordcount#" name="TotalrowCommodities1"  id="TotalrowCommodities1">
                  <input type="hidden" value="#request.qItems.Recordcount#" name="totalResult1"  id="totalResult1">
                  <input type="hidden" value="#request.qItems.Recordcount#" name="commoditityAlreadyCount1"  id="commoditityAlreadyCount1">
                </cfif> 
								<!--- <cfif request.qItems.recordcount lt 7>
								<cfset remainCol=request.qItems.recordcount+1>
								<cfloop from ="#remainCol#" to="7" index="rowNum">
								<tr <cfif rowNum mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> id="commodities1_#rowNum#">
								<td height="20" class="lft-bg">&nbsp;</td>
								<td class="lft-bg2" valign="middle" align="center"><input name="isFee#rowNum#" id="isFee#rowNum#" class="isFee check" type="checkbox" tabindex="#evaluate(currentTab+1)#"/></td>
								<td class="normaltdC" valign="middle" align="left"><input name="qty#rowNum#" class="qty q-textbox" type="text" onChange="CalculateTotal('#Application.dsn#')" tabindex="#evaluate(currentTab+1)#"/></td>
								<td class="normaltdC" valign="middle" align="left"><select name="unit#rowNum#" id="unit#rowNum#" class="t-select" onChange="checkForFee(this.value,'#rowNum#','','#application.dsn#');CalculateTotal('#Application.dsn#');" tabindex="#evaluate(currentTab+1)#">
								<option value=""></option>
								<cfloop query="request.qUnits">
								<option value="#request.qUnits.unitID#">#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
								</cfloop>
								</select></td>
								<td class="normaltdC" valign="middle" align="left"><input name="description#rowNum#" id="description#rowNum#" class="t-textbox" type="text" tabindex="#evaluate(currentTab+1)#" <cfif not request.qSystemSetupOptions.commodityWeight> style="width:220px;" </cfif> /></td>
								<cfif request.qSystemSetupOptions.commodityWeight>
									<td class="normaltdC" valign="middle" align="left"><input name="weight#rowNum#" class="wt-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
								</cfif>
								<td class="normaltdC" valign="middle" align="left"><select name="class#rowNum#" class="t-select sel_class" tabindex="#evaluate(currentTab+1)#" style="width:60px;">
								<option value=""></option>
								<cfloop query="request.qClasses">
								<option value="#request.qClasses.classId#">#request.qClasses.className#</option>
								</cfloop>
								</select></td>
								<td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#rowNum#" id="CustomerRate#rowNum#" tabindex="#evaluate(currentTab+1)#" class="q-textbox CustomerRate" onChange="CalculateTotal('#Application.dsn#')" type="text" value="#DollarFormat(variables.CustomerRate)#" /></td>
								<td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#rowNum#" id="CarrierRate#rowNum#" tabindex="#evaluate(currentTab+1)#"  class="q-textbox CarrierRate" onChange="CalculateTotal('#Application.dsn#')"  type="text" value="#DollarFormat(variables.CarrierRate)#"/></td>
								<td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer#rowNum#" id="CarrierPer#rowNum#" style="width:105px;" class="q-textbox CarrierPer" value="#request.qItems.CarrRateOfCustTotal#%" onChange="ConfirmMessage('#request.qItems.currentRow#',0)"  type="text" tabindex="" /></td>
								<td class="normaltdC" valign="middle" align="left"><input name="custCharges#rowNum#" id="custCharges#rowNum#" tabindex="#evaluate(currentTab+1)#" class="q-textbox custCharges" onChange="CalculateTotal('#Application.dsn#');" type="text" value="0.00" /></td>
								<td class="normaltd2C" valign="middle" align="left"><input name="carrCharges#rowNum#" id="carrCharges#rowNum#" tabindex="#evaluate(currentTab+1)#"  class="q-textbox carrCharges" onChange="CalculateTotal('#Application.dsn#');" type="text" value="0.00"/></td>
								<td class="normal-td3C normal-td3">&nbsp;</td>
								</tr> 
                <cfdump var="1" />
								</cfloop> 
								</cfif>--->
								<cfelse>
								<cfset currentTab=74>
								<cfloop from ="1" to="1" index="rowNum">
								<tr <cfif rowNum mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> id="commodities1_#rowNum#">
								<td height="20" class="lft-bg">&nbsp;</td>
								<td class="lft-bg2" valign="middle" align="center"><input name="isFee_#rowNum#" id="isFee_#rowNum#" class="isFee check" type="checkbox" tabindex="#evaluate(currentTab+1)#"/></td>
								<td class="normaltdC" valign="middle" align="left"><input name="qty_#rowNum#" onChange="CalculateTotal('#Application.dsn#')" class="qty q-textbox" type="text" value="1" tabindex="#evaluate(currentTab+1)#"/></td>
								
                                <td class="normaltdC" valign="middle" align="left">
                                    <select name="unit_#rowNum#" id="unit_#rowNum#" class="t-select unit typeSelect1" onChange="changeQuantityWithtype(this,'');checkForFee(this.value,'#rowNum#','','#application.dsn#');CalculateTotal('#Application.dsn#'); autoloaddescription(this, '', '#rowNum#','#application.dsn#');" tabindex="#evaluate(currentTab+1)#">
								        <option value=""></option>
								        <cfloop query="request.qUnits">
        								    <option value="#request.qUnits.unitID#">#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
        								</cfloop>
								    </select>
                                </td>
								<td class="normaltdC" valign="middle" align="left"><input name="description_#rowNum#" id="description_#rowNum#" class="t-textbox" type="text" tabindex="#evaluate(currentTab+1)#" <cfif not request.qSystemSetupOptions.commodityWeight> style="width:225px;" </cfif> /></td>
								<cfif request.qSystemSetupOptions.commodityWeight>
									<td class="normaltdC" valign="middle" align="left"><input name="weight_#rowNum#" class="wt-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
								</cfif>	
								<td class="normaltdC" valign="middle" align="left"><select name="class_#rowNum#" class="t-select" tabindex="#evaluate(currentTab+1)#" style="width:60px;">
								<option value=""></option>
								<cfloop query="request.qClasses">
								<option value="#request.qClasses.classId#">#request.qClasses.className#</option>
								</cfloop>
								</select></td>
								<cfset variables.carrierPercentage = 0>
								<cfif IsDefined("request.qItems.CarrRateOfCustTotal") and IsNumeric(request.qItems.CarrRateOfCustTotal)>
								<cfset variables.carrierPercentage = request.qItems.CarrRateOfCustTotal>
								</cfif>
								<td class="normaltdC" valign="middle" align="left"><input name="CustomerRate_#rowNum#" id="CustomerRate_#rowNum#" tabindex="#evaluate(currentTab+1)#" class="q-textbox CustomerRate" onChange="CalculateTotal('#Application.dsn#')"  type="text" value="#DollarFormat(variables.CustomerRate)#" /></td>
								<td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate_#rowNum#" id="CarrierRate_#rowNum#" tabindex="#evaluate(currentTab+1)#"  class="q-textbox CarrierRate"  onChange="CalculateTotal('#Application.dsn#')" type="text" value="#DollarFormat(variables.CarrierRate)#"/></td>
								<td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer_#rowNum#" id="CarrierPer_#rowNum#" style="width:105px;" class="q-textbox CarrierPer" value="#variables.carrierPercentage#%" onChange="ConfirmMessage('#rowNum#',0)"  type="text" tabindex="#evaluate(currentTab+1)#" /></td>
								<td class="normaltdC" valign="middle" align="left"><input name="custCharges_#rowNum#" id="custCharges_#rowNum#" class="q-textbox custCharges" onChange="CalculateTotal('#Application.dsn#');" type="text" value="0.00" tabindex="#evaluate(currentTab+1)#" /></td>
								<td class="normaltd2C" valign="middle" align="left"><input name="carrCharges_#rowNum#" id="carrCharges_#rowNum#" class="q-textbox carrCharges" onChange="CalculateTotal('#Application.dsn#');" type="text" value="0.00" tabindex="#evaluate(currentTab+1)#" /></td>
								<td class="normal-td3C normal-td3">&nbsp;</td>
								</tr> 
                  <input type="hidden" value="1" name="TotalrowCommodities1"  id="TotalrowCommodities1">
                  <input type="hidden" value="1" name="totalResult1"  id="totalResult1">
								</cfloop>
								</cfif>
							</tbody>
							<tfoot>
								<tr>
								<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
								<td <cfif request.qSystemSetupOptions.commodityWeight> colspan="11" <cfelse>  colspan="10"</cfif> align="left" valign="middle" class="footer-bg"></td>
								<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
								</tr>
							</tfoot>
						</table>
						<div class="clear"></div>
					</div>
					<div class="carrier-gap">&nbsp;</div>
				</div>
			</div>
		</div>
		<div class="form-heading">
			<div class="rt-button2">
				<input name="addstopButton" disabled="yes" type="button" onClick="AddStop('stop2',2);setStopValue();" class="green-btn" value="Add Stop" />
				<!--- <input name="" type="button" class="bttn" value="Delete Stop" /> --->
			</div>
			<div class="clear"></div>

			<div class="rt-button">
				<cfif ListContains(session.rightsList,'runReports',',')>
					<cfset carrierReportOnClick = "window.open('../reports/loadReportForCarrierConfirmation.cfm?loadid=#editid#&#session.URLToken#')">
					<!---<cfset customerReportOnClick = "window.open('customer-confirmation.cfm?AllNeededVlue=AllInfo&#session.URLToken#')">--->
					<cfset customerReportOnClick = "window.open('../reports/CustomerInvoiceReport.cfm?loadid=#editid#&#session.URLToken#')">
				<cfelse>
					<cfset carrierReportOnClick = "">
					<cfset customerReportOnClick = "">
				</cfif>
				<cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
					<p>
					<input type="button" value="#variables.freightBrokerReport# Report" class="black-btn" onclick="#carrierReportOnClick#" <cfif carrierReportOnClick eq ""> disabled </cfif>/>
					<input type="button" class="black-btn" value="B.O.L. Report" onClick="self.location='index.cfm?event=BOLReport&loadid=#url.loadid#&#session.URLToken#'"/>
					<!--- BEGIN: Prevent already transcore synced load update from Agent has no Transcore Login setup in their profile Date:20 Sep 2013  --->
					<cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
						<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
							<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
						<cfelse>
							<cfif local.lockloadStatsFlag>
								<input id="save" name="save" type="button" class="green-btn" value="Save" />
							<cfelse>
								<input name="save" type="submit" class="green-btn"  onClick="alert('Any changes you make will not be updated to the DAT Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButStayOnPage('#url.loadid#');" onfocus="checkUnload();" value="Save">
							</cfif>
						</cfif>	
					<cfelseif request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
						<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
							<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
						<cfelse>
							<cfif local.lockloadStatsFlag>
								<input id="save" name="save" type="button" class="green-btn" value="Save" />
							<cfelse>
								<input name="save" type="submit" class="green-btn"   onClick="alert('Any changes you make will not be updated to the 123Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButStayOnPage('#url.loadid#');" onfocus="checkUnload();" value="Save">
							</cfif>  
						</cfif>	
					<cfelse>
						<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
							<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
						<cfelse>
							<cfif local.lockloadStatsFlag>
								<input id="save" name="save" type="button" class="green-btn" value="Save" />
							<cfelse>
								<input name="save" type="submit" class="green-btn"  onClick="return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="yes" />
							</cfif> 
						</cfif>	
					</cfif>
				
				<!--- END: Prevent already transcore synced load update from Agent has no Transcore Login setup in their profile Date:20 Sep 2013  --->
				</p>
				<p>
				<cfif variables.statusDispatch eq 'Rate Quote'>
					<input id="custInvReportLink" style="width:125px !important;" type="button" class="black-btn custInvReportLink" value="Rate Quote"  <cfif customerReportOnClick eq "">  disabled </cfif>/>
				<cfelseif variables.statusDispatch eq 'Rate Confirmation'>
					<input id="custInvReportLink" style="width:125px !important;" type="button" class="black-btn custInvReportLink" value="Rate Conf"  <cfif customerReportOnClick eq "">  disabled </cfif>/>
				<cfelseif variables.statusDispatch eq 'Invoice'>
					<input id="custInvReportLink" style="width:125px !important;" type="button" class="black-btn custInvReportLink" value="Invoice"  <cfif customerReportOnClick eq "">  disabled </cfif>/>
				</cfif>
				<!---input type="button" value="Quote/R.Conf/Inv" class="black-btn" onclick="#customerReportOnClick#" <cfif customerReportOnClick eq "">  disabled </cfif>/--->
				<input type="button" value="Copy Load" class="blue-btn" onclick="window.open('index.cfm?event=addload&loadToBeCopied=#url.loadid#&#session.URLToken#')" <cfif variables.statusDispatch eq 'Customer Invoice'> style ="margin-left: 131px;"</cfif>/>
				<!--- BEGIN: Prevent already transcore synced load update from Agent has no Transcore Login setup in their profile Date:20 Sep 2013  --->
				<cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
					<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
					  <cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save & Exit" />
					  <cfelse>
						<input name="submit" type="submit" class="green-btn"   onClick="alert('Any changes you make will not be updated to the DAT Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButExitPage('#url.loadid#');"  onfocus="checkUnload();" value="Save & Exit">
					  </cfif> 
					</cfif>  
				<cfelseif request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save & Exit" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"   onClick="alert('Any changes you make will not be updated to the 123Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButExitPage('#url.loadid#');"  onfocus="checkUnload();" value="Save & Exit">
					</cfif> 
				<cfelse>
					<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>	
						<cfif local.lockloadStatsFlag>
							<input name="submit" type="button" class="green-btn" value="Save & Exit" />
						<cfelse>
							<input name="submit" type="submit" class="green-btn"  onClick="return saveButExitPage('#url.loadid#');" onfocus="checkUnload();" value="Save & Exit" disabled="yes" />
						</cfif> 
					</cfif>
				</cfif>	
				<!--- END: Prevent already transcore synced load update from Agent has no Transcore Login setup in their profile Date:20 Sep 2013  --->
				</p>
				<cfelse>
					<p>
					<!---cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
					<input name="save" type="submit" class="green-btn" onClick="alert('Any changes you make will not be updated to the DAT Load Board because you do not have credentials setup on your Agent Profile.');return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="yes" />
					<cfelseif request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
					<input name="save" type="submit" class="green-btn" onClick="alert('Any changes you make will not be Added to the 123Load Board because you do not have credentials setup on your Agent Profile.');return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="yes" />
					<cfelse--->
			<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
				<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
			<cfelse>
				<cfif local.lockloadStatsFlag>
					<input name="submit" type="button" class="green-btn" value="Save" />
				<cfelse>
					<input name="save" type="submit" class="green-btn"  onClick="return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save" disabled="yes" />
				</cfif>
			</cfif>	
					<!----/cfif---->
					<!---cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
						<input name="submit" type="submit" class="green-btn" onClick="alert('Any changes you make will not be Added to the DAT Board because you do not have credentials setup on your Agent Profile.');return saveButExitPage('2');" onfocus="checkUnload();" value="Save & Exit" disabled="yes" />
					<cfelseif request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
						<input name="submit" type="submit" class="green-btn" onClick="alert('Any changes you make will not be Added to the 123Load Board because you do not have credentials setup on your Agent Profile.');return saveButExitPage('2');" onfocus="checkUnload();" value="Save & Exit" disabled="yes" />
					<cfelse--->
				<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>		
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save & Exit" />
					<cfelse>
					   <input name="submit" type="submit" class="green-btn"  onClick="return saveButExitPage('2');" onfocus="checkUnload();" value="Save & Exit" disabled="yes" />
					</cfif>  
				</cfif>	
					<!---/cfif--->	
					</p>
				</cfif>
				<input type="hidden" name="shipperFlag" id="shipperFlag" value="0">
				<input type="hidden" name="consigneeFlag" id="consigneeFlag" value="0">	
			</div>
		</div>
		<div class="clear"></div>
		<cfif totStops eq  1>
			<cfif  structkeyexists(url,"loadid") and len(url.loadid) gt 1>
				<cfif request.qLoads.RecordCount GT 0 AND IsDefined("request.qLoads.LastModifiedDate") AND IsDefined("request.qLoads.ModifiedBy")>
					<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;">Last Updated:
						<cfif isDefined("request.qLoads")>
							&nbsp;&nbsp;&nbsp;#request.qLoads.LastModifiedDate#&nbsp;&nbsp;&nbsp;#request.qLoads.ModifiedBy#
						</cfif>
					</p>
				</cfif>
			</cfif>
		</cfif>
		<div class="white-bot"></div>
	</div>
  <!---End stop block 1--->
  <div class="gap"></div>
  <!--- stop block 2--->
  <cfset StopNoIs = 1> 
  <input type="hidden" name="CurrStopNo" id="CurrStopNo" value="0">
  <cfloop from="2" to="10" index="stopNo">
	<cfif NoOfStopsToShow gte StopNoIs>
	<div class="white-con-area">
		<div id="stop#stopNo#" <cfif NoOfStopsToShow gte StopNoIs>style="display:block"</cfif>>
			<div id="tabs#stopNo#" class="tabsload">
				<ul style="height:27px;">
					<li><a href="##tabs-1">Stop #stopNo#</a></li>
					<li><a href="index.cfm?event=loadIntermodal&stopno=#stopNo#&loadID=#loadID#&#Session.URLToken#">Intermodal</a></li>
					<div style="float: left;width: 23%; margin-left: 27px;" id="StopNo#stopNo#">
						<div class="form-con" style="width:103%">
							<ul class="load-link" id="ulStopNo1" style="line-height:26px;">
								<cfloop from="1" to="#totStops#" index='stpNoid'>
									<cfif stpNoid is 1>
										<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
									<cfelse>
										<li><a href="##StopNo#stpNoid#">###stpNoid#</a></li>
									</cfif>
								</cfloop>
								<!--- <li><a href="##">##2</a></li><li><a href="##">##3</a></li> --->
							</ul>
							<div class="clear"></div>
						</div>
					</div>
					<div style="float: left; width: 56%; height:6px;">
						<h2 id="loadNumber" style="color:white;font-weight:bold;margin-top: -11px;">Load###Ucase(loadnumber)#</h2>
					</div>
				</ul>
				<div id="tabs-1">
					<cfset stopNumber=stopNo>
					<cfinclude template="nextStop.cfm">
				</div>				
			</div>
			
			<div class="form-heading-loop">
				<div class="rt-button3">
					<input name="addstopButton" disabled="yes" type="button" class="green-btn" onclick="AddStop('stop#(stopNumber+1)#',#(stopNumber+1)#);setStopValue();" value="Add Stop" />
					<input name="" type="button" class="red-btn" onclick="deleteStop('stop#stopNumber#',#(stopNumber-1)#,#showItems#,'#nextLoadStopId#','#application.DSN#','#loadIDN#');setStopValue();" value="Delete Stop" /></p>
				</div>
				<div class="clear"></div>
				<cfif ListContains(session.rightsList,'runReports',',')>
					<cfset carrierReportOnClick = "window.open('../reports/loadReportForCarrierConfirmation.cfm?loadid=#editid#&#session.URLToken#')">
					<cfset customerReportOnClick = "window.open('customer-confirmation.cfm?AllNeededVlue=AllInfo&#session.URLToken#')">
				<cfelse>
					<cfset carrierReportOnClick = "">
					<cfset customerReportOnClick = "">
				</cfif>
				<cfif isdefined("url.loadid") and len(trim(url.loadid)) gt 1>
					<div class="rt-button">
						<input type="button" value="#variables.freightBrokerReport# Report" class="report-btn" onclick="#carrierReportOnClick#" <cfif carrierReportOnClick eq ""> disabled </cfif>/>
			<cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
				<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
					<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
				<cfelse>
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"  onClick="alert('Any changes you make will not be Added to the DAT Board because you do not have credentials setup on your Agent Profile.');return saveButStayOnPage('#url.loadid#');setStopValue();" onFocus="checkUnload();" value="Save"  disabled  />
					</cfif>
				</cfif>	
            <cfelseif  request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
				<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
					<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
				<cfelse>
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"  onClick="alert('Any changes you make will not be Added to the 123Load Board because you do not have credentials setup on your Agent Profile.');return saveButStayOnPage('#url.loadid#');setStopValue();" onFocus="checkUnload();" value="Save"  disabled  />
					</cfif>
				</cfif>	
            <cfelse>
				<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
					<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
				<cfelse>
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"  onClick="return saveButStayOnPage('#url.loadid#');setStopValue();" onFocus="checkUnload();" value="Save"  disabled  />
					 </cfif>
				</cfif>		
			</cfif>
			<cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
				<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save & Exit" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"  onClick="alert('Any changes you make will not be Added to the DAT Board because you do not have credentials setup on your Agent Profile.');return saveButExitPage('#url.loadid#');setStopValue();" onfocus="checkUnload();" value="Save & Exit" />
					</cfif> 
				</cfif>		
            <cfelseif  request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
				<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save & Exit" />
					<cfelse>
					  <input name="submit" type="submit" class="green-btn"  onClick="alert('Any changes you make will not be Added to the 123Load Board because you do not have credentials setup on your Agent Profile.');return saveButExitPage('#url.loadid#');setStopValue();" onfocus="checkUnload();" value="Save & Exit" />
					</cfif> 
				</cfif>		
            <cfelse>
				<cfif not (structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',','))>
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save & Exit" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"  onClick="return saveButExitPage('#url.loadid#');setStopValue();" onfocus="checkUnload();" value="Save & Exit" />
					</cfif>  
				</cfif>
			</cfif>	
						<cfif variables.statusDispatch eq 'Rate Quote'>
							<input id="custInvReportLink" style="width:125px !important;" type="button" class="black-btn custInvReportLink" value="Rate Quote"  <cfif customerReportOnClick eq "">  disabled </cfif>/>
						<cfelseif variables.statusDispatch eq 'Rate Confirmation'>
							<input id="custInvReportLink" style="width:125px !important;" type="button" class="black-btn custInvReportLink" value="Rate Conf"  <cfif customerReportOnClick eq "">  disabled </cfif>/>
						<cfelseif variables.statusDispatch eq 'Invoice'>
							<input id="custInvReportLink" style="width:125px !important;" type="button" class="black-btn custInvReportLink" value="Invoice"  <cfif customerReportOnClick eq "">  disabled </cfif>/>
						</cfif>
						<!---input type="button"  value="Customer Report" class="report-btn" onclick="#customerReportOnClick#" <cfif customerReportOnClick eq "">  disabled </cfif>/--->
						<input type="button"  value="Copy Load" class="bttn" onclick="window.open('index.cfm?event=addload&loadToBeCopied=#url.loadid#&#session.URLToken#')" <cfif variables.statusDispatch eq 'Customer Invoice'> style ="margin-left: 131px;"</cfif>/>
						<input name="" type="button" class="bttn" onclick="javascript:history.back();" value="Back" />
					</div>
				<cfelse>
					<div class="rt-button">
						<!---cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
								<input name="submit" type="submit" class="green-btn" onClick="alert('Any changes you make will not be Added to the DAT Load Board because you do not have credentials setup on your Agent Profile.');return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save"  disabled />
						<cfelseif  request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
								<input name="submit" type="submit" class="green-btn" onClick="alert('Any changes you make will not be Added to the 123Load Board because you do not have credentials setup on your Agent Profile.');return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save"  disabled />
						<cfelse--->
				<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
					<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
				<cfelse>		
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"  onClick="return saveButStayOnPage('#url.loadid#');" onFocus="checkUnload();" value="Save"  disabled />
					</cfif> 
				</cfif>	
						<!---/cfif--->
						<!---cfif request.qcurAgentdetails.integratewithTran360 EQ false AND posttoTranscore EQ 1>
							<input name="submit" type="submit" class="green-btn" onClick="alert('Any changes you make will not be Added to the DAT Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButExitPage('#url.loadid#');" onfocus="checkUnload();" value="Save & Exit"   disabled  />
						<cfelseif  request.qcurAgentdetails.loadBoard123 EQ false AND PostTo123LoadBoard EQ 1>
							<input name="submit" type="submit" class="green-btn" onClick="alert('Any changes you make will not be Added to the 123Load Board because you do not have credentials setup on your Agent Profile.');javascript:return saveButExitPage('#url.loadid#');" onfocus="checkUnload();" value="Save & Exit"   disabled  />
						<cfelse--->
				<cfif structkeyexists(session,"rightslist") and len(trim(url.loadid)) gt 0 and variables.loaddisabledStatus and ListContains(session.rightsList,'UnlockLoad',',')>
					<input id="Unlock" name="unlock" type="button" class="green-btnUnlock" onClick="removeEditAccess('#url.loadid#');" value="Unlock" style="width:100px !important;float:right;">
				<cfelse>		
					<cfif local.lockloadStatsFlag>
						<input name="submit" type="button" class="green-btn" value="Save & Exit" />
					<cfelse>
						<input name="submit" type="submit" class="green-btn"  onClick="javascript:return saveButExitPage('#url.loadid#');" onfocus="checkUnload();" value="Save & Exit"   disabled  />
					</cfif>
				</cfif>	
						<!---/cfif--->
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
	</cfif>
	<cfset StopNoIs = StopNoIs + 1>
  </cfloop>
  <!--- End stop block 2--->

  <!--- </cfform> --->
      <cfset rownum=0>
      <cfloop from ="1" to="1" index="i">
          <tr <cfif rowNum mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> class="commodities_1" id="commodities_#i#" style="display:none;">
          <td height="20" class="lft-bg">&nbsp;</td>
          <td class="lft-bg2" valign="middle" align="center"><input name="isFee_#rowNum#" id="isFee_#rowNum#" class="isFee check" type="checkbox" tabindex="#evaluate(currentTab+1)#"/></td>
          <td class="normaltdC" valign="middle" align="left"><input name="qty_#rowNum#" onChange="CalculateTotal('#Application.dsn#')" class="qty q-textbox" type="text" value="1" tabindex="#evaluate(currentTab+1)#"/></td>
        <td class="normaltdC" valign="middle" align="left">
            <select name="unit_#rowNum#" id="unit_#rowNum#" class="t-select unit typeSelect1" onChange="changeQuantityWithtype(this,'');checkForFee(this.value,'#rowNum#','','#application.dsn#');CalculateTotal('#Application.dsn#'); autoloaddescription(this, '', '#rowNum#', '#application.dsn#');" tabindex="#evaluate(currentTab+1)#">
          <option value=""></option>
          <cfloop query="request.qUnits">
          <option value="#request.qUnits.unitID#">#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
          </cfloop>
          </select></td>
          <td class="normaltdC" valign="middle" align="left"><input name="description_#rowNum#" id="description_#rowNum#" class="t-textbox" type="text" tabindex="#evaluate(currentTab+1)#" <cfif not request.qSystemSetupOptions.commodityWeight> style="width:225px;" </cfif> /></td>
          <cfif request.qSystemSetupOptions.commodityWeight>
            <td class="normaltdC" valign="middle" align="left"><input name="weight_#rowNum#" class="wt-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
          </cfif> 
          <td class="normaltdC" valign="middle" align="left"><select name="class_#rowNum#" class="t-select" tabindex="#evaluate(currentTab+1)#" style="width:60px;">
          <option value=""></option>
          <cfloop query="request.qClasses">
          <option value="#request.qClasses.classId#">#request.qClasses.className#</option>
          </cfloop>
          </select></td>
          <cfset variables.carrierPercentage = 0>
          <cfif IsDefined("request.qItems.CarrRateOfCustTotal") and IsNumeric(request.qItems.CarrRateOfCustTotal)>
          <cfset variables.carrierPercentage = request.qItems.CarrRateOfCustTotal>
          </cfif>
          <td class="normaltdC" valign="middle" align="left"><input name="CustomerRate_#rowNum#" id="CustomerRate_#rowNum#" tabindex="#evaluate(currentTab+1)#" class="q-textbox CustomerRate" onChange="CalculateTotal('#Application.dsn#')"  type="text" value="#DollarFormat(0)#" /></td>
          <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate_#rowNum#" id="CarrierRate_#rowNum#" tabindex="#evaluate(currentTab+1)#"  class="q-textbox CarrierRate"  onChange="CalculateTotal('#Application.dsn#')" type="text" value="#DollarFormat(0)#"/></td>
          <td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer_#rowNum#" id="CarrierPer_#rowNum#" style="width:105px;" class="q-textbox CarrierPer" value="0%" onChange="ConfirmMessage('#rowNum#',0)"  type="text" tabindex="#evaluate(currentTab+1)#" /></td>
          <td class="normaltdC" valign="middle" align="left"><input name="custCharges_#rowNum#" id="custCharges_#rowNum#" class="q-textbox custCharges" onChange="CalculateTotal('#Application.dsn#');" type="text" value="0.00" tabindex="#evaluate(currentTab+1)#"/></td>
          <td class="normaltd2C" valign="middle" align="left"><input name="carrCharges_#rowNum#" id="carrCharges_#rowNum#" class="q-textbox carrCharges" onChange="CalculateTotal('#Application.dsn#');" type="text" value="0.00" tabindex="#evaluate(currentTab+1)#" /></td>
          <td class="normal-td3C normal-td3">&nbsp;</td>
          </tr>
          <cfset rownum++>
    </cfloop>
    <cfloop from="2" to="10" index="stopNumber">
    <cfloop from ="1" to="1" index="rowNum">
                <tr <cfif rowNum mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> class="commodities_#stopNumber#" id="commodities_#stopNumber#" style="display:none;">
                  <td height="20" class="lft-bg">&nbsp;</td>
                  <td class="lft-bg2" valign="middle" align="center"><input name="isFee#stopNumber#_#rowNum#" id="isFee#stopNumber#_#rowNum#" class="isFee check" type="checkbox" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="qty#stopNumber#_#rowNum#" id="qty#stopNumber#_#rowNum#" onChange="CalculateTotal('#Application.dsn#')" value="1" class="qty q-textbox" type="text"  tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltdC" valign="middle" align="left"><select name="unit#stopNumber#_#rowNum#" id="unit#stopNumber#_#rowNum#" class="unit t-select typeSelect#stopNumber#" onchange="changeQuantityWithtype(this,'#stopNumber#');checkForFee(this.value,'#rowNum#','#stopNumber#','#application.dsn#'); autoloaddescription(this, '#stopNumber#', '#rowNum#', '#application.dsn#');" tabindex="#evaluate(currentTab+1)#">
                      <option value=""></option>
                      <cfloop query="request.qUnits">
                        <option value="#request.qUnits.unitID#">#request.qUnits.unitName#<cfif trim(request.qUnits.unitCode) neq ''>(#request.qUnits.unitCode#)</cfif></option>
                      </cfloop>
                    </select></td>
                  <td class="normaltdC" valign="middle" align="left"><input name="description#stopNumber#_#rowNum#" id="description#stopNumber#_#rowNum#" class="t-textbox" type="text" tabindex="#evaluate(currentTab+1)#" <cfif not request.qSystemSetupOptions.commodityWeight> style="width:220px;" </cfif> /></td>
           <cfif request.qSystemSetupOptions.commodityWeight>
            <td class="normaltdC" valign="middle" align="left"><input name="weight#stopNumber#_#rowNum#" class="wt-textbox" type="text" tabindex="#evaluate(currentTab+1)#"/></td>
          </cfif> 
                  <td class="normaltdC" valign="middle" align="left"><select name="class#stopNumber#_#rowNum#" id="class#stopNumber#_#rowNum#" class="t-select" tabindex="#evaluate(currentTab+1)#" style="width:60px;">
                      <option value=""></option>
                      <cfloop query="request.qClasses">
                        <option value="#request.qClasses.classId#">#request.qClasses.className#</option>
                      </cfloop>
                    </select></td>
          <cfset variables.carrierPercentage = 0>
          <cfif IsDefined("request.qItems.CarrRateOfCustTotal") and IsNumeric(request.qItems.CarrRateOfCustTotal)>
            <cfset variables.carrierPercentage = request.qItems.CarrRateOfCustTotal>
          </cfif>
          <!---
          <td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#rowNum##stopNumber#" id="CustomerRate#rowNum##stopNumber#" tabindex="#evaluate(currentTab++)#" onChange="CalculateTotal('#Application.dsn#');formatDollar(this.value, this.id);" class="CustomerRate q-textbox"  type="text" value="#DollarFormat(variables.CustomerRate)#" /></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#rowNum##stopNumber#" id="CarrierRate#rowNum##stopNumber#" tabindex="#evaluate(currentTab++)#"  onChange="CalculateTotal('#Application.dsn#');formatDollar(this.value, this.id);" class="CarrierRate q-textbox"  type="text" value="#DollarFormat(variables.CarrierRate)#"/></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer#rowNum##stopNumber#" id="CarrierPer#rowNum##stopNumber#" style="width:105px;" class="q-textbox CarrierPer" value="#variables.carrierPercentage#%" onChange="ConfirmMessage('#rowNum##stopNumber#',0)"  type="text" tabindex="" /></td>
          --->
          <td class="normaltdC" valign="middle" align="left"><input name="CustomerRate#stopNumber#_#rowNum#" id="CustomerRate#stopNumber#_#rowNum#" tabindex="#evaluate(currentTab+1)#" onChange="CalculateTotal('#Application.dsn#');formatDollar(this.value, this.id);" class="CustomerRate q-textbox"  type="text" value="$0.00" /></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="CarrierRate#stopNumber#_#rowNum#" id="CarrierRate#stopNumber#_#rowNum#" tabindex="#evaluate(currentTab+1)#"  onChange="CalculateTotal('#Application.dsn#');formatDollar(this.value, this.id);" class="CarrierRate q-textbox"  type="text" value="$0.00"/></td>
          <td class="normaltd2C" valign="middle" align="left"><input name="CarrierPer#stopNumber#_#rowNum#" id="CarrierPer#stopNumber#_#rowNum#" style="width:105px;" class="q-textbox CarrierPer" value="0.00%" onChange="ConfirmMessage('#rowNum##stopNumber#',0)"  type="text" tabindex="#evaluate(currentTab+1)#" /></td>
          <td class="normaltdC" valign="middle" align="left"><input name="custCharges#stopNumber#_#rowNum#" id="custCharges#stopNumber#_#rowNum#" onchange="CalculateTotal('#Application.dsn#');" class="custCharges q-textbox" type="text" value="0.0000" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normaltd2C" valign="middle" align="left"><input name="carrCharges#stopNumber#_#rowNum#" id="carrCharges#stopNumber#_#rowNum#" onchange="CalculateTotal('#Application.dsn#');" class="carrCharges q-textbox" type="text"  value="0.0000" tabindex="#evaluate(currentTab+1)#"/></td>
                  <td class="normal-td3C normal-td3">&nbsp;</td>
                </tr>
              </cfloop>
            </cfloop>  
  </form>                
  <script  type="text/javascript">
	 //mailUrlToken will be used for passing urlToken
	var mailUrlToken = "#session.URLToken#"; 
	<cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
	var mailLoadId = "#url.loadid#"; 
	</cfif>
	document.getElementById("milse").onchange();
	CalculateTotal('#Application.dsn#');
	//CalcCarrierTotal();
	<cfif session.currentUserType neq "LmAdmin" AND (ARExported eq "1" AND APExported eq "1")>
		EnableDisableForm(forms.load, true);
	<cfelseif session.currentUserType eq "LmAdmin">
		<!--- Enable A/R and A/P Export options for Admin--->
		document.getElementById('ARExported').disabled = false;
		document.getElementById('APExported').disabled = false;
	</cfif>
</script>
	<!---<script type="text/javascript" language="javascript" src="javascripts/jquery.js"></script>	
	<script type='text/javascript' language="javascript" src='javascripts/jquery.autocomplete.js'></script>
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
    <script src="javascripts/jquery-1.10.2.min.js"></script>
    <script src="javascripts/jquery-ui-1.11.0.min.js"></script>--->
	<script type="text/javascript">
		
		$(document).ready(function(){
      <!---cfif structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
      <cfelse>
        //$("##totalResult").val(2);
      </cfif--->
			<cfif IsDefined("loadIDN") && loadIDN neq "">
			ajaxloadNextStops('#loadID#', #totStops#, #LoadNumber#, #currentTab#);
		    <cfelse>
			ajaxloadNextStops('#loadID#', #totStops#, 'novalue', #currentTab#);
			</cfif>
            //alerts messages based on Post to 'ITS', 'Everywhere' and 'Transcore 360'.
            <cfif structKeyExists(url, 'Palert') and trim(url.Palert) neq "1">alert("#url.Palert#");</cfif>
            <cfif structKeyExists(url, 'Ialert') and trim(url.Ialert) neq "1">alert("#url.Ialert#");</cfif>
            <cfif structKeyExists(url, 'Talert') and trim(url.Palert) neq "1">alert("#url.Talert#");</cfif>
            
			$( ".tabsload" ).tabs({
				beforeLoad: function( event, ui ) {
					ui.jqXHR.error(function() {
						ui.panel.html(
							"Couldn't load this tab. We'll try to fix this as soon as possible. " +
							"If this wouldn't be a demo." 
						);
					});
				}
			});
			
			$('##carrierReportImg').click(function(){
				if(!$("##carrierReportLink").data('allowmail')) {
					alert('You must setup your email address in your profile before you can email reports.');
				} else {
					carrierMailReportOnClick(mailLoadId,mailUrlToken);
                    $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Emailed #variables.freightBroker# Report > \n');
				}
				/*
				var action =  $(this).data('action');
				if(action == 'view')
				{
					 $(this).attr('src',"images/white_mail.png");
					 $(this).data('action','mail');
					 $('##carrierReportLink').attr('title','Mail Carrier Report');					
				}
				else if(action == 'mail')
				{
					 $(this).attr('src',"images/black_mail.png");
					 $(this).data('action','view');
					 $('##carrierReportLink').attr('title','View Carrier Report');
				}
				*/
			 });
			
			$('##carrierReportLink').click(function(){
				var dsn='#dsn#';
				carrierReportOnClick(mailLoadId,mailUrlToken,dsn);
				/*
			   var action =  $('##carrierReportImg').data('action');
				if(action == 'view')
				{
					carrierReportOnClick(mailLoadId,mailUrlToken);
				}
				else if(action == 'mail')
				{
					if(!$(this).data('allowmail'))
					alert('You must setup your email address in your profile before you can email reports.');
					else
					carrierMailReportOnClick(mailLoadId,mailUrlToken);
				}
				*/
				
				var printDisplayStatus='<cfoutput>#request.qSystemSetupOptions.automaticprintreports#</cfoutput>';
                if(printDisplayStatus == '1'){
                    $('##dispatchHiddenValue').val('Printed #variables.freightBroker# Report >');
                        $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Printed #variables.freightBroker# Report > \n');
                        /*applyNotes($('##dispatchNotes'), "bfb");*/
                    }	
                });
			
			$('##impWorkReportImg').click(function(){
				if(!$('##impWorkReportLink').data('allowmail')) {
					alert('You must setup your email address in your profile before you can email reports.');
				} else {
					CarrierMailWorkOrderImportOnClick(mailLoadId,mailUrlToken);
                    $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Emailed Import Work Order > \n');
				}
				/*
			   var action =  $(this).data('action');
				if(action == 'view')
				{
					 $(this).attr('src',"images/white_mail.png");
					 $(this).data('action','mail');
					 $('##impWorkReportLink').attr('title','Mail Work Order Import Report');
				}
				else if(action == 'mail')
				{
					 $(this).attr('src',"images/black_mail.png");
					 $(this).data('action','view');
					 $('##impWorkReportLink').attr('title','View Work Order Import Report');
				}
				*/
			 });
			
			$('##impWorkReportLink').click(function(){
				var dsn='#dsn#';
				CarrierWorkOrderImportOnClick(mailLoadId,mailUrlToken,dsn);
				/*
				var action =  $('##impWorkReportImg').data('action');
				if(action == 'view')
				{
					CarrierWorkOrderImportOnClick(mailLoadId,mailUrlToken);
				}
				else if(action == 'mail')
				{
					if(!$(this).data('allowmail'))
					alert('You must setup your email address in your profile before you can email reports.');
					else
					CarrierMailWorkOrderImportOnClick(mailLoadId,mailUrlToken);
				}
				*/
				var printDisplayStatus='<cfoutput>#request.qSystemSetupOptions.automaticprintreports#</cfoutput>';
				if(printDisplayStatus == '1'){
					$('##dispatchHiddenValue').val('Printed Import Work Order >');
                    $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Printed Import Work Order > \n');
					/*applyNotes($('##dispatchNotes'), "bfb");*/
				}	
			 });
			
			$('##expWorkReportImg').click(function(){
				if(!$('##expWorkReportLink').data('allowmail')) {
					alert('You must setup your email address in your profile before you can email reports.');
				} else {
					CarrierMailWorkOrderExportOnClick(mailLoadId,mailUrlToken);
                    $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Printed Export Work Order > \n');
				}
				/*
				var action =  $(this).data('action');
				if(action == 'view')
				{
					 $(this).attr('src',"images/white_mail.png");
					 $(this).data('action','mail');
					 $('##expWorkReportLink').attr('title','Mail Work Order Export Report');
				}
				else if(action == 'mail')
				{
					 $(this).attr('src',"images/black_mail.png");
					 $(this).data('action','view');
					 $('##expWorkReportLink').attr('title','View Work Order Export Report');
				}
				*/
			 });
			
			$('##expWorkReportLink').click(function(){
				var dsn='#dsn#';
				CarrierWorkOrderExportOnClick(mailLoadId,mailUrlToken,dsn);
				/*
				var action =  $('##expWorkReportImg').data('action');
				if(action == 'view')
				{
					CarrierWorkOrderExportOnClick(mailLoadId,mailUrlToken);
				}
				else if(action == 'mail')
				{
					if(!$(this).data('allowmail'))
					alert('You must setup your email address in your profile before you can email reports.');
					else
					CarrierMailWorkOrderExportOnClick(mailLoadId,mailUrlToken);
				}
				*/
				var printDisplayStatus='<cfoutput>#request.qSystemSetupOptions.automaticprintreports#</cfoutput>';
				if(printDisplayStatus == '1'){
					$('##dispatchHiddenValue').val('Printed Export Work Order >');
          $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Printed Export Work Order > \n');
					/*applyNotes($('##dispatchNotes'), "bfb");*/
				}	
			 });
			
			$('##custInvReportImg').click(function(){
				if(!$('##custInvReportLink').data('allowmail')) {
					alert('You must setup your email address in your profile before you can email reports.');
				} else {
					CustomerMailReportOnClick(mailLoadId,mailUrlToken,'#NewcustomerID#');
                    $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Emailed <cfoutput>#variables.statusDispatch#</cfoutput> > \n');
				}
				/*
				var action =  $(this).data('action');
				if(action == 'view')
				{
					 $(this).attr('src',"images/white_mail.png");
					 $(this).data('action','mail');
					 $('##custInvReportLink').attr('title','Mail Customer Invoice Report');
				}
				else if(action == 'mail')
				{
					 $(this).attr('src',"images/black_mail.png");
					 $(this).data('action','view');
					 $('##custInvReportLink').attr('title','View Customer Invoice Report');
				}
				*/
			 });
			
			$('.custInvReportLink').on("click",function(){
				var dsn='#dsn#';
				CustomerReportOnClick(mailLoadId,mailUrlToken,dsn);
				/*
				var action =  $('##custInvReportImg').data('action');
				if(action == 'view')
				{
					CustomerReportOnClick(mailLoadId,mailUrlToken);
				}
				else if(action == 'mail')
				{
					if(!$(this).data('allowmail'))
					alert('You must setup your email address in your profile before you can email reports.');
					else
					CustomerMailReportOnClick(mailLoadId,mailUrlToken,'#NewcustomerID#');
				}
				*/
				
				var printDisplayStatus='<cfoutput>#request.qSystemSetupOptions.automaticprintreports#</cfoutput>';
				if(printDisplayStatus == '1'){
					$('##dispatchHiddenValue').val('Printed <cfoutput>#variables.statusDispatch#</cfoutput> >');
                    $("##dispatchNotes").prepend(clock()+' - '+ $('##Loggedin_Person').val()+ ' > Printed <cfoutput>#variables.statusDispatch#</cfoutput> > \n');
					/*applyNotes($('##dispatchNotes'), "bfb");*/
				}	
			 });
			
            $( ".datefield" ).datepicker({ 
              dateFormat: "mm/dd/yy",
              showOn: "button",
              buttonImage: "images/DateChooser.png",
              buttonImageOnly: true
            });
			
			$( "body" ).on( "change", ".addressChange",function() {
				var stop = $(this).data( "role" );
				addressChanged(stop);
			  });
			
//			$( ".dollarField" ).keydown(function () {
//				console.log('it works');
//				var value = $(this).val();
//				var rate = value.replace("$","");
//				rate = rate.replace(/,/g,"");
//
//				if(isNaN(rate))
//				{
//					$(this).val('$0');
//				}
//				else
//				{
//					var floatRate = Number(rate);
//					$(this).val('$'+convertDollarNumberFormat(floatRate));
//				}
//			  });
            
            // Setup form validation on the load element
            $("##load").validate({

                // Specify the validation rules
                rules: {
                    orderDate: {
                        required: true,
                        date: true
                    },
                    BillDate: {
                        date: true
                    },
                    readyDat: {
                        date: true
                    },
                    arriveDat: {
                        date: true
                    },
                    shipperPickupDate: {
                        date: true
                    },
                    consigneePickupDate: {
                        date: true
                    },
                    <cfloop from="2" to="10" index="stopNo">
                    shipperPickupDate#stopNo#: {
                        date: true
                    },
                    consigneePickupDate#stopNo#: {
                        date: true
                    },
                    </cfloop>
                    cutomerIdAutoValueContainer: "required"
                },

                // Specify the validation error messages
                messages: {
                    orderDate: {
                        required: "Please enter a Order date",
                        date: "Please enter a valid Order date"
                    },
                    BillDate: {
                        date: "Please enter a valid Invoice date"
                    },
                    readyDat: {
                        date: "Please enter a valid date"
                    },
                    arriveDat: {
                        date: "Please enter a valid date"
                    },
                    shipperPickupDate: {
                        date: "Please enter a valid date for shipper stop 1"
                    },
                    consigneePickupDate: {
                        date: "Please enter a valid date for consignee stop 1"
                    },
                    <cfloop from="2" to="10" index="stopNo">
                    shipperPickupDate#stopNo#: {
                        date: "Please enter a valid date for shipper stop #stopNo#"
                    },
                    consigneePickupDate#stopNo#: {
                        date: "Please enter a valid date for consignee stop #stopNo#"
                    },
                    </cfloop>
                    cutomerIdAutoValueContainer: "Please select a Customer"
                },
              
                errorPlacement: function(error, element) {
                  alert(error.text());
                }
            });
            
			$('.datePicker').on("click",function() {
				var itemId = $(this).attr("id");
				$(itemId).datepicker("show");
			});			
		});		
		function togglechange(x){
			$(".datePicker").datepicker();			
			if(x == 1) {
				togglechange(0);
			}
		}
		
		
	</script>
	
  <script type="text/javascript">
  
	$(document).ready(function(){
		if($.trim($('##load input[name="loadnumber"]').val()).length == 0){
			$('##load input[name="save"]').removeAttr('disabled');
			$('##load input[name="submit"]').removeAttr('disabled');
			$('##load input[name="saveexit"]').removeAttr('disabled');
		}
		$('##PostTo123LoadBoard').click(function() {
			if($(this).is(":checked"))
			{
				$(this).val("1");
				
			} else {
				$(this).val("0");
			}
		});
		$('##posttoTranscore').click(function() {
			if($(this).is(":checked"))
			{
				$(this).val("1");
				
			} else {
				$(this).val("0");
				$('##Trancore_DeleteFlag').val(1);
			}
		});
	});
	function ChkUpdteShiprAddress(Shipr,type,stpno)
	{ 
		if (type=='Shipper')
		{
			 $("##shipperUpAdd"+stpno).val(1);
		}
		if (type=='consignee')
		{
			 $("##consigneeUpAdd"+stpno).val(1);
		}	
	}
	function ChkUpdteShiprCity(Shipr,type,stpno)
	{ 
		if (type=='Shipper')
		{
			 $("##shipperUpAdd"+stpno).val(2);
		}
		if (type=='consignee')
		{
			 $("##consigneeUpAdd"+stpno).val(2);
		}	
	}
	function ChkUpdteShipr(Shipr,type,stpno)
	{   
		if ((type=='Shipper1' || type=='Shipper') && ( Shipr=='' || Shipr.length <=0) )
		{ 
			if (type=='Shipper1')
			{
			 $("##shipper"+stpno).val('');
			}
			$("##shipperValueContainer"+stpno).val(''); 
			$("##shipperName"+stpno).val('');
			$("##shipperNameText"+stpno).val('');
			$("##shipperlocation"+stpno).val(''); 
			$("##shippercity"+stpno).val('');
			$("##shipperstate"+stpno).val('');
			$("##shipperStateName"+stpno).val('');
			$("##shipperZipcode"+stpno).val('');
			$("##shipperContactPerson"+stpno).val('');
			$("##shipperPhone"+stpno).val('');
			$("##shipperFax"+stpno).val('');
			$("##shipperEmail"+stpno).val('');
			$("##shipperIsPayer"+stpno).val('');
			$("##shipIsPayer"+stpno).val('');
			if (type=='Shipper')
			{
				$("##span_Shipper"+stpno).html("<font color='red' size=2>This will add a new shipper </font>");
				$("##span_Shipper"+stpno).show();
			}
			else
			{
			 $("##span_Shipper"+stpno).html("");

			}
		}
		else if ( (type=='consignee' || type=='consignee1') && (Shipr=='' || Shipr.length  <=0) )
		{   
			if (type=='consignee1')
			{
			$("##consignee"+stpno).val('');
			}
			$("##consigneeValueContainer"+stpno).val('');
		    $("##consigneeName"+stpno).val('');
			$("##consigneeNameText"+stpno).val('');
			$("##consigneelocation"+stpno).val('');
			$("##consigneecity"+stpno).val('');
			$("##consigneestate"+stpno).val('');
			$("##consigneeStateName"+stpno).val('');
			$("##consigneeZipcode"+stpno).val('');
			$("##consigneeContactPerson"+stpno).val('');
			$("##consigneePhone"+stpno).val('');
			$("##consigneeFax"+stpno).val('');
			$("##consigneeEmail"+stpno).val('');
			$("##consigneeIsPayer"+stpno).val('');
			if (type=='consignee')
			{
			$("##span_Consignee"+stpno).html("<font color='red' size=2>This will add a new consignee </font>");
			$("##span_Consignee"+stpno).show();
			}
			else
			{
			 $("##span_Consignee"+stpno).html("");

			}
		}
		if ((type=='Shipper1' || type=='Shipper') && ( Shipr!='' || Shipr.length >0) && (Shipr != $("##shipperName"+stpno).val()))
		{   	
			 $("##shipperName"+stpno).val(Shipr);
		}
		if ((type=='Shipper1' || type=='Shipper') && ( Shipr!='' || Shipr.length >0) && (Shipr != $("##shipper"+stpno).val()))
		{   	
			 $("##shipper"+stpno).val(Shipr);
		}
		if ((type=='consignee1' || type=='consignee') && ( Shipr!='' || Shipr.length >0) && (Shipr != $("##consigneeName"+stpno).val()))
		{   	
			 $("##consigneeName"+stpno).val(Shipr);
		}
		if ((type=='consignee1' || type=='consignee') && ( Shipr!='' || Shipr.length >0) && (Shipr != $("##consignee"+stpno).val()))
		{   	
			 $("##consignee"+stpno).val(Shipr);
		}
		if (type=='consignee' || type=='consignee1')
		{$("##consigneeUpAdd"+stpno).val('');
		 
		}
		if (type=='Shipper1' || type=='Shipper')
		{   $("##shipperUpAdd"+stpno).val('');	
			 
		}
		
	}
	function typeAddressfield(myVal){
		var thisVal = $(myVal).attr("value");
		if(thisVal == ''){
			$(this).val("TYPE NEW ADDRESS BELOW");
			$(this).css("color","##ccc");
			$(this).css("z-index","-1");
		}
	}
function showChangeAlert(customerType,stopNumber)
	{  
	if(customerType=='shipper')
	{
		var ContainerVal='shipperValueContainer';
		
	}
	else
	{
		var ContainerVal='consigneeValueContainer';
		
	}
	if($("##"+ContainerVal+stopNumber).val()=="")
	{ 
		if($("##"+customerType+"Name"+stopNumber).val() !="" || $("##"+customerType+"location"+stopNumber).val()!="" || $("##"+customerType+"city"+stopNumber).val() !="" ||  $("##"+customerType+"state"+stopNumber).val() !="" ||  $("##"+customerType+"ZipCode"+stopNumber).val() !="")
		{
			 
				var data = {
							dsnName 		:'#application.dsn#',
							customerName 	:$("##"+customerType+"Name"+stopNumber).val(),
							customerAddress :$("##"+customerType+"location"+stopNumber).val(),
							customerCity 	:$("##"+customerType+"city"+stopNumber).val(),
							customerState 	:$("##"+customerType+"state"+stopNumber).val(),
							customerZipCode :$("##"+customerType+"Zipcode"+stopNumber).val()
					};
					
				
				$.ajax({
					url: '../gateways/loadgateway.cfc?method=customerDataCheck',
					type: 'POST',
					data: data,
					success: function(resultData, textStatus, XMLHttpRequest)
					{ 
						resultData= resultData.split("|");
						
						if(resultData[1] ==0)
						{
							if(customerType== "shipper")
							{
								if($("##"+customerType+"Name"+stopNumber).val() != $("##shipperNameText"+stopNumber).val())
								{
								    $("##span_Shipper"+stopNumber).html("<font color='red' size=2>This will add a new shipper </font>");
									$("##shipperFlag"+stopNumber).val(1);
								}
								else if ($("##shipperUpAdd"+stopNumber).val()==1)
								{
									$("##span_Shipper"+stopNumber).html("<font color='red' size=2>Shipper address will be saved</font>");
									$("##shipperFlag"+stopNumber).val(2);
								}
								else if ($("##shipperUpAdd"+stopNumber).val()=='')
								{
									$("##span_Shipper"+stopNumber).html("");
								 
								}	
								 else if ($("##shipperUpAdd"+stopNumber).val()==2)
								{
									if($('##shipIsPayer'+stopNumber).val()== 1){
										//$("##span_Shipper"+stopNumber).html("<font color='red' size=2>A new Shipper city will be added</font>");
									} else {
										$("##span_Shipper"+stopNumber).html("<font color='red' size=2>Shipper city change will be saved</font>");
									}
								}	
							}
							else if(customerType== "consignee")
							{
								if($("##"+customerType+"Name"+stopNumber).val() != $("##consigneeNameText"+stopNumber).val())
								{
								    $("##span_Consignee"+stopNumber).html("<font color='red' size=2>This will add a new consignee </font>");
									$("##consigneeFlag"+stopNumber).val(1);
								}
								else if ($("##consigneeUpAdd"+stopNumber).val()==1)
								{
									$("##span_Consignee"+stopNumber).html("<font color='red' size=2>Consignee address will be saved</font>");
									$("##consigneeFlag"+stopNumber).val(2);
								}
								else if ($("##consigneeUpAdd"+stopNumber).val()=='')
								{
									$("##span_Consignee"+stopNumber).html("");
								 
								}
								else if ($("##consigneeUpAdd"+stopNumber).val()==2)
								{
									if($('##consigneeIsPayer'+stopNumber).val()== 1){
										//$("##span_Consignee"+stopNumber).html("<font color='red' size=2>A new Consignee city will be added</font>");
									} else {
										$("##span_Consignee"+stopNumber).html("<font color='red' size=2>Consignee city change will be saved</font>");
									}
									$("##consigneeFlag"+stopNumber).val(2);
								}
							}
						}
						else
						{
							if(customerType== "shipper")
							{
								$("##span_Shipper"+stopNumber).html("");
								$("##shipperFlag"+stopNumber).val(0);
								$("##shipperValueContainer"+stopNumber).val(resultData[2]);
							}
							else if(customerType== "consignee")
							{
								$("##span_Consignee"+stopNumber).html("");
								$("##consigneeFlag"+stopNumber).val(0);
								$("##consigneeValueContainer"+stopNumber).val(resultData[2]);
							}
						}
						//is commented because while updating the address of shipper or consignee, so many popups are invoked leading 							to hang of page. Alternatively function called using onchange and onblur.
						//updateMilseFunction(stopNumber);
					}					
			  	});
 	 		} 		
	
	}
	else
	{
		if(customerType== "shipper")
		{
			if($("##"+customerType+"Name"+stopNumber).val() != $("##shipperNameText"+stopNumber).val())
			{ 
				if($('##shipIsPayer'+stopNumber).val()== 1){
					//$("##span_Shipper"+stopNumber).html("<font color='red' size=2>A new Shipper Name will be added </font>");
				}
				else {
					$("##span_Shipper"+stopNumber).html("<font color='red' size=2>Shipper Name change will be updated </font>");
				}
				$("##shipperFlag"+stopNumber).val(2);
			}
			else if ($("##shipperUpAdd"+stopNumber).val()== 1)
			{ 
				if($('##shipIsPayer'+stopNumber).val()== 1){
					//$("##span_Shipper"+stopNumber).html("<font color='red' size=2>A new Shipper address will be added</font>");
					$("##shipperFlag"+stopNumber).val(2);
				}
				else{
					$("##span_Shipper"+stopNumber).html("<font color='red' size=2>Shipper address will be updated</font>");
					$("##shipperFlag"+stopNumber).val(2);
				}
			
			}
			else if ($("##shipperUpAdd"+stopNumber).val()==2)
			{
				if($('##shipIsPayer'+stopNumber).val()== 1){
					//$("##span_Shipper"+stopNumber).html("<font color='red' size=2>A new Shipper city will be added</font>");
				} else {
					$("##span_Shipper"+stopNumber).html("<font color='red' size=2>Shipper city change will be saved</font>");
				}
				$("##shipperFlag"+stopNumber).val(2);
			}
			else
			{
				$("##span_Shipper"+stopNumber).html("");
				$("##shipperFlag"+stopNumber).val(2);
			}
	 
		}
		else if(customerType== "consignee")
		{ 
			if($("##"+customerType+"Name"+stopNumber).val() != $("##consigneeNameText"+stopNumber).val())
			{
				if($('##consigneeIsPayer'+stopNumber).val()== 1){
					//$("##span_Consignee"+stopNumber).html("<font color='red' size=2>A new Consignee Name will be added </font>");
				} else {
					$("##span_Consignee"+stopNumber).html("<font color='red' size=2>Consignee Name change will be updated </font>");
				}
				$("##consigneeFlag"+stopNumber).val(2);
			}
            else if ($("##consigneeUpAdd"+stopNumber).val()==1)
			{
				if($('##consigneeIsPayer'+stopNumber).val()== 1){
					//$("##span_Consignee"+stopNumber).html("<font color='red' size=2>New Consignee address will be added</font>");
					$("##consigneeFlag"+stopNumber).val(2);
				}
				else{
					$("##span_Consignee"+stopNumber).html("<font color='red' size=2>Consignee address will be updated</font>");
					$("##consigneeFlag"+stopNumber).val(2);
				}
				
				$("##consigneeFlag"+stopNumber).val(2);
			}
	     	else if ($("##consigneeUpAdd"+stopNumber).val()==2)
			{
				if($('##consigneeIsPayer'+stopNumber).val()== 1){
					//$("##span_Consignee"+stopNumber).html("<font color='red' size=2>A new Consignee city will be added</font>");
				} else {
					$("##span_Consignee"+stopNumber).html("<font color='red' size=2>Consignee city change will be saved</font>");
				}
				$("##consigneeFlag"+stopNumber).val(2);
			}
			else
			{
				$("##span_Consignee"+stopNumber).html("");
				$("##consigneeFlag"+stopNumber).val(2);
			}
		}	
	
	}
		
	
	}
	function updateMilseFunction(id){
		//updateMatrix(id);
        addressChanged(id);
	}
	
	
	function updateIsPayer(id){
	
	}

	function loadState(fldObj,from,stopNumber)
	{
		if($("##"+from+"StateName"+stopNumber).attr('id'))
		{
			if(fldObj.value!="")
				$("##"+from+"StateName"+stopNumber).val($("##"+fldObj.name+" option:selected").text());
			else
				$("##"+from+"StateName"+stopNumber).val('');
		}
	}
$(function() {
	
	// City DropBox
	function format(mail) {
		//alert(mail.location);
		return mail.name + "<br/><b><u>Address</u>:</b> " + mail.location+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b>" + mail.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b> " + mail.state+"<br><b><u>Zip</u>:</b> " + mail.zip;		
	}
	
		function Cityformat(mail) 
		{
			return mail.city + "<br/><b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b> " + mail.zip;
		}
		
		function Zipformat(mail) 
		{
			return mail.zip + "<br/><b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b> " + mail.city;
		}
	function formatCurrency(total) {
		var neg = false;
		if(total < 0) {
			neg = true;
			total = Math.abs(total);
		}
		return (neg ? "-$" : '$') + parseFloat(total, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString();
	}
	// Customer DropBox
	$('##cutomerIdAuto').each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 400,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			highlight: false,
			dataType: "json",
			focus: function( event, ui ) {
				$(this).val( ui.item.label );
				return false;
			},
			source: 'searchCustomersAutoFill.cfm?queryType=getCustomers',
			select: function(e, ui) {
				console.log(ui);
				var creditLimitshow=formatCurrency(ui.item.creditLimit);
				var balanceAmount=formatCurrency(ui.item.balance);
				var availableAmount=formatCurrency(ui.item.available);
				$(this).val(ui.item.name);
				$('##'+this.id+'ValueContainer').val(ui.item.value);
				var strHtml ="<div id='CustInfo1'>"
				strHtml = strHtml +"<input name='customerAddress' id='customerAddress' type='hidden' value='"+ui.item.location+"'/>";
				strHtml = strHtml +"<input name='customerCity' id='customerCity' type='hidden' value='"+ui.item.city+"'/>";
				strHtml = strHtml +"<input name='customerState' id='customerState' type='hidden' value='"+ui.item.state+"'/>";
				strHtml = strHtml +"<input name='customerZipCode' id='customerZipCode' type='hidden' value='"+ui.item.zip+"'/>";
				strHtml = strHtml +"<input name='customerContact' id='customerContact' type='hidden' value='"+ui.item.contactPerson+"'/>";
				strHtml = strHtml +"<input name='customerPhone' id='customerPhone' type='hidden' value='"+ui.item.phoneNo+"'/>";
				strHtml = strHtml +"<input name='customerCell' id='customerCell' type='hidden' value='"+ui.item.cellNo+"'/>";
				strHtml = strHtml +"<input name='customerFax' id='customerFax' type='hidden' value='"+ui.item.fax+"'/>";
				strHtml = strHtml +"<input name='customerPayer' id='customerPayer' type='hidden' value='"+ui.item.ispayer+"'/>";
				strHtml = strHtml +"<input name='shipIsPayer' id='shipIsPayer' type='hidden' value='"+ui.item.ispayer+"'/>";
				strHtml = strHtml + "<label class='field-textarea'><b><a href=index.cfm?event=addcustomer&customerid="+ui.item.value+" >"+ui.item.name+"</a></b><br/>"+ui.item.location+"<br/>"+ui.item.city+","+ui.item.state+"<br/>"+ui.item.zip+"</label>"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label>Contact</label><label class='field-text'>"+ui.item.contactPerson+"</label>"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label>Tel</label>"
				strHtml = strHtml + "<label class='cellnum-text'>"+ui.item.phoneNo+"</label>"
				//strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label class='space_load'>Cell</label>"
				strHtml = strHtml + "<label class='cellnum-text'></label>"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label>Fax</label>"
				strHtml = strHtml + "<label class='field-text'>"+ui.item.fax+"</label>"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label>Email</label>"
				strHtml = strHtml + "<label class='field-text'>"+ui.item.email+"</label>"
				strHtml = strHtml + "<div class='clear'></div>"
				/*strHtml = strHtml + "<label>IsPayer</label>"
				strHtml = strHtml + "<label class='field-text'>"+ui.item.ispayer+"</label>"*/
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "</div>";
				$('##CustInfo1').html(strHtml);
				var strHtml = "<div class='form-con'>"
				strHtml = strHtml + "<fieldset>"
				strHtml = strHtml + "<label>Credit Limit</label>"
				strHtml = strHtml + "<input name='CreditLimit' id='CreditLimit' type='text' value='"+creditLimitshow+"'/>"
				strHtml = strHtml + "<input name='CreditLimitInput' id='CreditLimitInput' type='hidden' value='"+ui.item.creditLimit+"'/>"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label >Balance</label>"
				strHtml = strHtml + "<input name='balanceAmount' id='balanceAmount' type='text' value='"+balanceAmount+"' />"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label>Available</label>"
				strHtml = strHtml + "<input name='Available' id='Available' type='text' value='"+availableAmount+"' />"
				strHtml = strHtml + "<input name='AvailableInput' id='AvailableInput' type='hidden' value='"+ui.item.available+"' />"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label>Notes</label>"
				strHtml = strHtml + "<textarea name='' cols='' style='height:76px;' rows=''>"+ui.item.notes+"</textarea>"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "<label>Dispatch Notes</label>"
				strHtml = strHtml + "<textarea name='' cols='' style='height:76px;' rows=''>"+ui.item.dispatchNotes+"</textarea>"
				strHtml = strHtml + "<div class='clear'></div>"
				strHtml = strHtml + "</fieldset>"
				strHtml = strHtml + "</div>"
				$('##CustInfo2').html(strHtml);
				if((ui.item.CarrierNotes)!=''){
					$('##carrierNotes').val(ui.item.CarrierNotes);
				}
				//Setting default sales rep of the customer
				if($('##Salesperson').val()=='')
				{
					$('##Salesperson').val(ui.item.salesRep);
				}
				//Setting default dispatcher of the customer
				if($('##Dispatcher').val()=='')
				{
					$('##Dispatcher').val(ui.item.dispatcher);
				}
				return false;
			}	
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.name+"<br/><b><u>Address</u>:</b> "+ item.location+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b>" + item.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b> " + item.state+"<br/><b><u>Zip</u>:</b> " + item.zip+"</li>" )
					.appendTo( ul );
		}
	});
	
	// Shippper DropBox
	$('##shipper, ##consignee').each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 400,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCustomersAutoFill.cfm?queryType=getShippers',
			select: function(e, ui) {
				$(this).val(ui.item.name);
				$(this).parent().find('.updateCreateAlert').val(ui.item.isPayer);
				$('##'+this.id+'ValueContainer').val(ui.item.value);
				$('##'+this.id+'Name').val(ui.item.name);
				$('##'+this.id+'NameText').val(ui.item.name);
				$('##'+this.id+'location').val(ui.item.location); 
				$('##'+this.id+'city').val(ui.item.city);
				$('##'+this.id+'Zipcode').val(ui.item.zip);
				$('##'+this.id+'ContactPerson').val(ui.item.contactPerson);
				$('##'+this.id+'Phone').val(ui.item.phoneNo);
				$('##'+this.id+'Fax').val(ui.item.fax);
				$('##'+this.id+'state').val(ui.item.state);
				$('##'+this.id+'StateName').val(ui.item.state);
				$('##'+this.id+'Email').val(ui.item.email);
				//$('##'+this.id+'IsPayer').val(ui.item.ispayer);
				//$('##'+this.id+'shipIsPayer').val(ui.item.ispayer);
        console.log('muruga');
				//addressChanged('');
				
				var stopNum ="";
				var customerType ="";
				var idText = $(this).attr('id');

				 if(idText.indexOf("shipper")!=-1)
				{
					customerType= 'shipper';
					idText = idText.split("shipper");			
				}
				else if(idText.indexOf("consignee")!=-1)
				{
					customerType= 'consignee';
					var idText = idText.split("consignee");
				}
				
				stopNum =idText[1];
				showChangeAlert(customerType,stopNum);
				return false;
			}
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.name+"<br/><b><u>Address</u>:</b> "+ item.location+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b>" + item.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b> " + item.state+"<br/><b><u>Zip</u>:</b> " + item.zip+"</li>" )
					.appendTo( ul );
		}
	});
	//$( "body" ).on( "click", ".carrierNew", function() {$( "##loadToSaveToCarrierPageSubmit" ).trigger( "click" );});
	
	//City Shippper City
	$('##shippercity, ##consigneecity').each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 400,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCustomersAutoFill.cfm?queryType=getCity',
			select: function(e, ui) {
				$(this).val(ui.item.city);
				strId = this.id;
				initialStr = strId.substr(0, 7);
				if(initialStr != 'shipper')
				{
					initialStr = 'consignee';
				}
				$('##'+initialStr+'state').val(ui.item.state);
				$('##'+initialStr+'StateName').val(ui.item.state);
				$('##'+initialStr+'Zipcode').val(ui.item.zip);
				return false;
			}
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.city+"<br/><b><u>State</u>:</b> "+ item.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b>" + item.zip+"</li>" )
					.appendTo( ul );
		}
	});
		

	//zip AutoComplete
	$('##shipperZipcode, ##consigneeZipcode').each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 400,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			minLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCustomersAutoFill.cfm?queryType=GetZip',
			select: function(e, ui) {
				$(this).val(ui.item.zip);
				strId = this.id;
				zipCodeVal=$('##'+strId).val();
				//auto complete the state and city based on first 5 characters of zip code
				if(zipCodeVal.length == 5)
				{
					initialStr = strId.substr(0, 7);
					if(initialStr != 'shipper')
					{
						initialStr = 'consignee';
					}
					//Donot update a field if there is already a value entered	
					if($('##'+initialStr+'state').val() == '')
					{
						$('##'+initialStr+'state').val(ui.item.state);
						$('##'+initialStr+'StateName').val(ui.item.state);
					}	
					if($('##'+initialStr+'city').val() == '')
					{
						$('##'+initialStr+'city').val(ui.item.city);	
					}
					addressChanged('');
				}
				return false;
			}
		});
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			return $( "<li>"+item.zip+"<br/><b><u>State</u>:</b> "+ item.state+"&nbsp;&nbsp;&nbsp;<b><u>City</u>:</b>" + item.city+"</li>" )
					.appendTo( ul );
		}
	});

	
	function formatCarrier(mail) {
		return mail.name + "<br/><b><u>City</u>:</b> " + mail.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b> " + mail.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b> " + mail.zip+"&nbsp;&nbsp;&nbsp;<b><u>Insurance Expiry</u>:</b> " + mail.InsExpDate;
	}
	// Customer TropBox
	$('##selectedCarrierValue').each(function(i, tag) {
		$(tag).autocomplete({
			multiple: false,
			width: 450,
			scroll: true,
			scrollHeight: 300,
			cacheLength: 1,
			highlight: false,
			dataType: "json",
			source: 'searchCarrierAutoFill.cfm?queryType=getCustomers&loadid=#loadid#',
			select: function(e, ui) {
				$(this).val(ui.item.name);
				$('##'+this.id+'ValueContainer').val(ui.item.value);
				var strHtml = "<div class='clear'></div>"
					strHtml = strHtml + "<input name='carrierID' id='carrierID' type='hidden' value='"+ui.item.value+"' />"
					strHtml = strHtml + "<div class='clear'></div>"
					if(ui.item.risk_assessment != ""){
						strHtml = strHtml + "<label><a target='_blank' href='"+ui.item.link+"'><img src='"+ui.item.risk_assessment+"' alt='Risk Assement Icon'></a></label>"
					}else{
						strHtml = strHtml + "<label>&nbsp;</label>"
					}					
					strHtml = strHtml + "<label class='field-textarea'>"
					strHtml = strHtml + "<b>"
					
					
					<cfif ListContains(session.rightsList,'bookCarrierToLoad',',')>
						strHtml = strHtml + "<a href='index.cfm?event=addcarrier&carrierid="+ui.item.value+"' style='color:##4322cc;text-decoration:underline;'>"
					<cfelse>
						strHtml = strHtml + "<a href='javascript: alert('Sorry!! You don\'t have rights to add/edit #variables.freightBroker#.'); return false;' style='color:##4322cc;text-decoration:underline;'>"
					</cfif>
					//alert(2);
					strHtml = strHtml + ui.item.name
					strHtml = strHtml + "</a>"
					strHtml = strHtml + "</b>"
					strHtml = strHtml + "<br/>"
					strHtml = strHtml + ""+ui.item.name+"<br/>"+ui.item.city+"<br/>"+ui.item.state+"&nbsp;-&nbsp;"+ui.item.zip+""
					strHtml = strHtml + "</label>"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>Tel</label>"
					strHtml = strHtml + "<label class='cellnum-text'>"+ui.item.phoneNo+"</label>"
					//strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label class='space_load'>Cell</label>"
					strHtml = strHtml + "<label class='cellnum-text'>"+ui.item.cell+"</label>"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>Fax</label>"
					strHtml = strHtml + "<label class='field-text'>"+ui.item.fax+"</label>"
					strHtml = strHtml + "<div class='clear'></div>"
					strHtml = strHtml + "<label>Email</label>"
					strHtml = strHtml + "<label class='emailbox'>"+ui.item.email+"</label>";
				if(ui.item.status == 'INACTIVE'){
					alert('#variables.freightBroker# is Inactive.');
					chooseCarrier();
					return false;
				}
				if(ui.item.insuranceExpired == 'yes')
				{
					alert('One or more of the #variables.freightBroker#s insurances has an expiration date prior to the final delivery of this load.')
				}
				
				document.getElementById("CarrierInfo").style.display = 'block';
				document.getElementById('choosCarrier').style.display = 'none';
				//document.getElementById('addCarrierLink').style.display = 'none';
				DisplayIntextField(ui.item.value,'#Application.dsn#');
				$('##CarrierInfo').html(strHtml);
				getCarrierCommodityValue(ui.item.value,"type",0);
				var carrierId =$('##carrierID').val();
				return false;
			}
		});	
		$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
			//console.log(item);
			if(item.risk_assessment != ""){
				var url = "<a target='_blank' href='"+item.link+"'><img src='"+item.risk_assessment+"' alt='Risk Assement Icon'></a>";
			}else{
				var url = "";
			}
			
			return $( "<li>"+item.name+"&nbsp;&nbsp;&nbsp;<b><u>Status</u>:</b> "+ item.status+"&nbsp;&nbsp;&nbsp;"+url+"<br/><b><u>City</u>:</b> "+ item.city+"&nbsp;&nbsp;&nbsp;<b><u>State</u>:</b>" + item.state+"&nbsp;&nbsp;&nbsp;<b><u>Zip</u>:</b> " + item.zip+"&nbsp;&nbsp;&nbsp;<b><u>Insurance Expiry</u>:</b> " + item.InsExpDate+"</li>" )
					.appendTo( ul );
		}
	});
	
	/*
	<cfif request.qSystemSetupOptions.ARAndAPExportStatusID neq loadStatus>
		$("##BillDateload_cf_buttondiv").hide();
		$("##BillDate_Area").hide();
		
	<cfelse>
		$("##BillDateload_cf_buttondiv").show();
		$("##BillDate_Area").show();
	</cfif>
	*/
	
	
	$("##loadStatus").change(function () {
		//alert($(this).val());
		var statusVal = $(this).val();
		var defaultStatus = $("##qLoadDefaultSystemStatus").val();
		
		
		if(statusVal == defaultStatus){
			/*$("##BillDateload_cf_buttondiv").show();
			$("##BillDate_Area").show();*/
			$("##BillDate").focus();
		}else{
			/*$("##BillDateload_cf_buttondiv").hide();
			$("##BillDate_Area").hide();*/
			$("##BillDate").val($("##BillDate_Static").val());
		}
	}).change();
	<!--- BEGIN: Uncheck Post Everywhere? and Post Transcore 360? when choosing load status other than Active Date:20 Sep 2013  --->
	$("##loadStatus").change(function () {
		if(!($("##loadStatus").val() == 'EBE06AA0-0868-48A9-A353-2B7CF8DA9F44' || $("##loadStatus").val() == ''))
		{
			$("##posttoTranscore").attr('checked', false);
			$("##posttoloadboard").attr('checked', false);
			$("##posttoITS").attr('checked', false);
			$("##PostTo123LoadBoard").attr('checked', false);
		}
	})
	<!--- END: Uncheck Post Everywhere? and Post Transcore 360? when choosing load status other than Active Date:20 Sep 2013  --->
    /*
    $('.applynotesPl').focus(function() {
        applyNotes(this, "bfb");
    });*/
    
    $('.userOnchageUpdate').focus(function() {
        $('input.userOnchageUpdate').parent().find('span.iconediting').remove();
        $( this ).after( '<span style="float:left;" class="iconediting">&##9998;</span>' );
    });
    $('.userOnchageUpdate').blur(function() {
        $('input.userOnchageUpdate').parent().find('span.iconediting').remove();
    });
	
	$('##dispatchNotes').focus(function() {
       $('span.iconediting1').remove();
        $('.dispatch_note' ).after( '<span style="float:left;" class="iconediting1">&##9998;</span>' );
		return false;
    });
	$('##dispatchNotes').blur(function() {
        $('span.iconediting1').remove();
    });
	
	$('##dispatchNotes').change(function() {
		var stopNumber   = $( this ).attr( "data-stopNumber" );
		var loadid             = $( this ).attr( "data-loadid" );
		var dispatchNote = $( this ).val().trim();
		if(dispatchNote.length >  0){
			 $.ajax({
					type    : 'POST',
					url     : "../gateways/loadgateway.cfc?method=updateLoadDispatchNote",
					data    : {loadid : loadid,  dispatchNote : dispatchNote,dsn:<cfoutput>"#application.dsn#"</cfoutput>},
					success :function(data){
					
					}
				});     
			}
    }); 
	
	 
    $('.userOnchageUpdate').change(function() {
        var self = this;
        var stopNumber = $( this ).attr( "data-stopNumber" );
        var loadid = $( this ).attr( "data-loadid" );
        var userDefname = $(this).attr('data-inputname');
        var userDefValue = $(this).val();

        if ( typeof stopNumber == 'undefined'){
            stopNumber = '';
        }
        var getloadstopid = 'nextLoadStopId'+stopNumber;
        var loadStopId = $("input[name="+getloadstopid+"]").val();

         $.ajax({
            type    : 'POST',
            url     : "../gateways/loadgateway.cfc?method=updateLoadUserDef",
            data    : {loadid : loadid, loadstopid : loadStopId, fieldname : userDefname, fieldValue : userDefValue,dsn:<cfoutput>"#application.dsn#"</cfoutput>},
            success :function(data){
              /* $('.iconediting').html('');*/
            }
        });      
    }); 

    
    $('.displayDispatchNotesPopup').click(function() {
		var loadid = $( this ).attr( "data-loadid" );
        if(!$(this).hasClass('applynotesPl')){
            $(".dispatchNotesPopup").css("display","block");
            $(".overlay").css("display","block");
            $(".dispatchPopupNotes").focus(); 
            $(".noteAdd").click(function(){
                var quote = $(".dispatchPopupNotes").val();
                if (quote != ''){
                    $(".displayDispatchNotesPopup").prepend(quote+'\n');
                    $(".dispatchPopupNotes").val('');
                    $( ".closModal" ).trigger( "click" );
					var  dispatchNote =  $('.displayDispatchNotesPopup').val().trim();
					$.ajax({
						type    : 'POST',
						url     : "../gateways/loadgateway.cfc?method=updateLoadDispatchNote",
						data    : {loadid : loadid,  dispatchNote : dispatchNote,dsn:<cfoutput>"#application.dsn#"</cfoutput>},
						success :function(data){
						
						}
					});   
                }
            }); 
        } else {
            var username=$( ".displayDispatchNotesPopup" ).attr( "data-username" );

            var currentDate = new Date();
            var currentDay = currentDate.getDate();
            var currentMonth = currentDate.getMonth() + 1;
            var currentYear = currentDate.getFullYear();
            var hours = currentDate.getHours();
            var minutes = currentDate.getMinutes();

            var currentDate = currentMonth + "/" + currentDay + "/" + currentYear;
            var ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours ? hours : 12; // the hour '0' should be '12'
            minutes = minutes < 10 ? '0'+minutes : minutes;
            var strTime = hours + ':' + minutes + ': ' + ampm;
            var dateTime = currentDate+' '+strTime

            var dispatchAutoTimeStamp = dateTime+' - '+username+' > ';

            $(".dispatchNotesPopup").css("display","block");
            $(".overlay").css("display","block");
            $(".dispatchPopupNotes").focus(); 
            $(".noteAdd").on("click",function() {
                var quote = $(".dispatchPopupNotes").val();
                if (quote != ''){
                    quote = dispatchAutoTimeStamp+' '+quote;
                    $(".displayDispatchNotesPopup").prepend(quote+'\n');
                    $(".dispatchPopupNotes").val('');
                    $( ".closModal" ).trigger( "click" );
					var  dispatchNote =  $('.displayDispatchNotesPopup').val().trim();
					 $.ajax({
						type    : 'POST',
						url     : "../gateways/loadgateway.cfc?method=updateLoadDispatchNote",
						data    : {loadid : loadid,  dispatchNote : dispatchNote,dsn:<cfoutput>"#application.dsn#"</cfoutput>},
						success :function(data){
						
						}
					});   
                }
            });
        }
    });

    $('.applynotesPl').focus(function() {
      if(!$(this).hasClass('displayDispatchNotesPopup')){ 
        applyNotes(this, "bfb"); 
      } 
    });
  
    $(".closModal").click(function() {
        $(".dispatchNotesPopup").css("display","none");
        $(".overlay").css("display","none");
    });
	$('.applynotesPricing').focus(function() {
		applyNotesPrice(this, "bfb");
	});
		//==============================Hint Box Code============================\\
		//Shows the title in the text box, and removes it when modifying it
	$('input[title]').each(function(i) {
		if(!$(this).val()) {
			$(this).val($(this).attr('title')).addClass('hint');
		}
	
	
	$(this).focus(
		function() {
		if ($(this).val() == $(this).attr('title')) {
		$(this).val('')
		.removeClass('hint');
		}
	});
	
	$(this).blur(
		function() {
			if ($(this).val() == '') {
			$(this).val($(this).attr('title'))
			.addClass('hint');
			}
		}
	);
	});
	
	//Clear input hints on form submit
	$('form').submit(function() {
	$('input.hint').val('');
	return true;
	});
		
		//======End hint Box Code==========\\
});

	function applyNotes( thisObj, type ) {
		var myDate = new Date();
		var displayDate = (myDate.getMonth()+1) + '/' + (myDate.getDate()) + '/' + myDate.getFullYear();
		var textHiddenValue=$("##dispatchHiddenValue").val();
		if(($('##dispatchHiddenValue').val())== textHiddenValue){
			var statusText=$("##dispatchHiddenValue").val();
			$("##dispatchHiddenValue").val('');
		} else {
			var statusText="";
		}
		if($.trim($(thisObj).val()) == ""){
			var nextline=' ';
		} else {
			var nextline='\n';
		}		
		var lines = $('##dispatchNotes').val().split('\n');
		if(lines[0].split('>')[1].trim() != ""){
			$(thisObj).val( + '\n' + clock()+' - '+ $('##Loggedin_Person').val()+ " >" +statusText+nextline+ "" + $.trim($(thisObj).val())); 
		}		
		var myString = clock()+' - '+ $('##Loggedin_Person').val()+ " >" +statusText+nextline;
		var n = myString.length;
		setSelectionRange(thisObj, n, n);
		return false;
	}
	function applyNotesPrice( thisObj, type ) {
		var myDate = new Date();
		var displayDate = (myDate.getMonth()+1) + '/' + (myDate.getDate()) + '/' + myDate.getFullYear();
		if($.trim($(thisObj).val()) == ""){
			var nextline=' ';
		} else {
			var nextline='\n';
		}
		$(thisObj).val( + '\n' + clock()+' - '+ $('##Loggedin_Person').val()+ " >" +nextline+ "" + $.trim($(thisObj).val())); 
		var myString = clock()+' - '+ $('##Loggedin_Person').val()+ " >" +nextline;
		var n = myString.length;
		setSelectionRange(thisObj, n, n);
		return false;
	}
 function getCarrierCommodityValue(carrierid,type,stopno){
 if(stopno==0){
	$('##carrier_id').val(carrierid);
 }
 else{
	$('##carrier_id'+stopno).val(carrierid);
 }
 
 var searchIndex="";
 var indexStopNo="";
	$.ajax({
		  type: "get",
		  url: "getCarrierCommodityValue.cfm?carrierid="+carrierid,		
				  
		  success: function(data){
			data =data.split(",");
			dataLength = data.length/3;
			
			for(i=1;i<=7;i++){
			if(stopno!=0){
				searchIndex=type+i+""+stopno;
				indexStopNo=stopno;
			}else{
			searchIndex=type+i;
			indexStopNo=""
			}
				for(j=0;j<dataLength;j++){
				index=j*3;
				if($('##'+searchIndex).val()==data[index]){
					var carrRate=data[index+1];
					if(carrRate.indexOf(".")==-1){
						carrRate=carrRate+".00";
					}
					$('##CarrierRate'+i+""+indexStopNo).val('$'+carrRate);
					$('##CarrierPer'+i+""+indexStopNo).val(data[index+2]+'%');
					
				}				
				}
			CalculateTotal('#Application.dsn#');
			}
		  }
		  
		});
 }
	function setSelectionRange(input, selectionStart, selectionEnd) {
		if (input.setSelectionRange) {
			input.focus();
			input.setSelectionRange(selectionStart, selectionEnd);
			return false;
		} else if (input.createTextRange) {
			var range = input.createTextRange();
			range.collapse(true);
			range.moveEnd('character', selectionEnd);
			range.moveStart('character', selectionStart);
			range.select();
		}
	}

	function clock(){
		var currentDate = new Date();
        var currentDay = currentDate.getDate();
        var currentMonth = currentDate.getMonth() + 1;
        var currentYear = currentDate.getFullYear();
        var hours = currentDate.getHours();
        var minutes = currentDate.getMinutes();

        var currentDate = currentMonth + "/" + currentDay + "/" + currentYear;
        var ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        minutes = minutes < 10 ? '0'+minutes : minutes;
        var strTime = hours + ':' + minutes + ': ' + ampm;
        var FinalTime = currentDate+' '+strTime;
		return FinalTime
	}
	
	function openCarrierFilter(){
		var url = document.getElementById('equipment').value+'&consigneecity='+document.getElementById('consigneecity').value+'&consigneestate='+document.getElementById('consigneestate').value+'&consigneeZipcode='+document.getElementById('consigneeZipcode').value+'&shippercity='+document.getElementById('shippercity').value+'&shipperstate='+document.getElementById('shipperstate').value+'&shipperZipcode='+document.getElementById('shipperZipcode').value;
		
		window.location='index.cfm?event=carrier&#session.URLToken#&carrierfilter=true&equipment='+url;
	}
	
	
</script>
<!--- To detect browser and increase the font size by 1px for Select Customer label for Chrome and Safari --->
<script type="text/javascript">
	var chromesafari_externalcss='styles/style_chrome_safari.css?t=10' //if "external", specify Mac css file here
	var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
    var isSafari = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);
    if (isChrome || isSafari){
    	document.write('<link rel="stylesheet" type="text/css" href="'+ chromesafari_externalcss +'">')
    }
</script>

<script type="text/javascript">
	window.onload = function() {
		CalculateTotal('#Application.dsn#');
		updateTotalRates('<cfoutput>#application.DSN#</cfoutput>');
	}	
	
	$( document ).ready(function() {
		<cfif variables.loaddisabledStatus>
			$(".green-btn").prop("disabled",true);
			$(".green-btn").attr("title","This load is edited by another person. Please ask administrator to unlock this load.");
			$(".green-btn").css("color",":##adadad !important");
			$(".green-btn").css("cursor","not-allowed");
			
		</cfif>	
		$('input[type=text]').addClass('myElements');
		$('input[type=checkbox]').addClass('myElements');
		$('input[type=datefield]').addClass('myElements');
		$('select').addClass('myElements');
		$('textarea').addClass('myElements');
		$('.myElements').each(function() {
		   var elem = $(this);
		   // Save current value of element
		   elem.data('oldVal', elem.val());
		   // Look for changes in the value
		   elem.bind("propertychange change click keyup input paste", function(event){
			  // If value has changed...
			  console.log(elem);
			  if (elem.data('oldVal') != elem.val()) {
			   // Updated stored value
			   elem.data('oldVal', elem.val());
			   $("##inputChanged").val(1);
			 }
		});
     });
  });
	
  // function addNewRowCommodities(){
  //   var selectOptions = $('.sel_commodityType').html();
  //   var currentRowCount = parseInt($('.commodityWrap tbody tr').length);
  //   var newRowCont = currentRowCount+1;
  //   var appenString = '<tr><td height="20" class="lft-bg">&nbsp;</td><td valign="middle" align="left" class="normaltd" style="width:274px;position:relative;top:-5px;padding:8px 0px;">';
  //   appenString  = appenString + '<select class="sel_commodityType" id="type" style="width:240px;height:26px;" name="sel_commodityType_'+newRowCont+'">'+selectOptions+'</select>';
  //   appenString  = appenString + '<input type="hidden" name="numberOfCommodity" value="1"></td>';
  //   appenString  =  appenString + '<td valign="middle" align="left" class="normaltd" style="width:142px;position:relative;top:-5px;"><input type="text" class="txt_carrRateComm q-textbox" value="$0.00" name="txt_carrRateComm_'+newRowCont+'"></td>';
  //   appenString  = appenString + '<td valign="middle" colspan="2" align="left" class="normaltd" style="width:132px;position:relative;top:-5px;"><input type="text" class="txt_custRateComm q-textbox" value="0.00%" name="txt_custRateComm_'+newRowCont+'"></td>';
    
              
  //   $('.commodityWrap tbody').append(appenString);
  //   $(appenString).find('.sel_commodityType').attr('name', 'sel_commodityType_' + parseInt(currentRowCount)+1);
  // }
   function addNewRowCommodities(evnt, comid) {
      var i = $('##totalResult'+comid).val();
      var original = document.getElementById('commodities_'+comid);
      var clone = original.cloneNode(true);
      i =++i;
      $(clone).find("input,radio,select,textArea,tr").each(function(e){
        var name = $(this).attr("name");
        name = name.split('_');
        $(this).attr("name",name[0]+"_"+i);
        $(this).attr("id",name[0]+"_"+i);
      });
      $("##commodity_"+comid+" tbody").append(clone);
      $('##commodities_'+comid).removeAttr("style");
      $('##totalResult'+comid).val(i);
      $('##commodity_'+comid+' tr').removeAttr("id");
       
      // console.log( $('##commodities_'+comid).removeAttr("id"));
    }
</script>

<!---cfif  structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
		<cfset loadID = url.loadid>
		<cfif structkeyexists (session,"empid")>		
			<cfif Session.empid neq "">
				<cfinvoke component="#variables.objloadGateway#" method="checkEditLoadIdExists" loadid="#loadID#"  returnvariable="request.EditLoadIdDetails"/>
				<cfif request.EditLoadIdDetails.recordcount>
						 <script  type="text/javascript">
							$(function() {
								$('input').prop('readonly',true);
								$('option:not(:selected)').attr('disabled', true);
								$("input:checkbox").on('click',function(){
								   $(this).prop('checked',!$(this).is(':checked'));
								});
								$( ".ui-datepicker-trigger" ).css( "display","none" );
								$(".form-con > fieldset > img").css("display","none");
								$('.rt-button3 > input[name="addstopButton"]').css("display","none");
								$('.rt-button1 > input[name="addstopButton"]').css("display","none");
								$('.rt-button2 > input[name="addstopButton"]').css("display","none");
								$("textarea").prop('readonly', true);
								alert("Another user is now editing the load.Please try again later..");
								$('input').unbind( "focus" );
								$('textarea').unbind( "focus" );
								return false;
							});
						</script>
					<cfelse>
						<cfinvoke component="#variables.objloadGateway#" method="insertUserEditingLoad" loadid="#loadID#" returnvariable="request.EditLoadIdDetails"/>
					</cfif>
				
			</cfif>
		</cfif>	
		<cfif structkeyexists (session,"customerid")>
			<cfif Session.customerid neq "">	
				<cfinvoke component="#variables.objloadGateway#" method="checkEditLoadIdExists" loadid="#loadID#"  returnvariable="request.EditLoadIdDetails"/>
				<cfif request.EditLoadIdDetails.recordcount>
					 <script  type="text/javascript">
						$(function() {
							$('input').prop('readonly',true);
							$('option:not(:selected)').attr('disabled', true);
							$("input:checkbox").on('click',function(){
							   $(this).prop('checked',!$(this).is(':checked'));
							});
							$( ".ui-datepicker-trigger" ).css( "display","none" );
							$(".form-con > fieldset > img").css("display","none");
							$('.rt-button3 > input[name="addstopButton"]').css("display","none");
							$('.rt-button1 > input[name="addstopButton"]').css("display","none");
							$('.rt-button2 > input[name="addstopButton"]').css("display","none");
							$("textarea").prop('readonly', true);
							alert("Another user is now editing the load.Please try again later..");
							$('input').unbind( "focus" );
							$('textarea').unbind( "focus" );
							return false;
						});
					</script>
				<cfelse>
					<cfinvoke component="#variables.objloadGateway#" method="insertUserEditingLoad" loadid="#loadID#" returnvariable="request.EditLoadIdDetails"/>
				</cfif>
			</cfif>
		</cfif>
</cfif--->	
</cfoutput>
<cfset tickEnd = GetTickCount()>
<cfset testTime = tickEnd - tickBegin> 

<cfscript>
	public string function myCurrencyFormatter(num) {
	  var neg = (num < 0);
	  var str = dollarFormat(abs(num));
	  if (neg) {
		str = Replace(str,"$","$-","all");
	  }
	  return str;
	}
</cfscript>