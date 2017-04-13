<cfparam name="MailTo" default="">
<cfparam name="MailFrom" default="">
<cfparam name="Subject" default="">
<cfparam name="body" default="">
<cfset Secret = application.dsn>
<cfset TheKey = 'NAMASKARAM'>
<cfset Encrypted = Encrypt(Secret, TheKey)>
<cfset dsn = ToBase64(Encrypted)>
<cfscript>
	variables.objequipmentGateway = getGateway("gateways.equipmentgateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
	variables.objCutomerGateway = getGateway("gateways.customergateway", MakeParameters("dsn=#Application.dsn#,pwdExpiryDays=#Application.pwdExpiryDays#"));
</cfscript>
<cfsilent>
	<cfparam name="loadID" default="">
	<cfinvoke component="#variables.objloadGateway#" method="getCompanyInformation" returnvariable="request.qGetCompanyInformation" />
	<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurAgentdetails" employeID="#session.empid#" />
	<cfinvoke component="#variables.objloadGateway#" AuthLevelId="1" method="getSalesPerson" returnvariable="request.qSalesPerson" />
	<cfinvoke component="#variables.objloadGateway#" AuthLevelId="3" method="getSalesPerson" returnvariable="request.qDispatcher" />
	<cfinvoke component="#variables.objloadGateway#" method="getSystemSetupOptions" returnvariable="request.qGetSystemSetupOptions" />
	<cfinvoke component="#variables.objequipmentGateway#" method="getloadEquipments" returnvariable="request.qEquipments" />
	<cfinvoke component="#variables.objCutomerGateway#" method="getAllpayerCustomers" returnvariable="request.qryCustomersList" />
	<cfinvoke component="#variables.objloadGateway#" method="getcurAgentMaildetails" returnvariable="request.qcurMailAgentdetails" employeID="#session.empid#" />
	<cfset MailFrom=request.qcurAgentdetails.EmailID>
	<cfset Subject = request.qGetSystemSetupOptions.SalesHead>
	<cfif request.qcurMailAgentdetails.recordcount gt 0 and (request.qcurMailAgentdetails.SmtpAddress eq "" or request.qcurMailAgentdetails.SmtpUsername eq "" or request.qcurMailAgentdetails.SmtpPort eq "" or request.qcurMailAgentdetails.SmtpPassword eq "" or request.qcurMailAgentdetails.SmtpPort eq 0)>
	  	<cfset mailsettings = "false">
	<cfelse>
	  	<cfset mailsettings = "true">
	</cfif>
	<cfif request.qGetSystemSetupOptions.freightBroker>
		<cfset variables.freightBroker = "Carrier">
	<cfelse>
		<cfset variables.freightBroker = "Driver">
	</cfif>
</cfsilent>

<cfoutput>
	<style type="text/css">
		.reportsSubHeading{
			border-bottom: 1px solid ##77463d !important;
			margin-bottom: 5px !important;
		}
	</style>
	<div class="white-con-area" style="height: 36px;background-color: ##82bbef;">
		<div style="float: left;"><h2 style="color:white;font-weight:bold;margin-left: 12px;">Reporting System</h2></div>
	</div>
	<div style="clear:left"></div>

	<div class="white-con-area">
		<div class="white-top"></div>
	    <div class="white-mid">
			<cfform name="frmCommissionReport" action="##" method="post">
				<div class="form-con">
					<fieldset>
						<h2 class="reportsSubHeading">Group By</h2>
						<div class="clear"></div>
	            		<div style="width:110px; float:left;">&nbsp;</div>
	           			<div style="float:left;">
			                <cfinput type="radio" name="groupBy" value="none" id="none" checked="yes" style="width:15px; padding:0px 0px 0 0px;margin-bottom:1px;"  onclick="hideCustomerCheckBox();hidecheckBoxGroup();"/>
			                <label class="normal" for="salesAgent" style="text-align:left; padding:0 0 0 0;">None</label>
			            </div>
	    				<div class="clear"></div>
	            		<div style="width:110px; float:left;">&nbsp;</div>
	        			<div style="float:left;">
			            	<cfif request.qGetSystemSetupOptions.freightBroker>	
			                	
			                	<cfinput type="radio" name="groupBy" value="salesAgent" id="salesAgent" style="width:15px; padding:0px 0px 0 0px;margin-bottom:1px;" onclick="hideCustomerCheckBox();showcheckBoxGroup()"/>
			                <cfelse>
			                	<cfif len(trim(request.qGetSystemSetupOptions.userDef7))>
			                			
			                		<cfinput type="radio" name="groupBy" value="#request.qGetSystemSetupOptions.userDef7#" id="salesAgent" style="width:15px; padding:0px 0px 0 0px;margin-bottom:1px;" onclick="hideCustomerCheckBox();showcheckBoxGroup()"/>	
			                	<cfelse>
			                		<cfinput type="radio" name="groupBy" value="salesAgent" id="salesAgent" style="width:15px; padding:0px 0px 0 0px;margin-bottom:1px;" onclick="hideCustomerCheckBox();showcheckBoxGroup()"/>
			                	</cfif>
			                </cfif>

	                		<label class="normal" for="salesAgent" style="text-align:left; padding:0 0 0 0;" >
				                <cfif request.qGetSystemSetupOptions.freightBroker>	
				                	Sales Agent
				                <cfelse>
				                	<cfif len(trim(request.qGetSystemSetupOptions.userDef7))>
				                			#request.qGetSystemSetupOptions.userDef7#
				                	<cfelse>
				                		Sales Agent	
				                	</cfif>
				                </cfif>	
	                		</label>
	            		</div>

	            		<div class="clear"></div>
	            		<div style="width:110px; float:left;">&nbsp;</div>
	            		<div style="float:left;">
	                		<cfinput type="radio" name="groupBy" value="dispatcher" id="dispatcher"  style="width:15px; padding:0px 0px 0 0px;margin-bottom:1px;" onclick="hideCustomerCheckBox();showcheckBoxGroup()"/>
	                		<label class="normal" for="dispatcher" style="text-align:left; padding:0 0 0 0;" >Dispatcher</label>
	            		</div>			
						<div class="clear"></div>
						<div style="width:110px; float:left;">&nbsp;</div>
	            		<div style="float:left;">
			                <cfinput type="radio" name="groupBy" value="customer" id="customer"  style="width:15px; padding:0px 0px 0 0px;margin-bottom:1px;" onclick="hideCustomerCheckBox();showcheckBoxGroup()"/>
			                <label class="normal" for="customer" style="text-align:left; padding:0 0 0 0;" >Customer</label>
			            </div>			
				 		<div class="clear"></div>
	            		<div style="width:110px; float:left;">&nbsp;</div>
			            <div style="float:left;">
			                <cfinput type="radio" name="groupBy" value="#variables.freightBroker#" id="#variables.freightBroker#" style="width:15px; padding:0px 0px 0 0px;margin-bottom:1px;" onclick="showCustomerCheckBox();showcheckBoxGroup()"/>
			                <label class="normal" for="#variables.freightBroker#" style="text-align:left; padding:0 0 0 0;">#variables.freightBroker#</label>
			            </div>            
			            <div class="clear"></div>       
			            <div style="float:right; margin-top: -25px;" class="hidecheckBox">
			                <cfinput type="checkbox" name="customerCheck" value="" id="customerCheck" checked style="width: 16px;"/>
			                 <label class="normal" for="customerCheck" style="width:100px;text-align:left;">Show Customer Info</label>
			            </div>   
			            <div class="clear"></div>       
			            <div style="float:right; margin-top: -77px;" class="hidecheckBoxGroup">
			                <cfinput type="checkbox" name="customerCheck" value="" id="customerCheckGroup" checked style="width: 16px;"/>
			                 <label class="normal" for="customerCheckGroup" style="width:100px;text-align:left;">Page Break After Each Group?</label>
			            </div>      
			            <div class="clear"></div>  
			            <div style="margin-top:30px;">
				            <cfinput type="radio" name="datetype" value="Shipdate" id="customer"  style="width:15px; padding:0px 0px 0 0px;" checked="true"/>
				            <label class="normal"><h2 style="float:left;padding: 0;">Ship Date</h2></label>

				            <cfinput type="radio" name="datetype" value="Invoicedate" id="customer"  style="width:15px; padding:0px 0px 0 0px;"/>
				            <label class="normal"><h2 style="float:left;padding: 0;">Invoice Date</h2></label>
				            <div class="clear reportsSubHeading" ></div>  
			            </div>

			            <label>From</label>
				        <cfinput class="sm-input" name="dateFrom" id="dateFrom" value="#dateformat(Now()-30,'mm/dd/yyy')#" validate="date" required="yes" message="Please enter a valid date in Date From" type="datefield" />
			        	<label style="margin-left: -54px;">To</label>
				        <cfinput class="sm-input" name="dateTo" id="dateTo" value="#dateformat(Now(),'mm/dd/yyy')#" validate="date" required="yes" message="Please enter a valid date in Date To" type="datefield" />
			            <div class="clear"></div>
	            
						<div width="100%" style="margin-top: 30px;">
							<div style="float:left;margin-top:15px;width:50%;">
								<h2 class="reportsSubHeading">Commission</h2>
								<label>Deduction %</label>
								<cfinput class="sm-input" name="deductionPercent" id="deductionPercent" value="#NumberFormat(request.qGetSystemSetupOptions.DeductionPercentage,'0.00')#" validate="float" required="yes" message="Please enter a valid percentage in Deduction %"/>
								<div class="clear"></div>
								
								<label>Commission %</label>
								<cfinput class="sm-input" name="commissionPercent" id="commissionPercent" value="#NumberFormat(0,'0.00')#" validate="float" required="yes" message="Please enter a valid percentage in Commission %"/>
								<div class="clear"></div>
							</div>
							<div  style="float:left;margin-top:15px;width:50%;">
								<h2 style="text-align:center;" class="reportsSubHeading">Margin Range</h2>
								<label>From </label>
								<cfinput class="sm-input" name="marginFrom" id="marginFrom" value="#DollarFormat(0)#" validate="float" required="yes" message="Please enter a valid amount in Margin From"/>
								<div class="clear"></div>
								
								<label>To </label>
								<cfinput class="sm-input" name="marginTo" id="marginTo" value="#DollarFormat(0)#" validate="float" required="yes" message="Please enter a valid amount in Margin To"/>
								<div class="clear"></div>
							</div>
						</div>
						<div class="clear"></div>
						<cfset loadStatus=request.qGetSystemSetupOptions.ARANDAPEXPORTSTATUSID>
							
						<div style="margin-top: 30px;">
							<h2 style="margin-top:14px;" class="reportsSubHeading">Load Status</h2>
				            <label>Status From</label>
							<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" /> 			
				   			<select name="loadStatus" id="StatusTo">
								<cfloop query="request.qLoadStatus">
									<option value="#request.qLoadStatus.value#" <cfif loadStatus EQ  request.qLoadStatus.value>selected="selected"</cfif>>#request.qLoadStatus.Text#</option>
								</cfloop>
							</select>
				
							<label>Status To</label>					
							<cfinvoke component="#variables.objloadGateway#" method="getLoadStatus" returnvariable="request.qLoadStatus" /> 
				   			<select name="loadStatus" id="StatusFrom">
								<cfloop query="request.qLoadStatus">
									<option value="#request.qLoadStatus.value#" <cfif loadStatus EQ  request.qLoadStatus.value>selected="selected"</cfif>>#request.qLoadStatus.Text#</option>
								</cfloop>
							</select>
						</div>

						<div class="clear"></div>
			            <div style="margin-top:30px">
				            <h2 style="margin-top:12px;" class="reportsSubHeading">Type</h2>
							<label>Report Type</label>
					        <cfselect name="reportType" id="reportType">
								<option value="Sales">Sales</option>
								<option value="Commission">Commission</option>
							</cfselect>
			            </div>
					</fieldset>
				</div>
				<div class="form-con">
					<fieldset>	
		        		<h2 class="reportsSubHeading" style="margin-left: 50px;">
				 			<cfif request.qGetSystemSetupOptions.freightBroker>	
				            	Sales Rep
				            <cfelse>
				            	<cfif len(trim(request.qGetSystemSetupOptions.userDef7))>
				            			#request.qGetSystemSetupOptions.userDef7#
				            	<cfelse>
				            		Sales Rep	
				            	</cfif>
				            </cfif>	
	        			</h2>
	        			<div style="float:right; margin-right:40px;">
				            <label>From </label>
				            <cfif request.qGetSystemSetupOptions.freightBroker>
				            	 <cfselect name="salesRepFrom" id="salesRepFrom">
					            	<option value="########">########</option>
					                <cfloop query="request.qSalesPerson">
										<option value="#request.qSalesPerson.EmployeeID#">#request.qSalesPerson.Name#</option>
									</cfloop>
					                <option value="ZZZZ">ZZZZ</option>
					            </cfselect> 	
				          	<cfelse>	  	
						       <cfinput type="text" name="salesRepFrom" id="salesRepFrom" value="(BLANK)">
					        </cfif>    
				            <div class="clear"></div>
				            <label>To </label>
				             
				            <cfif request.qGetSystemSetupOptions.freightBroker>
								<cfselect id="salesRepTo" name="salesRepTo">
					            	<option value="########">########</option>
					                <cfloop query="request.qSalesPerson">
										<option value="#request.qSalesPerson.EmployeeID#">#request.qSalesPerson.Name#</option>
									</cfloop>
					                <option value="ZZZZ" selected="selected">ZZZZ</option>
					            </cfselect> 
				            <cfelse>
								<cfinput type="text" name="salesRepTo" id="salesRepTo" value="ZZZZ">
				            </cfif>
		            		<div class="clear"></div>		
	        			</div>
	        			<div class="clear"></div>
	            
	        			<h2 style="margin-top:65px; margin-left: 50px;" class="reportsSubHeading">Dispatcher</h2>
	        			<div style="float:right; margin-right:40px;">
		        			<label>From </label>
					        <cfselect name="dispatcherFrom" id="dispatcherFrom">
				            	<option value="########">########</option>
				                <cfloop query="request.qDispatcher">
						        	<option value="#request.qDispatcher.EmployeeID#">#request.qDispatcher.Name#</option>
						        </cfloop>
				                <option value="ZZZZ">ZZZZ</option>
				            </cfselect>
				            <div class="clear"></div>
				            <label>To </label>
					        <cfselect id="dispatcherTo" name="dispatcherTo">
				            	<option value="########">########</option>
				                <cfloop query="request.qDispatcher">
						        	<option value="#request.qDispatcher.EmployeeID#">#request.qDispatcher.Name#</option>
						        </cfloop>
				                <option value="ZZZZ" selected="selected">ZZZZ</option>
				            </cfselect>
				            <div class="clear"></div>
				        </div>
				        <div class="clear"></div>
				 
						<h2 style="margin-top:17px; margin-left: 50px;" class="reportsSubHeading">Customer</h2>
						<div style="float:right; margin-right:40px;">
							<label>From </label>
							<cfselect name="customerFrom" id="customerFrom">
								<option value="########">########</option>
								<cfloop query="request.qryCustomersList">
								<option value="#request.qryCustomersList.customerid#">#request.qryCustomersList.customername#</option>
								</cfloop>
								<option value="ZZZZ">ZZZZ</option>
							</cfselect>
							<div class="clear"></div>
							<label>To </label>
							<cfselect name="customerTo" id="customerTo">
								<option value="########">########</option>
								<cfloop query="request.qryCustomersList">
								<option value="#request.qryCustomersList.customerid#">#request.qryCustomersList.customername#</option>
								</cfloop>
								<option value="ZZZZ" selected="selected">ZZZZ</option>
							</cfselect>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>

				
						<h2 style="margin-top:32px; margin-left: 50px;" class="reportsSubHeading">Equipment</h2>
						<div style="float:right; margin-right:40px;">
							<label>From </label>
							<cfselect name="equipmentFrom" id="equipmentFrom">
								<option value="########">########</option>
								<cfloop query="request.qEquipments">
								<option value="#request.qEquipments.equipmentID#">#request.qEquipments.equipmentname#</option>
								</cfloop>
								<option value="ZZZZ">ZZZZ</option>
							</cfselect>
							<div class="clear"></div>
							<label>To </label>
							<cfselect name="equipmentTo" id="equipmentTo">
								<option value="########">########</option>
								<cfloop query="request.qEquipments">
								<option value="#request.qEquipments.equipmentID#">#request.qEquipments.equipmentname#</option>
								</cfloop>
								<option value="ZZZZ" selected="selected">ZZZZ</option>
							</cfselect>
						</div>
						<div class="clear"></div>	

						<div class="clear"></div>
						<cfinput type="hidden" name="repUrl" id="repUrl" value="ss">
						<cfinput type="hidden" name="freightBroker" id="freightBroker" value="#variables.freightBroker#"> 
						<div style="border-top: 1px solid ##77463d; margin-top: 56px;margin-left: 50px;">	
							<div style="float:right;margin-right: -51px;">	
								<div style="float:left;">
									<h2 style="margin-top:14px;width: 184px;float:left;">Show Summary Only</h2> 
								</div>	
								<div style="float:left;">
									<cfinput type="checkbox" name="ShowSummaryOnly" value="" id="ShowSummaryOnly"  style="margin-left: -83px;margin-top: 13px;">
								</div>
								<div style="clear:both;"></div> 	
					        </div>  	
				           	<div class="clear"></div> 	
				           	<div style="float:right; margin-right:-51px;">	
								<div style="float:left;">
									<h2 style="margin-top:14px;width: 184px;float:left;">Show Profit & Cost</h2> 
								</div>	
								<div style="float:left;">
									<cfinput type="checkbox" name="ShowProfit" checked value="" id="ShowProfit"  style="margin-left: -83px;margin-top: 13px;">
								</div>
								<div style="clear:both;"></div> 	
					        </div>  	
				           	<div class="clear"></div>
				        </div>
				        <div class="clear"></div>   	 	
	            
				        <div class="right" style="margin-top:39px;">
				        	<div style="margin:-40px 0 0 -100px;">
								<div style="cursor:pointer;width:27px;background-color: ##bfbcbc;float: left;margin: 1px 0;text-align: center;">
									<cfif request.qGetSystemSetupOptions.emailType EQ "Load Manager Email">
										<img id="salesReportImg" style="vertical-align:bottom;" src="images/black_mail.png" data-action="view">
									<cfelse>
										<a <cfif request.qGetCompanyInformation.ccOnEmails EQ true> href="mailto:#MailTo#?cc=#request.qGetCompanyInformation.email#&subject=#Subject#&" <cfelse> href="mailto:#MailTo#?subject=#Subject#"</cfif>>
											<img style="vertical-align:bottom;" src="images/black_mail.png">
										</a>
									</cfif>
									<!---<cfparam name="MailFrom" default="">
									<cfparam name="Subject" default="">--->
								</div>
								<input id="sReport" type="button" name="viewReport" class="bttn tooltip" value="View Report" style="width:95px;"  <cfif mailsettings>data-allowmail="true"<cfelse>data-allowmail="false"</cfif>/>
				        	</div>
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

	<script type="text/javascript">
		$(document).ready(function(){
			$('##salesReportImg').click(function(){
				var dsn='#dsn#';
				if($("##customerCheck").is(':checked')){
			 		var customerStatus=0;
			 	}else{
			 		var customerStatus=1;
			 	}	
			 	if($("##customerCheckGroup").is(':checked')){
			 		var pageBreakStatus=1;
			 	}else{
			 		var pageBreakStatus=0;
			 	}
			 	if($("##ShowSummaryOnly").is(':checked')){
			 		var ShowSummaryStatus=1;
			 	}else{
			 		var ShowSummaryStatus=0;
			 	}
			 	if($("##ShowProfit").is(':checked')){
			 		var ShowProfit=0;
			 	}else{
			 		var ShowProfit=1;
			 	}
				getCommissionReport('#session.URLToken#', 'mail',dsn,customerStatus,pageBreakStatus,ShowSummaryStatus,ShowProfit);
			 });
			 $('##sReport').click(function(){	
				var dsn='#dsn#';
			 	if($("##customerCheck").is(':checked')){
			 		var customerStatus=0;
			 	}else{
			 		var customerStatus=1;
			 	}	
		 		if($("##customerCheckGroup").is(':checked')){
			 		var pageBreakStatus=1;
			 	}else{
			 		var pageBreakStatus=0;
			 	}
			 	if($("##ShowSummaryOnly").is(':checked')){
			 		var ShowSummaryStatus=1;
			 	}else{
			 		var ShowSummaryStatus=0;
			 	}
			 	if($("##ShowProfit").is(':checked')){
			 		var ShowProfit=0;
			 	}else{
			 		var ShowProfit=1;
			 	}
				getCommissionReport('#session.URLToken#', 'view',dsn,customerStatus,pageBreakStatus,ShowSummaryStatus,ShowProfit);
			});
		});		
		function sendmail(){
			var sub = "#Subject#";
			var mailTo = " ";
			myWindow=window.open("mailto:"+mailTo+"?subject="+sub,'','width=500,height=500');
			
		}
	</script>
</cfoutput>