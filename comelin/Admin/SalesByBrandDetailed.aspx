<%@ page language="C#" masterpagefile="~/Admin/AdminMP.Master" autoeventwireup="true" codebehind="SalesByBrandDetailed.aspx.cs" inherits="WebSite.Admin.SalesByBrandDetailed" %>
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
	<h1><%= Title %></h1>

	<div class="no-print">
		<asp:DropDownList runat="server" ID="lstStore" ClientIDMode="Static"/>
		<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" FilterByBrand="True" />
	</div>

	<table id="grid" style="display: none; width: 100%">
		<thead>
			<tr>
				<th>Code</th>
				<th>Marque</th>
				<th>Description</th>
				<th>$ inventaire</th>
				<th>Qté inventaire</th>
				<th>Qté vendue</th>
				<th>$ vente</th>
                <th><t>Tax1</t></th>
                <th><t>Tax2</t></th>
				<th>$ coûtant</th>
				<th>% profit</th>
				<th>Qté commandé</th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<th></th>
				<th></th>
				<th></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
                <th class="alignRight"></th>
                <th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
			</tr>
		</tfoot>
	</table>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		$('#grid').show().DataTable({
			ajax: '/<%= WebSite.Admin.SalesByBrandHandler.Url %>' + window.location.search,
			sAjaxDataProp: null,
			columns: [
				{ data: "Code", defaultContent: '' },
				{ data: "Brand", defaultContent: '' },
				{ data: "Title", defaultContent: '' },
				{ data: "InventoryValue", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
				{ data: "Inventory", defaultContent: '', sClass: 'alignRight', render: NumberToQuantity },
				{ data: "QtySold", defaultContent: '', sClass: 'alignRight', render: NumberToQuantity },
				{ data: "AmtSold", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
                { data: "Tax1", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
                { data: "Tax2", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
				{
					data: "Cost",
					defaultContent: '',
					render: NumberToAmount,
					sClass: 'alignRight'
				},
				{  /* profit */
					data: null,
					sClass: 'alignRight',
					render: {
						"_": function (row) {
							if (row.Cost === 0) {
								return 0;
							}
							return ((row.AmtSold - row.Cost) / row.AmtSold * 100).toFixed(0);
						}
					}
				},
				{
					data: "QtyReceived",
					defaultContent: '',
					sClass: 'alignRight'
				}
			],
			order: [[0, 'asc']],
			footerCallback: function (row, data, start, end, display) {
				var api = this.api();

				var count = api.column(0).data().length;
				$(api.column(2).footer()).html(count + ' produits');

				var totalInv = api.column(3).data().reduce(function (a, b) { return a + b; }, 0);
				$(api.column(3).footer()).html(NumberToAmount(totalInv));

				var totalInv = api.column(4).data().reduce(function(a, b) { return a + b; }, 0);
				$(api.column(4).footer()).html(NumberToQuantity(totalInv));

				var totalQtySold = api.column(5).data().reduce(function (a, b) { return a + b; }, 0);
				$(api.column(5).footer()).html(NumberToQuantity(totalQtySold));

				var totalSale = api.column(6).data().reduce(function (a, b) { return a + b; }, 0);
				$(api.column(6).footer()).html(NumberToAmount(totalSale));

                var totalTax1 = api.column(7).data().reduce(function (a, b) { return a + b; }, 0);
                $(api.column(7).footer()).html(NumberToAmount(totalTax1));


                var totalTax2 = api.column(8).data().reduce(function (a, b) { return a + b; }, 0);
                $(api.column(8).footer()).html(NumberToAmount(totalTax2));


				var totalCost = api.column(9).data().reduce(function (a, b) { return a + b; }, 0);
				$(api.column(9).footer()).html(NumberToAmount(totalCost));

				var profit = 0;
				if (totalCost !== 0) {
					profit = ((totalSale - totalCost) / totalSale * 100);
				}
				$(api.column(10).footer()).html(profit.toFixed(0));

				$(api.column(11).footer()).html(api.column(11).data().reduce(function (a, b) { return a + b; }, 0));
			}
		});
	</script>
</asp:Content>
