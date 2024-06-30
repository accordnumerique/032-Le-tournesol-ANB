<%@ Page Title="Admin" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="WebSite.AdminGeneral" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="images/admin.png" />Configurations Interne</h1>
	<div>
		<asp:Button ID="cmdPosUpdate" runat="server" OnClick="cmdPosUpdate_Click" Text="Mise à jour disponible" 
			style="margin-bottom: 0" />
		&nbsp;Alerter les POS connecter qu&#39;une mise à jour est disponible<br />
        <br />
        <a  href="/api/pad/barcode12" target="_blank">Code à barres manquant 0 au début 11 → 12</a> Ajouter un 0 au code à barre avec 11 chiffres seulement.
        <br />
		<a  href="/api/pad/barcode11" target="_blank">Code à barres manquant 0 au début 10 → 11</a> Ajouter un 0 au code à barre avec 10 chiffres seulement.
        <br />
        <a  href="/admin/api/product/barcode/5zero-to-variable-price" target="_blank">Code à barres remplacer les 5 derniers '0' par un étoile (prix variable)</a>
		<br/>
        <br/>
		<asp:Button runat="server" id="cmdSetDatabaseReset" Text="Forcer les clients à re-téléchargé la base de donnée" OnClick="cmdSetDatabaseReset_Click"/><br/><br>
		<br/>
		<asp:Button ID="cmdRequestError" runat="server" OnClick="cmdRequestError_Click" Text="Fichier d'erreurs de POS" />
		&nbsp;Demander à tout les POS connecter d&#39;envoyer leur fichier d&#39;erreurs.<br />
		<br />
		<asp:Button ID="cmdInProcess" runat="server" OnClick="cmdInProcess_Click" Text="Quantités en commandes" />
		&nbsp;Recalculer tout les quantités en commande et réservation à partir de la liste de reservation.<br />
		<br />
		<asp:Button ID="cmdRecalculateInTransfer" runat="server" onclick="cmdRecalculateInTransfer_Click" Text="Quantité en transfère" />
&nbsp;Recalculer tout les quantités en transfère à partir des demandes de transferts et des réponses<br />
		<br />
		<asp:Button ID="cmdRecalculateCreditNote" runat="server" onclick="cmdRecalculateCreditNote_Click" Text="Note de crédit" />
		&nbsp;Recalculer les notes de crédit des clients<br />
		<br />
		<asp:Button ID="cmdProductCustomAttributCleanup" runat="server" OnClick="cmdProductCustomAttributCleanup_Click" Text="Produit - Champs personnalisés" />
&nbsp;Modifier les produits pour effacé les valeurs des champs personnalisés effacés.<br />
		<br />
		<asp:Button ID="cmdTakeInventoryFromLinkedProduct" runat="server" OnClick="cmdTakeInventoryFromLinkedProduct_Click" Text="Prendre Inventaire produits jumeler" />
&nbsp;Regarder les produits avec inventaire négative et prendre l&#39;inventaire d&#39;un produit jumeler (si possible)<br />
		<br />
		<a href="Emails.ashx">Newsletter</a>
&nbsp;Télécharger la liste des clientes qui sont abonner à la newsletter.<br />
		<br />
		<asp:CheckBox ID="chkSimuateServerDown" runat="server" AutoPostBack="True" oncheckedchanged="chkSimuateServerDown_CheckedChanged" 
			Text="Simuler le serveur en panne" />
		<br />
		<br />
			<asp:Button ID="cmdCheckSSL" runat="server" Text="Vérification du certificat SSL" OnClick="cmdCheckSSL_Click" />
		<br />
		<br />
		<asp:Button ID="cmdReloadSettings" runat="server" onclick="cmdReloadSettings_Click" 
			Text="Rechargement des configurations" />
		&nbsp;Si une confirmation est change manuellement dans la base de donnée.<br />
		<br />
		Catégorie à mettre visible en ligne
		<asp:TextBox ID="txtCategoryToSetVisibleOnline" runat="server" Width="63px"></asp:TextBox>
&nbsp;<asp:Button ID="cmdSetVisible" runat="server" OnClick="cmdSetVisible_Click" Text="Mettre visible" />
    <br />
			<br />
		Catégories enlever changer personnalisés
		<asp:TextBox ID="txtCategoryRemoveAttrib" runat="server" Width="63px"></asp:TextBox>
&nbsp;<asp:Button ID="cmdCategoryRemoveAttrib" runat="server" Text="Enlever champs personnalisé" OnClick="cmdCategoryRemoveAttrib_Click" />
    	<br />
		<br />
		Panier non complété depuis moins de
		<asp:TextBox ID="txtAbandonCartNbDays" runat="server" Width="83px"></asp:TextBox>
&nbsp;jours.
		<asp:Button ID="cmdAbandonCart" runat="server" OnClick="cmdAbandonCart_Click" Text="Envoyer des courriels " />
    <br /><br /><br />
		
		
		<h1>Corrections</h1>
        <p>
		<asp:Button runat="server" id="cmdStickerPriceWithNoRebate" Text="Étiquettes: mettre les prix SANS les rabais" OnClick="cmdStickerPriceWithNoRebate_Click"/></p>
		<asp:Button runat="server" id="cmdFlipAddressAndNote" Text="Marque (Address et note flip)" OnClick="cmdFlipAddressAndNote_Click"/><br/><br>
		
		<asp:Button runat="server" id="cmdDeleteAtribLittleUsed" Text="Effacer les attributs peu utilisé (2)" OnClick="cmdDeleteAttribLittleUsed"/><br/><br>
		
		

		<asp:Button runat="server" ID="cmdSetAllAttribNotAssignedToNewProduct" Text="Mettre tous les champs personnalisés non assignable aux nouveaux produits" OnClick="cmdSetAllAttribNotAssignedToNewProduct_Click"/>
		<br />
		<br/>
		<asp:Button ID="cmdProductCleanupInvalidData" runat="server" OnClick="cmdProductCleanupInvalidData_Click" Text="Products cleanup inventory invalid data" />
		<br />
		<br />
		<asp:Button ID="cmdDeleteOldMessage" runat="server" OnClick="cmdDeleteOldMessage_Click" Text="Effacer les vieux messages" />
		<br />
		<br />
		<asp:Button ID="cmdRecalculateInventorySinceLastInventory" runat="server" Text="Recalculate inventory since last inventory" OnClick="cmdRecalculateInventorySinceLastInventory_Click" />

		&nbsp;Will update product inventory<br />
		<br />

		<asp:Button ID="cmdWishListCleanup" runat="server" OnClick="cmdWishListCleanup_Click" Text="Nettoyer les listes cadeaux" />
    Enlever les produits non existants ou les produits qui sont dans la liste depuis plus d&#39;un an.<br />
		<br />


	
		<asp:Button ID="cmdDeleteCustomer" runat="server" OnClick="cmdDeleteCustomer_Click" Text="Effacer client vide" />
		&nbsp;Effacer les clients qui n&#39;ont pas de numéro de téléphone de email et de vente.<br />
		<br />
		<asp:Button ID="cmdRemoveProductCodeFromTitle" runat="server" OnClick="cmdRemoveProductCodeFromTitle_Click" 
			Text="Nettoyer titre du code de produit" />
		&nbsp;Modifier les titres de produit pour ne PAS inclure le code du produit.<br />
		<br />
		<asp:Button ID="cmdRemoveManufacturerFromTitle" runat="server" Text="Nettoyer titre du fabricant" 
			onclick="cmdRemoveManufacturerFromTitle_Click" />
			<br />
		<asp:Button ID="chkNormalizedProductTitleCapitalization" runat="server" Text="Normaliser les titres de produits (majuscule)" OnClick="chkNormalizedProductTitleCapitalization_Click" 
		/>
	&nbsp;Modifier les titres de produit pour ne PAS inclure le fabricant produit.<br />
		<br />
		<asp:Button ID="cmdNormalizePhone" runat="server" onclick="cmdNormalizePhone_Click" Text="Normaliser Numéro de téléphone" />
		&nbsp;Mettre tout les numéro de téléphone dans une format specific<br />
    <br />
		<asp:Button ID="cmdSiteMap" runat="server" OnClick="cmdSiteMap_Click" Text="Re-généré le site map" />
		<br />
			<asp:Button ID="cmdError" runat="server" OnClick="cmdError_Click" Text="Générer une erreur" />
		&nbsp;Générer une erreur web (test des logs et rapport d&#39;erreur).<br />
		<br />
		<asp:Button ID="cmdSetDefaultCategory" runat="server" Text="Catégorie par défaut" 
			OnClick="cmdSetDefaultCategory_Click" />
		&nbsp;Assigner une catégorie par défaut si aucune ou non existante.<br />
		<br />
		<asp:Button ID="cmdDeleteExpiredPromotion" runat="server" OnClick="cmdDeleteExpiredPromotion_Click" Text="Effacer Promotion Expirer" />
		<br />
		<br />
		<asp:Button ID="cmdDeleteProductDoubleProductcode" runat="server" OnClick="cmdDeleteProductDoubleProductcode_Click" Text="Effacer produit en double (code de produit)" />
		<br />
		<br />
		<asp:Button ID="cmdPunchOut" runat="server" OnClick="cmdPunchOut_Click" Text="Punch out everyone" />
		<br />
		</div>
</asp:Content>
