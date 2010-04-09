<cfcomponent output="false">

	<cffunction name="getTables" access="remote" returnType="string">
		<cfargument name="datasource" type="string" required="false" default="">

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
				<cfoutput>
				<li class="wrap">
					<input type="checkbox" name="cfcs" value="#lcase(table_name)#" checked="checked" id="t#row#" />
					<label for="t#row#">#lcase(table_name)#<cfif not compareNoCase(table_type,'view')> (view)</cfif></label>
				</li>
				</cfoutput>
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