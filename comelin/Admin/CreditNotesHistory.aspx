<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="CreditNotesHistory.aspx.cs" Inherits="WebSite.Admin.CreditNotesHistory" %>
<%@ Register src="ucDateRangePicker.ascx" tagname="ucDateRangePicker" tagprefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="/Admin/images/credit.png"/> Notes de crédit <asp:Literal runat="server" ID="lblName"></asp:Literal></h1>
	<div id="datepicker">
	<uc1:ucDateRangePicker ID="ucDatePicker" runat="server"  ClientIDMode="Static" />
	</div>
	<table class="sssGrid">
		<thead>
		<tr><th>Date</th><th>Client</th><th>Facture</th><th>Montant</th><th>Employé</th><th>Balance</th></tr>
		</thead>
	</table>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
	$.ajax('/<%=WebSite.Admin.Api.AdminCreditNotesHistoryHandler.Url %>' + window.location.search).done(function(a) {
		var result = a;

		// set balance
		var balance = 0;
		for (var i = 0; i < a.length; i++) {
			var row = result[i];
			balance += row.Amount;
			row.Balance = balance;
			if (!row.Customer) {
				row.Customer = '';
			}
		}

		var viewCustomerName = $.query.get('idCustomer') == '';
		if (!viewCustomerName) {
			$$('datepicker').style.display = 'none';
		}

			$('.sssGrid').dataTable({
				data: result,
				paging:false,
				order: [[0, 'desc']],
				columns: [
					{
						data: null,
						render: {
							"_": "Date",
							"display": function (row) { return FormatDateTimeAgo(row.Date); }
						}
					},
					{
						data: 'Customer',
						visible: viewCustomerName,
						render: function (source, a, row) {
							return '<a href="CreditNotesHistory.aspx?idCustomer=' + row.IdCustomer + '">' + source + '</a>';
						}
					},
					{
						data: null,
						render: {
							"_": "IdTransaction",
							"display": function (row) {
								if (row.IdTransaction == 0) {
									return null;
								}
								return '<a href="' + row.WebUrl + '">' + row.IdTransaction + '</a>';
							}
						}
					},
					{
						data: 'Amount',
						render: function (source, type) {
							if (type === 'display') {
								if (source > 0) {
									return "+" + source.toFixed(2) + ' $';
								} else {
									return source.toFixed(2) + ' $';
								}
							} else {
								return source;
							}
							
						},
						sClass: 'alignRight'
					},
					{ data: 'Employee' },
					{
						data: 'Balance',
						sClass: 'alignRight',
						visible: !viewCustomerName,
						render: NumberToAmount
					}
				]
			});
		});
	</script>
</asp:Content>
