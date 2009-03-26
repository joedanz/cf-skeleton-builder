<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# &raquo; Login">

<cfoutput>
<div id="login">
	
<cfif isDefined("error")>
<div id="error"><img src="./images/alert.gif" height="16" width="16" border="0" alt="Alert!" align="absmiddle"> Error! #error#</div>
</cfif>	
	
<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="loginform">

<cfparam name="form.username" default="">
<label for="username" class="s14 b" style="display:block;">Login:</label>
<input type="text" id="username" name="username" value="#form.username#" size="20" style="width:180px;border:2px solid ##999;padding:4px;margin-bottom:5px;" onfocus="this.style.border='2px solid ##f00';this.style.background='##d9ecff';" onblur="this.style.border='2px solid ##999';this.style.background='##fff';" /><br />
<label for="pass" class="s14 b" style="display:block;">Password:</label>
<input type="password" id="pass" name="password" size="20" style="width:180px;border:2px solid ##999;padding:4px;margin-bottom:10px;" onfocus="this.style.border='2px solid ##f00';this.style.background='##d9ecff';" onblur="this.style.border='2px solid ##999';this.style.background='##fff';" /><br />
<input type="submit" value="Login" style="width:125px;padding:3px;font-family:Trebuchet MS, Verdana,Arial;" class="s14 b">
<input type="hidden" name="logon" value="true">
</form>
</div>	

<script type="text/javascript">
	document.forms[0].username.focus();
</script>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">