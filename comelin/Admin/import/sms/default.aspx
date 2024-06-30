<%@ Page Title="Importation des données de SMS" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebSite.Admin.import.ImportSMS" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="appAdmin">
	    <h1>Importation des données de SMS</h1>
        <generic-importer title="Importation des produits via la liste de prix par magasin" url="/admin/api/import/sms/product-list-per-store" filename="liste prix par magasin 3">
            <template v-slot:options="importer" >
                
            </template>
        </generic-importer>
        <br/>
	    <br/>

	    Fichier: "Liste de prix avec coût par sous-département"<br/>
	    <asp:FileUpload ID="FileUploadProduct" runat="server" />
    &nbsp;<asp:Button ID="cmdImportProducts" runat="server" OnClick="cmdImportProducts_Click" Text="Importer" />
	    <br />
	    <br />
	    Fichier: &quot;Valeur d&#39;inventaire&quot;<br />
	    <asp:FileUpload ID="FileUploadInventory" runat="server" />
    &nbsp;<asp:Button ID="cmdImportInventory" runat="server" OnClick="cmdImportInventory_Click" Text="Importer" />
	    <br />
	    <br />
	    Fichier: &quot;Liste de prix par fournisseur&quot;<br />
	    <asp:FileUpload ID="FileUploadSupplier" runat="server" />
    &nbsp;<asp:Button ID="cmdImportSupplier" runat="server" OnClick="cmdImportSupplier_Click" Text="Importer" />
	
	</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
	<script src="/admin/js/import.js"></script>
    <script src="/admin/js/admin-vue.js"></script>
    <link href="/admin/css/import.min.css" rel="stylesheet" />
</asp:Content>