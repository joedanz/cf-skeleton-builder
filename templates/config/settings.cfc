<cfcomponent displayName="Config" hint="Core CFC for the application. Main purpose is to handle settings.">

	<cffunction name="get" access="public" returnType="struct" output="false"
				hint="Returns application settings as a structure.">

	    <cfargument name="whichServer" required="false" default="development">

		<!--- load the settings from the ini file --->
		<cfset var settingsFile = getDirectoryFromPath(getCurrentTemplatePath()) & 'settings.ini.cfm'>
		<cfset var iniData = getProfileSections(settingsFile)>
		<cfset var r = structNew()>
		<cfset var key = "">
		<cfset var dsn = "">
		<cfset var getSettings = "">
		<cfset var fieldList = iniData[arguments.whichServer]>

		<cfloop index="key" list="#fieldList#">
			<cfset r[key] = getProfileString(settingsFile,arguments.whichServer,key)>
			<cfif key is "dsn">
				<cfset dsn = r[key]>
			</cfif>
		</cfloop>

		<cftry>
			<cfquery name="getSettings" datasource="#dsn#">
				SELECT setting,settingValue FROM #r['tableprefix']#settings
			</cfquery>
			<cfloop query="getSettings">
				<cfset r['#setting#'] = settingValue>
			</cfloop>
			<cfcatch></cfcatch>
		</cftry>

		<cfreturn r>

	</cffunction>

</cfcomponent>