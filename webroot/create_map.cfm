<!---<cfdump var="#URL#">--->
<cfajaximport params="#{googlemapkey='AIzaSyAMvv7YySXPntllOqj7509OH-9N3HgCJmw'}#">
<!---<cfmap centeraddress="3803 Locust Walk, Philadelphia PA 19130" zoomlevel="16" width="600" height="600" />--->
<cfparam name="ship_ConsName" default="" >
<cfparam name="URL.city" default="" >
<cfparam name="URL.loc" default="" >
<cfparam name="URL.state" default="" >
<cfparam name="URL.stopNo" default="" >
<cfparam name="URL.loadNum" default="" >

<cfif isdefined("URL.shipOrConsName")>
	<cfset ship_ConsName = "<b>Name : </b>"&#URL.shipOrConsName#&"<br/>">
</cfif>

<cfset add = #URL.loc#&", "&#URL.city#&", "&#URL.state# >
<cfset toolTip = "#stopNo#"&" , "&"#loadNum#">

<cfset marker_contents = 
#ship_ConsName#&"<b>Address : </b>"&#URL.loc#&"<br/>"&"<b>Load No. : </b>"&"#URL.loadNum#"&"<br/>"&"<b>Stop No. : </b>"&#URL.stopNo#>

<cfoutput>#add# <!---, #toolTip# , #ship_ConsName#---></cfoutput>
<cfmap 
	centeraddress="#add#" 
    zoomlevel="16" 
    width="600" 
    height="600" 
    tip="#toolTip#" 
	markercolor="009900"
<!---o
	markerbind="bind expression" 
    markercolor="marker color" 
    markericon="icon path    " --->
    markerwindowcontent="#marker_contents#" 
    name="name"
    />


