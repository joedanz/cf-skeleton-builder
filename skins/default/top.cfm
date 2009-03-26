<div id="wrapper">
	<div id="header">
		<cfif isDefined("session.loggedin") and session.loggedin is true>
			<div style="float:right">
				<ul id="navbar">
					<li><a href="#application.settings.mapping#/index.cfm">Home</a></li> | 
					<li><a href="#application.settings.mapping#/index.cfm?logout">Logout</a></li>
				</ul>
			</div>
		</cfif>
		<h1><img src="/stdimages/lrc40-bev.gif" alt="LRC" height="40" width="41" border="0" style="padding:0 8px 5px 5px;vertical-align:middle;" />#application.settings.title#</h1></div>
	<div id="content">