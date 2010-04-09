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
<cfcomponent displayname="CFMLAdmin API - Railo (base)" output="false" hint="CFMLAdmin API Layer for Railo (base)">

	<cffunction name="init" access="public" returntype="any" output="false" hint="">
		<cfargument name="password" type="string" required="true" hint="" />
		<cfargument name="username" type="string" default="" hint="" />
		<cfargument name="adminApiPath" type="string" default="" hint="" />

		<cfset variables.adminPassword = arguments.password />
		<cfset variables.context = "web" /> <!--- hard setting context to "web", can't come up with case where application would install server wide --->
		<cfreturn this />
	</cffunction>


<!--- Security --->
	<cffunction name="login" access="public" returntype="boolean" output="false" hint="">

		<cftry>
			<cfadmin action="connect" password="#variables.adminPassword#" type="#variables.context#">
			<cfcatch type="security">
				<cfreturn FALSE />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


<!--- Datasources --->
	<cffunction name="deleteDatasource" access="public" returntype="void" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cftry>
			<cfadmin action="removeDatasource" password="#variables.adminPassword#" type="#variables.context#" name="#arguments.dsn#">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getDatasource" access="public" returntype="struct" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfadmin action="getDatasource" password="#variables.adminPassword#" type="#variables.context#" name="#arguments.dsn#" returnVariable="local.returnDSN">

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
			<cfadmin action="getDatasources" password="#variables.adminPassword#" type="#variables.context#" returnVariable="local.workingDSNs">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- Railo returns datasources as a query, loop to make array of structs in common format --->
		<cfloop query="local.workingDSNs">
			<cfset ArrayAppend(local.returnDSNs, makeCommonDSN(queryRowToStruct(local.workingDSNs, local.workingDSNs.currentRow))) />
		</cfloop>

		<cfreturn local.returnDSNs />
	</cffunction>

	<cffunction name="setDatasource" access="public" returntype="void" output="false" hint="Creates Railo datasource">
		<cfargument name="name" type="string" required="true" hint="datasource name" />
		<cfargument name="description" type="string" required="false" hint="description for datasource <strong>[ignored]</strong>" />
		<cfargument name="databasetype" type="string" required="true" hint="database type <ul><li>jdbc</li><li>mssql - defaults to jTDS JDBC driver</li><li>mysql</li><li>oracle</li><li>postgresql</li></ul>" />
		<cfargument name="database" type="string" required="false" hint="name of database to use (or SID for Oracle)" />
		<cfargument name="server" type="string" required="false" hint="database server" />
		<cfargument name="username" type="string" required="false" hint="database username" />
		<cfargument name="password" type="string" required="false" hint="database password" />
		<cfargument name="port" type="numeric" required="false" hint="database port (will use databasetype default unless specified)" />
		<cfargument name="additionalConnectionParameters" type="string" required="false" hint="additional parameters for database connection" />
		<cfargument name="loginTimeout" type="numeric" required="false" hint="login timeout (in seconds) <strong>[ignored]</strong>" />
		<cfargument name="connectionTimeout" type="numeric" default="60" hint="timeout for database connection (in seconds)" />
		<cfargument name="connectionPooling" type="boolean" required="false" hint="is the connection pooled <strong>[ignored]</strong>" />
		<cfargument name="maxConnections" type="numeric" required="false" hint="maximum number of connections allowed" />
		<cfargument name="allowSQL_select" type="boolean" default="TRUE" hint="are SQL select statements allowed" />
		<cfargument name="allowSQL_insert" type="boolean" default="TRUE" hint="are SQL insert statements allowed" />
		<cfargument name="allowSQL_update" type="boolean" default="TRUE" hint="are SQL update statements allowed" />
		<cfargument name="allowSQL_delete" type="boolean" default="TRUE" hint="are SQL delete statements allowed" />
		<cfargument name="allowSQL_storedprocedure" type="boolean" required="false" hint="are SQL stored procedures allowed <strong>[ignored]</strong>" />
		<cfargument name="allowSQL_create" type="boolean" default="TRUE" hint="are SQL create statements allowed" />
		<cfargument name="allowSQL_alter" type="boolean" default="TRUE" hint="are SQL alter statements allowed" />
		<cfargument name="allowSQL_drop" type="boolean" default="TRUE" hint="are SQL drop statements allowed" />
		<cfargument name="allowSQL_grant" type="boolean" default="TRUE" hint="are SQL grant statements allowed" />
		<cfargument name="allowSQL_revoke" type="boolean" default="TRUE" hint="are SQL revoke statements allowed" />
		<cfargument name="allowSQL_blob" type="boolean" default="FALSE" hint="are SQL blobs allowed" />
		<cfargument name="allowSQL_clob" type="boolean" default="FALSE" hint="are SQL clobs allowed" />
		<cfargument name="jdbcURL" type="string" required="false" hint="JDBC URL to use (databasetype='jdbc' only)" />
		<cfargument name="jdbcClass" type="string" required="false" hint="Class for JDBC Driver (databasetype='jdbc' only)" />

		<cfset var local = StructNew() />

		<cfscript>
			// map common DSN back to Railo
			local.dsnSettings = StructNew();
			local.dsnSettings.name = arguments.name;

			if(StructKeyExists(arguments, "server") AND Len(arguments.server))
				local.dsnSettings.host = arguments.server;

			if(StructKeyExists(arguments, "database") AND Len(arguments.database))
				local.dsnSettings.database = arguments.database;

			if(StructKeyExists(arguments, "username") AND Len(arguments.username))
				local.dsnSettings.dbusername = arguments.username;

			if(StructKeyExists(arguments, "password") AND Len(arguments.password))
				local.dsnSettings.dbpassword = arguments.password;

			if(StructKeyExists(arguments, "connectionTimeout") AND Len(arguments.connectionTimeout))
				local.dsnSettings.connectiontimeout = Ceiling(Val(arguments.connectionTimeout) / 60); // convert seconds back to minutes

			if(StructKeyExists(arguments, "maxConnections") AND Len(arguments.maxConnections)){
				local.dsnSettings.connectionLimit = arguments.maxConnections;
			} else {
				local.dsnSettings.connectionLimit = ""; // Railo default
			}


			if(StructKeyExists(arguments, "allowSQL_select") AND Len(arguments.allowSQL_select))
				local.dsnSettings.allowed_select = arguments.allowSQL_select;

			if(StructKeyExists(arguments, "allowSQL_insert") AND Len(arguments.allowSQL_insert))
				local.dsnSettings.allowed_insert = arguments.allowSQL_insert;

			if(StructKeyExists(arguments, "allowSQL_update") AND Len(arguments.allowSQL_update))
				local.dsnSettings.allowed_update = arguments.allowSQL_update;

			if(StructKeyExists(arguments, "allowSQL_delete") AND Len(arguments.allowSQL_delete))
				local.dsnSettings.allowed_delete = arguments.allowSQL_delete;

			if(StructKeyExists(arguments, "allowSQL_create") AND Len(arguments.allowSQL_create))
				local.dsnSettings.allowed_create = arguments.allowSQL_create;

			if(StructKeyExists(arguments, "allowSQL_alter") AND Len(arguments.allowSQL_alter))
				local.dsnSettings.allowed_alter = arguments.allowSQL_alter;

			if(StructKeyExists(arguments, "allowSQL_drop") AND Len(arguments.allowSQL_drop))
				local.dsnSettings.allowed_drop = arguments.allowSQL_drop;

			if(StructKeyExists(arguments, "allowSQL_grant") AND Len(arguments.allowSQL_grant))
				local.dsnSettings.allowed_grant = arguments.allowSQL_grant;

			if(StructKeyExists(arguments, "allowSQL_revoke") AND Len(arguments.allowSQL_revoke))
				local.dsnSettings.allowed_revoke = arguments.allowSQL_revoke;

			if(StructKeyExists(arguments, "allowSQL_blob") AND Len(arguments.allowSQL_blob))
				local.dsnSettings.blob = arguments.allowSQL_blob;

			if(StructKeyExists(arguments, "allowSQL_clob") AND Len(arguments.allowSQL_clob))
				local.dsnSettings.clob = arguments.allowSQL_clob;

			if(StructKeyExists(arguments, "jdbcURL") AND Len(arguments.jdbcURL))
				local.dsnSettings.dsn = arguments.jdbcURL;

			if(StructKeyExists(arguments, "jdbcClass") AND Len(arguments.jdbcClass))
				local.dsnSettings.classname = arguments.jdbcClass;

			local.dsnSettings.custom = StructNew();
		</cfscript>

		<!--- database specific configuration --->
		<cfswitch expression="#LCase(arguments.databasetype)#">

			<cfcase value="jdbc">
				<cfscript>
					local.dsnSettings.host = "";
					local.dsnSettings.database = "";
					local.dsnSettings.port = "";
					local.dsnSettings.dbusername = "";
					local.dsnSettings.dbpassword = "";
				</cfscript>
			</cfcase>

			<cfcase value="mssql_ms">
				<cfscript>
					local.dsnSettings.port = 1433;
					local.dsnSettings.classname = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
					local.dsnSettings.dsn = "jdbc:sqlserver://{host}:{port}";

					if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
						local.dsnSettings.custom = queryStringToStruct(arguments.additionalConnectionParameters, ";");
				</cfscript>
			</cfcase>

			<cfcase value="mssql,mssql_jtds"> <!--- default all MSSQL to jTDS JDBC driver --->
				<cfscript>
					local.dsnSettings.port = 1433;
					local.dsnSettings.classname = "net.sourceforge.jtds.jdbc.Driver";
					local.dsnSettings.dsn = "jdbc:jtds:sqlserver://{host}:{port}/{database}";

					if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
						local.dsnSettings.custom = queryStringToStruct(arguments.additionalConnectionParameters, ";");
				</cfscript>
			</cfcase>

			<cfcase value="mysql,mysql3">
				<cfscript>
					local.dsnSettings.port = 3306;
					local.dsnSettings.classname = "org.gjt.mm.mysql.Driver";
					local.dsnSettings.dsn = "jdbc:mysql://{host}:{port}/{database}";

					if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
						local.dsnSettings.custom = queryStringToStruct(arguments.additionalConnectionParameters, "&");
				</cfscript>
			</cfcase>

			<cfcase value="mysql4,mysql5">
				<cfscript>
					local.dsnSettings.port = 3306;
					local.dsnSettings.classname = "com.mysql.jdbc.Driver";
					local.dsnSettings.dsn = "jdbc:mysql://{host}:{port}/{database}";

					if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
						local.dsnSettings.custom = queryStringToStruct(arguments.additionalConnectionParameters, "&");
				</cfscript>
			</cfcase>

			<cfcase value="oracle">
				<cfscript>
					local.dsnSettings.port = 1521;
					local.dsnSettings.classname = "oracle.jdbc.driver.OracleDriver";
					local.dsnSettings.dsn = "jdbc:oracle:{drivertype}:@{host}:{port}:{database}";

					if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
						local.dsnSettings.custom = queryStringToStruct(arguments.additionalConnectionParameters, ";");

					local.setDriverTypeResult = StructInsert(local.dsnSettings.custom, "drivertype", "thin", TRUE);
				</cfscript>
			</cfcase>

			<cfcase value="postgresql">
				<cfscript>
					local.dsnSettings.port = 5432;
					local.dsnSettings.drivername = "org.postgresql.Driver";
					local.dsnSettings.dsn = "jdbc:postgresql://{host}:{port}/{database}";

					if(StructKeyExists(arguments, "additionalConnectionParameters") AND Len(arguments.additionalConnectionParameters))
						local.dsnSettings.custom = queryStringToStruct(arguments.additionalConnectionParameters, "&");
				</cfscript>
			</cfcase>

			<cfdefaultcase>
				<cfthrow type="cfmladminapi.setDatasource.UNKNOWN_DATABASETYPE" message="" />
			</cfdefaultcase>
		</cfswitch>

		<cftry>

			<cfadmin
				action="updateDatasource"
				type="#variables.context#"
				password="#variables.adminPassword#"
				classname="#local.dsnSettings.classname#"
				dsn="#local.dsnSettings.dsn#"
				name="#local.dsnSettings.name#"
				host="#local.dsnSettings.host#"
				database="#local.dsnSettings.database#"
				port="#local.dsnSettings.port#"
				dbusername="#local.dsnSettings.dbusername#"
				dbpassword="#local.dsnSettings.dbpassword#"
				connectionLimit="#local.dsnSettings.connectionLimit#"
				connectionTimeout="#local.dsnSettings.connectionTimeout#"
				blob="#local.dsnSettings.blob#"
				clob="#local.dsnSettings.clob#"
				allowed_select="#local.dsnSettings.allowed_select#"
				allowed_insert="#local.dsnSettings.allowed_insert#"
				allowed_update="#local.dsnSettings.allowed_update#"
				allowed_delete="#local.dsnSettings.allowed_delete#"
				allowed_alter="#local.dsnSettings.allowed_alter#"
				allowed_drop="#local.dsnSettings.allowed_drop#"
				allowed_revoke="#local.dsnSettings.allowed_revoke#"
				allowed_create="#local.dsnSettings.allowed_create#"
				allowed_grant="#local.dsnSettings.allowed_grant#"
				custom="#local.dsnSettings.custom#">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="verifyDatasource" access="public" returntype="boolean" output="false" hint="">
		<cfargument name="dsn" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.returnDSN = getDatasource(arguments.dsn) />

			<cfadmin
				action="verifyDatasource"
				type="#variables.context#"
				password="#variables.adminPassword#"
				name="#arguments.dsn#"
				dbusername="#local.returnDSN.username#"
				dbpassword="#local.returnDSN.password#">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>

	<cffunction name="makeCommonDSN" access="private" returntype="struct" output="false" hint="Convert Railo datasource to common CFMLAdmin API datasource struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="Railo datasource (as a structure)" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonDSN.name = arguments.originalStruct.name;
			local.commonDSN.description = ""; // Railo does not have a description for datasource
			local.commonDSN.username = arguments.originalStruct.username;
			local.commonDSN.password = arguments.originalStruct.password;
			local.commonDSN.databasetype = getDatabaseTypeByClass(arguments.originalStruct.classname);
			local.commonDSN.server = arguments.originalStruct.host;
			local.commonDSN.port = arguments.originalStruct.port;
			local.commonDSN.database = arguments.originalStruct.database;
			local.commonDSN.jdbcURL = arguments.originalStruct.dsnTranslated;
			local.commonDSN.jdbcClass = arguments.originalStruct.classname;

			local.commonDSN.allowSQL_select = arguments.originalStruct.select;
			local.commonDSN.allowSQL_insert = arguments.originalStruct.insert;
			local.commonDSN.allowSQL_update = arguments.originalStruct.update;
			local.commonDSN.allowSQL_delete = arguments.originalStruct.delete;
			local.commonDSN.allowSQL_storedprocedure = ""; // Railo does not have a flag for stored procedures

			local.commonDSN.allowSQL_create = arguments.originalStruct.create;
			local.commonDSN.allowSQL_alter = arguments.originalStruct.alter;
			local.commonDSN.allowSQL_drop = arguments.originalStruct.drop;
			local.commonDSN.allowSQL_grant = arguments.originalStruct.grant;
			local.commonDSN.allowSQL_revoke = arguments.originalStruct.revoke;

			local.commonDSN.allowSQL_blob = arguments.originalStruct.blob;
			local.commonDSN.allowSQL_clob = arguments.originalStruct.clob;

			local.commonDSN.maxConnections = arguments.originalStruct.connectionLimit;
			local.commonDSN.loginTimeout = ""; // Railo does not have a login timeout for datasources
			local.commonDSN.connectionTimeout = (Val(arguments.originalStruct.connectionTimeout) * 60); // Railo stores timeout in minutes, convert to seconds
			local.commonDSN.connectionPooling = ""; // Railo does not have a flag for connection pooling

			// only variation between single datasource and multiple (struct vs query)
			if (structKeyExists(arguments.originalStruct, "custom") AND NOT StructIsEmpty(arguments.originalStruct.custom)) {
				local.commonDSN.additionalConnectionParameters = structToQueryString(arguments.originalStruct.custom);
			} elseif (structKeyExists(arguments.originalStruct, "customsettings") AND NOT StructIsEmpty(arguments.originalStruct.customsettings)) {
				local.commonDSN.additionalConnectionParameters = structToQueryString(arguments.originalStruct.customsettings);
			} else {
				local.commonDSN.additionalConnectionParameters = "";
			}
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

		<cftry>
			<cfadmin action="removeMapping" password="#variables.adminPassword#" type="#variables.context#" virtual="#arguments.mapName#">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getMapping" access="public" returntype="struct" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfadmin action="getMappings" password="#variables.adminPassword#" type="#variables.context#" returnVariable="local.workingMappings">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- Railo does not have a getMapping action for cfadmin --->
		<cfquery dbtype="query" name="local.workingMapping">
		SELECT	*
		FROM	local.workingMappings
		WHERE	virtual = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mapName#" />
		AND	hidden = 0
		</cfquery>

		<cfif local.workingMapping.RecordCount NEQ 1>
			<cfthrow type="CFMLAdminApi.getMapping.NOTFOUND" message="Could not find mapping #arguments.mapName#" />
		</cfif>

		<cfreturn makeCommonMapping(queryRowToStruct(local.workingMapping)) />
	</cffunction>

	<cffunction name="getMappings" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />
		<cfset local.returnMappings = ArrayNew(1) />

		<cftry>
			<cfadmin action="getMappings" password="#variables.adminPassword#" type="#variables.context#" returnVariable="local.workingMappings">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- filter out "hidden" mappings --->
		<cfquery dbtype="query" name="local.workingMappings">
		SELECT	*
		FROM	local.workingMappings
		WHERE	hidden = 0
		</cfquery>

		<!--- Railo returns mappings as a query, loop to make array of structs in common format --->
		<cfloop query="local.workingMappings">
			<cfset ArrayAppend(local.returnMappings, makeCommonMapping(queryRowToStruct(local.workingMappings, local.workingMappings.currentRow))) />
		</cfloop>

		<cfreturn local.returnMappings />
	</cffunction>

	<cffunction name="setMapping" access="public" returntype="void" output="false" hint="">
		<cfargument name="mapName" type="string" required="true" hint="" />
		<cfargument name="mapPath" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>
			<cfadmin action="updateMapping" password="#variables.adminPassword#" type="#variables.context#" virtual="#arguments.mapName#" physical="#arguments.mapPath#" archive="false" primary="false" trusted="false">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="makeCommonMapping" access="private" returntype="struct" output="false" hint="Convert Railo mapping to common CFMLAdmin API mapping struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="Railo mapping (as a structure)" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonMapping.name = arguments.originalStruct.virtual;
			local.commonMapping.directory = arguments.originalStruct.strphysical;
		</cfscript>

		<cfreturn local.commonMapping />
	</cffunction>


<!--- Custom Tag Paths --->
	<cffunction name="deleteCustomTagPath" access="public" returntype="void" output="false" hint="">
		<cfargument name="path" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<cftry>

			<cfset local.workingCustomTagPaths = getCustomTagPaths() />

			<!--- removeCustomTag uses virtual attribute with weird "/{indexnumber}" (zero based) to identify customtag path instead of using physical attribute --->
			<cfloop index="local.loopIndex" from="1" to="#ArrayLen(local.workingCustomTagPaths)#">
				<cfif server.os.name EQ "windows">
					<!--- since windows filesystem is case insensitive --->
					<cfif CompareNoCase(local.workingCustomTagPaths[local.loopIndex], arguments.path) EQ 0>
						<cfadmin action="removeCustomTag" password="#variables.adminPassword#" type="#variables.context#" virtual="/#(local.loopIndex - 1)#">
						<cfbreak />
					</cfif>
				<cfelse>
					<!--- probably should break OSX out, but I deem it Unix/Linux variant with case sensitivity --->
					<cfif Compare(local.workingCustomTagPaths[local.loopIndex], arguments.path) EQ 0>
						<cfadmin action="removeCustomTag" password="#variables.adminPassword#" type="#variables.context#" virtual="/#(local.loopIndex - 1)#">
						<cfbreak />
					</cfif>
				</cfif>
			</cfloop>

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getCustomTagPaths" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />
		<cfset local.returnCustomTagPaths = ArrayNew(1) />

		<cftry>
			<cfadmin action="getCustomTagMappings" password="#variables.adminPassword#" type="#variables.context#" returnVariable="local.workingCustomTagPaths">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- Railo returns custom tag paths as a query, loop to make array in common format --->
		<cfloop query="local.workingCustomTagPaths">
			<cfset ArrayAppend(local.returnCustomTagPaths, local.workingCustomTagPaths.strphysical) />
		</cfloop>

		<cfreturn local.returnCustomTagPaths />
	</cffunction>

	<cffunction name="setCustomTagPath" access="public" returntype="void" output="false" hint="">
		<cfargument name="path" type="string" required="true" hint="" />

		<cftry>
			<cfadmin action="updateCustomTag" password="#variables.adminPassword#" type="#variables.context#" virtual="" physical="#arguments.path#" archive="" primary="false" trusted="false">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

	</cffunction>

<!--- Java CFX --->
	<cffunction name="deleteJavaCFX" access="public" returntype="void" output="false" hint="">
		<cfargument name="cfxName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<!--- Railo does not prefix the Java CFX with cfx_, so strip it off --->
		<cfif CompareNoCase(Left(arguments.cfxName, 4), "cfx_") EQ 0>
			<cfset local.cfxName = Right(arguments.cfxName, (Len(arguments.cfxName) - 4)) />
		<cfelse>
			<cfset local.cfxName = arguments.cfxName />
		</cfif>

		<cftry>
			<!--- ugh, action name is inconsitent --->
			<cfadmin action="removeCFX" password="#variables.adminPassword#" type="#variables.context#" name="#local.cfxName#">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getJavaCFX" access="public" returntype="struct" output="false" hint="">
		<cfargument name="cfxName" type="string" required="true" hint="" />

		<cfset var local = StructNew() />

		<!--- Railo does not prefix the Java CFX with cfx_, so strip it off --->
		<cfif CompareNoCase(Left(arguments.cfxName, 4), "cfx_") EQ 0>
			<cfset local.cfxName = Right(arguments.cfxName, (Len(arguments.cfxName) - 4)) />
		<cfelse>
			<cfset local.cfxName = arguments.cfxName />
		</cfif>

		<cftry>
			<cfadmin action="getJavaCFXTags" password="#variables.adminPassword#" type="#variables.context#" returnVariable="local.workingJavaCFXs">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- Railo does not have a getJavaCFX action for cfadmin --->
		<cfquery dbtype="query" name="local.workingJavaCFX">
		SELECT	*
		FROM	local.workingJavaCFXs
		WHERE	name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.cfxName#" />
		</cfquery>

		<cfif local.workingJavaCFX.RecordCount NEQ 1>
			<cfthrow type="CFMLAdminApi.getJavaCFX.NOTFOUND" message="Could not find Java CFX #arguments.cfxName#" />
		</cfif>

		<cfreturn makeCommonJavaCFX(queryRowToStruct(local.workingJavaCFX)) />
	</cffunction>

	<cffunction name="getJavaCFXs" access="public" returntype="array" output="false" hint="">

		<cfset var local = StructNew() />
		<cfset local.returnJavaCFXs = ArrayNew(1) />

		<cftry>
			<cfadmin action="getJavaCFXTags" password="#variables.adminPassword#" type="#variables.context#" returnVariable="local.workingJavaCFXs">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<!--- Railo returns Java CFXs as a query, loop to make array of structs in common format --->
		<cfloop query="local.workingJavaCFXs">
			<cfset ArrayAppend(local.returnJavaCFXs, makeCommonJavaCFX(queryRowToStruct(local.workingJavaCFXs, local.workingJavaCFXs.currentRow))) />
		</cfloop>

		<cfreturn local.returnJavaCFXs />
	</cffunction>

	<cffunction name="setJavaCFX" access="public" returntype="void" output="false" hint="">
		<cfargument name="cfxName" type="string" required="true" hint="" />
		<cfargument name="class" type="string" required="true" hint="" />
		<cfargument name="description" type="string" default="" hint="" />

		<cfset var local = StructNew() />

		<!--- Railo does not prefix the Java CFX with cfx_, so strip it off --->
		<cfif CompareNoCase(Left(arguments.cfxName, 4), "cfx_") EQ 0>
			<cfset local.cfxName = Right(arguments.cfxName, (Len(arguments.cfxName) - 4)) />
		<cfelse>
			<cfset local.cfxName = arguments.cfxName />
		</cfif>

		<cftry>
			<cfadmin action="updateJavaCFX" password="#variables.adminPassword#" type="#variables.context#" name="#local.cfxName#" class="#arguments.class#">

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="makeCommonJavaCFX" access="private" returntype="struct" output="false" hint="Convert Railo Java CFX to common CFMLAdmin API Java CFX struct">
		<cfargument name="originalStruct" type="struct" required="true" hint="Railo Java CFX (as a structure)" />

		<cfset var local = StructNew() />

		<cfscript>
			local.commonJavaCFX.name = "cfx_" & arguments.originalStruct.name;
			local.commonJavaCFX.description = ""; // Railo does not have a description for Java CFX
			local.commonJavaCFX.class = arguments.originalStruct.class;
		</cfscript>

		<cfreturn local.commonJavaCFX />
	</cffunction>


<!--- Caching --->
	<cffunction name="clearTemplateCache" access="public" returntype="boolean" output="false" hint="">

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.returnBoolean = PagePoolClear() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


<!--- Utility methods --->
	<cffunction name="structToQueryString" access="private" returntype="string" output="false" hint="Converts a structure to a URL query string">
		<cfargument name="keyValueStruct" type="struct" required="true" hint="Structure of key/value pairs you want converted to URL parameters" />
		<cfargument name="queryStringDelim" type="string" default="&" hint="Delimiter separating url parameters" />
		<cfargument name="keyValueDelim" type="string" default="=" hint="Delimiter for the keys/values" />

		<cfset var local = structNew() />
		<cfset local.returnString = "" />

		<cfloop collection="#arguments.keyValueStruct#" item="local.item">
			<cfset local.returnString = ListAppend(local.returnString, URLEncodedFormat(local.item) & arguments.keyValueDelim & URLEncodedFormat(arguments.keyValueStruct[local.item]), arguments.queryStringDelim) />
		</cfloop>

		<cfreturn local.returnString />
	</cffunction>

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

	<cffunction name="queryRowToStruct" access="private" returntype="struct" output="false" hint="Makes a row of a query into a structure.">
		<cfargument name="query" type="query" required="true" hint="Query to work with" />
		<cfargument name="row" type="numeric" default="1" hint="Row number to check" />

		<cfset var local = StructNew() />

		<cfset local.returnStruct = StructNew() />
		<cfset local.columnList = listToArray(arguments.query.columnList) />

		<cfloop index="local.loopIndex" from="1" to="#ArrayLen(local.columnList)#">
			<cfset local.returnStruct[local.columnList[local.loopIndex]] = arguments.query[local.columnList[local.loopIndex]][arguments.row] />
		</cfloop>

		<cfreturn local.returnStruct />
	</cffunction>

</cfcomponent>