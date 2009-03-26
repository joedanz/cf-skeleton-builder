<cfapplication name="Skeleton_Site_Creator2" sessionmanagement="true" clientmanagement="false" />

<cfsetting showdebugoutput="true">

<cfif isDefined("url.logout")>
	<cflogout />
</cfif>

<cfscript>
	request.jqueryURL 		 = "http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js";
	request.jqueryUIURL		 = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.5.3/jquery-ui.min.js";
	request.jqueryCornerURL  = "http://jqueryjs.googlecode.com/svn/trunk/plugins/corner/jquery.corner.js";
	request.prototypeURL 	 = "http://ajax.googleapis.com/ajax/libs/prototype/1.6.0.3/prototype.js";
	request.scriptaculousURL = "http://ajax.googleapis.com/ajax/libs/scriptaculous/1.8.2/scriptaculous.js";
	request.mooToolsURL		 = "http://ajax.googleapis.com/ajax/libs/mootools/1.2.1/mootools-yui-compressed.js";
	request.dojoURL			 = "http://ajax.googleapis.com/ajax/libs/dojo/1.2.3/dojo/dojo.xd.js";
	request.swfObjectURL	 = "http://ajax.googleapis.com/ajax/libs/swfobject/2.1/swfobject.js";
	request.yuiURL			 = "http://ajax.googleapis.com/ajax/libs/yui/2.7.0/build/yuiloader/yuiloader-min.js";
	request.templateList	 = "default,beige,round";
</cfscript>