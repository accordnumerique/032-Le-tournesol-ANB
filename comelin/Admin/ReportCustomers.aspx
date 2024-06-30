<%@ Page Title="Rapport clients" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ReportCustomers.aspx.cs" Inherits="WebSite.Admin.ReportCustomers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#lstGroup {width: 400px;}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
<div id="app-client-report">
	<h1><img src="images/groups.png" /> 
		<template v-if="interest">Client·e·s qui ont un intérêts pour {{filterProduct}}</template>
		<template v-else-if="filterProduct">Client·e·s qui ont acheté·e·s {{filterProduct}}</template>
		<template v-else="interest">Liste des clients</template>
	</h1>
    <filter-customer-group></filter-customer-group>
	<div v-if="!filterProduct">
        <template v-if="interest">Demandé une notification pour: </template>
        <template v-else="interest">Fait l'achat de: </template>
        <filter-by-product-code></filter-by-product-code>
        <filter-brand @filterchanged="filterChanged"></filter-brand>
    </div>
	Fait des achats au montant minimal de: 
	<filter-amount></filter-amount>
    <div>
		<filter-employees></filter-employees>
        <span class="multi-store"> à <filter-store @filterchanged="filterChanged"></filter-store></span> 
        <filter-online-only></filter-online-only>
    </div>
	Afficher vente total <filter-date-range @filterchanged="filterChanged"></filter-date-range>
    
    <div class="btn btn-primary" @click="updateReport">Voir le rapport</div>
	
   <div class="btn btn-default"  ID="cmdDownload" @click="downloadReport">Télécharger incluant les produits vendus</div>
</div>
	<table id="table" style="width: 100%; display: none" class="sssGrid">
		<thead>
			<tr>
				<th>Prénom</th>
				<th>Nom</th>
				<th>Entreprise</th>
				<th>Téléphone</th>
				<th>Cell</th>
				<th>Courriel</th>
				<th>Adresse</th>
				<th>Ville</th>
				<th>Région</th>
				<th>Province</th>
				<th>Code Postal</th>
				<th>Date création</th>
				<th>Anniversaire</th>
				<th>Année naissance</th>
				<th>Notes</th>
				<th>Groupes</th>
				<th>Total Achats</th>
				<th># factures</th>
                <th>Date dernière facture</th>
				<th>Points</th>
				<th># membre</th>
				<th>Id</th>
				<th>Infolettre</th>
			</tr>
		</thead>
		<tfoot>
		<tr>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
            <th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
		</tr>
		</tfoot>
	</table>
	<br />
	<br />
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
        <%= this.JsInclude("/admin/js/components/report.js")  %>
        <%= this.JsInclude("/admin/js/report-customer.js")  %>
</asp:Content>
