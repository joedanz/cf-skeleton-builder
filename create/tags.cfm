<!---
	Purpose : Create tags directory and include layout tag for templates.
--->

<!--- create tags directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/tags/')#" />

<!--- copy layout.cfm which calls header & footer --->
<cffile action="copy" source="#ExpandPath('./templates/tags/')#layout.cfm"
	destination="#ExpandPath('./tmp/tags/')#" />

<!--- copy force_login.cfm which ensures user is logged in --->
<cffile action="copy" source="#ExpandPath('./templates/tags/')#force_login.cfm"
	destination="#ExpandPath('./tmp/tags/')#" />

<!--- copy udf.cfm which has user defined functions --->
<cffile action="copy" source="#ExpandPath('./templates/tags/')#udf.cfm"
	destination="#ExpandPath('./tmp/tags/')#" />
