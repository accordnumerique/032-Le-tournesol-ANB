<%@ Page Title="Importation des données d'Avantage" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportAvantage.aspx.cs" Inherits="WebSite.Admin.import.ImportAvantage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Import Avantage</h1>
	<p>
		Fichier &quot;Liste générale des clients&quot;</p>
	<p>
		<asp:FileUpload ID="FileUploadCustomer" runat="server" />
		&nbsp;<asp:Button ID="cmdImportCustomer" runat="server" OnClick="cmdImportCustomer_Click" Text="Importer" />
	</p>
	<p>
		Fichier &quot;Analyse des stocks par fournisseur&quot;</p>
	<p>
		<asp:FileUpload ID="FileUploadProducts" runat="server" />
&nbsp;<asp:Button ID="cmdImportProducts" runat="server" OnClick="cmdImportProducts_Click" Text="Importer" />
	</p>
</asp:Content>
