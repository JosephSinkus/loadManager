<!---Functuin for triming input string--->

<cfset variables.Secret = application.dsn>
<cfset variables.TheKey = 'NAMASKARAM'>
<cfset variables.Encrypted = Encrypt(variables.Secret, variables.TheKey)>
<cfset variables.dsn = ToBase64(variables.Encrypted)>
<cfif structkeyexists(session,'iscustomer') AND val(session.iscustomer)>
	<cfset customer = 1>
<cfelse>
	<cfset customer = 0>
</cfif>
<cffunction name="truncateMyString" access="public" returntype="string">

<cfargument name="endindex" type="numeric" required="true"  />
<cfargument name="inputstring" type="string" required="true"  />
	
	<cfif Len(inputstring) le endindex>
		<cfset inputstring=inputstring.substring(0, Len(inputstring))>
	<cfelse>
		<cfset inputstring=inputstring.substring(0, endindex)>
	</cfif>
	
	<cfreturn inputstring>
</cffunction>
<!---Functuin for triming input string--->
<cfparam name="message" default="">
<cfparam name="url.linkid" default="">

<cfparam name="url.sortorder" default="ASC">
<cfparam name="sortby"  default="">
<cfparam name="variables.searchTextStored"  default="">
<cfparam name="session.searchtext"  default="">
<cfif StructKeyExists(form,"searchtext")>
	<cfif structkeyexists(form,"rememberSearch")>
		<cfset session.searchtext = form.searchtext>
		<cfset variables.searchTextStored=session.searchtext>
	<cfelse>	
		<cfset session.searchtext = "">
		<cfset variables.searchTextStored=form.searchtext>
	</cfif>
<cfelse>
	<cfset variables.searchTextStored=session.searchtext> 
</cfif>
<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" />
<cfsilent>

<cfinvoke component="#variables.objloadGateway#" method="getLoadSystemSetupOptions" returnvariable="request.qSystemSetupOptions1" />

<cfset pageSize = 30>
<cfif structKeyExists(request.qSystemSetupOptions1, "rowsperpage") AND request.qSystemSetupOptions1.rowsperpage>
	<cfset pageSize = request.qSystemSetupOptions1.rowsperpage>
</cfif>
<!--- <cfif cgi.REMOTE_ADDR eq "202.88.237.237">
	<cfdump var="#pageSize#" /><cfabort />
</cfif> --->
<!--- Getting page1 of All Results --->
<cfif isdefined('url.event') AND url.event eq 'exportData'>
	<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
	<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" LoadStatus="#request.qGetSystemSetupOptions.ARAndAPExportStatusID#" searchText="#variables.searchTextStored#" pageNo="1" agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads" />
<cfelse>
	<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" searchText="#variables.searchTextStored#" pageNo="1" agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads" />
</cfif>

<cfif structkeyexists(session,"empid")>
	<cfif len(trim(session.empid))>
		<cfinvoke component="#variables.objloadGateway#" method="getcurAgentdetails" employeID="#session.empid#" returnvariable="request.qrygetAgentdetails" />
	</cfif>		
</cfif>

<cfif isdefined("form.searchText")>	
	<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" pageNo="#form.pageNo#" sortorder="#form.sortOrder#" sortby="#form.sortBy#" agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads" >
        <cfinvokeargument name="searchText" value="#form.searchText#">
        <cfif isdefined('url.event') AND url.event eq 'exportData'>
        	<cfinvokeargument name="LoadStatus" value="#request.qGetSystemSetupOptions.ARAndAPExportStatusID#">
        </cfif>
   </cfinvoke>
   <cfif qLoads.recordcount lte 0>
		<script> showErrorMessage('block'); </script>
	<cfelse>
    	<script> showErrorMessage('none'); </script>
	</cfif>
   
   <!--- Handeling Advance Search --->
	<cfelseif isDefined("url.lastweek")>
		<cfset weekOrMonth = "lastweek">
	<cfelseif isDefined("url.thisweek")>
		<cfset weekOrMonth = "thisweek">
	<cfelseif isDefined("url.thismonth")>
		<cfset weekOrMonth = "thismonth">
	<cfelseif isDefined("url.lastmonth")>
		<cfset weekOrMonth = "lastmonth">
	<cfelseif isdefined("form.searchSubmit")>
            <cfset searchSubmitLocal='yes'>
            <cfset LoadStatusAdv = #form.LoadStatusAdv#>
            <cfset LoadNumberAdv = #form.LoadNumberAdv#>
            <cfset OfficeAdv = #form.OfficeAdv#>
			<cfset ShipperCityAdv = #form.ShipperCityAdv#>
            <cfset ConsigneeCityAdv = #form.ConsigneeCityAdv#>
            <cfset ShipperStateAdv = #form.ShipperStateAdv#>
            <cfset ConsigneeStateAdv = #form.ConsigneeStateAdv#>
            <cfset CustomerNameAdv = #form.CustomerNameAdv#>
            <cfset StartDateAdv = #form.StartDateAdv#>
            <cfset EndDateAdv = #form.EndDateAdv#>
            <cfset CarrierNameAdv = #form.CarrierNameAdv#>
            <cfset CustomerPOAdv = #form.CustomerPOAdv#>
			<cfset LoadBol = #form.txtBol#>
			<cfset carrierDispatcher = #form.txtDispatcher#>
			<cfset carrierAgent = #form.txtAgent#>
	<cfelse>
      
	<cfif isdefined("url.loadid") and len(url.loadid) gt 1>
		<cfinvoke component="#variables.objloadGateway#" method="deleteLoad" loadid="#url.loadid#" returnvariable="message" />	
		<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" searchText="#variables.searchTextStored#" pageNo="1" agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads" />
	</cfif>
	<cfif isdefined('url.carrierId') and len(url.carrierId) gt 1>
		<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" searchText="#variables.searchTextStored#" pageNo="1" carrierID ='#url.carrierId#' agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads" />
	</cfif>	
</cfif>
<!--- Handeling Advance Search Ended --->

</cfsilent>
<link href="file:///D|/loadManagerForDrake/webroot/styles/style.css" rel="stylesheet" type="text/css" />

<cfoutput>

<cfif isdefined('url.carrierId') and len(url.carrierId) gt 1>
	<cfinvoke component="#variables.objCarrierGateway#" carrierid="#url.carrierId#" method="getAllCarriers" returnvariable="request.qCarrier" />
	<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" searchText="#request.qCarrier.CarrierName#" pageNo="1" carrierID ='#url.carrierId#' agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads" />
	<cfif request.qCarrier.recordcount >
		<cfset session.searchtext = request.qCarrier.CarrierName>
	</cfif>
	<cfif request.qCarrier.recordcount  gt 0>
		<h1>#request.qCarrier.CarrierName# Loads</h1>
	</cfif>	 
<cfelseif isdefined('url.event') AND url.event eq 'exportData'>
	<h1>Loads Ready To Be Exported</h1>
	<div style="clear:left;"></div>
	<!---<h1>Carrier's Load</h1>----->
<cfelseif isdefined('url.event') AND url.event eq 'myLoad'>
	<h1>My Loads</h1>
	<div style="clear:left;"></div>
<cfelseif isdefined('url.event') AND url.event eq 'dispatchboard'>
	<h1>Dispatch Board</h1>
	<div style="clear:left;"></div>
<cfelse>
	<h1>All Loads</h1>
	<div style="clear:left;"></div>
</cfif>

<!---<cfif isdefined("message") and len(message)>--->
<div id="message" class="msg-area" style="display:none;">No match found</div>
<cfif structKeyExists(session,"message") AND session.message NEQ "" >
	<div class="col-md-12">&nbsp;</div>
	<div id="messageLoadsExportedForCustomer" class="msg-area">#session.message#</div>
	<cfset session.message = "">
</cfif>
<div id="messageLoadsExportedForCustomer" class="msg-area" style="display:none;"></div>
<div id="messageLoadsExportedForCarrier" class="msg-area" style="display:none;"></div>
<div id="messageLoadsExportedForBoth" class="msg-area" style="display:none;"></div>
<div id="messageWarning" class="errormsg-area" style="display:none;"></div>
<!---</cfif>--->

<!---<cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
     <cfset sortorder="asc">
  <cfelse>
     <cfset sortorder="desc">
 </cfif>
 <cfif isDefined("url.sortby")>
     <cfinvoke component="#variables.objloadGateway#" method="getAllLoads" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="qLoads" />
 </cfif> --->
<div class="search-panel" style="width:100%;">
    <div class="form-search">

<!---<cfif isdefined('url.event') AND url.event eq 'exportData'>
	<cfset eventType = 'exportData'>
<cfelse>
	<cfset eventType = 'load'>
</cfif>
--->

<cfif isdefined('url.event') AND url.event eq 'addload:process'>
	<cfset actionUrl = 'index.cfm?event=load&#session.URLToken#'>
<cfelse>	
	<cfset actionUrl = 'index.cfm?event=#url.event#&#session.URLToken#'>
</cfif>

<cfset csrfToken=CSRFGenerateToken() /> 
<cfform id="dispLoadForm" name="dispLoadForm" action="#actionUrl#" method="post" preserveData="yes">
	<cfinput id="pageNo" name="pageNo" value="1" type="hidden">
    <cfinput id="sortOrder" name="sortOrder" value="ASC"  type="hidden">
    <cfinput id="sortBy" name="sortBy" value="statusText"  type="hidden">
    <cfinput id="LoadStatusAdv" name="LoadStatusAdv" value="" type="hidden">
    <cfinput id="LoadNumberAdv" name="LoadNumberAdv" value="" type="hidden">
	<cfinput id="OfficeAdv" name="OfficeAdv" value="" type="hidden">
	<cfinput id="shipperCityAdv" name="shipperCityAdv" value="" type="hidden">
    <cfinput id="consigneeCityAdv" name="consigneeCityAdv" value="" type="hidden">
    <cfinput id="ShipperStateAdv" name="ShipperStateAdv" value="" type="hidden">
    <cfinput id="ConsigneeStateAdv" name="ConsigneeStateAdv" value="" type="hidden">
    <cfinput id="CustomerNameAdv" name="CustomerNameAdv" value="" type="hidden">
    <cfinput id="StartDateAdv" name="StartDateAdv" value="" type="hidden">
    <cfinput id="EndDateAdv" name="EndDateAdv" value="" type="hidden">
    <cfinput id="CarrierNameAdv" name="CarrierNameAdv" value="" type="hidden">
    <cfinput id="CustomerPOAdv" name="CustomerPOAdv" value="" type="hidden">
    <cfinput id="weekMonth" name="weekMonth" value="" type="hidden">
	<cfinput id="txtBol" name="txtBol" value="" type="hidden">
	<cfinput id="txtDispatcher" name="txtDispatcher" value="" type="hidden">
	<cfinput id="txtAgent" name="txtAgent" value="" type="hidden">
	<cfinput id="csfrToken" name="csfrToken" value="#csrfToken#" type="hidden">
	<fieldset >
<!---	<cfinput  name="searchText" type="text"/>--->
	<input name="searchText"  style="width:224px;" type="text" placeholder="Load##, Status, Customer, PO##, BOL##, Carr......" value="#variables.searchTextStored#" id="searchText"  class="InfotoolTip" title="Load##, Status, Customer, PO##, BOL##, Carrier, City, State, Dispatcher <cfif request.qSystemSetupOptions1.freightBroker>OR Agent <cfelse>OR #left(request.qSystemSetupOptions1.userDef7,9)#</cfif>,shipdate" />
	<input name="" onclick="clearPreviousSearchHiddenFields()" type="submit" class="s-bttn" value="Search" style="width:56px;" />
    <input name="rememberSearch" type="checkbox" class="s-bttn" value="" <cfif session.searchtext neq "">checked="true"</cfif> id="rememberSearch" style="width: 15px;margin-left: 15px;margin-top: 3px;" onclick="rememberSearchSession(this);" />
	<div style="margin-left: 6px; margin-top: 5px;float: left;color: ##3a5b96;;">Remember Search</div>
	
	<div class="clear"></div>
    <cfif isdefined('url.event') AND url.event eq 'exportData'>
        <label>Date From</label>
        <cfinput class="" name="orderDateFrom" id="orderDateFrom" value="#dateformat('01/01/1900','mm/dd/yyyy')#" type="datefield" style="width:55px;"/>
        
        <label>Date To</label>
        <cfinput class="" name="orderDateTo" id="orderDateTo" value="#dateformat(NOW(),'mm/dd/yyyy')#" type="datefield" style="width:55px;"/>
    </cfif>
	<div class="clear"></div>
	</fieldset>
</cfform>

	<cfif isdefined('weekOrMonth') AND weekOrMonth neq "">
    	<cfset form.weekMonth = '#weekOrMonth#'>
        <script> document.getElementById('weekMonth').value='#weekOrMonth#' </script>
    </cfif>
    
    <cfif isdefined("form.weekMonth") AND form.weekMonth neq "">
    	
		<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads">
       		<cfinvokeargument name="#form.weekMonth#" value="#form.weekMonth#">
       		<cfif isdefined('form.pageNo')>
        		<cfinvokeargument name="pageNo" value="#form.pageNo#">
	        <cfelse>
		        <cfinvokeargument name="pageNo" value="1">
        	    <cfset form.pageNo = 1>
        	</cfif>
            
            <cfif isdefined('form.sortOrder')>
	            <cfinvokeargument name="sortorder" value="#form.sortOrder#">
            </cfif>
            <cfif isdefined('form.sortBy')>
	            <cfinvokeargument name="sortby" value="#form.sortBy#">
            </cfif>
            
		</cfinvoke>
	</cfif>
    
	<cfif isdefined('searchSubmitLocal') AND (searchSubmitLocal eq 'yes')>
        <cfset form.LoadStatusAdv = '#LoadStatusAdv#'>
        <cfset form.LoadNumberAdv = '#LoadNumberAdv#'>
        <cfset form.OfficeAdv = '#OfficeAdv#'>
		<cfset form.shipperCityAdv = '#shipperCityAdv#'>
        <cfset form.consigneeCityAdv = '#consigneeCityAdv#'>
        <cfset form.ShipperStateAdv = '#ShipperStateAdv#'>
        <cfset form.ConsigneeStateAdv = '#ConsigneeStateAdv#'>
        <cfset form.CustomerNameAdv = '#CustomerNameAdv#'>
        <cfset form.StartDateAdv = '#StartDateAdv#'>
        <cfset form.EndDateAdv = '#EndDateAdv#'>
        <cfset form.CarrierNameAdv = '#CarrierNameAdv#'>
        <cfset form.CustomerPOAdv = '#CustomerPOAdv#'>
		<cfset form.txtBol = '#LoadBol#'>
		<cfset form.txtDispatcher  = '#carrierDispatcher#'>
		<cfset form.txtAgent  = '#carrierAgent#'>		
    </cfif>
    
    <!--- Query for Advance Search and Advance Search Pagination --->
	<cfif (isdefined("form.LoadStatusAdv") AND form.LoadStatusAdv neq "")
	OR (isdefined("form.LoadNumberAdv") AND form.LoadNumberAdv neq "")
	OR (isdefined("form.OfficeAdv") AND form.OfficeAdv neq "")
	OR (isdefined("form.shipperCityAdv") AND form.shipperCityAdv neq "")
	OR (isdefined("form.consigneeCityAdv") AND form.consigneeCityAdv neq "")
	OR (isdefined("form.ShipperStateAdv") AND form.ShipperStateAdv neq "")
	OR (isdefined("form.ConsigneeStateAdv") AND form.ConsigneeStateAdv neq "")
	OR (isdefined("form.CustomerNameAdv") AND form.CustomerNameAdv neq "")
	OR (isdefined("form.StartDateAdv") AND form.StartDateAdv neq "")
	OR (isdefined("form.EndDateAdv") AND form.EndDateAdv neq "")
	OR (isdefined("form.CarrierNameAdv") AND form.CarrierNameAdv neq "")
	OR (isdefined("form.CustomerPOAdv") AND form.CustomerPOAdv neq "")
	OR (isdefined("form.txtBol") AND form.txtBol neq "")
	OR (isdefined("form.txtDispatcher") AND form.txtDispatcher neq "")
	OR (isdefined("form.txtAgent") AND form.txtAgent neq "")
	>
		
        <cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" agentUserName="#request.myLoadsAgentUserName#" rowsperpage="#pageSize#" returnvariable="qLoads">
			<cfinvokeargument name="LoadStatus" value="#form.LoadStatusAdv#">
            <cfinvokeargument name="LoadNumber" value="#form.LoadNumberAdv#">
            <cfinvokeargument name="Office" value="#form.OfficeAdv#">
			<cfinvokeargument name="shipperCity" value="#form.shipperCityAdv#">
            <cfinvokeargument name="consigneeCity" value="#form.consigneeCityAdv#">
            <cfinvokeargument name="ShipperState" value="#form.ShipperStateAdv#">
            <cfinvokeargument name="ConsigneeState" value="#form.ConsigneeStateAdv#">
            <cfinvokeargument name="CustomerName" value="#form.CustomerNameAdv#">
            <cfinvokeargument name="StartDate" value="#form.StartDateAdv#">
            <cfinvokeargument name="EndDate" value="#form.EndDateAdv#">
            <cfinvokeargument name="CarrierName" value="#form.CarrierNameAdv#">
            <cfinvokeargument name="CustomerPO" value="#form.CustomerPOAdv#">
            <cfinvokeargument name="bol" value="#form.txtBol#">
            <cfinvokeargument name="dispatcher" value="#form.txtDispatcher#">
            <cfinvokeargument name="agent" value="#form.txtAgent#">		
            <cfif isdefined('form.pageNo')>
	            <cfinvokeargument name="pageNo" value="#form.pageNo#">
            <cfelse>
            	<cfinvokeargument name="pageNo" value="1">
            </cfif>
            
            <cfif isdefined('form.sortOrder')>
	            <cfinvokeargument name="sortorder" value="#form.sortOrder#">
            </cfif>
            <cfif isdefined('form.sortBy')>
	            <cfinvokeargument name="sortby" value="#form.sortBy#">
            </cfif>
            
		</cfinvoke>
	</cfif>


</div>



   	<cfif isdefined('url.event') AND url.event eq 'exportData'>
    	<div id="exportLink" class="exportbutton">
       		<a href="javascript:exportLoads('#application.QBdsn#','#application.dsn#','#request.webpath#','#session.URLToken#')" onclick="document.getElementById('exportLink').className = 'busyButton';">Export ALL</a>
        </div>
    <cfelseif Not structKeyExists(session, "IsCustomer")>
    
    <!---add new link for dispatch board--->
    
		<cfif isdefined('url.event') and url.event eq 'dispatchboard'>
        	
            <div class="addbutton">
                <a href="index.cfm?event=addload&#session.URLToken#">Add New</a>
            </div>
           
         <cfelse>
         <!---add new link for load/my load--->
            <div class="addbutton">
                <a href="index.cfm?event=addload&#session.URLToken#">Add New</a>
            </div>
         </cfif>
    </cfif>
</div>
<div class="clear"></div>

<cfif isdefined('url.event') and url.event eq 'dispatchboard'>
<cfinvoke component="#variables.objLoadGateway#" method="getLoadStatusTypes" returnvariable="qLoadStatusTypes" />
	<cfinvoke component="#variables.objAgentGateway#" method="getAgentsLoadStatusTypesByLoginID" agentLoginId="#session.AdminUserName#" returnvariable="qAgentsLoadStatusTypes" />

<cfquery name="qLoadsDistinceStatus" dbtype="query">
	SELECT DISTINCT statusText, statustypeid, colorCode
	FROM qLoads
</cfquery>

	<table>
	  <tr>
		<td align="center">
			<label style="font-size:14px;  font-weight:bold">
				<!---<cfset isFirstMatch = 'yes'>
				<cfloop query="qLoads">
					<cfif qLoads.statustypeid EQ qAgentsLoadStatusTypes.loadStatusTypeID AND qAgentsLoadStatusTypes.dispatchBoardDirection EQ 'L'>
						<cfif isFirstMatch EQ 'no'>,</cfif>
						<cfset isFirstMatch = 'no'>
						<font style="color:###qLoadStatusTypes.colorCode#">#qLoadStatusTypes.statustext#</font>
					</cfif>
				</cfloop>--->
				<cfset isFirstMatch = 'yes'>
				<cfloop query="qLoadsDistinceStatus">
					<cfquery dbtype="query" name="qIsLeftSideRecord">
						SELECT *
						FROM qAgentsLoadStatusTypes
						WHERE loadStatusTypeID = <cfqueryparam value="#qLoadsDistinceStatus.STATUSTYPEID#" cfsqltype="cf_sql_varchar">
						AND qAgentsLoadStatusTypes.dispatchBoardDirection = <cfqueryparam value="L" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif qIsLeftSideRecord.RecordCount NEQ 0>
						<cfif isFirstMatch EQ 'no'>, </cfif>
						<cfset isFirstMatch = 'no'>
						<font style="color:###qLoadsDistinceStatus.colorCode#">#qLoadsDistinceStatus.statustext# </font>
					</cfif>
				</cfloop>
			</label>
		</td>
		<td>&nbsp;</td>
		<td align="center">
			<label style="font-size:14px;  font-weight:bold">
				<cfset isFirstMatch = 'yes'>
				<cfloop query="qLoadsDistinceStatus">
					<cfquery dbtype="query" name="qIsLeftSideRecord">
						SELECT *
						FROM qAgentsLoadStatusTypes
						WHERE loadStatusTypeID = <cfqueryparam value="#qLoadsDistinceStatus.STATUSTYPEID#" cfsqltype="cf_sql_varchar">
						AND qAgentsLoadStatusTypes.dispatchBoardDirection = <cfqueryparam value="R" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif qIsLeftSideRecord.RecordCount NEQ 0>
						<cfif isFirstMatch EQ 'no'>, </cfif>
						<cfset isFirstMatch = 'no'>
						<font style="color:###qLoadsDistinceStatus.colorCode#">#qLoadsDistinceStatus.statustext# </font>
					</cfif>
				</cfloop>
			</label>
		</td>
	  </tr>
	  <tr>
		<td style="vertical-align:top;">
			<table style="width:100%; font-weight:bold; font-size:9px;"  border="0" cellspacing="0" cellpadding="0" class="data-table">
			  <thead>
				  <tr>
					<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
					<!---<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>--->
					
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('l.LoadNumber','dispLoadForm');">LOAD##</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('statusText','dispLoadForm');">STATUS</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('CustomerName','dispLoadForm');">CUSTOMER</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('NewPickupDate','dispLoadForm');">SHIP</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('shipperCity','dispLoadForm');">S.CITY</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('shipperState','dispLoadForm');">ST</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('consigneeCity','dispLoadForm');">C.CITY</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('consigneeState','dispLoadForm');">ST</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('NewDeliveryDate','dispLoadForm');">DELIVERY</th>
					<th align="right" valign="middle" class="head-bg" onclick="sortTableBy('TotalCustomerCharges','dispLoadForm');">CUST AMT</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('CarrierName','dispLoadForm');">
						<cfif request.qSystemSetupOptions1.freightBroker>
							CARRIER
						<cfelse>
							DRIVER
						</cfif>
					</th>
					<th align="right" valign="middle" class="head-bg2" onclick="sortTableBy('CarrierName','dispLoadForm');">Carr.Amt</th>
					<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
				  </tr>
			  </thead>
			  <tbody>
			  
			  	 <cfif qLoads.recordcount eq 0>
					<script> showErrorMessage('block'); </script>
				<cfelse>
					<script> showErrorMessage('none'); </script>
					
				<cfloop query="qLoads">
					<cfquery dbtype="query" name="qIsLeftSideRecord">
						SELECT *
						FROM qAgentsLoadStatusTypes
						WHERE loadStatusTypeID = <cfqueryparam value="#qLoads.STATUSTYPEID#" cfsqltype="cf_sql_varchar">
						AND qAgentsLoadStatusTypes.dispatchBoardDirection = <cfqueryparam value="L" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif qIsLeftSideRecord.RecordCount EQ 0>
						<cfcontinue>
					</cfif>
					
					<cfif isdefined('url.event') AND url.event eq 'exportData' AND qLoads.ARExportedNN eq '1' AND qLoads.APExportedNN eq '1' >
						<cfcontinue>
					<cfelseif isdefined('url.event') AND url.event eq 'exportData'>
						<cfif not isdefined('form.orderDateFrom')>
							<cfset dateFrom = DateFormat('01/01/1900','mm/dd/yyyy')>
						<cfelse>
							<cfset dateFrom = DateFormat(form.orderDateFrom,'mm/dd/yyyy')>
						</cfif>
						
						<cfif not isdefined('form.orderDateTo')>
							<cfset dateTo = DateFormat(NOW(),'mm/dd/yyyy')>
						<cfelse>
							<cfset dateTo = DateFormat(form.orderDateTo,'mm/dd/yyyy')>
						</cfif>
						
						<cfif not isdefined('request.qLoads.orderDate') OR request.qLoads.orderDate eq ''>
							<cfset orderDate = DateFormat(NOW(),'mm/dd/yyyy')>
						<cfelse>
							<cfset orderDate = DateFormat(qLoads.orderDate,'mm/dd/yyyy')>
						</cfif>
						
						<cfif orderDate gte dateFrom AND orderDate lte dateTo>
							<!--- Do nothing, keep the normal flow --->
						<cfelse>
							<cfcontinue>
						</cfif>
					</cfif>
					<cfset request.ShipperStop = qLoads>
					<cfset request.ConsineeStop = qLoads>
					<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#qLoads.PAYERID#" returnvariable="request.qCustomer" />
					<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" LoadStatusID="#qLoads.statusTypeID#" returnvariable="request.qLoadStatus" />
					
					
					<cfset pageSize = 30>
					<cfif isdefined("form.pageNo")>
						<cfset rowNum=(qLoads.currentRow) + ((form.pageNo-1)*pageSize)>
					<cfelse>
						<cfset rowNum=(qLoads.currentRow)>
					</cfif>
			  		<cfif ListContains(session.rightsList,'editLoad',',')>
						<cfset onRowClick = "document.location.href='index.cfm?event=addload&loadid=#qLoads.LOADID#&#session.URLToken#'">
					<cfelse>
						<cfset onRowClick = "javascript: alert('You do not have the rights to edit loads');">
					</cfif>
					
			  
				  <tr style="background:###request.qLoadStatus.ColorCode#; cursor:pointer;" onmouseover="this.style.background = '##FFFFFF';" onmouseout="this.style.background = '###request.qLoadStatus.ColorCode#';" onclick="#onRowClick#" <cfif qLoads.Row mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
					<td height="20" class="sky-bg">&nbsp;</td>
					<!---<td align="center" valign="middle" nowrap="nowrap" class="sky-bg2">1</td>--->


<!---<cfset Trim_shippercity = request.ShipperStop.shippercity>
##--->
					<td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#qLoads.loadNumber#</td>
					<td width="50px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#qLoads.statusText#">#truncateMyString(6,qLoads.statusText)#</td>
					<td width="70px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#request.qCustomer.customerName#">#truncateMyString(9, request.qCustomer.customerName)#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td" >#dateformat(qLoads.PICKUPDATE,'m/d/yy')#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#request.ShipperStop.shippercity#">#truncateMyString(9, request.ShipperStop.shippercity)#</td>
					<td width="20px" align="left" valign="middle" nowrap="nowrap" class="normal-td" >#request.ShipperStop.shipperState#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#request.ConsineeStop.consigneeCity#">#truncateMyString(9,request.ConsineeStop.consigneeCity)#</td>
					<td width="20px" align="left" valign="middle" nowrap="nowrap" class="normal-td" >#request.ConsineeStop.consigneeState#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td">#dateformat(qLoads.DeliveryDATE,'m/d/yy')#</td>
					<td width="60px" align="right" valign="middle" nowrap="nowrap" class="normal-td" >#NumberFormat(qLoads.TOTALCUSTOMERCHARGES,'$')#</td>
					<td width="70px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#qLoads.CARRIERNAME#">#truncateMyString(10,qLoads.CARRIERNAME)#</td>
					<td width="70px" align="right" valign="middle" nowrap="nowrap" class="normal-td2" >#NumberFormat(qLoads.TOTALCARRIERCHARGES,'$')#</td>
					<td class="normal-td3">&nbsp;</td>
				  </tr>
    	 </cfloop>
    	 </cfif>
			  </tbody>
			  <tfoot>
				 <tr>
					<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
					<td colspan="13" align="left" valign="middle" class="footer-bg">
						<div class="up-down">
							<div class="arrow-top"><a href="javascript: tablePrevPage('dispLoadForm');"><img src="images/arrow-top.gif" alt="" /></a></div>
							<div class="arrow-bot"><a href="javascript: tableNextPage('dispLoadForm');"><img src="images/arrow-bot.gif" alt="" /></a></div>
						</div>
						<div class="gen-left"><a href="javascript: tablePrevPage('dispLoadForm');">Prev </a>-
						<a href="javascript: tableNextPage('dispLoadForm');"> Next</a></div>
						<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
						<div class="clear"></div>
					</td>
					<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
				 </tr>	
				 </tfoot>	
			  </table>
		</td>
		<td>&nbsp;</td>
		<td style="vertical-align:top;"><!---2nd Table--->
			<table style="width:100%; font-weight:bold; font-size:9px;"  border="0" cellspacing="0" cellpadding="0" class="data-table">
			  <thead>
				  <tr>
					<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
					<!---<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>--->
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('l.LoadNumber','dispLoadForm');">LOAD##</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('statusText','dispLoadForm');">STATUS</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('CustomerName','dispLoadForm');">CUSTOMER</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('NewPickupDate','dispLoadForm');">SHIP</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('shipperCity','dispLoadForm');">S.CITY</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('shipperState','dispLoadForm');">ST</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('consigneeCity','dispLoadForm');">C.CITY</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('consigneeState','dispLoadForm');">ST</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('NewDeliveryDate','dispLoadForm');">DELIVERY</th>
					<th align="right" valign="middle" class="head-bg" onclick="sortTableBy('TotalCustomerCharges','dispLoadForm');">CUST AMT</th>
					<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('CarrierName','dispLoadForm');">
						<cfif request.qSystemSetupOptions1.freightBroker>
							CARRIER
						<cfelse>
							DRIVER
						</cfif>
					</th>
					<th align="right" valign="middle" class="head-bg2" onclick="sortTableBy('CarrierName','dispLoadForm');">Carr.Amt</th>
					<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
				  </tr>
			  </thead>
			  <tbody>
			  
			  
			  	 <cfif qLoads.recordcount eq 0>
					<script> showErrorMessage('block'); </script>
				<cfelse>
					<script> showErrorMessage('none'); </script>
					
				<cfloop query="qLoads">
					<cfquery dbtype="query" name="qIsLeftSideRecord">
						SELECT *
						FROM qAgentsLoadStatusTypes
						WHERE loadStatusTypeID = <cfqueryparam value="#qLoads.STATUSTYPEID#" cfsqltype="cf_sql_varchar">
						AND qAgentsLoadStatusTypes.dispatchBoardDirection = <cfqueryparam value="R" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif qIsLeftSideRecord.RecordCount EQ 0>
						<cfcontinue>
					</cfif>
					
					<cfif isdefined('url.event') AND url.event eq 'exportData' AND qLoads.ARExportedNN eq '1' AND qLoads.APExportedNN eq '1' >
						<cfcontinue>
					<cfelseif isdefined('url.event') AND url.event eq 'exportData'>
						<cfif not isdefined('form.orderDateFrom')>
							<cfset dateFrom = DateFormat('01/01/1900','mm/dd/yyyy')>
						<cfelse>
							<cfset dateFrom = DateFormat(form.orderDateFrom,'mm/dd/yyyy')>
						</cfif>
						
						<cfif not isdefined('form.orderDateTo')>
							<cfset dateTo = DateFormat(NOW(),'mm/dd/yyyy')>
						<cfelse>
							<cfset dateTo = DateFormat(form.orderDateTo,'mm/dd/yyyy')>
						</cfif>
						
						<cfif not isdefined('request.qLoads.orderDate') OR request.qLoads.orderDate eq ''>
							<cfset orderDate = DateFormat(NOW(),'mm/dd/yyyy')>
						<cfelse>
							<cfset orderDate = DateFormat(qLoads.orderDate,'mm/dd/yyyy')>
						</cfif>
						
						<cfif orderDate gte dateFrom AND orderDate lte dateTo>
							<!--- Do nothing, keep the normal flow --->
						<cfelse>
							<cfcontinue>
						</cfif>
					</cfif>
					<cfset request.ShipperStop = qLoads>
					<cfset request.ConsineeStop = qLoads>
					<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#qLoads.PAYERID#" returnvariable="request.qCustomer" />
					<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" LoadStatusID="#qLoads.statusTypeID#" returnvariable="request.qLoadStatus" />
					
					
					<cfset pageSize = 30>
					<cfif isdefined("form.pageNo")>
						<cfset rowNum=(qLoads.currentRow) + ((form.pageNo-1)*pageSize)>
					<cfelse>
						<cfset rowNum=(qLoads.currentRow)>
					</cfif>
					<cfif ListContains(session.rightsList,'editLoad',',')>
			  			<cfset onRowClick = "document.location.href='index.cfm?event=addload&loadid=#qLoads.LOADID#&#session.URLToken#'">
					<cfelse>
						<cfset onRowClick = "javascript: alert('You do not have the rights to edit loads');">
					</cfif>
					
				  <tr style="background:###request.qLoadStatus.ColorCode#; cursor:pointer;" onmouseover="this.style.background = '##FFFFFF';" onmouseout="this.style.background = '###request.qLoadStatus.ColorCode#';" onclick="#onRowClick#" <cfif qLoads.Row mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
					<td height="20" class="sky-bg">&nbsp;</td>
					<!---<td align="center" valign="middle" nowrap="nowrap" class="sky-bg2">1</td>--->


<!---<cfset Trim_shippercity = request.ShipperStop.shippercity>
##--->
					<td width="40px" align="center" valign="middle" nowrap="nowrap" class="normal-td">#qLoads.loadNumber#</td>
					<td width="50px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#qLoads.statusText#">#truncateMyString(6,qLoads.statusText)#</td>
					<td width="70px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#request.qCustomer.customerName#">#truncateMyString(9, request.qCustomer.customerName)#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td" >#dateformat(qLoads.PICKUPDATE,'m/d/yy')#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#request.ShipperStop.shippercity#">#truncateMyString(9, request.ShipperStop.shippercity)#</td>
					<td width="20px" align="left" valign="middle" nowrap="nowrap" class="normal-td" >#request.ShipperStop.shipperState#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#request.ConsineeStop.consigneeCity#">#truncateMyString(9,request.ConsineeStop.consigneeCity)#</td>
					<td width="20px" align="left" valign="middle" nowrap="nowrap" class="normal-td" >#request.ConsineeStop.consigneeState#</td>
					<td width="55px" align="left" valign="middle" nowrap="nowrap" class="normal-td">#dateformat(qLoads.DeliveryDATE,'m/d/yy')#</td>
					<td width="60px" align="right" valign="middle" nowrap="nowrap" class="normal-td" >#NumberFormat(qLoads.TOTALCUSTOMERCHARGES,'$')#</td>
					<td width="70px" align="left" valign="middle" nowrap="nowrap" class="normal-td" title="#qLoads.CARRIERNAME#">#truncateMyString(10,qLoads.CARRIERNAME)#</td>
					<td width="70px" align="right" valign="middle" nowrap="nowrap" class="normal-td2" >#NumberFormat(qLoads.TOTALCARRIERCHARGES,'$')#</td>
					<td class="normal-td3">&nbsp;</td>
				  </tr>
    	 </cfloop>
    	 </cfif>
			  </tbody>
			  <tfoot>
				 <tr>
					<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
					<td colspan="13" align="left" valign="middle" class="footer-bg">
						<div class="up-down">
							<div class="arrow-top"><a href="javascript: tablePrevPage('dispLoadForm');"><img src="images/arrow-top.gif" alt="" /></a></div>
							<div class="arrow-bot"><a href="javascript: tableNextPage('dispLoadForm');"><img src="images/arrow-bot.gif" alt="" /></a></div>
						</div>
						<div class="gen-left"><a href="javascript: tablePrevPage('dispLoadForm');">Prev </a>-
						<a href="javascript: tableNextPage('dispLoadForm');"> Next</a></div>
						<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
						<div class="clear"></div>
					</td>
					<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
				 </tr>	
				 </tfoot>	
			  </table>
		</td>
	  </tr>
	</table>
	
  
	  <div style="clear:left;"></div>
<cfelse>
	<cfform id="dispLoadFormUdateShipDate" name="dispLoadFormUdateShipDate" action="#actionUrl#" method="post" preserveData="yes">
	<cfif request.qSystemSetupOptions1.rolloverShipDateStatus>
		 <cfif isdefined('url.event') AND url.event neq 'exportData'>
		 	<div id="dialog-confirm"></div>
		 	<div id="Information"></div>
		 	<div id="responseUploadProcess"></div>
		 	<cfif request.qSystemSetupOptions1.rolloverShipDateStatus AND structKeyExists(request, "qrygetAgentdetails") AND structKeyExists(request.qrygetAgentdetails, "ROLEID") AND request.qrygetAgentdetails.ROLEID neq 7>
		 			<div style="width: 523px; float: right; margin-top: -68px;margin-right: 239px;" class="hideStatus">
						<div style="float: left;margin-left: 17px;" id="status">
							<div style="float:left;width: 48px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Status</label>
		    				</div>
							<div style="float:left;">
								<select name="loadStatusUpdate" id="loadStatusUpdate" class="medium" style="width: 109px;" onchange="loadboardsstatus()">
					                <option value="">Select Status</option>
									<cfloop query="request.qLoadStatus">
					                  <option value="#request.qLoadStatus.value#">#request.qLoadStatus.Text#</option>
					                </cfloop>
					             </select>
			 				</div>
						</div>
						<div style="float: left;margin-left: 42px;" id="status">
							<div style="float:left;width: 102px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Post to ITS</label>
		    				</div>
							<div style="float:left;margin-top: 1px;">
								<input name="postToIts" type="checkbox" id="postToIts">
			 				</div>
						</div>
						<div style="float: left;margin-left: 25px;" id="status">
							<div style="float:left;width: 122px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Post DAT Load Board</label>
		    				</div>
							<div style="float:left;margin-top: 1px;">
								<input name="postdatloadboard" type="checkbox" id="postdatloadboard">
			 				</div>
						</div>
		  				<div style="clear:both"></div>
					</div>
					
			 		<!--- <div style="width: 372px;float: right;margin-top: -53px;margin-right: 366px;" class="hideStatus">
						<div style="float: left;" id="status">
							<div style="float:left;width: 48px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Status</label>
		    				</div>
							<div style="float:left;">
								<select name="loadStatusUpdate" id="loadStatusUpdate" class="medium" style="width: 109px;">
					                <option value="">Select Status</option>
									<cfloop query="request.qLoadStatus">
					                  <option value="#request.qLoadStatus.value#">#request.qLoadStatus.Text#</option>
					                </cfloop>
					             </select>
			 				</div>
						</div>
						<div style="float: left;margin-left: 45px;" id="status">
							<div style="float:left;width: 122px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Post Everywhere</label>
		    				</div>
							<div style="float:left;margin-top: 1px;">
								<input name="postToIts" type="checkbox" id="postToIts">
			 				</div>
						</div>
						<div style="float: left;margin-left: 25px;" id="status">
							<div style="float:left;width: 122px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Post 123Load Board</label>
		    				</div>
							<div style="float:left;margin-top: 1px;">
								<input name="postToIts" type="checkbox" id="postToIts">
			 				</div>
						</div>
						
		  				<div style="clear:both"></div>
					</div> --->
					<div style="width: 667px; float: right; margin-top: -44px;margin-right: 96px; " class="hideDate">
						
						<div style="float: left;" id="rollOverShipDateContainer">
		  					<div style="float:left;width: 65px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Ship Date</label>
		    				</div>
						
							<div style="float:left;">
								<cfinput name="rollOverShipDate" type="datefield" class="datefieldinput " style="width:103px;" id="rollOverShipDate" onblur="checkDateFormatAll(this)" value="">
			 				</div>
						</div>	
						<div style="float: left;margin-left: 25px;" id="status">
							<div style="float:left;width: 102px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Post Everywhere</label>
		    				</div>
							<div style="float:left;margin-top: 1px;">
								<input name="posteverywhere" type="checkbox" id="posteverywhere">
			 				</div>
						</div>
						<div style="float: left;margin-left: 25px;" id="status">
							<div style="float:left;width: 122px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Post 123Load Board</label>
		    				</div>
							<div style="float:left;margin-top: 1px;">
								<input name="post123loadboard" type="checkbox" id="post123loadboard">
			 				</div>
						</div>
						<div style="float: left;margin-left: 18px;margin-top: -21px;" id="updateLoadsContainer">
							<cfinput name="updateLoads" id="updateLoads" onclick="return UpdateLoadsCheck();" type="button" class="s-bttn" value="Update Loads" style="width:56px;">
							<cfinput name="dsn" type="hidden" value="#variables.dsn#" id="dsn">
							<cfinput name="Id" type="hidden" value="#session.empid#" id="Id">
						</div>
		  				<div style="clear:both">
						</div>
						<div style="margin-top: 5px;" id="weekendRollOver">
							
							<div style="float:right;margin-top: 1px;margin-right: 34px;">
								<input name="weekendRollOvercheck" type="checkbox" id="weekendRollOvercheck" checked="true">
			 				</div>
			 				<div style="float:right; margin-right: 5px;">
								<label style="color: ##0a0a0a;font-weight: bold;">Weekends rollover to Monday? </label>
		    				</div>
		    				<div style="clear:both;"></div>
						</div>
					</div>

			</cfif>	
		</cfif>
	</cfif>
	
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="data-table">
      <thead>
      <tr>
    	<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
    	<th width="29" align="center" valign="middle" class="head-bg numbering">&nbsp;</th>
    	<cfif request.qSystemSetupOptions1.rolloverShipDateStatus AND structKeyExists(request, "qrygetAgentdetails") AND structKeyExists(request.qrygetAgentdetails, "ROLEID") AND request.qrygetAgentdetails.ROLEID neq 7>
    		<cfif isdefined('url.event') AND url.event neq 'exportData'>
    			<th  align="center" valign="middle" class="head-bg"> <input type="checkbox" name="rolloverShipDateAll" id="rolloverShipDateAll" class="checkboxSelect" onclick="checkboxOperation(this)"></th>
    		</cfif>	
    	</cfif>	
    	<th align="center" valign="middle" class="head-bg load" onclick="sortTableBy('l.LoadNumber','dispLoadForm');">LOAD##</th>
    	<th align="center" valign="middle" class="head-bg statusWrap" onclick="sortTableBy('statusText','dispLoadForm');">STATUS</th>
    	<th align="center" valign="middle" class="head-bg custWrap" onclick="sortTableBy('CustomerName','dispLoadForm');">CUSTOMER</th>
		<th align="center" valign="middle" class="head-bg poWrap" onclick="sortTableBy('CustomerPONo','dispLoadForm');">PO##</th>
    	<th align="center" valign="middle" class="head-bg shipdate" onclick="sortTableBy('NewPickupDate','dispLoadForm');">SHIPDATE</th>
    	<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('shipperCity','dispLoadForm');">SHIPCITY</th>
		<th align="center" valign="middle" class="head-bg stHead" onclick="sortTableBy('shipperState','dispLoadForm');">ST</th>
    	<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('consigneeCity','dispLoadForm');">CONSCITY</th>
    	<th align="center" valign="middle" class="head-bg stHead" onclick="sortTableBy('consigneeState','dispLoadForm');">ST</th>
		<th align="center" valign="middle" class="head-bg deliverDate" onclick="sortTableBy('NewDeliveryDate','dispLoadForm');">DELIVERYDATE</th>

		<cfif request.qSystemSetupOptions1.showcustomeramount>
    		<th align="right" valign="middle" class="head-bg custAmt" onclick="sortTableBy('TotalCustomerCharges','dispLoadForm');">CUST_AMT</th>
    	</cfif>	

    	<cfif request.qSystemSetupOptions1.showcarrieramount>
    		<th align="right" valign="middle" class="head-bg custAmt" onclick="sortTableBy('TotalCarrierCharges','dispLoadForm');">CARR_AMT</th>
    	</cfif>	

		<th align="center" valign="middle" class="head-bg" onclick="sortTableBy('CarrierName','dispLoadForm');">
			<!--- <cfif request.qSystemSetupOptions1.freightBroker>
				CARRIER
			<cfelse>
				DRIVER
			</cfif> --->
			<cfif request.qSystemSetupOptions1.freightBroker and customer NEQ 1>
				CARRIER
			<cfelseif NOT val(request.qSystemSetupOptions1.freightBroker)>
				DRIVER
			</cfif>
		</th>
		<th align="center" valign="middle" class="head-bg dispatch" onclick="sortTableBy('EquipmentName','dispLoadForm');">EquipmentName </th>
		<th align="center" valign="middle" class="head-bg dispatch" onclick="sortTableBy('DriverName','dispLoadForm');">Driver </th>
		<th align="center" valign="middle" class="head-bg dispatch" onclick="sortTableBy('empDispatch','dispLoadForm');">Dispatcher </th>
		<th align="center" valign="middle" class="head-bg2 agent" <cfif request.qSystemSetupOptions1.freightBroker> onclick="sortTableBy('empAgent','dispLoadForm');" <cfelse> onclick="sortTableBy('userDefinedFieldTrucking','dispLoadForm');"</cfif>><cfif request.qSystemSetupOptions1.freightBroker>Agent <cfelse> #left(request.qSystemSetupOptions1.userDef7,9)#</cfif></th>
    	<!--- <th align="center" valign="middle" class="head-bg2">Action</th> --->
    	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
      </tr>
      </thead>
      	<tbody>
	        <cfif qLoads.recordcount eq 0>
		        <script> showErrorMessage('block'); </script>
	        <cfelse>
	        	<script> showErrorMessage('none'); </script>
		        <cfset variables.counter=0>	
		        <cfloop query="qLoads">
		        	<cfif isdefined('url.event') AND url.event eq 'exportData' AND qLoads.ARExportedNN eq '1' AND qLoads.APExportedNN eq '1' >
		        		<cfcontinue>
		        	<cfelseif isdefined('url.event') AND url.event eq 'exportData'>
		            	<cfif not isdefined('form.orderDateFrom')>
		            		<cfset dateFrom = DateFormat('01/01/1900','mm/dd/yyyy')>
			            <cfelse>
			            	<cfset dateFrom = DateFormat(form.orderDateFrom,'mm/dd/yyyy')>
			            </cfif>
			            
			            <cfif not isdefined('form.orderDateTo')>
			            	<cfset dateTo = DateFormat(NOW(),'mm/dd/yyyy')>
			            <cfelse>
			            	<cfset dateTo = DateFormat(form.orderDateTo,'mm/dd/yyyy')>
			            </cfif>
			            
						<cfif not isdefined('request.qLoads.orderDate') OR request.qLoads.orderDate eq ''>
			            	<cfset orderDate = DateFormat(NOW(),'mm/dd/yyyy')>
			            <cfelse>
			            	<cfset orderDate = DateFormat(qLoads.orderDate,'mm/dd/yyyy')>
			            </cfif>
			            
			            <cfif orderDate gte dateFrom AND orderDate lte dateTo>
			            	<!--- Do nothing, keep the normal flow --->
			            <cfelse>
			            	<cfcontinue>
			            </cfif>
		       		</cfif>
					<cfset request.ShipperStop = qLoads>
					<cfset request.ConsineeStop = qLoads>
					<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#qLoads.PAYERID#" returnvariable="request.qCustomer" />
					<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" LoadStatusID="#qLoads.statusTypeID#" returnvariable="request.qLoadStatus" />
		        
		        
		        	<cfset pageSize = 30>
		        	<cfif structKeyExists(request.qSystemSetupOptions1, "rowsperpage") AND request.qSystemSetupOptions1.rowsperpage>
		        		<cfset pageSize = request.qSystemSetupOptions1.rowsperpage>
		       		</cfif>

		        	<cfif isdefined("form.pageNo")>
		           		<cfset rowNum=(qLoads.currentRow) + ((form.pageNo-1)*pageSize)>
		        	<cfelse>
			           	<cfset rowNum=(qLoads.currentRow)>
			        </cfif>
					<cfif ListContains(session.rightsList,'editLoad',',')>
						<cfset onRowClick = "document.location.href='index.cfm?event=addload&loadid=#qLoads.LOADID#&#session.URLToken#'">
						<cfset onHrefClick = "index.cfm?event=addload&loadid=#qLoads.LOADID#&#session.URLToken#">
					<cfelse>
						<cfset onRowClick = "javascript: alert('You do not have the rights to edit loads');">
						<cfset onHrefClick = "javascript: alert('You do not have the rights to edit loads');">
					</cfif>
		         
		    		<tr style="background:###request.qLoadStatus.ColorCode#; cursor:pointer;" onmouseover="this.style.background = '##FFFFFF';" onmouseout="this.style.background = '###request.qLoadStatus.ColorCode#';" <cfif qLoads.Row mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
		    			<td height="20" class="sky-bg">&nbsp;</td>
		    			<td align="center" valign="middle" nowrap="nowrap" class="sky-bg2" onclick="#onRowClick#">#rowNum#</td>
		    			<cfif request.qSystemSetupOptions1.rolloverShipDateStatus AND structKeyExists(request, "qrygetAgentdetails") AND structKeyExists(request.qrygetAgentdetails, "ROLEID") AND request.qrygetAgentdetails.ROLEID neq 7>
		    				<cfif isdefined('url.event') AND url.event neq 'exportData'>
		    					<td align="center" valign="middle" nowrap="nowrap" class="sky-bg2 " style="padding: 0 5px 0 5px;" ><cfinput type="checkbox" name="rolloverShipDateCheckSub" id="rolloverShipDateCheckSub" class="checkboxSelect" value="#qLoads.loadNumber#"></td>
		    				</cfif>
		    			</cfif>
		    			<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#qLoads.loadNumber#</a></td>
						<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#qLoads.statusText#</a></td>
						<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#request.qCustomer.customerName#</a></td>
						<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#qLoads.CUSTOMERPONO#</a></td>
						<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#dateformat(qLoads.PICKUPDATE,'mm/dd/yyyy')#</a></td>
						<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#request.ShipperStop.shippercity#</a></td>
						<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#request.ShipperStop.shipperState#</a></td>
						<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#request.ConsineeStop.consigneeCity# </a></td>
						<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#request.ConsineeStop.consigneeState#</a></td>
						<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#dateformat(qLoads.DeliveryDATE,'mm/dd/yyyy')#</a></td>
					
						<cfif request.qSystemSetupOptions1.showcustomeramount>
							<td align="right" valign="middle" nowrap="nowrap" class="normal-td custAmt" onclick="#onRowClick#"><a href="#onHrefClick#">#NumberFormat(qLoads.TOTALCUSTOMERCHARGES,'$')#</a></td> 
						</cfif>

						<cfif request.qSystemSetupOptions1.showcarrieramount>
			    			<td align="right" valign="middle" nowrap="nowrap" class="normal-td carrAmt" onclick="#onRowClick#"><a href="#onHrefClick#">#NumberFormat(qLoads.TOTALCARRIERCHARGES,'$')#</a></td>
			    		</cfif>
						
						<cfif customer neq 1>
							<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#">
								<a href="#onHrefClick#">#qLoads.CARRIERNAME#</a>
							</td>
						</cfif>
						<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#qLoads.EquipmentName#</a></td>
						<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#qLoads.DriverName#</a></td>
						<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#onRowClick#"><a href="#onHrefClick#">#qLoads.empDispatch#</a></td>
						<td  align="left" valign="middle" nowrap="nowrap" class="normal-td2" onclick="#onRowClick#"><a href="#onHrefClick#"><cfif request.qSystemSetupOptions1.freightBroker>#qLoads.empAgent# <cfelse> #qLoads.userDefinedFieldTrucking#</cfif></a></td>
						<td class="normal-td3">&nbsp;</td>
		    		</tr>
		    		<cfset variables.counter++>
		    	</cfloop>	
    		</cfif>
    	</tbody>
    	<tfoot>
    		<tr>
    		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
    		<td colspan='<cfif request.qSystemSetupOptions1.rolloverShipDateStatus AND structKeyExists(request, "qrygetAgentdetails") AND structKeyExists(request.qrygetAgentdetails, "ROLEID") and request.qrygetAgentdetails.ROLEID neq 7>17<cfelse>13</cfif>' align="left" valign="middle" class="footer-bg">
    			<div class="up-down">
    				<div class="arrow-top"><a href="javascript: tablePrevPage('dispLoadForm');"><img src="images/arrow-top.gif" alt="" /></a></div>
    				<div class="arrow-bot"><a href="javascript: tableNextPage('dispLoadForm');"><img src="images/arrow-bot.gif" alt="" /></a></div>
    			</div>
    			<div class="gen-left"><a href="javascript: tablePrevPage('dispLoadForm');">Prev </a>-<a href="javascript: tableNextPage('dispLoadForm');"> Next</a></div>
    			<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
    			<div class="clear"></div>
    		</td>
			<td class="footer-bg"></td>
			<td class="footer-bg"></td>
    		<td width="6" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
    	 </tr>	
    	 </tfoot>	  
    </table>
</cfform>
</cfif>
    </cfoutput>
