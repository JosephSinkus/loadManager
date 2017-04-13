<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">
<cfsilent>	
<cfif isdefined("form.searchText") and len(searchText)>	
	<cfinvoke component="#variables.objCutomerGateway#" method="getSearchedStop" searchText="#form.searchText#" returnvariable="request.qStop" />
	<cfif request.qStop.recordcount lte 0>
		<cfset message="No match found">
	</cfif>
<cfelse>
<cfif isdefined("url.stopid") and len(url.stopid) gt 1>	
	<cfinvoke component="#variables.objCutomerGateway#" method="deleteStop" CustomerStopID="#url.stopid#" returnvariable="message" />	
	<cfinvoke component="#variables.objCutomerGateway#" method="getAllStop" returnvariable="request.qStop" />
</cfif>
<cfif isdefined("url.customerId") and len(url.customerId) gt 1>	
	<cfinvoke component="#variables.objCutomerGateway#" method="getAllStopByCustomer" customerId="#url.customerID#" returnvariable="request.qStop" />
</cfif>
</cfif>
</cfsilent>
<cfoutput>
<h1>All Stops</h1>
<cfif isdefined("message") and len(message)>
<div class="msg-area">#message#</div>
</cfif>
<cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
          <cfset sortorder="asc">
 <cfelse>
          <cfset sortorder="desc">
</cfif>
<cfif isDefined("url.sortby")>
          <cfinvoke component="#variables.objCutomerGateway#" method="getAllStopByCustomer" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qStop" />
</cfif> 
<div class="search-panel"><div class="form-search">
<cfform action="index.cfm?event=stop&#session.URLToken#" method="post" preserveData="yes">
	<fieldset>
		<cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
		<input name="" type="submit" class="s-bttn" value="Search" style="width:56px;" />
		<div class="clear"></div>
	</fieldset>
</cfform>			
</div>
<div class="addbutton"><a href="index.cfm?event=addstop&#session.URLToken#">Add New</a></div></div>
<table width="100%" border="0" class="data-table" cellspacing="0" cellpadding="0">
      <thead>
      <tr>
    	<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
    	<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>
    	<th width="120" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=stop&sortorder=#sortorder#&sortby=CustomerStopName&#session.URLToken#'">Stop Name</th>
    	<th width="120" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=stop&sortorder=#sortorder#&sortby=Location&#session.URLToken#'">Address</th>
    	<th width="169" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=stop&sortorder=#sortorder#&sortby=ContactPerson&#session.URLToken#'">Contact Person</th>
    	<th width="139" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=stop&sortorder=#sortorder#&sortby=Phone&#session.URLToken#'">Contact No.</th>
    	<th width="109" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=stop&sortorder=#sortorder#&sortby=EmailID&#session.URLToken#'">Email</th>
    	<th width="109" align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=stop&sortorder=#sortorder#&sortby=CustomerName&#session.URLToken#'">Customer</th>
    	<!--- <th width="129" align="center" valign="middle" class="head-bg2">Action</th> --->
    	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
      </tr>
      </thead>
      <tbody>
    	<cfloop query="request.qStop">	
    	    <cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#request.qStop.customerID#" returnvariable="request.qCustomer" />
    	<tr <cfif request.qStop.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
    		<td height="20" class="sky-bg">&nbsp;</td>
    		<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#'" align="center">#request.qStop.currentRow#</td>
    		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#'" align="left"><a title="#request.qStop.CustomerStopName# #request.qStop.Location# #request.qStop.ContactPerson# #request.qStop.Phone# #request.qStop.emailID#" href="index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#">#request.qStop.CustomerStopName#</a></td>
    		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#'" align="left"><a title="#request.qStop.CustomerStopName# #request.qStop.Location# #request.qStop.ContactPerson# #request.qStop.Phone# #request.qStop.emailID#" href="index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#">#request.qStop.Location#</a></td>
    		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#'" align="left"><a title="#request.qStop.CustomerStopName# #request.qStop.Location# #request.qStop.ContactPerson# #request.qStop.Phone# #request.qStop.emailID#" href="index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#">#request.qStop.ContactPerson#</a></td>
    		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#'" align="left"><a title="#request.qStop.CustomerStopName# #request.qStop.Location# #request.qStop.ContactPerson# #request.qStop.Phone# #request.qStop.emailID#" href="index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#">#request.qStop.Phone#</a></td>
    		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#'" align="left"><a title="#request.qStop.CustomerStopName# #request.qStop.Location# #request.qStop.ContactPerson# #request.qStop.Phone# #request.qStop.emailID#" href="mailto:#request.qStop.emailID#">#request.qStop.emailID#</a></td>
    		<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#'"  align="left"><a title="#request.qStop.CustomerStopName# #request.qStop.Location# #request.qStop.ContactPerson# #request.qStop.Phone# #request.qStop.emailID#" href="index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#"><cfif request.qCustomer.recordcount>#request.qCustomer.customerName#</cfif> </a></td>
    		<!--- <td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addstop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=stop&stopid=#request.qStop.CustomerStopID#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');"><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
    		<td class="normal-td3">&nbsp;</td>
    	 </tr>
    	 </cfloop>
    	 </tbody>
    	 <tfoot>
    	 <tr>
    		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
    		<td colspan="7" align="left" valign="middle" class="footer-bg">
    			<div class="up-down">
    				<div class="arrow-top"><a href="##"><img src="images/arrow-top.gif" alt="" /></a></div>
    				<div class="arrow-bot"><a href="##"><img src="images/arrow-bot.gif" alt="" /></a></div>
    			</div>
    			<div class="gen-left"><a href="##">View More</a></div>
    			<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
    			<div class="clear"></div>
    		</td>
    		<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
    	 </tr>	
    	 </tfoot>	  
    </table>
    </cfoutput>
    