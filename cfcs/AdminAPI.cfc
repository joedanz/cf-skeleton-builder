<cfcomponent output="false">

	<cffunction name="validateCredentials" access="remote" returntype="boolean" output="false" hint="Check credentials against Admin API & log user in if valid.">
		<cfargument name="j_username" type="string" />
		<cfargument name="j_password" type="string" />
		<cfset var validated = false />
		<!--- ensure any attempt to authenticate starts with new credentials --->
		<cflogout />
	
		<cflogin>
			<cfscript>
			validAdminLogin = createObject("component","cfide.adminapi.administrator").login("#arguments.j_password#");
			</cfscript>
			<cfif validAdminLogin>
				<cfloginuser name="#arguments.j_username#" password="#arguments.j_password#" roles="admin" />
				<cfset session.adminpw = arguments.j_password>
				<cfset validated = true />
			</cfif>
		</cflogin>
	
		<cfreturn validated />
	</cffunction>


	<cffunction name="dsList" access="remote" returnType="string">
		<cfargument name="adminpw" type="string" required="true">

		<cfset var adminapi="">
		<cfset var datasources="">
		<cfset var result="">
		
		<cftry>
		<cfscript>
		adminapi = createObject("component","cfide.adminapi.administrator").login("#arguments.adminpw#");
		datasources = createObject("component","cfide.adminapi.datasource").getDatasources();
		</cfscript>
		
		<cfloop collection="#datasources#" item="key">
			<cfset result = listAppend(result,key)>
		</cfloop>
		
		<cfcatch></cfcatch>
		</cftry>

		<cfreturn result>
	</cffunction>


	<cffunction name="dsArray" access="remote" returnType="array">
		<cfargument name="adminpw" type="string" required="true">

		<cfset var adminapi="">
		<cfset var datasources="">
		<cfset var datasourceArray=arraynew(2)>
		<cfset var result=arraynew(2)>

		<cftry>
		<cfscript>
		adminapi = createObject("component","cfide.adminapi.administrator").login("#arguments.adminpw#");
		datasources = createObject("component","cfide.adminapi.datasource").getDatasources();
		</cfscript>
		
		<cfset datasourceArray[1][1] = "">
		<cfset datasourceArray[1][2] = "Select One...">
		<cfset nextRow = 2>
		<cfloop collection="#datasources#" item="key">
			<cfset datasourceArray[nextRow][1] = key>
			<cfset datasourceArray[nextRow][2] = key>
			<cfset nextRow = nextRow + 1>
		</cfloop>

		<cfset result = datasourceArray>
		<cfcatch></cfcatch>
		</cftry>
		
		<cfreturn result>
	</cffunction>


	<cffunction name="getTables" access="remote" returnType="string">
		<cfargument name="datasource" type="string" required="false" default="cool">

		<cfset var filterTables="">
		<cfset var result="">
		<cfset var row=1>

		<cftry>
		<cfdbinfo datasource="#arguments.datasource#" name="tables" type="tables">

		<cfquery name="filterTables" dbtype="query">
			SELECT * FROM tables WHERE table_type IN ('TABLE','VIEW')
				AND table_name NOT IN ('syssegments','sysconstraints')
		</cfquery>

		<cfif not compare(arguments.datasource,'')>
			<cfset result = "">
		<cfelse>
			<cfloop query="filterTables">
				<cfsavecontent variable="li">
				<li class="wrap">
					<cfoutput>
					<input type="checkbox" name="cfcs" value="#lcase(table_name)#" checked="checked" id="t#row#" /> 
					<label for="t#row#">#lcase(table_name)#<cfif not compareNoCase(table_type,'view')> (view)</cfif></label>
					</cfoutput>
				</li>
				</cfsavecontent>
				<cfset result = result & li>
				<cfset row = row + 1>
			</cfloop>
		</cfif>
		<cfcatch></cfcatch>
		</cftry>

		<cfreturn result>
	</cffunction>

</cfcomponent>