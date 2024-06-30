<%@ page language="C#" masterpagefile="~/Admin/AdminMP.Master" autoeventwireup="true" codebehind="SalesByBrandSummary.aspx.cs" inherits="WebSite.Admin.SalesByBrandSummary" %>
<%@ register src="~/Admin/ucDateRangePicker.ascx" tagprefix="uc1" tagname="ucDateRangePicker" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#grid_wrapper {margin-top: 20px}
		@media print {
			#grid_wrapper {font-size: 10px;margin-top: 0 }
		}
		#grid .alignRight { text-align: right !important}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Sommaire des ventes par marques</h1>
	<div class="no-print">
		<asp:DropDownList runat="server" ID="lstStore" ClientIDMode="Static"/>
		<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
	</div>

	<table id="grid" style="display: none; width: 100%">
		<thead>
			<tr>
				<th>Marque</th>
				<th>$ inventaire</th>
				<th>Qté inventaire</th>
				<th>Qté vendue</th>
				<th>$ vente</th>
				<th>$ coûtant</th>
				<th>% profit</th>
				<th>Qté commandée</th>
			</tr>
		</thead>
		<tfoot>
		<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
		</tfoot>
	</table>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		$.ajax('/<%= WebSite.Admin.SalesByBrandSummaryHandler.Url %>' + window.location.search).done(function(data) {
			for (var i = 0; i < data.length; i++) {
				var r = data[i];
				r.SoldPriceStr = r.SoldPrice.toLocaleString(2);
			}
			$('#grid').show().DataTable({
				sAjaxDataProp: null,
				data: data,
				columns: [
					{
						data: "Name", defaultContent: '',
						render: function (data, type, row) {
							var qs = $.query.set('idBrand', row.Id);
							return "<a href='SalesByBrandDetailed.aspx" + qs + "'>" + row.Name + "</a>";
						}
					},
					{ data: "InventoryValue", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
					{ data: "InventoryQty", defaultContent: '', sClass: 'alignRight', render: NumberToQuantity },
					{ data: "SoldQty", defaultContent: '', sClass: 'alignRight', render: NumberToQuantity },
					{ data: "SoldPrice", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
					{ data: "SoldCost", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
					{  /* profit */
						data: null,
						sClass: 'alignRight',
						render: function (row) {
								if (row.SoldCost === 0 || row.SoldPrice === 0) {
									return '';
								}
								return ((row.SoldPrice - row.SoldCost) / row.SoldPrice * 100).toFixed(0);
							
						}
					},
					{ data: "RestockQty", defaultContent: '', sClass: 'alignRight' }
				],
				order: [[0, 'asc']],
				footerCallback: function (row, data, start, end, display) {
					var api = this.api();

					var count = api.column(0).data().length;
					$(api.column(0).footer()).html(count + ' marques');

					var totalInv = api.column(1).data().reduce(function (a, b) { return parseFloat(a) + parseFloat(b); }, 0);
					$(api.column(1).footer()).html(NumberToAmount(totalInv));

					totalInv = api.column(2).data().reduce(function (a, b) { return parseFloat(a) + parseFloat(b); }, 0);
					$(api.column(2).footer()).html(parseInt(totalInv));

					totalInv = api.column(3).data().reduce(function (a, b) { return parseFloat(a) + parseFloat(b); }, 0);
					$(api.column(3).footer()).html(parseInt(totalInv));

					totalInv = api.column(4).data().reduce(function (a, b) { return parseFloat(a) + parseFloat(b); }, 0);
					$(api.column(4).footer()).html(NumberToAmount(totalInv));

					totalInv = api.column(5).data().reduce(function (a, b) { return parseFloat(a) + parseFloat(b); }, 0);
					$(api.column(5).footer()).html(NumberToAmount(totalInv));
					
					totalInv = api.column(7).data().reduce(function (a, b) { return parseFloat(a) + parseFloat(b); }, 0);
					$(api.column(7).footer()).html(totalInv);
				}
			});
		});

		
	</script>
</asp:Content>
