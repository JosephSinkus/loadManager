<!--- from:2 executive blvd, 10901 to:100 broadway, ny, ny to:14 Avenue R, Brooklyn, NY 11223 --->
<cfajaximport params="#{googlemapkey='AIzaSyAMvv7YySXPntllOqj7509OH-9N3HgCJmw'}#">
<cfset theAddress = "Lafayette, LA">

<html>

<head>
<style>

#directionsPanel {
    /*width:500px;*/
	width:290px;
    height: 500px;
    overflow: auto;

}

 .hilight {
         font-weight: bold;
      }
      .hilight, .lolight {
         background-color: white;
         height: 18px;
         width:58px;
		 border-style: solid;
         border-color: black;
         border-width: 2px 1px 1px 2px;
         padding-bottom: 2px;
         font-family: arial, sans-serif;
         font-size: 12px;
      }
	  

</style>

	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
  <script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>

	<cfhttp url="http://maps.googleapis.com/maps/api/geocode/xml?address=#URL.frstShpAdd#&sensor=false"  method="get"  result="geoCode" />  
  
    <cfset geoCodeXML = xmlParse(geoCode.fileContent)>
	 <cfset centerLatitude  = geoCodeXML.GeocodeResponse[1].XmlChildren[2].geometry.location.lat.XmlText>		  
	 <cfset centerlLongitude = geoCodeXML.GeocodeResponse[1].XmlChildren[2].geometry.location.lng.XmlText>		   

</head>

<body>

<div style="width: 950px;">
 <div style="width: 300px; height: 530px; float: left;">
 	<div style="text-align:center; padding-top:8px;">
		<form name="me" action="" method="post">
			<input name="button" type="button" id="doDirections" value="Get Directions" onClick="calcRoute()" />
			<cfoutput>
			<input type="hidden" name="centerLatitude" id="centerLatitude" value="#centerLatitude#"  >
			<input type="hidden" name="centerlLongitude" id="centerlLongitude" value="#centerlLongitude#"  >
			</cfoutput>
			
		</form>
	</div>
 	<div id="directionsPanel"></div>
 </div> 
 <div id="panel" style="width:650px; float: right;">
	  <div id="themap" style="width: 650px; height: 535px;"></div>		 
	 
 </div> 
</div>

  <script language="javascript">
    var directionDisplay;
    var directionsService = new google.maps.DirectionsService();
	var map;
    var trafficLayer = null;
	var currentLayer = null;
	
  	jQuery(document).ready(function() {
  		//var addrs = ['219 4th Ave N Seattle Wa 98109','200 2nd Avenue North Seattle Wa 98109','325 5th Ave N Seattle Wa 98109'];
		directionsDisplay = new google.maps.DirectionsRenderer();
		<cfoutput>
		var addrs = [ "#URL.frstConAdd#|Stop No. : 1|#URL.frstConNm#"
			<cfif isdefined("URL.secShpAdd") and Len(#trim(URL.secShpAdd)#) gt 3 and #URL.secShpAdd# neq #URL.frstShpAdd# >
				 ,"#URL.secShpAdd#|Stop No. : 2|Shipper|#URL.secShpNm#" 
			</cfif>
			<cfif isdefined("URL.secConAdd") and Len(#trim(URL.secConAdd)#) gt 3>
				,"#URL.secConAdd#|Stop No. : 2|Consignee|#URL.secConNm#" 
			</cfif>
			<cfif isdefined("URL.thirdShpAdd") and Len(#trim(URL.thirdShpAdd)#) gt 3 and #URL.thirdShpAdd# neq #URL.secShpAdd# >
				,"#URL.thirdShpAdd#|Stop No. : 3|Shipper|#URL.thirdShpNm#" 
			</cfif>
			<cfif isdefined("URL.thirdConAdd") and Len(#trim(URL.thirdConAdd)#) gt 3>
				,"#URL.thirdConAdd#|Stop No. : 3|Consignee|#URL.thirdConNm#"
			</cfif>
			<cfif isdefined("URL.fourthShpAdd") and Len(#trim(URL.fourthShpAdd)#) gt 3 and #URL.fourthShpAdd# neq #URL.thirdShpAdd# >
				,"#URL.fourthShpAdd#|Stop No. : 4|Shipper|#URL.fourthShpNm#"
			</cfif>
			<cfif isdefined("URL.fourthConAdd") and Len(#trim(URL.fourthConAdd)#) gt 3>
				,"#URL.fourthConAdd#|Stop No. : 4|Consignee"
			</cfif>
			<cfif isdefined("URL.fifthShpAdd") and Len(#trim(URL.fifthShpAdd)#) gt 3 and #URL.fifthShpAdd# neq #URL.fourthShpAdd# >
				,"#URL.fifthShpAdd#|Stop No. : 5|Shipper|#URL.fifthShpNm#"
			</cfif>
			<cfif isdefined("URL.fifthConAdd") and Len(#trim(URL.fifthConAdd)#) gt 3>
				,"#URL.fifthConAdd#|Stop No. : 5|Consignee|#URL.fifthConNm#"
			</cfif>
		];
		</cfoutput>
		var markers = [];
		var marker_num = 0;
		// Process each address and get it's lat long
		var geocoder = new google.maps.Geocoder();
		var center = new google.maps.LatLngBounds();
		var infowindow = new google.maps.InfoWindow();
		
		var myLatlng = new google.maps.LatLng(document.getElementById('centerLatitude').value, document.getElementById('centerlLongitude').value);
			var myOptions = {
			  zoom: 9,
			  center: myLatlng,
			  mapTypeId: google.maps.MapTypeId.ROADMAP
			}
			map = new google.maps.Map(document.getElementById("themap"), myOptions);
			
			trafficLayer = new google.maps.TrafficLayer();
			
		for(k=0;k<addrs.length;k++){
			//var addr = addrs[k];
			var addr = addrs[k].split("|");
			addr = addr[0];
			geocoder.geocode({'address':addr},function(res,stat){
				if(stat==google.maps.GeocoderStatus.OK){
					// add the point to the LatLngBounds to get center point, add point to markers
					center.extend(res[0].geometry.location);
					markers[marker_num]=res[0].geometry.location;
					marker_num++;
					// actually display the map and markers, this is only done the last time
					if(k==addrs.length){
						directionsDisplay.setMap(map);
					    directionsDisplay.setPanel(document.getElementById("directionsPanel"));
						
						for(p=0;p<markers.length;p++){
							var mark = markers[p];
							addrsValues =  addrs[p].split("|")
							marker = new google.maps.Marker({
								title:addrsValues[1],
								map: map,
								position: mark
							});
							
						  <cfoutput>
						   google.maps.event.addListener(marker, 'click', (function(marker, p) {
							return function() {
							  addrsVal =  addrs[p].split("|")
							  if(addrsVal[1] == "Stop No. : 1")
							  {
							  	infowindow.setContent("<div  style='height:100px;width:500px;'> Load No. : #URL.loadNum#<br/> "+ addrsVal[1] + "<br/> Consignee Name : "+addrsVal[2] + "<br/> Consignee Address : "+addrsVal[0] +"</div>");
							  }
							  else
							  {
							  	if(addrsVal[2] == "Shipper")
							  	{
							  		infowindow.setContent("<div style='height:100px;width:500px;'> Load No. : #URL.loadNum#<br/> "+ addrsVal[1] + "<br/> Shipper Name : "+addrsVal[3] + "<br/> Shipper Address : "+addrsVal[0] +"</div>");
								}
								else
							  	{
							  		infowindow.setContent("<div style='height:100px;width:500px;'> Load No. : #URL.loadNum#<br/> "+ addrsVal[1] + "<br/> Consignee Name : "+addrsVal[3] + "<br/> Consignee Address : "+addrsVal[0] +"</div>");
								}	
							  }
							  infowindow.open(map, marker);
							}
						  })(marker, p));						  
						  </cfoutput>
						}	
						
    					// zoom map so all points can be seen
						map.fitBounds(center)
						
						// traffic button
					   var tbutton = document.createElement("button");
					   tbutton.innerHTML = "Traffic";
					   tbutton.style.position = "absolute";
					   tbutton.style.top = "6px";
					   tbutton.style.right = "112px";
					   tbutton.style.zIndex = 10;
					   tbutton.style.height="19px";
					   tbutton.style.width="55px";
					   map.getDiv().appendChild(tbutton);
					   tbutton.className = "lolight";
					   tbutton.onclick = function() {
					   	 traffic();
					     if (tbutton.className == "hilight") {
							  tbutton.className = "lolight";
						  } else {
							  tbutton.className = "hilight";
						  }
					   }

					}
				}else{
					console.log('can\'t find address');
				}
			});
		}
	
	});	
	
	
	
    function traffic() {
		//map.setCenter(new google.maps.LatLng(40.7142691, -74.0059729));
		map.setCenter(new google.maps.LatLng(document.getElementById('centerLatitude').value, document.getElementById('centerlLongitude').value));
		map.setZoom(12);
		trafficLayer.setMap(map);
		currentLayer = trafficLayer;
	  }
	
	function calcRoute() {
	<cfoutput>
		var request = {
		 origin: "#URL.frstShpAdd#",
		  <cfif isdefined("URL.fifthConAdd") and Len(trim(URL.fifthConAdd)) gt 3> destination: "#URL.fifthConAdd#", 
		  <cfelseif isdefined("URL.fifthShpAdd") and Len(trim(URL.fifthShpAdd)) gt 3> 
				<cfif (URL.fourthShpAdd) neq (URL.fifthShpAdd)> destination: "#URL.fifthShpAdd#", </cfif>
		  <cfelseif isdefined("URL.fourthConAdd") and Len(trim(URL.fourthConAdd)) gt 3> destination: "#URL.fourthConAdd#", 
		  <cfelseif isdefined("URL.fourthShpAdd") and Len(trim(URL.fourthShpAdd)) gt 3> 
				<cfif (URL.thirdShpAdd) neq (URL.fourthShpAdd)> destination: "#URL.fourthShpAdd#", </cfif>
		  <cfelseif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3> destination: "#URL.thirdConAdd#", 
		  <cfelseif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
			    <cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> destination: "#URL.thirdShpAdd#", </cfif>
		  <cfelseif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>destination: "#URL.secConAdd#",
	   	  <cfelseif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
			    <cfif (URL.frstShpAdd) neq (URL.secShpAdd)> destination: "#URL.secShpAdd#", </cfif>
		   <cfelse>
		       destination: "#URL.frstConAdd#",
		   </cfif>	
		   
		  waypoints: [
		  <cfif isdefined("URL.fifthConAdd") and Len(trim(URL.fifthConAdd)) gt 3>
			{ location:"#URL.frstConAdd#" }
			<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
			    <cfif (URL.frstShpAdd) neq (URL.secShpAdd)>, { location:"#URL.secShpAdd#" }</cfif>
		    </cfif>
			<cfif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>, { location:"#URL.secConAdd#" } </cfif>
	   	    <cfif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
			    <cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> ,{ location:"#URL.thirdShpAdd#" } </cfif>
			</cfif>	
			<cfif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3>, { location:"#URL.thirdConAdd#" } </cfif>
			<cfif isdefined("URL.fourthShpAdd") and Len(trim(URL.fourthShpAdd)) gt 3> 
				<cfif (URL.thirdShpAdd) neq (URL.fourthShpAdd)>, { location:"#URL.fourthShpAdd#" } </cfif>
			</cfif>	
			<cfif isdefined("URL.fourthConAdd") and Len(trim(URL.fourthConAdd)) gt 3>, { location:"#URL.fourthConAdd#" } </cfif>
			<cfif isdefined("URL.fifthShpAdd") and Len(trim(URL.fifthShpAdd)) gt 3> 
				<cfif (URL.fourthShpAdd) neq (URL.fifthShpAdd)>, { location:"#URL.fifthShpAdd#" }</cfif>
			</cfif>	
			],
		  <cfelseif isdefined("URL.fifthShpAdd") and Len(trim(URL.fifthShpAdd)) gt 3> 
			<cfif (URL.fourthShpAdd) neq (URL.fifthShpAdd)>
			  { location:"#URL.frstConAdd#" }
				<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
					<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>, { location:"#URL.secShpAdd#" }</cfif>
				</cfif>
				<cfif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>, { location:"#URL.secConAdd#" } </cfif>
				<cfif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
					<cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> ,{ location:"#URL.thirdShpAdd#" } </cfif>
				</cfif>	
				<cfif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3>, { location:"#URL.thirdConAdd#" } </cfif>
				<cfif isdefined("URL.fourthShpAdd") and Len(trim(URL.fourthShpAdd)) gt 3> 
					<cfif (URL.thirdShpAdd) neq (URL.fourthShpAdd)>, { location:"#URL.fourthShpAdd#" } </cfif>
				</cfif>	
				<cfif isdefined("URL.fourthConAdd") and Len(trim(URL.fourthConAdd)) gt 3>, { location:"#URL.fourthConAdd#" } </cfif>
				],	
			</cfif>
		  <cfelseif isdefined("URL.fourthConAdd") and Len(trim(URL.fourthConAdd)) gt 3>
		  	{ location:"#URL.frstConAdd#" }
				<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
					<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>, { location:"#URL.secShpAdd#" }</cfif>
				</cfif>
				<cfif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>, { location:"#URL.secConAdd#" } </cfif>
				<cfif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
					<cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> ,{ location:"#URL.thirdShpAdd#" } </cfif>
				</cfif>	
				<cfif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3>, { location:"#URL.thirdConAdd#" } </cfif>
				<cfif isdefined("URL.fourthShpAdd") and Len(trim(URL.fourthShpAdd)) gt 3> 
					<cfif (URL.thirdShpAdd) neq (URL.fourthShpAdd)>, { location:"#URL.fourthShpAdd#" } </cfif>
				</cfif>	
				], 
		  <cfelseif isdefined("URL.fourthShpAdd") and Len(trim(URL.fourthShpAdd)) gt 3> 
			<cfif (URL.thirdShpAdd) neq (URL.fourthShpAdd)>
				{ location:"#URL.frstConAdd#" }
				<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
					<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>, { location:"#URL.secShpAdd#" }</cfif>
				</cfif>
				<cfif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>, { location:"#URL.secConAdd#" } </cfif>
				<cfif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
					<cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> ,{ location:"#URL.thirdShpAdd#" } </cfif>
				</cfif>	
				<cfif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3>, { location:"#URL.thirdConAdd#" } </cfif>
				],
			</cfif>
		  <cfelseif isdefined("URL.thirdConAdd") and Len(trim(URL.thirdConAdd)) gt 3>
		  	{ location:"#URL.frstConAdd#" }
			<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
				<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>, { location:"#URL.secShpAdd#" }</cfif>
			</cfif>
			<cfif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>, { location:"#URL.secConAdd#" } </cfif>
			<cfif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
				<cfif (URL.secShpAdd) neq (URL.thirdShpAdd)> ,{ location:"#URL.thirdShpAdd#" } </cfif>
			</cfif>	
			],
		  <cfelseif isdefined("URL.thirdShpAdd") and Len(trim(URL.thirdShpAdd)) gt 3> 
			 <cfif (URL.secShpAdd) neq (URL.thirdShpAdd)>
			 	{ location:"#URL.frstConAdd#" }
				<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
					<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>, { location:"#URL.secShpAdd#" }</cfif>
				</cfif>
				<cfif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>, { location:"#URL.secConAdd#" } </cfif>
				],
			 </cfif>
		  <cfelseif isdefined("URL.secConAdd") and Len(trim(URL.secConAdd)) gt 3>
		  	{ location:"#URL.frstConAdd#" }
				<cfif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
					<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>, { location:"#URL.secShpAdd#" }</cfif>
				</cfif>
			],
	   	  <cfelseif isdefined("URL.secShpAdd") and Len(trim(URL.secShpAdd)) gt 3> 
			<cfif (URL.frstShpAdd) neq (URL.secShpAdd)>
				{ location:"#URL.frstConAdd#" }
			  ],	
			</cfif>
		   </cfif>
			 
			provideRouteAlternatives: false,
			travelMode: google.maps.DirectionsTravelMode.DRIVING
		  </cfoutput>
		};
		
		directionsService.route(request, function(response, status) {
		  if (status == google.maps.DirectionsStatus.OK) {
			directionsDisplay.setDirections(response);
		  }
		});
		
		
		jQuery("#ext-gen6 div:nth-child(1) div div:nth-child(7) img").each(function(i){
			if($(this).attr('src') == 'http://chart.apis.google.com/chart?cht=mm&chs=32x32&chco=ffffff,009900,000000&ext=.png') 
			{
				$(this).hide();
			}
		});
	
  }
	
  </script>
  


</body>
</html>
