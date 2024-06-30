<%@ Page Title="Importation LPOS" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportLPos.aspx.cs" Inherits="WebSite.Admin.import.ImportLPos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Importation de la base de donnée L-POS</h1>
	
	La première étape est d&#39;ouvrir la base de donnée MS-SQL avec l&#39;outil normalement déjà installé "Sql Server Management Studio" et exécuté le <a href="lpos/import_requete.sql.txt">script</a>.
	<br/>
	Sauvegarder le résultat en CSV avec les entêtes en UTF-8.<br/>
	<br/>
	Fichier SQL: 
	<asp:FileUpload ID="FileUploadDBScript" runat="server" />
	<br />
	<br />
	Dans l&#39;application L-POS faire une rapport des relation parent-enfants.<br />
	<br />
	Fichier &quot;Liste de PLU avec Parent-Enfant&quot;:
	<asp:FileUpload ID="fileUploadFichierParentEnfant" runat="server" />
	<br />
	<br />
	Dans l&#39;application L-POS faire une rapport des quantités en main.<br />
	<br />
	Fichier &quot;Rapport Quantité en main&quot;:
	<asp:FileUpload ID="FileUploadQty" runat="server" />
	<br />
	<br />

	<asp:Button ID="cmdImport" runat="server" CssClass="btn-primary" OnClick="cmdImport_Click" Text="Importer" />
</asp:Content>
