
	<cfset application.init = true>
	
</cfif>

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
			<!--- don't perform AKOAuth while on localhost --->
			<cfif not compare(cgi.server_name,'127.0.0.1')>
				<cfset valid = true>
			<cfelse>
				<cf_AKOAuth login="#trim(form.username)#" password="#trim(form.password)#" cfmx givelinks>
			</cfif>				
		
			<cfif not valid>
				<cfset error="Your AKO login was not accepted. Please try again!">
				<cfinclude template="login.cfm">
				<cfabort>
			<cfelse>
				<!--- uncomment to check user account against database table 
				<cfset session.user = application.user.getUser(trim(form.username))>
				<cfif not structKeyExists(session.user,"userid")>
					<cfset error="You do not have an account in this system!">
					<cfinclude template="login.cfm">
					<cfabort>
				<cfelse>
					<!--- log user into application --->
					<cfloginuser name="#trim(form.username)#" password="#trim(form.password)#" roles="user">
					<cfset session.loggedin = true>		
				</cfif>
				--->
				<!--- log user into application --->
				<cfloginuser name="#trim(form.username)#" password="#trim(form.password)#" roles="user">
				<cfset session.loggedin = true>		
			</cfif>
		</cfif>			
	</cfif>
	
</cflogin>

<cfsetting enablecfoutputonly="false">