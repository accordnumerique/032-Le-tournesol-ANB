<%@ Page Title="Importation facebook" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportFacebook.aspx.cs" Inherits="WebSite.Admin.import.ImportFacebook" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <h1>Importation facebook</h1>
    <asp:Button ID="cmdImport" runat="server" Text="Importer" Visible="False" OnClick="cmdImport_Click" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
</asp:Content>
