<!--- $Id: cfmladminapi.cfc 12 2009-12-12 17:07:55Z dcepler $ --->
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
<cfcomponent displayname="CFMLAdmin API" output="false" hint="CFMLAdmin API">

	<cffunction name="init" access="public" returntype="any" output="false" hint="Constructor. Connects to correct CFMLAdmin API engine layer">
		<cfargument name="password" type="string" required="true" hint="administrator password" />
		<cfargument name="username" type="string" default="" hint="administrator username (<strong>ColdFusion 8+ only</strong>)" />
		<cfargument name="adminApiPath" type="string" default="" hint="override default Admin API path (<strong>ColdFusion & Open BlueDragon only</strong>)" />

		<cfset var local = StructNew() />

		<cfset variables.CFMLAdminAPI.version = "0.4" />
		<cfset variables.CFMLAdminAPI.releaseDate = "20091212-121138" />
		<cfset variables.CFMLAdminAPI.supportedDBs = "jdbc,mssql,mysql,oracle,postgresql" />

		<!--- what CFML Engine are we running on--->
		<cfset variables.CFMLEngine = getCFMLEngine() />

		<!--- don't have enough info on BlueDragon & BlueDragon.NET version to reliably interact with them, so they are blocked (for now) --->
		<cfif variables.CFMLEngine.Name EQ "BlueDragon">
			<cfthrow type="cfmladminapi.UNSUPPORTED_BD_BDNET" message="BlueDragon and BlueDragon.NET are not supported, only Open BlueDragon is currently supported by CFMLAdmin API." />
		</cfif>

		<!--- override default AdminAPI CFC location --->
		<cfif Len(arguments.adminApiPath)>
			<cfset variables.CFMLEngine.actualAdminApiPath = Replace(arguments.adminApiPath, "/\", ".", "ALL") />
		<cfelse>
			<cfset variables.CFMLEngine.actualAdminApiPath = variables.CFMLEngine.defaultAdminApiPath />
		</cfif>

		<cftry>
			<!--- try to create CFMLAdminAPI instance for specific version of CFML Engine determined --->
			<cfset variables.AdminAPI = createObject("component", "#variables.CFMLEngine.Name#.#variables.CFMLEngine.Version#").init(arguments.password, arguments.username, variables.CFMLEngine.actualAdminApiPath) />

			<cfcatch type="any">
				<!--- if version of CFML Engine has more than major/minor try again with just major_minor --->
				<cfif ListLen(variables.CFMLEngine.Version, "_") GT 2>
					<cftry>
						<cfset local.majorminor = ListGetAt(variables.CFMLEngine.Version, 1, "_") & "_" & ListGetAt(variables.CFMLEngine.Version, 2, "_") />
						<cfset variables.AdminAPI = createObject("component", "#variables.CFMLEngine.Name#.#local.majorminor#").init(arguments.password, arguments.username, variables.CFMLEngine.actualAdminApiPath) />

						<cfcatch type="any">
							<cfthrow type="cfmladminapi.UNSUPPORTED" message="CFMLAdmin API currently does not support #variables.CFMLEngine.Name# #Replace(variables.CFMLEngine.Version, '_', '.', 'ALL')#" />
						</cfcatch>
					</cftry>
				<cfelse>
					<cfthrow type="cfmladminapi.UNSUPPORTED" message="CFMLAdmin API currently does not support #variables.CFMLEngine.Name# #Replace(variables.CFMLEngine.Version, '_', '.', 'ALL')#" />
				</cfif>

			</cfcatch>
		</cftry>

		<cfreturn this />
	</cffunction>


<!--- Security --->
	<cffunction name="login" access="public" returntype="boolean" output="false" hint="Login to Administrator API">

		<cfif NOT variables.AdminAPI.login()>
			<cfthrow type="cfmladminapi.login.FAILED" message="Could not login into Administrator API with credentials provided" />
		</cfif>

		<cfreturn TRUE />
	</cffunction>


<!--- Datasources --->
	<cffunction name="deleteDatasource" access="public" returntype="void" output="false" hint="Deletes a datasource">
		<cfargument name="dsn" type="string" required="true" hint="Name of the datasource to be deleted" />

		<cfset login() />

		<cfif NOT datasourceExists(arguments.dsn)>
			<cfthrow type="cfmladminapi.deleteDatasource.NOTFOUND" message="Could not find datasource #arguments.dsn#" />
		</cfif>

 		<cftry>
			<cfset variables.AdminAPI.deleteDatasource(arguments.dsn) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.deleteDatasource.FAILED" message="Could not delete datasource #arguments.dsn#" />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getDatasource" access="public" returntype="struct" output="false" hint="Returns specified datasource in common CFMLAdmin API datasource structure">
		<cfargument name="dsn" type="string" required="true" hint="Name of the datasource to be retrieved" />

		<cfset var local = StructNew() />

		<cfset login() />

 		<cftry>
			<cfset local.returnDSN = variables.AdminAPI.getDatasource(arguments.dsn) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.getDatasource.NOTFOUND" message="Could not find datasource #arguments.dsn#" />
			</cfcatch>
		</cftry>

		<cfreturn local.returnDSN />
	</cffunction>

	<cffunction name="getDatasources" access="public" returntype="array" output="false" hint="Returns array of all datasources in common CFMLAdmin API datasource structure">

		<cfset var local = StructNew() />

		<cfset login() />

 		<cftry>
			<cfset local.returnDSNs = variables.AdminAPI.getDatasources() />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.getDatasources.FAILED" message="#variables.CFMLEngine.Name# Error: #cfcatch.message#" />
			</cfcatch>
		</cftry>

		<cfreturn local.returnDSNs />
	</cffunction>

	<cffunction name="setDatasource" access="public" returntype="void" output="false" hint="Creates a datasource">
		<cfargument name="name" type="string" required="true" hint="datasource name" />
		<cfargument name="description" type="string" required="false" hint="description for datasource" />
		<cfargument name="databasetype" type="string" required="true" hint="database type <ul><li>jdbc</li><li>mssql</li><li>mysql</li><li>oracle</li><li>postgresql</li></ul>" />
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

		<!--- validate datbasetype for only supported ones--->
		<cfif ListFindNoCase(variables.CFMLAdminAPI.supportedDBs, local.dbType) EQ 0>
			<cfthrow type="cfmladminapi.setDatasource.UNSUPPORTED_DATABASETYPE" message="Unsupported databasetype='#local.dbType#'. Only database types of '#variables.CFMLAdminAPI.supportedDBs#' are supported by CFMLAdmin API" />
		</cfif>

		<!--- validate additional arguments for specific databasetypes --->
		<cfif ListFindNoCase("mssql,mysql,oracle,postgresql", local.dbType) NEQ 0>
			<cfif NOT StructKeyExists(arguments, "server")>
				<cfthrow type="cfmladminapi.setDatasource.REQUIRED_ARG" message="Argument 'server' required for databasetype='#local.dbType#'">
			</cfif>
			<cfif NOT StructKeyExists(arguments, "database")>
				<cfthrow type="cfmladminapi.setDatasource.REQUIRED_ARG" message="Argument 'database' required for databasetype='#local.dbType#'">
			</cfif>
		</cfif>

		<cfif ListFindNoCase("jdbc", local.dbType) NEQ 0>
			<cfif NOT StructKeyExists(arguments, "jdbcURL")>
				<cfthrow type="cfmladminapi.setDatasource.REQUIRED_ARG" message="Argument 'jdbcURL' required for databasetype='#local.dbType#'">
			</cfif>
			<cfif NOT StructKeyExists(arguments, "jdbcClass")>
				<cfthrow type="cfmladminapi.setDatasource.REQUIRED_ARG" message="Argument 'jdbcClass' required for databasetype='#local.dbType#'">
			</cfif>

			<cftry>
				<cfset local.registerJDBCDriver = createObject("java", "java.lang.Class").forName(arguments.jdbcClass) />

				<cfcatch type="any">
					<cfthrow type="cfmladminapi.setDatasource.BAD_CLASS" message="Could not register jdbcClass='#arguments.jdbcClass#'" />
				</cfcatch>
			</cftry>
		</cfif>

		<cfset login() />

 		<cftry>
			<cfset variables.AdminAPI.setDatasource(argumentCollection=arguments) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.setDatasource.FAILED" message="#variables.CFMLEngine.Name# Error: #cfcatch.message#" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="datasourceExists" access="public" returntype="boolean" output="false" hint="Does a datasource exist">
		<cfargument name="dsn" type="string" required="true" hint="Name of the datasource to check existance of" />

		<cftry>
			<cfset getDatasource(arguments.dsn) />

			<cfcatch type="cfmladminapi.getDatasource.NOTFOUND">
				<cfreturn FALSE />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>

	<cffunction name="verifyDatasource" access="public" returntype="boolean" output="false" hint="Verifies a given data source name">
		<cfargument name="dsn" type="string" required="true" hint="Name of the datasource to be verified" />

		<cfset var local = StructNew() />

		<cfset login() />

 		<cftry>
			<cfset local.verifiedDSN = variables.AdminAPI.verifyDatasource(arguments.dsn) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.verifyDatasource.FAILED" message="#variables.CFMLEngine.Name# Error: #cfcatch.message#" />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


<!--- Mappings --->
	<cffunction name="deleteMapping" access="public" returntype="void" output="false" hint="Deletes a mapping">
		<cfargument name="mapName" type="string" required="true" hint="Name of the mapping to be deleted" />

		<cfset login() />

		<cfif NOT mappingExists(arguments.mapName)>
			<cfthrow type="cfmladminapi.deleteMapping.NOTFOUND" message="Could not find mapping #arguments.mapName#" />
		</cfif>

		<cftry>
			<cfset variables.AdminAPI.deleteMapping(arguments.mapName) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.deleteMapping.FAILED" message="Could not delete mapping #arguments.mapName#" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getMapping" access="public" returntype="struct" output="false" hint="Returns specified mapping in common CFMLAdmin API mapping structure">
		<cfargument name="mapName" type="string" required="true" hint="Name of Mapping to be retrieved" />

		<cfset var local = StructNew() />

		<cfset login() />

		<cftry>
			<cfset local.returnMapping = variables.AdminAPI.getMapping(arguments.mapName) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.getMapping.NOTFOUND" message="Could not find mapping #arguments.mapName#" />
			</cfcatch>
		</cftry>

		<cfreturn local.returnMapping />
	</cffunction>

	<cffunction name="getMappings" access="public" returntype="array" output="false" hint="Returns an array of all mappings in common CFMLAdmin API mapping structure">

		<cfset var local = StructNew() />

		<cfset login() />

		<cftry>
			<cfset local.returnMappings = variables.AdminAPI.getMappings() />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.getMappings.FAILED" message="#variables.CFMLEngine.Name# Error: #cfcatch.message#" />
			</cfcatch>
		</cftry>

		<cfreturn local.returnMappings />
	</cffunction>

	<cffunction name="setMapping" access="public" returntype="void" output="false" hint="Creates a mapping">
		<cfargument name="mapName" type="string" required="true" hint="Name of mapping to be created" />
		<cfargument name="mapPath" type="string" required="true" hint="Path that is related to the mapping" />

		<cfset login() />

		<cfif mappingExists(arguments.mapName)>
			<cfthrow type="cfmladminapi.setMapping.EXISTS" message="Mapping #arguments.mapName# already exists" />
		</cfif>

		<cftry>
			<cfset variables.AdminAPI.setMapping(arguments.mapName, arguments.mapPath) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.setMapping.FAILED" message="Could not create mapping #arguments.mapName#" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="mappingExists" access="public" returntype="boolean" output="false" hint="Does a mapping exist">
		<cfargument name="mapName" type="string" required="true" hint="Name of mapping to check existance of" />

		<cftry>
			<cfset getMapping(arguments.mapName) />

			<cfcatch type="cfmladminapi.getMapping.NOTFOUND">
				<cfreturn FALSE />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


<!--- Custom Tag Paths --->
	<cffunction name="deleteCustomTagPath" access="public" returntype="void" output="false" hint="Deletes a custom tag path">
		<cfargument name="path" type="string" required="true" hint="path to custom tag" />

		<cfset login() />

		<cfif NOT customTagPathExists(arguments.path)>
			<cfthrow type="cfmladminapi.deleteCustomTagPath.NOTFOUND" message="Could not find custom tag path #arguments.path#" />
		</cfif>

		<cftry>
			<cfset variables.AdminAPI.deleteCustomTagPath(arguments.path) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.deleteCustomTagPath.FAILED" message="Could not delete customtag path #arguments.path#" />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="getCustomTagPaths" access="public" returntype="array" output="false" hint="Returns array of all custom tag paths">

		<cfset var local = StructNew() />

		<cfset login() />

		<cftry>
			<cfset local.returnCustomTagPaths = variables.AdminAPI.getCustomTagPaths() />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.getCustomTagPaths.FAILED" message="#variables.CFMLEngine.Name# Error: #cfcatch.message#" />
			</cfcatch>
		</cftry>

		<cfreturn local.returnCustomTagPaths />
	</cffunction>

	<cffunction name="setCustomTagPath" access="public" returntype="void" output="false" hint="Creates a custom tag path">
		<cfargument name="path" type="string" required="true" hint="" />

		<cfset login() />

		<cfif customTagPathExists(arguments.path)>
			<cfthrow type="cfmladminapi.setCustomTagPath.EXISTS" message="Customtag path #arguments.path# already exists" />
		</cfif>

		<cftry>
			<cfset variables.AdminAPI.setCustomTagPath(arguments.path) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.setCustomTagPath.FAILED" message="Could not create customtag path #arguments.path#" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="customTagPathExists" access="public" returntype="boolean" output="false" hint="Does a custom tag path exist">
		<cfargument name="path" type="string" required="true" hint="path of custom tag path to check existance of" />

		<cfset var local = StructNew() />

		<cftry>
			<cfset local.workingCustomTagPaths = getCustomTagPaths() />

			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>

		<cfloop index="local.loopIndex" from="1" to="#ArrayLen(local.workingCustomTagPaths)#">

			<cfif server.os.name EQ "windows">
				<!--- since windows filesystem is case insensitive --->
				<!--- would really like to break the OpenBlueDragon check down a layer, but since all the *Exists() are up here just dealing with it --->
				<cfif (CompareNoCase(local.workingCustomTagPaths[local.loopIndex], arguments.path) EQ 0) OR (variables.CFMLEngine.Name EQ "OpenBlueDragon" AND CompareNoCase(local.workingCustomTagPaths[local.loopIndex], "$" & arguments.path) EQ 0)>
					<cfreturn TRUE />
				</cfif>
			<cfelse>
				<!--- probably should break OSX out, but I deem it Unix/Linux variant with case sensitivity --->
				<cfif (Compare(local.workingCustomTagPaths[local.loopIndex], arguments.path) EQ 0) OR (variables.CFMLEngine.Name EQ "OpenBlueDragon" AND Compare(local.workingCustomTagPaths[local.loopIndex], "$" & arguments.path) EQ 0)>
					<cfreturn TRUE />
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn FALSE />
	</cffunction>


<!--- Java CFX --->
	<cffunction name="deleteJavaCFX" access="public" returntype="void" output="false" hint="Deletes a Java CFX">
		<cfargument name="cfxName" type="string" required="true" hint="Name of Java CFX" />

		<cfset login() />

		<cfif NOT javaCFXExists(arguments.cfxName)>
			<cfthrow type="cfmladminapi.deleteJavaCFX.NOTFOUND" message="Could not find Java CFX #arguments.cfxName#" />
		</cfif>

		<cftry>
			<cfset variables.AdminAPI.deleteJavaCFX(arguments.cfxName) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.deleteJavaCFX.FAILED" message="Could not delete Java CFX #arguments.cfxName#" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getJavaCFX" access="public" returntype="struct" output="false" hint="Returns specified Java CFX in common CFMLAdmin API Java CFX structure">
		<cfargument name="cfxName" type="string" required="true" hint="Name of Java CFX" />

		<cfset var local = StructNew() />

		<cfset login() />

		<cftry>
			<cfset local.returnJavaCFX = variables.AdminAPI.getJavaCFX(arguments.cfxName) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.getJavaCFX.NOTFOUND" message="Could not find Java CFX #arguments.cfxName#" />
			</cfcatch>
		</cftry>

		<cfreturn local.returnJavaCFX />
	</cffunction>

	<cffunction name="getJavaCFXs" access="public" returntype="array" output="false" hint="Returns array of all Java CFXs in common CFMLAdmin API Java CFX structure">

		<cfset var local = StructNew() />

		<cfset login() />

		<cftry>
			<cfset local.returnJavaCFXs = variables.AdminAPI.getJavaCFXs() />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.getJavaCFXs.FAILED" message="#variables.CFMLEngine.Name# Error: #cfcatch.message#" />
			</cfcatch>
		</cftry>

		<cfreturn local.returnJavaCFXs />
	</cffunction>

	<cffunction name="setJavaCFX" access="public" returntype="void" output="false" hint="Creates a Java CFX">
		<cfargument name="cfxName" type="string" required="true" hint="Name of tag, beginning with cfx_" />
		<cfargument name="class" type="string" required="true" hint="class/package name (without .class or .jar extension) that implements the Java CFX" />
		<cfargument name="description" type="string" default="" hint="description of tag usage" />

		<cfset login() />

		<cfif javaCFXExists(arguments.cfxName)>
			<cfthrow type="cfmladminapi.setJavaCFX.EXISTS" message="Java CFX #arguments.cfxName# already exists" />
		</cfif>

		<cftry>
			<cfset variables.AdminAPI.setJavaCFX(arguments.cfxName, arguments.class, arguments.description) />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.setJavaCFX.FAILED" message="Could not create Java CFX #arguments.cfxName#" />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="javaCFXExists" access="public" returntype="boolean" output="false" hint="Does a Java CFX exist">
		<cfargument name="cfxName" type="string" required="true" hint="Name of Java CFX" />

		<cftry>
			<cfset getJavaCFX(arguments.cfxName) />

			<cfcatch type="cfmladminapi.getJavaCFX.NOTFOUND">
				<cfreturn FALSE />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


<!--- Caching --->
	<cffunction name="clearTemplateCache" access="public" returntype="boolean" output="false" hint="Clears Template Cache">

		<cfset login() />

		<cftry>
			<cfset variables.AdminAPI.clearTemplateCache() />

			<cfcatch type="any">
				<cfthrow type="cfmladminapi.clearTemplateCache.FAILED" message="Could not clear template cache" />
			</cfcatch>
		</cftry>

		<cfreturn TRUE />
	</cffunction>


<!--- additional utility functions --->
	<cffunction name="getCFMLEngine" access="public" returntype="struct" output="false" hint="Returns common CFML Engine struct based upon server.ColdFusion.ProductName">

		<cfset var local = StructNew() />

		<cfswitch expression="#server.ColdFusion.ProductName#">
			<cfcase value="ColdFusion Server">
				<cfset local.CFMLEngine.Vendor = "Adobe" />
				<cfset local.CFMLEngine.Name = "ColdFusion" />
				<cfset local.CFMLEngine.FullVersion = Replace(server.ColdFusion.ProductVersion, ",", "_", "ALL") />
				<cfset local.CFMLEngine.Version = ListDeleteAt(local.CFMLEngine.FullVersion, ListLen(local.CFMLEngine.FullVersion, "_"), "_") /> <!--- get rid of build number --->
				<cfset local.CFMLEngine.Edition = server.ColdFusion.ProductLevel />
				<cfset local.CFMLEngine.defaultAdminApiPath = "cfide.adminapi" />
			</cfcase>
			<cfcase value="Railo">
				<cfset local.CFMLEngine.Vendor = "Railo Technologies" />
				<cfset local.CFMLEngine.Name = "Railo" />
				<cfset local.CFMLEngine.FullVersion = Replace(server.Railo.Version, ".", "_", "ALL") />
				<cfset local.CFMLEngine.Version = ListDeleteAt(local.CFMLEngine.FullVersion, ListLen(local.CFMLEngine.FullVersion, "_"), "_") /> <!--- get rid of minor patch updates --->
				<cfset local.CFMLEngine.Edition = server.ColdFusion.ProductLevel />
				<cfset local.CFMLEngine.defaultAdminApiPath = "" />
			</cfcase>
			<cfcase value="BlueDragon">

				<cfif server.ColdFusion.ProductLevel EQ "GPL">
					<cfset local.CFMLEngine.Vendor = "Open BlueDragon Project" />
					<cfset local.CFMLEngine.Name = "OpenBlueDragon" />
					<cfset local.CFMLEngine.defaultAdminApiPath = "bluedragon.adminapi" />
				<cfelse>
					<cfset local.CFMLEngine.Vendor = "New Atlanta" />
					<cfset local.CFMLEngine.Name = "BlueDragon" />
					<cfset local.CFMLEngine.defaultAdminApiPath = "" />
				</cfif>

				<cfset local.CFMLEngine.FullVersion = Replace(server.ColdFusion.ProductVersion, ".", "_", "ALL") />
				<cfset local.CFMLEngine.Version = local.CFMLEngine.FullVersion />
				<cfset local.CFMLEngine.Edition = server.ColdFusion.ProductLevel />
			</cfcase>

			<cfdefaultcase>
				<cfthrow type="cfmladminapi.getCFMLEngine.NOCLUE" message="Unable to determine CFML Engine!" />
			</cfdefaultcase>
		</cfswitch>

		<cfreturn local.CFMLEngine />
	</cffunction>

</cfcomponent>