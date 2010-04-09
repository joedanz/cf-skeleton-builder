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
<cfcomponent displayname="CFMLAdmin API - Open BlueDragon (base)" output="false" hint="CFMLAdmin API Layer for Open BlueDragon (base)">

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

		<cfset var local = StructNew() />

		<cfset local.LoginResult = createObject("component", "#variables.adminApiPath#.Administrator").login(variables.adminPassword) />

		<cfif local.LoginResult>
			<!--- ensure session vars OpenBlueDragon Admin API are looking for are set --->
			<cflock scope="session" type="exclusive" timeout="5">
				<cfset session.auth.loggedIn = true />
				<cfset session.auth.password = variables.adminPassword />
			</cflock>

			<cfreturn TRUE />
		<cfelse>
			<cfreturn FALSE />
		</cfif>

	</cffunction>


<!--- Datasources --->
	<cffunction name="deleteDatasource" access="public" returntype="void" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.Datasource") />
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
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.Datasource") />
			<cfset local.returnDSN = local.datasource.getDatasources(arguments.dsn)[1] />

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
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.Datasource") />
			<cfset local.workingDSNs = local.datasource.getDatasources() />

			<cfcatch type="bluedragon.adminapi.datasource">
				 <!--- OpenBluedragon throws an error instead of returning empty array --->
				<cfif cfcatch.message EQ "No registered datasources">
					<cfset local.workingDSNs = ArrayNew(1) />
				</cfif>
			</cfcatch>

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfloop index="local.indexDSN" from="1" to="#ArrayLen(local.workingDSNs)#">
			<cfset ArrayAppend(local.returnDSNs, makeCommonDSN(local.workingDSNs[local.indexDSN])) />
		</cfloop>

		<cfreturn local.returnDSNs />
	</cffunction>

	<cffunction name="setDatasource" access="public" returntype="void" output="false" hint="Creates an Open BlueDragon Datasource">
		<cfargument name="name" type="string" required="true" hint="datasource name" />
		<cfargument name="description" type="string" required="false" hint="description for datasource" />
		<cfargument name="databasetype" type="string" required="true" hint="database type <ul><li>jdbc</li><li>mssql - defaults to jTDS JDBC driver</li><li>mysql</li><li>oracle</li><li>postgresql</li></ul>" />
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
		<cfargument name="allowSQL_create" type="boolean" required="false" hint="are SQL create statements allowed <strong>[ignored]</strong>" />
		<cfargument name="allowSQL_alter" type="boolean" required="false" hint="are SQL alter statements allowed <strong>[ignored]</strong>" />
		<cfargument name="allowSQL_drop" type="boolean" required="false" hint="are SQL drop statements allowed <strong>[ignored]</strong>" />
		<cfargument name="allowSQL_grant" type="boolean" required="false" hint="are SQL grant statements allowed <strong>[ignored]</strong>" />
		<cfargument name="allowSQL_revoke" type="boolean" required="false" hint="are SQL revoke statements allowed <strong>[ignored]</strong>" />
		<cfargument name="allowSQL_blob" type="boolean" required="false" hint="are SQL blobs allowed <strong>[ignored]</strong>" />
		<cfargument name="allowSQL_clob" type="boolean" required="false" hint="are SQL clobs allowed <strong>[ignored]</strong>" />
		<cfargument name="jdbcURL" type="string" required="false" hint="JDBC URL to use (databasetype='jdbc' only)" />
		<cfargument name="jdbcClass" type="string" required="false" hint="Class for JDBC Driver (databasetype='jdbc' only)" />

		<cfset var local = StructNew() />

		<cfscript>
			// map common DSN back to Open BlueDragon
			local.dsnSettings = StructNew();

			local.dsnSettings.action = 'create';

			local.dsnSettings.name = arguments.name;

			if(StructKeyExists(arguments, "server") AND Len(arguments.server))
				local.dsnSettings.server = arguments.server;

			if(StructKeyExists(arguments, "database") AND Len(arguments.database))
				local.dsnSettings.databasename = arguments.database;

			if(StructKeyExists(arguments, "username") AND Len(arguments.username))
				local.dsnSettings.username = arguments.username;

			if(StructKeyExists(arguments, "password") AND Len(arguments.password))
				local.dsnSettings.password = arguments.password;

			if(StructKeyExists(arguments, "description") AND Len(arguments.description))
				local.dsnSettings.description = arguments.description;

			if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
				local.dsnSettings.connectstring = arguments.additionalConnectionParameters;

			if(StructKeyExists(arguments, "loginTimeout") AND Len(arguments.loginTimeout))
				local.dsnSettings.logintimeout = arguments.loginTimeout;

			if(StructKeyExists(arguments, "connectionTimeout") AND Len(arguments.connectionTimeout))
				local.dsnSettings.connectiontimeout = arguments.connectionTimeout;

			if(StructKeyExists(arguments, "connectionPooling") AND Len(arguments.connectionPooling))
				local.dsnSettings.perrequestconnections = NOT arguments.connectionPooling; // Flip

			if(StructKeyExists(arguments, "maxConnections") AND Len(arguments.maxConnections))
				local.dsnSettings.maxconnections = arguments.maxConnections;

			if(StructKeyExists(arguments, "allowSQL_select") AND Len(arguments.allowSQL_select))
				local.dsnSettings.sqlselect = arguments.allowSQL_select;

			if(StructKeyExists(arguments, "allowSQL_insert") AND Len(arguments.allowSQL_insert))
				local.dsnSettings.sqlinsert = arguments.allowSQL_insert;

			if(StructKeyExists(arguments, "allowSQL_update") AND Len(arguments.allowSQL_update))
				local.dsnSettings.sqlupdate = arguments.allowSQL_update;

			if(StructKeyExists(arguments, "allowSQL_delete") AND Len(arguments.allowSQL_delete))
				local.dsnSettings.sqldelete = arguments.allowSQL_delete;

			if(StructKeyExists(arguments, "allowSQL_storedprocedure") AND Len(arguments.allowSQL_storedprocedure))
				local.dsnSettings.sqlstoredprocedures = arguments.allowSQL_storedprocedure;

			if(StructKeyExists(arguments, "jdbcURL") AND Len(arguments.jdbcURL))
				local.dsnSettings.hoststring = arguments.jdbcURL;

			if(StructKeyExists(arguments, "jdbcClass") AND Len(arguments.jdbcClass))
				local.dsnSettings.drivername = arguments.jdbcClass;
		</cfscript>

		<!--- database specific configuration --->
		<cfswitch expression="#LCase(arguments.databasetype)#">

			<cfcase value="jdbc">
				<cfscript>
					local.dsnSettings.verificationQuery = "SELECT 1";
				</cfscript>
			</cfcase>

			<cfcase value="mssql_ms">
				<cfscript>
					local.dsnSettings.port = 1433;
					local.dsnSettings.drivername = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
				</cfscript>
			</cfcase>

			<cfcase value="mssql,mssql_jtds"> <!--- default all MSSQL to jTDS JDBC driver --->
				<cfscript>
					local.dsnSettings.port = 1433;
					local.dsnSettings.drivername = "net.sourceforge.jtds.jdbc.Driver";
				</cfscript>
			</cfcase>

			<cfcase value="mysql3">
				<cfscript>
					local.dsnSettings.port = 3306;
					local.dsnSettings.drivername = "org.gjt.mm.mysql.Driver";
				</cfscript>
			</cfcase>

			<cfcase value="mysql,mysql4,mysql5">
				<cfscript>
					local.dsnSettings.port = 3306;
					local.dsnSettings.drivername = "com.mysql.jdbc.Driver";
				</cfscript>
			</cfcase>

			<cfcase value="oracle">
				<cfscript>
					local.dsnSettings.port = 1521;
					local.dsnSettings.drivername = "oracle.jdbc.OracleDriver";
				</cfscript>
			</cfcase>

			<cfcase value="postgresql">
				<cfscript>
					local.dsnSettings.port = 5432;
					local.dsnSettings.drivername = "org.postgresql.Driver";
				</cfscript>
			</cfcase>

			<cfdefaultcase>
				<cfthrow type="cfmladminapi.setDatasource.UNKNOWN_DATABASETYPE" message="" />
			</cfdefaultcase>
		</cfswitch>

		<cftry>
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.Datasource") />
			<cfset local.datasource.setDatasource(argumentCollection=local.dsnSettings) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="verifyDatasource" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.datasource = createObject("component", "#variables.adminApiPath#.Datasource") />
			<cfset local.verifiedDSN = local.datasource.verifyDatasource(arguments.dsn) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>

	<cffunction name="makeCommonDSN" access="private" returntype="struct" output="false" hint="Convert Open BlueDragon datasource to common CFMLAdmin API datasource struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="Open BlueDragon datasource structure" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonDSN.name = arguments.originalStruct.name;
			local.commonDSN.description = arguments.originalStruct.description;
			local.commonDSN.username = arguments.originalStruct.username;
			local.commonDSN.password = arguments.originalStruct.password;
			local.commonDSN.databasetype = getDatabaseTypeByClass(arguments.originalStruct.drivername);
			local.commonDSN.server = arguments.originalStruct.server;
			local.commonDSN.port = arguments.originalStruct.port;
			local.commonDSN.database = arguments.originalStruct.databasename;
			local.commonDSN.jdbcURL = arguments.originalStruct.hoststring;
			local.commonDSN.jdbcClass = arguments.originalStruct.drivername;

			local.commonDSN.allowSQL_select = arguments.originalStruct.sqlselect;
			local.commonDSN.allowSQL_insert = arguments.originalStruct.sqlinsert;
			local.commonDSN.allowSQL_update = arguments.originalStruct.sqlupdate;
			local.commonDSN.allowSQL_delete = arguments.originalStruct.sqldelete;
			local.commonDSN.allowSQL_storedprocedure = arguments.originalStruct.sqlstoredprocedures;

			local.commonDSN.allowSQL_create = ""; // Open BlueDragon does not have a flag for create
			local.commonDSN.allowSQL_alter = ""; // Open BlueDragon does not have a flag for alter
			local.commonDSN.allowSQL_drop = ""; // Open BlueDragon does not have a flag for drop
			local.commonDSN.allowSQL_grant = ""; // Open BlueDragon does not have a flag for grant
			local.commonDSN.allowSQL_revoke = ""; // Open BlueDragon does not have a flag for revoke

			local.commonDSN.allowSQL_blob = ""; // Open BlueDragon does not have a flag for blob
			local.commonDSN.allowSQL_clob = ""; // Open BlueDragon does not have a flag for clob

			local.commonDSN.maxConnections = arguments.originalStruct.maxconnections;
			local.commonDSN.loginTimeout = arguments.originalStruct.logintimeout;
			local.commonDSN.connectionTimeout = arguments.originalStruct.connectionTimeout;
			local.commonDSN.connectionPooling = NOT arguments.originalStruct.perrequestconnections; // Need to flip value
			local.commonDSN.additionalConnectionParameters = arguments.originalStruct.connectstring;
		</cfscript>

		<cfreturn local.commonDSN />
	</cffunction>

	<cffunction name="getDatabaseTypeByClass" access="private" returntype="string" output="false" hint="Return databasetype based upon Java class">
		<cfargument name="className" type="string" required="true" hint="Java class name" />

		<cfswitch expression="#arguments.className#">
			<cfcase value="org.gjt.mm.mysql.Driver">
				<cfreturn "MySQL" />
			</cfcase>
			<cfcase value="com.mysql.jdbc.Driver">
				<cfreturn "MySQL5" />
			</cfcase>
			<cfcase value="com.microsoft.sqlserver.jdbc.SQLServerDriver">
				<cfreturn "MSSQL (Microsoft)" />
			</cfcase>
			<cfcase value="net.sourceforge.jtds.jdbc.Driver">
				<cfreturn "MSSQL (jTDS)" />
			</cfcase>
			<cfcase value="oracle.jdbc.OracleDriver,oracle.jdbc.driver.OracleDriver">
				<cfreturn "Oracle" />
			</cfcase>
			<cfcase value="org.postgresql.Driver">
				<cfreturn "PostgreSQL" />
			</cfcase>

			<cfdefaultcase>
				<cfreturn "unknown" />
			</cfdefaultcase>
		</cfswitch>

	</cffunction>


<!--- Mappings --->
	<cffunction name="deleteMapping" access="public" returntype="void" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.mapping = createObject("component", "#variables.adminApiPath#.Mapping") />
			<cfset local.mapping.deleteMapping(arguments.mapName) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getMapping" access="public" returntype="struct" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.mapping = createObject("component", "#variables.adminApiPath#.Mapping") />
			<cfset local.returnMapping = local.mapping.getMappings(arguments.mapName) />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn makeCommonMapping(local.returnMapping[1]) />
	</cffunction>

	<cffunction name="getMappings" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />
		<cfset local.returnMappings = ArrayNew(1) />

		<cftry>
			<cfset local.mapping = createObject("component", "#variables.adminApiPath#.Mapping") />
			<cfset local.workingMappings = local.mapping.getMappings() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfloop index="local.indexMapping" from="1" to="#ArrayLen(local.workingMappings)#">
			<cfset ArrayAppend(local.returnMappings, makeCommonMapping(local.workingMappings[local.indexMapping])) />
		</cfloop>

		<cfreturn local.returnMappings />
	</cffunction>

	<cffunction name="setMapping" access="public" returntype="void" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />
		<cfargument name="mapPath" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.mapping = createObject("component", "#variables.adminApiPath#.Mapping") />
			<cfset local.mapping.setMapping(arguments.mapName, arguments.mapPath) />

			<cfcatch type="any">
				<!--- deal with OpenBlueDragon "$" on non-windows for mappings --->
				<cfif server.os.name NEQ "windows">
					<cftry>
						<cfset local.mapping.setMapping(arguments.mapName, "$" & arguments.mapPath) />

						<cfcatch type="any">
							<cfrethrow />
						</cfcatch>
					</cftry>
				<cfelse>
					<cfrethrow />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="makeCommonMapping" access="private" returntype="struct" output="false" hint="Convert Open BlueDragon mapping to common CFMLAdmin API mapping struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="Open BlueDragon mapping structure" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonMapping.name = arguments.originalStruct.name;
			local.commonMapping.directory = arguments.originalStruct.directory;
		</cfscript>

		<cfreturn local.commonMapping />
	</cffunction>


<!--- Custom Tag Paths --->
	<cffunction name="deleteCustomTagPath" access="public" returntype="void" output="false" hint="">
		<cfargument name="path" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.Extensions") />
			<cfset local.extensions.deleteCustomTagPath(arguments.path) />

			<cfcatch type="any">
				<!--- deal with OpenBlueDragon "$" on non-windows for paths --->
				<cfif server.os.name NEQ "windows">
					<cftry>
						<cfset local.extensions.deleteCustomTagPath("$" & arguments.path) />

						<cfcatch type="any">
							<cfrethrow />
						</cfcatch>
					</cftry>
				<cfelse>
					<cfrethrow />
				</cfif>
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getCustomTagPaths" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.Extensions") />
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
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.Extensions") />
			<cfset local.extensions.setCustomTagPath(arguments.path, "create") />

			<cfcatch type="any">
				<!--- deal with OpenBlueDragon "$" on non-windows for paths --->
				<cfif server.os.name NEQ "windows">
					<cftry>
						<cfset local.extensions.setCustomTagPath("$" & arguments.path, "create") />

						<cfcatch type="any">
							<cfrethrow />
						</cfcatch>
					</cftry>
				<cfelse>
					<cfrethrow />
				</cfif>
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
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.Extensions") />
			<cfset local.extensions.deleteJavaCFX(local.cfxName) />

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
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.Extensions") />
			<cfset local.returnJavaCFX = local.extensions.getJavaCFX(local.cfxName)[1] />

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
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.Extensions") />
			<cfset local.workingJavaCFXs = local.extensions.getJavaCFX() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfloop index="local.indexJavaCFX" from="1" to="#ArrayLen(local.workingJavaCFXs)#">
			<cfset ArrayAppend(local.returnJavaCFXs, makeCommonJavaCFX(local.workingJavaCFXs[local.indexJavaCFX])) />
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
			<cfset local.extensions = createObject("component", "#variables.adminApiPath#.Extensions") />
			<cfset local.extensions.setJavaCFX(local.cfxName, arguments.class, arguments.description, local.cfxName, "", "create") />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="makeCommonJavaCFX" access="private" returntype="struct" output="false" hint="Convert Open BlueDragon Java CFX to common CFMLAdmin API Java CFX struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="Open BlueDragon Java CFX structure" />

		<cfset StructDelete(arguments.originalStruct, "displayname") />

		<cfreturn arguments.originalStruct />
	</cffunction>


<!--- Caching --->
	<cffunction name="clearTemplateCache" access="public" returntype="boolean" output="false" hint="">

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.caching = createObject("component", "#variables.adminApiPath#.Caching") />
			<cfset local.caching.flushFileCache() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


</cfcomponent>