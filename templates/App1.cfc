<cfcomponent displayname="Application" output="false" hint="Handle the application.">

	<!--- set up the application --->
	<cfset this.name 				= right(REReplace(getDirectoryFromPath(getCurrentTemplatePath()),'[^A-Za-z0-9]','','all'),64) />
	<cfset this.applicationTimeout	= createTimeSpan(1,0,0,0) />
	<cfset this.clientManagement 	= true />
	<cfset this.clientStorage 		= "cookie" />
	<cfset this.loginStorage 		= "cookie" />
	<cfset this.sessionManagement 	= true />
	<cfset this.sessionTimeout 		= createTimeSpan(1,0,0,0) />
	<cfset this.setClientCookies 	= true />
	<cfset this.setDomainCookies 	= false />
	<cfset this.scriptProtect 		= true />
	<cfset this.customTagPaths 		= getDirectoryFromPath(getCurrentTemplatePath()) & "tags/">

	<!--- define the page request properties --->
	<cfsetting requesttimeout="30" enablecfoutputonly="false" />
	<cfparam name="application.settings.showDebug" default="false">

	<cffunction name="onApplicationStart" access="public" returntype="boolean" output="false">

		<!--- Select App settings --->
		<cfif not compare(cgi.server_name,'127.0.0.1') or not compareNoCase(cgi.server_name,'localhost')>
			<cfset application.whichServer = "development">
		<cfelseif not compareNoCase(cgi.server_name,'** staging server name **')>
			<cfset application.whichServer = "staging">
		<cfelse>
			<cfset application.whichServer = "live">
		</cfif>

		<!--- Load App settings --->
		<cfinvoke component="config.settings" method="get" whichServer="#application.whichServer#" returnVariable="settings">
		<cfset application.settings = settings>
		<cfset settings.cfcPath = replace(settings.mapping,'/','.','all') & '.site.cfcs.'>
		<cfset application.settings.cfcPath = right(settings.cfcPath,len(settings.cfcPath)-1)>

		<!--- Load Application CFCs --->