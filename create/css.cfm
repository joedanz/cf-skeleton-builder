<!---
	Purpose : Create css directory and add relevant stylesheets to master.css
--->

<!--- create css directory and YUI reset css files --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/css/')#" />

<cfset mastercss = "" />

<!--- include html reset? --->
<cfif isDefined("form.yuireset")>
	<cffile action="copy" source="#ExpandPath('./templates/css/')#reset-min.css" destination="#ExpandPath('./tmp/css/')#" />
	<cfset mastercss = mastercss & '@import url("reset.css");
' />
</cfif>

<!--- include font reset? --->
<cfif isDefined("form.yuifonts")>
	<cffile action="copy" source="#ExpandPath('./templates/css/')#fonts-min.css" destination="#ExpandPath('./tmp/css/')#" />
	<cfset mastercss = mastercss & '@import url("fonts.css");
' />
</cfif>

<!--- get template css --->
<cfswitch expression="#form.skin#">

	<cfcase value="default">
		<cffile action="copy" source="#ExpandPath('./skins/default/')#style.css" destination="#ExpandPath('./tmp/css/')#" />
		<cfset mastercss = mastercss & '@import url("style.css");
' />
	</cfcase>

</cfswitch>	
	
<!--- write out master.css --->
<cffile action="write" file="#ExpandPath('./tmp/css/')#master.css" output="#mastercss#" />