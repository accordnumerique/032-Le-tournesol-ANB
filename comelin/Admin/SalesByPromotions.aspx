<%@ Page Title="Ventes par rabais" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SalesByPromotions.aspx.cs" Inherits="WebSite.Admin.SalesByPromotions" %>
<%@ Register Src="~/Admin/ucDateRangePicker.ascx" TagPrefix="uc1" TagName="ucDateRangePicker" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>
		<img src="images/report-promotion.png" />
		Ventes par Promotions</h1>
<span class="multi-store"> à <select id="store-picker" multiple class="select2"></select></span>
	<div id="timeSelector">
		<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
	</div>
	<br />
	<br />
	<table class="sssGrid">
		<thead>
			<tr>
				<td>Promotion</td>
				<td># d'articles vendu</td>
				<td>Valeur Vendu</td>
				<td>Rabais accordée</td>
				<td>% rabais</td>
				<td>Coût</td>
				<td>% profit</td>
				<td># de factures</td>
				<td>total factures</td>
			</tr>
		</thead>
		<tfoot>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</tfoot>
	</table>
	<br/><br/>
	<a class="btn btn-primary" runat="server" id="lnkDownload">Télécharger les ventes</a>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script type="text/javascript">
		function GetUrl() {
			$.query.SET('from', $$("from").value);
			$.query.SET('to', $$("to").value);
			// get selected store
			GetStoreSelectedToQueryString();
			return $.query.toString();
		}
		
		$(function () {
			$('.sssGrid').dataTable({
				data: _promotions,
				order: [[2, 'desc']],
				columns: [
					{ data: 'PromotionName' },
					{
						data: 'NbItems',
						render: function (a, b, c) {
							return a + ' <a href="' + c.Url + '" class="fa fa-file-excel-o"></i>';
						},
						sClass: 'alignRight'
					},
					{
						data: 'DirectSales',
						render: NumberToAmount,
						sClass: 'alignRight'
					},
					{
						data: 'RebateGiven',
						render: NumberToAmount,
						sClass: 'alignRight'
					},
					{
						data: 'RebatePercentage',
						render: NumberToPercentage,
						sClass: 'alignRight'
					},
					{
						data: 'Cost',
						render: NumberToAmount,
						sClass: 'alignRight'
					},
					{
						data: 'Profit',
						render: NumberToPercentage,
						sClass: 'alignRight'
					},
					{ data: 'NbSales', sClass: 'alignRight' },
					{
						data: 'IndirectSales',
						render: NumberToAmount,
						sClass: 'alignRight'
					}

				]
			});

		});
		


	</script>
</asp:Content>
