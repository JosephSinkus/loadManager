
<cfset variables.dateDispatched = "">
<cfset variables.steamShipLine = "">
<cfset variables.eta = "">
<cfset variables.oceanBillofLading = "">
<cfset variables.actualArrivalDate = "">
<cfset variables.seal = "">
<cfset variables.customersReleaseDate = "">
<cfset variables.vesselName = "">
<cfset variables.freightReleaseDate = "">
<cfset variables.dateAvailable = "">
<cfset variables.demuggageFreeTimeExpirationDate = "">
<cfset variables.perDiemFreeTimeExpirationDate = "">
<cfset variables.pickupDate = "">
<cfset variables.requestedDeliveryDate = "">
<cfset variables.requestedDeliveryTime = "">
<cfset variables.scheduledDeliveryDate = "">
<cfset variables.scheduledDeliveryTime = "">
<cfset variables.unloadingDelayDetentionStartDate = "">
<cfset variables.unloadingDelayDetentionStartTime = "">
<cfset variables.actualDeliveryDate = "">
<cfset variables.unloadingDelayDetentionEndDate = "">
<cfset variables.unloadingDelayDetentionEndTime = "">
<cfset variables.returnDate = "">
<cfset variables.exportDateDispatched = "">
<cfset variables.exportDateMtAvailableForPickup = "">
<cfset variables.exportSteamShipLine = "">
<cfset variables.exportDemurrageFreeTimeExpirationDate = "">
<cfset variables.exportVesselName = "">
<cfset variables.exportPerDiemFreeTimeExpirationDate = "">
<cfset variables.exportVoyage = "">
<cfset variables.exportEmptyPickupDate = "">
<cfset variables.exportSeal = "">
<cfset variables.exportBooking  = "">
<cfset variables.exportScheduledLoadingDate = "">
<cfset variables.exportScheduledLoadingTime = "">
<cfset variables.exportVesselCutoffDate = "">
<cfset variables.exportLoadingDate = "">
<cfset variables.exportVesselLoadingWindow = "">
<cfset variables.exportLoadingDelayDetectionStartDate = "">
<cfset variables.exportLoadingDelayDetectionStartTime = "">
<cfset variables.exportRequestedLoadingDate = "">
<cfset variables.exportRequestedLoadingTime = "">
<cfset variables.exportLoadingDelayDetectionEndDate = "">
<cfset variables.exportLoadingDelayDetectionEndTime = "">
<cfset variables.exportETS = "">
<cfset variables.exportReturnDate = "">

<cfset variables.pickUpAddress = "">
<cfset variables.deliveryAddress = "">
<cfset variables.emptyReturnAddress = "">
<cfset variables.exportEmptyPickUpAddress = "">
<cfset variables.exportLoadingAddress = "">
<cfset variables.exportReturnAddress = "">

<cfif StructKeyExists(url,"loadID")>
	<cfif url.stopno EQ "">
		<cfset stopnumber = 0>
	<cfelse>
		<cfset stopnumber = url.stopno - 1 >
	</cfif>
	<cfif url.loadID EQ "">
		<cfset url.loadID = 0>
	</cfif>
	<cfinvoke component="#variables.objloadGateway#" method="getLoadStopInfo" StopNo="#stopnumber#" LoadType="1" loadID="#url.loadID#" returnvariable="request.LoadStopInfoShipper" />
	<cfif request.LoadStopInfoShipper.recordcount>
		<cfinvoke component="#variables.objloadGateway#" method="getLoadStopIntermodalImport" LOADSTOPID="#request.LoadStopInfoShipper.loadstopid#" returnvariable="request.qLoadStopIntermodalImport" />
		<cfinvoke component="#variables.objloadGateway#" method="getLoadStopIntermodalExport" LOADSTOPID="#request.LoadStopInfoShipper.loadstopid#" returnvariable="request.qLoadStopIntermodalExport" />
		<cfif request.qLoadStopIntermodalImport.recordcount>
			<cfset variables.dateDispatched = DateFormat(request.qLoadStopIntermodalImport.dateDispatched,"mm/dd/yyyy")>
			<cfset variables.steamShipLine = request.qLoadStopIntermodalImport.steamShipLine>
			<cfset variables.eta = DateFormat(request.qLoadStopIntermodalImport.eta,"mm/dd/yyyy")>
			<cfset variables.oceanBillofLading = request.qLoadStopIntermodalImport.oceanBillofLading>
			<cfset variables.actualArrivalDate = DateFormat(request.qLoadStopIntermodalImport.actualArrivalDate,"mm/dd/yyyy")>
			<cfset variables.seal = request.qLoadStopIntermodalImport.seal>
			<cfset variables.customersReleaseDate = DateFormat(request.qLoadStopIntermodalImport.customersReleaseDate,"mm/dd/yyyy")>
			<cfset variables.vesselName = request.qLoadStopIntermodalImport.vesselName>
			<cfset variables.freightReleaseDate = DateFormat(request.qLoadStopIntermodalImport.freightReleaseDate,"mm/dd/yyyy")>
			<cfset variables.dateAvailable = DateFormat(request.qLoadStopIntermodalImport.dateAvailable,"mm/dd/yyyy")>
			<cfset variables.demuggageFreeTimeExpirationDate = DateFormat(request.qLoadStopIntermodalImport.demuggageFreeTimeExpirationDate,"mm/dd/yyyy")>
			<cfset variables.perDiemFreeTimeExpirationDate = DateFormat(request.qLoadStopIntermodalImport.perDiemFreeTimeExpirationDate,"mm/dd/yyyy")>
			<cfset variables.pickupDate = DateFormat(request.qLoadStopIntermodalImport.pickupDate,"mm/dd/yyyy")>
			<cfset variables.requestedDeliveryDate = DateFormat(request.qLoadStopIntermodalImport.requestedDeliveryDate,"mm/dd/yyyy")>
			<cfset variables.requestedDeliveryTime = request.qLoadStopIntermodalImport.requestedDeliveryTime>
			<cfset variables.scheduledDeliveryDate = DateFormat(request.qLoadStopIntermodalImport.scheduledDeliveryDate,"mm/dd/yyyy")>
			<cfset variables.scheduledDeliveryTime = request.qLoadStopIntermodalImport.scheduledDeliveryTime>
			<cfset variables.unloadingDelayDetentionStartDate = DateFormat(request.qLoadStopIntermodalImport.unloadingDelayDetentionStartDate,"mm/dd/yyyy")>
			<cfset variables.unloadingDelayDetentionStartTime = request.qLoadStopIntermodalImport.unloadingDelayDetentionStartTime>
			<cfset variables.actualDeliveryDate = DateFormat(request.qLoadStopIntermodalImport.actualDeliveryDate,"mm/dd/yyyy")>
			<cfset variables.unloadingDelayDetentionEndDate = DateFormat(request.qLoadStopIntermodalImport.unloadingDelayDetentionEndDate,"mm/dd/yyyy")>
			<cfset variables.unloadingDelayDetentionEndTime = request.qLoadStopIntermodalImport.unloadingDelayDetentionEndTime>
			<cfset variables.returnDate = DateFormat(request.qLoadStopIntermodalImport.returnDate,"mm/dd/yyyy")>
			<cfset variables.pickUpAddress = request.qLoadStopIntermodalImport.pickUpAddress>
			<cfset variables.deliveryAddress = request.qLoadStopIntermodalImport.deliveryAddress>
			<cfset variables.emptyReturnAddress = request.qLoadStopIntermodalImport.emptyReturnAddress>
		</cfif>
		<cfif request.qLoadStopIntermodalExport.recordcount>
			<cfset variables.exportDateDispatched = DateFormat(request.qLoadStopIntermodalExport.DateDispatched,"mm/dd/yyyy")>
			<cfset variables.exportDateMtAvailableForPickup = DateFormat(request.qLoadStopIntermodalExport.DateMtAvailableForPickup,"mm/dd/yyyy")>
			<cfset variables.exportSteamShipLine = request.qLoadStopIntermodalExport.SteamShipLine>
			<cfset variables.exportDemurrageFreeTimeExpirationDate = DateFormat(request.qLoadStopIntermodalExport.DemurrageFreeTimeExpirationDate,"mm/dd/yyyy")>
			<cfset variables.exportVesselName = request.qLoadStopIntermodalExport.VesselName>
			<cfset variables.exportPerDiemFreeTimeExpirationDate = DateFormat(request.qLoadStopIntermodalExport.PerDiemFreeTimeExpirationDate,"mm/dd/yyyy")>
			<cfset variables.exportVoyage = request.qLoadStopIntermodalExport.Voyage>
			<cfset variables.exportEmptyPickupDate = DateFormat(request.qLoadStopIntermodalExport.EmptyPickupDate,"mm/dd/yyyy")>
			<cfset variables.exportSeal = request.qLoadStopIntermodalExport.Seal>
			<cfset variables.exportBooking  = request.qLoadStopIntermodalExport.Booking>
			<cfset variables.exportScheduledLoadingDate = DateFormat(request.qLoadStopIntermodalExport.ScheduledLoadingDate,"mm/dd/yyyy")>
			<cfset variables.exportScheduledLoadingTime = request.qLoadStopIntermodalExport.ScheduledLoadingTime>
			<cfset variables.exportVesselCutoffDate = DateFormat(request.qLoadStopIntermodalExport.VesselCutoffDate,"mm/dd/yyyy")>
			<cfset variables.exportLoadingDate = DateFormat(request.qLoadStopIntermodalExport.LoadingDate,"mm/dd/yyyy")>
			<cfset variables.exportVesselLoadingWindow = request.qLoadStopIntermodalExport.VesselLoadingWindow>
			<cfset variables.exportLoadingDelayDetectionStartDate = DateFormat(request.qLoadStopIntermodalExport.LoadingDelayDetectionStartDate,"mm/dd/yyyy")>
			<cfset variables.exportLoadingDelayDetectionStartTime = request.qLoadStopIntermodalExport.LoadingDelayDetectionStartTime>
			<cfset variables.exportRequestedLoadingDate = DateFormat(request.qLoadStopIntermodalExport.RequestedLoadingDate,"mm/dd/yyyy")>
			<cfset variables.exportRequestedLoadingTime = request.qLoadStopIntermodalExport.RequestedLoadingTime>
			<cfset variables.exportLoadingDelayDetectionEndDate = DateFormat(request.qLoadStopIntermodalExport.LoadingDelayDetectionEndDate,"mm/dd/yyyy")>
			<cfset variables.exportLoadingDelayDetectionEndTime = request.qLoadStopIntermodalExport.LoadingDelayDetectionEndTime>
			<cfset variables.exportETS = DateFormat(request.qLoadStopIntermodalExport.ETS,"mm/dd/yyyy")>
			<cfset variables.exportReturnDate = DateFormat(request.qLoadStopIntermodalExport.ReturnDate,"mm/dd/yyyy")>
			<cfset variables.exportEmptyPickUpAddress = request.qLoadStopIntermodalExport.emptyPickUpAddress>
			<cfset variables.exportLoadingAddress = request.qLoadStopIntermodalExport.loadingAddress>
			<cfset variables.exportReturnAddress = request.qLoadStopIntermodalExport.returnAddress>
		</cfif>
	</cfif>
</cfif>
<cfoutput>
	<script>
		$(document).ready(function(){
			$('.typeAddress').css("font-size","8px !important");
			$('.typeAddress').on("click",function(){
				var thisVal = $(this).val();
				if(thisVal == 'TYPE NEW ADDRESS BELOW'){
					$(this).val("");
					$(this).css("color","black");
					$(this).css("z-index","1");
					$(this).css("font-size","11px !important");
				}
			});
			$('.typeAddress').each(function(i, tag) {
				var addressClass = $(tag).attr("class");
				var addressClass = addressClass.substring(addressClass.lastIndexOf(" ") + 1);
				var addressfieldID = $(tag).attr("rel");
				$(tag).autocomplete({
					multiple: false,
					width: 450,
					scroll: true,
					scrollHeight: 300,
					cacheLength: 1,
					highlight: false,
					dataType: "json",
					source: 'searchLoadStopAddress.cfm?fieldClass='+addressClass+'&loadid=#url.loadid#&stopno=#stopNo#',
					select: function(e, ui) {
						var string = ui.item.label.replace('\n\n\n\n', "\n").replace('\n\n', "\n");
						var string = string.replace('\n\n\n\n', "\n").replace('\n\n', "\n");
						var string = string.replace('\n\n\n\n', "\n").replace('\n\n', "\n");
						var string = string.replace('\n\n\n\n', "\n").replace('\n\n', "\n");
						var string = string.replace('\n\n\n\n', "\n").replace('\n\n', "\n");
						$("##"+addressfieldID).val(string);	
						return false;
					}
				});	
				$(tag).data("ui-autocomplete")._renderItem = function(ul, item) {
					return $( "<li>"+item.label+"</li>" ).appendTo( ul );
				}
			});
		}); 
	</script>
	<div class="importLoads"> 
			<table>
				<tr>
					<th class="importLoadsheader" colspan="6">
						IMPORT LOADS
					</th>
				</tr>
				<tr style="height: 40px;">
					<td>
						TYPE TO SELECT
					</td>
					<td>
						<input class="ac_input typeAddress typePickUpAddress" rel="pickUpAddress#url.stopno#" tabindex=4 id="typePickUpAddress#url.stopno#" name="typePickUpAddress#url.stopno#" value="TYPE NEW ADDRESS BELOW" type="text"/>
					</td>
					<td>
						TYPE TO SELECT
					</td>
					<td>
						<input class="ac_input typeAddress typeDeliveryddress" rel="deliveryAddress#url.stopno#" tabindex=4 id="typeDeliveryddress#url.stopno#" name="typeDeliveryddress#url.stopno#" value="TYPE NEW ADDRESS BELOW" type="text"/>
					</td>
					<td>
						TYPE TO SELECT
					</td>
					<td>
						<input class="ac_input typeAddress typeEmptyReturnAddress" rel="emptyReturnAddress#url.stopno#" tabindex=4 id="typeEmptyReturnAddress#url.stopno#" name="typeEmptyReturnAddress#url.stopno#" value="TYPE NEW ADDRESS BELOW" type="text"/>
					</td>
				</tr>
				<tr>
					<td>
						CARGO PICKUP ADDRESS
					</td>
					<td>
						<textarea id="pickUpAddress#url.stopno#"  cols="26" rows="6" name="pickUpAddress#url.stopno#">#variables.pickUpAddress#</textarea>
					</td>
					<td>
						CARGO DELIVERY ADDRESS
					</td>
					<td>
						<textarea id="deliveryAddress#url.stopno#"  cols="26" rows="6" name="deliveryAddress#url.stopno#">#variables.deliveryAddress#</textarea>
					</td>
					<td>
						EMPTY RETURN ADDRESS
					</td>
					<td>
						<textarea id="emptyReturnAddress#url.stopno#"  cols="26" rows="6" name="emptyReturnAddress#url.stopno#" >#variables.emptyReturnAddress#</textarea>
					</td>
				</tr>
			</table>
			<div class="lineBreak"></div>
			<table class="importLoadsTable" cellspacing="0" cellpadding="0">
				<tr>
					<td class="leftlabel">
						DATE DISPATCHED TO TRUCKER
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker"  name="dateDispatched#url.stopno#" id="dateDispatched#url.stopno#" value="#variables.dateDispatched#" message="Please enter a valid date Dsipatched to Trucker" type="text" />  
					</td>
					<td class="rightlabel">
						STEAMSHIP LINE
					</td>
					<td class="rightfield">
						<input class="ac_input" tabindex=4 id="steamShipLine#url.stopno#" name="steamShipLine#url.stopno#" value="#variables.steamShipLine#" type="text" message="Please enter a valid Steamship Line" />
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						ETA
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker" tabindex=4 name="eta#url.stopno#" id="eta#url.stopno#" value="#variables.eta#" validate="date" message="Please enter a valid ETA" type="datefield" mask="dd/mm/yyyy" />  
					</td>
					<td class="rightlabel">
						OCEAN BILL OF LADING ##
					</td>
					<td class="rightfield">
						<input class="ac_input" tabindex=4 id="oceanBillofLading#url.stopno#" name="oceanBillofLading#url.stopno#" value="#variables.oceanBillofLading#" type="text" message="Please enter a valid ocean bill of lading" />
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						ACTUAL ARRIVAL DATE
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker" tabindex=4 name="actualArrivalDate#url.stopno#" id="actualArrivalDate#url.stopno#" value="#variables.actualArrivalDate#" validate="date" message="Please enter a valid actual arrival date" type="datefield" mask="dd/mm/yyyy" />  
					</td>
					<td class="rightlabel">
						SEAL ##
					</td>
					<td class="rightfield">
						<input class="ac_input" tabindex=4 value="#variables.seal#" id="seal#url.stopno#" name="seal#url.stopno#" type="text" message="Please enter a valid seal" />
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						CUSTOMS RELEASE DATE
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker" tabindex=4 name="customersReleaseDate#url.stopno#" id="customersReleaseDate#url.stopno#" value="#variables.customersReleaseDate#" validate="date" message="Please enter a valid customs release date" type="datefield" mask="dd/mm/yyyy" />  
					</td>
					<td class="rightlabel">
						VESSEL NAME
					</td>
					<td class="rightfield">
						<input class="ac_input" tabindex=4 value="#variables.vesselName#" id="vesselName#url.stopno#" name="vesselName#url.stopno#" type="text" message="Please enter a valid vessel name" />
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						FREIGHT RELEASE DATE
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker" tabindex=4 name="freightReleaseDate#url.stopno#" id="freightReleaseDate#url.stopno#" value="#variables.freightReleaseDate#" validate="date" message="Please enter a valid freight release date" type="datefield" mask="dd/mm/yyyy" />  
					</td>
					<td class="rightlabel">
						DATE AVAILABLE
					</td>
					<td class="rightfield">
						<input class="sm-input datePicker" tabindex=4 name="dateAvailable#url.stopno#" id="dateAvailable#url.stopno#" value="#variables.dateAvailable#" validate="date" message="Please enter a valid date available" type="datefield" mask="dd/mm/yyyy" />  
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						DEMURRAGE-FREE TIME EXPIRATION DATE
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker" tabindex=4 name="demuggageFreeTimeExpirationDate#url.stopno#" id="demuggageFreeTimeExpirationDate#url.stopno#" value="#variables.demuggageFreeTimeExpirationDate#" validate="date" message="Please enter a valid demurrage-free time expiration date" type="datefield" mask="dd/mm/yyyy" />  
					</td>
					<td class="rightlabel">
						PER DIEM-FREE TIME EXPIRATION DATE
					</td>
					<td class="rightfield">
						<input class="sm-input datePicker" tabindex=4 name="perDiemFreeTimeExpirationDate#url.stopno#" id="perDiemFreeTimeExpirationDate#url.stopno#" value="#variables.perDiemFreeTimeExpirationDate#" validate="date" message="Please enter a valid per diem-free time expiration date" type="datefield" mask="dd/mm/yyyy" />  
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						PICK UP DATE
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker" tabindex=4 name="pickupDate#url.stopno#" id="pickupDate#url.stopno#" value="#variables.pickupDate#" validate="date" message="Please enter a valid pick up date" type="datefield" mask="dd/mm/yyyy" />  
					</td>
					<td class="rightlabel">
						REQUESTED DELIVERY DATE
					</td>
					<td class="rightfield">
						<table>
							<tr>
								<td>
									<input class="sm-input datePicker" tabindex=4 name="requestedDeliveryDate#url.stopno#" id="requestedDeliveryDate#url.stopno#" value="#variables.requestedDeliveryDate#" validate="date" message="Please enter a valid requested delivery date" type="datefield" mask="dd/mm/yyyy" />  
								</td>
								<td>
									TIME
								</td>
								<td>
									<input class="sm-input" name="requestedDeliveryTime#url.stopno#" id="requestedDeliveryTime#url.stopno#" value="#variables.requestedDeliveryTime#" type="text" message="Please enter a valid requested delivery time" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						SCHEDULED DELIVERY DATE
					</td>
					<td class="leftfield">
						<table>
							<tr>
								<td>
									<input class="sm-input datePicker" tabindex=4 name="scheduledDeliveryDate#url.stopno#" id="scheduledDeliveryDate#url.stopno#" value="#variables.scheduledDeliveryDate#" validate="date" message="Please enter a valid scheduled delivery date" type="datefield" mask="dd/mm/yyyy" />  
								</td>
								<td>
									TIME
								</td>
								<td>
									<input class="sm-input" name="scheduledDeliveryTime#url.stopno#" id="scheduledDeliveryTime#url.stopno#" value="#variables.scheduledDeliveryTime#" type="text" />
								</td>
							</tr>
						</table>
					</td>
					<td class="rightlabel">
						UNLOADING DELAY-DETENTION START TIME
					</td>
					<td class="rightfield">
						<table>
							<tr>
								<td>
									<input class="sm-input datePicker" tabindex=4 name="unloadingDelayDetentionStartDate#url.stopno#" id="unloadingDelayDetentionStartDate#url.stopno#" value="#variables.unloadingDelayDetentionStartDate#" validate="date" message="Please enter a valid unloading delay-detention start time" type="datefield" mask="dd/mm/yyyy" />  
								</td>
								<td>
									TIME
								</td>
								<td>
									<input class="sm-input" name="unloadingDelayDetentionStartTime#url.stopno#" id="unloadingDelayDetentionStartTime#url.stopno#" value="#variables.unloadingDelayDetentionStartTime#" type="text" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						ACTUAL DELIVERY DATE
					</td>
					<td class="leftfield">
						<input class="sm-input datePicker" tabindex=4 name="actualDeliveryDate#url.stopno#" id="actualDeliveryDate#url.stopno#" value="#variables.actualDeliveryDate#" validate="date" message="Please enter a valid actual delivery date" type="datefield" mask="dd/mm/yyyy" />  
					</td>
					<td class="rightlabel">
						UNLOADING DELAY-DETENTION END TIME
					</td>
					<td class="rightfield">
						<table>
							<tr>
								<td>
									<input class="sm-input datePicker" tabindex=4 name="unloadingDelayDetentionEndDate#url.stopno#" id="unloadingDelayDetentionEndDate#url.stopno#" value="#variables.unloadingDelayDetentionEndDate#" validate="date" message="Please enter a valid unloading delay-detention end time" type="datefield" mask="dd/mm/yyyy" />  
								</td>
								<td>
									TIME
								</td>
								<td>
									<input class="sm-input" name="unloadingDelayDetentionEndTime#url.stopno#" id="unloadingDelayDetentionEndTime#url.stopno#" value="#variables.unloadingDelayDetentionEndTime#" type="text" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="leftlabel">
						RETURN DATE
					</td>
					<td class="leftfield" colspan="3">
						<input class="sm-input datePicker" tabindex=4 name="returnDate#url.stopno#" id="returnDate#url.stopno#" value="#variables.returnDate#" validate="date" message="Please enter a valid return date" type="datefield" mask="dd/mm/yyyy" />  
					</td>		
				</tr>
			</table>

	</div>
	<div class="exportLoads"> 
		<table>
			<tr>
				<th class="exportLoadsheader" colspan="6">
					EXPORT LOADS
				</th>
			</tr>
			<tr style="height: 40px;">
				<td>
					TYPE TO SELECT
				</td>
				<td>
					<input class="ac_input typeAddress typeEmptyPickUpAddress" rel="exportEmptyPickUpAddress#url.stopno#" tabindex=4 id="typeEmptyPickUpAddress#url.stopno#" name="typeEmptyPickUpAddress#url.stopno#" value="TYPE NEW ADDRESS BELOW" type="text"/>
				</td>
				<td>
					TYPE TO SELECT
				</td>
				<td>
					<input class="ac_input typeAddress typeLoadingAddress" rel="exportLoadingAddress#url.stopno#" tabindex=4 id="typeLoadingAddress#url.stopno#" name="typeLoadingAddress#url.stopno#" value="TYPE NEW ADDRESS BELOW" type="text"/>
				</td>
				<td>
					TYPE TO SELECT
				</td>
				<td>
					<input class="ac_input typeAddress typeReturnAddress" rel="exportReturnAddress#url.stopno#" tabindex=4 id="typeReturnAddress#url.stopno#" name="typeReturnAddress#url.stopno#" value="TYPE NEW ADDRESS BELOW" type="text"/>
				</td>
			</tr>
			<tr>
				<td>
					EMPTY PICKUP ADDRESS
				</td>
				<td>
					<textarea id="exportEmptyPickUpAddress#url.stopno#"  cols="26" rows="6" name="exportEmptyPickUpAddress#url.stopno#">#variables.exportEmptyPickUpAddress#</textarea>
				</td>
				<td>
					LOADING ADDRESS
				</td>
				<td>
					<textarea id="exportLoadingAddress#url.stopno#"  cols="26" rows="6" name="exportLoadingAddress#url.stopno#">#variables.exportLoadingAddress#</textarea>
				</td>
				<td>
					RETURN ADDRESS
				</td>
				<td>
					<textarea id="exportReturnAddress#url.stopno#"  cols="26" rows="6" name="exportReturnAddress#url.stopno#" >#variables.exportReturnAddress#</textarea>
				</td>
			</tr>
		</table>
		<div class="lineBreak"></div>
		<table class="exportLoadsTable" cellspacing="0" cellpadding="0">
			<tr>
				<td class="leftlabel">
					DATE DISPATCHED TO TRUCKER
				</td>
				<td class="leftfield">
					<input class="sm-input datePicker" tabindex=4 name="exportDateDispatched#url.stopno#" id="exportDateDispatched#url.stopno#" value="#variables.exportDateDispatched#" validate="date" message="Please enter a valid date dispatched to trucker" type="datefield" mask="dd/mm/yyyy" />  
				</td>
				<td class="rightlabel">
					DATE MT AVAILABLE FOR PICKUP
				</td>
				<td class="rightfield">
					<input class="sm-input datePicker" tabindex=4 name="exportDateMtAvailableForPickup#url.stopno#" id="exportDateMtAvailableForPickup#url.stopno#" value="#variables.exportDateMtAvailableForPickup#" validate="date" message="Please enter a valid date mt available for pickup" type="datefield" mask="dd/mm/yyyy" />  
				</td>
			</tr>
			<tr>
				<td class="leftlabel">
					STEAMSHIP LINE
				</td>
				<td class="leftfield">
					<input class="ac_input" tabindex=4 value="#variables.exportSteamShipLine#" id="exportSteamShipLine#url.stopno#" name="exportSteamShipLine#url.stopno#" type="text" message="Please enter a valid export Steamship Line" />
				</td>
				<td class="rightlabel">
					DEMURRAGE-FREE TIME EXPIRATION DATE
				</td>
				<td class="rightfield">
					<input class="sm-input datePicker" tabindex=4 name="exportDemurrageFreeTimeExpirationDate#url.stopno#" id="exportDemurrageFreeTimeExpirationDate#url.stopno#" value="#variables.exportDemurrageFreeTimeExpirationDate#" validate="date" message="Please enter a valid export demurrage free time expiration date" type="datefield" mask="dd/mm/yyyy" />  
				</td>
			</tr>
			<tr>
				<td class="leftlabel">
					VESSEL NAME
				</td>
				<td class="leftfield">
					<input class="ac_input" tabindex=4 id="exportVesselName#url.stopno#" name="exportVesselName#url.stopno#" type="text" value="#variables.exportVesselName#" message="Please enter a valid vessel name" />
				</td>
				<td class="rightlabel">
					PER DIEM-FREE TIME EXPIRATION DATE
				</td>
				<td class="rightfield">
					<input class="sm-input datePicker" tabindex=4 name="exportPerDiemFreeTimeExpirationDate#url.stopno#" id="exportPerDiemFreeTimeExpirationDate#url.stopno#" value="#variables.exportPerDiemFreeTimeExpirationDate#" validate="date" message="Please enter a valid export Per Diem Free Time Expiration Date" type="datefield" mask="dd/mm/yyyy" />  
				</td>
			</tr>
			<tr>
				<td class="leftlabel">
					VOYAGE ##
				</td>
				<td class="leftfield">
					<input class="ac_input" tabindex=4 value="#variables.exportVoyage#" id="exportVoyage#url.stopno#" name="exportVoyage#url.stopno#" type="text" message="Please enter a valid export voyage" />
				</td>
				<td class="rightlabel">
					EMPTY PICKUP DATE
				</td>
				<td class="rightfield">
					<input class="sm-input datePicker" tabindex=4 name="exportEmptyPickupDate#url.stopno#" id="exportEmptyPickupDate#url.stopno#" value="#variables.exportEmptyPickupDate#" validate="date" message="Please enter a valid export Empty Pickup Date" type="datefield" mask="dd/mm/yyyy" />  
				</td>
			</tr>
			<tr>
				<td class="leftlabel">
					SEAL ##
				</td>
				<td class="leftfield" colspan="3">
					<input class="ac_input" tabindex=4 value="#variables.exportSeal#" id="exportSeal#url.stopno#" name="exportSeal#url.stopno#" type="text" message="Please enter a valid export seal" />
				</td>
			</tr>
			
			<tr>
				<td class="leftlabel">
					BOOKING ##
				</td>
				<td class="leftfield">
					<input class="ac_input" tabindex=4 value="#variables.exportBooking#" id="exportBooking#url.stopno#" name="exportBooking#url.stopno#" type="text" message="Please enter a valid export booking" />
				</td>
				<td class="rightlabel">
					SCHEDULED LOADING DATE
				</td>
				<td class="rightfield">
					<table>
						<tr>
							<td>
								<input class="sm-input datePicker" tabindex=4 name="exportScheduledLoadingDate#url.stopno#" id="exportScheduledLoadingDate#url.stopno#" value="#variables.exportScheduledLoadingDate#" validate="date" message="Please enter a valid export Scheduled Loading Date" type="datefield" mask="dd/mm/yyyy" />  
							</td>
							<td>
								TIME
							</td>
							<td>
								<input class="sm-input" name="exportScheduledLoadingTime#url.stopno#" id="exportScheduledLoadingTime#url.stopno#" value="#variables.exportScheduledLoadingTime#" type="text" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="leftlabel">
					VESSEL CUTOFF DATE
				</td>
				<td class="leftfield">
					<input class="sm-input datePicker" tabindex=4 name="exportVesselCutoffDate#url.stopno#" id="exportVesselCutoffDate#url.stopno#" value="#variables.exportVesselCutoffDate#" validate="date" message="Please enter a valid export vessel Cutoff Date" type="datefield" mask="dd/mm/yyyy" />  
				</td>
				<td class="rightlabel">
					LOADING DATE
				</td>
				<td class="rightfield">
					<input class="sm-input datePicker" tabindex=4 name="exportLoadingDate#url.stopno#" id="exportLoadingDate#url.stopno#" value="#variables.exportLoadingDate#" validate="date" message="Please enter a valid Export Loading Date" type="datefield" mask="dd/mm/yyyy" />  
				</td>
			</tr
			><tr>
				<td class="leftlabel">
					VESSEL LOADING WINDOW
				</td>
				<td class="leftfield">
					<input class="ac_input" tabindex=4 value="#variables.exportVesselLoadingWindow#" id="exportVesselLoadingWindow#url.stopno#" name="exportVesselLoadingWindow#url.stopno#" type="text" message="Please enter a valid export Vessel Loading Window" />
				</td>
				<td class="rightlabel">
					LOADING DELAY-DETECTION START TIME
				</td>
				<td class="rightfield">
					<table>
						<tr>
							<td>
								<input class="sm-input datePicker" tabindex=4 name="exportLoadingDelayDetectionStartDate#url.stopno#" id="exportLoadingDelayDetectionStartDate#url.stopno#" value="#variables.exportLoadingDelayDetectionStartDate#" validate="date" message="Please enter a valid export Loading Delay Detection Start Date" type="datefield" mask="dd/mm/yyyy" />  
							</td>
							<td>
								TIME
							</td>
							<td>
								<input class="sm-input" name="exportLoadingDelayDetectionStartTime#url.stopno#" id="exportLoadingDelayDetectionStartTime#url.stopno#" value="#variables.exportLoadingDelayDetectionStartTime#" type="text" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="leftlabel">
					REQUESTED LOADING DATE
				</td>
				<td class="leftfield">
					<table>
						<tr>
							<td>
								<input class="sm-input datePicker" tabindex=4 name="exportRequestedLoadingDate#url.stopno#" id="exportRequestedLoadingDate#url.stopno#" value="#variables.exportRequestedLoadingDate#" validate="date" message="Please enter a valid export Requested Loading Date" type="datefield" mask="dd/mm/yyyy" />  
							</td>
							<td>
								TIME
							</td>
							<td>
								<input class="sm-input" name="exportRequestedLoadingTime#url.stopno#" id="exportRequestedLoadingTime#url.stopno#" value="#variables.exportRequestedLoadingTime#" type="text" />
							</td>
						</tr>
					</table>
				</td>
				<td class="rightlabel">
					LOADING DELAY-DETECTION END TIME
				</td>
				<td class="rightfield">
					<table>
						<tr>
							<td>
								<input class="sm-input datePicker" tabindex=4 name="exportLoadingDelayDetectionEndDate#url.stopno#" id="exportLoadingDelayDetectionEndDate#url.stopno#" value="#variables.exportLoadingDelayDetectionEndDate#" validate="date" message="Please enter a valid export Loading Delay Detection End Date" type="datefield" mask="dd/mm/yyyy" />  
							</td>
							<td>
								TIME
							</td>
							<td>
								<input class="sm-input" name="exportLoadingDelayDetectionEndTime#url.stopno#" id="exportLoadingDelayDetectionEndTime#url.stopno#" value="#variables.exportLoadingDelayDetectionEndTime#" type="text" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="leftlabel">
					ETS
				</td>
				<td class="leftfield">
					<input class="sm-input datePicker" tabindex=4 name="exportETS#url.stopno#" id="exportETS#url.stopno#" value="#variables.exportETS#" validate="date" message="Please enter a valid export ETS" type="datefield" mask="dd/mm/yyyy" />  
				</td>
				<td class="rightlabel">
					RETURN DATE
				</td>
				<td class="rightfield">
					<input class="sm-input datePicker" tabindex=4 name="exportReturnDate#url.stopno#" id="exportReturnDate#url.stopno#" value="#variables.exportReturnDate#" validate="date" message="Please enter a valid export Return Date" type="datefield" mask="dd/mm/yyyy" />  
				</td>
			</tr>
		</table>
	</div>
	<div class="carrier-gap"></div>
	<cfif  structkeyexists(url,"loadid") and len(trim(url.loadid)) gt 1>
		<cfset loadID = url.loadid>
		<cfif structkeyexists (session,"empid")>		
			<cfif Session.empid neq "">
				<cfinvoke component="#variables.objloadGateway#" method="checkEditLoadIdExists" loadid="#loadID#"  returnvariable="request.EditLoadIdDetails"/>
				<cfif request.EditLoadIdDetails.recordcount>
						 <script  type="text/javascript">
							$(function() {
								$('input').prop('readonly',true);
								$('option:not(:selected)').attr('readonly', true);
								$("input:checkbox").on('click',function(){
								   $(this).prop('checked',!$(this).is(':checked'));
								});
								$( ".ui-datepicker-trigger" ).css( "display","none" );
								$("textarea").prop('readonly', true);
								$('input').unbind( "focus" );
								$('textarea').unbind( "focus" );
								return false;
							});
						</script>
					<cfelse>
						<cfinvoke component="#variables.objloadGateway#" method="insertUserEditingLoad" loadid="#loadID#" returnvariable="request.EditLoadIdDetails"/>
					</cfif>
				
			</cfif>
		</cfif>	
		<cfif structkeyexists (session,"customerid")>
			<cfif Session.customerid neq "">	
				<cfinvoke component="#variables.objloadGateway#" method="insertUserEditingLoad" loadid="#loadID#" returnvariable="request.EditLoadIdDetails"/>
			</cfif>
		</cfif>
	</cfif>	
</cfoutput>