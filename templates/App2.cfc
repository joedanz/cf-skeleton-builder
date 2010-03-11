
		<!--- check for Blue Dragon --->
		<cfset application.isBD = StructKeyExists(server,"bluedragon")>

		<!--- check for Railo --->
		<cfset application.isRailo = not compareNoCase(server.coldfusion.productname,"railo")>

		<!--- get CF version --->
		<cfif application.isBD>
			<cfset majorVersion = listFirst(server.coldfusion.productversion,'.')>
			<cfset minorVersion = listGetAt(server.coldfusion.productversion,2,'.')>
			<cfset cfversion = server.coldfusion.productversion>
		<cfelse>
			<cfset majorVersion = listFirst(server.coldfusion.productversion)>
			<cfset minorVersion = listGetAt(server.coldfusion.productversion,2)>
			<cfset cfversion = majorVersion & "." & minorVersion>
		</cfif>

		<!--- check for CF8 Scorpio --->
		<cfset application.isCF8 = server.coldfusion.productname is "ColdFusion Server" and cfversion gte 8>

		<!--- app startup --->
		<cfparam name="application.startup" default="#DateConvert("local2Utc",Now())#">
		<!--- session tracker --->
		<cfparam name="application.sessions" default="#StructNew()#">

		<cfreturn true />
	</cffunction>

	<cffunction name="onSessionStart" access="public" returntype="void" output="false">

		<!--- application session details --->
		<cfset application.sessions[session.sessionid] = structNew()>
		<cfset application.sessions[session.sessionid].firstHit = Now()>
		<cfset application.sessions[session.sessionid].lastHit = Now()>
		<cfset application.sessions[session.sessionid].firstTemplate = cgi.script_name>
		<cfset application.sessions[session.sessionid].lastTemplate = cgi.script_name>
		<cfset application.sessions[session.sessionid].referer = cgi.http_referer>
		<cfset application.sessions[session.sessionid].numHits = 0>
		<cfset application.sessions[session.sessionid].username = "Guest">

		<cfreturn />
	</cffunction>

	<cffunction name="onRequestStart" access="public" returntype="boolean" output="false">
		<cfargument name="TargetPage" type="string" required="true" />

		<cfsetting showdebugoutput="#application.settings.showDebug#">

		<cfif isDefined("url.reinit")>
			<cfset onApplicationStart() />
		</cfif>

		<cfif isDefined("url.logout")>
			<cfset structDelete(session, "user")>
			<cfset structDelete(session, "loggedin")>
			<cflogout>
			<cfset onSessionStart() />
		</cfif>

		<!--- G18N - everything in/out to unicode --->
		<cfset setEncoding('URL','UTF-8')>
		<cfset setEncoding('Form','UTF-8')>
		<cfcontent type="text/html; charset=UTF-8">

		<cfset application.sessions[session.sessionid].numHits = application.sessions[session.sessionid].numHits + 1>
		<cfset application.sessions[session.sessionid].lastHit = Now()>
		<cfset application.sessions[session.sessionid].lastTemplate = cgi.script_name>

		<cfinclude template="./tags/udf.cfm">

		<!--- Search Engine Safe (SES) URLs --->
		<cfscript>
		pathInfo = reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '');
		i = 1;
		lastKey = "";
		value = "";
		if(len(pathInfo)){
		   for(i=1; i lte listLen(pathInfo, "/"); i=i+1) {
		    value = listGetAt(pathInfo, i, "/");
		    if(i mod 2 is 0) url[lastKey] = value;
		    else lastKey = value;
		   }
		   if((i-1) mod 2 is 1) url[lastKey] = "";
		}
		</cfscript>

		<!--- handle security --->
		<cflogin>

			<cfparam name="variables.errors" default="">
			<cfif not StructKeyExists(form,"username")>
				<cfinclude template="#application.settings.mapping#/login.cfm">
				<cfabort>
			<!--- are we trying to logon? --->
			<cfelseif not compare(trim(form.username),'') or not compare(trim(form.password),'')>
				<cfset variables.errors = variables.errors & "<li>Your must enter your login info to continue!</li>">
				<cfinclude template="#application.settings.mapping#/login.cfm">
				<cfabort>
			<cfelse>
				<!--- check user account against database table --->
				<cfset getUser = application.users.get(username=trim(form.username),password=trim(form.password))>
				<cfif not compare(getUser.userid,'')>
					<cfset variables.errors = variables.errors & "<li>Your login was not accepted. Please try again!</li>">
					<cfinclude template="#application.settings.mapping#/login.cfm">
					<cfabort>
				<cfelse>
					<!--- log user into application --->
					<cfloginuser name="#trim(form.username)#" password="#trim(form.password)#" roles="user">
					<cfset session.user.userid = getUser.userid>
					<cfset session.user.username = getUser.username>
					<!---<cfset session.user.admin = getUser.admin>--->
					<cfset session.loggedin = true>
					<!--- set last login stamp --->
					<!---<cfset application.user.setLastLogin(getUser.userid)>--->
				</cfif>
			</cfif>

		</cflogin>

		<!--- check admin authority --->
		<cfif findNoCase('/admin/',cgi.script_name) and not session.user.admin>
			<cfoutput><h2>#application.settings.site_name# - Admin Access Only!!!</h2></cfoutput><cfabort>
		</cfif>

		<cfreturn true />
	</cffunction>

	<cffunction name="onRequestEnd" access="public" returntype="void" output="true" hint="fires after the page processing is complete.">
		<!--- This is the perfect place to handle page logging. By doing it here (especially if the first command is a <cfflush> tag), the user experience will not be affected by any processing overhead of this event method. --->
		<!---
		<cfdump var="#session.user#">
		<cfdump var="#application.whoson#">
		<cfdump var="#application.settings#">--->
		<cfreturn />
	</cffunction>

	<cffunction name="onSessionEnd" access="public" returntype="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true" />
		<cfargument name="applicationScope" type="struct" required="false" default="#structNew()#" />

		<cfset arguments.appScope.unregisterUser(arguments.sessionScope.urltoken)>
		<cfset structDelete(arguments.appScope.sessions, arguments.sessionScope.urltoken)>
		<cfreturn />
	</cffunction>

	<cffunction name="onApplicationEnd" access="public" returntype="void" output="false" hint="fires when the application is terminated.">
		<cfargument name="applicationScope" type="struct" required="false" default="#structNew()#" />
		<!--- This is the perfect place to log information about the application. This method does not have inherent access to the application scope. In order to access that scope, you must used the passed in argument. --->
		<cfreturn />
	</cffunction>

	<cffunction name="onError" access="public" returntype="void" output="true" hint="fires when an exception occures that is not caught by a try/catch.">
		<cfargument name="Exception" type="any" required="true" />
		<cfargument name="EventName" type="string" required="false" default="" />
		<!--- This event gets called when an event fires and allows you to handle that error and include an error handling template if you so desire. However, this event cannot display anything to the user if the error occurs during the OnApplicationEnd() or OnSessionEnd() events as those are not request-related (unless called explicitly during a request). One thing to be aware of (as of MX7) is that the <cflocation> tag throws a runtime Abort exception (which makes sense if you understand that the <cflocation> tag halts the page and flushes header information to the browser). As a work around to this, you can check the passed in Exception type and if its a Abort exception do not process the error: <cfif NOT compareNoCase(arguments.Exception.RootCause.Type, "coldfusion.runtime.AbortException")> <!--- do not process this error ---> <cfreturn /> </cfif> --->

		<cfoutput>
		<h2>An error has occured!</h2>

		<cfif application.settings.showError>
		<p>
		Page: #cgi.script_name#?#cgi.query_string#<br>
		Time: #dateFormat(now())# #timeFormat(now())#<br>
		</p>

		<cfdump var="#arguments.exception#" label="Exception">
		<cfdump var="#url#" label="URL">
		<cfdump var="#form#" label="Form">
		<cfdump var="#cgi#" label="CGI">

		</cfif>

		<h5><em>Please try again or contact your administrator.</em></h5>
		</cfoutput>

		<cfreturn />
	</cffunction>

</cfcomponent>