<!---
	Purpose : Create images directory and add images for selected template.
--->

<!--- create images directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/images/')#" />

<!--- get images list for template --->
<cfdirectory action="list" directory="#ExpandPath('./skins/' & form.template & '/images/')#" name="images" />

<!--- copy images for template --->
<cfloop query="images">
	<cfif compare(name,'.svn')>
		<cffile action="copy" source="#ExpandPath('./skins/' & form.template & '/images/')##name#" destination="#ExpandPath('./tmp/images/')#" />
	</cfif>
</cfloop>