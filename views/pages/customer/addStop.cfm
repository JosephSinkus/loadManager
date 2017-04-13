<cfoutput>
	<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer">
<cfsilent>
<cfparam name="editid" default="">	
<cfparam name="CustomerStopName" default="">
<cfparam name="location" default="">
<cfparam name="City" default="">
<cfparam name="StateID" default="">
<cfparam name="StateID1" default="">
<cfparam name="ZipCode" default="">
<cfparam name="ContactPerson" default="">
<cfparam name="Phone" default="">
<cfparam name="Fax" default="">
<cfparam name="EmailID" default="">
<cfparam name="CustomerID1" default="">
<cfparam name="NewInstructions" default="">
<cfparam name="NewDirections" default="">
<cfparam name="StopType" default="">

<cfimport taglib="../../../plugins/customtags/mytag/" prefix="myoffices" >	
<cfif isdefined("url.stopid") and len(trim(url.stopid)) gt 1>
	<cfinvoke component="#variables.objCutomerGateway#" method="getAllstop" CustomerStopID="#url.stopid#" returnvariable="request.qStop" />
	<cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" <!--- CustomerID="#request.qStop.customerID#" ---> returnvariable="request.qCustomer" />
<cfset CustomerStopName=#request.qStop.CustomerStopName#>
<cfset location=#request.qStop.location#>
<cfset City=#request.qStop.city#>
<cfset StateID1=#request.qStop.StateID#>
<cfset Zipcode=#request.qStop.PostalCode#>
<cfset ContactPerson=#request.qStop.ContactPerson#>
<cfset Phone=#request.qStop.Phone#>
<cfset Fax=#request.qStop.Fax#>
<cfset EmailID=#request.qStop.EmailID#>
<cfset CustomerID1=#request.qStop.CustomerID#>
<cfset NewInstructions=#request.qStop.NewInstructions#>
<cfset NewDirections=#request.qStop.NewDirections#>
<cfset StopType=request.qStop.StopType>
<cfset editid="#url.stopid#">
</cfif>
</cfsilent>
<cfif isdefined("url.customerId") and len(url.customerId) gt 1>	
	<cfset CustomerID1=url.customerId>
</cfif>
<cfif isdefined("url.stopid") and len(trim(url.stopid)) gt 1>
	<div class="search-panel"><div class="delbutton"><a href="index.cfm?event=stop&stopid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?');">  Delete</a></div></div>	
<h1>Edit Stop <span style="padding-left:180px;">#CustomerStopName#</span></h1>
<cfelse>
<cfset session.checkUnload ='add'>
<h1>Add New Stop</h1>
</cfif>
<div class="white-con-area">
<div class="white-top"></div>
<div class="white-mid">
<cfform name="frmStop" action="index.cfm?event=addstop:process&editid=#editid#&#session.URLToken#" method="post">
	<cfinput type="hidden" name="editid" value="#editid#">
<div class="form-con">
					
	<fieldset>
        <label>Stop Type</label>
        <select name="StopType">
        <option value="1" <cfif StopType is 1> selected="selected"</cfif>>Shipper</option>
        <option value="2" <cfif StopType is 2> selected="selected"</cfif>>Consignee</option>
        </select>
        <div class="clear"></div>
		<label>Stop Name*</label>
		<cfinput name="CustomerStopName" type="text" value="#CustomerStopName#" tabindex="3" required="yes" message="Please enter stop name">
		<div class="clear"></div>
		<label>Address*</label>
		<textarea name="location" tabindex="4" rows="" cols="">#location#</textarea>
		<div class="clear"></div>
		<label>City*</label>
		<cfinput name="City" id="City" type="text" value="#City#" required="yes" message="Please enter city">
		<div class="clear"></div>
		<label>State*</label>
		<select name="StateID" id="state">
            <option value="">Select</option>
			<cfloop query="request.qstates">
        		<option value="#request.qstates.stateID#" <cfif request.qstates.stateID is stateID1> selected="selected" </cfif> >#request.qstates.statecode#</option>	
			</cfloop>
		</select>
		<div class="clear"></div>
		<label>Zip*</label>
        <!--- <cfinclude template="getcitystate.cfm"> --->
	    <cfinput name="ZipCode" type="text" value="#ZipCode#" required="yes" message="Please enter zipcode"> 
		<div class="clear"></div>
		<!--- <label>Contact Person</label> --->
		<cfinput name="ContactPerson" type="hidden" tabindex="6" value="#ContactPerson#">
		<div class="clear"></div>
		<!--- <label>Phone</label> --->
		<cfinput name="Phone" type="hidden" tabindex="7" value="#Phone#" onchange="ParseUSNumber(this.value);" >
		<div class="clear"></div>
	</fieldset>
</div>
<div class="form-con">
	<fieldset>
		<!--- <label>Fax</label> --->
		<cfinput name="Fax" type="hidden" tabindex="8" value="#fax#" >
		<div class="clear"></div>
		<!--- <label>Email</label> --->
		<cfinput name="EmailID" type="hidden" tabindex="9" value="#EmailID#" validate="email">
		<div class="clear"></div>
		<label>Customer*</label>
		<select name="CustomerID" tabindex="10">
			<cfloop query="request.qCustomer">
        		<option value="#request.qCustomer.customerID#" <cfif request.qCustomer.customerID is CustomerID1> selected="selected" </cfif> >#request.qCustomer.customerName#</option>	
			</cfloop>
		</select>
		<div class="clear"></div>
		<label>Instructions</label>
		<textarea name="NewInstructions" tabindex="11" rows="" style="height: 61px;" cols="">#NewInstructions#</textarea>
		<div class="clear"></div>
		<label>Directions</label>
		<textarea name="NewDirections"  tabindex="12" rows="" style="height: 62px;" cols="">#NewDirections#</textarea>
		<div class="clear"></div>
		 <div style="padding-left:150px;"><input  type="submit" name="submit" class="bttn" onClick="return validateStop(frmStop);" value="Save Stop" onfocus="checkUnload();" style="width:112px;" /><input  type="button" onclick="javascript:history.back();" name="back" class="bttn" value="Back" style="width:70px;" /></div>
		<div class="clear"></div>
	</fieldset>
</div>
  <div class="clear"></div>
</cfform>
<cfif isDefined("url.stopid") and len(url.stopid) gt 1>
<p id="footer" style="padding-left:10px;font-family:Verdana, Geneva, sans-serif; font-style:italic bold; text-transform:uppercase;font-family:Verdana, Geneva, sans-serif; font-style:italic; text-transform:uppercase;width:80%;">Last Updated:<cfif isDefined("request.qStop")>&nbsp;&nbsp;&nbsp; #request.qStop.LastModifiedDateTime#&nbsp;&nbsp;&nbsp;#request.qStop.LastModifiedBy#</cfif></p>
</cfif>
</div>

<div class="white-bot"></div>
</div>
<br /><br /><br />
</cfoutput>


