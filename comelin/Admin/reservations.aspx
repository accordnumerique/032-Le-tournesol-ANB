<%@ Page Title="Réservations" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="reservations.aspx.cs" Inherits="WebSite.Admin.reservations" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1> <img alt="" src="images/reservations.png" /> Réservations</h1>
	<p>Liste de tout les produits en réservation ou commandes à complétées.<br /><br /></p>
	<table id=tableReservation style="width:100%" class=sssGrid>
	<thead><tr><th style="width:100px">Voir Commande</th><th style="width:100px">Code</th><th>Description</th><th>Client</th>
	<th style="width:100px">Qté</th><th style="width:100px">Inventaire</th><th>Status</th><th>Livraison</th></tr></thead>
	</table>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			$('#tableReservation').dataTable({
				"sAjaxSource": '/admin/api/reservations/details' + window.location.search,
				"aaSorting": [[1, 'asc'], [3, 'asc']],
				"aoColumnDefs": [ {
					"aTargets": [ 0 ],
					"mData": "download_link",
					"mRender": function ( data, type, full ) {
						return '<a href="' + full[8] + '">' + full[0] + '</a>';
					}
				} ]
			});
		});
	</script>
</asp:Content>
