<%@ Page  Title="Notes de crédit" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.AdminPage"  %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
	<div id="app">
	
    
    <h1><img src="/Admin/images/credit.png"/> Notes de crédit 
        <help style="float:right" number="1814"></help>
    </h1>
    </div>
	<h3>Total: <span id="total"></span></h3>
	<table class="sssGrid">
		<thead>
			<tr><th>Client</th><th>Téléphone</th><th>Balance</th><th>Montant</th><th>Date</th><th>Employé</th><th>Facture</th></tr>
		</thead>
		<tfoot>
		<tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
		</tfoot>
	</table>	

</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
        <% EnsurePermission(Permission.AdminSalesSummary); %>
	<script>
        new Vue({
            el: '#app'
        });

        $.ajax('/<%=WebSite.Admin.Api.ApiCreditNotes.Url %>' + window.location.search).done(function(a) {
            var result = a;
            var total = 0;
            for (var i = 0; i < a.length; i++) {
                var row = result[i];
                if (!row.Balance) {
                    row.Balance = 0;
                }
                total += row.Balance;
            }
            $$('total').innerHTML = NumberToAmount(total);
            var tableCreditNote = $('.sssGrid').dataTable({
                data: result,
                paging:false,
                order: [[3, 'desc']],
                columns: [
                    { data: 'CustomerName', defaultContent: '' },
                    { data: 'CustomerPhone', defaultContent: '' },
                    {
                        data: 'Balance', sClass: 'alignRight',
                        render: function (source, a, row) {
                            return '<a href="CreditNotesHistory.aspx?idCustomer=' + row.IdCustomer + '">' + source.toFixed(2) + ' $</a>';
                        }
                    },
                    {
                        data: 'LastAmount',
                        render: function (source) {
                            if (source > 0) {
                                return "+" + source.toFixed(2) + ' $';
                            } else {
                                return source.toFixed(2) + ' $';
                            }
                        },
                        sClass: 'alignRight',
                    },
                    {
                        data: null,
                        render: {
                            "_": "LastDate",
                            "display": function (row) { return FormatDateTimeAgo(row.LastDate); } 
                        }
                    },
                    { data: 'LastEmployee', defaultContent: ''},
                    {
                        data: null,
                        render: {
                            "_": "LastTransaction",
                            display: function (row) {
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
