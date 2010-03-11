
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

	<cfset application.init = true>

</cfif>

<!--- error page --->
<cfif application.settings.errorPage>
	<cferror type="exception" template="#application.settings.mapping#/error.cfm">
</cfif>

<!--- include UDFs --->
<cfinclude template="#application.settings.mapping#/tags/udf.cfm">

<!--- check for logout --->
<cfif isDefined("url.logout")>
	<cfset structDelete(session, "user")>
	<cfset session.loggedin = false>
	<cflogout>
</cfif>

<!--- handle security --->
<cflogin>

	<cfif NOT IsDefined("username")>
		<cfinclude template="login.cfm">
		<cfabort>
	<cfelse>
		<!--- are we trying to logon? --->
		<cfif not compare(trim(form.username),'') or not compare(trim(form.password),'')>
			<cfset error="Your must enter your AKO login info to continue!">
			<cfinclude template="login.cfm">
			<cfabort>
		<cfelse>
			<!--- check user account against database table --->
			<cfset session.user = application.users.get(username=trim(form.username),password=trim(form.password))>
			<cfif not structKeyExists(session.user,"userid") or not compare(session.user.userid,'')>
				<cfset error="Your login was not accepted!">
				<cfinclude template="login.cfm">
				<cfabort>
			<cfelse>
				<!--- log user into application --->
				<cfloginuser name="#trim(form.username)#" password="#trim(form.password)#" roles="user">
				<cfset session.loggedin = true>
			</cfif>
		</cfif>
	</cfif>

</cflogin>

<cfsetting enablecfoutputonly="false">