<!--- from:2 executive blvd, 10901 to:100 broadway, ny, ny to:14 Avenue R, Brooklyn, NY 11223 --->
<cfajaximport params="#{googlemapkey='AIzaSyAMvv7YySXPntllOqj7509OH-9N3HgCJmw'}#">
<cfset theAddress = "Lafayette, LA">

<html>

<head>
<style>
#result {
    /*width:500px;*/
	width:290px;
    height: 500px;
    overflow: auto;

}
</style>
</head>

<body>

<div style="width: 800px;">
 <div style="width: 300px; height: 530px; float: left;">
 	<div style="text-align:center; padding-top:8px;">
		<cfform name="me" action="" method="post">
			<cfinput name="button" type="button" id="doDirections" value="Get Directions" />
		</cfform>
	</div>
 	<div id="result"></div>
 </div> 
 <div id="panel" style="width:500px; float: right;">
	 <cfmap name="themap" centeraddress="#URL.frstShpAdd#" width="500" height="535" zoomlevel="9" markercolor="009900">
	
	
	<cfif isdefined("URL.frstConAdd") and Len(#trim(URL.frstConAdd)#) gt 3>
		<cfmapitem 
				address="#URL.frstConAdd#" 
				markerwindowcontent="Stop No. 1 <br/>Consignee Name : #URL.frstConNm#<br/>Consignee Address : #URL.frstConAdd#" 
				name="mapitemname" 
				markercolor="009900" 
				tip="stop1"
				>
	</cfif>
	
	<cfif isdefined("URL.secShpAdd") and Len(#trim(URL.secShpAdd)#) gt 3 and #URL.secShpAdd# neq #URL.frstShpAdd# >
		<cfmapitem 
			address="#URL.secShpAdd#" 
			markerwindowcontent="Stop No. 2<br> Shipper Name : #URL.secShpAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" 
			/>
	</cfif>
	<cfif isdefined("URL.secConAdd") and Len(#trim(URL.secConAdd)#) gt 3>
		<cfmapitem 
			address="#URL.secConAdd#" 
			markerwindowcontent="Stop No. 2<br> Consignee Name : #URL.secConAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" 
			/>
	</cfif>
	<cfif isdefined("URL.thirdShpAdd") and Len(#trim(URL.thirdShpAdd)#) gt 3 and #URL.thirdShpAdd# neq #URL.secShpAdd# >
		<cfmapitem 
			address="#URL.thirdShpAdd#" 
			markerwindowcontent="Stop No. 3<br> Shipper Name : #URL.thirdShpAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" 
			/>
	</cfif>
	<cfif isdefined("URL.thirdConAdd") and Len(#trim(URL.thirdConAdd)#) gt 3>
		<cfmapitem 
			address="#URL.thirdConAdd#" 
			markerwindowcontent="Stop No. 3<br> Consignee Name : #URL.thirdConAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" />
	</cfif>
	
	
	
	<cfif isdefined("URL.fourthShpAdd") and Len(#trim(URL.fourthShpAdd)#) gt 3 and #URL.fourthShpAdd# neq #URL.thirdShpAdd# >
		<cfmapitem 
			address="#URL.fourthShpAdd#" 
			markerwindowcontent="Stop No. 4<br> Shipper Name : #URL.fourthShpAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" />
	</cfif>
	<cfif isdefined("URL.fourthConAdd") and Len(#trim(URL.fourthConAdd)#) gt 3>
		<cfmapitem 
			address="#URL.fourthConAdd#" 
			markerwindowcontent="Stop No. 4<br> Consignee Name : #URL.fourthConAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" />
	</cfif>
	
	
	
	<cfif isdefined("URL.fifthShpAdd") and Len(#trim(URL.fifthShpAdd)#) gt 3 and #URL.fifthShpAdd# neq #URL.fourthShpAdd# >
		<cfmapitem 
			address="#URL.fifthShpAdd#" 
			markerwindowcontent="Stop No. 5<br> Shipper Name : #URL.fifthShpAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" />
	</cfif>
	<cfif isdefined("URL.fifthConAdd") and Len(#trim(URL.fifthConAdd)#) gt 3>
		<cfmapitem 
			address="#URL.fifthConAdd#" 
			markerwindowcontent="Stop No. 5<br> Consignee Name : #URL.fifthConAdd#" 
			name="mapitemname1" 
			markercolor="009900" 
			tip="stop2" />
	</cfif>
				
	</cfmap>
 </div> 
</div>

</body>
</html>



<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script>


/*var map;
var markersArray = [];


function clearOverlays() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(null);
    }
  }
}
*/
$(document).ready(function() {

	$("#doDirections").click(function() {
			
		//debugger
		//clearOverlays();
		
		//var youraddy = $.trim($("#youraddress").val())
		//var youraddy = $.trim("Lafayette, LA")
		//if(youraddy == '') return
		//console.log('Directions from '+youraddy)
		var mapOb = ColdFusion.Map.getMapObject("themap");
		
		var dir = new GDirections(mapOb, document.getElementById('result'));		
		
		<cfoutput>
		dir.load("from: #URL.frstShpAdd# to: #URL.frstConAdd#" 

		<cfif isdefined("URL.secShpAdd") and Len(#trim(URL.secShpAdd)#) gt 3> 
			<cfif #URL.frstShpAdd# neq #URL.secShpAdd#>+" to: #URL.secShpAdd#"</cfif>
		</cfif>
		<cfif isdefined("URL.secConAdd") and Len(#trim(URL.secConAdd)#) gt 3>+" to: #URL.secConAdd#"</cfif>


		<cfif isdefined("URL.thirdShpAdd") and Len(#trim(URL.thirdShpAdd)#) gt 3> 
			<cfif #URL.secShpAdd# neq #URL.thirdShpAdd#>+" to: #URL.thirdShpAdd#"</cfif>
		</cfif>
		<cfif isdefined("URL.thirdConAdd") and Len(#trim(URL.thirdConAdd)#) gt 3>+" to: #URL.thirdConAdd#"</cfif>

		<cfif isdefined("URL.fourthShpAdd") and Len(#trim(URL.fourthShpAdd)#) gt 3> 
			<cfif #URL.thirdShpAdd# neq #URL.fourthShpAdd#>+" to: #URL.fourthShpAdd#"</cfif>
		</cfif>
		<cfif isdefined("URL.fourthConAdd") and Len(#trim(URL.fourthConAdd)#) gt 3>+" to: #URL.fourthConAdd#"</cfif>


		<cfif isdefined("URL.fifthShpAdd") and Len(#trim(URL.fifthShpAdd)#) gt 3> 
			<cfif #URL.fourthShpAdd# neq #URL.fifthShpAdd#>+" to: #URL.fifthShpAdd#"</cfif>
		</cfif>
		<cfif isdefined("URL.fifthConAdd") and Len(#trim(URL.fifthConAdd)#) gt 3>+" to: #URL.fifthConAdd#"</cfif>
		);
		</cfoutput>
		
		// Code To Remove Extra Markers
		$("#ext-gen6 div:nth-child(1) div div:nth-child(7) img").each(function(i){
			if($(this).attr('src') == 'http://chart.apis.google.com/chart?cht=mm&chs=32x32&chco=ffffff,009900,000000&ext=.png') 
			{
				$(this).hide();
			}
		});


	});
});

</script>