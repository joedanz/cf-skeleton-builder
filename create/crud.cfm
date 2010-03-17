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

<cfif StructKeyExists(url,"del")>
	<cfset application.#i#.delete('>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & "url.#column_name#">
		<cfif currentRow neq recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	</cfloop>

	<cfset thisCRUD = thisCRUD & ')>
<cfelseif StructKeyExists(form,"add")>
	<cfset application.#i#.create('>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & "form.#column_name#">
		<cfif currentRow neq recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	</cfloop>
	<cfif primary_keys.recordCount and non_primary_keys.recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	<cfloop query="non_primary_keys">
		<cfset thisCRUD = thisCRUD & "form.#column_name#">
		<cfif currentRow neq recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	</cfloop>

<cfset thisCRUD = thisCRUD & ')>
	<cflocation url="##cgi.script_name##?added" addtoken="false">
<cfelseif StructKeyExists(form,"upd")>
	<cfset application.#i#.update('>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & "form.#column_name#">
		<cfif currentRow neq recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	</cfloop>
	<cfif primary_keys.recordCount and non_primary_keys.recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	<cfloop query="non_primary_keys">
		<cfset thisCRUD = thisCRUD & "form.#column_name#">
		<cfif currentRow neq recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	</cfloop>
<cfset thisCRUD = thisCRUD & ')>
	<cflocation url="##cgi.script_name##?updated" addtoken="false">
</cfif>

<!--- Loads header/footer --->
<cfmodule template="##application.settings.mapping##/tags/layout.cfm" templatename="main" title="##application.settings.title## &raquo; CRUD &raquo; #i#">

<cfoutput>
<ul class="subnav">
	<li><cfif not isDefined("url.new")>List<cfelse><a href="##cgi.script_name##?list">List</a></cfif></li> |
	<li><cfif isDefined("url.new")>New<cfelse><a href="##cgi.script_name##?new">New</a></cfif></li>
</ul>
<h2>#i#</h2>

<cfif StructKeyExists(url,"new")>

	<form action="##cgi.script_name##" method="post">
	'>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & '#chr(10)#		<p>#chr(10)#			<label for="#column_name#">#column_name#:</label>#chr(10)#		'>
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCRUD = thisCRUD & '	<input type="text" name="#column_name#" id="#column_name#" />#chr(10)#		</p>'>
		<cfelse>
			<cfset thisCRUD = thisCRUD & '	<input type="text" name="#column_name#" id="#column_name#" maxlength="#column_size#" value="##createUUID()##" />#chr(10)#		</p>#chr(10)#'>
		</cfif>
	</cfloop>
	<cfloop query="non_primary_keys">
		<cfset thisCRUD = thisCRUD & '#chr(10)#		<p>#chr(10)#			<label for="#column_name#">#column_name#:</label>#chr(10)#		'>
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCRUD = thisCRUD & '	<input type="text" name="#column_name#" id="#column_name#" />#chr(10)#		</p>'>
		<cfelse>
			<cfset thisCRUD = thisCRUD & '	<input type="text" name="#column_name#" id="#column_name#" maxlength="#column_size#" />#chr(10)#		</p>#chr(10)#'>
		</cfif>
	</cfloop>

	<cfset thisCRUD = thisCRUD & '#chr(10)#		<label for="sub">&nbsp;</label><input type="submit" name="add" value="Add New Record" id="sub" /> or <a href="##cgi.script_name##">Cancel</a>

	</form>

<cfelseif StructKeyExists(url,"edit")>

	<cfset record = application.#i#.get('>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & "url.#column_name#">
		<cfif currentRow neq recordCount><cfset thisCRUD = thisCRUD & ","></cfif>
	</cfloop>

	<cfset thisCRUD = thisCRUD & ')>

	<form action="##cgi.script_name##" method="post">
	'>

	<cfloop query="non_primary_keys">
		<cfset thisCRUD = thisCRUD & '#chr(10)#		<p>#chr(10)#			<label for="#column_name#">#column_name#:</label>#chr(10)#		'>
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCRUD = thisCRUD & '	<input type="text" name="#column_name#" id="#column_name#" value="##record.#column_name###" />#chr(10)#		</p>'>
		<cfelse>
			<cfset thisCRUD = thisCRUD & '	<input type="text" name="#column_name#" id="#column_name#" maxlength="#column_size#" value="##record.#column_name###" />#chr(10)#		</p>#chr(10)#'>
		</cfif>
	</cfloop>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & '		<input type="hidden" name="#column_name#" value="##record.#column_name###" />'>
	</cfloop>

	<cfset thisCRUD = thisCRUD & '#chr(10)#		<label for="sub">&nbsp;</label><input type="submit" name="upd" value="Update Record" id="sub" /> or <a href="##cgi.script_name##">Cancel</a>

	</form>

<cfelse>

	<cfset records = application.#i#.get()>
	<table cellpadding="2" cellspacing="0" border="1">
	<thead>
		<tr>
			<th>####</th>'>

	<cfloop query="columns">
		<cfset thisCRUD = thisCRUD & '#chr(10)#			<th>#column_name#</th>'>
	</cfloop>

	<cfset thisCRUD = thisCRUD & '#chr(10)#			<th>Action</th>#chr(10)#		</tr>#chr(10)#	</thead>#chr(10)#	<tbody>'>

	<cfset thisCRUD = thisCRUD & '#chr(10)#		<cfloop query="records">
		<tr>
			<td>##currentRow##</td>'>

		<cfloop query="columns">
			<cfset thisCRUD = thisCRUD & '#chr(10)#			<td>###Column_name###</td>'>
		</cfloop>

	<cfset thisCRUD = thisCRUD & '#chr(10)#			<td>[<a href="##cgi.script_name##?edit=1&'>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & '&#column_name#=###column_name###'>
	</cfloop>

	<cfset thisCRUD = thisCRUD & '">edit</a>] [<a href="##cgi.script_name##?del=1'>

	<cfloop query="primary_keys">
		<cfset thisCRUD = thisCRUD & '&#column_name#=###column_name###'>
	</cfloop>

	<cfset thisCRUD = thisCRUD & '" onclick="return confirm(''Are you sure you wish to delete this record?'');">x</a>]</td>'>

	<cfset thisCRUD = thisCRUD & '	#chr(10)#		</tr>
		</cfloop>'>

	<cfset thisCRUD = thisCRUD & '
	</tbody>
	</table>
</cfif>

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">'>

<cffile action="write" file="#ExpandPath('./tmp/crud/')##i#.cfm" output="#thisCRUD#">

</cfloop>


<!--- create default index file --->
<cffile action="write" file="#ExpandPath('./tmp/crud/')#index.cfm" output='<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="##application.settings.mapping##/tags/layout.cfm" templatename="main" title="##application.settings.title## &raquo; Home">

<cfoutput>
<h2>Database CRUD Pages</h2>
<ul style="list-style-type:square;margin-left:30px;">
	<cfloop list="#form.cfcs#" index="t">
		<li><a href="./##t##.cfm">##t##</a></li>
	</cfloop>
</ul>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">'>