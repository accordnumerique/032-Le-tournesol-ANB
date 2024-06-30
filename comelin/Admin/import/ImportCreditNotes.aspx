<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportCreditNotes.aspx.cs" Inherits="WebSite.Admin.onetime.ImportCreditNotes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Importation des notes de crédit</h1>
	<p>- Encodage par défaut (exporte de Excel)</p>
	<p>- Séparer par des 
		<asp:TextBox ID="txtSeparator" runat="server" Width="32px" ClientIDMode="Static">,</asp:TextBox>
&nbsp;(CSV)&nbsp;&nbsp; (laisser la case vide pour des TAB)</p>
	<p>- Doit avoir des entêtes (1ère ligne n'est importé)</p>
	<p>- 1er colonne numéro de téléphone ou référence client</p>
	<p>- 2e colonne nom du client</p>
	<p>- 3e colonne montant de la note de crédit</p>
	<p>
		<asp:FileUpload ID="FileUpload1" runat="server" />
	</p>
	<p>
		<asp:Button ID="cmdImport" runat="server" OnClick="cmdImport_Click" Text="Importer" />
	</p>
	<style>
		#txtSeparator { text-align: center}
	</style>
</asp:Content>
