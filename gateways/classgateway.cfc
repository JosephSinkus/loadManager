<cfcomponent output="false">
<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>
<!----Get All Equipments Information---->
<cffunction name="getAllClasses" access="public" output="false" returntype="any">
    <cfargument name="ClassID" required="no" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
	<cfargument name="status" required="no" type="string">
             <cfquery name="qrygetclasses" datasource="#variables.dsn#">
                 select * from  CommodityClasses
                 where 1=1
         		 <cfif isdefined('arguments.ClassID') and len(arguments.ClassID)>
         			and ClassID='#arguments.ClassID#'
         		</cfif>	
				<cfif isdefined('arguments.status') and len(arguments.status)>
					and isActive = '#arguments.status#'
				</cfif>
                ORDER BY (SELECT CAST(ClassName AS float))
             </cfquery>
                 
 <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
              
           <cfquery datasource="#variables.dsn#" name="getnewAgent">
                       select *  from CommodityClasses
                       where 1=1
                       order by #arguments.sortby# #arguments.sortorder#;
           </cfquery>
                     
          <cfreturn getnewAgent>               
                       
</cfif>
             <cfreturn qrygetclasses>
</cffunction>
<!---------get class for add/editload page---->
<cffunction name="getloadClasses" access="public" output="false" returntype="any">
    <cfargument name="ClassID" required="no" type="any">
    <cfargument name="sortorder" required="no" type="any">
    <cfargument name="sortby" required="no" type="any">
	<cfargument name="status" required="no" type="string">
             <cfquery name="qrygetclasses" datasource="#variables.dsn#">
                 select classId,className from  CommodityClasses
                 where 1=1
         		 <cfif isdefined('arguments.ClassID') and len(arguments.ClassID)>
         			and ClassID='#arguments.ClassID#'
         		</cfif>	
				<cfif isdefined('arguments.status') and len(arguments.status)>
					and isActive = '#arguments.status#'
				</cfif>
                ORDER BY (SELECT CAST(ClassName AS float))
             </cfquery>
                 
 <cfif isDefined("arguments.sortorder") and isDefined("arguments.sortby") and len(arguments.sortby)> 
              
           <cfquery datasource="#variables.dsn#" name="getnewAgent">
                       select  classId,className   from CommodityClasses
                       where 1=1
                       order by #arguments.sortby# #arguments.sortorder#;
           </cfquery>
                     
          <cfreturn getnewAgent>               
                       
</cfif>
             <cfreturn qrygetclasses>
</cffunction>
<!---Add Equipment Information---->
<cffunction name="Addclass" access="public" output="false" returntype="any">
   <cfargument name="formStruct" type="struct" required="no" />
      <cfquery name="insertquery" datasource="#variables.dsn#">
       insert into CommodityClasses(ClassName,IsActive)
       values(
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ClassName#">,
              <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">                     
              )
   </cfquery>
   <cfreturn "Class has been added Successfully">	    	
</cffunction>
<!---Update Equipment --->
<cffunction name="Updateclass" access="public" output="false" returntype="any">
    <cfargument name="formStruct" type="struct">
    <cfargument name="editid" type="any"> 
    <cfquery name="qryupdate" datasource="#variables.dsn#">
         update CommodityClasses
         set  ClassName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ClassName#">,
              IsActive=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">
        where ClassID='#arguments.formStruct.editid#' 
     </cfquery>
     <cfreturn "Class has been updated Successfully">
</cffunction>
<!--- Delete Equipment---->
<cffunction name="deleteClasses"  access="public" output="false" returntype="any">
<cfargument name="ClassID" type="any" required="yes">
    <cftry>
    		<cfquery name="qryDelete" datasource="#variables.dsn#">
    			 delete from CommodityClasses where  ClassID='#arguments.ClassID#'
    		</cfquery>
    		<cfreturn "Class has been deleted successfully.">	
    		<cfcatch type="any">
    			<cfreturn "Delete operation has been not successfull.">
    		</cfcatch>
    	</cftry>
</cffunction>  

<cffunction name="getSearchedClass" access="public" output="false" returntype="query">
	<cfargument name="searchText" required="yes" type="any">
	<CFSTOREDPROC PROCEDURE="searchClass" DATASOURCE="#variables.dsn#"> 
		<cfif isdefined('arguments.searchText') and len(arguments.searchText)>
		 	<CFPROCPARAM VALUE="#arguments.searchText#" cfsqltype="CF_SQL_VARCHAR">  
		 <cfelse>
		 	<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
		 </cfif>
		 <CFPROCRESULT NAME="QreturnSearch"> 
	</CFSTOREDPROC>
    <cfreturn QreturnSearch>
</cffunction>

</cfcomponent>