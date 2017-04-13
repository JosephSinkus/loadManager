<cffunction name="clean_javascript_data" hint="Clean data by removing characters that cause issue with JS" returntype="string" output="false">
	<cfargument name="input_string" required="true" type="string">
	<cfargument name="include_cdata" required="false" type="boolean" default="true">
	
	<cfset clean_string	= Replace(ARGUMENTS.input_string,"\","\\","all") /><!--- Clean \ --->
	<cfset clean_string	= Replace(clean_string,"""","\""","all") /><!--- Clean ""--->
	<cfset clean_string	= Replace(clean_string,"'","\'","all") /><!--- Clean ' --->
	<cfset clean_string	= Replace(clean_string,chr(10),"","all") /><!--- Clean chr(10) --->
	<cfset clean_string	= Replace(clean_string,chr(13),"","all") /><!--- Clean chr(13) --->
	<cfif include_cdata>
		<cfset clean_string	= "<![CDATA["&clean_string&"]]>" /><!--- Add CDATA to consider the content as data --->
	</cfif>
	
	<cfreturn clean_string />
</cffunction>