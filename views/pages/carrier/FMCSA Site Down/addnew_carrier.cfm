<cfoutput>
<cfajaxproxy cfc="#request.cfcpath#.loadgateway" jsclassname="ajaxLoadCutomer">
<!---Init the default value------->	  
<cfsilent>
 <cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
 <cfset requireValidMCNumber = request.qGetSystemSetupOptions.requireValidMCNumber>
						
 <cfparam name="MCNumber" default=""> 
 <cfparam name="carrierid" default="">  
</cfsilent>

<cfif isDefined("url.carrierid") and len(url.carrierid)>
<div class="search-panel"><div class="delbutton"><a href="index.cfm?event=carrier&carrierid=#editid#&#session.URLToken#" onclick="return confirm('Are you sure to delete it ?','Delete Carrier');">  Delete</a></div></div>	
<h1>Edit Carrier <span style="padding-left:180px;">#Ucase(CarrierName)#</span></h1>
<cfelse>
 <cfset session.checkUnload ='add'>
<h1>Enter New Carrier</h1>
</cfif>
 <cfif isDefined("SaveContinue")>
 	<cfset messageHead='Please enter either MC## or DOT## to add new Carrier. If you dont have that use their phone## instead.'>
	<cfif isDefined("MCNumber") and len(MCNumber) gt 0>
         <cfinvoke component="#request.cfcpath#.loadgateway" method="checkcarrierMCNumber" returnvariable="request.qcarrier"> 
         <cfinvokeargument name="McNumber" value="#McNumber#">
         <cfinvokeargument name="dsn" value="#application.dsn#">
         </cfinvoke>
         <cfif  request.qcarrier.recordcount gte 1>
            <cfset carierid=request.qcarrier.CarrierID>
            <cfset message='<a href="index.cfm?event=addcarrier&carrierid=#request.qCarrier.CarrierID#&#session.URLToken#" style="text-decoration:font:bold;padding-left:96px;"> MC##  #McNumber# </a>'  &"already existed">
         <cfelse>
	        <cflocation url="index.cfm?event=addcarrier&mcno=#McNumber#&#session.urltoken#">         
         </cfif>  
	<cfelseif structKeyExists(form, "DOTNumber") and len(DOTNumber) gt 0>
         <cfinvoke component="#request.cfcpath#.loadgateway" method="checkcarrierMCNumber" returnvariable="request.qcarrier"> 
         <cfinvokeargument name="DOTNumber" value="#form.DOTNumber#">
         <cfinvokeargument name="dsn" value="#application.dsn#">
         </cfinvoke>

		<cfif  request.qcarrier.recordcount gte 1>
            <cfset carierid=request.qcarrier.CarrierID>
            <cfset message='<a href="index.cfm?event=addcarrier&carrierid=#request.qCarrier.CarrierID#&#session.URLToken#" style="text-decoration:font:bold;padding-left:96px;"> DotNumber##  #form.DOTNumber# </a>'  &"already existed">
         <cfelse>
	        <cflocation url="index.cfm?event=addcarrier&DOTNumber=#DOTNumber#&#session.urltoken#">         
         </cfif> 
    <cfelseif not structKeyExists(form, "DOTNumber") and not len(DOTNumber) gt 0> 
     	 <cflocation url="index.cfm?event=addcarrier&DOTNumber=&#session.urltoken#">  
    <cfelseif not structKeyExists(form, "MCNumber") and not len(MCNumber) gt 0>      
		 <cflocation url="index.cfm?event=addcarrier&mcno=&#session.urltoken#">              
    </cfif> 
</cfif>
<cfif not (isdefined("message") and len(message))>
	<cfif isdefined("messageHead") and len(messageHead)>
	<div class="msg-area" style="margin-left: 13px;">#messageHead#</div>
	</cfif>
</cfif>

<div class="white-con-area">
		<div class="white-top"></div>
		<div class="white-mid-carrier">
		 <cfform name="frmNewCarrier" action="index.cfm?event=addnewcarrier:process&#session.urltoken#" method="post">
				<div class="form-con">
				 <fieldset>
				   <cfinput type="hidden" name="carrierid" id="carrierid" value="#carrierid#">
			       <cfif isdefined("message") and len(message)>
			         <div class="msg-carr">
			           
			           <div class="form-con">  
				           <ul class="load-link">                                                           
				       			<li><font size="3">#message#</font></li>
	                       </ul> 
                       </div>                        
			         </div>
			       </cfif>
					    <div class="clear"></div>
					   <label class="DOTNumber" style="padding-left: 39px;"><span style="color:##448bc8;"><i>Please enter...</i></span>DOT ##</label>
                      	<cfinput name="DOTNumber" id="DOTNumber" type="text" value="" />
                      		
				        <label><span style="color:##448bc8;"><i>...OR...</i></span><span style="margin-left: 34px;"> MC ##</span></label>
						<cfif requireValidMCNumber EQ True>
                    	  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#"  /> 				
                    	<cfelse>
						  <cfinput name="MCNumber" id="MCNumber" type="text" tabindex="1"  value="#MCNumber#"  />
						</cfif>
						
						<div class="clear"></div>
                        <cfinput name="SaveContinue" id="continue-btn" type="submit" class="normal-bttn" value="Continue>>"  onfocus="checkUnload();" style="margin-left: 533px; margin-top: -29px;"/>                    		 
                  </fieldset>
				  </div>						
			<div class="clear"></div>					
		</cfform>
		<div class="clear"></div>
		</div>					
		<div class="white-bot"></div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$('##continue-btn').click(function(){
			var MCnum = $('##MCNumber').val();
			var DOTnum = $('##DOTNumber').val();
			// if (DOTnum == "") {
			// 	alert('Please enter in a DOT## before trying to update the carriers information.');
			// 	return false;
			// }
			/*if (MCnum == "" && DOTnum == "")
		      {
		        alert('Please enter in a DOT## or mc Number before trying to update the carriers information. If you dont have that use their phone## instead.');
		        return false
		      }*/
			
		});
	});
</script>
</cfoutput>	
