<cfset request.subnavigation = includeTemplate("views/admin/carrierNav.cfm", true) />
<cfset request.content=includeTemplate("views/pages/equipment/addDriverEquipment.cfm",true)/>
<cfset includeTemplate("views/templates/maintemplate.cfm") />