<!--- Insert Record in Invoices Table --->
<cffunction name="insertInInvoices" returntype="void">
	<cfargument name="qLoadsRow" required="yes" type="query">
    
    <cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#qLoadsRow.PayerID#" returnvariable="qCustomer" />
    <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" stateID="#qCustomer.StateID#" returnvariable="qState" />
    
    <cfinvoke component="#variables.objloadGateway#" method="getNoOfStops" LOADID="#qLoadsRow.LoadID#" returnvariable="request.NoOfStops" />
	<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#qLoadsRow.LoadID#" stopNo="#request.NoOfStops#" returnvariable="qLoadsLastStop" />
    
    <cfset itemDescriptions = 'Miles: #DollarFormat(qLoadsRow.customerMilesCharges )#, Flate Rate: #DollarFormat(qLoadsRow.CustFlatRate )#, Commodities/Other: #DollarFormat(qLoadsRow.customerCommoditiesCharges )#'>
    <cfset invTotal = qLoadsRow.customerMilesCharges + qLoadsRow.CustFlatRate + qLoadsRow.customerCommoditiesCharges>
    <!---<cfoutput>
    <br /><br />
    <strong>insertInvoices</strong>
    <br />	
    		LoadNum #qLoadsRow.LoadNumber#<br />
			InvDate #DateFormat(NOW(),'mm/dd/yyyy')#<br />
			PONum #qLoadsRow.CustomerPONo#<br />
            ItemNames 'Load'<br />
			ItemDescriptions #itemDescriptions#<br />
            ItemTotalAmount #DollarFormat(invTotal)#<br />
            ItemQuantities '1'<br />
            ItemUnitPrice #DollarFormat(invTotal)#<br />
            ItemTaxable 'N'<br />
            TotalInvoiceAmount #DollarFormat(invTotal)#<br />
            DueDate #DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#<br />
            PaymentTerms 'See Contract'<br />
            BookLoad '-1'<br />
            BillDate #DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#<br />
			CustomerName #qCustomer.CustomerName#<br />
			Street #qCustomer.Location#<br />
			City #qCustomer.City#<br />
			State #qState.StateCode#<br />
			Zip #qCustomer.Zipcode#<br />
			PickUpTelephone #qCustomer.PhoneNo# <br />
            BillToAddr #qCustomer.Location#, #qCustomer.City#, #qState.StateCode#.<br />
    </cfoutput>--->

        <cfquery name="QInsertInInvoice" datasource="accessQB">
            INSERT INTO Invoices (LoadNum, InvDate, PONum, ItemNames, ItemDescriptions, ItemTotalAmount, ItemQuantities, ItemUnitPrice, ItemTaxable, TotalInvoiceAmount, DueDate, PaymentTerms, BookLoad, BillDate, CustomerName, Street, City, State, Zip, PickUpTelephone, BillToAddr)
            VALUES ('#qLoadsRow.LoadNumber#', '#DateFormat(NOW(),'mm/dd/yyyy')#', '#qLoadsRow.CustomerPONo#', 'Load', '#itemDescriptions#', '#DollarFormat(invTotal)#', '1', '#DollarFormat(invTotal)#', 'N', '#DollarFormat(invTotal)#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', 'See Contract', '-1', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '#qCustomer.CustomerName#', '#qCustomer.Location#', '#qCustomer.City#', '#qState.StateCode#', '#qCustomer.Zipcode#', '#qCustomer.PhoneNo#', '#qCustomer.Location#, #qCustomer.City#, #qState.StateCode#.')
        </cfquery>
        
        <cfquery name="QLoadARStatusUpdate" datasource="#application.dsn#">
            UPDATE Loads
            SET ARExported = '1'
            WHERE LoadID = '#qLoadsRow.LoadID#'
        </cfquery>
</cffunction>


<!--- Insert Record in Bills Table --->
<cffunction name="insertInBills" returntype="void">
	<cfargument name="qLoadsRow" required="yes" type="query">
    

    <cfinvoke component="#variables.objCarrierGateway#" method="getAllCarriers" CustomerID="#qLoadsRow.shipperID#" returnvariable="qCarrier" />
    <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" stateID="#qCarrier.StateID#" returnvariable="qState" />
    <cfinvoke component="#variables.objCutomerGateway#" method="getAllCustomers" CustomerID="#qLoadsRow.PayerID#" returnvariable="qCustomer" />
    <cfinvoke component="#variables.objAgentGateway#" method="getAllStaes" stateID="#qCustomer.StateID#" returnvariable="qState" />
    
    <cfinvoke component="#variables.objloadGateway#" method="getNoOfStops" LOADID="#qLoadsRow.LoadID#" returnvariable="request.NoOfStops" />
	<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#qLoadsRow.LoadID#" stopNo="#request.NoOfStops#" returnvariable="qLoadsLastStop" />
    
    <cfset invTotal = qLoadsRow.carrierMilesCharges + qLoadsRow.carrFlatRate + qLoadsRow.carrierCommoditiesCharges>
    <cfoutput>
        <br /><br />
        <strong>insertBills</strong>
        <br />
        LoadNum #qLoadsRow.LoadNumber#<br />
        PickUpDate #DateFormat(qLoadsRow.PickupDate,'mm/dd/yyyy')#<br />
        DateDelv #DateFormat(qLoadsRow.DeliveryDate,'mm/dd/yyyy')#<br />
        DueDate #DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#<br />
        Carrier #qCarrier.CarrierName# <br />
        Account 'Purchasing'<br />
        Total #DollarFormat(invTotal)#<br />
        BookLoad '-1'<br />
        FactorName #qCarrier.CarrierName#<br />
        FactorMailTo #qCarrier.Address#<br />
        FactorCity #qCarrier.City#<br />
        FactorSt #qCarrier.statecode#<br />
        FactorZip #qCarrier.ZipCode#<br />
        BilledDate #DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#<br />
        BillDate #DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#<br />
        Memo ''<br />
        Terms 'See Contract'<br />
        CustomerCode #qCustomer.CustomerCode#<br />
        VendorCode #qCarrier.MCNumber#<br />
        CarrierName #qCarrier.CarrierName#<br />
        CarrierRemitAddr #qCarrier.Address#<br />
        CarrierRemitCity #qCarrier.City#<br />
        CarrierRemitSt #qCarrier.statecode#<br />
        CarrierRemitZip #qCarrier.ZipCode#<br />
        TollFree #qCarrier.TollFree#<br />
    </cfoutput>
    
        <cfquery name="QInsertInBills" datasource="accessQB">
            INSERT INTO Bills (LoadNum, PickUpDate, DateDelv, DueDate, Carrier, Account, Total, BookLoad, FactorName, FactorMailTo, FactorCity, FactorSt, FactorZip, BilledDate, BillDate, Memo, Terms, CustomerCode, VendorCode, CarrierName, CarrierRemitAddr, CarrierRemitCity, CarrierRemitSt, CarrierRemitZip, TollFree)
            VALUES ('#qLoadsRow.LoadNumber#', '#DateFormat(qLoadsRow.PickupDate,'mm/dd/yyyy')#', '#DateFormat(qLoadsRow.DeliveryDate,'mm/dd/yyyy')#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '#qCarrier.CarrierName#', 'Purchasing', '#DollarFormat(invTotal)#', '-1', '#qCarrier.CarrierName#', '#qCarrier.Address#', '#qCarrier.City#', '#qCarrier.statecode#', '#qCarrier.ZipCode#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '#DateFormat(qLoadsLastStop.DeliveryDate,'mm/dd/yyyy')#', '', 'See Contract', '#qCustomer.CustomerCode#', '#qCarrier.MCNumber#', '#qCarrier.CarrierName#', '#qCarrier.Address#', '#qCarrier.City#', '#qCarrier.statecode#', '#qCarrier.ZipCode#', '#qCarrier.TollFree#')
        </cfquery>
        
        <cfquery name="QLoadAPStatusUpdate" datasource="#application.dsn#">
            UPDATE Loads
            SET APExported = '1'
            WHERE LoadID = '#qLoadsRow.LoadID#'
        </cfquery>
</cffunction>


<!--- Functions definitions end here --->

<cfsilent>
	<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
	<cfinvoke component="#variables.objloadGateway#" method="getSearchLoads" LoadStatus="#request.qGetSystemSetupOptions.ARAndAPExportStatusID#" searchText="" pageNo="1" returnvariable="qLoads" />
</cfsilent>


<cfoutput>
<html>
	<head></head>
	<body>
        <cfquery name="qTruncateOldInvoiceData" datasource="accessQB">
            DELETE FROM Invoices
            WHERE 1=1
        </cfquery>
        
        <cfquery name="qTruncateOldBillsData" datasource="accessQB">
            DELETE FROM Bills
            WHERE 1=1
        </cfquery>
        
        <cfset customerTypeExportsCount = 0>
        <cfset carrierTypeExportsCount = 0>
        <cfset bothTypeExportsCount = 0>
        
        <cfloop query="qLoads">
        	
            <cfif not isdefined('request.qLoads.orderDate') OR request.qLoads.orderDate eq ''>
            	<cfset orderDate = DateFormat(NOW(),'mm/dd/yyyy')>
            <cfelse>
            	<cfset orderDate = DateFormat(qLoads.orderDate,'mm/dd/yyyy')>
            </cfif>
            
            <cfset dateFrom = DateFormat(url.dateFrom,'mm/dd/yyyy')>
            <cfset dateTo = DateFormat(url.dateTo,'mm/dd/yyyy')>
            
            
        	<cfif (qLoads.ARExportedNN eq '1' AND qLoads.APExportedNN eq '1') OR (orderDate LT dateFrom OR orderDate GT dateTo)>
            	<cfcontinue>
            <cfelseif qLoads.ARExportedNN eq '1'> <!--- Already Exported for Customer now just need to export for Client(Bills Table) --->
            	<!--- Insert in Bills --->
                <cfinvoke method="insertInBills">
                	<cfinvokeargument name="qLoadsRow" value="#qLoads#">
                </cfinvoke>
                
                
            	<cfset customerTypeExportsCount = customerTypeExportsCount + 1>
                
            <cfelseif qLoads.APExportedNN eq '1'> <!--- Already Exported for Client now just need to export for Customer(Invoices Table) --->
            	<!--- Insert in Invoices --->
                
            	<cfset carrierTypeExportsCount = carrierTypeExportsCount + 1>
                
            <cfelse> <!--- Not Exported yet for Client or Customer export to both tables(Invoices Table, Bills table) --->
            	<!--- Insert in Invoices --->
                <cfinvoke method="insertInBills">
                	<cfinvokeargument name="qLoadsRow" value="#qLoads#">
                </cfinvoke>
                
                <cfinvoke method="insertInInvoices">
                	<cfinvokeargument name="qLoadsRow" value="#qLoads#">
                </cfinvoke>
                
                
            	<cfset bothTypeExportsCount = bothTypeExportsCount + 1>
            </cfif>
            
            
        </cfloop>
        
        <!---<cfloop query="updateBQAccessFile">
        	output: #updateBQAccessFile.LoadNum# - #updateBQAccessFile.InvDate# - #updateBQAccessFile.PONum#
        </cfloop>--->
        
        
        
        <cfset filePath = request.webpath&"/../views/templates/QBData.mdb">
        <!---<cfheader name="content-disposition" value="attachment;filename=views/templates/QBData.mdb">--->
	</body>
</html>
<script>
	alert('#customerTypeExportsCount# Loads exported for Customer\n#carrierTypeExportsCount# Loads exported for Carrier.\n#bothTypeExportsCount# Loads exported for both Customer and Client');
	window.open('#filePath#');
	window.focus();
	window.close();
</script>
</cfoutput>