<cfset currentTab = "25">
<cfset variables.carrierid = form.carrierid >
<cfset variables.LoadStopID = form.LoadStopID >
<cfquery name="qrygetunits" datasource="#Application.dsn#">
	select unitID,unitName,unitCode,CustomerRate,CarrierRate from  Units	
	ORDER BY unitName
</cfquery>

<cfquery name="qrygetclasses" datasource="#Application.dsn#">
	select * from  CommodityClasses
	ORDER BY (SELECT CAST(ClassName AS float))
</cfquery>

<cfstoredproc procedure="USP_GetLoadItems" datasource="#Application.dsn#"> 
	<cfif isdefined('variables.LoadStopID') and len(variables.LoadStopID) gt 1>
		<cfprocparam value="#variables.LoadStopID#" cfsqltype="CF_SQL_VARCHAR">
	<cfelse>
		<cfprocparam value="" cfsqltype="CF_SQL_VARCHAR">
	</cfif> 
	<cfprocresult name="request.qItems"> 
</cfstoredproc>

<cfoutput query="request.qItems">

	<cfquery name="" datasource="#Application.dsn#">
		SELECT carrierid,carrrate,commodityid,CarrRateOfCustTotal,id
		FROM carrier_commodity
		WHERE carrierid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.carrierid#"> 
		AND commodityid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.qItems.unitid#"> 
	</cfquery>
	
	<tr <cfif request.qItems.currentRow mod 2 eq 0>bgcolor="##FFFFFF"<cfelse>  bgcolor="##f7f7f7"</cfif> >
		<td height="20" class="lft-bg">&nbsp;</td>
		<td class="lft-bg2" valign="middle" align="center">
			<input name="isFee#request.qItems.currentRow#" id="isFee#request.qItems.currentRow#" class="check isFee" <cfif request.qItems.fee is 1> checked="checked" </cfif> type="checkbox" tabindex="#evaluate(currentTab+1)#" />
		</td>
		<td class="normaltdC" valign="middle" align="left">
			<input name="qty#request.qItems.currentRow#" id="qty#request.qItems.currentRow#" onchange="CalculateTotal()" class="q-textbox qty" type="text" value="#request.qItems.qty#"  tabindex="#evaluate(currentTab+1)#" />
		</td>
		<td class="normaltdC" valign="middle" align="left">
			<select name="unit#request.qItems.currentRow#" id="type#request.qItems.currentRow#" class="t-select unit" onChange="checkForFee(this.value,'#request.qItems.currentRow#','','#application.dsn#');CalculateTotal();" tabindex="#evaluate(currentTab+1)#">
				<option value=""></option>
				<cfloop query="qrygetunits">
					<option value="#qrygetunits.unitID#" <cfif qrygetunits.unitID is request.qItems.unitid> selected="selected" </cfif>>#qrygetunits.unitName#<cfif trim(qrygetunits.unitCode) neq ''>(#qrygetunits.unitCode#)</cfif></option>
				</cfloop>
			</select>
		</td>
		<td class="normaltdC" valign="middle" align="left">
			<input name="description#request.qItems.currentRow#" id="description#request.qItems.currentRow#" class="t-textbox" value="#request.qItems.description#" type="text" tabindex="#evaluate(currentTab+1)#" />
		</td>
		<td class="normaltdC" valign="middle" align="left">
			<input name="weight#request.qItems.currentRow#" class="wt-textbox" value="#request.qItems.weight#" type="text" tabindex="#evaluate(currentTab+1)#" />
		</td>
		<td class="normaltdC" valign="middle" align="left">
			<select name="class#request.qItems.currentRow#" class="t-select sel_class" tabindex="#evaluate(currentTab+1)#" >
				<option></option>
				<cfloop query="qrygetclasses">
					<option value="#qrygetclasses.classId#" <cfif qrygetclasses.classId is request.qItems.classid> selected="selected" </cfif>>#qrygetclasses.className#</option>
				</cfloop>
			</select>
		</td>
		<cfset variables.CUSTRATE = request.qItems.CUSTRATE>
		<cfset variables.CARRRATE = request.qItems.CARRRATE>
		<cfset variables.CarrierPer = "" >
		<cfif qGetCarrierCommodityById.recordcount >
			<cfset variables.CARRRATE = qGetCarrierCommodityById.carrrate>
			<cfset variables.CarrierPer = qGetCarrierCommodityById.CarrRateOfCustTotal >
		</cfif>
		<cfif request.qItems.CUSTRATE eq ""><cfset variables.CUSTRATE = '0.00' ></cfif>
		<cfif request.qItems.CARRRATE eq ""><cfset variables.CARRRATE = '0.00' ></cfif>

		<td class="normaltdC" valign="middle" align="left">
			<input name="CustomerRate#request.qItems.currentRow#" id="CustomerRate#request.qItems.currentRow#" class="q-textbox CustomerRate" value="#DollarFormat(variables.CUSTRATE)#" onChange="CalculateTotal();formatDollar(this.value, this.id);"  type="text" tabindex="#evaluate(currentTab+1)#"/>
		</td>
		<td class="normaltd2C" valign="middle" align="left">
			<input name="CarrierRate#request.qItems.currentRow#" id="CarrierRate#request.qItems.currentRow#" class="q-textbox CarrierRate" value="#DollarFormat(variables.CARRRATE)#" onChange="CalculateTotal();formatDollar(this.value, this.id);"  type="text" tabindex="#evaluate(currentTab+1)#" />
		</td>
		<td class="normaltd2C" valign="middle" align="left">
			<input name="CarrierPer#request.qItems.currentRow#" id="CarrierPer#request.qItems.currentRow#" class="q-textbox CarrierPer" value="#variables.CarrierPer#" onChange=""  type="text" tabindex="#evaluate(currentTab+1)#" />
		</td>
		<td class="normaltdC" valign="middle" align="left">
			<input name="custCharges#request.qItems.currentRow#" id="custCharges#request.qItems.currentRow#" class="q-textbox custCharges" value="#request.qItems.CUSTCHARGES#" onChange="CalculateTotal();" type="text" tabindex="#evaluate(currentTab+1)#"/>
		</td>
		<td class="normaltd2C" valign="middle" align="left">
			<input name="carrCharges#request.qItems.currentRow#" id="carrCharges#request.qItems.currentRow#" class="q-textbox carrCharges" value="#request.qItems.CARRCHARGES#" onChange="CalculateTotal();" type="text" tabindex="#evaluate(currentTab+1)#" />
		</td>
		<td class="normal-td3">&nbsp;</td>	  
	</tr>
</cfoutput>
  