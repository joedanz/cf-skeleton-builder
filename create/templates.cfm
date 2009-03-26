<!--- create templates directory --->
<cfdirectory action="create" directory="#ExpandPath('./tmp/templates/')#">

<!--- set doctype line --->
<cfswitch expression="#form.doctype#">
	<cfcase value="html4tr"><cfset doctype='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">#chr(10)#<html>#chr(10)#'>
	</cfcase>
	<cfcase value="html4st"><cfset doctype='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">#chr(10)#<html>#chr(10)#'>
	</cfcase>
	<cfcase value="xhtml1tr"><cfset doctype='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">#chr(10)#<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">#chr(10)#'>
	</cfcase>
	<cfcase value="xhtml1st"><cfset doctype='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">#chr(10)#<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">#chr(10)#'>
	</cfcase>
	<cfcase value="xhtml11dtd"><cfset doctype='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">#chr(10)#<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">#chr(10)#'>
	</cfcase>
</cfswitch>

<!--- reference any selected scripts --->
<cfset scripts = "">
<cfif isDefined("form.jquery")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.jqueryURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/js/jquery.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.jqueryui")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.jqueryUIURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/js/jqueryui.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.jqueryCorner")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.jqueryCornerURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/js/jquery.corner.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.prototype")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.prototypeURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/scripts/prototype.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.scriptaculous")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.scriptaculousURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/js/scriptaculous.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.mootools")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.mooToolsURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/scripts/mootools.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.dojo")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.dojoURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/scripts/dojo.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.swfobject")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.swfObjectURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/scripts/swfobject.js"></script>
'>
	</cfif>
</cfif>
<cfif isDefined("form.yui")>
	<cfif form.javascripts is 'linked'>
		<cfset scripts = scripts & '<script type="text/javascript" src="##request.yuiURL##"></script>
'>
	<cfelse>
		<cfset scripts = scripts & '<script type="text/javascript" src="##application.settings.mapping##/scripts/yui.js"></script>
'>
	</cfif>
</cfif>

<!--- read in header & footer templates --->
<cffile action="read" file="#ExpandPath('./templates/templates/')#main_header1.cfm" variable="head1">
<cffile action="read" file="#ExpandPath('./templates/templates/')#main_header2.cfm" variable="head2">
<cffile action="read" file="#ExpandPath('./templates/templates/')#main_header3.cfm" variable="head3">
<cffile action="read" file="#ExpandPath('./templates/templates/')#main_header4.cfm" variable="head4">
<cffile action="read" file="#ExpandPath('./templates/templates/')#main_footer1.cfm" variable="foot1">
<cffile action="read" file="#ExpandPath('./templates/templates/')#main_footer2.cfm" variable="foot2">

<!--- write out header --->
<cffile action="write" file="#ExpandPath('./tmp/templates/')#main_header.cfm" output="#head1##doctype##head2##scripts##head3#">

<!--- get template css --->
<cffile action="read" file="#ExpandPath('./skins/' & form.template & '/')#top.cfm" variable="top">
<cffile action="append" file="#ExpandPath('./tmp/templates/')#main_header.cfm" output="#top##head4#">
<cffile action="read" file="#ExpandPath('./skins/' & form.template & '/')#bottom.cfm" variable="bottom">

<!--- write out footer --->
<cffile action="write" file="#ExpandPath('./tmp/templates/')#main_footer.cfm" output="#foot1##bottom##foot2#">
