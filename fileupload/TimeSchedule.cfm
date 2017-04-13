<cfschedule action = "update"
    task = "TimeCheck" 
    operation = "HTTPRequest"
    url = "http://fcs-net.securec24.ezhostingserver.com/loadmanageryasir/www/fileupload/UserTimeCheck.cfm"
    startDate = "4/09/13"
    startTime = "10:13 AM"
    interval = "3600"
    resolveURL = "Yes"
  
    >