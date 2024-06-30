<%@ Page Title="Import Open Cart" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportOpenCart.aspx.cs" Inherits="WebSite.Admin.onetime.ImportOpenCart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Import OpenCart / VotreSite.ca</h1>
	<p>
		<br />
		MySQL Database Name: 
		<asp:TextBox ID="txtDbName" runat="server" Text=""></asp:TextBox><br />
		MySQL Username: 
		<asp:TextBox ID="txtDbUsername" runat="server" Text="root"></asp:TextBox><br/>
		Password: 
		<asp:TextBox ID="txtDebPassword" runat="server" TextMode="Password" Text=""></asp:TextBox> <asp:Button ID="cmdTestConnection" runat="server" OnClick="cmdTestConnection_Click" Text="TestConnection" /><br/>
		
	</p>
	<hr />
		<h2>Importation des produits</h2>
		<p>Les images doivent être sur le serveur de Comelin dans le répertoire "catalog"</p>
		<asp:Button ID="cmdImportProduct" runat="server" Text="Produits" OnClick="cmdImportProduct_Click" />
</asp:Content>
