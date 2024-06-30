<%@ Page Title="Acomba" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Acomba.aspx.cs" Inherits="WebSite.Admin.Acomba" %>
<%@ register src="~/Admin/ucDateRangePicker.ascx" tagprefix="uc1" tagname="ucDateRangePicker" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#reports table .c {text-align: right}
		#reports table td,#reports table th {padding: 10px}
		.invalid {background-color: rgb(245, 229, 149)}
		.notbalance {background-color: red}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Acomba</h1>
	<div><input id="chkOneEntry" type="checkbox"/> <label for="chkOneEntry">Une seule entrée pour la période de temps</label></div>
    <div><input id="chkGroupSameAccount" type="checkbox"/> <label for="chkGroupSameAccount">Regrouper les catégories qui sont associés au même compte Acomba</label></div>
	<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" ButtonText="Télécharger"  />
	<hr/>
	<div id="reports">
		<div v-for="r in reports">
			<h2>{{ formatDate(r.Date) }} {{r.Store}}</h2>
			<table><thead>
				<tr><th>Compte Acomba</th><th>Débit</th><th>Credit</th><th>Description</th></tr>
				</thead>
				<tbody>
				<tr v-for="e in r.Entries">
					<td v-bind:class="{invalid: !e.AccountName}">{{e.AccountName}}</td>
					<td class="c">{{formatAmount(e.Debit)}}</td>
					<td class="c">{{formatAmount(e.Credit)}}</td>
					<td>{{e.Description}}</td>
				</tr>
				</tbody>
				<tfoot>
				<tr v-bind:class="{notbalance: (sumDebit(r.Entries).toFixed(2) != sumCredit(r.Entries).toFixed(2))}">
					<th></th><th>{{formatAmount(sumDebit(r.Entries))}}</th>
					<th>{{formatAmount(sumCredit(r.Entries))}}</th><th></th>
				</tr>
				</tfoot>
			</table>
			<div class="btn btn-success" v-on:click="download(r)">Télécharger</div>
		</div>
	</div>
	<hr/>
	<a href="/Admin/AccountingIntegration.aspx">configuration des comptes</a>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		function GetUrlExtra() {
			return $.query.SET('oneEntry', $$("chkOneEntry").checked.toString()).SET('GroupSameAccount', $$("chkGroupSameAccount").checked.toString());
		}

		$$('chkOneEntry').checked = $.query.get('oneEntry') === 'true';
        $$('chkGroupSameAccount').checked = $.query.get('GroupSameAccount') === 'true';

		moment.updateLocale('en', {
			monthsShort: [
				"janv", "févr", "mars", "avr", "mai", "juin", "juil", "août", "sept", "oct", "nov", "déc."
			]
		});


		var vm = new Vue({
			el: '#reports',
			data: {
				reports: _reports
			},
			methods: {
				formatDate: function(date) {
					return moment(date).format("dddd, MMMM Do YYYY");
				},
				formatAmount: function (amount) {
					if (amount) {
						return amount.toFixed(2);
					}
					return '';
				},
				sumDebit: function (entries) {
					var total = 0;
					for (var i in entries) {
						var e = entries[i];
						if (e.Debit) {
							total += e.Debit;
						}
					}
					return total;
				},
				sumCredit: function (entries) {
					var total = 0;
					for (var i in entries) {
						var e = entries[i];
						if (e.Credit) {
							total += e.Credit;
						}
					}
					return total;
				},
				download: function (r) {
					var date = moment(r.Date);
					var dateStr = date.format('DD-MMM-YYYY');
					var fileHeader = 'Z du ' + dateStr;
					if (r.Store) {
						fileHeader += ' ' + r.Store;
					}
					var text = fileHeader + "\r\n";
					text += 'E' + date.format('YYMMDD') + 'Z du ' + dateStr + "\r\n";
					for (var i in r.Entries) {
						var e = r.Entries[i];
						var debit = '';
						if (e.Debit) {
							debit = e.Debit.toFixed(2);
						}
						var credit = '';
						if (e.Credit) {
							credit = e.Credit.toFixed(2);
						}
						text += 'T' + e.AccountName.padEnd(6, ' ') + debit.padStart(8, ' ') + credit.padStart(9, ' ') + "\r\n";
					}
					downloadFile(fileHeader + '.txt', text);
				}

			}
		});

		function downloadFile(filename, text) {
			var element = document.createElement('a');
			element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
			element.setAttribute('download', filename);

			element.style.display = 'none';
			document.body.appendChild(element);

			element.click();

			document.body.removeChild(element);
		}

	</script>

</asp:Content>
