
<cfset applicationName = right(REReplace(getDirectoryFromPath(getCurrentTemplatePath()),'[^A-Za-z0-9]','','all'),64)>
<cfapplication name="#applicationName#" sessionManagement="true" loginstorage="session">

<cfif not isDefined("application.init") or isDefined("url.reinit")>

	<!--- Get application settings depending on which server --->
	<cfif not compare(cgi.server_name,'127.0.0.1')>
		<cfset serverSettings = "settings.local.cfm">
	<cfelseif not compare(cgi.server_name,'lrc3b')>
		<cfset serverSettings = "settings.dev.cfm">
	<cfelse>
		<cfset serverSettings = "settings.ini.cfm">
	</cfif>

	<cfinvoke component="config.settings" method="getSettings" iniFile="#serverSettings#" returnVariable="settings">
	<cfset application.settings = settings>
	
	<!--- application CFCs --->	