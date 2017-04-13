<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="url.carrierfilter" default="false">
<cfparam name="url.equipment" default="">

<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qSystemSetupOptions" />
<cfinvoke component="#variables.objequipmentGateway#" method="getAllEquipments" returnvariable="request.qEquipments" />
<cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qStates" />

<cfparam name="sortby"  default="">
<cfsilent>

<cfif request.qSystemSetupOptions.freightBroker>
	<cfset variables.freightBroker = "carrier">
<cfelse>
	<cfset variables.freightBroker = "driver">
</cfif>

<!--- Getting page1 of All Results --->
<cfinvoke component="#variables.objCarrierGateway#" method="getSearchedCarrier" searchText="" pageNo="1" returnvariable="qCarrier" />


<cfif isdefined("form.searchText")>
   	<cfinvoke component="#variables.objCarrierGateway#" method="getSearchedCarrier" searchText="#form.searchText#" pageNo="#form.pageNo#" sortorder="#form.sortOrder#" sortby="#form.sortBy#" returnvariable="qCarrier" />
	<cfif qCarrier.recordcount lte 0>
		<cfset message="No match found">
	</cfif>
    


<cfelseif isdefined("form.form_submitted") and isdefined("url.carrierfilter") and #url.carrierfilter# eq "true" >
	<cfif isdefined("form.pageNo")>
    	<cfset pages = #form.pageNo#>
    <cfelse>
    	<cfset pages = 1>
    </cfif>
    
    <cfif isdefined("form.insExp")>	
		<cfset insEXP = #form.insExp#>
    <cfelse>
		<cfset insEXP = 0>
	</cfif>
    
    <cfif not isdefined('form.consigneecity')>
		<cfset form.consigneecity = "">
	</cfif>

    <cfif not isdefined('form.equipment')>
		<cfset form.equipment = "">
	</cfif>
    
    <cfif not isdefined('form.consigneestate')>
		<cfset form.consigneestate = "">
	</cfif>
    
    <cfif not isdefined('form.consigneeZipcode')>
		<cfset form.consigneeZipcode = "">
	</cfif>
    
    <cfif not isdefined('form.shippercity')>
		<cfset form.shippercity = "">
	</cfif>
    
	<cfif not isdefined('form.shipperstate')>
		<cfset form.shipperstate = "">
	</cfif>
    
	<cfif not isdefined('form.shipperZipcode')>
		<cfset form.shipperZipcode = "">
	</cfif>

    
    
   	
    <cfinvoke component="#variables.objCarrierGateway#" method="getFilteredCarrier" pageNo="#pages#" sortorder="ASC" sortby="CarrierName" 
    insexp="#insEXP#" shippercity="#form.shippercity#" shipperstate="#form.shipperstate#" shipperZipcode="#form.shipperZipcode#" consigneecity="#form.consigneecity#" consigneestate="#form.consigneestate#" consigneeZipcode="#form.consigneeZipcode#"   returnvariable="qCarrier" />
    <cfif qCarrier.recordcount lte 0>
		<cfset message="No More Record found">
	</cfif>
    
    
    
<cfelseif isdefined("url.carrierfilter") and #url.carrierfilter# eq "true">
	
	<cfif isdefined("form.pageNo")>
    	<cfset pages = #form.pageNo#>
    <cfelse>
    	<cfset pages = 1>
    </cfif>
    
    <cfif isdefined("form.insExp")>	
		<cfset insEXP = #form.insExp#>
    <cfelse>
		<cfset insEXP = 0>
	</cfif>
   	<cfif not isdefined('url.consigneecity')>
		<cfset url.consigneecity = "">
	</cfif>

    <cfif not isdefined('url.consigneestate')>
		<cfset url.consigneestate = "">
	</cfif>
    
    <cfif not isdefined('url.consigneeZipcode')>
		<cfset url.consigneeZipcode = "">
	</cfif>
    
    <cfif not isdefined('url.shippercity')>
		<cfset url.shippercity = "">
	</cfif>
    
	<cfif not isdefined('url.shipperstate')>
		<cfset url.shipperstate = "">
	</cfif>
    
	<cfif not isdefined('url.shipperZipcode')>
		<cfset url.shipperZipcode = "">
	</cfif>

    <cfinvoke component="#variables.objCarrierGateway#" method="getFilteredCarrier" pageNo="#pages#" sortorder="ASC" sortby="CarrierName" 
    insexp="#insEXP#" shippercity="#url.shippercity#" shipperstate="#url.shipperstate#" shipperZipcode="#url.shipperZipcode#" consigneecity="#url.consigneecity#" consigneestate="#url.consigneestate#" consigneeZipcode="#url.consigneeZipcode#" returnvariable="qCarrier" />
    <cfif qCarrier.recordcount lte 0>
		<cfset message="No More Record found">
	</cfif>



<cfelse>
	<cfif isdefined("url.carrierid") and len(url.carrierid) gt 1>	
		<cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" returnvariable="request.qCarrier">
			<cfinvokeargument name="carrierid" value="#url.carrierid#">
		</cfinvoke>
		<cfinvoke component="#variables.objCarrierGateway#" method="deleteCarriers" CarrierID="#url.carrierid#" returnvariable="message1" />
		<cfif message1 eq 1>
			<cfinvoke component="#variables.objCarrierGateway#" method="deleteCarriersoffices" CarrierID="#url.carrierid#" returnvariable="message" />
			<cfinvoke component="#variables.objCarrierGateway#" method="deleteCarrierLipublicfmcsa" CarrierID="#url.carrierid#" returnvariable="message" />
			<cfif request.qSystemSetupOptions.FreightBroker EQ 1 AND request.qSystemSetupOptions.SaferWatch  EQ 1 >				
				<cfinvoke component="#variables.objCarrierGateway#" method="RemoveWatch" returnvariable="message">
						<cfinvokeargument name="DOTNumber" value="#request.qCarrier.DOTNumber#">
						<cfinvokeargument name="MCNumber" value="MC#request.qCarrier.MCNumber#">
					</cfinvoke>
			</cfif>
		<cfelse>
			<cfset message="Deletion is not allowed because data is active in other records.">
		</cfif>      		
		<cfinvoke component="#variables.objCarrierGateway#" method="getSearchedCarrier" searchText="" pageNo="1" returnvariable="qCarrier" />
	</cfif>
</cfif>
</cfsilent>

<cfoutput>
<!---<cfset insExp="#request.qSystemSetupOptions.showExpiredInsuranceCarriers#">--->
<cfif isdefined("message") and len(message)>
 <div id="message" class="msg-area">#message#</div>
<!--- <cfif message eq "Deletion is not allowed because data is active in other records.">
<script>alert('Deletion is not allowed because data is active in other records.');</script><!--- </div> --->
<cfelse>
<div class="msg-area">#message#</div>
</cfif> --->
</cfif>
 <!---<cfif isDefined("url.sortorder") and url.sortorder eq 'desc'>
           <cfset sortorder="asc">
  <cfelse>
           <cfset sortorder="desc">
 </cfif>
 <cfif isDefined("url.sortby")>
           <cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" sortorder="#sortorder#" sortby="#sortby#"  returnvariable="qCarrier" />
 </cfif> --->

<div class="search-panel">
<div class="form-search form-search-big">
<cfif StructKeyExists(session,"currentusertype") and session.currentusertype neq "Sales Representative">
	<!---<div class="addbutton"><a href="index.cfm?event=addnewcarrier&#session.URLToken#">Add New</a></div>--->
	<cfif variables.freightBroker EQ 'carrier'>
		<div class="addbutton"><a href="index.cfm?event=addnewcarrier&#session.URLToken#">Add New</a></div>
	<cfelse>
		<div class="addbutton"><a href="index.cfm?event=add#variables.freightBroker#&#session.URLToken#">Add New</a></div>
	</cfif>
</cfif>
<div class="clear"></div>
<cfif isdefined("url.carrierfilter") and #url.carrierfilter# eq "true" >
	<cfset form_action ="index.cfm?event=carrier&#session.URLToken#&carrierfilter=true&equipment=#url.equipment#&consigneecity=#url.consigneecity#&consigneestate=#url.consigneestate#&consigneeZipcode=#url.consigneeZipcode#&shippercity=#url.shippercity#&shipperstate=#url.shipperstate#&shipperZipcode=#url.shipperZipcode#">
<cfelse>
	<cfset form_action = "index.cfm?event=carrier&#session.URLToken#">
</cfif>

<cfform id="dispCarrierForm" name="dispCarrierForm" action="#form_action#" method="post" preserveData="yes">
    <cfinput id="pageNo" name="pageNo" value="1" type="hidden">
    
    <cfinput id="sortOrder" name="sortOrder" value="ASC" type="hidden">
    <cfinput id="sortBy" name="sortBy" value="CarrierName" type="hidden">
    
	<div style="float:left;width:346px;">
    <h1>
		<cfif request.qSystemSetupOptions.freightBroker>
			Select Carriers
		<cfelse>
			Driver List
		</cfif>		
	</h1>
	<fieldset>
        <cfinput name="searchText" type="text" message="Please enter search text"  />
        <input name="" onclick="javascript: document.getElementById('pageNo').value=1;" type="submit" class="s-bttn" value="Search" style="width:56px;" />
        <div class="clear"></div>
	</fieldset>
    </div>
    <cfif url.carrierfilter eq true>
	<div style="float:left;width:450px;">
    	<fieldset class="career_filter">
        	<legend>FILTER CARRIER</legend>
            <span class="carrier_type">
                <span><p>&nbsp;All </p><input type="radio" name="Carrier_Type" id="Carrier_Type1" value="1" 
                <cfif isdefined("form.Carrier_Type") and #form.Carrier_Type# eq "1"> checked="checked"</cfif>&nbsp; />
                </span>
                <span><p>LTL :</p><input type="radio" name="Carrier_Type" id="Carrier_Type1" value="2" 
                <cfif isdefined("form.Carrier_Type") and #form.Carrier_Type# eq "2"> checked="checked"</cfif> />
                </span>
            </span>
            <span class="int">
            	<p>Ins EXP:</p> <input name="insExp" type="checkbox"  <cfif isdefined("form.insExp")> checked="checked" </cfif> value="1" />
            </span>
            <span class="equipment">
            	  <p>Equipment:</p>
                  <select name="equipment">
                    <option value="">Select</option>
                    <cfloop query="request.qEquipments">
                      <!---<option value="#request.qEquipments.equipmentID#" <cfif url.equipment eq request.qEquipments.equipmentID> selected="selected" </cfif> >#request.qEquipments.equipmentname#</option>--->
                      <option value="#request.qEquipments.equipmentname#" <cfif isdefined("form.equipment") ><cfif #form.equipment# eq request.qEquipments.equipmentname >selected="selected"</cfif> 
					  <cfelseif url.equipment eq request.qEquipments.equipmentID> selected="selected" </cfif>>#request.qEquipments.equipmentname#</option>
                    </cfloop>
                  </select>
            </span>
            <div class="clear"></div>
            
            <div class="carrier_bottom_area">
            	<div class="carrier_bottom_area_left">
                	<fieldset class="career_subfilter">
                       
	        			<legend>ORIGIN</legend>
                        <div class="career_subfilter_area">
                        <span class="equipment highpadd">
                            <label>City</label>
                            <input type="text" name="shippercity" id="shippercity" value=<cfif isdefined('form.shippercity') >"#form.shippercity#"
							<cfelseif isdefined('url.shippercity')> "#url.shippercity#" </cfif>  />
                        </span>
                        <div class="clear"></div>
                        <span class="equipment">
                            <label>State</label>
                            <select name="shipperstate" id="shipperstate" onChange="" >
                              <option value="">Select</option>
                              <cfloop query="request.qStates">
                                <option value="#request.qStates.statecode#" 
								<cfif isdefined("form.shipperstate") ><cfif #form.shipperstate# eq request.qStates.statecode >selected="selected"</cfif> <cfelseif url.shipperstate eq request.qStates.statecode> selected="selected" </cfif>>#request.qStates.statecode#</option>
                              </cfloop>
                            </select>
                            
                            <label class="zip">Zip</label>
                            <input name="shipperZipcode" id="shipperZipcode" value=<cfif isdefined('form.shipperZipcode') >"#form.shipperZipcode#"
							<cfelseif isdefined('url.shipperZipcode')> "#url.shipperZipcode#" </cfif> type="text" class="zip" />
                            
                        </span>
                        <div class="clear"></div>
                        <!---<span class="equipment">
                            <label>Zip</label>
                            <input name="shipperZipcode" id="shipperZipcode" value=<cfif isdefined('form.shipperZipcode') >"#form.shipperZipcode#"
							<cfelseif isdefined('url.shipperZipcode')> "#url.shipperZipcode#" </cfif> type="text" />
                        </span>--->
                        </div>
                    </fieldset>
                </div>
            	<div class="carrier_bottom_area_right">
                	<fieldset class="career_subfilter">
	        			<legend>DESTINATION</legend>
                        <span class="equipment highpadd">
                            <label>City</label>
                            <input type="text" name="consigneecity" id="consigneecity"  value=<cfif isdefined('form.consigneecity') >"#form.consigneecity#"
							<cfelseif isdefined('url.consigneecity')> "#url.consigneecity#" </cfif>/>
                        </span>
                        <div class="clear"></div>
                        <span class="equipment">
                         <label>State</label>
                         <select name="consigneestate" id="consigneestate" >
                            <option value="">Select</option>
                            <cfloop query="request.qStates">
                              <option value="#request.qStates.statecode#" <cfif isdefined("form.consigneestate") ><cfif #form.consigneestate# eq request.qStates.statecode >selected="selected"</cfif> <cfelseif url.consigneestate eq request.qStates.statecode> selected="selected" </cfif>>#request.qStates.statecode#</option>
                            </cfloop>
                         </select>
                         <label class="zip">Zip</label>
                         <input name="consigneeZipcode" id="consigneeZipcode" value=<cfif isdefined('form.consigneeZipcode') >"#form.consigneeZipcode#"
                         <cfelseif isdefined('url.consigneeZipcode')> "#url.consigneeZipcode#" </cfif> type="text" class="zip" />
                        </span>
                        <div class="clear"></div>
                        <!---<span class="equipment">
                            <label>Zip</label>
                            <input name="consigneeZipcode" id="consigneeZipcode" value=<cfif isdefined('form.consigneeZipcode') >"#form.consigneeZipcode#"
							<cfelseif isdefined('url.consigneeZipcode')> "#url.consigneeZipcode#" </cfif> type="text" />
                        </span>--->
                    </fieldset>
                </div>
            </div>
            <div class="clear"></div>
            <div class="clear">&nbsp;</div>
            <div style="text-align:center;">
                <input type="hidden" name="form_submitted" value="form_submitted"  />
                <button class="button" type="button" name="submit_form" value="submit_form" onclick="this.form.submit();" >Submit</button>
                <button class="button" type="button" name="submit_form" value="submit_form" onclick="window.location='index.cfm?event=carrier&#session.URLToken#&carrierfilter=true' " >Reset</button>
            </div>
        </fieldset>
    <div class="clear">&nbsp;</div>
    </div>
    </cfif>
</cfform>


</div>
	<!---<div class="addbutton"><a href="index.cfm?event=addnewcarrier&#session.URLToken#">Add New</a></div>--->
</div>   
		<style type="text/css">
			span.carrierTextarea{ 
				white-space: pre-wrap;      
				white-space: -moz-pre-wrap; 
				white-space: -pre-wrap;     
				white-space: -o-pre-wrap;   
				word-wrap: break-word;
			}
		</style>
	   <table width="100%" border="0" class="data-table" cellspacing="0" cellpadding="0">
          <thead>
          <tr>
        	<th width="5" align="left" valign="top" ><img src="images/top-left.gif" alt="" width="5" /></th>			
        	<th width="24" align="center" valign="middle" class="head-bg">&nbsp;</th>			
        	<th width="100" align="center" valign="middle" class="head-bg" onclick="sortTableBy('CarrierName','dispCarrierForm');" >Name</th>
        	<th width="120" align="center" valign="middle" class="head-bg" onclick="sortTableBy('MCNumber','dispCarrierForm');">
				<cfif request.qSystemSetupOptions.freightBroker>
					MCNumber
				<cfelse>
					Driver Lic ##
				</cfif>
			</th>
            <cfif request.qSystemSetupOptions.freightBroker>
                <th width="120" align="center" valign="middle" class="head-bg" onclick="sortTableBy('DotNumber','dispCarrierForm');">
                        DotNumber
                </th>
            </cfif>
        	<th width="120" align="center" valign="middle" class="head-bg" onclick="sortTableBy('city','dispCarrierForm');">City</th>
			<th width="50" align="center" valign="middle" class="head-bg" onclick="sortTableBy('StateCode','dispCarrierForm');">State</th>
        	<th width="109" align="center" valign="middle" class="head-bg" onclick="sortTableBy('phone','dispCarrierForm');">Phone</th>
        	<th width="109" align="center" valign="middle" class="head-bg" onclick="sortTableBy('email','dispCarrierForm');">Email</th>
			<th width="150" align="center" valign="middle" class="head-bg" onclick="sortTableBy('insExpDate','dispCarrierForm');" nowrap="nowrap">Insurance Expiration</th>
            <th width="109" align="center" valign="middle" class="head-bg2" onclick="sortTableBy('status','dispCarrierForm');">Status</th>
        	<!--- <th width="129" align="center" valign="middle" class="head-bg2">Action</th> --->
        	<th width="5" align="right" valign="top"><img src="images/top-right.gif" alt="" width="5" height="23" /></th>
          </tr>
          </thead>
          <tbody>
        	<cfloop query="qCarrier">
				<cfset pageSize = 30>
				<cfif isdefined("form.pageNo")>
					<cfset rowNum=(qCarrier.currentRow) + ((form.pageNo-1)*pageSize)>
				<cfelse>
					<cfset rowNum=(qCarrier.currentRow)>
				</cfif>
				<tr <cfif qCarrier.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
					<cfset tdOnClickString ="document.location.href='index.cfm?event=add#variables.freightBroker#&carrierid=#qCarrier.CarrierID#&#session.URLToken#'">
					<cfset tdTitleString ="#qCarrier.CarrierName# #qCarrier.MCNumber# #qCarrier.city# #qCarrier.Phone# #qCarrier.EmailID#">
					<cfset tdHrefClickString ="index.cfm?event=add#variables.freightBroker#&carrierid=#qCarrier.CarrierID#&#session.URLToken#">					
					<td height="20" class="sky-bg">&nbsp;</td>					
					<td class="sky-bg2" valign="middle" onclick="#tdOnClickString#" align="center">#rowNum#</td>					
					<td align="left" valign="middle" nowrap="nowrap" class="normal-td" >
						<cfif request.qSystemSetupOptions.FreightBroker AND request.qSystemSetupOptions.SaferWatch>						
							<cfif qCarrier.MCNumber NEQ "">
								<cfset number = "MC"&qCarrier.MCNumber >
							<cfelseif  qCarrier.DOTNumber NEQ "" >
								<cfset number = qCarrier.DOTNumber>
							<cfelse>
								<cfset number = 0 >
							</cfif>
							<cfset risk_assessment = 	qCarrier.RiskAssessment>					
								<a href="http://www.saferwatch.com/swCarrierDetailsLink.php?&number=#number#" target="_blank">
									<cfif risk_assessment EQ "Unacceptable">
										&nbsp;<img style="vertical-align:bottom;" src="images/SW-Red.png" height="16px"  width="25px">
									<cfelseif risk_assessment EQ "Moderate">
										&nbsp;<img style="vertical-align:bottom;" src="images/SW-Yellow.png" height="16px"  width="25px">
									<cfelseif risk_assessment EQ "Acceptable">
										&nbsp;<img style="vertical-align:bottom;" src="images/SW-Green.png" height="16px"  width="25px">
									<cfelse>   
										&nbsp;<img style="vertical-align:bottom;" src="images/SW-Blank.png" height="16px"  width="25px">
									</cfif>
								</a>							
						</cfif>
						<a title="#tdTitleString#" href="#tdHrefClickString#" onclick="#tdOnClickString#">#qCarrier.CarrierName#</a>
					</td>
					<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
						<a title="#tdTitleString#" href="#tdHrefClickString#">#qCarrier.MCNumber#</a>
					</td>
                    <cfif request.qSystemSetupOptions.freightBroker>
                        <td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
                            <a title="#tdTitleString#" href="#tdHrefClickString#">#qCarrier.DotNumber#</a>
                        </td>
                    </cfif>
					<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
						<a title="#tdTitleString#" href="#tdHrefClickString#">#qCarrier.city#</a>
					</td>

					<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
						<a title="#tdTitleString#" href="#tdHrefClickString#">#qCarrier.stateCode#</a>
					</td>

					<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
						<a title="#tdTitleString#" href="#tdHrefClickString#">#qCarrier.Phone#</a>
					</td>

					<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
						<a title="#tdTitleString#" href="mailto:#qCarrier.EmailID#">#qCarrier.EmailID#</a>
					</td>

					<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
						<a title="#tdTitleString#" href="mailto:#qCarrier.EmailID#">#DateFormat(qCarrier.insExpDate,'MM/DD/YY')#</a>
					</td>

					<td  align="center" valign="middle" nowrap="nowrap" class="normal-td2" onclick="#tdOnClickString#">
						<a href="#tdHrefClickString#"><cfif qCarrier.Status eq 0 >InActive<cfelse>Active</cfif></a>
					</td>
					
					<td class="normal-td3">&nbsp;</td>
	        	</tr>
				<tr <cfif qCarrier.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
					<td height="20" class="sky-bg">&nbsp;</td>
					<td class="sky-bg2" valign="middle" onclick="#tdOnClickString#" align="center">&nbsp;</td>
					<td colspan="<cfif request.qSystemSetupOptions.freightBroker>10<cfelse>9</cfif>" align="left" valign="middle" nowrap="nowrap" class="normal-td" style="height:10px;">
						<span class="carrierTextarea" style="display: block;max-height: 35px;overflow: hidden;">#qCarrier.notes#</span>
					</td>
				</tr>
        	 </cfloop>
        	 </tbody>
        	 <tfoot>
        	 <tr>
        		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
        		<td colspan="<cfif request.qSystemSetupOptions.freightBroker>10<cfelse>9</cfif>" align="left" valign="middle" class="footer-bg">
        			<div class="up-down">
        				<div class="arrow-top"><a href="javascript: tablePrevPage('dispCarrierForm');"><img src="images/arrow-top.gif" alt="" /></a></div>
        				<div class="arrow-bot"><a href="javascript: tableNextPage('dispCarrierForm');"><img src="images/arrow-bot.gif" alt="" /></a></div>
        			</div>
        			<div class="gen-left"><a href="javascript: tablePrevPage('dispCarrierForm');">Prev </a>-<a href="javascript: tableNextPage('dispCarrierForm');"> Next</a></div>
        			<div class="gen-right"><img src="images/loader.gif" alt="" /></div>
        			<div class="clear"></div>
        		</td>
        		<td width="5" align="right" valign="top"><img src="images/right-bot.gif" alt="" width="5" height="23" /></td>
        	 </tr>	
        	 </tfoot>	  
        </table>
        </cfoutput>
        
