<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SettingsInternal.aspx.cs" Inherits="WebSite.Admin.InternalSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="images/settings.png" /> Configuration Interne</h1>
	<div class="text-indent"><p>Grouper les produits: <asp:DropDownList runat="server" ID=lstGroupProducts >
		<asp:ListItem Value="1">Titre</asp:ListItem>
		<asp:ListItem Value="3">Code Produit</asp:ListItem>
		<asp:ListItem Value="9">Ne pas grouper</asp:ListItem>
		</asp:DropDownList>
		<asp:CheckBox ID="chkGroupInactiveProduct" runat="server" Text="Regrouper les produits inactifs" />
		<br /></p>
	</div>
    <asp:CheckBox ID="chkPrixAvecTaxes" runat="server" Text="Prix affiché inclue les taxes"  />
	<br />
	<br />
	<br />
	<asp:CheckBox ID="chkEnableExpirationPerStore" runat="server" Text="Date d'expiration par magasin"  />
	<br />
	<br />
	Module de produits recyclés. # catégorie:
	<asp:TextBox ID="txtEnableRecycleProductCategory" runat="server" Width="52px"></asp:TextBox>
	<br />
&nbsp;<asp:CheckBox ID="chkModulePortfolio" runat="server" Text="Module Portfolio/Projects" />
	<br />
	<div class="indent">
	<asp:CheckBox ID="chkModulePortfolioCanCreated" runat="server" Text="Peut créer plusieurs portfolio" />
		</div>
	<br />

	<br />
	<h2>MySql Integration</h2>
	Database name: <asp:TextBox ID="txtMySqlDatabase" runat="server"></asp:TextBox><br/>
	Username: <asp:TextBox ID="txtMySqlUsername" runat="server"></asp:TextBox><br/>
	Password: <asp:TextBox ID="txtMySqlPassword" runat="server"></asp:TextBox><br/>
	<br />

	<asp:Button ID="cmdSave" runat="server" OnClick="cmdSave_Click" Text="Sauvegarder" />
	<br />
	
	<br />
	<br />
</asp:Content>
