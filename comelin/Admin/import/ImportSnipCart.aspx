<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportSnipCart.aspx.cs" Inherits="WebSite.Admin.import.ImportSnipCart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <h1>
        Importation de Snipcart</h1>
    <p>
        Les images doivents être téléversés dans &quot;App_Data\import\snipcart&quot;</p>
    <p>
        Le fichier json
        <asp:FileUpload ID="FileUpload1" runat="server" />
    </p>
    <p>
        <asp:Button ID="cmdImport" runat="server" OnClick="cmdImport_Click" Text="Importation" />
    </p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
</asp:Content>
