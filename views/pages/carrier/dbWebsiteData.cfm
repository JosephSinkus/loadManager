	<cfset session.AuthType_Common_status=#request.qLiWebsiteData.DOTCommonAuthorityStatus#>
	<cfset session.AuthType_Contract_status =#request.qLiWebsiteData.DOTContractAuthorityStatus# >
	<cfset session.AuthType_Broker_status = #request.qLiWebsiteData.DOTBrokerAuthorityStatus#>
	<cfset session.AuthType_Common_appPending = #request.qLiWebsiteData.DOTCommonAppPending#>
	<cfset session.AuthType_Contract_appPending = #request.qLiWebsiteData.DOTContractAppPending#>
	<cfset session.AuthType_Broker_appPending = #request.qLiWebsiteData.DOTBrokerAppPending#>
	<cfset session.bipd_Insurance_required = #request.qLiWebsiteData.InsLiabilities#>
	<cfset session.bipd_Insurance_on_file = #request.qLiWebsiteData.InsOnFileLiabilities#>
	<cfset session.cargo_Insurance_required = #request.qLiWebsiteData.InsCargo#>
	<cfset session.cargo_Insurance_on_file = #request.qLiWebsiteData.InsOnFileCargo#>
	<cfset session.session.household_goods = #request.qLiWebsiteData.CargoAuthHouseHold#>

