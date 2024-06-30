<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportDupralSite.aspx.cs" Inherits="WebSite.Admin.import.ImportDupralSite" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<p>
		Trouvé les pages de produits</p>
	<p>
		Url de départ:
		<asp:TextBox ID="txtUrlStart" runat="server">http://menottesetpetitspieds.com/boutique</asp:TextBox>
&nbsp;<asp:Button ID="cmdFindPages" runat="server" OnClick="cmdFindPages_Click" Text="Trouver les pages" />
	</p>
</asp:Content>
