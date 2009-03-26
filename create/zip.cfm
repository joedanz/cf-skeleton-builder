<!---
	Purpose : Create zip file, output to browser, and delete working directory.
--->

<!--- create zip file --->
<cfzip file="#expandpath('./skeleton.zip')#" source="#ExpandPath('./tmp/')#">

<!--- delete working directory --->
<cfdirectory action="delete" directory="#ExpandPath('./tmp/')#" recurse="true">

<!--- output to browser --->
<cfheader name="content-disposition" value="attachment; filename=skeleton.zip">
<cfcontent file="#expandpath('./skeleton.zip')#" deletefile="yes" type="application/unknown">