<%@ Page Title="Subscribe to newsletter" Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="WebSite.Inscription_Journal" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="server">
	<h1>Newsletter</h1>
	<p>An email is send to subscribe for news, new products and promotions.</p>
	<br />
	<p>You can unsubscribe at any time.</p>
	<p>&nbsp;</p>
	<asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validation" />
	<p><b>Email:</b><br />
		<asp:TextBox ID="txtEmail" runat="server" Width="250px"></asp:TextBox>
		<asp:RequiredFieldValidator ID="valReqEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email field is required">*</asp:RequiredFieldValidator>
		<asp:RegularExpressionValidator ID="valRegEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is invalid">*</asp:RegularExpressionValidator>
	</p>
	<p>
		<asp:RadioButtonList ID="lstChoice" runat="server">
			<asp:ListItem Selected="True" Value="true">Subscribe me to the newsletter</asp:ListItem>
			<asp:ListItem Value="false">Remove me from the newsletter</asp:ListItem>
		</asp:RadioButtonList>
	</p>
	<p>
		<asp:Button ID="cmdSave" runat="server" OnClick="cmdSave_Click" Text="Save" CssClass=button />
		<br />
	</p>
</asp:Content>
