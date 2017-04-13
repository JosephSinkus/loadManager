<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">

<cfsilent>
<!--- Getting page1 of All Results --->
<cfinvoke component="#variables.objCarrierGateway#" method="getSearchedCarrier" searchText="" pageNo="1" returnvariable="qCarrier" />

<cfif isdefined("form.searchText") >
   	<cfinvoke component="#variables.objCarrierGateway#" method="getSearchedCarrier" searchText="#form.searchText#" pageNo="#form.pageNo#" sortorder="#form.sortOrder#" sortby="#form.sortBy#" returnvariable="qCarrier" />
    
	<cfif qCarrier.recordcount lte 0>
		<cfset message="No match found">
	</cfif>
<cfelse>
	<cfif isdefined("url.carrierid") and len(url.carrierid) gt 1>	
		<cfinvoke component="#variables.objCarrierGateway#" method="deleteCarriers" CarrierID="#url.carrierid#" returnvariable="message1" />
		<cfif message1 eq 1>
		<cfinvoke component="#variables.objCarrierGateway#" method="deleteCarriersoffices" CarrierID="#url.carrierid#" returnvariable="message" />
		<cfelse>
		<cfset message="Deletion is not allowed because data is active in other records.">
		</cfif>       			
		<cfinvoke component="#variables.objCarrierGateway#" method="getSearchedCarrier" searchText="" pageNo="1" returnvariable="qCarrier" />
	</cfif>
</cfif>
</cfsilent>
<cfoutput>
<!---<h1>Select Carriers</h1>
<div style="clear:left"></div>
--->

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
<div class="form-search">
<cfform id="dispCarrierForm" name="dispCarrierForm" action="index.cfm?event=carrier&#session.URLToken#" method="post" preserveData="yes">
	<cfinput id="pageNo" name="pageNo" value="1" type="hidden">
    
    <cfinput id="sortOrder" name="sortOrder" value="ASC" type="hidden">
    <cfinput id="sortBy" name="sortBy" value="CarrierName" type="hidden">
    
    <div style="float:left;width:346px;">
    <h1>Select Carriers</h1>
	<fieldset>
        <cfinput name="searchText" type="text" required="yes" message="Please enter search text"  />
        <input name="" onclick="javascript: document.getElementById('pageNo').value=1;" type="submit" class="s-bttn" value="Search" style="width:56px;" />
        <div class="clear"></div>
	</fieldset>
    </div>
    
	<div style="float:left;width:400px;">
    	<fieldset class="career_filter">
        	<legend>FILTER CARRIER</legend>
            <span><p>&nbsp;All </p><input type="radio" name="Carrier_Type" id="Carrier_Type1" value="1"/>&nbsp;</span>
            <span><p>LTL :</p><input type="radio" name="Carrier_Type" id="Carrier_Type1" value="2" /></span>
            <span class="int"><p>Ins EXP:</p> <input type="checkbox" value=""  /></span>
            <span class="equipment">
            	<p>Equipment:</p>
                <select name="equipment">
                    <option>-Select-</option>
                </select>
            </span>
            <div class="clear"></div>
            
            <div class="carrier_bottom_area">
            	<div class="carrier_bottom_area_left">
                	<fieldset class="career_subfilter">
	        			<legend>ORIGIN</legend>
                        <span class="equipment">
                            <label>City</label>
                            <input type="text" name="city" id="city"  />
                        </span>
                        <div class="clear"></div>
                        <span class="equipment">
                            <label>State</label>
                            <select name="State">
                                <option>-Select-</option>
                            </select>
                        </span>
                        <div class="clear"></div>
                        <span class="equipment">
                            <label>Zip</label>
                            <select name="Zip<">
                                <option>-Select-</option>
                            </select>
                        </span>
                    </fieldset>
                </div>
            	<div class="carrier_bottom_area_right">
                	<fieldset class="career_subfilter">
	        			<legend>DESTINATION</legend>
                        <span class="equipment">
                            <label>City</label>
                            <input type="text" name="city" id="city"  />
                        </span>
                        <div class="clear"></div>
                        <span class="equipment">
                            <label>State</label>
                            <select name="State">
                                <option>-Select-</option>
                            </select>
                        </span>
                        <div class="clear"></div>
                        <span class="equipment">
                            <label>Zip</label>
                            <select name="Zip<">
                                <option>-Select-</option>
                            </select>
                        </span>
                    </fieldset>
                </div>
            </div>
            <div class="clear"></div>
        </fieldset>
    </div>
</cfform>

</div>
</div>     
	   <table width="100%" border="0" class="data-table" cellspacing="0" cellpadding="0">
          <thead>
          <tr>
        	<th width="5" align="left" valign="top" ><img src="images/top-left.gif" alt="" width="5" /></th>
        	<th width="29" align="center" valign="middle" class="head-bg">&nbsp;</th>
        	<th width="120" align="center" valign="middle" class="head-bg" onclick="sortTableBy('CarrierName','dispCarrierForm');" >Name22222222222</th>
        	<th width="120" align="center" valign="middle" class="head-bg" onclick="sortTableBy('MCNumber','dispCarrierForm');">MCNumber</th>
        	<th width="169" align="center" valign="middle" class="head-bg" onclick="sortTableBy('city','dispCarrierForm');">City</th>
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
            	 <!---<cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" returnvariable="request.qStates">
        	      <cfinvokeargument name="StateId1" value="#qCarrier.StateCode#">
        	     </cfinvoke>--->
                 
				 <cfset pageSize = 30>
				<cfif isdefined("form.pageNo")>
                    <cfset rowNum=(qCarrier.currentRow) + ((form.pageNo-1)*pageSize)>
                <cfelse>
                    <cfset rowNum=(qCarrier.currentRow)>
                </cfif>
            
			
			
	<tr <cfif qCarrier.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>bgcolor="##f7f7f7"</cfif>>
	
	<cfset tdOnClickString ="document.location.href='index.cfm?event=addcarrier&carrierid=#qCarrier.CarrierID#&#session.URLToken#'">
	<cfset tdTitleString ="#qCarrier.CarrierName# #qCarrier.MCNumber# #qCarrier.city# #qCarrier.Phone# #qCarrier.EmailID#">
	<cfset tdHrefClickString ="index.cfm?event=addcarrier&carrierid=#qCarrier.CarrierID#&#session.URLToken#">
	
	
		<td height="20" class="sky-bg">&nbsp;</td>
	    
		<td class="sky-bg2" valign="middle" onclick="#tdOnClickString#" align="center">#rowNum#</td>
		
       	<td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
			<a title="#tdTitleString#" href="#tdHrefClickString#">#qCarrier.CarrierName#</a>
		</td>
			  
	    <td align="left" valign="middle" nowrap="nowrap" class="normal-td" onclick="#tdOnClickString#">
			<a title="#tdTitleString#" href="#tdHrefClickString#">#qCarrier.MCNumber#</a>
		</td>
	
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
	
	
	        		<!--- <td class="normal-td2" valign="middle" align="Center"><a href="index.cfm?event=addcarrier&carrierid=#qCarrier.CarrierID#&#session.URLToken#"><img src="#request.imagesPath#edit.gif" title="Edit" /></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm?event=carrier&carrierid=#qCarrier.CarrierID#" onclick="return confirm('Are you sure to delete it ?');"><img src="#request.imagesPath#delete-icon.gif" title="Delete" /></a></td> --->
   <td class="normal-td3">&nbsp;</td>
	        	 </tr>
        	 </cfloop>
        	 </tbody>
        	 <tfoot>
        	 <tr>
        		<td width="5" align="left" valign="top"><img src="images/left-bot.gif" alt="" width="5" height="23" /></td>
        		<td colspan="7" align="left" valign="middle" class="footer-bg">
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
        
