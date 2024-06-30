<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportShopify.aspx.cs" Inherits="WebSite.Admin.import.ImportShopify" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
	<div id="divUpload">
		Fichier CSV de Shopify (Exportation des produits): 
		<asp:FileUpload ID="fileUploadProduct" runat="server" /> &nbsp;
        <div>
            <h2>Options</h2>
            <asp:CheckBox ID="chkImportUnpublished" runat="server" Text="Importer produits non publiés" />
        </div>
        <div>
            <h2>Si le produit existe dans la base de donnée de Comelin (mise à jour)</h2>
            <asp:CheckBox ID="chkUpdatePhotos" runat="server" Text="Ajouter les photos" Checked="true"  />
        </div>
		<div>
			<h2>Si le produit n'existe pas dans la base de donnée de Comelin</h2>
            <asp:CheckBox ID="chkCreateProduct" runat="server" Text="Créer le produit" Checked="true"  /><br/>
            <asp:CheckBox ID="chkAddPhotos" runat="server" Text="Ajouter les photos" Checked="true"  />
        </div>
        
        
        <asp:Button ID="cmdUpload" runat="server" Text="Importation" OnClick="cmdUpload_Click"  />
	</div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
</asp:Content>
