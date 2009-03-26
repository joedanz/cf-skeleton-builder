<!---
	Purpose : Create config directory and ini files
--->

<!--- create config directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/config/')#" />

<!--- create App.cfm to protect config files from web access --->
<cffile action="copy" 
	source="#ExpandPath('./templates/config/')#Application.cfm" 
	destination="#ExpandPath('./tmp/config/')#" />

<!--- component to read ini files --->
<cffile action="copy" 
	source="#ExpandPath('./templates/config/')#settings.cfc" 
	destination="#ExpandPath('./tmp/config/')#" />

<!--- create 3 ini files: localhost, dev server & production server --->
<cffile action="write" file="#ExpandPath('./tmp/config/')#settings.ini.cfm" output="[settings]
dsn=#form.dsource#
mapping=#form.mapping#
title=#form.title#" />

<cffile action="write" file="#ExpandPath('./tmp/config/')#settings.dev.cfm" output="[settings]
dsn=#form.dsource#
mapping=#form.mapping#
title=#form.title#" />

<cffile action="write" file="#ExpandPath('./tmp/config/')#settings.local.cfm" output="[settings]
dsn=#form.dsource#
mapping=#form.mapping#
title=#form.title#" />