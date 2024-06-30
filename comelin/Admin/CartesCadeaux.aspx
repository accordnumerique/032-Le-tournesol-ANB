<%@ Page Title="Liste des cartes cadeaux"  Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.AdminPage"  %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="/Admin/images/giftcard.png"/> Cartes cadeaux</h1>
	<h3>Total: <span id="total"></span></h3>
	<table class="sssGrid">
		<thead>
		<tr><th>Numéro</th><th>Balance</th><th>Date dernière opération</th><th>Client</th><th>Téléphone</th><th>Date</th><th>Facture</th></tr>
		</thead>
		<tfoot>
		<tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
		</tfoot>
	</table>	

</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
		<% EnsurePermission(Permission.AdminViewGiftCards);  %>
	<script>
	$.ajax('/<%=WebSite.Admin.Api.AdminGiftCardsHandler.Url %>' + window.location.search).done(function(a) {
			var result = a;
			var total = 0;
			for (var i = 0; i < a.length; i++) {
				var row = result[i];
				total += row.Balance;
			}
			$$('total').innerHTML = NumberToAmount(total);
			$('.sssGrid').dataTable({
				data: result,
				paging:false,
				order: [[3, 'desc']],
				columns: [
					{ data: 'Number' },
					{
						data: 'Balance',
						render: NumberToAmount,
						sClass: 'alignRight',
					},
					{
						data: 'LastAmount',
						render: NumberToAmount,
						sClass: 'alignRight',
					},
					{ data: 'CustomerName', defaultContent: '' },
					{ data: 'CustomerPhone', defaultContent: '' },
					{
						data: null,
						render: {
							"_": "LastDate",
							"display": function (row) { return FormatDateTimeAgo(row.LastDate); }
						}
					},
					
					{
						"data": null,
						"render": {
							"_": "LastTransaction",
							"display": function (row) {
								if (row.LastTransaction == 0) {
									return null;
								}
								return '<a href="' + row.WebUrl + '">' + row.LastTransaction + '</a>';
							}
						}
					}
				]
			});
		});
	</script>
</asp:Content>
