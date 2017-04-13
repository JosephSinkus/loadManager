 <cfif isDefined('FORM.feedback_buttn')>
 <cfset f_reqt = 0>
	<cfset imagesFolder = ExpandPath('images\logo')>
	<cfif form.Attachment NEQ ''>
		<cffile action="upload" fileField="Attachment" destination="#imagesFolder#" nameconflict="makeunique">
		<cfset serverFileName = '#cffile.SERVERFILE#'>
		   <cfset attachment_local_file_1 = "#imagesFolder#\#serverFileName#">
	<cfelse>
		<cfset serverFileName = ''>
	</cfif>
	<cfif isdefined('session.AdminUserName')><cfset user=session.AdminUserName><cfelse>
	<cfset user=''>
	</cfif>
    <cfif isdefined("FORM.f_req")>
	<cfif FORM.f_req eq 1>
		<cfset f_reqt = 1>
	<cfelse>
	<cfset f_reqt = 0>
	</cfif>

  </cfif>
  <cfquery name="FeedbackDetails" datasource="#Application.dsn#">
  select * from FeedbackDetails
  </cfquery>
   
  <cfquery name="qrySetfeedback" datasource="#Application.dsn#" result="qResult">
  INSERT INTO FeedbackDetails (u_publicIP,u_LocalIP,[User], Company_name, name, email , phone , attachment ,description,flag,url )
VALUES ('#CGI.REMOTE_ADDR#','#cgi.SERVER_NAME#','#user#','#form.comp_Name#','#form.f_Name#','#form.f_email#','#form.f_phone#',
'#serverFileName#',
'#form.f_description#',
#f_reqt#,'#CGI.HTTP_HOST#')
</cfquery>
  	<cfmail from="feedback@loadmanager.com" to="ScottW@WeberSystems.Com"  cc="em.j447@yahoo.com" subject="Feedback" type="html" >
	<cfsilent>
	 <cfif form.Attachment NEQ ''>
        <cfmailparam file="#attachment_local_file_1#">
     </cfif>
	</cfsilent>
	<cfoutput>
	If this is a feature request are you willing to pay to have it done right away? <cfif structkeyexists(form,"f_req") and form.f_req eq 1><b> Yes</b>
	 <cfelseif  structkeyexists(form,"f_req") and form.f_req eq 0><b>No</b><cfelse></cfif><br />
	<cfif len(form.f_Name) gt 2>Name :<b>#form.f_Name#</b><br></cfif>
	<cfif len(form.f_phone) gt 2>Phone :<b>#form.f_phone#</b><br></cfif>
	<cfif len(form.f_email) gt 2>Email address :<b>#form.f_email#</b><br></cfif>
	<cfif len(form.f_description) gt 2>description :<b> #form.f_description#</b><br></cfif>
	<cfif len(form.comp_Name) gt 2>Company Name : <b>#form.comp_Name#</b><br></cfif>
	</cfoutput>
	</cfmail>
	 
	<cflocation  url="index.cfm?event=myLoad&thnks=1">
</cfif>

<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" /> 
<cfinvoke component="#variables.objloadGateway#" method="getCompanyName" returnvariable="request.qCompanyName" /> 
<cfset loadStatus = request.qGetSystemSetupOptions.ARAndAPExportStatusID>
 
<cfoutput>
<h1 >We want your feedback</h1>
<div style="clear:left"></div>
 
<div class="white-con-area">
	<div class="white-top"></div>
	
    <div class="white-mid">
	<cfform name="frmLongShortMiles" enctype="multipart/form-data" method="post">
	<div class="form-con">
	<fieldset>
		<div class="clear"></div
			 ><label>If this is a feature request are you willing to pay to have it done right away?</label>
			  Yes  ?<input type="radio" style="width:10px" name="f_req" id="f_req" value="1">No  ?<input type="radio" name="f_req" id="f_req"  style="width:10px"  value="0">  
		 <div class="clear"></div>
		 <label>Description</label> 
		<cftextarea name="f_description" style="height:200px;width:400px" ></cftextarea>
		<div class="clear"></div>
	
        <label>Name</label>
		<input type="hidden" name="comp_Name" id="comp_Name" value="#request.qCompanyName.COMPANYNAME#">
        <input type="text" name="f_Name" id="f_Name" value="">
        <div class="clear"></div>
		<label>Email</label> 
		<input type="text" name="f_email" id="f_email" value="">
		<div class="clear"></div>
		<label>Phone</label>
		<input type="text" name="f_phone" id="f_phone" value="">
		<div class="clear"></div>
		<label>Attachment</label>  
		<input type="file" name="Attachment" />
		</fieldset>
		</div>
		<div style="float:right;margin-top:60px;margin-right:100px;">
		<div align="center" style="width:100%;position:relative;" >
		<img src="images/fdbk.png" width="230px" border="0">
<br>
<span style="float:left;font-size:15px;color:##0c587d">•	<b>Feature Request</b></span><br>
<span style="float:left;font-size:15px;color:##0c587d">•	<b>Make a Suggestion</b></span><br>
<span style="float:left;font-size:15px;color:##0c587d">•	<b>Report a problem</b></span><br>
</div>
		</div>
		<div class="right" style="margin-right:53px;">
			<input  type="submit" name="feedback_buttn" onfocus="" class="bttn" value="Send" style="width:80px;" />
	    </div>
		</fieldset>
        <div class="clear"></div>
         <div id="message" class="msg-area" style="width:153px; margin-left:200px; display:<cfif isDefined('systemConfigUpdated')>block;<cfelse>none;</cfif>">
		 	<cfif isDefined('systemConfigUpdated') AND systemConfigUpdated GT 0>
			 	Information saved successfully
			<cfelseif isDefined('systemConfigUpdated')>
				unknown <b>Error</b> occured while saving
			</cfif>
		</div>
         <div class="clear">&nbsp;</div>
         <div class="clear">&nbsp;</div>
         
                  
	</div>
   <div class="clear"></div>
 </cfform>
    </div>
    
	<div class="white-bot"></div>
</div>
</cfoutput>