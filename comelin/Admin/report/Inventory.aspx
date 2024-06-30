<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="WebSite.Admin.report.Inventory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="/Admin/js/components/report.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="app-inventory">
        <h1>{{title}}</h1>
        <div class="box">
            <div class="title">Valeur total de l'inventaire</div>
            <div class="value">{{NumberToAmount(total)}}</div>
        </div>
        <report-grouping @set-grouping="setGrouping"></report-grouping>


    <table id="table" v-if="entries">
        <thead>
        <tr>
            <td class="ct">{{groupTitle}}</td>
            <template v-for="s in stores"><td>{{s}} <br/>Qté</td><td>{{s}} <br/>valeur achat</td><td>{{s}} <br/>valeur vente</td></template>
            <template v-if="stores.length > 1"><td>Total <br/>Qté</td><td>Total <br/>valeur achat</td><td>Total <br/>valeur vente</td></template>
        </tr>
        </thead>
        <tfoot>
        <tr>
            <td></td>
            <template v-for="s in stores"><td></td><td></td><td></td></template>
            <template v-if="stores.length > 1"><td><br/></td><td> <br/></td><td> <br/></td></template>
        </tr>
        </tfoot>
    </table>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <script src="/Admin/js/sale-report.js"></script>
    <script>
        var _dataTable;
        appInventory = new Vue({
            el: '#app-inventory',
            data: {
                entries: null, // downloaded
                stores: null,
                total: 0,
                grouping: null,
                groupTitle:'Par catégorie primaire',
                dataTableCreated: false,
                title: 'Rapport d\'inventaire'
            },
            watch: {
                presentationType: function(newValue) {
                    downloadData(newValue);
                    document.title = this.title = 'Rapport d\'inventaire ' + this.groupTitle.toLowerCase() + ' ' + moment().format('LL');
                }
            },
            methods: {
                setGrouping(grouping, btn) {
                    downloadData(grouping);
                    this.groupTitle = btn;
                    this.grouping = grouping;
                },
                NumberToQuantity(input, type) {
                    return NumberToQuantity(input, type);
                },
                NumberToAmount(input, type) {
                    return NumberToAmount(input, type);
                }
            },
            mounted() {
                if (!this.presentationType) {
                    this.presentationType = 'Cat1'; // default filtering
                }
            },
            updated() {
                if (!this.dataTableCreated && this.entries) {
                    var columns = [
                        { data: "Title", defaultContent: '', orderable:true }
                    ];
                    for (let i = 0; i < appInventory.stores.length; i++) {
                        columns.push({ data: function (row, type, val, meta) { return row.Stores[i].NbItems; }, 
                            defaultContent: '', render: NumberToQuantity }); 
                        columns.push({ data: function (row, type, val, meta) { return row.Stores[i].Cost; }, 
                            defaultContent: '', render: NumberToAmount }); 
                        columns.push({ data: function (row, type, val, meta) { return row.Stores[i].Sale; }, 
                            defaultContent: '', render: NumberToAmount }); 
                    }
                    if (this.stores.length > 1) {
                        // add total columns
                        columns.push({ data: function (row, type, val, meta) { return sum(row.Stores, 'NbItems');
                        }, defaultContent: '', render: NumberToQuantity }); 
                        columns.push({ data: function (row, type, val, meta) { return sum(row.Stores, 'Cost');
                        }, defaultContent: '', render: NumberToAmount }); 
                        columns.push({ data: function (row, type, val, meta) {  return sum(row.Stores, 'Sale');
                        }, defaultContent: '', render: NumberToAmount }); 
                    }
                    _dataTable = $('#table').DataTable({
                        data: this.entries,
                        columns: columns,
                        order:[],
                        footerCallback: function (row, data, start, end, display) {
                            var api = this.api();
                            for (var i = 1; i < api.columns()[0].length; i++) {
                                var total = sum(api.column(i).data());
                                if ((i-1) % 3 === 0) {
                                    total = NumberToQuantity(total);
                                } else {
                                    total = NumberToAmount(total);
                                }
                                $(api.column(i).footer()).html(total); 
                            }
                        }
                    });
                    this.dataTableCreated = true;
                }
            }
        });
        function downloadData(grouping) {
            fetchPost('/admin/api/inventory/report/?type=' + groupingToUrl(grouping), null, '.report-data-grouping-options', data => {
                appInventory.stores = data.Stores;
                appInventory.entries = data.Presentations;
                appInventory.total = data.Total;
                appInventory.title = data.Title;
                if (appInventory.dataTableCreated) {
                    // table already created, just update the source
                    _dataTable.clear().rows.add(data.Presentations).draw();
                }
            });
        }

    </script>
    <style>
        
        #table {width: 100% !important; }
        #table tbody td {text-align: right}
        #table .ct {text-align: left}
        #table thead{background-color: rgb(232, 232, 232); text-align: right}
        #table tfoot {background-color: rgb(58, 58, 58); color:white; text-align: right}
        .group-col-store {border: 2px solid black}

        .box{background-color: #eee; margin: 20px 0; text-align: center; max-width: 400px}
        .box .title {background-color: #ccc; padding:5px}
        .box .value {padding:20px}
    </style>
</asp:Content>
