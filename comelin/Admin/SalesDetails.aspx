<%@ Page Title="Détails des ventes" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SalesDetails.aspx.cs" Inherits="WebSite.Admin.SalesDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="server">
	<h1>Détail des ventes</h1>
	
    <div id="appSalesDetails">
        <filter-date-range @filterchanged="filterChanged"></filter-date-range>
        <filter-store @filterchanged="filterChanged"></filter-store>
        <filter-category @filterchanged="filterChanged"></filter-category>
        <filter-brand @filterchanged="filterChanged"></filter-brand>
        <filter-supplier @filterchanged="filterChanged"></filter-supplier>
        <filter-attrib instance="1" @filterchanged="filterChanged"></filter-attrib>
        <filter-attrib instance="2" @filterchanged="filterChanged"></filter-attrib>
		
        <div id="viewReport" >
            <div class="btn btn-primary" @click="updateReport">Voir le rapport</div>
        </div>

        <br/><br/>
	    <h2 id="total"></h2>
	    <table class="sssGrid" id="salesdetails">
		    <thead><tr><th>Date</th><th>#Facture</th><th>Magasin</th><th>Employé</th><th>Client</th><th>Qté</th><th>Nom du produit</th><th>Catégorie</th><th>Total</th><th>Rabais</th><th>Coût</th><th>Profit</th><th>Info</th></tr></thead>
		    <tbody></tbody>
		    <tfoot><tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr></tfoot>
	    </table>
	
	</div>


</asp:Content>

	<asp:Content ID="Content2" ContentPlaceHolderID="cpFooter" runat="server">
		<style>.TimeAgo  {display: block}</style>
        <%= this.JsInclude("/admin/js/components/report.js")  %>
        <%= this.JsInclude("/admin/js/salesdetails.js")  %>

</asp:Content>

