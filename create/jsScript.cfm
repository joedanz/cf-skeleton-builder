<!---
	Purpose : Retrieve packed jquery.js from jQuery site.
--->

<cfif form.javascripts is 'downloaded'>

<!--- create js directory if not there --->
<cftry>
	<cfdirectory action="create" directory="#ExpandPath('./tmp/js/')#" />
	<cfcatch></cfcatch>
</cftry>

<!--- retrieve prototype.js from site --->
<cfhttp url="#jsscriptURL#" result="jsfile" />

<!--- write javascript out to js directory --->
<cffile action="write"
	file="#ExpandPath('./tmp/js/')##jsscript#.js"
	output="#jsfile.fileContent#" />

</cfif>