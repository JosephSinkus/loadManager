Create An HTML Form Like Below
<cfhttp
url="http://development.b-linkt.com/RestApi/"
method="post"
result="httpResponse">
	<cfhttpparam
	type="formField"
	name="authcode"
	value="ece7aef9eb11470c03d176f0835b97cf"
	/>
</cfhttp>

<cfset mydoc = XmlParse(httpResponse.Filecontent)> 
<cfset xmlvalue = StructNew()>
<cfset xmlvalue.Email = mydoc.User.Email['XmlText']>
<cfset xmlvalue.Phone = mydoc.User.Phone['XmlText']>
<cfset xmlvalue.Mobile = mydoc.User.Mobile['XmlText']>
<cfset xmlvalue.Address = mydoc.User.Address['XmlText']>
<cfset xmlvalue.Address2 = mydoc.User.Address2['XmlText']>
<cfset xmlvalue.City = mydoc.User.City['XmlText']>
<cfset xmlvalue.ZipCode = mydoc.User.ZipCode['XmlText']>
<cfset xmlvalue.State = mydoc.User.State['XmlText']>
<cfset xmlvalue.AuthCode = mydoc.User.AuthCode['XmlText']>
<cfoutput>
	HTTP Request Method To Be Used : POST
	<br/>
	After submiting the form you recieve response like this : 
	<br/>
	&lt;User&gt;&lt;Email&gt;#xmlvalue.Email#&lt;/Email&gt;&lt;Phone&gt;#xmlvalue.Phone#&lt;/Phone&gt;&lt;Mobile&gt;#xmlvalue.Mobile#&lt;/Mobile&gt;&lt;Address&gt;#xmlvalue.Address#&lt;/Address&gt;&lt;Address2&gt;#xmlvalue.Address2#&lt;/Address2&gt;&lt;City&gt;#xmlvalue.City#&lt;/City&gt;&lt;ZipCode&gt;#xmlvalue.ZipCode#&lt;/ZipCode&gt;&lt;State&gt;#xmlvalue.State#&lt;/State&gt;&lt;AuthCode&gt;#xmlvalue.AuthCode#&lt;/AuthCode&gt;&lt;/User&gt;
	<br/>
	You can use this xml to your website to update your data.
</cfoutput>










