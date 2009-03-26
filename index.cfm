<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfif isDefined("create")>
	
	<cfparam name="form.CFCs" default="">
	
	<!--- delete old working directory --->
	<cftry>
		<cfdirectory action="delete" directory="#ExpandPath('./tmp/')#" recurse="true">
		<cfcatch></cfcatch>
	</cftry>

	<!--- recreate working directory --->
	<cftry>
		<cfdirectory action="create" directory="#ExpandPath('./tmp/')#">	
		<cfcatch></cfcatch>
	</cftry>

	<cfinclude template="./create/app_base.cfm" />
	<cfinclude template="./create/admin.cfm" />
	<cfinclude template="./create/cfcs.cfm" />
	<cfinclude template="./create/crud.cfm" />
	<cfinclude template="./create/config.cfm" />
	<cfinclude template="./create/css.cfm" />
	<cfinclude template="./create/images.cfm" />
	<cfinclude template="./create/tags.cfm" />
	<cfinclude template="./create/templates.cfm" />
	
	<!--- scripts to include in js dir --->	
	<cfif isDefined("form.jquery")>
		<cfset jsscript = "jquery">
		<cfset jsscriptURL = request.jqueryURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
	<cfif isDefined("form.jqueryui")>
		<cfset jsscript = "jqueryui">
		<cfset jsscriptURL = request.jqueryUIURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>	
	<cfif isDefined("form.jqueryCorner")>
		<cfset jsscript = "jquery.corner">
		<cfset jsscriptURL = request.jqueryCornerURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>	
	<cfif isDefined("form.prototype")>
		<cfset jsscript = "prototype">
		<cfset jsscriptURL = request.prototypeURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
	<cfif isDefined("form.scriptaculous")>
		<cfset jsscript = "scriptaculous">
		<cfset jsscriptURL = request.scriptaculousURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
	<cfif isDefined("form.mootools")>
		<cfset jsscript = "mootools">
		<cfset jsscriptURL = request.mootoolsURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
	<cfif isDefined("form.dojo")>
		<cfset jsscript = "dojo">
		<cfset jsscriptURL = request.dojoURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
	<cfif isDefined("form.swfobject")>
		<cfset jsscript = "swfobject">
		<cfset jsscriptURL = request.swfobjectURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
	<cfif isDefined("form.yui")>
		<cfset jsscript = "yui">
		<cfset jsscriptURL = request.yuiURL>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
		
	<!--- create zip file --->
	<cfinclude template="./create/zip.cfm" />
	
</cfif>

<cfoutput>
<html>
<head>
<title>CF Skeleton Site Creator</title>
<link rel="stylesheet" type="text/css" href="./css/reset-min.css" />
<link rel="stylesheet" type="text/css" href="./css/fonts-min.css" />
<link rel="stylesheet" type="text/css" href="./css/style.css" />
<script type="text/javascript" src="./js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="./js/jquery.corner.js"></script>
<script type="text/javascript" src="./js/master.js"></script>
</head>
<body>
<cfajaxproxy cfc="cfcs.AdminAPI" jsclassname="AdminAPI" />
<div id="container">
<cfform action="index.cfm" method="post">
<div id="header">ColdFusion Skeleton Site Creator</div>

<div class="row" id="step1">
	<label for="appName" class="step">Step 1: Enter an application name:</label> 
	<input type="text" name="appName" size="30" id="appName" style="padding:2px;" />
</div>

<div class="row" id="step2">
	<label for="title" class="step">Step 2: Enter a title for your app:</label> 
	<input type="text" name="title" size="30" id="title" style="padding:2px;" />
</div>

<div class="row" id="step3">
	<label for="mapping" class="step">Step 3: Enter the mapping path:</label> 
	<input type="text" name="mapping" size="30" id="mapping" style="padding:2px;" />
</div>

<div class="row" id="step4">
	<label for="doctype" class="step">Step 4: Which doctype would you like to use?</label>
	<ul id="doctype">
		<li class="wrap"><input type="radio" name="doctype" value="xhtml1tr" id="xhtml1tr" /> 
			<label for="xhtml1tr">XHTML 1.0 Transitional</label></li>
		<li class="wrap"><input type="radio" name="doctype" value="xhtml1st" id="xhtml1st" /> 
			<label for="xhtml1st">XHTML 1.0 Strict</label></li>
		<li><input type="radio" name="doctype" value="xhtml11dtd" id="xhtml11dtd" /> 
			<label for="xhtml11dtd">XHTML 1.1 DTD</label></li>
		<li class="wrap"><input type="radio" name="doctype" value="html4tr" id="html4tr" checked="checked" /> 
			<label for="html4tr">HTML 4.01 Transitional</label></li>
		<li><input type="radio" name="doctype" value="html4st" id="html4st" /> 
			<label for="html4st">HTML 4.01 Strict</label></li>
	</ul>
</div>

<div class="row" id="step5">
	<label for="scripts" class="step">Step 5: Select any libraries to include: </label>
	<ul id="scripts">
		<li class="wrap"><input type="checkbox" name="jquery" value="1" id="jquery" /> 
			<label for="jquery">jQuery</label></li>
		<li class="wrap"><input type="checkbox" name="prototype" value="1" id="prototype" /> 
			<label for="prototype">Prototype</label></li>
		<li><input type="checkbox" name="yuireset" value="1" id="yuireset" checked="checked" /> 
			<label for="yuireset">YUI Reset</label></li>

		<li class="wrap"><input type="checkbox" name="jqueryui" value="1" id="jqueryui" /> 
			<label for="jqueryui">jQuery UI</label></li>
		<li class="wrap"><input type="checkbox" name="prototype" value="1" id="prototype" /> 
			<label for="prototype">Script.aculo.us</label></li>
		<li><input type="checkbox" name="yuifonts" value="1" id="yuifonts" checked="checked" /> 
			<label for="yuifonts">YUI Fonts</label></li>
			
		<li class="wrap"><input type="checkbox" name="jqueryCorner" value="1" id="jqueryCorner" /> 
			<label for="jqueryCorner">jQuery Corner Plugin</label></li>
		<li class="wrap"><input type="checkbox" name="mootools" value="1" id="mootools" /> 
			<label for="mootools">MooTools</label></li>
		<li><input type="checkbox" name="yui" value="1" id="yui" checked="checked" /> 
			<label for="yui">YUI</label></li>			

		<li class="wrap"><input type="checkbox" name="dojo" value="1" id="dojo" checked="checked" /> 
			<label for="dojo">Dojo</label></li>
		<li><input type="checkbox" name="swfobject" value="1" id="swfobject" /> 
			<label for="swfobject">SWFObject</label></li>
	</ul>
	<p><input type="radio" name="javascripts" value="linked" id="linked" /> <label for="linked">Linked</label> 
		or <input type="radio" name="javascripts" value="downloaded" id="downloaded" /> <label for="downloaded">Downloaded</label>
	</p>
	<div class="note">A 'js' directory will be created if any scripts are selected for download</div>
</div>

<div class="row" id="step6">

<label for="template" class="step">Step 6: Choose a template for your application:</label>
<ul>
<cfset templateNum = 1>
<cfloop list="#request.templateList#" index="i">
	<li style="vertical-align:top; float:left;"><input type="radio" name="template" value="#i#" id="t#i#"<cfif templateNum eq 1> checked="checked"</cfif> />
		<img src="./skins/#i#/thumb.jpg" border="0" onclick="$('##t#i#').attr('checked','checked');" />&nbsp;&nbsp;&nbsp;</li>
	<cfset templateNum = templateNum + 1>
</cfloop>
</ul><br clear="both" />
</div>

<div class="row" id="step7">
<label for="ds" class="step">Step 7: Choose the datasource for your application:</label>
<cfselect name="dsource" id="dsource" style="padding:1px;" onchange="showTables();">
	<option value="">None</option>
	<cfif isDefined("session.adminpw")>
		<cfset getDS = createObject("component","cfcs.AdminAPI").dsList(session.adminpw)>
		<cfloop list="#getDS#" index="ds">
		<option value="#ds#">#ds#</option>
		</cfloop>
	</cfif>
</cfselect>
</div>

<div class="row" id="step8">
<label class="step">Step 8: Select tables and views to create CFCs &amp; CRUD pages for:</label>
<ul>
<cfdiv bind="cfc:cfcs.AdminAPI.getTables({dsource})" />
</ul><br style="clear:both;" />
</div>

<div class="row row-last">
<input type="submit" value="Create Application" name="create" class="submit" />
<h4>The following folders will be created by default:</h4>
admin, cfcs, config, css, images, tags, templates
</div>
</cfform>
</div>
</body>
</html>
</cfoutput>

<!--- login window popup --->
<cfif compareNoCase(GetAuthUser(),'admin')>
	<cfoutput>
	<cfwindow name="loginWindow" title="ColdFusion Administrator Login" center="true" closable="false" initShow="true" modal="true" height="150" width="250" resizable="false">
		
	<script type="text/javascript">
	function doLogin() {
		// Create the ajax proxy instance.
		var auth = new AdminAPI();
		// setForm() implicitly passes the form fields to the CFC function.
		auth.setForm("loginForm");
		//Call the CFC validateCredentials function.
		if (auth.validateCredentials()) {
			ColdFusion.Window.hide("loginWindow");
		} else {
			var msg = document.getElementById("loginWindow_title");
			msg.innerHTML = "Invalid Credentials. Please try again!";
		}
		return false;
	}
	</script>

	<cfform method="post" format="html" timeout="10000" name="loginForm">
		<label for="username">Username:</label> 
		<cfinput type="text" name="j_username" id="username" value="Admin" required="true" message="Administrator username is required!" />
		<label for="password">Password:</label>
		<cfinput type="password" name="j_password" id="password" required="true" message="Administrator password is required!" />
		<cfinput type="submit" name="submit" value="Login" onClick="return doLogin();" />
	</cfform>
	</cfwindow>
	</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false">