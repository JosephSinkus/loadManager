<cfoutput>
<cfsilent>
<cfimport taglib="../../../plugins/customtags/mytag/" prefix="myoffices" >	
<!---Init Default Value------->
<cfparam name="EquipmentCode" default="">
<cfparam name="Length" default="1">
<cfparam name="PEPcode" default="0">
<cfparam name="EquipmentName" default="">
<cfparam name="Status" default="">
<cfparam name="url.editid" default="0">
<cfparam name="url.equipmentid" default="0">

<cfif isdefined("url.equipmentid") and len(trim(url.equipmentid)) gt 1>
<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" EquipmentID="#url.equipmentid#" returnvariable="request.qEquipments" />
<cfif request.qEquipments.recordcount eq 1>
<cfset EquipmentCode=#request.qEquipments.EquipmentCode#>
<cfset EquipmentName=#request.qEquipments.EquipmentName#>
<cfset PEPcode=#request.qEquipments.PEPcode#>
<cfset Length=#request.qEquipments.Length#>
<cfset Status=#request.qEquipments.IsActive#>
<cfset editid=#request.qEquipments.EquipmentID#>
</cfif>
</cfif>

</cfsilent> 
<cfif isdefined("url.equipmentid") and len(trim(url.equipmentid)) gt 1>
<div class="search-panel"><div class="delbutton">
<cfif PEPcode neq 1><a href="index.cfm?event=equipment&equipmentid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');"></cfif>
  Delete <cfif PEPcode neq 1></a></cfif></div></div>	
<h1>Edit Equipment <span style="padding-left:180px;">#Ucase(EquipmentName)#</span></h1>
<cfelse>
<h1>Add New Equipment</h1>
</cfif>
<div class="white-con-area">
<div class="white-top"></div>
<div class="white-mid">
<cfform name="frmEquipment" action="index.cfm?event=addequipment:process&editid=#editid#&#session.URLToken#" method="post">
	<cfinput type="hidden" name="editid" value="#editid#">
	<div class="form-con">
	<fieldset>       
	    <label><strong>Equipment Code*</strong></label>
		<cfif PEPcode neq 1>
	    <cfinput type="text" name="EquipmentCode"    value="#EquipmentCode#" size="25" required="yes" message="Please  enter the equipment code">
	    <div class="clear"></div>  
	    <label><strong>Name*</strong></label>
        <cfinput type="text" name="EquipmentName" value="#EquipmentName#" size="25" required="yes" message="Please  enter the equipment name">
		<cfelse>
		<cfinput type="text" name="EquipmentCode"    readonly  value="#EquipmentCode#" size="25" required="yes" message="Please  enter the equipment code">
	    <div class="clear"></div>  
	    <label><strong>Name*</strong></label>
        <cfinput type="text" name="EquipmentName"   readonly  value="#EquipmentName#" size="25" required="yes" message="Please  enter the equipment name">
		</cfif>
        <div class="clear"></div>
		 <label><strong>Length</strong></label>
        <cfinput type="text" name="Length" value="#Length#" size="4" maxlength="4"  style=" width:40px"    required="yes" message="Please  enter the Length">
        <div class="clear"></div>
		<label><strong>Post Everwhere</strong></label>
         <input name="PEPcode" ID="PEPcode" type="checkbox"  style="border:none; float:left;width: 20px " <cfif PEPcode eq 1> checked="checked" </cfif> value=""  />
        <div class="clear"></div>
    </fieldset>
    </div>
    <div class="form-con">
      <fieldset>
        <label><strong>Active*</strong></label>
        <select name="Status">
          <option value="1" <cfif Status eq '1'>selected="selected" </cfif>>Active</option>
          <option value="0" <cfif Status eq '0'>selected="selected" </cfif>>InActive</option>
        </select>
        <div class="clear"></div>
        <div style="padding-left:150px;"><input  type="submit" name="submit" onclick="return validateEquipment(frmEquipment);" class="bttn" value="Save Equipment" style="width:112px;"     /><input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" /></div>
        <div class="clear"></div>  		
   </fieldset>
	</div>
    </cfform>
   <div class="clear"></div>
<cfif isDefined("url.equipmentid") and len(url.equipmentid) gt 1>
<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qEquipments")>&nbsp;&nbsp;&nbsp; #request.qEquipments.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qEquipments.LastModifiedBy#</cfif></p>
</cfif> 
</div>

<div class="white-bot"></div>
</div>
</cfoutput>


