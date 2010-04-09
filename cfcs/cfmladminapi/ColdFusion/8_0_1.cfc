<!--- $Id: 8_0_1.cfc 12 2009-12-12 17:07:55Z dcepler $ --->
<!---
	Copyright 2009 David C. Epler - http://www.dcepler.net

	This file is part of of the CFML Admin API.

	The CFML Admin API is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	The CFML Admin API is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with the CFML Admin API.  If not, see <http://www.gnu.org/licenses/>.
--->
<cfcomponent displayname="CFMLAdmin API - Adobe ColdFusion 8.0.1" output="false" hint="CFMLAdmin API Layer for Adobe ColdFusion 8.0.1" extends="base">

	<cffunction name="init" access="public" returntype="any" output="false" hint="">
		<cfargument name="password" type="string" required="true" hint="administrator password" />
		<cfargument name="username" type="string" default="" hint="administrator username (<strong>ColdFusion 8+ only</strong>)" />
		<cfargument name="adminApiPath" type="string" default="" hint="override default Admin API path (<strong>ColdFusion & Open BlueDragon only</strong>)" />

		<cfset variables.adminPassword = arguments.password />
		<cfset variables.adminUsername = arguments.username />
		<cfset variables.adminApiPath = arguments.adminApiPath />
		<cfreturn this />
	</cffunction>


<!--- Security --->
	<cffunction name="login" access="public" returntype="boolean" output="false" hint="">

		<cfif Len(variables.adminUsername)>
			<cfreturn createObject("component", "#variables.adminApiPath#.administrator").login(variables.adminPassword, variables.adminUsername) />
		<cfelse>
			<cfreturn createObject("component", "#variables.adminApiPath#.administrator").login(variables.adminPassword) />
		</cfif>
	</cffunction>

</cfcomponent>