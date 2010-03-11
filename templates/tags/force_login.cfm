<cfif not request.udf.isLoggedOn()>
	<cfinclude template="#application.settings.mapping#/site/login.cfm">
	<cfabort>
</cfif>