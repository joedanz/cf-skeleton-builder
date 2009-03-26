<div id="container">
	<div id="header"><cfif isDefined("session.loggedin") and session.loggedin is true><span id="menu2" style="float:right" class="s12"><a href="#application.settings.mapping#/index.cfm">Home</a> &##183; <cfif session.user.admin eq 1><a href="#application.settings.mapping#/admin/">Admin</a> &##183; </cfif><a href="#application.settings.mapping#/index.cfm?logout">Logout</a>
	
	<cfif not compareNoCase(right(cgi.script_name,11),'addTask.cfm')>
	<div class="s18" style="text-align:right;padding:5px;">Add Task</div>
	<cfelseif not compareNoCase(right(cgi.script_name,12),'editTask.cfm')>
	<div class="s18" style="text-align:right;padding:5px;">Edit Task</div>	
	</cfif>
	</span>
	
	#application.settings.title#<div id="menu1" class="s13" style="color:##444;"><a href="#application.settings.mapping#/index.cfm">Home</a> // <!---<a href="search.cfm">Search</a> // ---><a href="#application.settings.mapping#/report.cfm">Report<cfif session.user.admin eq 1>s</cfif></a><cfif session.user.admin eq 1> // <a href="#application.settings.mapping#/admin/users.cfm">Users</a></cfif></div><cfelse>#application.settings.title#<div class="s12">Please login below...</div></cfif></div>
	<div id="main">
