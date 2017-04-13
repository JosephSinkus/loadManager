<cfoutput> 
	<style type="text/css">
		.importLoads .importLoadsheader, .exportLoads .exportLoadsheader{
			background: url("images/footer-bg.gif") repeat-x scroll left top rgba(0, 0, 0, 0);
			font-size: 11px;
			font-weight: bold;
			height: 24px;
			padding-left:10px;
		}
		.importLoads td, .exportLoads td{color: ##000000;font-size: 9px;font-weight: bold;padding: 0 2px 0 0;text-align: right;}
		.leftlabel{width:475px;}
		.rightlabel{width:575px;}
		.rightfield{width:210px;}	
		input.sm-input {background: none repeat scroll 0 0 ##ffffff;border: 1px solid ##b3b3b3; float: left; font-size: 11px; margin-top: 5px; margin-bottom: 5px; padding: 2px 2px 0; width: 75px;}
		input.ac_input {
			background: none repeat scroll 0 0 ##ffffff;
			border: 1px solid ##b3b3b3;
			float: left;
			font-size: 11px;
			margin-top: 5px;
			margin-bottom: 5px;
			padding: 2px 2px 0;
			width: 190px;
		}		
	</style>
	<script type="text/javascript">
		togglechange(1);
	</script>
	<cfif StructKeyExists(request, "content")>
		#request.content#
	</cfif>
</cfoutput>