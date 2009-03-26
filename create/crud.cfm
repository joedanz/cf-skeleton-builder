<!--- allow for no CFCs to be selected --->
<cfparam name="form.cfcs" default="">

<cfif listLen(form.cfcs)>
	<!--- create directory for CRUD files --->
	<cfdirectory action="create" directory="#ExpandPath('./tmp/crud/')#">
</cfif>

<cfloop list="#form.cfcs#" index="i">

	<!--- query db for columns --->
	<cfdbinfo datasource="#form.dsource#" table="#i#" type="columns" name="columns">

	<!--- separate out keys from non-keys --->
	<cfquery name="primary_keys" dbtype="query">
		select * from columns where IS_PRIMARYKEY = 'YES'
	</cfquery>	
	<cfquery name="non_primary_keys" dbtype="query">
		select * from columns where IS_PRIMARYKEY = 'NO'
	</cfquery>	
	
	<cfset thisCRUD = '<cfsetting enablecfoutputonly="true">

<cfif isDefined("url.del")>
	<cfset application.#i#.delete(url.del)>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="##application.settings.mapping##/tags/layout.cfm" templatename="main" title="##application.settings.title## &raquo; CRUD &raquo; #i#">

<cfoutput>
<style type="text/css">
ul.subnav { float:right; font-size:1.1em; }
ul.subnav li { display:inline; font-weight:bold; }
label { float:left; width:200px; text-align:right; margin-right:10px; }
</style>

<ul class="subnav">
	<li><a href="##cgi.script_name##?list">List</a></li> | 
	<li><a href="##cgi.script_name##?new">New</a></li> | 
	<li><a href="../index.cfm">Home</a></li>
</ul>
<h2>#i#</h2>

<cfif isDefined("url.list")>

	<cfset records = application.#i#.get()>
	<table cellpadding="2" cellspacing="0" border="1">
	<tr>
		<th>####</th>
		<th>Action</th>'>

	<cfloop query="columns">
		<cfset thisCRUD = thisCRUD & '#chr(10)#		<th>#column_name#</th>'>
	</cfloop>

	<cfset thisCRUD = thisCRUD & '#chr(10)#	</tr>'>

	<cfset thisCRUD = thisCRUD & '#chr(10)#	<cfloop query="records">
	<tr>
		<td>##currentRow##</td><td>[<a href="">edit</a>] [<a href="##cgi.script_name##?del=1&'>
		
		<cfloop query="primary_keys">
			<cfset thisCRUD = thisCRUD & '#column_name#=###column_name###&'>
		</cfloop>

		<cfset thisCRUD = thisCRUD & 'list" onclick="return confirm(''Are you sure you wish to delete this record?'');">x</a>]</td>'>

		<cfloop query="columns">
			<cfset thisCRUD = thisCRUD & '#chr(10)#		<td>###Column_name###</td>'>
		</cfloop>

	<cfset thisCRUD = thisCRUD & '	#chr(10)#	</tr>
	</cfloop>'>

	<cfset thisCRUD = thisCRUD & '
	</tr>

	</table>

<cfelseif isDefined("url.new")>'>

	<cfloop query="columns">
		<cfset thisCRUD = thisCRUD & '#chr(10)#	<p>#chr(10)#		<label for="#column_name#">#column_name#:</label>#chr(10)#		'>
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCRUD = thisCRUD & '<input type="text" name="#column_name#" id="#column_name#" />#chr(10)#	</p>'>
		<cfelse>
			<cfset thisCRUD = thisCRUD & '<input type="text" name="#column_name#" id="#column_name#" maxlength="#column_size#" />#chr(10)#	</p>#chr(10)#'>
		</cfif>
	</cfloop>

	<cfset thisCRUD = thisCRUD & '#chr(10)#	<input type="submit" value="Add New Record" id="sub" />
</cfif>

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">'>

<cffile action="write" file="#ExpandPath('./tmp/crud/')##i#.cfm" output="#thisCRUD#">

</cfloop>
