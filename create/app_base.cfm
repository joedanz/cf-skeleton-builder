<!--- create Application.cfm --->
<cffile action="read" file="#ExpandPath('./templates/')#App1.cfm" variable="app1cfm">
<cffile action="read" file="#ExpandPath('./templates/')#App2.cfm" variable="app2cfm">
<cffile action="write" file="#ExpandPath('./tmp/')#Application.cfm" output='<cfsetting enablecfoutputonly="true" showdebugoutput="true">

<cfset applicationName = "#form.appName#">#app1cfm#'>
<cfloop list="#form.cfcs#" index="i">
	<cffile action="append" file="#ExpandPath('./tmp/')#Application.cfm" output='	<cfset application.#i# = createObject("component","cfcs.#i#").init(application.settings.dsn)>'>
</cfloop>
<cffile action="append" file="#ExpandPath('./tmp/')#Application.cfm" output="#app2cfm#">

<!--- copy login.cfm --->
<cffile action="copy" source="#ExpandPath('./templates/')#login.cfm" destination="#ExpandPath('./tmp/')#">

<!--- create default index file --->
<cffile action="write" file="#ExpandPath('./tmp/')#index.cfm" output='<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="##application.settings.mapping##/tags/layout.cfm" templatename="main" title="##application.settings.title## &raquo; Home">

<cfoutput>
<h2>Database CRUD Pages</h2>
<ul style="list-style-type:square;margin-left:30px;">
	<cfloop list="#form.cfcs#" index="t">
		<li><a href="./crud/##t##.cfm">##t##</a></li>
	</cfloop>
</ul>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">'>