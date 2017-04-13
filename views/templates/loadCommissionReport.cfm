<cfsilent>
<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
<cfinvoke component="#variables.objCutomerGateway#" method="getCompanies" returnvariable="request.qCompanies">

<cfset groupBy = url.groupBy>
<cfset orderDateFrom = url.orderDateFrom>
<cfset orderDateTo = url.orderDateTo>
<cfset deductionPercentage = url.deductionPercentage>
<cfset salesRepFrom = url.salesRepFrom>
<cfset salesRepFromForQuery = url.salesRepFrom>
<cfset salesRepTo = url.salesRepTo>
<cfset salesRepToForQuery = url.salesRepTo>
<cfset dispatcherFrom = url.dispatcherFrom>
<cfset dispatcherFromForQuery = url.dispatcherFrom>
<cfset dispatcherTo = url.dispatcherTo>
<cfset dispatcherToForQuery = url.dispatcherTo>
<cfset marginRangeFrom = url.marginRangeFrom>
<cfset marginRangeTo = url.marginRangeTo>
<cfset deductionPercentage = url.deductionPercentage>
<cfset commissionPercentage = url.commissionPercentage>
<cfset reportType = url.reportType>
<cfset statusTo = url.statusTo>
<cfset statusFrom = url.statusFrom>
<!---<cfif NumberFormat(request.qGetSystemSetupOptions.DeductionPercentage,'0.00') eq 0.00>
	<cfset deductionPercentage = url.deductionPercentage>
<cfelse>
	<cfset deductionPercentage = NumberFormat(request.qGetSystemSetupOptions.DeductionPercentage,'0.00')>
</cfif>--->
<cfif salesRepFrom eq "AAAA">
	<cfset salesRepFrom = "########">
    <cfset salesRepFromForQuery = "">
</cfif>
<cfif salesRepTo eq "AAAA">
	<cfset salesRepTo = "########">
    <cfset salesRepToForQuery = "">
</cfif>

<cfif dispatcherFrom eq "AAAA">
	<cfset dispatcherFrom = "########">
    <cfset dispatcherFromForQuery = "">
</cfif>
<cfif dispatcherTo eq "AAAA">
	<cfset dispatcherTo = "########">
    <cfset dispatcherToForQuery = "">
</cfif>


<cfinvoke component="#variables.objloadGateway#" method="getCommissionReportInfo" returnvariable="request.qReportLoads">
	<cfinvokeargument name="groupBy" value="#groupBy#">
    <cfinvokeargument name="orderDateFrom" value="#orderDateFrom#">
    <cfinvokeargument name="orderDateTo" value="#orderDateTo#">
    <cfinvokeargument name="salesRepFrom" value="#salesRepFromForQuery#">
    <cfinvokeargument name="salesRepTo" value="#salesRepToForQuery#">
    <cfinvokeargument name="dispatcherFrom" value="#dispatcherFromForQuery#">
    <cfinvokeargument name="dispatcherTo" value="#dispatcherToForQuery#">
	<cfinvokeargument name="statusTo" value="#statusTo#">
	<cfinvokeargument name="statusFrom" value="#statusFrom#">
</cfinvoke>

<cfif groupBy eq "salesAgent">
	<cfset groupBy = "Sales Agent">
<cfelse>
	<cfset groupBy = "Dispatcher">
</cfif>

</cfsilent>


<cfdocument format="PDF" name="cfdoc" margintop="1.3" scale="90">

<cfoutput>

<html>
        <head>
                <META http-equiv="Content-Type" content="text/html; charset=utf-8">
                <title>Commission Report</title>
                <style type="text/css">
					
                </style>
        </head>
        <body>
        	<cfdocumentitem type="header"> <!--- Header Opening --->
				<table width="100%" cellspacing="0" style="border:0px solid black; font-size:10px;">
                	<tr>
                    	<td align="left"> #request.qCompanies.CompanyName#</td>
                    </tr>
                </table>
        
                <table width="100%" cellspacing="0" style="border:0px solid black; font-size:12px;">
                	<tr>
                		<td align="center" colspan="5" style="font-size:22px; height:50px; font-weight:bold;">Sales Rep #reportType#</td>
                    </tr>
                    <tr style="width:100%;">
                    	<td align="right" style="width:54%;">&nbsp;  </td>
                        <td align="left" style="width:3%; font-weight:bold;"> From: </td>
                        <td align="left" style="width:15%;"> #orderDateFrom# </td>
                        <td align="left" style="width:3%; font-weight:bold;"> To: </td>
                        <td align="right" style="width:25%;"> #orderDateTo# </td>
                    </tr>
                    <tr style="width:100%;">
                    	<td align="right" width="64%">&nbsp;  </td>
                        <td align="left" width="3%" style="font-weight:bold;"> From: </td>
                        <td align="left" width="15%"> #salesRepFrom# </td>
                        <td align="left" width="3%" style="font-weight:bold;"> To: </td>
                        <td align="right" width="15%"> #salesRepTo# </td>
                    </tr>
                    <tr style="width:100%;">
                    	<td align="right" width="64%">&nbsp;  </td>
                        <td align="left" width="3%" style="font-weight:bold;"> From: </td>
                        <td align="left" width="15%"> #dispatcherFrom# </td>
                        <td align="left" width="3%" style="font-weight:bold;"> To: </td>
                        <td align="right" width="15%"> #dispatcherTo# </td>
                    </tr>
                    <tr style="width:100%;">
                    	<td align="right" width="64%">&nbsp;  </td>
                        <td align="left" width="3%" style="font-weight:bold;"> From: </td>
                        <td align="left" width="15%"> #DollarFormat(marginRangeFrom)# </td>
                        <td align="left" width="3%" style="font-weight:bold;"> To: </td>
                        <td align="right" width="15%"> #DollarFormat(marginRangeTo)# </td>
                    </tr>
                    <tr style="width:100%;">
                    	<td align="right" width="64%">&nbsp;  </td>
                        <td align="left" width="3%" style="font-weight:bold;"> By: </td>
                        <td align="left" width="15%"> #groupBy# </td>
                        <td align="left" width="3%">&nbsp;  </td>
                        <td align="right" width="15%">&nbsp;  </td>
                    </tr>
				</table>
                <!---<table width="100%" cellpadding="2px" cellspacing="0" style="table-layout:fixed; border:0px solid black; font-size:12px;">
                   <tr style="width:100%;">
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Load## </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Order Date </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Customer </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> First Stop </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Last Stop </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Cust. Total </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Carr. Total </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Gross Margin </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Carrier </td>
                        <td align="center" colspan="2" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Commission </td>
                    </tr>
                </table>--->
            </cfdocumentitem> <!--- Header Closing --->
            
            <p style="page-break-inside:avoid">
            <table width="100%" cellpadding="2px" cellspacing="0" style="table-layout:fixed; border:0px solid black; font-size:12px;">
               <tr style="width:100%;">
                	<td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Load## </td>
                	<td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Order Date </td>
                    <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Customer </td>
                	<td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> First Stop </td>
                    <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Last Stop </td>
                    <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Cust. Total </td>
                    <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Carr. Total </td>
                    <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Gross Margin </td>
                    <td align="center" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Carrier </td>
					<cfif reportType EQ 'Commission'>
	                    <td align="center" colspan="2" style="overflow:hidden; white-space:nowrap; border-bottom:1 solid ##000000; padding-top:15px; font-weight:bold;"> Commission </td>
					</cfif>
                </tr>
                
                <cfset sumCustomerTotals=0>
                <cfset sumCarrierTotals=0>
                <cfset sumCommissions=0>
                <cfset sumGrossMargins=0>
                <cfset sumProfits=0>
                <cfset numOfLoads=0>
                
                <cfset grandSumCustomerTotals=0>
                <cfset grandSumCarrierTotals=0>
                <cfset grandSumCommissions=0>
                <cfset grandSumGrossMargins=0>
                <cfset grandSumProfits=0>
                
                <cfset matchPrinted="false">
                <cfset prevGroupByName = "">
                <cfloop query="request.qReportLoads">
                	<cfif groupBy eq "Sales Agent">
                        <cfset groupByName = request.qReportLoads.salesAgentName>
                    <cfelse>
                    	<cfset groupByName = request.qReportLoads.dispatcherName>
                    </cfif>
                    
                    <cfif request.qReportLoads.CarrierID neq '' AND Len(request.qReportLoads.CarrierID) gt 1>
                    	<cfinvoke component="#variables.objCarrierGateway#" method="getCarriersInfo" carrierid="#request.qReportLoads.CarrierID#" returnvariable="request.qCarrier" />
                        <cfset carrierName = request.qCarrier.CarrierName>
                    <cfelse>
                        <cfset carrierName = ''>
                    </cfif>
                    
                    
                    
                    <cfinvoke component="#variables.objloadGateway#" method="getNoOfStops" LOADID="#request.qReportLoads.LoadID#" returnvariable="request.NoOfStops" />
					
					<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#request.qReportLoads.LoadID#" stopNo="0" returnvariable="request.qLoadsFirstStop" />
					<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#request.qReportLoads.LoadID#" stopNo="#request.NoOfStops#" returnvariable="request.qLoadsLastStop" />
					
                    <!---<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#request.qReportLoads.LoadID#" stopNo="0" returnvariable="request.qLoadsFirstStop" />
					<cfinvoke component="#variables.objloadGateway#" method="getAllLoads" loadid="#request.qReportLoads.LoadID#" stopNo="#request.NoOfStops#" returnvariable="request.qLoadsLastStop" />--->
                    
                    
					<!---<cfset shipCustomerStopId=request.qLoadsFirstStop.SHIPPERID>
					<cfinvoke component="#variables.objCutomerGateway#" method="getAllstop" CustomerStopID="#shipCustomerStopId#" returnvariable="request.ShipperStop" />
                    <cfquery name="qShipperState" datasource="#application.dsn#">
                        select StateCode from states where StateID = '#request.ShipperStop.StateID#'
                     </cfquery>
                    
        			
                    <cfset consigneeCustomerStopId=request.qLoadsLastStop.CONSIGNEEID>
					<cfinvoke component="#variables.objCutomerGateway#" method="getAllstop" CustomerStopID="#consigneeCustomerStopId#" returnvariable="request.ConsineeStop" />
                    <cfquery name="qConsigneeState" datasource="#application.dsn#">
                        select StateCode from states where StateID = '#request.ConsineeStop.StateID#'
                     </cfquery>--->
                    
                    
                    <cfinvoke component="#variables.objAgentGateway#" method="getAllAgent" agentId="#request.qReportLoads.SalesRepID#" returnvariable="request.qAgent" />

                    <!--- Calculating Commission --->
                    <cfset commissionPercentageInDollars = (request.qReportLoads.grossProfit/100)*commissionPercentage>
                    <cfset deductionPercentageInDollars =  (request.qReportLoads.grossProfit/100)*deductionPercentage>
                    <cfset commission = commissionPercentageInDollars - deductionPercentageInDollars >
                    
                    <!--- Calculating Gross Margin ---> <!--- Gross Margin = Total Profit --->
                    <cfset grossMargin = (request.qReportLoads.TotalCustomerCharges - request.qReportLoads.TotalCarrierCharges - deductionPercentageInDollars)>
                    
                    <cfif marginRangeFrom neq 0 OR marginRangeTo neq 0> <!--- If both are zero, include all margins --->
						<cfif grossMargin gte marginRangeFrom AND grossMargin lte marginRangeTo>
                            <!--- Continue With Normal Loop-Iteration --->
                        <cfelse>
                            <cfcontinue>
                        </cfif>
                    </cfif>
                    
                    
                    <cfset matchPrinted="true">
                    <cfif groupByName neq prevGroupByName>
                    	<cfif prevGroupByName neq "">
                        	<!--- Calculating Gross Margin %age --->
							<cfif sumCustomerTotals eq 0>
                                <cfset grossMarginPercentage = 0>
                            <cfelse>
                                <cfset grossMarginPercentage = (sumProfits/sumCustomerTotals)*100>
                            </cfif>
                            <!--- Total For fisrt and middle salesAgent/dispacthers --->
                        	<tr style="width:100%;">
                                <td align="left" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap; font-weight:bold;"> Total: </td>
                                <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;" colspan="2"> #numOfLoads# Loads </td>
                                <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;" colspan="2"> Margin: #NumberFormat(grossMarginPercentage,'0.00')#% </td>
                                <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">#DollarFormat(sumCustomerTotals)# </td>
                                <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">#DollarFormat(sumCarrierTotals)#</td>
                                <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #DollarFormat(sumGrossMargins)# </td>
                                <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">&nbsp;  </td>
								<cfif reportType EQ 'Commission'>
									<td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #NumberFormat(commissionPercentage,'0.00')#% </td>
									<td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #DollarFormat(sumCommissions)# </td>
								</cfif>
                            </tr>
							<cfif request.qAgent.SalesCommission eq 0>
								<cfset commissionPercentage = url.commissionPercentage>
							<cfelse>
								<cfif trim(request.qAgent.SalesCommission) eq ''>
									<cfset commissionPercentage = 0>
								<cfelse>
									<cfset commissionPercentage = request.qAgent.SalesCommission>
								</cfif>
							</cfif>
                            <cfset sumCustomerTotals=0>
							<cfset sumCarrierTotals=0>
                            <cfset sumCommissions=0>
                            <cfset sumGrossMargins=0>
                            <cfset sumProfits=0>
                            <cfset numOfLoads=0>
                            <!--- Dynamic Table closing --->
                            </table>
                            </p>
                            <cfdocumentitem type="pagebreak"></cfdocumentitem>
                            <!--- Dynamic Table opening --->
                            <p style="page-break-inside:avoid">
                            <table width="100%" cellpadding="2px" cellspacing="0" style="table-layout:fixed; border:0px solid black; font-size:12px;">
                        </cfif>
                        <tr>
                            <td align="left" colspan="11" style="font-size:12px; border-bottom:1 solid ##999999;"> <b>#groupBy#:</b>&nbsp;&nbsp;&nbsp;&nbsp;
                                #groupByName#
                            </td>
                        </tr>
                    </cfif>
                	<tr style="width:100%;">
                        <td align="center" style="overflow:hidden; white-space:nowrap;"> #request.qReportLoads.LoadNumber# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;"> #DateFormat(request.qReportLoads.orderDate,'mm/dd/yyyy')# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;"> #request.qReportLoads.CustomerName# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;">#request.qLoadsFirstStop.ShipperCity#, #request.qLoadsFirstStop.ShipperState# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;">#request.qLoadsFirstStop.ConsigneeCity#, #request.qLoadsFirstStop.ConsigneeState# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;"> #DollarFormat(request.qReportLoads.TotalCustomerCharges)# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;"> #DollarFormat(request.qReportLoads.TotalCarrierCharges)# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;"> #DollarFormat(grossMargin)# </td>
                        <td align="center" style="overflow:hidden; white-space:nowrap;"> #carrierName# </td>
						<cfif reportType EQ 'Commission'>
							<td align="center" style="overflow:hidden; white-space:nowrap;"> #NumberFormat(commissionPercentage,'0.00')#% </td>
							<td align="center" style="overflow:hidden; white-space:nowrap;"> #DollarFormat(commission)# </td>
						</cfif>
                        <cfset sumCustomerTotals = sumCustomerTotals + request.qReportLoads.TotalCustomerCharges>
                        <cfset sumCarrierTotals = sumCarrierTotals + request.qReportLoads.TotalCarrierCharges>
                        <cfset sumCommissions = sumCommissions + commission>
                        <cfset sumGrossMargins = sumGrossMargins + grossMargin>
                        <cfset sumProfits = sumProfits + request.qReportLoads.grossProfit>
                        <cfset numOfLoads = numOfLoads + 1>
                        
                        <cfset grandSumCustomerTotals = grandSumCustomerTotals + request.qReportLoads.TotalCustomerCharges>
                        <cfset grandSumCarrierTotals = grandSumCarrierTotals + request.qReportLoads.TotalCarrierCharges>
                        <cfset grandSumCommissions = grandSumCommissions + commission>
                        <cfset grandSumGrossMargins = grandSumGrossMargins + grossMargin>
                        <cfset grandSumProfits = grandSumProfits + request.qReportLoads.grossProfit>
                        
	                </tr>
                    <cfset prevGroupByName = groupByName>
                </cfloop>
                
                
                <cfif matchPrinted eq "false">
                	<tr style="width:100%;">
                    	<td align="left" > No Match Found </td>
                    </tr>
                </cfif>
                
                
                <!--- Calculating Gross Margin %age --->
				<cfif sumCustomerTotals eq 0>
                	<cfset grossMarginPercentage = 0>
                <cfelse>
                	<cfset grossMarginPercentage = (sumProfits/sumCustomerTotals)*100>
                </cfif>
                	<!--- Total For last salesAgent/dispacther --->
                	<tr style="width:100%;">
                        <td align="left" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap; font-weight:bold;"> Total: </td>
                        <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;" colspan="2"> #numOfLoads# Loads </td>
                        <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;" colspan="2"> Margin: #NumberFormat(grossMarginPercentage,'0.00')#% </td>
                        <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">#DollarFormat(sumCustomerTotals)# </td>
                        <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">#DollarFormat(sumCarrierTotals)#</td>
                        <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #DollarFormat(sumGrossMargins)# </td>
                        <td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">&nbsp;  </td>
						<cfif reportType EQ 'Commission'>
							<td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #NumberFormat(commissionPercentage,'0.00')#% </td>
							<td align="center" style="border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #DollarFormat(sumCommissions)# </td>
						</cfif>
                    </tr>
					<cfset sumCustomerTotals=0>
					<cfset sumCarrierTotals=0>
                    <cfset sumCommissions=0>
                    <cfset sumGrossMargins=0>
                    <cfset sumProfits=0>
                    <cfset numOfLoads=0>
			</table>
            </p>
            <cfdocumentitem type="pagebreak"></cfdocumentitem>
            
            
            
            <!--- Calculating Gross Margin %age --->
			<cfif grandSumCustomerTotals eq 0>
            	<cfset grandGrossMarginPercentage = 0>
            <cfelse>
            	<cfset grandGrossMarginPercentage = (grandSumProfits/grandSumCustomerTotals)*100>
            </cfif>
            
            <!--- Grand Totals --->
            <table width="100%" cellspacing="0" style="border:0px solid black; font-size:12px;">
            	<tr style="width:100%;">
                        <td align="left" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap; font-weight:bold;"> Total: </td>
                        <td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;" colspan="2"> #request.qReportLoads.RecordCount# Loads </td>
                        <td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;" colspan="2"> Margin: #NumberFormat(grandGrossMarginPercentage,'0.00')#% </td>
                        <td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">#DollarFormat(grandSumCustomerTotals)# </td>
                        <td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">#DollarFormat(grandSumCarrierTotals)#</td>
                        <td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #DollarFormat(grandSumGrossMargins)# </td>
                        <td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;">&nbsp;  </td>
						<cfif reportType EQ 'Commission'>
							<td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #NumberFormat(url.commissionPercentage,'0.00')#% </td>
							<td align="center" style="padding-top:2px; border-top:1 solid ##999999; overflow:hidden; white-space:nowrap;"> #DollarFormat(grandSumCommissions)# </td>
						</cfif>
                    </tr>
			</table>
            
            
            
            
            
            
            <cfdocumentitem type="footer">
            	<table width="100%" cellspacing="0" style="border:0px solid black; font-size:10px;">
                    <tr>
                        <td align="left" style="padding-top:2px; border-top:1 solid ##000000;"> Date/Time: #DateFormat(Now(),'mm/dd/yyyy hh:mm:ss')# </td>
                        <td align="right" style="padding-top:2px; border-top:1 solid ##000000;">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
                    </tr>
				</table>
            </cfdocumentitem>
            
		</body>
</html>

</cfoutput>
</cfdocument>

    <cfpdf
        action      = "write"
        source      = "cfdoc"
        name		= "output"
    />



<!--- return the full pdf --->
<cfcontent type="application/pdf" reset="true" variable="#toBinary(output)#">