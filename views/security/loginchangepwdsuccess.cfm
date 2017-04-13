<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  border="1">
	<tr>
		<td width="100%" height="97%" align="center" valign="middle">
			<table border="0" cellspacing="0" cellpadding="5" class="lightitemborder">
				<tr>
					<td class="failurealert">
						Your password has been successfully changed.
					</td>
				</tr>
				<tr>
					<td align="right"><input name="btnContinue" type="button" value="Continue" class="button" onclick="document.location.href='index.cfm?event=SearchClient&#Session.URLToken#'"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>