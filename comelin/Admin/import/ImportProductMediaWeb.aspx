<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportProductMediaWeb.aspx.cs" Inherits="WebSite.Admin.onetime.ImportProductMediaWeb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<style>
		.imported, .importedfuzzy, .notimported { display: inline-block; width: 30%; float: left }

	</style>
		<%= RenderImported %>
	<%= RenderImportedFuzzy %>
		<%= RenderNotImported %>
</asp:Content>
