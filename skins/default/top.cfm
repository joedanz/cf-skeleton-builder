<div id="wrapper">
	<div id="header">
		<cfif isDefined("session.loggedin") and session.loggedin is true>
			<div style="float:right">
				<a href="#application.settings.mapping#/index.cfm?logout">Logout</a>
			</div>
		</cfif>
		<h1>#application.settings.title#</h1>
	</div>
	<cfif isDefined("session.loggedin") and session.loggedin is true>
	<ul id="navbar">
		<li><a href="#application.settings.mapping#/index.cfm" class="selected">Home</a></li>
		<li><a href="#application.settings.mapping#/index.cfm?logout">Logout</a></li>
	</ul>
	</cfif>
	<div id="content">