<%@ page title="" language="C#" masterpagefile="~/Admin/AdminMP.Master" autoeventwireup="true" codebehind="ProductsReceivedFromSupplier.aspx.cs" inherits="WebSite.Admin.ProductsReceivedFromSupplierPage" %>
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
	<h1><img src="images/order-supplier.png"/> Achats par marques</h1>
	<div>
		<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" FilterByBrand="True" />
	</div>
	<table id="grid" style="display: none; width: 100%">
		<thead>
			<tr>
				<th>Code</th>
				<th>Marque</th>
				<th>Description</th>
				<th>Qté recu</th>
				<th>$ coûtant</th>
				<th>Total</th>
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
			</tr>
		</tfoot>
	</table>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		$('#grid').show().DataTable({
			ajax: '/<%= WebSite.Admin.ProductsReceivedFromSupplierHandler.Url %>' + window.location.search,
			sAjaxDataProp: null,
			columns: [
				{ data: "Code", defaultContent: '' },
				{ data: "Brand", defaultContent: '' },
				{ data: "Title", defaultContent: '' },
				{ data: "QtyReceived", defaultContent: '', sClass: 'alignRight' },
				{
					data: "Cost",
					defaultContent: '',
					render: NumberToAmount,
					sClass: 'alignRight'
				},
				{  /* total */
					data: "Total",
					sClass: 'alignRight',
					render: NumberToAmount
				}
			],
			order: [[0, 'asc']],
			footerCallback: function (row, data, start, end, display) {
				var api = this.api();

				var count = api.column(0).data().length;
				$(api.column(2).footer()).html(count + ' produits');

				var t = api.column(3).data().reduce(function(a, b) { return a + b; }, 0);
				$(api.column(3).footer()).html(t);

				t = api.column(4).data().reduce(function (a, b) { return a + b; }, 0);
				$(api.column(4).footer()).html(NumberToAmount(t));

				t = api.column(5).data().reduce(function (a, b) { return a + b; }, 0);
				$(api.column(5).footer()).html(NumberToAmount(t));



			}
		});
	</script>
</asp:Content>
