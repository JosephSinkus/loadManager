  <cfajaxproxy cfc="#request.cfcpath#.customergateway" jsclassname="ajaxStateID">
         <html>
         <head>
         <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js?file=api&amp;v=2&amp;sensor=true_or_false&amp;key=#Application.gAPI#">
         </script>
         <script>
          var map;
          var geocoder;
          var address;
          var zipNo;
          var lat;
          var longt;
           function initialize(zipval) {
           	
			zipval=zipval.substring(0,5);			
            map = new GMap2(document.getElementById("mainMap"),{ size: new GSize(640,480)});
             var res1=ColdFusion.Map.getLatitudeLongitude(zipval, callbackHandler);
              }
           function getAddress(overlay, latlng) {
             if (latlng != null) {

               address = latlng;
               geocoder.getLocations(latlng, showAddress);
             }
           }

           function showAddress(response) {
             map.clearOverlays();
             if (!response || response.Status.code != 200) {
               alert("Status Code:" + response.Status.code);
             } else {
               place = response.Placemark[0];
               point = new GLatLng(place.Point.coordinates[1],place.Point.coordinates[0]);
                          
               var loc=place.address;
               var strmylocation=loc.toString();
               var mylocation=strmylocation.split(',');
                            
               var myStateCode = mylocation[2].substring(1,3);
             
               //document.getElementById("location").value=place.address;
               document.getElementById("City").value=mylocation[1];
               var getStateId = new ajaxStateID();
               var stateIDNow = getStateId.getStatesID(myStateCode);
               document.getElementById("state").value=stateIDNow;
               
                        }
           }
           
           function callbackHandler(result) 
             {
             //document.getElementById('result'+zipNo).value=result;
             var myList = result.toString();
             var myvalue=myList.split(',');
             var myLastVal1=myvalue[0];
             var myLastVal2=myvalue[1];        
             var myLastVal1Len = myLastVal1.length;
             var myLastVal2Len = myLastVal2.length;        
             var lat=myLastVal1.substring(1,myLastVal1Len);
             var longt=myLastVal2.substring(1,myLastVal2Len-1);
             map.setCenter(new GLatLng(lat,longt), 15);
             map.addControl(new GLargeMapControl);
             getAddress(1,result);        
             //GEvent.addListener(map, getAddress);        
             geocoder = new GClientGeocoder();                
            
             } 
             
           </script>
           </head>
           <body>
           
             <cfajaximport params="#{googlemapkey='#Application.gAPI#'}#">
             <div style="width:50px;height:50px;display:none;"><cfmap name="mainMap" width="50" height="50" centeraddress="35801" /></div> 
             <cfinput type="text" name="Zipcode" value="#Zipcode#" tabindex="5" onchange="initialize(this.value)">
            
           </body>
           </html>    
         