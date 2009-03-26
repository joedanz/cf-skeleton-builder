<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.title# &raquo; Home">

<cfoutput>
<h3>CRUD</h3>
<ul>
	<cfdump var="change_log,exchange_data,joined_exchange_data,lrc_pocs">
	<cfloop list="change_log,exchange_data,joined_exchange_data,lrc_pocs" index="c">
		
	</cfloop>
</ul>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">
