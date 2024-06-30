<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Export.aspx.cs" Inherits="WebSite.Admin.Exporter" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Exporter les données</h1>
	<asp:Button ID="cmdProduct" runat="server" Text="Produits" OnClick="cmdProduct_Click" />
</asp:Content>
