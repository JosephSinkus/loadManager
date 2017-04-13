<cfoutput>
<cfif structkeyExists(url,"dsn")>
<!--- Decrypt String --->
<cfset TheKey = 'NAMASKARAM'>
<cfset dsn = Decrypt(ToString(ToBinary(url.dsn)), TheKey)>
</cfif>
 
<cfif structkeyexists(url,"loadno") or structkeyexists(url,"loadid")>
	<cfquery name="BOLReport" datasource="#dsn#">
		SELECT         l.LoadID, l.LoadNumber, l.CustomerPONo AS RefNo, l.Address AS custaddress, l.City AS custcity, l.StateCode AS custstate, l.PostalCode AS custpostalcode, 
                         l.Phone AS custphone, l.Fax AS custfax, l.CellNo AS custcell, l.CustName AS custname, l.EmergencyResponseNo, l.CODAmt, l.CODFee, l.DeclaredValue, l.Notes, 
                         stops.shipperState, stops.shipperCity, stops.consigneeState, stops.consigneeCity, carr.CarrierName, stops.LoadStopID, stops.StopNo, 
                         l.NewPickupDate AS PickupDate, l.NewPickupTime AS PickupTime, l.NewDeliveryDate AS DeliveryDate, l.NewDeliveryTime AS DeliveryTime, 
                         stops.shipperStopName, stops.consigneeStopName, stops.shipperLocation, stops.consigneeLocation, stops.shipperPostalCode, stops.consigneePostalCode, 
                         stops.shipperContactPerson, stops.consigneeContactPerson, stops.shipperPhone, stops.consigneePhone, stops.shipperFax, stops.consigneeFax, 
                         stops.shipperEmailID, stops.consigneeEmailID, stops.shipperBlind, stops.consigneeBlind, stops.shipperDriverName, stops.consigneeDriverName, BOL.SrNo, 
                         ISNULL(BOL.Qty, 0) AS Qty, BOL.Description, ISNULL(BOL.Weight, 0) AS Weight, BOL.classid, BOL.Hazmat, BOL.LoadStopIDBOL, CarrierTerms.CarrierTerms, 
                         dbo.Companies.CompanyName, dbo.Companies.address, dbo.Companies.address2, dbo.Companies.city, dbo.Companies.state, dbo.Companies.zipCode,offi.ContactNo as Phone,offi.faxno as fax
FROM            dbo.Loads AS l LEFT OUTER JOIN
                             (SELECT        a.LoadID, a.LoadStopID, a.StopNo, a.NewCarrierID, a.NewOfficeID, a.City AS shipperCity, b.City AS consigneeCity, a.CustName AS shipperStopName, 
                                                         b.CustName AS consigneeStopName, a.Address AS shipperLocation, b.Address AS consigneeLocation, a.PostalCode AS shipperPostalCode, 
                                                         b.PostalCode AS consigneePostalCode, a.ContactPerson AS shipperContactPerson, b.ContactPerson AS consigneeContactPerson, 
                                                         a.Phone AS shipperPhone, b.Phone AS consigneePhone, a.Fax AS shipperFax, b.Fax AS consigneeFax, a.EmailID AS shipperEmailID, 
                                                         b.EmailID AS consigneeEmailID, a.StopDate AS shipperStopDate, b.StopDate AS consigneeStopDate, a.StopTime AS shipperStopTime, 
                                                         b.StopTime AS consigneeStopTime, a.TimeIn AS shipperStopTimeIn, b.TimeIn AS consigneeStopTimeIn, a.TimeOut AS shipperStopTimeOut, 
                                                         b.TimeOut AS consigneeStopTimeOut, a.ReleaseNo AS shipperReleaseNo, b.ReleaseNo AS consigneeReleaseNo, a.Blind AS shipperBlind, 
                                                         b.Blind AS consigneeBlind, a.Instructions AS shipperInstructions, b.Instructions AS consigneeInstructions, a.Directions AS shipperDirections, 
                                                         b.Directions AS consigneeDirections, a.LoadStopID AS shipperLoadStopID, b.LoadStopID AS consigneeLoadStopID, 
                                                         a.NewBookedWith AS shipperBookedWith, b.NewBookedWith AS consigneeBookedWith, a.NewEquipmentID AS shipperEquipmentID, 
                                                         b.NewEquipmentID AS consigneeEquipmentID, a.NewDriverName AS shipperDriverName, b.NewDriverName AS consigneeDriverName, 
                                                         a.NewDriverCell AS shipperDriverCell, b.NewDriverCell AS consigneeDriverCell, a.NewTruckNo AS shipperTruckNo, 
                                                         b.NewTruckNo AS consigneeTruckNo, a.NewTrailorNo AS shipperTrailorNo, b.NewTrailorNo AS consigneeTrailorNo, a.RefNo AS shipperRefNo, 
                                                         b.RefNo AS consigneeRefNo, a.Miles AS shipperMiles, b.Miles AS consigneeMiles, a.CustomerID AS shipperCustomerID, 
                                                         b.CustomerID AS consigneeCustomerID, a.StateCode AS shipperState, b.StateCode AS consigneeState
                               FROM            dbo.LoadStops AS a INNER JOIN
                                                         dbo.LoadStops AS b ON a.LoadID = b.LoadID AND a.StopNo = b.StopNo
                               WHERE        (a.LoadID = '#url.loadid#') AND (a.LoadType = 1) AND (b.LoadType = 2) AND (a.ForBOL = 1) AND (b.ForBOL = 1)) AS stops ON 
                         stops.LoadID = l.LoadID LEFT OUTER JOIN
                             (SELECT        CarrierID, CarrierName
                               FROM            dbo.Carriers) AS carr ON carr.CarrierID = stops.NewCarrierID LEFT OUTER JOIN
                             (SELECT        CarrierTerms
                               FROM            dbo.SystemConfig) AS CarrierTerms ON 1 = 1 LEFT OUTER JOIN
                             (SELECT        ISNULL(dbo.LoadStopsBOL.SrNo, '') AS SrNo, ISNULL(dbo.LoadStopsBOL.Qty, 0) AS Qty, ISNULL(dbo.LoadStopsBOL.Description, '') AS Description, 
                                                         ISNULL(dbo.LoadStopsBOL.Weight, 0) AS Weight, dbo.CommodityClasses.ClassName AS classid, ISNULL(dbo.LoadStopsBOL.Hazmat, '') AS Hazmat, 
                                                         dbo.LoadStopsBOL.loadStopIdBOL AS LoadStopIDBOL
                               FROM            dbo.LoadStopsBOL LEFT OUTER JOIN
                                                         dbo.CommodityClasses ON dbo.LoadStopsBOL.ClassID = dbo.CommodityClasses.ClassID) AS BOL ON BOL.LoadStopIDBOL = l.LoadID CROSS JOIN
                         dbo.Companies left outer join (select ContactNo,FaxNo,officeid from offices ) as offi  on offi.officeid=l.officeid
WHERE        (l.LoadID = '#url.loadid#')
ORDER BY l.LoadNumber
	</cfquery>
	<cfreport format="PDF" template="BOLReport.cfr" query="#BOLReport#">
	</cfreport> 	 
<cfelse>
	Unable to generate the report. Please specify the load Number or Load ID	
</cfif>
</cfoutput>	