<!---<cfparam name="message" default="">
<cfparam name="url.sortorder" default="desc">
<cfparam name="sortby"  default="">--->

<cfoutput>
<h1 style="width:655px; float:left;">System Setup</h1>
<label style="float:left;"><b>Version 1.01</b> &lt;Posted: 10/10/2011&gt;</label>
<div style="clear:left"></div>

<div class="white-con-area">
	<div class="white-top"></div>
	
    <div class="white-mid">
	<cfform name="frmAgent" action="index.cfm?event=addagent:process&#session.URLToken#" method="post">

	<div class="form-con">
	<fieldset>
    	<cfinput id="calculatedMiles" name="calculatedMiles" type="hidden" value="" onChange="updatedMilesWithLongShort();">
		<label>Long Miles</label>
        <cfinput type="text" name="longMiles" id="longMiles" tabindex="1" value="" size="25" onClick="document.getElementById('message').style.display='none';" onChange="updatedMilesWithLongShort();"> %
        <div class="clear"></div>
		<label>Consignee Address</label>
        <cftextarea type="text" tabindex="2" name="conAddress" id="conAddress" onClick="document.getElementById('message').style.display='none';" onBlur="calculateDist('conAddress','shipperAddress')"></cftextarea>
        <div class="clear"></div>
		<label>Customer Rate Per Mile</label>
        <cfinput type="text" name="customerRate" id="customerRate" tabindex="1" value="" size="25" onClick="document.getElementById('message').style.display='none';" onChange="updatedMilesWithLongShort();">
        <div class="clear"></div>
        <div style="height:30px;"></div>
        <label>Customer Miles</label>
        <cfinput type="text" name="customerMiles" id="customerMiles" tabindex="1" value="" size="25" readonly="readonly" onChange="document.getElementById('message').style.display='none';">
        <div class="clear"></div>
        <label>Customer Amount</label>
        <cfinput type="text" name="customerAmount" id="customerAmount" tabindex="1" value="" size="25" readonly="readonly" onChange="document.getElementById('message').style.display='none';">
        <div class="clear"></div>
		</fieldset>
		</div>
		<div class="form-con">
		<fieldset>	

        <label>Short Miles</label>
        <cfinput type="text" name="shortMiles" id="shortMiles" tabindex="1" value="" size="25" onChange="updatedMilesWithLongShort();" onClick="document.getElementById('message').style.display='none';"> %
        <div class="clear"></div>
		<label>Shipper Address</label>
        <cftextarea type="text" tabindex="2" name="shipperAddress" id="shipperAddress" onBlur="calculateDist('conAddress','shipperAddress')" onClick="document.getElementById('message').style.display='none';"></cftextarea>
        <div class="clear"></div>
        <label>Carrier Rate Per Mile</label>
        <cfinput type="text" name="carrierRate" id="carrierRate" tabindex="1" value="" size="25" onChange="updatedMilesWithLongShort();" onClick="document.getElementById('message').style.display='none';">
        <div class="clear"></div>
        <div style="height:30px;"></div>
        <label>Carrier Miles</label>
        <cfinput type="text" name="carrierMiles" id="carrierMiles" tabindex="1" value="" size="25" readonly="readonly" onChange="document.getElementById('message').style.display='none';">
        <div class="clear"></div>
        <label>Carrier Amount</label>
        <cfinput type="text" name="carrierAmount" id="carrierAmount" tabindex="1" value="" size="25" readonly="readonly" onChange="document.getElementById('message').style.display='none';">
        <div class="clear"></div>
        
        <div class="right" style="margin-right:53px;">
		        <input  type="button" name="submit" onclick="if(validateFields()){saveLongShortMiles('#application.DSN#'); addQuickCalcInfoToLog('#application.DSN#');}" onfocus="" class="bttn" value="Save Long Short Miles" style="width:170px;" />
	    </div>
		</fieldset>
        <div class="clear"></div>
         <div id="message" class="msg-area" style="width:153px; margin-left:200px; display:none;"></div>
         <div class="clear"></div>
	</div>
   <div class="clear"></div>
 </cfform>
    </div>
    
	<div class="white-bot"></div>
</div>
<script>getAndUpdateLongShortMilesFields('#application.DSN#');</script>
</cfoutput>