<cfsetting enablecfoutputonly=true>

<cfscript>
function isLoggedOn() {
	return structKeyExists(session, "loggedin");
}
request.udf.isLoggedOn = isLoggedOn;

/**
 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
 * Update by David Kearns to support '
 * SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
 *
 * @param str 	 The string to check. (Required)
 * @return Returns a boolean.
 * @author Jeff Guillaume (jeff@kazoomis.com)
 * @version 2, August 15, 2002
 */
function IsEmail(str) {
//supports new top level tlds
if (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$",str)) return TRUE;
	else return FALSE;
}
request.udf.isEmail = isEmail;

function isValidUsername(str) {
	if(reFindNoCase("[^a-z0-9]",str)) return false;
	return true;
}
request.udf.isValidUsername = isValidUsername;

function relativeTime(pastdate) {
   var delta = dateDiff("s", pastDate, now());

   if(delta < 60) {
    return "less than a minute ago";
   } else if(delta < 120) {
    return "about a minute ago";
   } else if(delta < (45*60)) {
    return round(delta/60) & " minutes ago";
   } else if(delta < (90*60)) {
    return "about an hour ago";
   } else if(delta < (24*60*60)) {
      return round(delta/3600) & " hours ago";
   } else if(delta < (48*60*60)) {
    return "1 day ago";
   } else if(delta < (7*24*60*60)) {
    return round(delta/86400) & " days ago";
   } else {
      return dateFormat(pastdate,"mmm d");
   }
}
request.udf.relativeTime = relativeTime;
</cfscript>

<cfsetting enablecfoutputonly=false>