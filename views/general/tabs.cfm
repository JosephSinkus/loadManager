<cfparam name="request.lstTabs" default="" />

<cfoutput> 
	<link href="stylesheets/tabs.css" rel="stylesheet" type="text/css">
	<table cellpadding="0" cellspacing="0" width="100%" height="100%" class="border">
		<tr height="18">
			<td width="100%" valign="top">
				<table cellpadding="4" cellspacing="0" width="100%" border="0" class="LightItemBorder">
					<tr class="tabBackground"><cfsilent>
						<cfset intTabCount = 0 />
						<cfloop list="#request.lstTabs#" index="lstTab" delimiters="|">
							<cfif ListLen(lstTab) EQ 2>
								<cfset intTabCount = intTabCount + 1 />
							</cfif>
						</cfloop></cfsilent>
						<td align="center">
							<script language="javascript" type="text/javascript">
								function padZero(i) {
									if (i < 10)
										return '0' + String(i);
									else
										return String(i);
								}
								
								function getPreviousHeight(i) {
									var intReturn = 0;
									for (var j = 1; j < i; j++)
										intReturn = intReturn + document.getElementById('iframe' + padZero(j)).clientHeight;
										
									return intReturn;
								}
								
								function selectTab(intSelected, strIframeLocation) {
									var intTabs = #intTabCount#;
									
									for (var i = 1; i <= intTabs; i++) {
										if (i == intSelected) 
										{
											if (document.getElementById('iframe' + padZero(i)).src != '' && document.getElementById('left' + padZero(i)).className == 'tabLeftSelected') 
											{
												document.getElementById('imgWaitAnimation' + padZero(i)).style.display = '';
												document.getElementById('iframe' + padZero(i)).src = unescape(strIframeLocation);
											}
											document.getElementById('left' + padZero(i)).className= 'tabLeftSelected';
											document.getElementById('middle' + padZero(i)).className = 'tabMiddleSelected';
											document.getElementById('right' + padZero(i)).className = 'tabRightSelected';
											document.getElementById('iframe' + padZero(i)).style.visibility = '';
											document.getElementById('iframe' + padZero(i)).style.zIndex = 999 + i;
											if (document.getElementById('iframe' + padZero(i)).src == '') 
											{
												document.getElementById('imgWaitAnimation' + padZero(i)).style.display = '';
												document.getElementById('iframe' + padZero(i)).src = unescape(strIframeLocation);
											}
											
											if (i > 1)
												document.getElementById('iframe' + padZero(i)).style.top = (-1 * getPreviousHeight(i)) + "px";
										} 
										else 
										{
											document.getElementById('left' + padZero(i)).className= 'tabLeft';
											document.getElementById('middle' + padZero(i)).className = 'tabMiddle';
											document.getElementById('right' + padZero(i)).className = 'tabRight';
											document.getElementById('iframe' + padZero(i)).style.visibility = 'hidden';
											document.getElementById('iframe' + padZero(i)).style.zIndex = -1;
										}
									}
								}
	
							</script>
							<table cellpadding="0" cellspacing="0" width="100%" border="0">
								<tr style="height: 18px;">
									<cfset intListItem = 0 />
									<cfloop list="#request.lstTabs#" index="lstTab" delimiters="|">
										<cfif ListLen(lstTab) EQ 2><cfsilent>
											<cfset intListItem = intListItem + 1 />
											<cfif intListItem EQ 1>
												<cfset strClassSuffix = "Selected" />
											<cfelse>
												<cfset strClassSuffix = "" />
											</cfif>
                                            <cfset strIFrameURL = ListGetAt(lstTab, 2) />
                                            <cfif NOT FindNoCase("blnIsTab", strIFrameURL) GT 0>
												<cfif FindNoCase("?", strIFrameURL) GT 0>
                                                    <cfset strIFrameURL = ListGetAt(lstTab, 2) & "&blnIsTab=True" />
                                                <cfelse>
                                                    <cfset strIFrameURL = ListGetAt(lstTab, 2) & "?blnIsTab=True" />
												</cfif>
											</cfif>
											</cfsilent>
											<td id="left#NumberFormat(intListItem, '00')#" class="tabLeft#strClassSuffix#"><div style="width:2px;"></div></td>
											<td id="middle#NumberFormat(intListItem, '00')#" nowrap align="center" class="tabMiddle#strClassSuffix#" onClick="selectTab(#intListItem#,'#URLEncodedFormat(strIFrameURL)#');"><img src="images/aniwait.gif" id="imgWaitAnimation#NumberFormat(intListItem, '00')#" />#ListGetAt(lstTab, 1)#</td>
											<td id="right#NumberFormat(intListItem, '00')#" class="tabRight#strClassSuffix#"><div style="width:9px;"></div></td>
										</cfif>
									</cfloop>
									<td class="tabLastFiller" align="right">&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" valign="top" align="center"><br>
				<cfset intListItem = 0 />
				<cfloop list="#request.lstTabs#" index="lstTab" delimiters="|"><cfsilent>
					</cfsilent><cfif ListLen(lstTab) EQ 2><cfsilent>
						<cfset intListItem = intListItem + 1 />
						<cfif intListItem EQ 1>
							<cfset strDisplay = "" />
						<cfelse>
							<cfset strDisplay = "hidden" />
						</cfif>
						</cfsilent><iframe style="overflow-x:hidden;height:400px;visibility:#strDisplay#;position:relative;"<cfif intListItem EQ 1> src="#ListGetAt(lstTab,2)#"</cfif> id="iframe#NumberFormat(intListItem, '00')#" name="iframe#NumberFormat(intListItem, '00')#" width="96%" frameborder="0" marginheight="0" marginwidth="0" onload="document.getElementById('imgWaitAnimation#NumberFormat(intListItem, '00')#').style.display='none';"></iframe>
					</cfif><cfsilent>
				</cfsilent></cfloop>
			</td><!--- left:20px; top:175px; --->
		</tr>
	</table>
<cfif isdefined('SelectedTabIndex')>
<script language="javascript" type="text/javascript">
	window.onload = function() {selectTab(#SelectedTabIndex#,'#URLEncodedFormat(ListGetAt(ListGetAt(request.lstTabs,SelectedTabIndex,'|'),2))#');}
</script>
</cfif>
</cfoutput>