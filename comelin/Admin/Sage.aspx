<%@ Page Title="Syncronisation Sage50" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.Acomba" %>
<%@ register src="~/Admin/ucDateRangePicker.ascx" tagprefix="uc1" tagname="ucDateRangePicker" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#reports .reportType {margin-bottom:10px}
		#reports table .c {text-align: right}
		#reports table td,#reports table th {padding: 10px}
		.invalid {background-color: rgb(245, 229, 149)}
		.notbalance {background-color: red}
	</style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cp" runat="server">
	<h1>Synchronisation avec le logiciel de comptabilité Sage50</h1>
	<div><input id="chkOneEntry" type="checkbox"/> <label for="chkOneEntry">Une seule entrée pour la période de temps</label></div>
    <div><input id="chkGroupSameAccount" type="checkbox"/> <label for="chkGroupSameAccount">Regrouper les catégories qui sont associés au même compte</label></div>
	<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" ButtonText="Télécharger"  />
	<hr/>
	<div id="reports">
		<div class="reportType">
			Format du fichier: 
            <div @click="formatSelected = formatSageCloud" class="btn" :class="cssClassFormatSelected(formatSageCloud)">Sage Cloud</div>
			<div @click="formatSelected = formatSage50" class="btn" :class="cssClassFormatSelected(formatSage50)">Sage50</div>
        </div>
		<div v-if="reports.length > 1" class="btn btn-success" @click="download(reports)">Télécharger les {{reports.length}} entrées de journaux</div>
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
			<div class="btn btn-success" @click="download(r)">Télécharger</div>
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
				formatSelected: localStorage.getItem('ExportFormat'),
				reports: _reports,
				formatSage50:1,
				formatSageCloud:2
			},
			watch: {
				formatSelected(v) {
					localStorage.setItem('ExportFormat', v);
				}
			},
			methods: {
				cssClassFormatSelected(buttonFormat) {
                    if (!this.formatSelected) {
						return 'btn-warning'; // none of the format is selected
                    }
                    if (this.formatSelected == buttonFormat) {
						return 'btn-success';
                    } else {
						return 'btn-secondary'
                    }
				},
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
                    if (this.formatSelected == this.formatSageCloud) {
						text = "Référence,Date,Description,Numéro de compte du grand livre,Détails,Débit,Crédit,Incluse dans la déclaration de taxes?,Type d'analyse 1,Type d'analyse 2,Type d'analyse 3,Taux de change\n";
                    }
					var filename = '';
					if (Array.isArray(r)) {
						for (var report of r) {
							text += this.reportDump(report);
						}
						filename = 'Comelin du ' + moment(r[0].Date).format('DD-MMM-YYYY') + ' au ' + moment(r[r.length - 1].Date).format('DD-MMM-YYYY');
					} else {
						var date = moment(r.Date);
						filename = 'Comelin ' + date.format('DD-MMM-YYYY');
						text += this.reportDump(r);
					}
					
					downloadFile(filename + '.csv', text);
				},
				reportDump: function (r) {
					var date = moment(r.Date);
					var fileHeader = 'Comelin ' + date.format('DD-MMM-YYYY');
					if (r.Store) {
						fileHeader += ' ' + r.Store;
					}
					if (this.formatSelected == this.formatSage50) {
						return this.reportDumpSage50(r, fileHeader);
					} else {
						return this.reportDumpSageCloud(r, fileHeader);
					}
				},
				reportDumpSageCloud: function (r, fileHeader) {
					/*
					Reference CSV provided by Sage50 Clound web site when uploading a Journal Entry 
					Référence,Date,Description,Numéro de compte du grand livre,Détails,Débit,Crédit,Incluse dans la déclaration de taxes?,Type d'analyse 1,Type d'analyse 2,Type d'analyse 3,Taux de change
Premier Journal,25/01/2023,journal 1 a été importé,1000,détail de la première ligne du journal,53,0,N,,,,
,,,1050,détail de la deuxième ligne du journal,0,53,N,,,,
,,,1000,détail de la troisième ligne du journal,53,0,N,,,,
,,,1050,détail de la quatrième ligne du journal,0,53,N,,,,
Deuxième Journal,25/01/2023,journal 2 a été importé,1000,détail de la première ligne du journal,60,0,N,,,,
,,,1050,détail de la deuxième ligne du journal,0,60,N,,,,
,,,1000,détail de la troisième ligne du journal,60,0,N,,,,
,,,1050,détail de la quatrième ligne du journal,0,60,N,,,,

*/


					// the header is already set, just add the rows
					var firstEntry = true;
					var strCsv = '';
					for (var e of r.Entries) {
						var csvCells = [];
						if (firstEntry) {
							csvCells.push(r.Identifier);
							csvCells.push(moment(r.Date).format('DD/MM/YYYY'));
							csvCells.push(r.Identifier + ' (Comelin)'); // description
						} else {
							csvCells.push('');
							csvCells.push('');
							csvCells.push('');
						}
						firstEntry = false;
						csvCells.push(e.AccountName);
						csvCells.push(e.Description);
						csvCells.push(this.formatNumber2Digit(e.Debit));
						csvCells.push(this.formatNumber2Digit(e.Credit));
						csvCells.push('N');// not sure about that flag
						csvCells.push('');
						csvCells.push('');
						csvCells.push('');
						csvCells.push('');
						strCsv += csvCells.join(',') + '\n';
					}
					
					return strCsv; // return the array as a string comma separated
				},
				formatNumber2Digit(value) {
                    if (!value) {
						return '0';
                    } else {
						return value.toFixed(2);
                    }
				},
				reportDumpSage50: function (r, fileHeader) {
					var date = moment(r.Date);
					var text = date.format('MM-DD-YY') + ',"' + date.format('DD-MMM-YY') + '","' + fileHeader + '"\n';

					for (var e of r.Entries) {
						var value = '';
						if (e.Debit) {
							value = e.Debit.toFixed(2);
						}
						if (e.Credit) {
							value = -e.Credit.toFixed(2);
						}
						text += e.AccountName.padEnd(4, ' ') + ',' + value + "\n";
					}
					return text;
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
