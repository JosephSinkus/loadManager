<div class="form-heading">
	      <div class="pg-title"><h2>Stop 1</h2></div>
		  <div class="st-link"><ul><li><a href="##">##1</a></li><li><a href="##">##2</a></li><li><a href="##">##3</a></li></ul><div class="clear"></div></div>
		  <div class="rt-button"><input name="" type="button" class="bttn" value="Add Stop" />
				<input name="" type="button" class="bttn" value="Delete Stop" /></div>
		  <div class="clear"></div>
	   </div>
		<div class="form-con">
		
			<fieldset>
				<label class="big-text">Shipperrr</label>
				<select name="Shipper" onchange="getShipperForm(this.value,'#application.DSN#');">
					<option>CHOOSE A SHIPPER OR ENTER ONE BELOW</option>
					<cfloop query="request.qShipper">
						<option value="#request.qShipper.CustomerStopID#">#request.qShipper.CustomerStopName# &nbsp;&nbsp;&nbsp;#request.qShipper.City# &nbsp;&nbsp;&nbsp;#request.qShipper.State# </option>
					</cfloop>
				</select>
				<div class="clear"></div>
				<label>Name</label>
				<input name="shipperName" id="shipperName" value="#CustomerStopName#" type="text" requ />
				<div class="clear"></div>
				<label>Address</label>
				<textarea rows="" name="shipperlocation" id="shipperlocation" cols="">#location#</textarea>
				<div class="clear"></div>
				<label>City</label>
				<input name="shippercity" id="shippercity" value="#city#" type="text" />
				<div class="clear"></div>
				<label>State</label>
				<select name="state" id="state">
			        <option value="">Select</option>
					<cfloop query="request.qStates">
			             <option value="#request.qStates.stateID#" <cfif request.qStates.stateID is state1> selected="selected" </cfif> >#request.qStates.statecode#</option>	
					</cfloop>
				</select>
				<div class="clear"></div>
				<label>Zip</label>
				<input name="shipperZipcode" id="shipperZipcode" value="#zipcode#" type="text" />
				<div class="clear"></div>
				<label>Contact</label>
				<input name="shipperContactPerson" id="shipperContactPerson" value="#contactPerson#" type="text" />
				<div class="clear"></div>
				<label>Phone</label>
				<input name="shipperPhone" id="shipperPhone" value="#Phone#" type="text" />
				<div class="clear"></div>
				<label>Fax</label>
				<input name="shipperFax" id="shipperFax" value="#fax#" type="text" />
				<div class="clear"></div>
				
			</fieldset>
		</div>
		<div class="form-con">
			<fieldset>
				<label>Email</label>
				<input name="shipperEmail" id="shipperEmail" value="#email#" type="text" />
				<div class="clear"></div>
				<label>Pickup ##</label>
				<input name="shipperPickupNo" id="shipperPickupNo" vaue="#PickupNo#" type="text" />
				<div class="clear"></div>
				<label>Pickup Date</label>
				<input class="sm-input" name="shipperPickupDate" id="shipperPickupDate" value="#pickupDate#" type="text" />
				<label class="sm-lbl">Pickup Time</label>
				<input class="pick-input" name="shipperpickupTime" id="shipperpickupTime" value="#pickupTime#" type="text" />
				<div class="clear"></div>
				<label>Time In</label>
				<input class="sm-input" name="shipperTimeIn" id="shipperTimeIn" value="#timeIn#" type="text" />
				<label class="sm-lbl">Time Out</label>
				<input class="pick-input" name="shipperTimeOut" id="shipperTimeOut" value="#TimeOut#" type="text" />
				<div class="clear"></div>
				<label>&nbsp;</label>
				<label class="ch-box"><input name="shipBlind" id="shipBlind" type="checkbox" <cfif shipBlind is true> checked="checked" </cfif> class="check" />Ship Blind</label>
				<div class="clear"></div>
				<label>Instructions</label>
				<textarea rows="" name="shipperNotes" id="shipperNotes" style="height:61px;" cols="">#notes#</textarea>
				<div class="clear"></div>
				<label>Directions</label>
				<textarea rows="" name="shipperDirection" id="shipperDirection" style="height:62px;" cols="">#direction#</textarea>
				<div class="clear"></div>
			</fieldset>
		</div>