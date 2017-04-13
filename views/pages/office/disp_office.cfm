<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">
<cfoutput>
<cfif isdefined("form.searchText") and len(searchText)>
   	<cfinvoke component="#variables.objOfficeGateway#" method="getSearchedOffices" searchText="#form.searchText#" returnvariable="request.qOffice" />
	<cfif request.qOffice.recordcount lte 0>
		<cfset message="No match found">
	</cfif>
<cfelse>
	<cfif isdefined("url.officeID") and len(url.officeID) gt 1>	
		<cfinvoke component="#variables.objOfficeGateway#" method="deleteOffice" officeID="#url.officeID#" returnvariable="message" />	
		<cfinvoke component="#variables.objOfficeGateway#" method="getAllOffices" returnvariable="request.qOffice" />
	</cfif>
</cfif>
<h1>All Offices</h1>
<cfif isdefined("message") and len(message)>
<div class="msg-area">#message#</div>
</cfif>

 <cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
        <cfset sortorder="asc">
     <cfelse>
        <cfset sortorder="desc">
    </cfif>
<cfif isDefined("url.sortby")>
           <cfinvoke component="#variables.objOfficeGateway#" method="getAllOffices" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qOffice" />
</cfif>
<div class="search-panel"><div class="form-search">
<cfform action="index.cfm?event=office&#session.URLToken#" method="post" preserveData="yes">
	<fieldset>
		<cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
		<input name="" type="submit" class="s-bttn" value="Search" style="width:56px;" />
		<div class="clear"></div>
	</fieldset>
</cfform>			
</div>


<cfif ListContains(session.rightsList,'addEditDeleteOffices',',')>
	<cfset newOfficeUrl = "index.cfm?event=addoffice&#session.URLToken#">
<cfelse>
	<cfset newOfficeUrl = "javascript: alert('Sorry!! You don\'t have rights to add new Office.');">
</cfif>

<div class="addbutton"><a href="#newOfficeUrl#">Add New</a></div></div>
<table width="100%" border="0" class="data-table" cellspacing="0" cellpadding="0">
  <thead>
  <tr>
	<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
	<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>
	<th width="120" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=office&sortorder=#sortorder#&sortby=OfficeCode&#session.URLToken#'">Office Code</th>
	<th width="120" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=office&sortorder=#sortorder#&sortby=Location&#session.URLToken#'">Location</th>
	<th width="109" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=office&sortorder=#sortorder#&sortby=AdminManager&#session.URLToken#'">Admin Manager</th>
	<th width="169" align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=office&sortorder=#sortorder#&sortby=EmailId&#session.URLToken#'">Email Id</th>
	<th width="139" align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=office&sortorder=#sortorder#&sortby=ContactNo&#session.URLToken#'">Contact No.</th>
<!--- 	<th width="139" align="center" valign="middle" class="head-bg2">Action</th> --->
	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
  </tr>
  </thead>
  <tbody>
	<cfloop query="request.qOffice">	
	<label for="edit"><tr <cfif request.qOffice.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
		<td height="20" class="sky-bg">&nbsp;</td>
		<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#'" align="center">#request.qOffice.currentRow#</td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#'" align="left"><a title="#request.qOffice.officeCode# #request.qOffice.location# #request.qOffice.adminManager# #request.qOffice.emailId# #request.qoffice.ContactNo#"  href="index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#">#request.qOffice.officeCode#</a></td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#'" align="left"><a title="#request.qOffice.officeCode# #request.qOffice.location# #request.qOffice.adminManager# #request.qOffice.emailId# #request.qoffice.ContactNo#" href="index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#">#request.qOffice.location#</a></td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#'" align="left"><a title="#request.qOffice.officeCode# #request.qOffice.location# #request.qOffice.adminManager# #request.qOffice.emailId# #request.qoffice.ContactNo#" href="index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#">#request.qOffice.adminManager#</a></td>
		<td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#'" align="left"><a title="#request.qOffice.officeCode# #request.qOffice.location# #request.qOffice.adminManager# #request.qOffice.emailId# #request.qoffice.ContactNo#" href="mailto:#request.qOffice.emailId#">#request.qOffice.emailId#</a></td>
		<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#'"  align="left"><a title="#request.qOffice.officeCode# #request.qOffice.location# #request.qOffice.adminManager# #request.qOffice.emailId# #request.qoffice.ContactNo#" href="index.cfm?event=addoffice&officeId=#request.qOffice.officeID#&#session.URLToken#">#request.qoffice.ContactNo#</a></td>
<!--- 		<td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addoffice&officeId=#request.qOffice.officeID#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=office&officeId=#request.qOffice.officeID#"  onclick="return confirm('Are you sure to delete this record ?')";><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
		<td class="normal-td3">&nbsp;</td>
	 </tr></label>
	 </cfloop>
	 </tbody>
	 <tfoot>
	 <tr>
		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
		<td colspan="6" align="left" valign="middle" class="footer-bg">
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