<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Freight Agent Tracking System</title>
<link href="styles/style.css" rel="stylesheet" type="text/css" />
</head>
<body class="cls">
    <cfset customerid=session.AllInfo.NewcustomerID>  
    <cfset equipmentid=session.AllInfo.equipment1> 
    <cfif session.AllInfo.carrierID neq "">
        <cfquery name="GetCarrier" datasource="#Application.dsn#">
            select * from Carriers
            where carrierID='#session.AllInfo.carrierID#'
        </cfquery>
    </cfif>
        <cfquery name="GetCustomer" datasource="#Application.dsn#">
            select Customers.* from Customers
            where CustomerID='#session.AllInfo.NewcustomerID#'
        </cfquery>
        <cfif session.AllInfo.equipment1 neq "">
        <cfquery name="GetEquipment" datasource="#Application.dsn#">
            select * from Equipments
            where EquipmentID='#session.AllInfo.equipment1#'
        </cfquery>
        </cfif>
        <cfquery name="GetCustomerCharge" datasource="#Application.dsn#">
            select sum(CustCharges) as totcustcharge, sum(carrCharges) as carrCharge  from LoadStopCommodities
            where LoadStopID='#session.AllInfo.LOADSTOPID#'
            group by LoadStopID
        </cfquery>
        
            <CFSTOREDPROC PROCEDURE="USP_GetLoadItems" DATASOURCE="#Application.dsn#"> 
            			<CFPROCPARAM VALUE="#session.AllInfo.LOADSTOPID#" cfsqltype="CF_SQL_VARCHAR">

            	    <CFPROCRESULT NAME="GetShipment"> 
            	</CFSTOREDPROC>
        
	<div class="container-pr">
		<div class="content-area">
			<div class="white-con-area">
				<div class="white-top"></div>
				<div class="white-midconf">
				 <h1>LOAD MANAGER</h1>
				   <h2 class="cconf">Customer Confirmation</h2>
				   <div class="form-confirmation">
								<label><strong>LOAD NUMBER </strong></label>
								<label class="msg"><strong>#session.AllInfo.loadnumber#</strong></label>
								<div class="clear"></div>
								<label>BOOKED BY</label>
								<label class="name"><strong>#Ucase(GetCustomer.CustomerName)#</strong></label>
								<label class="msg">&nbsp;</label>
								<label class="msg">#DateFormat(now())#</label>
								<label class="msg">B/L##</label>
								<label class="msg">&nbsp;</label>
								<label class="msg">PO##</label>
								<label class="msg">#session.AllInfo.customerPO#</label>
								<div class="clear"></div>
								<label>Tel</label>
				                <label class="msg">#GetCustomer.PhoneNo#</label>
								<div class="clear"></div>

						</div>
					<div class="clear"></div>
					<div align="center"><img src="images/con-border.jpg" alt="" border="0" /></div>
				</div>
				<div class="white-midconf-data">
				   <div class="form-confirmation">
								<label><strong>CUSTOMER</strong></label>
								<label class="msg">#Ucase(GetCustomer.CustomerName)#<br />#Ucase(GetCustomer.location)#<br />#Ucase(GetCustomer.City)#, #Ucase(GetCustomer.statecode)# #GetCustomer.Zipcode#</label>
								<div class="clear"></div>
								<label>CONTACT</label>
								<label class="msg">#Ucase(GetCustomer.ContactPerson)#</label>
								<div class="clear"></div>
								<label>PHONE</label>
								<label class="msg">#GetCustomer.PhoneNo#</label>
								<div class="clear"></div>
								<label>FAX</label>
								<label class="msg">616-784-1255</label>
								<div class="clear"></div>
								<label>TOLL FREE</label>
								<label class="msg">&nbsp;</label>
								<div class="clear"></div>

						</div>
				   <div class="form-confirmation">
								<label>EQUIPMENT REQUIRED</label>
								<label class="msg"><cfif session.AllInfo.equipment1 neq "">#Ucase(GetEquipment.EquipmentName)#</cfif></label>
								<div class="clear"></div>
								<label>CHARGES</label>
								<label class="msg">#session.AllInfo.TotalCustomerCharges#</label>
								<div class="clear"></div>
								<label>TOTAL</label>
								<label class="msg"><strong>#session.AllInfo.TotalCustomerCharges#</strong></label>
								<div class="clear"></div>
								

						</div>
						<div class="clear"></div>
						<br />
						<div class="confirm-text">
						  <label>***** FOR DISPATCH HAVE YOUR DRIVER CALL 616-977-5740 AND FAX BACK THIS CONFIRMATION SIGNED TO 616-977-5745./////PLEASE COMPLETE:DRIVER NAME__________________CELL##________________________ 
TRACTOR##________________& TRAILER##_______________________.\\\\\\ Should a problem or change arise at anytime please notify NTG immediately, 24/7, at 616-977-575-40. By doing business with NTG you fully agree with NTG terms and conditions listed in the NTG broker agreement, carrier packet, and terms and conditions document located at www.terms.nfreight.com. This confirmation must be signed by carrier and received back by our booking office for payment. -->/////SEND ALL INVOICES and PODS TO:1240 JOHNSON FERRY PLACE/SUITE A10/MARIETTA, GA 30068, POD@NTGFREIGHT.COM, or Fax at 678-569-1069. Do you factor? NTGs QUICK PAY program is hassle free. Send in completed quick pay form with your invoice and pod. Form can be located at www.quickpay.ntgfreight.com, in our carrier packet, or we can fax you one upon request.</label>
                       <div class="clear"></div>
						</div>
					<div class="clear"></div>
					
				</div>
				<div class="confirmation-gap">&nbsp;</div>
				<div class="white-midconf">
				<table width="100%" border="0" class="ccdatatable" bgcolor="##5d8cc9" cellspacing="1" cellpadding="4">
				   <tr bgcolor="##ffffff">
				       <td width="50%" valign="top">
					      <table cellpadding="0" class="cctable" cellspacing="0" border="0" width="100%" align="center">
				      <tr>
					     <td><strong>PICK-UP</strong></td>
						 <td><strong>#DateFormat(session.AllInfo.shippickupDate)#</strong></td>
						 <td><strong>FCFS</strong></td>
					  </tr>
					  <tr>
					     <td>ADDRESS</td>
						 <td colspan="2">#Ucase(session.AllInfo.shiplocation)#</td>
					  </tr>
					   <tr>
					     <td>PHONE</td>
						 <td colspan="2">#session.AllInfo.shipPhone#</td>
					  </tr>
					   <tr>
					     <td>FAX</td>
						 <td colspan="2">#session.AllInfo.shipfax#</td>
					  </tr>
					  <tr>
					     <td>PICK UP##</td>
						 <td colspan="2">#session.AllInfo.shipPickupNo#</td>
					  </tr>
					  <tr>
					     <td>CONTACT</td>
						 <td colspan="2">#Ucase(session.AllInfo.shipcontactPerson)#</td>
					  </tr>
					  <tr>
						 <td colspan="3">&nbsp;</td>
					  </tr>
					  <!--- <tr>
						 <td colspan="3"><strong>SHIPMENT DESCRIPTION</strong></td>
					  </tr>
					  <tr>
						 <td >#GetShipment.UnitName#&nbsp;#GetShipment.Description# </td>
						  <td colspan="2"><CFIF LEN(TRIM(GetShipment.UnitName)) GT 0>#GetShipment.Weight#lbs</CFIF></td>
					  </tr> --->
                        <tr>
                          <td colspan="3" valign="top">
                              <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
							    <tr>
							    <td colspan="2"><strong>SHIPMENT DESCRIPTION</strong></td>
							    </tr>
							    <tr>
	    						  <td >#GetShipment.UnitName#&nbsp;#GetShipment.Description# </td>
	    						  <td><CFIF LEN(TRIM(GetShipment.UnitName)) GT 0>#GetShipment.Weight#lbs</CFIF></td>
	    					    </tr>
                              </table>
                          </td>
                       </tr>
					  <tr>
						 <td colspan="3">&nbsp;</td>
					  </tr>
					  <tr>
						 <td colspan="3"><strong>PICK-UP INSTRUCTIONS</strong></td>
					  </tr>
					  <tr>
						 <td colspan="3">#session.AllInfo.shipInstructions#</td> 
					  </tr>
				   </table>
					   </td>
					   <td valign="top">
					      <table cellpadding="0" class="cctable" cellspacing="0" border="0" width="100%" align="center">
				      <tr>
					     <td><strong>DELIVER</strong></td>
						 <td><strong>#DateFormat(session.AllInfo.consigneepickupDate)#1/17/2011</strong></td>
						 <td><strong>FCFS</strong></td>
					  </tr>
					  <tr>
					     <td>ADDRESS</td>
						 <td colspan="2">#session.AllInfo.consigneelocation#</td>
					  </tr>
					   <tr>
					     <td>PHONE</td>
						 <td colspan="2">205-545-1254</td>
					  </tr>
					   <tr>
					     <td>FAX</td>
						 <td colspan="2">#session.AllInfo.consigneefax#</td>
					  </tr>
					  <tr>
					     <td>DELIV##</td>
						 <td colspan="2">#session.AllInfo.consigneePickupNo#</td>
					  </tr>
					  <tr>
					     <td>CONTACT</td>
						 <td colspan="2">#session.AllInfo.consigneecontactPerson#</td>
					  </tr>
					  <tr>
						 <td colspan="3">&nbsp;</td>
					  </tr>
                       <tr>
                       <td colspan="3" valign="top">
                           <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
				            <tr>
				            <td colspan="2"><strong>SHIPMENT DESCRIPTION</strong></td>
				            </tr>
				            <tr>
  						     <td >#GetShipment.UnitName#&nbsp;#GetShipment.Description# </td>
  						     <td><CFIF LEN(TRIM(GetShipment.UnitName)) GT 0>#GetShipment.Weight#lbs</CFIF></td>
  					         </tr>
                           </table>
                       </td>
                       </tr>
					  <!--- <tr>
						 <td colspan="3"><strong>Shipment Description</strong></td>
					  </tr>
					  <tr>
						 <td >#GetShipment.UnitName#&nbsp;#GetShipment.Description# </td>
						  <td colspan="2"><CFIF LEN(TRIM(GetShipment.UnitName)) GT 0>#VAL(GetShipment.Weight)# lbs</CFIF></td>
					  </tr> --->
					  <tr>
						 <td colspan="3">&nbsp;</td>
					  </tr>
					  <tr>
						 <td colspan="3"><strong>Pick-Up Instructions</strong></td>
					  </tr>
					  <tr>
						 <td colspan="3">#session.AllInfo.consigneeInstructions#</td> 
					  </tr>
				   </table>
					   </td>
				   </tr>
				   
				</table>
				
			<br />
			<div class="clear"></div>
			<p>&nbsp;</p>
			<p>&nbsp;</p>
			<div class="confirm-text">
			  <label>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dapibus, lorem congue ornare elementum, dui dui adipiscing libero, ac ultrices diam eros ac nulla. Duis eu augue rutrum quam lacinia ultricies vel sit amet massa. Nam tristique, tortor non pellentesque tristique, turpis justo consequat arcu, eu vulputate elit arcu id sem.<br /><br /> Curabitur id orci sit amet ligula sed ipsum lobortis at feugiat lorem rhoncus. Pellentesque bibendum enim ac purus egestas at tincidunt quam bibendum. Nullam vestibulum ullamcorper tincidunt. Aliquam auctor feugiat sapien, id tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dapibus, lorem congue ornare elementum, dui dui adipiscing libero, ac ultrices diam eros ac nulla. Duis eu augue rutrum quam lacinia ultricies vel sit amet massa. Nam tristique, tortor non pellentesque tristique.</label>
			  <div class="clear"></div>
			  <p>&nbsp;</p>
			  <label class="csignature">Signature__________________________ Position_________________ Date__________________</label>
	           <div class="clear"></div>
			</div>
  						       </div>
	    <div class="white-bot"></div>
     	</div>
     </div>
	</div>
     <!---- Carrier Info---> 
     
                   
                    

    <br/>    <br/>    <br/>    <br/>    <br/>
  						       <cfset customerid=session.AllInfo.NewcustomerID>  
  						           <cfset equipmentid=session.AllInfo.equipment1> 
  						           <cfif session.AllInfo.carrierID neq "">
  						               <cfquery name="GetCarrier" datasource="#Application.dsn#">
  						                   select * from Carriers
  						                   where carrierID='#session.AllInfo.carrierID#'
  						               </cfquery>
  						           </cfif>
  						               <cfquery name="GetCustomer" datasource="#Application.dsn#">
  						                   select Customers.* from Customers
  						                   where CustomerID='#session.AllInfo.NewcustomerID#'
  						               </cfquery>
  						               <cfif session.AllInfo.equipment1 neq "">
  						               <cfquery name="GetEquipment" datasource="#Application.dsn#">
  						                   select * from Equipments
  						                   where EquipmentID='#session.AllInfo.equipment1#'
  						               </cfquery>
  						               </cfif>
  						               <cfquery name="GetCustomerCharge" datasource="#Application.dsn#">
  						                   select sum(CustCharges) as totcustcharge, sum(carrCharges) as carrCharge  from LoadStopCommodities
  						                   where LoadStopID='#session.AllInfo.LOADSTOPID#'
  						                   group by LoadStopID
  						               </cfquery>
  						               
  						                   <CFSTOREDPROC PROCEDURE="USP_GetLoadItems" DATASOURCE="#Application.dsn#"> 
  						                   			<CFPROCPARAM VALUE="#session.AllInfo.LOADSTOPID#" cfsqltype="CF_SQL_VARCHAR">

  						                   	    <CFPROCRESULT NAME="GetShipment"> 
  						                   	</CFSTOREDPROC>
												<div class="content-area">
												  <div class="white-con-area">
													<div class="white-top"></div>
  						                   	   			<div class="white-midconf">
  						                   	   				 <!--- <h1><!--- LOAD MANAGER ---></h1> --->
  						                   	   				   <h2 class="cconf">Carrier Confirmation</h2>
  						                   	   				   <div class="form-confirmation">
  						                   	   								<label><strong>LOAD NUMBER </strong></label>
  						                   	   								<label class="msg"><strong>#session.AllInfo.loadnumber#</strong></label>
  						                   	   								<div class="clear"></div>
  						                   	   								<label>BOOKED BY</label>
  						                   	   								<label class="name"><strong><cfif session.AllInfo.NewcustomerID neq "">#Ucase(GetCustomer.CustomerName)#</cfif></strong></label>
  						                   	   								<label class="msg">&nbsp;</label>
  						                   	   								<label class="msg">#DateFormat(now())#</label>
  						                   	   								<label class="msg">B/L##</label>
  						                   	   								<label class="msg">&nbsp;</label>
  						                   	   								<label class="msg">PO##</label>
  						                   	   								<label class="msg">#session.AllInfo.customerPO#</label>
  						                   	   								<div class="clear"></div>
  						                   	   								<label>Tel</label>
  						                   	   								<label class="msg"><cfif session.AllInfo.NewcustomerID neq "">#GetCustomer.PhoneNo#</cfif></label>
  						                   	   								<div class="clear"></div>

  						                   	   						</div>
  						                   	   					<div class="clear"></div>
  						                   	   					<div align="center"><img src="images/con-border.jpg" alt="" border="0" /></div>
  						                   	   				</div>
  						                   	   				<div class="white-midconf-data">
  						                   	   				   <div class="form-confirmation">
  						                   	   								<label><strong>CARRIER</strong></label>
  						                   	   								<label class="msg"><cfif session.AllInfo.carrierID neq "">#GetCarrier.CarrierName#</cfif><br /></label>
  						                   	   								<div class="clear"></div>
  						                   	   							    <label>BOOKED  WITH</label>
  						                   	   						        <label class="msg">#session.AllInfo.bookedwith1#</label>
  						                   	   							    <div class="clear"></div>
  						                   	   								<label>PHONE</label>
  						                   	   								<label class="msg"><cfif session.AllInfo.carrierID neq "">#GetCarrier.Phone#</cfif></label>
  						                   	   								<div class="clear"></div>
  						                   	   								<label>FAX</label>
  						                   	   								<label class="msg"><cfif session.AllInfo.carrierID neq "">#GetCarrier.Fax#</cfif>&nbsp;</label>
  						                   	   								<div class="clear"></div>
  						                   	   								<label>TOLL FREE</label>
  						                   	   								<label class="msg"><cfif session.AllInfo.carrierID neq "">#GetCarrier.TollFree#</cfif>&nbsp;</label>
  						                   	   								<div class="clear"></div>

  						                   	   						</div>
  						                   	   				   <div class="form-confirmation">
  						                   	   								<label>EQUIPMENT REQUIRED</label>
  						                   	   								<label class="msg"><cfif session.AllInfo.equipment1 neq "">#GetEquipment.EquipmentName#</cfif></label>
  						                   	   								<div class="clear"></div>
  						                   	   								<label>REF ##</label>
  						                   	   								<label class="msg"></label>
  						                   	   								<div class="clear"></div>
  						                   	   								<label>CHARGES</label>
  						                   	   								<label class="msg">#session.AllInfo.TotalCustomerCharges#</label>
  						                   	   								<div class="clear"></div>
  						                   	   								<label>TOTAL</label>
  						                   	   								<label class="msg"><strong>#session.AllInfo.TotalCustomerCharges#</strong></label>
  						                   	   								<div class="clear"></div>
  						                   	   								

  						                   	   						</div>
  						                   	   						<div class="clear"></div>
  						                   	   						<br />
  						                   	   						<div class="confirm-text">
  						                   	   						  <label>***** FOR DISPATCH HAVE YOUR DRIVER CALL 616-977-5740 AND FAX BACK THIS CONFIRMATION SIGNED TO 616-977-5745./////PLEASE COMPLETE:DRIVER NAME__________________CELL##________________________ 
  						                   	   TRACTOR##________________& TRAILER##_______________________.\\\\\\ Should a problem or change arise at anytime please notify NTG immediately, 24/7, at 616-977-575-40. By doing business with NTG you fully agree with NTG terms and conditions listed in the NTG broker agreement, carrier packet, and terms and conditions document located at www.terms.nfreight.com. This confirmation must be signed by carrier and received back by our booking office for payment. -->/////SEND ALL INVOICES and PODS TO:1240 JOHNSON FERRY PLACE/SUITE A10/MARIETTA, GA 30068, POD@NTGFREIGHT.COM, or Fax at 678-569-1069. Do you factor? NTGs QUICK PAY program is hassle free. Send in completed quick pay form with your invoice and pod. Form can be located at www.quickpay.ntgfreight.com, in our carrier packet, or we can fax you one upon request.</label>
  						                   	                          <div class="clear"></div>
  						                   	   						</div>
  						                   	   					<div class="clear"></div>
  						                   	   					
  						                   	   				</div>
  						                   	   				<div class="confirmation-gap">&nbsp;</div>
  						                   	   				<div class="white-midconf">
  						                   	   				<table width="100%" border="0" class="ccdatatable" bgcolor="##5d8cc9" cellspacing="1" cellpadding="4">
  						                   	   				   <tr bgcolor="##ffffff">
  						                   	   				       <td width="50%" valign="top">
  						                   	   					      <table cellpadding="0" class="cctable" cellspacing="0" border="0" width="100%" align="center">
  						                   	   				      <tr>
  						                   	   					     <td><strong>PICK-UP</strong></td>
  						                   	   						 <td><strong>#DateFormat(session.AllInfo.shippickupDate)#</strong></td>
  						                   	   						 <td><strong>FCFS</strong></td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   					     <td>ADDRESS</td>
  						                   	   						 <td colspan="2">#Ucase(session.AllInfo.shiplocation)#</td>
  						                   	   					  </tr>
  						                   	   					   <tr>
  						                   	   					     <td>PHONE</td>
  						                   	   						 <td colspan="2">#session.AllInfo.shipPhone#</td>
  						                   	   					  </tr>
  						                   	   					   <tr>
  						                   	   					     <td>FAX</td>
  						                   	   						 <td colspan="2">#session.AllInfo.shipfax#</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   					     <td>PICK UP##</td>
  						                   	   						 <td colspan="2">#session.AllInfo.shipPickupNo#</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   					     <td>CONTACT</td>
  						                   	   						 <td colspan="2">#Ucase(session.AllInfo.shipcontactPerson)#</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3">&nbsp;</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	                             <td colspan="3" valign="top">
  						                   	                                 <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
  						                   	   								    <tr>
  						                   	   								    						 <td colspan="2"><strong>SHIPMENT DESCRIPTION</strong></td>
  						                   	   								    					  </tr>
  						                   	   								    					  <tr>
  						                   	   								    						 <td >#GetShipment.UnitName#&nbsp;#GetShipment.Description# </td>
  						                   	   								    						  <td><CFIF LEN(TRIM(GetShipment.UnitName)) GT 0>#GetShipment.Weight#lbs</CFIF></td>
  						                   	   								    					  </tr>
  						                   	                                 </table>
  						                   	                             </td>
  						                   	                         </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3">&nbsp;</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3"><strong>PICK-UP INSTRUCTIONS</strong></td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3">#session.AllInfo.shipInstructions#</td> 
  						                   	   					  </tr>
  						                   	   				   </table>
  						                   	   					   </td>
  						                   	   					   <td valign="top">
  						                   	   					      <table cellpadding="0" class="cctable" cellspacing="0" border="0" width="100%" align="center">
  						                   	   				      <tr>
  						                   	   					     <td><strong>DELIVER</strong></td>
  						                   	   						 <td><strong>#DateFormat(session.AllInfo.consigneepickupDate)#1/17/2011</strong></td>
  						                   	   						 <td><strong>FCFS</strong></td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   					     <td>ADDRESS</td>
  						                   	   						 <td colspan="2">#session.AllInfo.consigneelocation#</td>
  						                   	   					  </tr>
  						                   	   					   <tr>
  						                   	   					     <td>PHONE</td>
  						                   	   						 <td colspan="2">205-545-1254</td>
  						                   	   					  </tr>
  						                   	   					   <tr>
  						                   	   					     <td>FAX</td>
  						                   	   						 <td colspan="2">#session.AllInfo.consigneefax#</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   					     <td>DELIV##</td>
  						                   	   						 <td colspan="2">#session.AllInfo.consigneePickupNo#</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   					     <td>CONTACT</td>
  						                   	   						 <td colspan="2">#session.AllInfo.consigneecontactPerson#</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3">&nbsp;</td>
  						                   	   					  </tr>
  						                   	                               
  						                   	                            <tr>
  						                   	                             <td colspan="3" valign="top">
  						                   	                                 <table cellpadding="0" cellspacing="0" width="100%" align="center" border="0">
  						                   	   							    <tr>
  						                   	   							    <td colspan="2"><strong>SHIPMENT DESCRIPTION</strong></td>
  						                   	   							    </tr>
  						                   	   							    <tr>
  						                   	   	    						  <td >#GetShipment.UnitName#&nbsp;#GetShipment.Description# </td>
  						                   	   	    						  <td><CFIF LEN(TRIM(GetShipment.UnitName)) GT 0>#GetShipment.Weight#lbs</CFIF></td>
  						                   	   	    					    </tr>
  						                   	                                 </table>
  						                   	                             </td>
  						                   	                         </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3">&nbsp;</td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3"><strong>Pick-Up Instructions</strong></td>
  						                   	   					  </tr>
  						                   	   					  <tr>
  						                   	   						 <td colspan="3">#session.AllInfo.consigneeInstructions#</td> 
  						                   	   					  </tr>
  						                   	   				   </table>
  						                   	   					   </td>
  						                   	   				   </tr>
  						                   	   				   
  						                   	   				</table>
  						                   	   				
  						                   	   			<br />
  						                   	   			<div class="clear"></div>
  						                   	   			<p>&nbsp;</p>
  						                   	   			<p>&nbsp;</p>
  						                   	   			<div class="confirm-text">
  						                   	   						  <label>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dapibus, lorem congue ornare elementum, dui dui adipiscing libero, ac ultrices diam eros ac nulla. Duis eu augue rutrum quam lacinia ultricies vel sit amet massa. Nam tristique, tortor non pellentesque tristique, turpis justo consequat arcu, eu vulputate elit arcu id sem.<br /><br /> Curabitur id orci sit amet ligula sed ipsum lobortis at feugiat lorem rhoncus. Pellentesque bibendum enim ac purus egestas at tincidunt quam bibendum. Nullam vestibulum ullamcorper tincidunt. Aliquam auctor feugiat sapien, id tincidunt.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dapibus, lorem congue ornare elementum, dui dui adipiscing libero, ac ultrices diam eros ac nulla. Duis eu augue rutrum quam lacinia ultricies vel sit amet massa. Nam tristique, tortor non pellentesque tristique.</label>
  						                   	   						  <div class="clear"></div>
  						                   	   						  <p>&nbsp;</p>
  						                   	   						  <label class="csignature">Signature__________________________ Position_________________ Date__________________</label>
  						                   	                          <div class="clear"></div>
  						                   	   						</div>
  						                   	   				</div>
  						                   	   				<div class="white-bot"></div>
  						                   	   			</div>
  						                   	   	    						</div>
</div>
</div>
</body>
</html>
</cfoutput>