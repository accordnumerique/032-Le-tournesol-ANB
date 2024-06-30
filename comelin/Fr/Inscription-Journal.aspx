<%@ Page Title="Inscription au Journal" Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="WebSite.Inscription_Journal" CodeBehind="Inscription-Journal.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="server">
	<h1>Le Bulletin d'information</h1>
	<p>Ce courriel est envoyé périodiquement aux abonné(e)s concernant les produits. Voyez toutes nos promotions et nouveautés.</p>
	<p><br />
	</p>
	<p>Vous pouvez vous inscrire ou vous désinscrire en tout temps.</p>
	<p>&nbsp;</p>
	
	<p>En créant un compte gratuit, il vous sera possible de créer votre liste de Souhaits ou votre liste Coups de coeur. Vous pourrez par la suite partager cette liste avec vos proches, qui pourront faire leurs achats à partir de cette liste, en boutique ou en ligne.</p>
	<p>&nbsp;</p>
	<asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validation" />
	<p><b>Courriel:</b><br />
		<asp:TextBox ID="txtEmail" runat="server" Width="250px"></asp:TextBox>
		<asp:RequiredFieldValidator ID="valReqEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Le champs courriel est requis">*</asp:RequiredFieldValidator>
		<asp:RegularExpressionValidator ID="valRegEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Le courriel n'est pas valide">*</asp:RegularExpressionValidator>
	</p>
	<p>
		<asp:RadioButtonList ID="lstChoice" runat="server">
			<asp:ListItem Selected="True" Value="true">S&#39;inscrire au Journal</asp:ListItem>
			<asp:ListItem Value="false">Ne pas être inscrit au Journal</asp:ListItem>
		</asp:RadioButtonList>
	</p>
	<p>
		<asp:Button ID="cmdSave" runat="server" OnClick="cmdSave_Click" Text="Enregistrer" CssClass="btn btn-primary" />
		<br />
	</p>
</asp:Content>
