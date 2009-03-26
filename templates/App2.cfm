
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
			<!--- check user account against database table ---> 
			<cfset session.user = application.user.get(username=trim(form.username),password=trim(form.password))>
			<cfif not structKeyExists(session.user,"userid")>
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