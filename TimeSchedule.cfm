	<cfschedule action = "update"
    task = "TimeCheck" 
    operation = "HTTPRequest"
    url = "http://fcs-net.securec24.ezhostingserver.com/loadmanageryasir/www/fileupload/UserTimeCheck.cfm"
    startDate = "4/10/13"
    startTime = "07:19 AM"
    interval = "360"
    resolveURL = "Yes"
    >