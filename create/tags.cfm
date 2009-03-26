<!---
	Purpose : Create tags directory and include layout tag for templates.
--->

<!--- create tags directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/tags/')#" />

<!--- copy layout.cfm which calls header & footer --->
<cffile action="copy" 
	source="#ExpandPath('./templates/tags/')#layout.cfm" 
	destination="#ExpandPath('./tmp/tags/')#" />