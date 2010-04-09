<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfinvoke component="skeleton.cfcs.dbinfo" method="getTables" returnvariable="tables">
	<cfinvokeargument name="datasource" value="#url.ds#">
</cfinvoke>

<cfoutput>
#tables#
</cfoutput>

<cfsetting enablecfoutputonly="false">