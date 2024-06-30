<%@ Page Title="Rapport par mode de paiement" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="PaymentMode.aspx.cs" Inherits="WebSite.Admin.PaymentMode" %>

<%@ Register Src="~/Admin/ucDateRangePicker.ascx" TagPrefix="uc1" TagName="ucDateRangePicker" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Sommaire par mode de paiement</h1>
	<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
	
	<div id="SummaryByPaymentMethod" style="max-width: 800px;margin-top: 30px">
		<table class="bs">
			<thead>
			<tr>
				<th>Mode de paiement</th>
				<th class="alignRight">TPS</th>
				<th class="alignRight">TVQ</th>
				<th class="alignRight">Transport</th>
				<th class="alignRight">Total</th>
			</tr>
			</thead>
			<tbody></tbody>
		<tr v-for="payment in SummaryByPaymentMethod">
			<th>{{payment.Name}}</th>
			<td class="alignRight">{{formatAmount(payment.Tax1)}}</td>
			<td class="alignRight">{{formatAmount(payment.Tax2)}}</td>
			<td class="alignRight">{{formatAmount(payment.Transport)}}</td>
			<td class="alignRight">{{formatAmount(payment.TotalSales)}}</td>
		</tr>
		</table>
	</div>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		var vm = new Vue({
			el : '#SummaryByPaymentMethod',
			data: {
				SummaryByPaymentMethod: _SummaryByPaymentMethod
			},
			methods: {
				formatAmount: function (amount) {
					if (amount) {
						return amount.toFixed(2);
					}
					return '';
				},
			}


		});
	</script>
</asp:Content>
