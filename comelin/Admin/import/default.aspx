<%@ Page Title="Importations" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Importations de données</h1>
	
	
	<div id="page-import">
		
	
	<h2>Import générique</h2>
	<a href="ImportProducts.aspx">Produits</a>
	<a href="ImportCustomers.aspx">Clients</a>
	<a href="ImportCategory.aspx">Catégorie / Marque / Fournisseurs</a>
	<a href="ImportGiftCard.aspx">Carte cadeau</a>
	<a href="ImportHistory.aspx">Historique des transactions</a>
    <a href="ImportCreditNotes.aspx">Notes de crédit</a>
	<a href="ImportProductWithSupplier.aspx">Produits avec fournisseur</a>
	

	<h2>Logiciel Comptable / POS / Boutique en ligne</h2><a href="ImportSquare.aspx">Square</a>
	<a href="ImportShopify.aspx">Shopify</a>
	<a href="ImportWooCommerce.aspx">WooCommerce</a>
	<a href="ImportRetailPoint.aspx">RetailPoint</a>
    <a href="ImportBiatriz.aspx">Biatriz</a>
	<a href="ImportSage.aspx">Sage</a>
    <a href="ImportSnipCart.aspx">Snipcart</a>
	<a href="ImportOpenCart.aspx">OpenCart / Votresite.ca</a>
	<a href="ImportLPos.aspx">L-POS</a>
	<a href="ImportAvantage.aspx">Avantage</a>
	<a href="SMS/">SMS</a>
	<a href="ImportSupplierBest.aspx">BEST</a>
	<a href="ImportProductGoDaddy.aspx">GoDaddy</a>
	<a href="ImportFacebook.aspx">Facebook</a>
	<a href="ImportDupralSite.aspx">Dupral</a>
	<a href="ImportDatabaseCubeCart.aspx">CubeCart</a>
	
	<a href="ImportProductMediaWeb.aspx">MediaWeb</a>
	<a href="ImportProductFromComelinViaJson.aspx">D'un export Comelin (JSON)</a>
	</div>
	
	<style>
		#page-import > a {display: block; line-height: 2em}
	</style>

</asp:Content>
