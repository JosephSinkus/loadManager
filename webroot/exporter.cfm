
<cfoutput>
	<cfquery name="getCountries" datasource="#Application.dsn#">
    	select * from Countries
    </cfquery>
	
	
	<cfloop query="getCountries">
		INSERT INTO Countries (uuid, countryCode, countryName, countryStandardName) VALUES ('#CreateUUID()#', '#getCountries.CountryCode#', '#getCountries.Country#', '#getCountries.standardName#');<br />
	</cfloop>
	
</cfoutput>