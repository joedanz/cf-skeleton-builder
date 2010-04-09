<!--- $Id: base.cfc 12 2009-12-12 17:07:55Z dcepler $ --->
<!---
	Copyright 2009 David C. Epler - http://www.dcepler.net

	This file is part of of the CFML Admin API.

	The CFML Admin API is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	The CFML Admin API is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with the CFML Admin API.  If not, see <http://www.gnu.org/licenses/>.
--->
<cfcomponent displayname="CFMLAdmin API - Adobe ColdFusion (base)" output="false" hint="CFMLAdmin API Layer for Adobe ColdFusion (base)">

	<cffunction name="init" access="public" returntype="any" output="false" hint="">
		<cfargument name="password" type="string" required="true" hint="" />
		<cfargument name="username" type="string" default="" hint="" />
		<cfargument name="adminApiPath" type="string" default="" hint="" />

		<cfset variables.adminPassword = arguments.password />
		<cfset variables.adminApiPath = arguments.adminApiPath />
		<cfreturn this />
	</cffunction>


<!--- Security --->
	<cffunction name="login" access="public" returntype="boolean" output="false" hint="">

		<cfreturn createObject("component", "#variables.adminApiPath#.administrator").login(variables.adminPassword) />
	</cffunction>


<!--- Datasources --->
	<cffunction name="deleteDatasource" access="public" returntype="void" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
			<cfset local.datasource.deleteDatasource(arguments.dsn) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getDatasource" access="public" returntype="struct" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
			<cfset local.returnDSN = local.datasource.getDatasources(arguments.dsn) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn makeCommonDSN(local.returnDSN) />
	</cffunction>

	<cffunction name="getDatasources" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />
		<cfset local.returnDSNs = ArrayNew(1) />

		<cftry>
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
			<cfset local.workingDSNs = local.datasource.getDatasources() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- get the datasource names into alpha order --->
		<cfset local.datasourceArray = StructKeyArray(local.workingDSNs) />
		<cfset ArraySort(local.datasourceArray, "text") />

		<!--- ColdFusion returns datasources as struct of structs, loop to make array of structs in common format --->
		<cfloop index="local.loopIndex" from="1" to="#ArrayLen(local.datasourceArray)#">
			<cfset ArrayAppend(local.returnDSNs, makeCommonDSN(local.workingDSNs[local.datasourceArray[local.loopIndex]])) />
		</cfloop>

		<cfreturn local.returnDSNs />
	</cffunction>

	<cffunction name="setDatasource" access="public" returntype="void" output="false" hint="Creates a ColdFusion datasource">
		<cfargument name="name" type="string" required="true" hint="datasource name" />
		<cfargument name="description" type="string" required="false" hint="description for datasource" />
		<cfargument name="databasetype" type="string" required="true" hint="database type <ul><li>jdbc</li><li>mssql</li><li>mysql - defaults to MySQL5 driver</li><li>oracle</li><li>postgresql</li></ul>" />
		<cfargument name="database" type="string" required="false" hint="name of database to use (or SID for Oracle)" />
		<cfargument name="server" type="string" required="false" hint="database server" />
		<cfargument name="username" type="string" required="false" hint="database username" />
		<cfargument name="password" type="string" required="false" hint="database password" />
		<cfargument name="port" type="numeric" required="false" hint="database port (will use databasetype default unless specified)" />
		<cfargument name="additionalConnectionParameters" type="string" required="false" hint="additional parameters for database connection" />
		<cfargument name="loginTimeout" type="numeric" required="false" hint="login timeout (in seconds)" />
		<cfargument name="connectionTimeout" type="numeric" required="false" hint="timeout for database connection (in seconds)" />
		<cfargument name="connectionPooling" type="boolean" required="false" hint="is the connection pooled" />
		<cfargument name="maxConnections" type="numeric" required="false" hint="maximum number of connections allowed" />
		<cfargument name="allowSQL_select" type="boolean" required="false" hint="are SQL select statements allowed" />
		<cfargument name="allowSQL_insert" type="boolean" required="false" hint="are SQL insert statements allowed" />
		<cfargument name="allowSQL_update" type="boolean" required="false" hint="are SQL update statements allowed" />
		<cfargument name="allowSQL_delete" type="boolean" required="false" hint="are SQL delete statements allowed" />
		<cfargument name="allowSQL_storedprocedure" type="boolean" required="false" hint="are SQL stored procedures allowed" />
		<cfargument name="allowSQL_create" type="boolean" required="false" hint="are SQL create statements allowed" />
		<cfargument name="allowSQL_alter" type="boolean" required="false" hint="are SQL alter statements allowed" />
		<cfargument name="allowSQL_drop" type="boolean" required="false" hint="are SQL drop statements allowed" />
		<cfargument name="allowSQL_grant" type="boolean" required="false" hint="are SQL grant statements allowed" />
		<cfargument name="allowSQL_revoke" type="boolean" required="false" hint="are SQL revoke statements allowed" />
		<cfargument name="allowSQL_blob" type="boolean" required="false" hint="are SQL blobs allowed" />
		<cfargument name="allowSQL_clob" type="boolean" required="false" hint="are SQL clobs allowed" />
		<cfargument name="jdbcURL" type="string" required="false" hint="JDBC URL to use (databasetype='jdbc' only)" />
		<cfargument name="jdbcClass" type="string" required="false" hint="Class for JDBC Driver (databasetype='jdbc' only)" />

		<cfset var local = StructNew() />
		<cfset local.dbType = LCase(arguments.databasetype) />

		<cfscript>
			// map common DSN back to ColdFusion
			local.dsnSettings = StructNew();
			local.dsnSettings.name = arguments.name;

			if(StructKeyExists(arguments, "server") AND Len(arguments.server))
				local.dsnSettings.host = arguments.server;

			if(StructKeyExists(arguments, "database") AND Len(arguments.database))
				local.dsnSettings.database = arguments.database;

			if(StructKeyExists(arguments, "username") AND Len(arguments.username))
				local.dsnSettings.username = arguments.username;

			if(StructKeyExists(arguments, "password") AND Len(arguments.password))
				local.dsnSettings.password = arguments.password;

			if(StructKeyExists(arguments, "description") AND Len(arguments.description))
				local.dsnSettings.description = arguments.description;

			if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
				local.dsnSettings.args = arguments.additionalConnectionParameters;

			if(StructKeyExists(arguments, "loginTimeout") AND Len(arguments.loginTimeout))
				local.dsnSettings.login_timeout = arguments.loginTimeout;

			if(StructKeyExists(arguments, "connectionTimeout") AND Len(arguments.connectionTimeout))
				local.dsnSettings.timeout = arguments.connectionTimeout;

			if(StructKeyExists(arguments, "connectionPooling") AND Len(arguments.connectionPooling))
				local.dsnSettings.pooling = arguments.connectionPooling;

			if(StructKeyExists(arguments, "maxConnections") AND Len(arguments.maxConnections)){
				local.dsnSettings.enablemaxconnections = TRUE;
				local.dsnSettings.maxconnections = arguments.maxConnections;
			}

			if(StructKeyExists(arguments, "allowSQL_select") AND Len(arguments.allowSQL_select))
				local.dsnSettings.select = arguments.allowSQL_select;

			if(StructKeyExists(arguments, "allowSQL_insert") AND Len(arguments.allowSQL_insert))
				local.dsnSettings.insert = arguments.allowSQL_insert;

			if(StructKeyExists(arguments, "allowSQL_update") AND Len(arguments.allowSQL_update))
				local.dsnSettings.update = arguments.allowSQL_update;

			if(StructKeyExists(arguments, "allowSQL_delete") AND Len(arguments.allowSQL_delete))
				local.dsnSettings.delete = arguments.allowSQL_delete;

			if(StructKeyExists(arguments, "allowSQL_storedprocedure") AND Len(arguments.allowSQL_storedprocedure))
				local.dsnSettings.storedproc = arguments.allowSQL_storedprocedure;


			if(StructKeyExists(arguments, "allowSQL_create") AND Len(arguments.allowSQL_create))
				local.dsnSettings.create = arguments.allowSQL_create;

			if(StructKeyExists(arguments, "allowSQL_alter") AND Len(arguments.allowSQL_alter))
				local.dsnSettings.alter = arguments.allowSQL_alter;

			if(StructKeyExists(arguments, "allowSQL_drop") AND Len(arguments.allowSQL_drop))
				local.dsnSettings.drop = arguments.allowSQL_drop;

			if(StructKeyExists(arguments, "allowSQL_grant") AND Len(arguments.allowSQL_grant))
				local.dsnSettings.grant = arguments.allowSQL_grant;

			if(StructKeyExists(arguments, "allowSQL_revoke") AND Len(arguments.allowSQL_revoke))
				local.dsnSettings.revoke = arguments.allowSQL_revoke;

			if(StructKeyExists(arguments, "allowSQL_blob") AND Len(arguments.allowSQL_blob))
				local.dsnSettings.disable_blob = NOT arguments.allowSQL_blob; // Flip

			if(StructKeyExists(arguments, "allowSQL_clob") AND Len(arguments.allowSQL_clob))
				local.dsnSettings.disable_clob = NOT arguments.allowSQL_clob; // Flip

			if(StructKeyExists(arguments, "jdbcURL") AND Len(arguments.jdbcURL))
				local.dsnSettings.url = arguments.jdbcURL;

			if(StructKeyExists(arguments, "jdbcClass") AND Len(arguments.jdbcClass))
				local.dsnSettings.class = arguments.jdbcClass;
		</cfscript>

		<!--- database specific configuration --->
		<cfswitch expression="#local.dbType#">

			<cfcase value="jdbc">
				<cfset local.dsnSettings.driver = "Other JDBC" />
				<cftry>
					<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
					<cfset local.datasource.setOther(argumentCollection=local.dsnSettings) />

					<cfcatch type="any">
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cfcase>

			<cfcase value="mssql">
				<!--- TODO:
					* sendStringParametersAsUnicode - true+/false
					* selectMethod - direct+/cursor
				--->
				<cftry>
					<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
					<cfset local.datasource.setMSSQL(argumentCollection=local.dsnSettings) />

					<cfcatch type="any">
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cfcase>

			<cfcase value="mysql3">
				<cftry>
					<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
					<cfset local.datasource.setMySQL(argumentCollection=local.dsnSettings) />

					<cfcatch type="any">
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cfcase>

			<cfcase value="mysql,mysql4,mysql5">
				<cftry>
					<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
					<cfset local.datasource.setMySQL5(argumentCollection=local.dsnSettings) />

					<cfcatch type="any">
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cfcase>

			<cfcase value="oracle">
				<cfset local.dsnSettings.sid = arguments.database />
				<cftry>
					<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
					<cfset local.datasource.setOracle(argumentCollection=local.dsnSettings) />

					<cfcatch type="any">
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cfcase>

			<cfcase value="postgresql">
				<cftry>
					<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
					<cfset local.datasource.setPostGreSQL(argumentCollection=local.dsnSettings) />

					<cfcatch type="any">
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cfcase>

			<cfdefaultcase>
				<cfthrow type="cfmladminapi.setDatasource.UNKNOWN_DATABASETYPE" message="" />
			</cfdefaultcase>
		</cfswitch>

	</cffunction>

	<cffunction name="verifyDatasource" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.datasource") />
			<cfset local.verifiedDSN = local.datasource.verifyDSN(arguments.dsn) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>

	<cffunction name="makeCommonDSN" access="private" returntype="struct" output="false" hint="Convert ColdFusion datasource to common CFMLAdmin API datasource struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="ColdFusion datasource structure" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonDSN.name = arguments.originalStruct.name;
			local.commonDSN.description = arguments.originalStruct.description;
			local.commonDSN.username = arguments.originalStruct.username;
			local.commonDSN.password = arguments.originalStruct.password;
			local.commonDSN.databasetype = arguments.originalStruct.driver;
			local.commonDSN.jdbcURL = arguments.originalStruct.url;
			local.commonDSN.jdbcClass = arguments.originalStruct.class;

			local.commonDSN.allowSQL_select = arguments.originalStruct.select;
			local.commonDSN.allowSQL_insert = arguments.originalStruct.insert;
			local.commonDSN.allowSQL_update = arguments.originalStruct.update;
			local.commonDSN.allowSQL_delete = arguments.originalStruct.delete;
			local.commonDSN.allowSQL_storedprocedure = arguments.originalStruct.storedproc;

			local.commonDSN.allowSQL_create = arguments.originalStruct.create;
			local.commonDSN.allowSQL_alter = arguments.originalStruct.alter;
			local.commonDSN.allowSQL_drop = arguments.originalStruct.drop;
			local.commonDSN.allowSQL_grant = arguments.originalStruct.grant;
			local.commonDSN.allowSQL_revoke = arguments.originalStruct.revoke;

			local.commonDSN.allowSQL_blob = NOT arguments.originalStruct.disable_blob; // Need to flip value
			local.commonDSN.allowSQL_clob = NOT arguments.originalStruct.disable_clob; // Need to flip value

			local.commonDSN.loginTimeout = arguments.originalStruct.login_timeout;
			local.commonDSN.connectionTimeout = arguments.originalStruct.timeout;
			local.commonDSN.connectionPooling = arguments.originalStruct.pooling;

			// why does ColdFusion returns two different structs (struct-of-structs vs single)
			if (structKeyExists(arguments.originalStruct, "urlmap")) {
				local.commonDSN.server = arguments.originalStruct.urlmap.host;
				local.commonDSN.port = arguments.originalStruct.urlmap.port;
				local.commonDSN.database = arguments.originalStruct.urlmap.database;
				local.commonDSN.additionalConnectionParameters = arguments.originalStruct.urlmap.args;

				if (structKeyExists(arguments.originalStruct.urlmap, "maxconnections")) {
					local.commonDSN.maxConnections = arguments.originalStruct.urlmap.maxconnections;
				} else {
					local.commonDSN.maxConnections = "";
				}
			} else {
				local.commonDSN.server = arguments.originalStruct.host;
				local.commonDSN.port = arguments.originalStruct.port;
				local.commonDSN.database = arguments.originalStruct.database;
				local.commonDSN.additionalConnectionParameters = arguments.originalStruct.args;

				if (structKeyExists(arguments.originalStruct, "maxconnections")) {
					local.commonDSN.maxConnections = arguments.originalStruct.maxconnections;
				} else {
					local.commonDSN.maxConnections = "";
				}
			}
		</cfscript>

		<cfreturn local.commonDSN />
	</cffunction>


<!--- Mappings --->
	<cffunction name="deleteMapping" access="public" returntype="void" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.extensions.deleteMapping(arguments.mapName) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getMapping" access="public" returntype="struct" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.returnMapping = local.extensions.getMappings(arguments.mapName) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn makeCommonMapping(arguments.mapName, local.returnMapping[arguments.mapName]) />
	</cffunction>

	<cffunction name="getMappings" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />
		<cfset local.returnMappings = ArrayNew(1) />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.workingMappings = local.extensions.getMappings() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- get the datasource names into alpha order --->
		<cfset local.mappingArray = StructKeyArray(local.workingMappings) />
		<cfset ArraySort(local.MappingArray, "text") />

		<!--- ColdFusion returns mapping as structs, loop to make array of structs in common format --->
		<cfloop index="local.loopIndex" from="1" to="#ArrayLen(local.mappingArray)#">
			<cfset ArrayAppend(local.returnMappings, makeCommonMapping(local.MappingArray[local.loopIndex], local.workingMappings[local.MappingArray[local.loopIndex]])) />
		</cfloop>

		<cfreturn local.returnMappings />
	</cffunction>

	<cffunction name="setMapping" access="public" returntype="void" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />
		<cfargument name="mapPath" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.extensions.setMapping(arguments.mapName, arguments.mapPath) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="makeCommonMapping" access="private" returntype="struct" output="false" hint="Convert ColdFusion mapping to common CFMLAdmin API mapping struct">
		<cfargument name="name" type="string" required="true" hint="Mapping Name" />
		<cfargument name="directory" type="string" required="true" hint="Mapping Directory" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonMapping.name = arguments.name;
			local.commonMapping.directory = arguments.directory;
		</cfscript>

		<cfreturn local.commonMapping />
	</cffunction>


<!--- Custom Tag Paths --->
	<cffunction name="deleteCustomTagPath" access="public" returntype="void" output="false" hint="">
		<cfargument name="path" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.extensions.deleteCustomTagPath(arguments.path) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getCustomTagPaths" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.returnCustomTagPaths = local.extensions.getCustomTagPaths() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn local.returnCustomTagPaths />
	</cffunction>

	<cffunction name="setCustomTagPath" access="public" returntype="void" output="false" hint="">
		<cfargument name="path" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.extensions.setCustomTagPath(arguments.path) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>


<!--- Java CFX --->
	<cffunction name="deleteJavaCFX" access="public" returntype="void" output="false" hint="">
		<cfargument name="cfxName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<!--- ensure cfxName is prefixed with cfx_ --->
		<cfif CompareNoCase(Left(arguments.cfxName, 4), "cfx_") NEQ 0>
			<cfset local.cfxName = "cfx_" & arguments.cfxName />
		<cfelse>
			<cfset local.cfxName = arguments.cfxName />
		</cfif>

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.extensions.deleteCFX(local.cfxName) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getJavaCFX" access="public" returntype="struct" output="false" hint="">
		<cfargument name="cfxName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<!--- ensure cfxName is prefixed with cfx_ --->
		<cfif CompareNoCase(Left(arguments.cfxName, 4), "cfx_") NEQ 0>
			<cfset local.cfxName = "cfx_" & arguments.cfxName />
		<cfelse>
			<cfset local.cfxName = arguments.cfxName />
		</cfif>

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.returnJavaCFX = local.extensions.getCFX(local.cfxName) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn makeCommonJavaCFX(local.returnJavaCFX) />
	</cffunction>

	<cffunction name="getJavaCFXs" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />
		<cfset local.returnJavaCFXs = ArrayNew(1) />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.workingJavaCFXs = local.extensions.getCFX() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- get the cfx names into alpha order --->
		<cfset local.cfxArray = StructKeyArray(local.workingJavaCFXs) />
		<cfset ArraySort(local.cfxArray, "text") />

		<!--- ColdFusion returns CFXs as structs, loop to make array of structs in common format and only Java ones --->
		<cfloop index="local.loopIndex" from="1" to="#ArrayLen(local.cfxArray)#">
			<cfif local.workingJavaCFXs[local.cfxArray[local.loopIndex]]["type"] EQ "java">
				<cfset ArrayAppend(local.returnJavaCFXs, makeCommonJavaCFX(local.workingJavaCFXs[local.cfxArray[local.loopIndex]])) />
			</cfif>
		</cfloop>

		<cfreturn local.returnJavaCFXs />
	</cffunction>

	<cffunction name="setJavaCFX" access="public" returntype="void" output="false" hint="">
		<cfargument name="cfxName" type="string" required="true" hint="" />
		<cfargument name="class" type="string" required="true" hint="" />
		<cfargument name="description" type="string" default="" hint="" />

		<cfset var local = StructNew() />

		<!--- ensure cfxName is prefixed with cfx_ --->
		<cfif CompareNoCase(Left(arguments.cfxName, 4), "cfx_") NEQ 0>
			<cfset local.cfxName = "cfx_" & arguments.cfxName />
		<cfelse>
			<cfset local.cfxName = arguments.cfxName />
		</cfif>

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.extensions") />
			<cfset local.extensions.setJavaCFX(local.cfxName, arguments.class, arguments.description) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="makeCommonJavaCFX" access="private" returntype="struct" output="false" hint="Convert ColdFusion Java CFX to common CFMLAdmin API Java CFX struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="ColdFusion Java CFX structure" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonJavaCFX.name = arguments.originalStruct.name;
			local.commonJavaCFX.description = arguments.originalStruct.description;
			local.commonJavaCFX.class = arguments.originalStruct.classname;
		</cfscript>

		<cfreturn local.commonJavaCFX />
	</cffunction>


<!--- Caching --->
	<cffunction name="clearTemplateCache" access="public" returntype="boolean" output="false" hint="">

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.runtime = createObject("component", "#variables.adminApiPath#.runtime") />
			<cfset local.runtime.clearTrustedCache() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


<!--- Utility methods --->
	<cffunction name="queryStringToStruct" access="private" returntype="struct" output="false" hint="Converts a URL query string to a structure">
		<cfargument name="queryString" type="string" required="true" hint="Query string to parse" />
		<cfargument name="queryStringDelim" type="string" default="&" hint="Delimiter separating URL parameters" />
		<cfargument name="keyValueDelim" type="string" default="=" hint="Delimiter for the keys/values" />

		<cfset var local = StructNew() />
		<cfset local.returnStruct = StructNew() />

		<!--- convert querystring to array, also make sure we ONLY deal with querystring if full URL is passed --->
		<cfset local.queryStringArray = ListToArray(listLast(arguments.queryString, "?"), arguments.queryStringDelim) />

		<cfloop index="local.loopIndex" from="1" to="#ArrayLen(local.queryStringArray)#">
			<cfset local.key = ListFirst(local.queryStringArray[local.loopIndex], arguments.keyValueDelim) />
			<cfset local.value = URLDecode(listLast(local.queryStringArray[local.loopIndex], arguments.keyValueDelim)) />

			<cfif StructKeyExists(local.returnStruct, local.key)>
				<cfset local.returnStruct[local.key] = ListAppend(local.returnStruct[local.key], local.value) />
			<cfelse>
				<cfset StructInsert(local.returnStruct, local.key, local.value) />
			</cfif>
		</cfloop>

		<cfreturn local.returnStruct />
	</cffunction>

</cfcomponent>
