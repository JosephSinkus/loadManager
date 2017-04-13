<cfoutput>
<cfsilent>
<cfimport taglib="../../../plugins/customtags/mytag/" prefix="myoffices" >	
<!---Add New Agent------->
<cfparam name="ClassName" default="">
<cfparam name="Status" default="">
<cfparam name="url.editid" default="0">
<cfparam name="url.classid" default="0">

<cfif isdefined("url.classid") and len(trim(url.classid)) gt 1>
	<cfinvoke component="#variables.objclassGateway#" method="getAllClasses" ClassID="#url.classid#" returnvariable="request.qClasses" />
		<cfif request.qClasses.recordcount eq 1>
			<cfset ClassName=#request.qClasses.ClassName#>
			<cfset Status=#request.qClasses.IsActive#>
			<cfset editid=#request.qClasses.ClassID#>
		</cfif>
</cfif>
</cfsilent>
<cfif isdefined("url.classid") and len(trim(url.classid)) gt 1>
<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
	<div class="search-panel"><div class="delbutton"><a href="index.cfm?event=class&classid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');">  Delete</a></div></div>	
	<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Edit Class <span style="padding-left:180px;">#Ucase(ClassName)#</span></h2></div>
</div>
<div style="clear:left;"></div>
<cfelse>
<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
	<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Add New Class</h2></div>
</div>
<div style="clear:left;"></div>
</cfif>
<div class="white-con-area">
<div class="white-top"></div>
<div class="white-mid">
<cfform name="frmClass" action="index.cfm?event=addclass:process&editid=#editid#&#session.URLToken#" method="post">
	<cfinput type="hidden" name="editid" value="#editid#">
	<div class="form-con">
	<fieldset>        
	    <!--- <label><strong>Equipment Code*</strong></label>
	    <cfinput type="text" name="EquipmentCode" value="#EquipmentCode#" size="25" required="yes" message="Please  enter the customer code">
	    <div class="clear"></div>   --->
	    <label><strong>Name*</strong></label>
        <cfinput type="text" name="ClassName" value="#ClassName#" size="25" required="yes" message="The Class Name can only contain numbers, please fix this before continuing." validate="float">
        <div class="clear"></div>
    </fieldset>
    </div>
    <div class="form-con">
      <fieldset>
        <label><strong>Active*</strong></label>
        <select name="Status">
          <option value="True" <cfif Status eq 'True'>selected="selected"</cfif>>True</option>
          <option value="False" <cfif Status eq 'False'>selected="selected"</cfif>>False</option>
        </select>
        <div class="clear"></div>
        <div style="padding-left:150px;">
			<input  type="submit" name="submit" class="bttn" value="Save Class" style="width:112px;" />
			<input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" />
		</div>
        <div class="clear"></div>  		
   </fieldset>
	</div>
    </cfform>
   <div class="clear"></div>
 </div>
<!--- <cfif isDefined("url.classid") and len(url.classid) gt 1>
<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qClasses")>&nbsp;&nbsp;&nbsp; #request.qClasses.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qClasses.LastModifiedBy#</cfif></p>
</cfif> --->
<div class="white-bot"></div>
</div>
		   
</cfoutput>


