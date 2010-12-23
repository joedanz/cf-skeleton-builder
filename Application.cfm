<cfapplication name="Skeleton_Site_Creator2" sessionmanagement="true" clientmanagement="false" />

<cfsetting showdebugoutput="true">

<cfif isDefined("url.logout")>
	<cflogout />
	<cfset session.loggedin = false>
</cfif>

<cfscript>
	request.jqueryURL 		 = "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js";
	request.jqueryUIURL		 = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.0/jquery-ui.min.js";
	request.jqueryCornerURL  = "https://github.com/malsup/corner/raw/master/jquery.corner.js?v2.09";
	request.prototypeURL 	 = "http://ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js";
	request.scriptaculousURL = "http://ajax.googleapis.com/ajax/libs/scriptaculous/1.8.3/scriptaculous.js";
	request.mooToolsURL		 = "http://ajax.googleapis.com/ajax/libs/mootools/1.2.4/mootools-yui-compressed.js";
	request.dojoURL			 = "http://ajax.googleapis.com/ajax/libs/dojo/1.4.1/dojo/dojo.xd.js";
	request.swfObjectURL	 = "http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js";
	request.yuiURL			 = "http://ajax.googleapis.com/ajax/libs/yui/2.8.0r4/build/yuiloader/yuiloader-min.js";
	request.extCore			 = "http://ajax.googleapis.com/ajax/libs/ext-core/3.1.0/ext-core.js";
	request.chromeFrame		 = "http://ajax.googleapis.com/ajax/libs/chrome-frame/1.0.2/CFInstall.min.js";
	request.templateList	 = "default,beige,round";
</cfscript>