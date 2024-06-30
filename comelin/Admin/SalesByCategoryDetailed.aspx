<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SalesByCategoryDetailed.aspx.cs" Inherits="WebSite.Admin.SalesByCategoryDetailed" %>
<%@ register src="~/Admin/ucDateRangePicker.ascx" tagprefix="uc1" tagname="ucDateRangePicker" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://unpkg.com/vue-select@latest"></script>
    <link rel="stylesheet" href="https://unpkg.com/vue-select@3.11.2/dist/vue-select.css" />
	<style>
		#grid_wrapper {margin-top: 20px}
		@media print {
			#grid_wrapper {font-size: 10px;margin-top: 0 }
		}
		#grid .alignRight { text-align: right !important}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Sommaire des ventes par produit</h1>

	<div class="no-print">
		<div id="app-filter-custom-fields">
			

			Champs personnalisés: 
            <v-select id="lstCustomField" v-model="customFieldSelectedId" :options="customFields" label="Title" :reduce="att => att.Id">
            </v-select>
			<v-select v-if="customFieldSelected" v-model="customFieldsValueSelected" id="lstCustomFieldValues" :options="customFieldSelected.Values" multiple="multiple" label="Text" :reduce="att => att.Id">
			</v-select>
        </div>
		<input type="checkbox" id="chkGroupByVariant" /><label for="chkGroupByVariant">Regrouper par modèle de produit (matrice). Les produits aux volumes seront afficher en KG</label>
        <br/>
		<asp:DropDownList runat="server" ID="lstStore" ClientIDMode="Static"/>
		<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" FilterByCategory="true" FilterByBrand="True"  />
		
	</div>

	<table id="grid" style="display: none; width: 100%">
		<thead>
			<tr>
				<th>Code</th>
				<th>Marque</th>
				<th>Description</th>
				<th>$ inventaire</th>
				<th>Qté inventaire</th>
				<th>Qté vendue</th>
				<th>$ vente</th>
				<th>$ coûtant</th>
				<th>% profit</th>
				<th>Qté commandée</th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<th></th>
				<th></th>
				<th></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
				<th class="alignRight"></th>
			</tr>
		</tfoot>
	</table>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">


	<script>
        $$('chkGroupByVariant').checked = $.query.get('group');
        var originalValueFromQueryString = $.query.get('attribValues');
        var vmFilterCustomFields = new Vue({
            el: '#app-filter-custom-fields',
            data: {
                customFields: window._customFields,
                customFieldSelectedId: null, // window._customFieldsSelected  // key = id custom field, value = array of short (id of the values)
                customFieldSelected: null, // window._customFieldsSelected  // key = id custom field, value = array of short (id of the values)
                customFieldsValueSelected: [] // array of value selected

            },
            watch: {
                customFieldSelectedId: function (newValue, oldValue) {
                    this.customFieldSelected = this.getAttrib(newValue);
                    if (oldValue) {
                        this.customFieldsValueSelected = []; // clear previous selection  
                    }
                }
            },
            methods: {
                getAttrib : function(strId) {
                    const id = parseInt(strId);
                    return this.customFields.find(c => c.Id === id);
                },
            },
            mounted: function () {
                this.customFieldSelectedId = $.query.get('attrib');
                const valueSelected = $.query.get('attribValues');
                if (valueSelected) {
                    this.customFieldsValueSelected = JSON.parse(valueSelected);    
                }
            }
        });

        function GetUrlExtra() {
            if (vmFilterCustomFields.customFieldSelectedId > 0) {
                $.query.SET('attrib', vmFilterCustomFields.customFieldSelectedId);
                if (vmFilterCustomFields.customFieldsValueSelected.length !== 0) {
                    $.query.SET('attribValues', JSON.stringify(vmFilterCustomFields.customFieldsValueSelected));
                } else {
                    $.query.REMOVE('attribValues');
                }
            } else {
                $.query.REMOVE('attrib').remove('attribValues');
            }
            $.query.SET('group', $$('chkGroupByVariant').checked);
        }

        $('#grid').show().DataTable({
            ajax: '/<%= WebSite.Admin.SalesByCategoryHandler.Url %>' + window.location.search,
            sAjaxDataProp: null,
            columns: [
                { data: "Code", defaultContent: '' },
                { data: "Brand", defaultContent: '' },
                { data: "Title", defaultContent: '' },
                { data: "InventoryValue", defaultContent: '', sClass: 'alignRight', render: NumberToAmount },
                { data: "Inventory", defaultContent: '', sClass: 'alignRight', render: NumberToQuantity },
                { data: "QtySold", defaultContent: '', sClass: 'alignRight', render: NumberToQuantity },
                { data: "AmtSold", defaultContent: '', sClass: 'alignRight', render: NumberToAmount},
                {
                    data: "Cost",
                    defaultContent: '',
                    render: NumberToAmount,
                    sClass: 'alignRight'
                },
                {  /* profit */
                    data: null,
                    sClass: 'alignRight',
                    render: {
                        "_": function (row) {
                            if (row.Cost === 0) {
                                return 0;
                            }
                            return ((row.AmtSold - row.Cost) / row.AmtSold * 100).toFixed(0);
                        }
                    }
                },
                {
                    data: "QtyReceived",
                    defaultContent: '',
                    sClass: 'alignRight'
                }
            ],
            order: [[0, 'asc']],
            footerCallback: function (row, data, start, end, display) {
                var api = this.api();

                var count = api.column(0).data().length;
                $(api.column(2).footer()).html(count + ' produits');

                var totalInv = api.column(3).data().reduce(function (a, b) { return a + b; }, 0);
                $(api.column(3).footer()).html(NumberToAmount(totalInv));

                var totalInv = api.column(4).data().reduce(function(a, b) { return a + b; }, 0);
                $(api.column(4).footer()).html(roundToTwo(totalInv));

                var totalQtySold = api.column(5).data().reduce(function (a, b) { return a + b; }, 0);
                $(api.column(5).footer()).html(NumberToQuantity(totalQtySold));

                var totalSale = api.column(6).data().reduce(function (a, b) { return a + b; }, 0);
                $(api.column(6).footer()).html(NumberToAmount(totalSale));

                var totalCost = api.column(7).data().reduce(function (a, b) { return a + b; }, 0);
                $(api.column(7).footer()).html(NumberToAmount(totalCost));

                var profit = 0;
                if (totalCost !== 0) {
                    profit = ((totalSale - totalCost) / totalSale * 100);
                }
                $(api.column(8).footer()).html(profit.toFixed(0));

                $(api.column(9).footer()).html(api.column(9).data().reduce(function (a, b) { return a + b; }, 0));
            }
        });


        function roundToTwo(num) {    
            return +(Math.round(num + "e+3")  + "e-3");
        }
    </script>
</asp:Content>
