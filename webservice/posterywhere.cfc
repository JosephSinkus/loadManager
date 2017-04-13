<cfcomponent>
	<cfsavecontent variable="strXML">
	 
	<PostLoads.Many>
	
	   <LoadDO>
	
		  <postAction>A</postAction>
	
		  <importRef>REF123</importRef>
	
		  <originCity>Hebron</originCity>
	
		  <originState>ND</originState>
	
		  <pickupDate>2013-11-11</pickupDate>
	
		  <destCity>Fargo</destCity>
	
		  <destState>ND</destState>
	
		  <truckType>V</truckType>
	
		  <fullOrPartial>Full</fullOrPartial>
	
		  <length>48</length>
	
		  <weight>20000</weight>
	
		  <comment>test load. do not call</comment>
	
	   </LoadDO>
	
	   <LoadDO>
	
		  <postAction>A</postAction>
	
		  <importRef>REF456</importRef>
	
		  <originCity>Hebron</originCity>
	
		  <originState>ND</originState>
	
		  <pickupDate>2013-11-11</pickupDate>
	
		  <destCity>Fargo</destCity>
	
		  <destState>ND</destState>
	
		  <truckType>V</truckType>
	
		  <fullOrPartial>Full</fullOrPartial>
	
		  <length>48</length>
	
		  <weight>20000</weight>
	
		  <comment>test load. do not call</comment>
	 </LoadDO>
	</PostLoads.Many>
	 
	</cfsavecontent> 
	 
	
		<cffunction name="posterywhere" returntype="string" access="remote">
			<cfhttp method="post" url="http://app.posteverywhere.com/webservices/PostLoads.php" useragent="#CGI.http_user_agent#" result="objGet">
				<cfhttpparam type="url" name="ServiceKey" value="NxvMWFGJTNGHbMW"/>
				<cfhttpparam type="url" name="CustomerKey"  value="DQkLKV2QFT"/>
				<cfhttpparam type="url"  name="ServiceAction"  value="Many" />
				<cfhttpparam type="body" value="#strXML.Trim()#"/>
			</cfhttp> 
		<cfreturn objGet.FileContent>
		</cffunction>
</cfcomponent>

 