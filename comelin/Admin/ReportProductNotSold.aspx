<%@ Page Title="Rapport de produits non vendus" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ReportProductNotSold.aspx.cs" Inherits="WebSite.Admin.ReportProductNotSold" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
		<h1><img alt="" src="images/report-product-not-sold.png" /> Rapport de produits non vendus</h1>
	<br />
<label for="from">Depuis le</label>
<input type="date" id="from" name="from">
<select id=lstStore runat=server ClientIDMode=Static>
	<option value=0>Tous</option>
</select>
<div class=button id=cmdDisplay >Afficher</div><br /><br />
	<table id=table style="width:100%; display:none" class=sssGrid>
	<thead><tr><th style="width:200px">Code</th><th>Marque</th><th>Description</th><th>Date création</th><th>Dernière vente</th><th>Dernière réception</th><th>Qté</th><th>Coût</th><th>Total</th></tr></thead>
		
		<tfoot>
			<tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th>
			</tr>
		</tfoot>
	</table>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script type="text/javascript">
		function GetUrl() {
			// redirect with querystring
			var idStore = $('#lstStore').val();
			var url = 'ReportProductNotSold.aspx?from=' + $$("from").value;
			if (idStore) {
				url += '&idStore=' + idStore;
			}
			return url;
		};

		$(function () {
			var strFrom = GetQueryStringAsString('from');
			if (strFrom != '') {
				$$("from").value = strFrom;
			} else {
				var dateBeginMonth = new Date();
				dateBeginMonth.setDate(1);
				$$("from").valueAsDate = dateBeginMonth;
			}

			$('#lstStore').val(GetQueryStringAsString('idStore'));

			if (strFrom != '') {
				DisplayResult();
			}

		});

		function DisplayResult() {
            $('#table').show().DataTable({
                ajax: '/admin/api/report/product-not-sold'  + window.location.search,
                sAjaxDataProp: null,
                columns: [
                    { data: "Code", defaultContent: '' },
                    { data: "CategoryBrandStr", defaultContent: '' },
                    { data: "Title", defaultContent: '' },
                    { data: "DateCreated", render:GridFormatDate  },
                    { data: "DateSales", defaultContent: '', render:GridFormatDate  },
                    { data: "DateReStocked", defaultContent: '', render:GridFormatDate },
                    { data: "Inv", defaultContent: 0, sClass: 'alignRight', render:NumberToQuantity },
                    { data: "Cost",  defaultContent: 0, sClass: 'alignRight', render: NumberToAmount },
                    {  /* total */
                        data: null,
                        sClass: 'alignRight',
                        render: {
                            "_": function (row, type) {
                                return NumberToAmount(row.Cost * row.Inv, type);
                            }
						}
                    }
                ],
                order: [[4, 'asc'], [3, 'asc'], [0, 'asc']],
                footerCallback: function (row, data, start, end, display) {
                    var api = this.api();
                    DataTableSumColumn(api, 8, NumberToAmount, (r) => r.Cost * r.Inv);
                    DataTableSumColumn(api, 6, NumberToQuantity);
                }
            });
		
		}

	</script>
</asp:Content>
