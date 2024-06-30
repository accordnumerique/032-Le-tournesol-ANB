<%@ Page Title="Importation Sage" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportSage.aspx.cs" Inherits="WebSite.Admin.import.ImportSage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Importation Sage</h1>
	
	<p>Exporté dans Sage un rapport Client, Clients, Stocks et Fournisseurs.</p>
	
	<hr/>
	<h3>Exportations des Client</h3>
	<p>
		<asp:FileUpload ID="FileUploadClient" runat="server" />
		<asp:Button ID="cmdImportClient" runat="server" Text="Importer les clients" OnClick="cmdImportClient_Click" />
	</p>
	<p>
		Format CSV, la première ligne devrait avoir la date puis un chiffre et &quot;Customer&quot;. Ex:</p>
	<code><pre>
27101,3,Customers

"9174-5551 Québec Inc.","Normand Dollen","12310, Chemin de la Rivière nord","","Mirabel","Québec","Canada","J7N1M3","(514) 555-9262","","","","","CAD","Courrant",</pre></code>
	
	<hr/>
	<h3>Exportation des stocks</h3>
	<p>
		<asp:FileUpload ID="FileUploadInventory" runat="server" />
		<asp:Button ID="cmdImportInventory" runat="server" Text="Importer l'inventaire" OnClick="cmdImportInventory_Click" />
	</p>
	<p>
		Format CSV, la première ligne devrait avoir la date puis un chiffre et &quot;Inventory&quot;. Ex:</p>
	<code><pre>
27101,3,Inventory

"0011800209S","Plaquette électronique extérieur HAIER 1U12LC2VHA","Inventory","Chaque",231.75,231.75,1530,4030,5025,5025,"Plaquette électronique extérieur HAIER 1U12LC2VHA","Chaque",</pre></code>
	
	<hr/>
</asp:Content>
