<!--- create Application file --->
<cfif not compare(form.cfmcfc,'cfm')> <!--- create Application.cfm --->
	<cffile action="read" file="#ExpandPath('./templates/')#App1.cfm" variable="app1cfm">
	<cffile action="read" file="#ExpandPath('./templates/')#App2.cfm" variable="app2cfm">
	<cffile action="write" file="#ExpandPath('./tmp/')#Application.cfm" output='<cfsetting enablecfoutputonly="true" showdebugoutput="true">#app1cfm#'>
	<cfloop list="#form.cfcs#" index="i">
		<cffile action="append" file="#ExpandPath('./tmp/')#Application.cfm" output='	<cfset application.#i# = createObject("component","cfcs.#i#").init(settings)>'>
	</cfloop>
	<cffile action="append" file="#ExpandPath('./tmp/')#Application.cfm" output="#app2cfm#">
<cfelse> <!--- create Application.cfc --->
	<cffile action="read" file="#ExpandPath('./templates/')#App1.cfc" variable="app1cfc">
	<cffile action="read" file="#ExpandPath('./templates/')#App2.cfc" variable="app2cfc">
	<cffile action="write" file="#ExpandPath('./tmp/')#Application.cfc" output='#app1cfc#'>
	<cfloop list="#form.cfcs#" index="i">
		<cffile action="append" file="#ExpandPath('./tmp/')#Application.cfc" output='		<cfset application.#i# = createObject("component","cfcs.#i#").init(settings)>'>
	</cfloop>
	<cffile action="append" file="#ExpandPath('./tmp/')#Application.cfc" output="#app2cfc#">
</cfif>

<!--- copy login.cfm --->
<cffile action="copy" source="#ExpandPath('./templates/')#login.cfm" destination="#ExpandPath('./tmp/')#">

<!--- copy error.cfm --->
<cffile action="copy" source="#ExpandPath('./templates/')#error.cfm" destination="#ExpandPath('./tmp/')#">

<!--- create default index file --->
<cffile action="write" file="#ExpandPath('./tmp/')#index.cfm" output='<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="##application.settings.mapping##/tags/layout.cfm" templatename="main" title="##application.settings.title## &raquo; Home">

<cfoutput>
<h2>Hello World!</h2>

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">'>