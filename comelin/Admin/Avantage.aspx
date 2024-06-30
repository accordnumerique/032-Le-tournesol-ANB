<%@ Page Title="Syncronisation Avantage" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.Acomba" %>
<%@ register src="~/Admin/ucDateRangePicker.ascx" tagprefix="uc1" tagname="ucDateRangePicker" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#reports table .c {text-align: right}
		#reports table td,#reports table th {padding: 10px}
		.invalid {background-color: rgb(245, 229, 149)}
		.notbalance {background-color: red}
	</style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cp" runat="server">
	<h1>Synchronisation avec le logiciel de comptabilité Avantage</h1>
	<div><input id="chkOneEntry" type="checkbox"/> <label for="chkOneEntry">Une seule entrée pour la période de temps</label></div>
    <div><input id="chkGroupSameAccount" type="checkbox"/> <label for="chkGroupSameAccount">Regrouper les catégories qui sont associés au même compte</label></div>
	<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" ButtonText="Télécharger"  />
	<hr/>
	<div id="reports">
		<div v-if="reports.length > 1" class="btn btn-success" v-on:click="download(reports)">Télécharger les {{reports.length}} entrées de journaux</div>
		<div v-for="r in reports">
			<h2>{{ formatDate(r.Date) }} {{r.Store}}</h2>
			<table><thead>
				<tr><th>Compte</th><th>Débit</th><th>Credit</th><th>Description</th></tr>
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

	<asp:Content ID="Content2" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		function GetUrlExtra() {
			return $.query.SET('oneEntry', $$("chkOneEntry").checked.toString()).SET('GroupSameAccount', $$("chkGroupSameAccount").checked.toString());
		}

		$$('chkOneEntry').checked = $.query.get('oneEntry') === 'true';
        $$('chkGroupSameAccount').checked = $.query.get('GroupSameAccount') === 'true';

		var vm = new Vue({
			el: '#reports',
			data: {
				reports: _reports
			},
			methods: {
				formatDate: function(date) {
					return moment(date).format("MM-DD-YY");
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
					var text = '';
					var filename = '';
					if (Array.isArray(r)) {
						var i = 0;
						for (var report of r) {
							text += this.reportDump(report, i);
                            i += 1;
                        }
						filename = 'Comelin du ' + moment(r[0].Date).format('DD-MMM-YYYY') + ' au ' + moment(r[r.length - 1].Date).format('DD-MMM-YYYY');
					} else {
						var date = moment(r.Date);
						filename = 'Comelin ' + date.format('DD-MMM-YYYY');
						text = this.reportDump(r);
					}
					
					downloadFile(filename + '.txt', text);
				},
				reportDump: function (r, index) {
					var date = moment(r.Date);
					var fileHeader = 'Comelin ' + date.format('DD-MMM-YYYY');
					if (r.Store) {
						fileHeader += ' ' + r.Store;
					}

					// RQ01,W01,01,ECR,SUPDATE="2020/12/23",SUPDESC1="VENTES VELOCE DEPOT36-1",GL="31200,430.36,2",GL="31100,175.33,2",GL="32100,0.77,1",GL="21350,20.96,2",GL="21360,41.79,2",GL="11113,161.80,1",GL="32121,32.90,2",GL="11111,171.09,1",GL="11112,367.68,1"
                    if (!index) {
                        index = 0;
                    }

                    var requestNb = String(index + 1).padStart(2, '0');
					var text = 'RQ' + requestNb + ',W01,01,ECR,SUPDATE="' + date.format('YYYY/MM/DD') + '",SUPDESC1="' + fileHeader + '"';

					for (var e of r.Entries) {
                        text += ',';
						var value = '';
						if (e.Debit) {
							value = e.Debit.toFixed(2) + ',1';
						}
						if (e.Credit) {
							value = e.Credit.toFixed(2) + ',2';
						}
						text += 'GL="' + e.AccountName + ',' + value + '"';
					}
					return text +  "\r\n";
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
