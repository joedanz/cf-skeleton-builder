<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="An Error Has Occurred">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="alert">An Error Has Occurred</h2>
				</div>
				<div class="content">
					<div class="wrapper">

						<cfif application.settings.showError>
							#error.diagnostics#
							<hr size="1" />
						</cfif>

						<h5><em>Please try again or contact your administrator.</em></h5>

				 	</div>
				</div>

		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="#application.settings.mapping#/footer.cfm">
		</div>
	</div>

	<!--- right column --->
	<div class="right">

	</div>

</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">