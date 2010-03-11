
<cfset applicationName = right(REReplace(getDirectoryFromPath(getCurrentTemplatePath()),'[^A-Za-z0-9]','','all'),64)>
<cfapplication name="#applicationName#" sessionManagement="true" loginstorage="session">

<cfparam name="application.settings.showDebug" default="false">
<cfsetting showdebugoutput="#application.settings.showDebug#">

<cfif not isDefined("application.init") or isDefined("url.reinit")>

	<!--- Select App settings --->
	<cfif not compare(cgi.server_name,'127.0.0.1') or not compareNoCase(cgi.server_name,'localhost')>
		<cfset application.whichServer = "development">
	<cfelseif not compareNoCase(cgi.server_name,'** staging server name **')>
		<cfset application.whichServer = "staging">
	<cfelse>
		<cfset application.whichServer = "live">
	</cfif>

	<cfinvoke component="config.settings" method="get" whichServer="#application.whichServer#" returnVariable="settings">
	<cfset application.settings = settings>
	<cfset settings.cfcPath = replace(settings.mapping,'/','.','all') & '.cfcs.'>
	<cfset application.settings.cfcPath = right(settings.cfcPath,len(settings.cfcPath)-1)>

	<!--- application CFCs --->