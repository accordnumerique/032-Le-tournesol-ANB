<%@ Page Title="Problème d'inventaire" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="InventoryHistory.aspx.cs" Inherits="WebSite.Admin.InventoryProblems" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		.err { font-weight:bold; color:Red}
		table td { text-align:right; padding:5px;}
		thead { font-weight:bold}

	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>
		<img src="images/calcul.png" />
		Historique de l'inventaire</h1>

	<div class="multi-store">
		Inventaire: 
	<select id="store-picker" multiple class="select2"></select>
		<div id="cmdDisplay" class="btn btn-primary">Afficher</div>
	</div>

	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<div id="chart_div"></div>
	<div id="app-view-data">
		<div class="btn-group" id="btn-select-group">
			<div class="btn btn-secondary" v-for="s in stores" :class="{'btn-primary':(s == activeStore)}" @click="activeStore = s">
				{{s.Name}}
			</div>
		</div>
		

		<%= ComputeProblem() %>
	</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		var queryStringIdStore = 'idStore';
		google.charts.load('current', { packages: ['corechart', 'line'] });
		google.charts.setOnLoadCallback(drawBasic);

		function drawBasic() {
			// convert date to object
            for (var row of _data) {
                row[0] = new Date(row[0]);
            }
			var data = new google.visualization.DataTable();
			data.addColumn('date', 'Date');
			data.addColumn('number', "Inventaire");

			data.addRows(_data);
			var options = {
				hAxis: {
					title: 'Date'
				},
				vAxis: {
					title: 'Inventaire'
				},
				legend: 'none'
			};

			var chart = new google.visualization.LineChart(document.getElementById('chart_div'));

			chart.draw(data, options);
		}

		function GetUrl() {
			// get selected store
			GetStoreSelectedToQueryString();

			return $.query.toString();
		}

		if (_stores.length > 1) {
			// create a view instance to toggle visible one
			appViewdata = new Vue({
				el: '#app-view-data',
				data: {
					stores: _stores,
					activeStore: _stores[0]
				},
				watch: {
					activeStore: function () {
						document.location.hash = this.activeStore.Name;
					}
				},
				mounted: function() {
					// select the activate store from the query string
					var storeName = document.location.hash;
					if (storeName.length > 1) {
						storeName = decodeURI(storeName.substr(1)); // remove the #
						this.activeStore = this.stores.find(s => s.Name === storeName);
					}
				}
			});
		} else {
			$('#btn-select-group').hide();
		}
	
		function fix(idOrderLine, invBefore) {
			fetch('/admin/api/fix-inventory-invoice?invBefore=' + invBefore + '&idOrderLine=' + idOrderLine)
				.then(response =>
					location.reload()
				).catch(error => { $.notify(error, 'error');}
				);
		}
	</script>

	<style>
		.fa-check-circle {color:green; cursor: pointer}
	</style>
</asp:Content>
