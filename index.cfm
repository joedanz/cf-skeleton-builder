<cfsetting enablecfoutputonly="true">

<!--- try to login --->
<cfif StructKeyExists(form,"username")>
	<cftry>
		<cfset request.AdminAPI = createObject("component", "skeleton.cfcs.CFMLAdminAPI.cfmladminapi").init("#form.password#") />
		<cfif request.AdminAPI.login()>
			<cfset session.loggedin = true>
			<cfset session.adminAPI = request.adminAPI>
		</cfif>
		<cfcatch>
			<cfset invalidLogin = true>
		</cfcatch>
	</cftry>
</cfif>

<!--- login page --->
<cfif not StructKeyExists(session,"loggedin") or not session.loggedin>
	<cfsetting showdebugoutput="false">
	<cfoutput>
	<html>
	<head>
	<title>CF Skeleton Site Creator</title>
	<!-- Meta Tags -->
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

	<!-- Favicon -->
	<link rel="shortcut icon" href="images/favicon.ico" />
	<link rel="icon" type="image/ico" href="images/favicon.ico" />

	<link rel="stylesheet" type="text/css" href="./css/reset-min.css" />
	<link rel="stylesheet" type="text/css" href="./css/fonts-min.css" />
	<link rel="stylesheet" type="text/css" href="./css/style.css" />
	<script type="text/javascript" src="./js/jquery-1.4.2.min.js"></script>
	</head>
	<body>

	<div class="center skeleton">&nbsp;</div>

	<div class="center login rounded">
		<form action="#cgi.script_name#" method="post">
			<p>
				<label>CF Admin Username:</label> <br />
				<input type="text" class="text" name="username" value="" />
			</p>
			<p>
				<label>CF Admin Password:</label> <br />
				<input type="password" name="password" class="text" value="" />
			</p>

			<p>
				<input type="submit" class="sub" value="Login" />
			</p>
		</form>
	</div>

	<cfif isDefined("invalidLogin")>
		<div class="rounded invalid center">Your login was invalid.  Please try again...</div>
	</cfif>

	</body>
	</html>
	</cfoutput>
	<cfabort>
</cfif>

<!--- generate code --->
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
	<cfif isDefined("form.extcore")>
		<cfset jsscript = "extcore">
		<cfset jsscriptURL = request.extCore>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>
	<cfif isDefined("form.chromeframe")>
		<cfset jsscript = "chromeframe">
		<cfset jsscriptURL = request.chromeFrame>
		<cfinclude template="./create/jsScript.cfm" />
	</cfif>

	<!--- create zip file --->
	<cfinclude template="./create/zip.cfm" />
</cfif>

<cfoutput>
<html>
<head>
<title>CF Skeleton Site Creator</title>
<!-- Meta Tags -->
<meta http-equiv="content-type" content="text/html; charset=utf-8" />

<!-- Favicon -->
<link rel="shortcut icon" href="images/favicon.ico" />
<link rel="icon" type="image/ico" href="images/favicon.ico" />

<link rel="stylesheet" type="text/css" href="./css/reset-min.css" />
<link rel="stylesheet" type="text/css" href="./css/fonts-min.css" />
<link rel="stylesheet" type="text/css" href="./css/style.css" />
<script type="text/javascript" src="./js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="./js/jquery.corner.js"></script>
<script type="text/javascript" src="./js/master.js"></script>
<script type="text/javascript">
$(document).ready(function(){
    $('##dsource').change(function() {
        showTables();
    });
});
</script>
</head>
<body>
<div id="container">
<cfform action="index.cfm" method="post">
<div id="header">ColdFusion Skeleton Site Creator</div>

<div class="row" id="step1">
	<label for="title" class="step">Step 1: Enter a title for your app:</label>
	<input type="text" name="title" size="30" id="title" style="padding:2px;" />
</div>

<div class="row" id="step2">
	<label for="mapping" class="step">Step 2: Enter the mapping path:</label>
	<input type="text" name="mapping" size="30" id="mapping" style="padding:2px;" />
</div>

<div class="row" id="step3">
	<label for="doctype" class="step">Step 3: Which doctype would you like to use?</label>
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

<div class="row" id="step4">
	<label for="scripts" class="step">Step 4: Select any libraries to include: </label>
	<ul id="scripts">
		<li class="wrap"><input type="checkbox" name="jquery" value="1" id="jquery" />
			<label for="jquery">jQuery</label></li>
		<li class="wrap"><input type="checkbox" name="prototype" value="1" id="prototype" />
			<label for="prototype">Prototype</label></li>
		<li><input type="checkbox" name="prototype" value="1" id="prototype" />
			<label for="prototype">Script.aculo.us</label></li>

		<li class="wrap"><input type="checkbox" name="jqueryui" value="1" id="jqueryui" />
			<label for="jqueryui">jQuery UI</label></li>
		<li class="wrap"><input type="checkbox" name="prototype" value="1" id="prototype" />
			<label for="prototype">Script.aculo.us</label></li>
		<li><input type="checkbox" name="yui" value="1" id="yui" checked="checked" />
			<label for="yui">YUI</label></li>

		<li class="wrap"><input type="checkbox" name="jqueryCorner" value="1" id="jqueryCorner" />
			<label for="jqueryCorner">jQuery Corner Plugin</label></li>
		<li class="wrap"><input type="checkbox" name="mootools" value="1" id="mootools" />
			<label for="mootools">MooTools</label></li>
		<li><input type="checkbox" name="dojo" value="1" id="dojo" checked="checked" />
			<label for="dojo">Dojo</label></li>


		<li class="wrap"><input type="checkbox" name="swfobject" value="1" id="swfobject" />
			<label for="swfobject">SWFObject</label></li>
		<li class="wrap"><input type="checkbox" name="extcore" value="1" id="extcore" />
			<label for="extcore">Ext Core</label></li>
		<li><input type="checkbox" name="chromeframe" value="1" id="chromeframe" />
			<label for="chromeframe">Chrome Frame</label></li>
	</ul>
	<p><input type="radio" name="javascripts" value="linked" id="linked" /> <label for="linked">Linked</label>
		or <input type="radio" name="javascripts" value="downloaded" id="downloaded" checked="checked" /> <label for="downloaded">Downloaded</label>
	</p>
	<div class="note">A 'js' directory will be created if any scripts are selected for download</div>
</div>

<div class="row" id="step5">
	<label for="template" class="step">Step 5: Choose a template for your application:</label>
	<ul>
	<cfset templateNum = 1>
	<cfloop list="#request.templateList#" index="i">
		<li style="vertical-align:top; float:left;"><input type="radio" name="template" value="#i#" id="t#i#"<cfif templateNum eq 1> checked="checked"</cfif> />
			<img src="./skins/#i#/thumb.jpg" border="0" onclick="$('##t#i#').attr('checked','checked');" />&nbsp;&nbsp;&nbsp;</li>
		<cfset templateNum = templateNum + 1>
	</cfloop>
	</ul>
	<br clear="both" />
</div>

<div class="row" id="step6">
	<label for="cfmcfc" class="step">Step 6: Which type of application file?</label>
	<input type="radio" name="cfmcfc" value="cfc" id="cfc" checked="checked" />
	<label for="cfc">Application.cfc</label> &nbsp;&nbsp;
	<input type="radio" name="cfmcfc" value="cfm" id="cfm" />
	<label for="cfm">Application.cfm</label>
</div>

<div class="row" id="step7">
	<label for="cfmcfc" class="step">Step 7: Check here to include reset CSS:</label>
	<input type="checkbox" name="reset" value="1" checked="checked" />
</div>

<div class="row" id="step8">
	<label for="ds" class="step">Step 8: Choose the datasource for your application:</label>
	<select name="dsource" id="dsource" style="padding:1px;">
		<option value="">None</option>
		<cfset datasources = session.adminAPI.getDatasources()>
		<cfloop index="x" from="1" to="#arrayLen(datasources)#">
		   <option value="#datasources[x].name#">#datasources[x].name#</option>
		</cfloop>
	</select>
</div>

<div class="row" id="step9">
	<label class="step">Step 9: Select tables for which to create CFCs &amp; CRUD pages:</label>
	<ul id="tables">
	</ul>
	<br clear="both" />
</div>

<div class="row row-last">
	<input type="submit" value="Generate Application" name="create" class="submit generate" />
	<h4>The following folders will be created by default:</h4>
	admin, cfcs, config, css, images, tags, templates
</div>
</cfform>
</div><br/>
<div class="logout center"><a href="#cgi.script_name#?logout" class="b">Logout of the Skeleton Site Creator</a></div><br/>
</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly="false">