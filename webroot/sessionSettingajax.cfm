<cfif structkeyexists(url,"checked") and structkeyexists(url,"searchText") and structkeyexists(url,"csfrToken")>
	<cfset validate = CSRFverifyToken(csfrToken)> 
	<cfif validate>
		<cfif url.checked>		
			<cfset session.searchtext = url.searchText>
		<cfelse>
			<cfset session.searchtext = ''>
		</cfif>
	</cfif>	
</cfif>
