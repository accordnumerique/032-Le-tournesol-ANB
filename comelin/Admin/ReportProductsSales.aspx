<%@ Page Title="Raport de vente de produits" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ReportProductsSales.aspx.cs" Inherits="WebSite.Admin.ReportProductsSales" %>

<%@ Register Src="~/Admin/ucDateRangePicker.ascx" TagPrefix="uc1" TagName="ucDateRangePicker" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
		<h1><img alt="" src="images/report-products.png" /> Rapport de vente de produits spécifiques</h1>
	<br />
<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
	<br /><br />
	
	

	<table id=table style="width:100%; display:none" class=sssGrid>
	<thead><tr><th style="width:120px">Code</th><th style="width:30%">Titre</th><%= StoresHeader %></tr></thead>
	<tfoot>
		<tr><th></th><th></th><%= StoresHeader %></tr>
	</tfoot>
	</table>
	<br /><br />
	<div class="btn btn-primary" id=lnkConfig data-toggle="modal" data-target="#dialogConfigureProduct">modifier la liste des produits affichés</div>
	
	
	<div id=dialogConfigureProduct  class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Configuration des produits rapportés</h4>
      </div>
      <div class="modal-body">
        <p><asp:TextBox runat="server" ID=txtCodes Rows="10" TextMode="MultiLine" Width="236px"></asp:TextBox></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
  <asp:Button runat="server" Text="Sauvegarder" ID="cmdSave" onclick="cmdSave_Click" />
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script type="text/javascript">

		$('#lnkConfig').click(function() {
			var dlg = $('#dialogConfigureProduct').dialog({ modal: true });
			dlg.parent().appendTo($("form:first")); // for postback
		});

		$(function () {
			var strFrom = GetQueryStringAsString('from');
			var strTo = GetQueryStringAsString('to');

			if (strFrom != '' && strTo != '') {
				DisplayResult();
			}
		});

		$('#cmdDisplay').click(function () {
			// redirect with querystring
			window.location = 'ReportProductsSales.aspx?from=' + $$("from").value + '&to=' + $$("to").value;
		});

		function DisplayResult() {
			$('#table').show().dataTable({
				sAjaxSource: 'AjaxProductsSales.ashx' + window.location.search,
				aaSorting: [ [0, 'asc']],
				aoColumnDefs: [
					{ aTargets: [2], "sClass": "alignRight" },
					{ aTargets: [3], "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 3); } }
					<%= StoresDataColumnRender %>
				],
				fnFooterCallback: function(oFooter, aaData, iStart, iEnd, aiDisplay) {
					for (var i = 2; i < oFooter.childElementCount; i++) {
						var total = 0;
		   			for (var iRow = aaData.length - 1; iRow >= 0; iRow--) {
							var rgData = aaData[aiDisplay[iRow]];
							total += rgData[i];
						}
						// Modify the footer row to display the sums
						var rgCells = oFooter.getElementsByTagName('th');
						if ((i % 2) == 0) {
							rgCells[i].innerHTML = total;
						} else {
							rgCells[i].innerHTML = total.toFixed(2);
						}
					}
				}
			});
		}

	</script>
</asp:Content>
