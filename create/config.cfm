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
<cffile action="write" file="#ExpandPath('./tmp/config/')#settings.ini.cfm" output="[development]
dsn=#form.dsource#
tablePrefix=
mapping=#form.mapping#
title=#form.title#
dbUsername=
dbPassword=
mailServer=
mailUsername=
mailPassword=
mailPort=25
mailUseSSL=false
mailUseTLS=false
showDebug=true
showError=true

[live]
dsn=#form.dsource#
tablePrefix=
mapping=#form.mapping#
title=#form.title#
dbUsername=
dbPassword=
mailServer=
mailUsername=
mailPassword=
mailPort=25
mailUseSSL=false
mailUseTLS=false
showDebug=true
showError=true

[staging]
dsn=#form.dsource#
tablePrefix=
mapping=#form.mapping#
title=#form.title#
dbUsername=
dbPassword=
mailServer=
mailUsername=
mailPassword=
mailPort=25
mailUseSSL=false
mailUseTLS=false
showDebug=true
showError=true" />