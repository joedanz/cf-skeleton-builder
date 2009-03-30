<!--- create cfc directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/cfcs/')#">

<!--- create any selected cfcs --->
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
	
	<!--- start CFC & init method --->
	<cfset thisCFC = '<cfcomponent displayName="#i#" hint="Manages CRUD operations for the #i# table.">

	<cfset variables.dsn = "">
	
	<cffunction name="init" access="public" returntype="#i#" output="false"
				html="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="dsn" type="string" required="true" hint="DSN used for all operations in the CFC.">

		<cfset variables.dsn = arguments.dsn>

		<cfreturn this>
	</cffunction>
	'>


	<!--- get Method --->
	<cfset thisCFC = thisCFC & '#chr(10)#	<cffunction name="get" access="public" returntype="query" output="false"
				hint="Returns #i# records.">'>

	<cfloop query="primary_keys">
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="numeric" required="false" default="0" />'>
		<cfelse>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="string" required="false" default="" />'>
		</cfif>	
	</cfloop>

	<cfset thisCFC = thisCFC & '
		<cfset var qRecords = "">
		
		<cfquery name="qRecords" datasource="##variables.dsn##">
			SELECT '>

	<cfloop query="columns">
		<cfset thisCFC = thisCFC & column_name>
		<cfif currentRow neq recordCount>
			<cfset thisCFC = thisCFC & ', '>
		</cfif>
	</cfloop>
	
	<cfset thisCFC = thisCFC & '
			FROM #i#'>

	<cfset thisCFC = thisCFC & '
		</cfquery>		
		
		<cfreturn qRecords>
		
	</cffunction>
	'>	


	<!--- insert Method --->
	<cfset thisCFC = thisCFC & '#chr(10)#	<cffunction name="create" access="public" returntype="void" output="false"
				hint="Inserts a #i# record.">'>

	<cfloop query="primary_keys">
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="numeric" required="false" default="0" />'>
		<cfelse>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="string" required="false" default="" />'>
		</cfif>	
	</cfloop>
	
	<cfloop query="non_primary_keys">
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="numeric" required="false" default="0" />'>
		<cfelse>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="string" required="false" default="" />'>
		</cfif>	
	</cfloop>	

	<cfset thisCFC = thisCFC & '#chr(10)##chr(10)#		<cfquery datasource="##variables.dsn##">
			INSERT INTO #i# ('>

	<cfloop query="columns">
		<cfset thisCFC = thisCFC & column_name>
		<cfif currentRow neq recordCount>
			<cfset thisCFC = thisCFC & ', '>
		</cfif>
	</cfloop>

	<cfset thisCFC = thisCFC & ')
				VALUES('>

	<cfloop query="columns">
	
		<cfset result = getCFSQLType(type_name)>	
		
		<cfif not compareNoCase(result,'CF_SQL_BIT')>
			<cfset thisCFC = thisCFC & '#chr(10)#				<cfqueryparam cfsqltype="#result#" VALUE="##arguments.#column_name###" maxlength="1" />'>	
		<cfelseif compareNoCase(result,'CF_SQL_DATE')>
			<cfset thisCFC = thisCFC & '#chr(10)#				<cfqueryparam cfsqltype="#result#" VALUE="##arguments.#column_name###" maxlength="#column_size#" />'>	
		<cfelse>
			<cfset thisCFC = thisCFC & '#chr(10)#				<cfqueryparam cfsqltype="#result#" VALUE="##arguments.#column_name###" />'>
		</cfif>
		
		<cfif currentRow neq recordCount>
			<cfset thisCFC = thisCFC & ', '>
		</cfif>
						
	</cfloop>
				
	<cfset thisCFC = thisCFC & '		
				)
		</cfquery>
			
	</cffunction>
	'>


	<!--- update Method --->
	<cfset thisCFC = thisCFC & '#chr(10)#	<cffunction name="update" access="public" retunrtype="void" output="false"
				hint="Updates a #i# record.">'>

	<cfloop query="primary_keys">
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="numeric" required="false" default="0" />'>
		<cfelse>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="string" required="false" default="" />'>
		</cfif>	
	</cfloop>
	
	<cfloop query="non_primary_keys">
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="numeric" required="false" default="0" />'>
		<cfelse>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="string" required="false" default="" />'>
		</cfif>	
	</cfloop>	

	<cfset thisCFC = thisCFC & '#chr(10)##chr(10)#		<cfquery datasource="##variables.dsn##">
			UPDATE #i# SET
				'>

	<cfloop query="non_primary_keys">
	
		<cfset result = getCFSQLType(type_name)>

		<cfif not compareNoCase(result,'CF_SQL_BIT')>
			<cfset thisCFC = thisCFC & '#column_name# = <cfqueryparam cfsqltype="#result#" value="##ARGUMENTS.#column_name###" maxlength="1" />'>
		<cfelseif compareNoCase(result,'CF_SQL_DATE')>
			<cfset thisCFC = thisCFC & '#column_name# = <cfqueryparam cfsqltype="#result#" value="##ARGUMENTS.#column_name###" maxlength="#column_size#" />'>
		<cfelse>
			<cfset thisCFC = thisCFC & '#column_name# = <cfqueryparam cfsqltype="#result#" value="##ARGUMENTS.#column_name###" />'>
		</cfif>
		
		<cfif currentRow neq recordCount>
			<cfset thisCFC = thisCFC & ', 
				'>
		</cfif>
	</cfloop>

	<cfset thisCFC = thisCFC & '
			WHERE 0=0'>

	<cfloop query="primary_keys">
		<cfset result = getCFSQLType(type_name)>
		
		<cfset thisCFC = thisCFC & '
				AND #column_name# = <cfqueryparam cfsqltype="#result#" value="##arguments.#column_name###">'>
	</cfloop>
	
	<cfset thisCFC = thisCFC & '			
		</cfquery>
				
	</cffunction>
	'>


	<!--- delete Method --->
	<cfset thisCFC = thisCFC & '#chr(10)#	<cffunction name="delete" access="public" returntype="void" output="false"	hint="Deletes a #i# record.">'>

	<cfloop query="primary_keys">
		<cfif listFindNoCase('bigint,bit,decimal,float,int,money,smallint,smallmoney,tinyint',replaceNoCase(type_name,' identity',''))>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="numeric" required="false" default="0" />'>
		<cfelse>
			<cfset thisCFC = thisCFC & '#chr(10)#		<cfargument name="#column_name#" type="string" required="false" default="" />'>
		</cfif>	
	</cfloop>

	<cfset thisCFC = thisCFC & '
		
		<cfquery datasource="##variables.dsn##">
			DELETE FROM #i# WHERE 0=0'>

	<cfloop query="primary_keys">
	
		<cfset result = getCFSQLType(type_name)>		
		
		<cfset thisCFC = thisCFC & '
				AND #column_name# = <cfqueryparam cfsqltype="#result#" VALUE="##arguments.#column_name###" maxlength="#column_size#">'>
	</cfloop>

	<cfset thisCFC = thisCFC & '
		</cfquery>
		
	</cffunction>'>

	<!--- end of CFC --->
	<cfset thisCFC = thisCFC & '#chr(10)##chr(10)#</cfcomponent>'>

	<cffile action="write" file="#ExpandPath('./tmp/cfcs/')##i#.cfc" OUTPUT="#thisCFC#">

</cfloop>

<cffunction name="getCFSQLType" returntype="string">
	<cfargument name="type_name" type="string" required="true">
	<cfset var result = "">
	<cfswitch expression="#arguments.type_name#">
		<cfcase value="bigint"><cfset result = "CF_SQL_BIGINT"></cfcase>
		<cfcase value="bit"><cfset result = "CF_SQL_BIT"></cfcase>
		<cfcase value="char"><cfset result = "CF_SQL_CHAR"></cfcase>
		<cfcase value="datetime"><cfset result = "CF_SQL_DATE"></cfcase>
		<cfcase value="decimal"><cfset result = "CF_SQL_DECIMAL"></cfcase>
		<cfcase value="float"><cfset result = "CF_SQL_FLOAT"></cfcase>
		<cfcase value="int"><cfset result = "CF_SQL_INTEGER"></cfcase>
		<cfcase value="money"><cfset result = "CF_SQL_MONEY"></cfcase>
		<cfcase value="nchar"><cfset result = "CF_SQL_CHAR"></cfcase>
		<cfcase value="ntext"><cfset result = "CF_SQL_LONGVARCHAR"></cfcase>
		<cfcase value="numeric"><cfset result = "CF_SQL_NUMERIC"></cfcase>
		<cfcase value="nvarchar"><cfset result = "CF_SQL_VARCHAR"></cfcase>
		<cfcase value="real"><cfset result = "CF_SQL_REAL"></cfcase>
		<cfcase value="smalldatetime"><cfset result = "CF_SQL_DATE"></cfcase>
		<cfcase value="smallint"><cfset result = "CF_SQL_SMALLINT"></cfcase>
		<cfcase value="smallmoney"><cfset result = "CF_SQL_MONEY4"></cfcase>
		<cfcase value="text"><cfset result = "CF_SQL_LONGVARCHAR"></cfcase>
		<cfcase value="timestamp"><cfset result = "CF_SQL_TIMESTAMP"></cfcase>
		<cfcase value="tinyint"><cfset result = "CF_SQL_TINYINT"></cfcase>
		<cfcase value="uniqueidentifier"><cfset result = "CF_SQL_IDSTAMP"></cfcase>
		<cfcase value="varchar"><cfset result = "CF_SQL_VARCHAR"></cfcase>
		<cfdefaultcase><cfset result = "UNKNOWN"></cfdefaultcase>
	</cfswitch>		
	<cfreturn result />
</cffunction>