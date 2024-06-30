<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebSite.Admin.DefaultAdminPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h2>Rapports</h2>
	<div id="links">
		<a class=tool href="Punchs.aspx"><img src="images/punch.png" /><span>Horodateur</span></a>
		<a class=tool href="ReportCustomers.aspx"><img src="images/groups.png" /><span>Clients<br/>et vente</span></a>
		<a class=tool href="report/CustomersSummary.aspx">
            <div class="badge new">Nouveau</div>
            <img src="images/groups.png" /><span>Sommaires des nouveau clients</span>
        </a>
		<a class=tool href="Birthday.aspx"><img src="images/birthday.png" /><span>Anniversaire<br/>des clients</span></a>
		<a class=tool href="ProductsReceivedFromSupplier.aspx"><img src="images/order-supplier.png" /><span><br/>Achats</span></a>
        <a class=tool href="report/NotificationsByCustomer.aspx">
            <img src="images/mail_notification.png" /><span><br/>Clients avec notifications par courriel</span>
        </a>
		<br style="clear:both" />
        <a class=tool href="report/Sales.aspx">
            <img src="images/report-list.png" /><span><br/>Achat / Inventaire / Ventes</span>
        </a>
        <a class=tool href="report/InventoryAdjustement.aspx" style="display: none">
            <div class="badge new">Nouveau</div>
            <img src="images/report-list.png" /><span><br/>Ajustement d'inventaire</span>
        </a>
		<a class=tool href="SalesList.aspx"><img src="images/report-list.png" /><span><br/>Ventes & Réservations</span></a>
		<a class=tool href="SalesDetails.aspx"><img src="images/report-list.png" /><span><br/>Details des ventes</span></a>
		<a class=tool href="SalesByBrandSummary.aspx"><img src="images/report-list.png" /><span><br/>Sommaire des ventes par marques</span></a>
        <a class=tool href="SalesByCategorySummary.aspx"><img src="images/report-list.png" /><span><br/>Sommaire des ventes par catégorie</span></a>
		<a class=tool href="SalesByCategoryDetailed.aspx"><img src="images/report-list.png" /><span><br/>Sommaire des ventes par produit</span></a>
        <a class=tool href="SalesStats.aspx"><img src="images/salesreport.png" /><span>Graphique des<br/>ventes</span></a>
		<a class=tool href="ReportQty.aspx"><img src="images/attribut.png" /><span>Ventes par<br/>champs personnalisés</span></a>
		<a class=tool href="ReportByTime.aspx"><img src="images/salesreport.png" /><span>Ventes par<br/>heure du jour</span></a>
		<br style="clear:both" />
        <a class=tool href="report/inventory.aspx"><img src="images/report-list.png" /><span>Inventaire</span></a>
		<a class=tool href="CartesCadeaux.aspx"><img src="images/giftcard.png" /><span>Cartes<br/>cadeaux</span></a>
		<a class=tool href="CreditNotes.aspx"><img src="images/credit.png" /><span>Notes<br/>de crédit</span></a>
		<a class=tool href="SecurityDeposits.aspx"><img src="images/securitydeposit.png" /><span>Dépôts de<br/>sécurité</span></a>
		<a class=tool href="Brands.aspx"><img src="images/report-list.png" /><span>Liste des<br/>marques</span></a>
		<a class=tool href="Referrers.aspx"><img src="images/references.png" /><span>Références<br/>partenaires</span></a>
		<a class=tool href="Referral.aspx"><img src="images/referral.png" /><span>Sources</span></a>
		<a class=tool href="SalesByPromotions.aspx"><img src="images/report-promotion.png" /><span>Promotion</span></a>
		<br style="clear:both" />
		<a class=tool href="Report.aspx?type=Daily"><img src="images/report-daily.png" /><span>Rapport quotidien</span></a>
		<a class=tool href="Report.aspx?type=Weekly"><img src="images/report-weekly.png" /><span>Rapport hebdomadaire</span></a>
		<a class=tool href="Report.aspx?type=Monthly"><img src="images/report-monthly.png" /><span>Rapport mensuel</span></a>
		<a class=tool href="Report.aspx?type=Yearly"><img src="images/report-yearly.png" /><span>Rapport Annuel</span></a>
		<a class=tool href="Report.aspx?type=Custom"><img src="images/report-custom.png" /><span>Rapport Configurable</span></a>
		<a class=tool href="PaymentMode.aspx"><img src="images/report-list.png" /><span>Rapport par mode de paiement</span></a>
	
		<a class=tool runat="server" Visible="False" id="lnkReportPerformance" href="/Admin/report/PerformanceWeb.aspx"><img src="images/performance.png" /><span>Rapport de performance</span></a>
        <a class=tool href="report/Employees.aspx"><i class="fa fa-user-circle" aria-hidden="true"></i> <span>Employés</span></a>
		<div class="web">
			<h2>Site Web <img data-kb="comelin/panneau-administration/site-web-personnalisation" class="help-page" /></h2>
			<a class=tool href="HomePageConfigure.aspx"><img src="images/MessageHomePage.png" /><span>Page<br />d'accueil</span></a>
			<a class=tool href="GenericPageEditor.aspx"><img src="images/generic-page.png" /><span>Pages<br />d'informations</span></a>
			<a class=tool href="config/Text.aspx"><i class="fa fa-font"></i><span>Textes</span></a>
			<a runat="server" Visible="False" id="lnkPortfolio" class=tool href="Portfolio.aspx"><img src="images/portfolio.png" /><span>Portfolio & Projets</span></a>
			<a class=tool href="RedirectManager.aspx"><img src="images/redirect.png" /><span>Redirection</span></a>
		</div>
	
		<h2>Outils</h2>
		<a class=tool href="AccountingIntegration.aspx"><img src="images/accounting.png" /><span>Comptabilité</span></a>
		<a class=tool href="QB.aspx" runat="server" id="lnkQB"><img src="images/quickbook.png" /><span>Quickbooks Online</span></a>
		<a class=tool href="Acomba.aspx" runat="server" id="lnkAcomba"><img src="images/acomba.png" /><span>Acomba</span></a>
		<a class=tool href="Sage.aspx" runat="server" id="lnkSage"><img src="images/sage.png" /><span>Sage 50</span></a>
        <a class=tool href="Avantage.aspx" runat="server" id="lblAvantage"><i class="fa fa-book" aria-hidden="true"></i><span>Avantage</span></a>
		<a class=tool href="Communication.aspx"><img src="images/email.png" /><span>Communications automatisées</span></a>
		<a class=tool href="Restore.aspx"><img src="images/undelete.png" /><span>Restauration</span></a>
		<a class=tool href="MailChimp.aspx"><img src="images/mailchimp.png" /><span>Infolettre Mailchimp</span></a>
        <a class=tool href="CustomerUnsubscribeMass.aspx"><img src="images/newsletter.png" /><span>Désabonnement à l'infolettre</span></a>
        
		<a class=tool href="Security.aspx"><img src="images/security.png" /><span>Sécurité</span></a>
		<a class=tool href="reservations.aspx"><img src="images/reservations.png" /><span>Réservations</span></a>
		<a class=tool href="Contest.aspx"><img src="images/contest.png" /><span>Concours</span></a>
	
		<h2>Maintenance</h2>
		<a class=tool href="DuplicateProduct.aspx"><img src="images/cleanup-product.png" /><span>Doublons produits</span></a>
		<a class=tool href="ReportProductNotSold.aspx"><img src="images/report-product-not-sold.png" /><span>Produits non vendus</span></a>
		<a class=tool href="GiftReinitialize.aspx"><img src="images/giftcard.png" /><span>Réinitialiser cartes cadeaux</span></a>
		<a class=tool href="POSDelete.aspx"><i class="fa fa-trash"></i><span>Effacer des points de ventes/ordinateur</span></a>
		

		<h2>Administration</h2>
		<a class=tool href="Settings.aspx"><img src="images/settingscomelin.png" /><span>Configurations Comelin</span></a>
		<a class="tool web" href="SettingsWeb.aspx"><img src="images/settingsweb.png" /><span>Configurations Web</span></a>
		<a class=tool href="config/Magasin.aspx"><img src="images/store.png" /><span>Magasins & Factures</span></a>
		<a class=tool href="InventoryRecount.aspx"><img src="images/inventoryrecount.png" /><span>Recompter l'inventaire</span></a>
	
		<div id="divInternal" runat="server" Visible="False">
			<h2>Interne</h2>
			<a class=tool href="SettingsInternal.aspx"><img src="images/settings.png" /><span>Configurations</span></a>
			<a class=tool href="Admin.aspx"><img src="images/admin.png" /><span>Config internes</span></a>
			<a class=tool href="Patch.aspx"><img src="images/patch.png" /><span>Mise à jour</span></a>
			
			<a class=tool href="import/"><i class="fa fa-file-text-o"></i> <span>Importations</span></a>
			<a class=tool href="onetime/RemplacerTitreProduit.aspx"><i class="fa fa-exchange"></i> <span>Remplacement de texte dans titre des produits</span></a>
		</div>
	
	</div>


	<h2>En ligne présentement</h2>
    <div id="app">
        <currently-online></currently-online>
    </div>
	
    </asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
        <script src="/Admin/js/components/CurrentlyOnline.js"></script>
	<script type="text/javascript">
        var vm = new Vue({
            el: '#app'
        });
    </script>
    </asp:Content>
