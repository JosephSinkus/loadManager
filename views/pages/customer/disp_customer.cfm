<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">
<cfsilent>
	<cfif isdefined("form.searchText") >
		<cfif structKeyExists(url,"payer")>
			<cfinvoke component="#variables.objCutomerGateway#" method="getSearchedCustomer" searchText="#form.searchText#" pageNo="#form.pageNo#" sortorder="#form.sortOrder#" sortby="#form.sortBy#" argPayer="#url.payer#"  returnvariable="qCustomer" />
		<cfelse>
			<cfinvoke component="#variables.objCutomerGateway#" method="getSearchedCustomer" searchText="#form.searchText#" pageNo="#form.pageNo#" sortorder="#form.sortOrder#" sortby="#form.sortBy#"   returnvariable="qCustomer" />
		</cfif>		
			<cfif qCustomer.recordcount lte 0>
				<cfset message="No match found">
			</cfif>
	<cfelse>
		<cfif isdefined("url.customerid") and len(url.customerid) gt 1>	
			<cfinvoke component="#variables.objCutomerGateway#" method="deleteCustomers" CustomerID="#url.customerid#" returnvariable="message" />
			<cfinvoke component="#variables.objCutomerGateway#" method="getSearchedCustomer" searchText="" pageNo="1" returnvariable="qCustomer" />
		<cfelseif isdefined("url.payer")>
			<cfinvoke component="#variables.objCutomerGateway#" method="getSearchedCustomer" searchText="" pageNo="1" argPayer="#url.payer#" returnvariable="qCustomer" />		
		<cfelse>
			<!--- Getting page1 of All Results --->
			<cfinvoke component="#variables.objCutomerGateway#" method="getSearchedCustomer" searchText="" pageNo="1" returnvariable="qCustomer" />		
		</cfif>
	</cfif>
 </cfsilent>


<cfoutput>
<h1>All Customers</h1>
<div style="clear:left"></div>

<cfif isdefined("message") and len(message)>
<div id="message" class="msg-area">#message#</div>
</cfif>

	  <!---<cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
          <cfset sortorder="asc">
       <cfelse>
          <cfset sortorder="desc">
      </cfif>
      <cfif isDefined("url.sortby")>
          <cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="qCustomer" />
      </cfif> --->
   
 
<div class="search-panel">
<div class="form-search">
<cfif structKeyExists(url,'payer')>
	<cfset frmAction = "index.cfm?event=customer&#session.URLToken#&payer=#url.payer#">
<cfelse>
	<cfset frmAction = "index.cfm?event=customer&#session.URLToken#">	
</cfif>


<cfform id="dispCustomerForm" name="dispCustomerForm" action="#frmAction#" method="post" preserveData="yes">
	<cfinput id="pageNo" name="pageNo" value="1" type="hidden">
    
    <cfinput id="sortOrder" name="sortOrder" value="ASC" type="hidden">
    <cfinput id="sortBy" name="sortBy" value="CustomerName" type="hidden">
    
	<fieldset>
		<cfinput name="searchText" type="text" />
		<input name="" onclick="javascript: document.getElementById('pageNo').value=1;" type="submit" class="s-bttn" value="Search" style="width:56px;" />
		<div class="clear"></div>
	</fieldset>
</cfform>			
</div>
<div class="addbutton"><a href="index.cfm?event=addcustomer&#session.URLToken#">Add New</a></div></div>
<table width="100%" border="0" class="data-table" cellspacing="0" cellpadding="0" style="color:##000000;">
      <thead>
      <tr>
    	<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
    	<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>
    	<th width="120" align="center" valign="middle" class="head-bg" onclick="sortTableBy('CustomerName','dispCustomerForm');">Name</th>
    	<th width="169" align="center" valign="middle" class="head-bg" onclick="sortTableBy('address','dispCustomerForm');">Address</th>
    	<th width="139" align="center" valign="middle" class="head-bg" onclick="sortTableBy('phoneNo','dispCustomerForm');">Phone No.</th>
        <th width="120" align="center" valign="middle" class="head-bg" onclick="sortTableBy('office','dispCustomerForm');">Office</th>
    	<th width="109" align="center" valign="middle" class="head-bg2" onclick="sortTableBy('status','dispCustomerForm');">Status</th>
    	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
      </tr>
      </thead>
      <tbody>
         <cfloop query="qCustomer">	
    	    <cfinvoke component="#variables.objAgentGateway#" method="getOffices"  returnvariable="request.qOffices">
        	    <cfinvokeargument name="officeID" value="#qCustomer.OfficeID#">
    	    </cfinvoke>
    	    <cfinvoke component="#variables.objCutomerGateway#" method="getCompanies" returnvariable="request.qCompanies">
    	    <cfinvokeargument name="CompanyID" value="#qCustomer.CompanyID#">
    	    </cfinvoke>
            
            <cfset pageSize = 30>
            <cfif isdefined("form.pageNo")>
            	<cfset rowNum=(qCustomer.currentRow) + ((form.pageNo-1)*pageSize)>
            <cfelse>
            	<cfset rowNum=(qCustomer.currentRow)>
            </cfif>
    	<tr <cfif qCustomer.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
			<td height="20" class="sky-bg">&nbsp;</td>
			<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#'" align="center">#rowNum#</td>
			<td  align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="document.location.href='index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#'"><a title="#qCustomer.CustomerName# <cfif request.qOffices.recordcount gt 0>#request.qOffices.Location# </cfif>  #qCustomer.PhoneNo# #request.qCompanies.CompanyName#" href="index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#">#qCustomer.CustomerName#</a></td>
			<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="document.location.href='index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#'"><a title="#qCustomer.CustomerName# #request.qOffices.Location#  #qCustomer.PhoneNo# #request.qCompanies.CompanyName#" href="index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#"><cfif isDefined("qCustomer.custLocation")>#qCustomer.custLocation#</cfif><cfif isDefined("qCustomer.Location")>#qCustomer.Location#</cfif></a></td>
			<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="document.location.href='index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#'"><a title="#qCustomer.CustomerName# #request.qOffices.Location#  #qCustomer.PhoneNo# #request.qCompanies.CompanyName#" href="index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#">#qCustomer.PhoneNo#</a></td>
			<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="document.location.href='index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#'"><cfif request.qOffices.recordcount gt 0><a title="#qCustomer.CustomerName# <cfif request.qOffices.recordcount gt 0>#request.qOffices.Location# </cfif>  #qCustomer.PhoneNo# #request.qCompanies.CompanyName#" href="index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#">#request.qOffices.Location#</a></cfif></td>
			<td align="center" valign="middle" nowrap="nowrap" class="normal-td2" onclick="document.location.href='index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#'"><a href="index.cfm?event=addcustomer&customerid=#qCustomer.CustomerID#&#session.URLToken#"><cfif #qCustomer.CustomerStatusId# eq 1>Active<cfelse>Inactive</cfif></a></td>
			<td class="normal-td3">&nbsp;</td>
    	 </tr>
    	 </cfloop>
    	 </tbody>
    	 <tfoot>
    	 <tr>
    		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
    		<td colspan="6" align="left" valign="middle" class="footer-bg">
    			<div class="up-down">
    				<div class="arrow-top"><a href="javascript: tablePrevPage('dispCustomerForm');"><img src="images/arrow-top.gif" alt="" /></a></div>
    				<div class="arrow-bot"><a href="javascript: tableNextPage('dispCustomerForm');"><img src="images/arrow-bot.gif" alt="" /></a></div>
    			</div>
    			<div class="gen-left"><a href="javascript: tablePrevPage('dispCustomerForm');">Prev </a>-<a href="javascript: tableNextPage('dispCustomerForm');"> Next</a></div>
    			<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
    			<div class="clear"></div>
    		</td>
    		<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
    	 </tr>	
    	 </tfoot>	  
    </table>
    </cfoutput>
    