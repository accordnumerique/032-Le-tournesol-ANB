<%@ Page Title="Liste des dépôts de sécurités sur réservations"  Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.AdminPage"  %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="/Admin/images/securitydeposit.png"/> Dépôts de sécurité</h1>
	<h3>Total: <span id="total"></span></h3>
	<table class="sssGrid">
		<thead>
		<tr><th>Client</th><th>Téléphone</th><th>Montant dépôt</th><th>Montant réservation</th><th>Date</th><th>Facture</th></tr>
		</thead>
			<tfoot>
		<tr><th></th><th></th><th></th><th></th><th></th><th></th></tr>
		</tfoot>
	</table>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
        <% EnsurePermission(Permission.AdminSalesSummary); %>
	<script>
	$.ajax('/<%=WebSite.Admin.Api.AdminSecurityDepositHandler.Url %>' + window.location.search).done(function(a) {
			var result = a;
			var total = 0;
			for (var i = 0; i < a.length; i++) {
				var row = result[i];
				total += row.SecurityDepositAmount;
			}
			$$('total').innerHTML = NumberToAmount(total);
			$('.sssGrid').dataTable({
				data: result,
				paging:false,
				order: [[3, 'desc']],
				columns: [
					{ data: 'CustomerName' },
					{ data: 'CustomerPhone', defaultContent: '' },
					{
						data: 'SecurityDepositAmount',
						render: NumberToAmount,
						sClass: 'alignRight',
					},
					{
						data: 'ReservationAmount',
						render: NumberToAmount,
						sClass: 'alignRight',
					},
					{
						data: null,
						render: {
							"_": "Date",
							display: function (row) { return FormatDateTimeAgo(row.Date); } 
						}
					},
					
					{
						data: null,
						render: {
							"_": "Invoice",
							display: function (row) {
								if (row.LastTransaction == 0) {
									return null;
								}
								return '<a href="' + row.WebUrl + '">' + row.Invoice + '</a>';
							}
						}
					}
				]
			});
		});
	</script>
</asp:Content>
