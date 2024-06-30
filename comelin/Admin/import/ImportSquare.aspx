<%@ Page Title="Importation Square" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportSquare.aspx.cs" Inherits="WebSite.Admin.import.ImportSquare" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    
    Exportation du fichier:
    <a href="https://squareup.com/dashboard/items/library">Dashboard</a> puis bouton action (haut à droite) et Export Library.<br/>
    <br/>

    Fichier d'importation: (catalog-YYYY-MM-DD-XXXX.csv)<br/>
    <asp:FileUpload ID="FileUploadImport" runat="server" /> <asp:Button ID="cmdImport" runat="server" Text="Importer" OnClick="cmdImport_Click" />
    <br />
    <br />
    Importation via l'<a href="https://developer.squareup.com/">API key</a>: 
    <asp:TextBox ID="txtSquareApikey" runat="server" Width="399px"></asp:TextBox>
    <br />
    <br />
    <asp:CheckBox ID="chkImportNew" runat="server" Text="Importer les nouveaux produits" Checked="True" />
    <br />
    <asp:CheckBox ID="chkUpdate" runat="server" Text="Importer les produits existants"  Checked="True" />
    <br />
    <asp:CheckBox ID="chkImportTitle" runat="server" Text="Importer propriété (titre, description, prix, coût...)"  Checked="True" />
    <br />
    <asp:CheckBox ID="chkImportPhotos" runat="server"  Text="Importer les images)" Checked="True" />
    <br />
    <asp:CheckBox ID="chkImportInventory" runat="server"  Text="Importer l'inventaire" Checked="True" />
    <br />
    <br />
    <asp:Button ID="cmdImportViaApiKey" runat="server" OnClick="cmdImportViaApiKey_Click" Text="Importer" />
&nbsp; 
</asp:Content>
