<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportGiftCard.aspx.cs" Inherits="WebSite.Admin.ImportGiftCard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Importer les cartes cadeaux</h1>
	<p>Une carte cadeau par ligne</p>
	<p>- 1ère colonne: Balance de la carte cadeau</p>
	<p>- 2e colonne: le # de la carte cadeaux</p>
	<p>- 3e colonne (optionnel) le nom du client)</p>
	<p>
		<asp:CheckBox ID="chkDelete" runat="server" Text="Effacer les cartes précédentes" />
	</p>
	<p>
		<asp:CheckBox ID="chkNegative" runat="server" Text="Quantité négative" ToolTip="Si cocher, les valeurs des cartes cadeaux seront négatives au lieu de positive" />
	</p>
	<p>
		<asp:FileUpload ID="FileUpload1" runat="server" />
	</p>
	<p>

		<asp:Button ID="cmdImport" runat="server" onclick="cmdImport_Click" Text="Importer" />
	</p>

</asp:Content>
