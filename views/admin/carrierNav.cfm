<cfparam name="event" default="carrier">
<cfparam name="url.maintenanceWithEquipment" default="0">
<cfinvoke component="#variables.objloadGateway#" method="getLoadSystemSetupOptions" returnvariable="request.qSystemSetupOptions1" />
<cfoutput>
<div class="below-navleft">
	<ul>
		<li>
			<a href="index.cfm?event=carrier&#session.URLToken#" class="navbarDriverAdjust <cfif event is 'carrier' or event is 'addcarrier:process' or event is 'addcarrier'>active</cfif>">
				<cfif request.qSystemSetupOptions1.freightBroker>
					Carriers
				<cfelse>
					Drivers
				</cfif>
			</a>
		</li>
        <!---<li><a href="index.cfm?event=carrierselection&#session.URLToken#" <cfif event is 'carrierselection'> class="active" </cfif>>Carrier</a></li>--->
		<!--- <li><a href="index.cfm?event=addcarrier&#session.URLToken#" <cfif event is 'addcarrier'> class="active" </cfif>>Add&nbsp;Carrier</a></li> --->
		<li>
			<a href="index.cfm?event=equipment&#session.URLToken#" class="navbarDriverAdjust <cfif event is 'equipment' or event is 'addequipment:process' or event is 'addequipment' or event is 'addDriverEquipment:process' or event is 'addDriverEquipment' or event is 'addNewMaintenanceTransaction' or event is 'addNewMaintenance:process' or event is 'addNewMaintenance'><cfif url.maintenanceWithEquipment neq 1>active</cfif></cfif>" >
				Equipment
			</a>
		</li>
		<cfif not request.qSystemSetupOptions1.freightBroker>
			<li>
				<a href="index.cfm?event=equipment&EquipmentMaint=1&maintenanceWithEquipment=1&#session.URLToken#" class="navbarDriverAdjust <cfif event is 'equipment' > <cfif url.maintenanceWithEquipment eq 1> active</cfif> </cfif>" >
				Equipment Maintenance 
				</a>
			</li>
			<li>
				<a href="index.cfm?event=maintenanceSetUp&#session.URLToken#" class="navbarDriverAdjust <cfif event is 'maintenanceSetUp' or event is 'addMaintenanceSetUp'>active</cfif>" >
				Equipment Maintenance Setup
				</a>
			</li>
			<li>
				<a href="index.cfm?event=iftaDownload&#session.URLToken#" class="navbarDriverAdjust <cfif event is 'iftaDownload'>active</cfif>" >
				IFTA Download
				</a>
			</li>
		</cfif>
        <!--- <li><a href="index.cfm?event=addequipment&#session.URLToken#" <cfif event is 'addequipment'> class="active" </cfif>>Add&nbsp;Equipmentr</a></li> --->
		<!--- <li><a href="index.cfm?event=unit&#session.URLToken#" <cfif event is 'unit' or event is 'addunit:process' or event is 'addunit'> class="active" </cfif>>Unit</a></li> --->
        <!--- <li><a href="index.cfm?event=addunit&#session.URLToken#" <cfif event is 'addunit'> class="active" </cfif>>Add&nbsp;Unit</a></li> --->
		<!--- <li><a href="index.cfm?event=class&#session.URLToken#" <cfif event is 'class' or event is 'addclass:process' or event is 'addclass'> class="active" </cfif>>Class</a></li> --->
        <!--- <li><a href="index.cfm?event=addclass&#session.URLToken#" <cfif event is 'addclass'> class="active" </cfif>>Add&nbsp;Class</a></li> --->
		<!---<li><a href="index.cfm?event=shipper&#session.URLToken#" <cfif event is 'shipper' or event is 'addshipper:process'> class="active" </cfif>>Shipper</a></li>
		 <li><a href="index.cfm?event=addshipper&#session.URLToken#" <cfif event is 'addshipper'> class="active" </cfif>>Add&nbsp;Shipper</a></li>
		<li><a href="index.cfm?event=consignee&#session.URLToken#" <cfif event is 'consignee' or event is 'addconsignee:process'> class="active" </cfif>>Consignee</a></li>
		<li><a href="index.cfm?event=addconsignee&#session.URLToken#" <cfif event is 'addconsignee'> class="active" </cfif>>Add&nbsp;Consignee</a></li> --->
	</ul>
<div class="clear"></div>
</div>
<div class="below-navright">
	<p align="right">Logged in : <cfif isdefined('session.AdminUserName')> #session.AdminUserName# </cfif></p>
</div>
<div style="float:right;margin-right:10px;margin-top:-55px;"><a href="index.cfm?event=feedback&#Session.URLToken#"><img src="images/fdbk.png" width="100px" border="0"></a></div>

</cfoutput>