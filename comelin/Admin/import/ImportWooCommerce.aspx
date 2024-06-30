<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportWooCommerce.aspx.cs" Inherits="WebSite.Admin.onetime.ImportWooCommerce" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<p>
		<br />
		MySQL Base de données: 
		<asp:TextBox ID="txtDbName" runat="server" Text=""></asp:TextBox><br />
		MySQL Nom d'utilisateur: 
		<asp:TextBox ID="txtDbUsername" runat="server" Text="root"></asp:TextBox><br/>
		MySQL Mot de passe: 
		<asp:TextBox ID="txtDebPassword" runat="server" TextMode="Password"></asp:TextBox> <asp:Button ID="cmdTestConnection" runat="server" OnClick="cmdTestConnection_Click" Text="TestConnection" /><br/>
		
	</p>
	<hr />
	Prefix des tables:
	<asp:TextBox ID="txtWordPressPrefix" runat="server" Text="wp_"></asp:TextBox>
	<br />
Copier manuellement les images sur ce serveur (habituellement dans /wp-content/upload)<br/>
    <h2>Importation des produits</h2>
		<asp:Button ID="cmdImportProduct" runat="server" Text="Produits" OnClick="cmdImportProduct_Click" />
	&nbsp;<br />
	<br />
    <hr />
		<h2>Importation des clients</h2>
		<asp:Button ID="cmdImportCustomer" runat="server" Text="Clients" OnClick="cmdImportCustomer_Click" />
</asp:Content>
