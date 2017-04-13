<cfparam name="message" default="">
 <cfparam name="url.sortorder" default="desc">
 <cfparam name="sortby"  default="">
<cfsilent>
<cfif isdefined("form.searchText") and len(searchText)>	
	<cfinvoke component="#variables.objclassGateway#" method="getSearchedClass" searchText="#form.searchText#" returnvariable="request.qClasses" />
	<cfif request.qClasses.recordcount lte 0>
		<cfset message="No match found">
	</cfif>
<cfelse>	
	<cfif isdefined("url.classid") and len(url.classid) gt 1>	
		<cfinvoke component="#variables.objclassGateway#" method="deleteClasses" ClassID="#url.classid#" returnvariable="message" />	
		<cfinvoke component="#variables.objclassGateway#" method="getAllClasses" returnvariable="request.qClasses" />
	</cfif>
</cfif>
</cfsilent>
<cfoutput>
<h1>All Class</h1>
<cfif isdefined("message") and len(message)>
<div class="msg-area">#message#</div>
</cfif>
 <cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
           <cfset sortorder="asc">
  <cfelse>
           <cfset sortorder="desc">
 </cfif>
 <cfif isDefined("url.sortby")>
           <cfinvoke component="#variables.objclassGateway#" method="getAllClasses" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="request.qClasses" />
 </cfif> 
<div class="search-panel">
<div class="form-search">
<cfform action="index.cfm?event=class&#session.URLToken#" method="post" preserveData="yes">
	<fieldset>
	<cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
	<input name="" type="submit" class="s-bttn" value="Search" style="width:56px;" />
	<div class="clear"></div>
	</fieldset>
</cfform>			
</div>
<div class="addbutton"><a href="index.cfm?event=addclass&#session.URLToken#">Add New</a></div></div>  
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="data-table">
      <thead>
      <tr>
    	<th width="5" align="left" valign="top"><img src="images/top-left.gif" alt="" width="5" height="23" /></th>
    	<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>
    	<!--- <th width="120" align="center" valign="middle" class="head-bg">Equipment Code</th> --->
    	<th  align="center" valign="middle" class="head-bg" onclick="document.location.href='index.cfm?event=class&sortorder=#sortorder#&sortby=ClassName&#session.URLToken#'">Name</th>
    	<th  align="center" valign="middle" class="head-bg2" onclick="document.location.href='index.cfm?event=class&sortorder=#sortorder#&sortby=IsActive&#session.URLToken#'">Status</th>
    	<!--- <th  align="center" valign="middle" class="head-bg2">Action</th> --->
    	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
      </tr>
      </thead>
      <tbody>
    	<cfloop query="request.qClasses">	
    	<tr <cfif request.qClasses.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
    		<td height="20" class="sky-bg">&nbsp;</td>
    		<td class="sky-bg2" valign="middle" onclick="document.location.href='index.cfm?event=addclass&classid=#request.qClasses.ClassID#&#session.URLToken#'" align="center">#request.qClasses.currentRow#</td>
    	    <td class="normal-td" valign="middle" onclick="document.location.href='index.cfm?event=addclass&classid=#request.qClasses.ClassID#&#session.URLToken#'"  align="left"><a title="#request.qClasses.ClassName#" href="index.cfm?event=addclass&classid=#request.qClasses.ClassID#&#session.URLToken#">#request.qClasses.ClassName#</a></td>
    		<td class="normal-td2" valign="middle" onclick="document.location.href='index.cfm?event=addclass&classid=#request.qClasses.ClassID#&#session.URLToken#'"  align="center"><a href="index.cfm?event=addclass&classid=#request.qClasses.ClassID#&#session.URLToken#"><cfif request.qClasses.IsActive eq 'True'>Active<cfelse>Inactive</cfif></a></td>
    		<!--- <td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addclass&classid=#request.qClasses.ClassID#&#session.URLToken#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=class&classid=#request.qClasses.ClassID#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');"><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
    		<td class="normal-td3">&nbsp;</td>
    	 </tr>
    	 </cfloop>
    	 </tbody>
    	 <tfoot>
    	 <tr>
        		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
        		<td colspan="4" align="left" valign="middle" class="footer-bg">
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
    