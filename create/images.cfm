<!---
	Purpose : Create images directory and add images for selected template.
--->

<!--- create images directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/images/')#" />

<!--- copy images for template --->
<cfswitch expression="#form.skin#">

	<cfcase value="default">
		<cffile action="copy" source="#ExpandPath('./skins/default/images/')#header-bg.png" destination="#ExpandPath('./tmp/images/')#" />
		<cffile action="copy" source="#ExpandPath('./skins/default/images/')#body-bg.png" destination="#ExpandPath('./tmp/images/')#" />
		<cffile action="copy" source="#ExpandPath('./skins/default/images/')#footer-bg.png" destination="#ExpandPath('./tmp/images/')#" />
	</cfcase>

</cfswitch>