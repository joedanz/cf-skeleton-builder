<!---
	Purpose : Create admin directory and default Application.cfm to protect it.
--->

<!--- create admin directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/admin/')#" />

<!--- create default App.cfm to protect from non-admins --->
<cffile action="write" file="#ExpandPath('./tmp/admin/')#Application.cfm" 
	output='<cfinclude template="../Application.cfm">

<cfif not session.user.admin>
	<h2>Admin Only!!!</h2>
	<cfabort>
</cfif>' />