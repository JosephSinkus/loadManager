<!---<cfinvoke component="#variables.#" method="UserTimeCheck"/>--->

	<!---<cfset variables.dsn = 'LoadManagerBindu' />--->
     
     <cfdump var="#Application.dsn#">
     
	<cfset variables.dsn = #Application.dsn# />
      <cfdump var="#variables.dsn#">
     
	  <cfset todayDate = #Now()#> 
        <cfset logindate = #DateFormat(todayDate, "yyyy-mm-dd")# >
        <cfset logintime = #TimeFormat(todayDate, "HH")#>
           
            <cfquery name="chkusers1" datasource="LoadManagerBindu" result="c">
                SELECT * From Employees
             
            </cfquery>
           
           
            <cfquery name="chkusers" datasource="#variables.dsn#" result="c">
                SELECT User_Track.user_id, User_Track.track_id, User_Track.ip, User_Track.dated, User_Track.timing
                FROM User_Track
                WHERE User_Track.dated = '#logindate#' AND User_Track.timing ! = #logintime# And User_Track.status = 'active'
             
            </cfquery>
              
        <cfif chkusers.recordcount gt 0>
       <cfquery name="getrow" datasource="#variables.dsn#" result="e">
        
                 SELECT	Employees.current_count
                 FROM Employees
                 WHERE Employees.EmployeeID = '#chkusers.user_id#'
             <cfabort>
            </cfquery>
        
        <cfset usercount = #getrow.current_count#>
     
        <cfloop query="chkusers">
        
        	<cfquery name="getrow" datasource="#variables.dsn#" result="e">
        
                 SELECT	Employees.current_count
                 FROM Employees
                 WHERE Employees.EmployeeID = '#chkusers.user_id#'
             
            </cfquery>
        
        <cfset usercount = #getrow.current_count#>
   
       		 <cfquery name="editstatus" datasource="#variables.dsn#" result="e">
            
                 UPDATE	Employees
                 set 
                 Employees.current_count = #--usercount#
                 WHERE Employees.EmployeeID = '#chkusers.user_id#'
             
            </cfquery>
               
            <cfquery name="editstatus2" datasource="#variables.dsn#" result="e">
            
                 UPDATE	User_Track
                 set 
                 User_Track.status = 'inactive'
                 WHERE User_Track.track_id = #chkusers.track_id#
                 
            </cfquery>
                
        </cfloop>
        <cfelse>
        no record to update.
        </cfif>