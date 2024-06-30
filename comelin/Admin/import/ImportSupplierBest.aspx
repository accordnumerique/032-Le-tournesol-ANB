<%@ Page Title="Importé des fournisseurs de BEST" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportSupplierBest.aspx.cs" Inherits="WebSite.Admin.onetime.ImportSupplierBest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
	<p>
		Importer la liste des fournisseurs à partir d&#39;un fichier exporté de BEST.</p>
	<p>
		Fichier:
		<asp:FileUpload ID="FileUpload1" runat="server" />
	</p>
	<p>
		&nbsp;</p>
	<asp:Button ID="cmdImport" runat="server" OnClick="cmdImport_Click" Text="Importer" />
	
</asp:Content>
