<cfoutput>
   <cfif thisTag.ExecutionMode is 'start'>
    <cfif isDefined("attributes.officeloc")>
        <cfsilent>       
        <cfquery name="qrygetoffices" datasource="#application.dsn#">
            select * from Offices where isActive = 'True'
            ORDER BY Location
        </cfquery> 
        
        </cfsilent>   
	    <select name="OfficeID1" <cfif isDefined("attributes.tabindex")> tabindex="#attributes.tabindex#" </cfif>>
	    <cfloop query="qrygetoffices">
	        <option value="#qrygetoffices.officeid#" <cfif attributes.officeloc eq qrygetoffices.officeid> selected="selected" </cfif> >#qrygetoffices.location#</option>
	    </cfloop>
	    </select>           
  </cfif> 
  
  <!---<cfif isDefined("attributes.addressloc")>
      <cfquery name="qrygetaddresses" datasource="#application.dsn#">
                      select * from Addresses                 
              		<cfif isdefined('arguments.AddressID') and len(arguments.AddressID)>
              			where AddressID  = '#arguments.AddressID#'
              		</cfif>	
     </cfquery>
     <select name="AddressID1">
       <cfloop query="qrygetaddresses">
        <option value="#qrygetaddresses.addressid#" <cfif attributes.addressloc eq qrygetaddresses.addressid> selected="selected" </cfif>>#qrygetaddresses.Location#</option>
       </cfloop>
     </select> 
  </cfif>--->
  <cfif isDefined("attributes.contact")>
      <cfquery name="qrygetcontacts" datasource="#application.dsn#">
         select * from Contacts                
          <cfif isdefined('arguments.ContactID') and len(arguments.ContactID)>
             where ContactID  = '#arguments.ContactID#'
          </cfif>	
     </cfquery>
      <select name="ContactID1">
             <cfloop query="qrygetcontacts">
              <option value="#qrygetcontacts.ContactID#"  <cfif attributes.contact eq qrygetcontacts.ContactID> selected="selected"</cfif>>#qrygetcontacts.PhoneNo#</option>
             </cfloop>
      </select> 
  </cfif>
  <cfif isDefined("attributes.company")>
      <cfquery name="qrygetcompanies" datasource="#application.dsn#">
         select * from Companies                
          <cfif isdefined('arguments.CompanyID') and len(arguments.CompanyID)>
            where CompanyID  = '#arguments.CompanyID#'
          </cfif>
          ORDER BY CompanyName
     </cfquery>
      <select name="CompanyID1" <cfif isDefined("attributes.tabindex")> tabindex="#attributes.tabindex#" </cfif> >
         <cfloop query="qrygetcompanies">
          <option value="#qrygetcompanies.CompanyID#" <cfif attributes.company eq qrygetcompanies.CompanyID>selected="selected" </cfif>>#qrygetcompanies.CompanyName#</option>
         </cfloop>
      </select>  
  </cfif>
  <cfif isDefined("attributes.role")>
      <cfquery name="qrygetRole" datasource="#application.dsn#">
           select * from roles where 1=1
      		<cfif isdefined('arguments.roleID') and len(arguments.roleID)>
      			and roleID  = '#arguments.roleID#'
      		</cfif>	
       </cfquery>
      <select name="FA_roleid">
      <cfloop query="qrygetRole">
       <option value="#qrygetRole.roleid#" <cfif attributes.role eq qrygetRole.roleid> selected="selected" </cfif> >#qrygetRole.roleValue#</option>	
      </cfloop>
      </select>
  </cfif>
  <cfif isDefined("attributes.dispatcher")>
      <cfquery name="qrygetDispatcher" datasource="#application.dsn#">
             select * from carriers where status = 1 
       </cfquery> 
      <select name="FA_dispatcherid">
       <cfloop query="qrygetDispatcher">
       <option value="#qrygetDispatcher.carrierId#" <cfif attributes.dispatcher eq qrygetDispatcher.carrierId> selected="selected"</cfif>>#qrygetDispatcher.carrierName#</option>
      	</cfloop>
      </select> 
  </cfif>
 
  </cfif>  
</cfoutput>