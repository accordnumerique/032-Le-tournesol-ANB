<%@ Page Title="Sources" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Referral.aspx.cs" Inherits="WebSite.Admin.Referral" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		.sssGrid td { text-align:right}
		#timeSelector a { padding:5px; margin: 5px;}
		#cmdSave{margin-bottom: 50px}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="appReferral">
        <h1><img src="images/referral.png" /> Sources <help url="articles/activation-et-configuration-des-cartes-cadeaux"></help></h1>
        <p>Ce module vous permet de demander la question à vos clients. "Comment vous nous avez connus?". Vous pourrez alors connaître l'impact de vos différentes techniques de visibilité.</p>
        <filter-date-range @filterchanged="filterChanged"></filter-date-range>
        <div id="viewReport" >
            <div class="btn btn-primary" @click="updateReport">Voir le rapport</div>
        </div>

    </div>
	<div >
	<div id=divResult runat=server  ClientIDMode=Static  enableviewstate=false>
		<h3>Résultat</h3>
		 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
    	google.load("visualization", "1", { packages: ["corechart"] });
    	google.setOnLoadCallback(drawChart);
    	function drawChart() {
    		var data = google.visualization.arrayToDataTable([
			  ['# vente', 'Référence'],
          <%= DataSalesPerReferral %>
        ]);

      	var formatter = new google.visualization.NumberFormat({ prefix: '$' });
      	formatter.format(data, 1);
      	var options = { title: 'Vente', is3D: true };
      	var chart = new google.visualization.PieChart(document.getElementById('chartSalesValue'));
      	chart.draw(data, options);
      }
	</script>
		<div id="chartSalesValue" style="width: 600px; height: 300px;"></div>
		<table class=sssGrid>
			<thead>
				<tr><td>Référence</td><td>Montant vendu</td><td>Nombre ventes</td><td>Vente moyenne</td></tr>
			</thead>
			<tbody>
				<%= DataTableSales %>
			</tbody>
		</table>
		 
	</div>

	<h3>Configuration</h3>
		<asp:CheckBox ID="chkAskReferral" ClientIDMode=Static runat="server" Text="Demander la source dans Comelin" />
	
	<ul class="sortable" id=divReferral style="width:350px; margin:20px 0">
  <li class="ui-state-default"  ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(0) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(1) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(2) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(3) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(4) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(5) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(6) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(7) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(8) %>" /></li>
  <li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(9) %>" /></li>
	<li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(10) %>" /></li>
	<li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(11) %>" /></li>
	<li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(12) %>" /></li>
	<li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(13) %>" /></li>
	<li class="ui-state-default" ><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><input type=text value="<%= Choice(14) %>" /></li>
</ul>
 Un choix "autre" sera ajouté à votre liste.<br /><br />

	<span class=button id=cmdSave onclick="saveOrder()">Sauvegarder</span>
	</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
        <%= this.JsInclude("/admin/js/components/report.js")  %>
	<script type="text/javascript">
        var appReferral = new Vue({
			el:'#appReferral',
			methods: {
                filterChanged() {
                    this.dirty = computeSearchUrl(this.$children) !== document.location.search;
                },
                updateReport() {
                    redirectWithFilter(this.$children);
                },
		        
		    }
        });
		$(function () {
			$(".sortable").sortable({
				axis: 'y',
				update: function () {
					enableSave();
				}
			});
			$('#chkAskReferral').change(function () {
				if ($('#chkAskReferral').is(":checked")) {
					$('#divResult').show('slow');
				} else {
					$('#divResult').hide('slow');
				}
				enableSave();
			});
			$('#divReferral li input').keydown(function () {
				enableSave();
			});

			$('.sssGrid').dataTable({
			  "aaSorting": [[ 1, "desc" ]],
				});

		});

		function enableSave() {
			//$('#cmdSave').show('slow');
		}

		function saveOrder() {
			var strOrder ='';
			$("#divReferral li input").each(function() {
				if (strOrder != '') {
					strOrder += '|';
				}
				strOrder += $(this).val();
			});
			$.post('AjaxReferral.ashx?enable=' + $('#chkAskReferral').is(":checked"), strOrder);
			$("#cmdSave").notify('sauvegarder');
		}
	
    </script>
</asp:Content>
