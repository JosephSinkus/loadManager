<cfcomponent output="false">
<cffunction name="init" access="public" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes" />
	<cfset variables.dsn = Application.dsn />
</cffunction>
<!----Get All Equipments Information---->
<cffunction name="getAllEquipments" access="public" output="false" returntype="any">
    <cfargument name="EquipmentID" required="no" type="any">
	<cfargument name="sortorder" required="no" type="any">
	<cfargument name="sortby" required="no" type="any">
	<cfargument name="EquipmentMaint" default="0">
	<cfargument name="maintenanceWithEquipment" default="0">
	
	<cfset currentDate=now()>
    <cfif structKeyExists(arguments,"sortorder") and structKeyExists(arguments,"sortby") and len(arguments.sortby)> 
        <cfquery datasource="#variables.dsn#" name="getnewAgent">
			select e.* <cfif arguments.EquipmentMaint>,emt.Description,emt.NextDate,emt.NextOdometer</cfif> from Equipments e
			<cfif arguments.EquipmentMaint>
				INNER JOIN EquipmentMaint emt on emt.EquipID = e.EquipmentID
			</cfif>
			where 1=1
			<cfif arguments.EquipmentMaint>
				and  e.EquipmentID in(
					select Distinct(e.EquipmentID) from Equipments e
					INNER JOIN EquipmentMaint em
					ON e.EquipmentID=em.EquipID
					<cfif not arguments.maintenanceWithEquipment>
						where e.Odometer> em.NextOdometer or em.NextDate < <cfqueryparam value="#currentDate#" cfsqltype="cf_sql_timestamp">
					</cfif>	
				)
				<cfif not arguments.maintenanceWithEquipment>
					AND e.Odometer> emt.NextOdometer or emt.NextDate < <cfqueryparam value="#currentDate#" cfsqltype="cf_sql_timestamp">
				</cfif>	
			</cfif>
			order by #arguments.sortby# #arguments.sortorder#;
		</cfquery>
		<cfreturn getnewAgent>
    </cfif>
	
	<cfquery name="qrygetcustomers" datasource="#variables.dsn#">
		select e.*<cfif arguments.EquipmentMaint>,emt.Description,emt.NextDate,emt.NextOdometer</cfif> 
		from  Equipments e
		<cfif arguments.EquipmentMaint>
			INNER JOIN EquipmentMaint emt on emt.EquipID = e.EquipmentID
		</cfif>
		where 1=1  
		<cfif arguments.EquipmentMaint>
			AND e.EquipmentID IN (
				select Distinct(e.EquipmentID)  from Equipments e
				INNER JOIN EquipmentMaint em
				ON e.EquipmentID=em.EquipID
				<cfif not arguments.maintenanceWithEquipment>
					where e.Odometer> em.NextOdometer or em.NextDate < <cfqueryparam value="#currentDate#" cfsqltype="cf_sql_timestamp">
				</cfif>	
			)
			<cfif not arguments.maintenanceWithEquipment>
				AND e.Odometer> emt.NextOdometer or emt.NextDate < <cfqueryparam value="#currentDate#" cfsqltype="cf_sql_timestamp">
			</cfif>	
		</cfif>
		<cfif structKeyExists(arguments,"EquipmentID") and len(arguments.EquipmentID)>
			and e.EquipmentID= <cfqueryparam value="#arguments.EquipmentID#">
		</cfif>
		ORDER BY e.EquipmentName 
	</cfquery>	
	<cfreturn qrygetcustomers>
</cffunction>
<cffunction name="getloadEquipments" access="public" output="false" returntype="any">
    <cfargument name="EquipmentID" required="no" type="any">
	<cfargument name="sortorder" required="no" type="any">
	<cfargument name="sortby" required="no" type="any">
		<cfquery name="qrygetcustomers" datasource="#variables.dsn#">
			select equipmentID,equipmentname from  Equipments
			where 1=1
			<cfif structKeyExists(arguments,"EquipmentID") and len(arguments.EquipmentID)>
				and EquipmentID='#arguments.EquipmentID#'
			</cfif>
			and IsActive=1
			ORDER BY EquipmentName	
		</cfquery>
    <cfif structKeyExists(arguments,"sortorder") and structKeyExists(arguments,"sortby") and len(arguments.sortby)>   
        <cfquery datasource="#variables.dsn#" name="getnewAgent">
		   select  equipmentID,equipmentname  from Equipments
		   where 1=1
		   order by #arguments.sortby# #arguments.sortorder#;
        </cfquery>       
        <cfreturn getnewAgent>                 
    </cfif>
    <cfreturn qrygetcustomers>
</cffunction>
<!---Add Equipment Information---->
<cffunction name="Addequipment" access="public" output="false" returntype="any">
	<cfargument name="formStruct" type="struct" required="no" />
	<cfif structKeyExists(arguments.formStruct,"PEPCODE")>
		<cfset PEPcode=True>
	<cfelse>
		<cfset PEPcode=False>
	</cfif>
	<cfif structKeyExists(arguments.formStruct,"driverowned")>
        <cfset driverowned=True>
	<cfelse>
        <cfset driverowned=False>
	</cfif>
    <cfquery name="insertquery" datasource="#variables.dsn#" result="resullt">
		declare @equipmentID uniqueidentifier
		set @equipmentID = NewID();
		insert into Equipments(
			EquipmentCode,EquipmentID,EquipmentName,IsActive,CreatedBy,LastModifiedBy,CreatedDateTime,LastModifiedDateTime,CreatedByIP,GUID,PEPCode,Width,Length
			<cfif structKeyExists(arguments.formStruct, "freightBroker")>
				,TranscoreCode,PosteverywhereCode,ITSCode,LoadboardCode
			</cfif>
			<cfif structKeyExists(arguments.formStruct, "unitNumber")>
              ,Odometer,unitNumber, vin, licensePlate, Driver, driverowned, Notes
			</cfif>
			<cfif structKeyExists(arguments.formStruct, "tagexpirationdate") AND arguments.formStruct.tagexpirationdate NEQ "">
				,tagexpirationdate 
			</cfif>
			<cfif structKeyExists(arguments.formStruct, "annualDueDate") AND arguments.formStruct.annualDueDate NEQ "">
				,annualDueDate
			</cfif>
        )
        values(
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentCode#">,
			    @equipmentID,
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentName#">,
			    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">,
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.adminUserName#">,
			    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">, 
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_USER_AGENT#">,
			    '#PEPcode#',
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Width)#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Length)#">
			   <cfif structKeyExists(arguments.formStruct, "freightBroker")>
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.TranscoreCode#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.PosteverywhereCode#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ITSCode#">      
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.123loadboardcode#">
			    </cfif> 
                <cfif structKeyExists(arguments.formStruct, "unitNumber")>
                   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.formStruct.Odometer)#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.unitNumber#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.vin#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.licensePlate#">                  
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Driver#">
                   ,<cfqueryparam cfsqltype="cf_sql_bit" value="#driverowned#">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Notes#">
                </cfif>
                <cfif structKeyExists(arguments.formStruct, "tagexpirationdate") AND arguments.formStruct.tagexpirationdate NEQ "">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.tagexpirationdate#">
                </cfif>
                <cfif structKeyExists(arguments.formStruct, "annualDueDate") AND arguments.formStruct.annualDueDate NEQ "">
                   ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.annualDueDate#">
                </cfif>
              );
			select @equipmentID as EquipmentID;
   </cfquery>
    <!--- If there are any files attached to this load then move from temp table to the main table --->
   <cfif structKeyExists(arguments.formStruct,"tempEquipmentId")>
	   <cfinvoke method="linkAttachments" tempEquipmentId="#arguments.formStruct.tempEquipmentId#" permEquipmentId="#insertquery.EQUIPMENTID#">
   </cfif>
   <cfreturn "Equipment has been added Successfully">	    	
</cffunction>

<!--- Link attachments --->
<cffunction name="linkAttachments">	
	<cfargument name="tempEquipmentId" type="string" required="yes" />
	<cfargument name="permEquipmentId" type="string" required="yes" />
	<cfquery name="retriveFromTemp" datasource="#application.dsn#">
		select * from fileattachmentstemp where linked_id ='#tempEquipmentId#'
	</cfquery>
	<cfset flagFile = 0>
	<cfif retriveFromTemp.recordcount neq 0>
		<cfloop query="retriveFromTemp">
			<cfquery name="insertFilesUploaded" datasource="#application.dsn#">
				insert into FileAttachments(linked_Id,linked_to,attachedFileLabel,attachmentFileName,uploadedBy)
				values('#permEquipmentId#','#retriveFromTemp.linked_to#','#retriveFromTemp.attachedFileLabel#','#retriveFromTemp.attachmentFileName#','#retriveFromTemp.uploadedBy#')
			</cfquery>
		</cfloop>	
		<cfset flagFile =1>
	</cfif>	
	<cfif flagFile eq 1>
		<cfquery name="deleteTempFiles" datasource="#application.dsn#">
			delete from fileattachmentstemp where linked_id = '#tempEquipmentId#'
		</cfquery>
	</cfif>
</cffunction>


<!---Update Equipment --->
	<cffunction name="Updateequipment" access="public" output="false" returntype="any">
		<cfargument name="formStruct" type="struct">
		<cfargument name="editid" type="any">
			<cfif structKeyExists(arguments.formStruct,"PEPCODE")>
				<cfset PEPcode=True>
			<cfelse>
				<cfset PEPcode=False>
			</cfif> 
			<cfif structKeyExists(arguments.formStruct,"driverowned")>
				<cfset driverowned=True>
			<cfelse>
				<cfset driverowned=False>
			</cfif>
			<cfquery name="qryupdate" datasource="#variables.dsn#">
				update Equipments
				set  EquipmentCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentCode#">,
					EquipmentName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.EquipmentName#">,
					IsActive=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.formStruct.Status#">,
					UpdatedByIP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
					PEPCode='#PEPcode#',
					Length=<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Length)#">,
					Width=<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Width)#">
				<cfif structKeyExists(arguments.formStruct, "freightBroker")>	
					,TranscoreCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.TranscoreCode#">
					,PosteverywhereCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.PosteverywhereCode#">
					,ITSCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.ITSCode#">
					,LoadboardCode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.123LoadboardCode#">
				</cfif>	
			    <cfif structKeyExists(arguments.formStruct, "unitNumber")>
					,unitNumber=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.unitNumber#">
				</cfif>
				<cfif structKeyExists(arguments.formStruct, "vin")>
					,vin=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.vin#">
				</cfif>
				<cfif structKeyExists(arguments.formStruct, "licensePlate")>
					,licensePlate=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.licensePlate#">
				</cfif>
				<cfif structKeyExists(arguments.formStruct, "Odometer")>
					,Odometer=<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.formStruct.Odometer)#">
				</cfif>
				<cfif structKeyExists(arguments.formStruct, "tagexpirationdate")>
					,tagexpirationdate=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.tagexpirationdate#">
				</cfif>
				<cfif structKeyExists(arguments.formStruct, "annualDueDate")>
					,annualDueDate=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.formStruct.annualDueDate#">
				</cfif>
				<cfif structKeyExists(arguments.formStruct, "Driver")>
					,Driver=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Driver#">
					<cfif isDefined("driverowned")>
						  ,driverowned=<cfqueryparam cfsqltype="cf_sql_bit" value="#driverowned#">
					</cfif>
				</cfif>              
				<cfif structKeyExists(arguments.formStruct, "Notes")>
					,Notes=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Notes#">
				</cfif>
				where EquipmentID='#arguments.formStruct.editid#' 
			</cfquery>
		<cfreturn "Equipment has been updated Successfully">
	</cffunction>
	<!--- Delete Equipment---->
	<cffunction name="deleteEquipments"  access="public" output="false" returntype="any">
		<cfargument name="EquipmentID" type="any" required="yes">
			<cftry>
			<!---delete fileattachment table entry and associated files in equipments--->
			<cfquery name="qryGetfileAttachmentsEquipments" datasource="#variables.dsn#">
				select attachmentFileName,linked_Id from FileAttachments
				where  linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentID#">
					and linked_to=57
			</cfquery>
			<cfif qryGetfileAttachmentsEquipments.recordcount>
				<cfloop query="qryGetfileAttachmentsEquipments">
					<cfset variables.equipments = expandPath('../fileupload/img/#qryGetfileAttachmentsEquipments.attachmentFileName#')>
					<cfquery name="deleteItems" datasource="#variables.dsn#">
						delete from FileAttachments where linked_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetfileAttachmentsEquipments.linked_Id#">
					</cfquery>
					<!---cfdirectory action="list" name="qlist" directory="#variables.maintenanceTrans#"--->
					<cfif fileexists(variables.equipments)>
						<cffile action = "delete"  file = "#variables.equipments#">
					</cfif>
				</cfloop>	
			</cfif>
			<!---delete fileattachment table entry and associated files in equipmentMaintenance--->
			<cfquery name="qryGetEquipMainT" datasource="#variables.dsn#">
				select EquipMainID from EquipmentMaint
				where  EquipID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentID#">
			</cfquery>
			<cfif qryGetEquipMainT.recordcount>
				<cfloop query="qryGetEquipMainT">
					<cfquery name="qryGetfileAttachmentsMaintenance" datasource="#variables.dsn#">
						select attachmentFileName,linked_Id from FileAttachments
						where  linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetEquipMainT.EquipMainID#">
							and linked_to=58
					</cfquery>
					<cfif qryGetfileAttachmentsMaintenance.recordcount>
						<cfloop query="qryGetfileAttachmentsMaintenance" >
							<cfset variables.maintenance = expandPath('../fileupload/img/#qryGetfileAttachmentsMaintenance.attachmentFileName#')>
							<cfquery name="deleteItems" datasource="#variables.dsn#">
								delete from FileAttachments where linked_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetfileAttachmentsMaintenance.linked_Id#">
							</cfquery>
							<!---cfdirectory action="list" name="qlist" directory="#variables.maintenanceTrans#"--->
							<cfif fileexists(variables.maintenance)>
								<cffile action = "delete"  file = "#variables.maintenance#">
							</cfif>
						</cfloop>	
					</cfif>
				</cfloop>
			</cfif>
			<!---delete fileattachment table entry and associated files in equipmentMaintenanceTransaction--->
			<cfquery name="qryGetEquipMainTransaction" datasource="#variables.dsn#">
				select EquipMainID from EquipmentMaintTrans
				where  EquipID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentID#">
			</cfquery>
			<cfif qryGetEquipMainTransaction.recordcount>
				<cfloop query="qryGetEquipMainTransaction">
					<cfquery name="qryGetfileAttachmentsTrans" datasource="#variables.dsn#">
						select attachmentFileName,linked_Id from FileAttachments
						where  linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetEquipMainTransaction.EquipMainID#">
							and linked_to=59
					</cfquery>
					<cfif qryGetfileAttachmentsTrans.recordcount>
						<cfloop query="qryGetfileAttachmentsTrans">
							<cfset variables.maintenanceTrans = expandPath('../fileupload/img/#qryGetfileAttachmentsTrans.attachmentFileName#')>
							<cfquery name="deleteItems" datasource="#variables.dsn#">
								delete from FileAttachments where linked_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetfileAttachmentsTrans.linked_Id#">
							</cfquery>
							<!---cfdirectory action="list" name="qlist" directory="#variables.maintenanceTrans#"--->
							<cfif fileexists(variables.maintenanceTrans)>
								<cffile action = "delete"  file = "#variables.maintenanceTrans#">
							</cfif>
						</cfloop>	
					</cfif>
				</cfloop>
			</cfif>
			<cfquery name="qryDeleteEquipmentMaintTrans" datasource="#variables.dsn#">
    			 delete from EquipmentMaintTrans where  EquipID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentID#">
    		</cfquery>
			<cfquery name="qryDelete" datasource="#variables.dsn#">
    			 delete from EquipmentMaint where  EquipID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentID#">
    		</cfquery>
    		<cfquery name="qryDelete" datasource="#variables.dsn#">
    			 delete from Equipments where  EquipmentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentID#">
    		</cfquery>
    		<cfreturn "Equipments has been deleted successfully.">	
    		<cfcatch type="any">
    			<cfreturn "Delete operation has been not successfull.">
    		</cfcatch>
    	</cftry>
	</cffunction>  

	<!--- Delete Equipmentmaint---->
	<cffunction name="deleteEquipmentsMaint"  access="public" output="false" returntype="any">
		<cfargument name="equipmentID" type="any" required="yes">
		<cfargument name="equipmentMaintID" type="any" required="yes">
			<cfquery name="qryGetfileAttachments" datasource="#variables.dsn#">
				select attachmentFileName,linked_Id from FileAttachments
				where  linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.equipmentMaintID#">
					and linked_to=58
			</cfquery>
			<cfif qryGetfileAttachments.recordcount>
				<cfloop query="qryGetfileAttachments">
					<cfset variables.maintenanceT = expandPath('../fileupload/img/#qryGetfileAttachments.attachmentFileName#')>
					<cfquery name="deleteItems" datasource="#variables.dsn#">
						delete from FileAttachments where linked_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetfileAttachments.linked_Id#">
					</cfquery>
					<!---cfdirectory action="list" name="qlist" directory="#variables.maintenanceTrans#"--->
					<cfif fileexists(variables.maintenanceT)>
						<cffile action = "delete"  file = "#variables.maintenanceT#">
					</cfif>
				</cfloop>	
			</cfif>
			<cfquery name="qryGetEquipMainTransaction" datasource="#variables.dsn#">
				select EquipMainID from EquipmentMaintTrans
				where  EquipMaintID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.equipmentMaintID#">
					and EquipID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.equipmentID#">
			</cfquery>
			<cfif qryGetEquipMainTransaction.recordcount>
				<cfloop query="qryGetEquipMainTransaction">
					<cfquery name="qryGetfileAttachmentsTrans" datasource="#variables.dsn#">
						select attachmentFileName,linked_Id from FileAttachments
						where  linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetEquipMainTransaction.EquipMainID#">
							and linked_to=59
					</cfquery>
					<cfif qryGetfileAttachmentsTrans.recordcount>
						<cfloop query="qryGetfileAttachmentsTrans">
							<cfset variables.maintenanceTrans = expandPath('../fileupload/img/#qryGetfileAttachmentsTrans.attachmentFileName#')>
							<cfquery name="deleteItems" datasource="#variables.dsn#">
								delete from FileAttachments where linked_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetfileAttachmentsTrans.linked_Id#">
							</cfquery>
							<!---cfdirectory action="list" name="qlist" directory="#variables.maintenanceTrans#"--->
							<cfif fileexists(variables.maintenanceTrans)>
								<cffile action = "delete"  file = "#variables.maintenanceTrans#">
							</cfif>
						</cfloop>	
					</cfif>
				</cfloop>
			</cfif>
			<cftry>
				<cfquery name="qryDeleteEquipmentMaintTrans" datasource="#variables.dsn#">
					 delete from EquipmentMaintTrans where  EquipMaintID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentMaintID#">
					 and EquipID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.equipmentID#">
				</cfquery>
				<cfquery name="qryDelete" datasource="#variables.dsn#">
					 delete from EquipmentMaint where  EquipMainID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentMaintID#">
					 and EquipID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.equipmentID#">
				</cfquery>
				<cfreturn "Equipment Maintenance has been deleted successfully.">	
    		<cfcatch type="any">
				
    			<cfreturn "Maintenance Delete operation has been not successfull.">
    		</cfcatch>
    	</cftry>
	</cffunction> 

	<!--- Delete EquipmentmainTransaction---->
	<cffunction name="deleteEquipmentsMainTransaction"  access="remote" output="false" returntype="numeric">
		<cfargument name="equipMainID" type="any" required="yes">
		<cfargument name="dsName" required="true">	
		<cfargument name="equipMaintId" required="true">	
		<cfargument name="equipmentId" required="true">	
		<cfset TheKey = "NAMASKARAM">
		<cfset variables.decrypted = Decrypt(ToString(ToBinary(arguments.dsName)), TheKey)>
		<cfquery name="qryGetfileAttachments" datasource="#variables.decrypted#">
			select attachmentFileName,linked_Id from FileAttachments
			where  linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.equipMainID#">
				and linked_to=59
		</cfquery>
		<cfif qryGetfileAttachments.recordcount>
			<cfloop query="qryGetfileAttachments">
				<cfset variables.maintenanceTrans = expandPath('../fileupload/img/#qryGetfileAttachments.attachmentFileName#')>
				<cfquery name="deleteItems" datasource="#variables.decrypted#">
					delete from FileAttachments where linked_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qryGetfileAttachments.linked_Id#">
				</cfquery>
				<!---cfdirectory action="list" name="qlist" directory="#variables.maintenanceTrans#"--->
				<cfif fileexists(variables.maintenanceTrans)>
					<cffile action = "delete"  file = "#variables.maintenanceTrans#">
				</cfif>
			</cfloop>	
		</cfif>
		<cfquery name="qryDeleteEquipmentMaintTrans" datasource="#variables.decrypted#">
			delete from EquipmentMaintTrans where  EquipMainID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.equipMainID#">
		</cfquery>
		<cfreturn 1>	
    </cffunction> 
    <cffunction name="getSearchedEquipment" access="public" output="false" returntype="query">
		<cfargument name="searchText" required="yes" type="any">
		<cfargument name="EquipmentMaint" default="0">
		<cfargument name="maintenanceWithEquipment" default="0">
		<CFSTOREDPROC PROCEDURE="searchEquipment" DATASOURCE="#variables.dsn#"> 
			<cfif isdefined('arguments.searchText') and len(arguments.searchText)>
				<CFPROCPARAM VALUE="#arguments.searchText#" cfsqltype="CF_SQL_VARCHAR">  
			 <cfelse>
				<CFPROCPARAM VALUE="" cfsqltype="CF_SQL_VARCHAR">  
			 </cfif>
			 <CFPROCPARAM VALUE="#arguments.EquipmentMaint#" cfsqltype="cf_sql_bit">		 
			 <CFPROCPARAM VALUE="#arguments.maintenanceWithEquipment#" cfsqltype="cf_sql_bit">		 
			 <CFPROCRESULT NAME="QreturnSearch"> 
		</CFSTOREDPROC>
		<cfreturn QreturnSearch>
	</cffunction>
	<!---Add Equipment Information---->
	<cffunction name="AddMaintenanceInformation" access="public" output="false" returntype="any">
	   <cfargument name="formStruct" type="struct" required="no" />
		<cfquery name="insertquery" datasource="#variables.dsn#">
		   insert into EquipmentMaintSetup(Description,MilesInterval,DateInterval,Notes,createdDate)
		   values(
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Description#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.MilesInterval#"  null="#yesNoFormat(NOT len(arguments.formStruct.MilesInterval))#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.DateInterval#" null="#yesNoFormat(NOT len(arguments.formStruct.DateInterval))#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Notes#">,
				  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				  )
	   </cfquery>
	   <cfreturn "Maintenance has been added Successfully">	    	
	</cffunction>

	<cffunction name="getDescriptionDuplicate" access="remote" output="false" returntype="any" returnFormat="plain">
		<cfargument name="dsName" required="true">	
		<cfargument name="description" required="true">
		<cfargument name="editid" required="true">
		<!---
		<cfset TheKey = "NAMASKARAM">
		<cfset variables.decrypted=decrypt(arguments.dsName, theKey, 'CFMX_COMPAT', 'Base64')>
		--->
		<cfset TheKey = "NAMASKARAM">
		<cfset variables.decrypted = Decrypt(ToString(ToBinary(arguments.dsName)), TheKey)>
		<cfquery name="qryDescriptioncheck" datasource="#variables.decrypted#">	
			select Description from EquipmentMaintSetup 
			where 
				Description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar"> 
				<cfif arguments.editid NEQ "">
					AND id <> <cfqueryparam value="#arguments.editid#" cfsqltype="cf_sql_varchar">
				</cfif>
		</cfquery>
		<cfif qryDescriptioncheck.recordcount>
			<cfreturn 0>
		</cfif>
		<cfreturn 1>
	</cffunction>
	<!---Update Equipment --->
	<cffunction name="UpdateMaintenanceInformation" access="public" output="false" returntype="any">
		<cfargument name="formStruct" type="struct">
		 <cfargument name="editid" type="any"> 
		<cfquery name="qryupdate" datasource="#variables.dsn#">
			 UPDATE EquipmentMaintSetup
			SET Description = <cfqueryparam value="#arguments.formStruct.Description#" cfsqltype="cf_sql_varchar">,
			MilesInterval = <cfqueryparam value="#arguments.formStruct.MilesInterval#" cfsqltype="cf_sql_integer" null="#yesNoFormat(NOT len(arguments.formStruct.MilesInterval))#">,
			DateInterval = <cfqueryparam value="#arguments.formStruct.DateInterval#" cfsqltype="cf_sql_integer" null="#yesNoFormat(NOT len(arguments.formStruct.DateInterval))#">,
			Notes = <cfqueryparam value="#arguments.formStruct.Notes#" cfsqltype="cf_sql_varchar">,
			ModifiedDate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			where id=<cfqueryparam value="#arguments.formStruct.editid#" cfsqltype="cf_sql_integer">
		 </cfquery>
		 <cfreturn "Maintenance has been updated Successfully">
	</cffunction>

	<cffunction name="getMaintenanceInformation" access="public" output="false" returntype="any">
		<cfargument name="EquipmentMaintSetupId" required="no" type="any">
		<cfargument name="sortorder" required="no" type="any">
		<cfargument name="sortby" required="no" type="any">
			<cfquery name="qryGetMaintenance" datasource="#variables.dsn#">
				 select * from  EquipmentMaintSetup
				 where 1=1
				 <cfif structKeyExists(arguments,"EquipmentMaintSetupId") and len(arguments.EquipmentMaintSetupId)>
					and id=<cfqueryparam value="#arguments.EquipmentMaintSetupId#" cfsqltype="cf_sql_integer">
				</cfif>
				ORDER BY Description	
			</cfquery>
				 
			<cfif structKeyExists(arguments,"sortorder") and structKeyExists(arguments,"sortby") and len(arguments.sortby)> 
				<cfquery datasource="#variables.dsn#" name="qryGetMaintenanceSorted">
					select *  from EquipmentMaintSetup
					where 1=1
					order by #arguments.sortby# #arguments.sortorder#;
				</cfquery>        
				<cfreturn qryGetMaintenanceSorted>          
			</cfif>
			<cfreturn qryGetMaintenance>
	</cffunction>

	<cffunction name="getMaintenanceInformationForSelect" access="public" output="false" returntype="any">
		<cfargument name="EquipmentID" required="yes" type="any">
		<cfquery name="qryGetMaintenance" datasource="#variables.dsn#">
			select Description from  EquipmentMaintSetup
			 where Description not in(
			 select Description from EquipmentMaint
			 where EquipID=<cfqueryparam value="#arguments.EquipmentID#" cfsqltype="cf_sql_varchar">
			 )
			
			ORDER BY Description	
		</cfquery>
		<cfreturn qryGetMaintenance>
	</cffunction>

	<cffunction name="getMaintenanceInformationAjax" access="remote" output="false" returntype="any" returnFormat="JSON">
		<cfargument name="EquipmentMaintSetupId" required="yes" >
		<cfargument name="dsName" required="true">	
		<cfset TheKey = "NAMASKARAM">
		<cfset variables.decrypted = Decrypt(ToString(ToBinary(arguments.dsName)), TheKey)>
		<cfset qryGetMaintenance="1">
		<cfif structKeyExists(arguments,"EquipmentMaintSetupId") and len(arguments.EquipmentMaintSetupId)>
			<cfquery name="qryGetMaintenance" datasource="#variables.decrypted#">
			 select * from  EquipmentMaintSetup
			 where  Description=<cfqueryparam value="#arguments.EquipmentMaintSetupId#" cfsqltype="cf_sql_varchar">
			ORDER BY Description	
			</cfquery>
		</cfif>
		 <cfreturn serializejson(qryGetMaintenance)>   
	</cffunction>
	<!---get Maintenance Details --->
	<cffunction name="getEquipmentMaintTable" access="remote" returntype="query">
		<cfargument name="editid" required="no">
		<cfargument name="sortorder" required="no" type="any">
		<cfargument name="sortby" required="no" type="any">
		<cfargument name="equipmentmaintid" required="no" type="any">
		<cfif structkeyexists(arguments,"sortorder") and structkeyexists(arguments,"sortby") and len(arguments.sortby)>
			<cfquery name="qrySort" datasource="#variables.dsn#">
				SELECT * FROM EquipmentMaint
				where 1=1
				<cfif structkeyexists(arguments,"editid")>
					<cfif len(arguments.editid)>
						and  EquipID=<cfqueryparam value="#arguments.editid#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfif>
				<cfif structkeyexists(arguments,"equipmentmaintid")>
					<cfif len(arguments.equipmentmaintid)>
						and  EquipMainID=<cfqueryparam value="#arguments.equipmentmaintid#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfif>
				order by #arguments.sortby# #arguments.sortorder#
			</cfquery>
			<cfreturn qrySort>
		</cfif>
		<cfquery name="qry" datasource="#variables.dsn#">
			SELECT * FROM EquipmentMaint
			where 1=1
			<cfif structkeyexists(arguments,"editid")>
				<cfif len(arguments.editid)>
					and EquipID=<cfqueryparam value="#arguments.editid#" cfsqltype="cf_sql_varchar">
				</cfif>
			</cfif>
			<cfif structkeyexists(arguments,"equipmentmaintid")>
				<cfif len(arguments.equipmentmaintid)>
					and  EquipMainID=<cfqueryparam value="#arguments.equipmentmaintid#" cfsqltype="cf_sql_varchar">
				</cfif>
			</cfif>
			order by NextDate asc
		</cfquery> 
		<cfreturn qry>
	</cffunction>

	<!---get Maintenance Transaction Details --->
	<cffunction name="getEquipmentMainTransaction" access="remote" returntype="query">
		<cfargument name="editid" required="no">
		<cfargument name="sortorder" required="no" type="any">
		<cfargument name="sortby" required="no" type="any">
		<cfargument name="equipmentMaint" required="no" type="any">
		<cfif structkeyexists(arguments,"sortorder") and structkeyexists(arguments,"sortby") and len(arguments.sortby)>
			<cfquery name="qrySort" datasource="#variables.dsn#">
				SELECT * FROM EquipmentMaintTrans
				where 1=1
				<cfif structkeyexists(arguments,"editid")>
					<cfif len(arguments.editid)>
						and  EquipID=<cfqueryparam value="#arguments.editid#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfif>
				<cfif structkeyexists(arguments,"equipmentMaint")>
					<cfif len(arguments.equipmentMaint)>
						and  EquipMaintID=<cfqueryparam value="#arguments.equipmentMaint#" cfsqltype="cf_sql_varchar">
					</cfif>
				</cfif>
				order by #arguments.sortby# #arguments.sortorder#
			</cfquery>
			<cfreturn qrySort>
		</cfif>
		<cfquery name="qry" datasource="#variables.dsn#">
			SELECT * FROM EquipmentMaintTrans
			where 1=1
			<cfif structkeyexists(arguments,"editid")>
				<cfif len(arguments.editid)>
					and EquipID=<cfqueryparam value="#arguments.editid#" cfsqltype="cf_sql_varchar">
				</cfif>
			</cfif>
			<cfif structkeyexists(arguments,"equipmentMaint")>
				<cfif len(arguments.equipmentMaint)>
					and  EquipMaintID=<cfqueryparam value="#arguments.equipmentMaint#" cfsqltype="cf_sql_varchar">
				</cfif>
			</cfif>
			order by Date
		</cfquery> 
		<cfreturn qry>
	</cffunction>


	<!---Add EquipmentMaintenance table Information---->
	<cffunction name="insertEquipMaintInformation" access="public" output="false" returntype="any">
	   <cfargument name="formStruct" type="struct" required="yes" />
		<cfif structkeyexists(arguments.formStruct,"equipmentId")>
			<cfif structkeyexists(arguments.formStruct,"MilesInterval") and structkeyexists(arguments.formStruct,"Odometer")>
				<cfset var nextOdometer=val(arguments.formStruct.MilesInterval)+val(arguments.formStruct.Odometer)>
			</cfif>
			<cfset variables.currentday=now()>
			<cfset variables.nextdate="">
			<cfif structkeyexists(arguments.formStruct,"nextDate")>
				<cfif len(trim(arguments.formStruct.nextDate))>
					<cfset variables.nextdate=arguments.formStruct.nextDate>
				<cfelse>
					<cfif structkeyexists(arguments.formStruct,"DateInterval")>
						<cfif arguments.formStruct.DateInterval neq 0>
							<cfset variables.nextdate=DateAdd("m",arguments.formStruct.DateInterval,variables.currentday)>
						</cfif>	
					</cfif>
				</cfif>	
			</cfif>
			<!---cfset variables.attachedfilename="">
			<cfif structkeyexists(arguments.formStruct,"FileAttachments") >
				<cfif len(trim(arguments.formStruct.FileAttachments))>
					<cfset variables.destination = ExpandPath("../")&'views\pages\equipment\attachments\Equipmentmaintenance\'&arguments.formStruct.equipmentId>
					<cfif not directoryExists(variables.destination)>
						<cfdirectory action="create" name="qlist" directory="#variables.destination#">
					</cfif>
					<cffile  action = "upload" destination = "#variables.destination#"  fileField = "FileAttachments"  nameConflict = "MAKEUNIQUE"  result = "result">
					<cfset variables.attachedfilename=result.SERVERFILE>
				</cfif>
			</cfif--->
			<cfquery name="insertQueryEquipmentMaint" datasource="#variables.dsn#" result="result">
				declare @equipMainID uniqueidentifier
				set @equipMainID = NewID();
			   insert into EquipmentMaint(EquipMainID,EquipID,MilesInterval,DateInterval,NextOdometer,Notes,NextDate,Description,CreatedDate)
			   values(
					  @equipMainID,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.equipmentId#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.formStruct.MilesInterval)#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.DateInterval#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#val(nextOdometer)#">,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Notes#">,
					  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.nextdate#"  null="#yesNoFormat(NOT len(variables.nextdate))#">,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Description#">,
					  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.currentday#">
					  );
				select @equipMainID as equipMainID;	  
		   </cfquery>
			 <!--- If there are any files attached to this load then move from temp table to the main table --->
		   <cfif structKeyExists(arguments.formStruct,"tempEquipmentMaint")>
			   <cfinvoke method="linkAttachments" tempEquipmentId="#arguments.formStruct.tempEquipmentMaint#" permEquipmentId="#insertQueryEquipmentMaint.equipMainID#">
		   </cfif>
		   <cflocation url="index.cfm?event=addDriverEquipment&equipmentid=#arguments.formStruct.equipmentId#&#session.URLToken#" addtoken="false">
	   </cfif>
	</cffunction>

	<!---Add EquipmentMaintenanceTranscation table Information---->
	<cffunction name="insertEquipMaintTransInformation" access="public" output="false" returntype="any">
	   <cfargument name="formStruct" type="struct" required="yes" />
		<cfif structkeyexists(arguments.formStruct,"equipmentIdForMainTrans")>
			<cfquery name="getEquipmentMaintdetails" datasource="#variables.dsn#">
				select MilesInterval,DateInterval from EquipmentMaint
				where EquipMainID=<cfqueryparam value="#arguments.formStruct.equipmentMainT#" cfsqltype="cf_sql_varchar">
		   </cfquery>
			<cfquery name="insertqueryEquipMainTrans" datasource="#variables.dsn#">
				declare @equipMainID uniqueidentifier
				set @equipMainID = NewID();
			   insert into EquipmentMaintTrans(EquipMainID,EquipID,EquipMaintID,
			   <cfif structkeyexists(arguments.formStruct,"Odometer") >
					<cfif len(trim(arguments.formStruct.Odometer))>
						Odometer,
						<cfset var nextOdometer = val(arguments.formStruct.Odometer)+val(getEquipmentMaintdetails.MilesInterval)>
					</cfif>
			   </cfif>
			   <cfif structkeyexists(arguments.formStruct,"Date")>
					<cfif len(trim(arguments.formStruct.Date))>
						Date,
						<cfset variables.nextdate=DateAdd("m",getEquipmentMaintdetails.DateInterval,arguments.formStruct.Date)>
					</cfif>	
				</cfif>
			   <cfif structkeyexists(arguments.formStruct,"Notes")>
					<cfif len(trim(arguments.formStruct.Notes))>
						Notes,
					</cfif>	
			   </cfif>
			   CreatedDate)
			   values(@equipMainID,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.equipmentIdForMainTrans#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.equipmentMainT#">,
						<cfif structkeyexists(arguments.formStruct,"Odometer") >
							<cfif len(trim(arguments.formStruct.Odometer))>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.Odometer#">,
							</cfif>
						</cfif>	
						<cfif structkeyexists(arguments.formStruct,"Date")>
							<cfif len(trim(arguments.formStruct.Date))>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.formStruct.Date#">,
							</cfif>	
						</cfif>	
						<cfif structkeyexists(arguments.formStruct,"Notes")>
							<cfif len(trim(arguments.formStruct.Notes))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.Notes#">,
							</cfif>
						</cfif>		
						<!---cfif structkeyexists(arguments.formStruct,"FileAttachments")>
							<cfif len(trim(arguments.formStruct.FileAttachments))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.attachedfilename#">,
							</cfif>
						</cfif--->		
					  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					  );
					  select @equipMainID as equipMaintID
		   </cfquery>
			<cfquery name="qryGetEquipments" datasource="#variables.dsn#">
				select odometer 
				from Equipments 
				where EquipmentID=<cfqueryparam value="#arguments.formStruct.equipmentIdForMainTrans#" cfsqltype="cf_sql_varchar">
			</cfquery>
		    <cfif structkeyexists(arguments.formStruct,"Odometer") >
				<cfif len(trim(arguments.formStruct.Odometer))> 
					<cfset variables.equipmentValue=val(qryGetEquipments.odometer)>
					<cfif variables.equipmentValue lt arguments.formStruct.Odometer> 
						<cfquery name="qryUpdateEquipment" datasource="#variables.dsn#" result="aa">
							UPDATE Equipments
							SET	Odometer = <cfqueryparam value="#arguments.formStruct.Odometer#" cfsqltype="cf_sql_integer">
							where EquipmentID=<cfqueryparam value="#arguments.formStruct.equipmentIdForMainTrans#" cfsqltype="cf_sql_varchar">
					   </cfquery>
					</cfif>
				</cfif>
			</cfif>	
		   <cfquery name="qryUpdate" datasource="#variables.dsn#">
			  UPDATE EquipmentMaint
				SET
				<cfif structkeyexists(arguments.formStruct,"Odometer") >
					<cfif len(trim(arguments.formStruct.Odometer))>
						NextOdometer = <cfqueryparam value="#nextOdometer#" cfsqltype="cf_sql_integer">,
					</cfif>
				</cfif>		
				<cfif structkeyexists(arguments.formStruct,"Date")>
					<cfif len(trim(arguments.formStruct.Date))>
						NextDate = <cfqueryparam value="#variables.nextdate#" cfsqltype="cf_sql_timestamp">,
					</cfif>
				</cfif>		
				<cfif structkeyexists(arguments.formStruct,"Notes1")>
					<cfif len(trim(arguments.formStruct.Notes1))>
						Notes = <cfqueryparam value="#arguments.formStruct.Notes#" cfsqltype="cf_sql_varchar">,
					</cfif>	
				</cfif>	
				<!---cfif structkeyexists(arguments.formStruct,"FileAttachments")>
					<cfif len(trim(arguments.formStruct.FileAttachments))>
						FileAttachments=<cfqueryparam value="#variables.attachedfilename#" cfsqltype="cf_sql_varchar">,
					</cfif>
				</cfif--->		
				ModifiedDate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
				
				where EquipMainID=<cfqueryparam value="#arguments.formStruct.equipmentMainT#" cfsqltype="cf_sql_varchar">
		   </cfquery>
		
			<!--- If there are any files attached to this load then move from temp table to the main table --->
		   <cfif structKeyExists(arguments.formStruct,"tempEquipmentMaintTransId")>
			   <cfinvoke method="linkAttachments" tempEquipmentId="#arguments.formStruct.tempEquipmentMaintTransId#" permEquipmentId="#insertqueryEquipMainTrans.equipMaintID#">
		   </cfif>
			<cfif arguments.formStruct.pageDirection>
				<cflocation url="index.cfm?event=addNewMaintenance&equipmentid=#arguments.formStruct.equipmentIdForMainTrans#&equipmentMaintId=#arguments.formStruct.equipmentMainT#&#session.URLToken#" addtoken="false">
			<cfelse>
				<cflocation url="index.cfm?event=addDriverEquipment&equipmentid=#arguments.formStruct.equipmentIdForMainTrans#&#session.URLToken#" addtoken="false">
			</cfif>	
		</cfif>   
	</cffunction>


	<!---Function to get unique Equipment ids for maintenance not up to date --->
	<cffunction name="getOutOfOdometerListEquipments" access="public" output="false" returntype="query">
		<cfset var currentDate=now()>
		<cfquery name="qryListEquipments" datasource="#variables.dsn#">
		   select e.EquipmentID from Equipments e
			LEFT JOIN EquipmentMaint em
			ON e.EquipmentID=em.EquipID
			where e.Odometer > em.NextOdometer or em.NextDate < <cfqueryparam value="#currentDate#" cfsqltype="cf_sql_timestamp">
	   </cfquery>
	   <cfreturn qryListEquipments>
	</cffunction>
	<!---Function to get count for equipments that maintenance not up to date --->
	<cffunction name="getCountEquipments" access="public" output="false" returntype="query">
		<cfset var currentDate=now()>
		<cfquery name="qryCountequipments" datasource="#variables.dsn#">
		   select count(e.EquipmentID)  from Equipments e
			LEFT JOIN EquipmentMaint em
			ON e.EquipmentID=em.EquipID
			where e.Odometer> em.NextOdometer or em.NextDate < <cfqueryparam value="#currentDate#" cfsqltype="cf_sql_timestamp">
	   </cfquery>
	   <cfreturn qryCountequipments>
	</cffunction>
	<!---Update EquipmentMaintenance table Information---->
	<cffunction name="updadeEquipMaintInformation" access="public" output="false" returntype="any">
	   <cfargument name="formStruct" type="struct" required="yes" />
		<cfif structkeyexists(arguments.formStruct,"equipmentId") and structkeyexists(arguments.formStruct,"editEquipmentmMaintId")>
			<cfset variables.currentday=now()>
			<!---cfset variables.attachedfilename="">
			<cfif structkeyexists(arguments.formStruct,"FileAttachments") >
				<cfif len(trim(arguments.formStruct.FileAttachments))>
					<cfset variables.destination = ExpandPath("../")&'views\pages\equipment\attachments\Equipmentmaintenance\'&arguments.formStruct.equipmentId>
					<cfdirectory action="list" name="qlist" directory="#variables.destination#">
					<!---cfif fileexists(variables.destination&'\'&qlist.NAME)>
						<cffile action = "delete"  file = "#variables.destination#/#qlist.NAME#">
					</cfif--->
					<cfif not directoryExists(variables.destination)>
						<cfdirectory action="create" name="qlist" directory="#variables.destination#">
					</cfif>
					<cffile  action = "upload" destination = "#variables.destination#"  fileField = "FileAttachments"  nameConflict = "Overwrite"  result = "result">
					<cfset variables.attachedfilename=result.SERVERFILE>
				</cfif>
			</cfif--->
			<cfquery name="updateQuery" datasource="#variables.dsn#">
				UPDATE EquipmentMaint
				SET
					<cfif structkeyexists(arguments.formStruct,"MilesInterval") and len(trim(arguments.formStruct.MilesInterval))>
						MilesInterval= <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.formStruct.MilesInterval)#">,
					</cfif>
					<cfif structkeyexists(arguments.formStruct,"DateInterval") and len(trim(arguments.formStruct.DateInterval))>
						DateInterval= <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.formStruct.DateInterval)#">,
					</cfif>
					<cfif structkeyexists(arguments.formStruct,"Notes") and len(trim(arguments.formStruct.Notes))>
					Notes= <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.formStruct.Notes)#">,
					</cfif>
					<!---cfif structkeyexists(arguments.formStruct,"FileAttachments") and len(trim(arguments.formStruct.FileAttachments))>
					FileAttachments= <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.attachedfilename#">,
					</cfif--->
					<cfif structkeyexists(arguments.formStruct,"MilesInterval") and structkeyexists(arguments.formStruct,"Odometer")>
						<cfset var nextOdometer=val(arguments.formStruct.MilesInterval)+val(arguments.formStruct.Odometer)>
						NextOdometer = <cfqueryparam value="#nextOdometer#" cfsqltype="cf_sql_integer">,
					</cfif>
					<cfset variables.nextdate="">
					<cfif structkeyexists(arguments.formStruct,"nextDate")>
						<cfif len(trim(arguments.formStruct.nextDate))>
							NextDate = <cfqueryparam value="#arguments.formStruct.nextDate#" cfsqltype="cf_sql_timestamp">,
						<cfelse>
							<cfif structkeyexists(arguments.formStruct,"DateInterval")>
								<cfif arguments.formStruct.DateInterval neq 0>
									<cfset variables.nextdate=DateAdd("m",arguments.formStruct.DateInterval,variables.currentday)>
									NextDate = <cfqueryparam value="#variables.nextdate#" cfsqltype="cf_sql_timestamp">,
								<cfelse>
									NextDate = <cfqueryparam value="" cfsqltype="cf_sql_timestamp"  null="#yesNoFormat(NOT len(arguments.formStruct.nextDate))#">,
								</cfif>	
							</cfif>
						</cfif>	
					</cfif>
					ModifiedDate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where 
					EquipID=<cfqueryparam value="#arguments.formStruct.equipmentId#" cfsqltype="cf_sql_varchar">
					and EquipMainID=<cfqueryparam value="#arguments.formStruct.editEquipmentmMaintId#" cfsqltype="cf_sql_varchar">
			</cfquery>
		   <cflocation url="index.cfm?event=addNewMaintenance&equipmentid=#arguments.formStruct.equipmentId#&equipmentMaintId=#arguments.formStruct.editEquipmentmMaintId#&#session.URLToken#" addtoken="false">
	   </cfif>
	</cffunction>
	<cffunction name="deleteEquipmentMainsetUp"  access="public" output="false" returntype="any">
		<cfargument name="EquipmentMainsetUp" type="any" required="yes">
			<cftry>
				<cfquery name="qryDeleteEquipmentMaintTrans" datasource="#variables.dsn#">
					delete from EquipmentMaintSetup where  id=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EquipmentMainsetUp#">
				</cfquery>
				<cfreturn "Equipment Maintenance SetUp has been deleted successfully.">	
				<cfcatch type="any">
					<cfreturn "Maintenance SetUp Delete operation has been not successfull.">
				</cfcatch>
			</cftry>	
	</cffunction> 
	
	<cffunction name="exportAllIftaTaxSummary" access="public" returntype="query">
		<cfargument name="dateFrom" required="yes">
		<cfargument name="dateTo" required="yes">
		<CFSTOREDPROC PROCEDURE="usp_IFTAData" DATASOURCE="#variables.dsn#"> 
				<CFPROCPARAM VALUE="#arguments.dateFrom#" cfsqltype="cf_sql_timestamp">  
				<CFPROCPARAM VALUE="#arguments.dateTo#" cfsqltype="cf_sql_timestamp">  
			 <CFPROCRESULT NAME="QreturnResult"> 
		</CFSTOREDPROC>
		<cfreturn QreturnResult>
		<!---cfquery name="qryGettaxSummary" datasource="#variables.dsn#">
			SELECT 
				*
			FROM 
			   vwIFTATaxSummary				
			where newDeliveryDate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.dateFrom#">	
			and newDeliveryDate <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.dateTo#">
		</cfquery>
		<cfreturn qryGettaxSummary--->
	</cffunction>
	
	<cffunction name="getFileAttachmentDetails" access="public" returntype="query">
		<cfargument name="EquipmentTransID" required="yes">
		<cfquery name="qryGetFileAttachmentDetails" datasource="#variables.dsn#">
			SELECT * FROM FileAttachments
			where linked_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EquipmentTransID#">
				and linked_to=<cfqueryparam cfsqltype="cf_sql_integer" value="59">
		</cfquery>
		<cfreturn qryGetFileAttachmentDetails>
	</cffunction>
	
	
	<!---cffunction name="getIftaTaxSummaryColumns" access="public" returntype="query">
		<cfquery name="qryColumns" datasource="#variables.dsn#">
			SELECT column_name FROM information_schema.columns WHERE table_name = 'vwIFTATaxSummary';
		</cfquery>	
		<cfreturn qryColumns>
	</cffunction--->
</cfcomponent>