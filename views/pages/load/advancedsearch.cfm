<cfoutput>
<h1>Advanced Load Search</h1>   
<!---cfdump var="#request#"--->
<cfform name="searchload" action="index.cfm?event=load&#session.URLToken#" method="post" preserveData="yes">
<div class="white-con-area">
<div class="white-top"></div>
	<div class="white-mid">				
		<div class="form-con">
		<fieldset>
        <div class="form-con" style="padding-bottom:15px;">
		   <ul class="load-link">
			   <li><a href="index.cfm?event=load&linkid=lastweek&#session.URLToken#&thisweek">This Week</a></li>
			   <li><a href="index.cfm?event=load&linkid=lastweek&#session.URLToken#&lastweek">Last Week</a></li>
			   <li><a href="index.cfm?event=load&linkid=thismonth&#session.URLToken#&thismonth">This Month</a></li>
			   <li><a href="index.cfm?event=load&linkid=lastmonth&#session.URLToken#&lastmonth">Last Month</a></li>
		   </ul>
		</div>
            <div class="clear"></div>	
            <label>Ship Date</label>
            <cfinput class="sm-input" type="datefield" style="width:60px;" name="startdateAdv" value="">
            <label class="sm-lbl">End Date</label>
            <cfinput class="sm-input" type="datefield" style="width:60px;" name="enddateAdv" value="">        
                     
            <div class="clear"></div>
			<label>Load Status*</label>
            <select name="LoadStatusAdv">
             <option value="">Select Status</option>
			<cfloop query="request.qLoadStatus">
				<option value="#request.qLoadStatus.value#">#request.qLoadStatus.Text#</option>
			</cfloop>
           </select>
            <div class="clear"></div>
			<label>Office*</label>
            <select name="OfficeAdv">
             <option value="">Select</option>
             <cfloop query="request.qOffices">
              <option value="#request.qOffices.officeid#">#request.qOffices.location#</option>
              </cfloop>
             </select>
			<!--- <cfinput type="text" name="Office" id="Office" value=""> --->
			<div class="clear"></div> 
            <label>Load ##</label>
            <cfinput type="text" name="LoadNumberAdv" id="LoadNumberAdv" value="">
            <div class="clear"></div>         
             <label>Customer Name</label>
             <cfinput type="text" name="CustomerNameAdv" id="CustomerNameAdv" value="">
			 <div class="clear"></div>
			 <label>Agent</label>     
			<cfinput type="text" name="txtAgent" id="txtAgent" value="">	
             <div class="clear"></div>		
		</fieldset>
		</div>
		<div class="form-con">
			<fieldset>
			<div class="right">                
               <label>Customer PO##</label>
                <cfinput type="text" name="CustomerPOAdv" id="CustomerPOAdv" value="">
                <div class="clear"></div>
                <label>Carrier Name</label>
                <cfinput type="text" name="CarrierNameAdv" id="CarrierNameAdv" value="">
                <div class="clear"></div>
				<label>Shipper City/State</label>
                <cfinput type="text" name="shipperCityAdv" id="shipperCityAdv" value="" style="width: 107px;">
                <select name="ShipperStateAdv" style="width:72px;">
					<option value="">Select</option>
					<cfloop query="request.qStates">
						<option value="#request.qStates.statecode#" >#request.qStates.statecode#</option>	
					</cfloop>
                </select>
				<div class="clear"></div>
                <label style="width: 111px;padding: 0px 2px 0 0;">Consignee City/State</label>
                <cfinput type="text" name="consigneeCityAdv" id="consigneeCityAdv" value="" style="width: 107px;">  
                <select name="ConsigneeStateAdv" style="width:72px;">
					<option value="">Select</option>
					<cfloop query="request.qStates">
						<option value="#request.qStates.statecode#">#request.qStates.statecode#</option>	
					</cfloop>      
                </select>     
                <div class="clear"></div>     
				<label>BOL ##</label>     
				<cfinput type="text" name="txtBol" id="txtBol" value="">
                <div class="clear"></div>     
				<label>Dispatcher</label>     
				<cfinput type="text" name="txtDispatcher" id="txtDispatcher" value="">				
				<div class="clear"></div>     
                        
				<input name="searchsubmit" type="submit" class="bttn" onclick="return checkLoad();" onfocus="checkUnload();" value="Search" style="width:96px;" />
				<input name="back" type="button" onclick="javascript:history.back();" class="bttn" value="Back" style="width:62px;" />
			</div>
         </div>
			<div class="clear"></div>
			
			</fieldset>
			
</div>
</div>
</div>



</cfform>		   
</cfoutput>