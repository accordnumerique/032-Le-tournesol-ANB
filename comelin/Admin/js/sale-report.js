// for page /admin/report/sales.aspx


Vue.component('report-grouping', {
    template: `<div>
    <div class="title">{{label}}:</div>
    <div class="options">
        <div class="report-data-grouping-options"><div class="btn-group">
        <div v-if=!required class="button None" @click="setGrouping(GroupingNone, $event)">Pas de regroupement</div>
        <div v-if="showadj" class="button Adjustment" @click="setGrouping('Adjustment', $event)">par type d'ajustement d'inventaire</div>
        <div class="button Cat1" @click="setGrouping('Cat1', $event)">par catégorie primaire</div>
        <div class="button Cat2" @click="setGrouping('Cat2', $event)">par catégorie complète</div>
        <div class="button Brand" @click="setGrouping('Brand', $event)">par marque</div>
        <div class="button Supplier" @click="setGrouping('Supplier', $event)">par fournisseur</div>
        <div class="button Matrix" @click="setGrouping('Matrix', $event)">par produit (modèle)</div>
        <div class="button Product" @click="setGrouping('Product', $event)">par produit (individuel)</div>
        <div class="button Attrib" @click="setGrouping('Attrib', $event)">par champs personnalisé</div>
        <attrib-select v-if="grouping && grouping.Type == 'Attrib'" :attribselected=grouping.IdAttrib disabledvalue=true @attribselected=setGroupingAttrib></attrib-select>
        </div></div>
     </div>
</div>`,
    props: ['selected', 'required', 'instance', 'label', 'showadj', 'groupingInit'],
    data: function () {
        return {
            grouping: null, // data structure GroupedByInfo with Type and IdAttrib just in C#
            title: null
        }
    },
    watch: {
        selected: function() {
            var selectedValue = this.selected;
            if (typeof selectedValue !== 'object' || selectedValue === null) {
                if (typeof selectedValue === 'string') {
                    selectedValue = JSON.parse(selectedValue); // not sure why but the prop is sometimes parse as string
                }
            }
            // copy props to data
            if (selectedValue) {
                this.grouping = selectedValue;
            } else {
                this.grouping = { Type: GroupingNone};
            }
        },
        grouping: function() {
            this.updateButtonCss();
            this.$emit('set-grouping', this.grouping, this.title);
        }
    },
    methods: {
        setGrouping(grouping, eventObject) {
            this.grouping = { Type: grouping};
            this.$emit('filterchanged');
        },
        setGroupingAttrib(idAttrib, eventObject) {
            this.grouping = { Type: 'Attrib', IdAttrib: idAttrib};
            this.$emit('filterchanged');
        },
        updateButtonCss() {
            var jQueryThisComponent = $(this.$el);
            jQueryThisComponent.find('.button').removeClass('btn-info');

            var selector = '.button.';
            if (this.grouping) {
                selector += this.grouping.Type;
            } else {
                selector += GroupingNone;
            }
            btn = jQueryThisComponent.find(selector);
            btn.addClass('btn-info');
            this.title = btn.text();
        },
        getQueryString() {
            if (this.grouping && this.grouping.Type !== GroupingNone) {
                return this.queryStringGroup + "=" + groupingToUrl(this.grouping);
            }
        }
    },
    mounted() {
        this.queryStringGroup = 'group' + this.instance;
        this.GroupingNone = GroupingNone; // constant value
        this.grouping = urlToGrouping(GetQueryStringAsString(this.queryStringGroup, this.groupingInit));
        this.updateButtonCss();
    }
});

var _dataTable;

const localSettingDisplaySupplierOrder = 'app-report-sale-displaySupplierOrders';
appReport = new Vue({
    el: '#app-report-sale',
    data: {
        entries: null, // downloaded
        dataTableCreated: false,
        groupTitle: null,
        subGroupTitle: null,
        displayProductCode: false,
        displayBarcodes: window._displayBarcodes,
        title: 'Rapport de vente',
        displaySupplierOrders: false,
        dirty: false,
        totalProfit: 0,
        totalSell: 0,
        isMultiStore: window._multistore
    },
    watch: {
        displaySupplierOrders() {
            if (this.displaySupplierOrders) {
                window.localStorage[localSettingDisplaySupplierOrder] = this.displaySupplierOrders;    
            } else {
                window.localStorage.removeItem(localSettingDisplaySupplierOrder);
            }
            
        }
    },
    methods: {
        filterChanged() {
            this.dirty = computeSearchUrl(this.$children) !== document.location.search;
        },
        updateReport() {
            redirectWithFilter(this.$children);
        },
        NumberToQuantity(input, type) {
            return NumberToQuantity(input, type);
        },
        NumberToAmount(input, type) {
            return NumberToAmount(input, type);
        },
        mergeEntry(lst) {
            var result = {};
            result.OrderQty = 0;
            result.OrderTotalCost = 0;
            result.OrderTotalSold = 0;

            result.BuyQty = 0;
            result.BuyTotalCost = 0;
            result.BuyTotalSold = 0;

            result.InvQty = 0;
            result.InvTotalCost = 0;
            result.InvTotalSold = 0;

            result.SellQty = 0;
            result.SellCost = 0;
            result.SellSold = 0;
            result.SellRebate = 0;

            for (var i = 0; i < lst.length; i++) {
                var e = lst[i];
                addToElement(result, e, 'OrderQty');
                addToElement(result, e, 'OrderTotalCost');
                addToElement(result, e, 'OrderTotalSold');

                addToElement(result, e, 'BuyQty');
                addToElement(result, e, 'BuyTotalCost');
                addToElement(result, e, 'BuyTotalSold');

                addToElement(result, e, 'InvQty');
                addToElement(result, e, 'InvTotalCost');
                addToElement(result, e, 'InvTotalSold');

                addToElement(result, e, 'SellQty');
                addToElement(result, e, 'SellCost');
                addToElement(result, e, 'SellSold');
                addToElement(result, e, 'SellRebate');
            }
            this.addPropertyToEntry(result);
            return result;
        },
        addPropertyToEntry(e) {
            e.SellNet = e.SellSold - e.SellRebate; // #11
            e.SellProfit = e.SellNet - e.SellCost; // #12
            e.SellPercentageSold = this.computeSalePercentage(e); // #13
            e.SellMarkup = SafeDivision(e.SellProfit, e.SellNet);
            this.addGlobalPropertyToEntry(e);
        },
        addGlobalPropertyToEntry(e) {
            e.PercentageProfit = SafeDivision(e.SellProfit, this.totalProfit);
            e.PercentageTurnover = SafeDivision(e.SellNet, this.totalSell);
        },


        computeSalePercentage(e) {
            var v = SafeDivision(e.SellQty, e.BuyQty);
            if (v > 1) {
                v = 1; // avoid displaying a > 100% sold, doesn't make sense
            }
            return v;
        },
        
        downloadData() {
            let c = this;
            fetchPost('/admin/api/report/buy-inv-sell/' + document.location.search, null, '.report-data-grouping-options', data => {
                c.displayProductCode = data.DisplayProductCode;
                c.entries = data.Groups;
                c.title = data.Title;
                document.title = data.Title;
                c.groupTitle = data.GroupByTitle;
                c.subGroupTitle = data.SubGroupTitle;
                c.subGrouping = data.SubGroup;
                if (c.dataTableCreated) {
                    _dataTable.clear().rows.add(data.Presentations).draw(); // table already created, just update the source
                }
            });
        }
    },
    mounted() {
        if (window.localStorage[localSettingDisplaySupplierOrder]) {
            this.displaySupplierOrders = true;
        }
        if (!this.dirty) { // do not download if nothing is selected
            this.downloadData(); // will fetch the data using the query string
        }
    },
    updated() {
        if (!this.dataTableCreated && this.entries) {
            // calculate  computed value
            this.totalProfit = 0;
            this.totalSell = 0;

            for (var e of this.entries) {
                if (!e.SellSold) {
                    e.SellSold = 0;
                }
                if (!e.SellRebate) {
                    e.SellRebate = 0;
                }
                if (!e.SellCost) {
                    e.SellCost = 0;
                }
                if (!e.BuyQty) {
                    e.BuyQty = 0;
                }
                this.addPropertyToEntry(e);
                this.totalSell += e.SellNet;
                this.totalProfit += e.SellProfit;
            }


            // The global properties must be recalculate using the big total from all the rows
            for (var e of this.entries) {
                this.addGlobalPropertyToEntry(e);
            }



            if (this.displayProductCode === undefined) {
                this.displayProductCode = false; // this is required so the columns can be hidden
            }
            _dataTable = $('#table').DataTable({
                data: this.entries,
                columns: [
                    {
                        data: 'Group',
                        class: 'text-left',
                        orderable: false,
                        width: '300px',
                        visible: !this.subGrouping
                    },
                    {
                        data: 'SubGroup',
                        class: 'text-left',
                        orderable: false,
                        width: '300px',
                        defaultContent: '',
                        visible: this.subGrouping !== null
                    },
                    {
                        data: 'Code',
                        class: 'text-left',
                        orderable: true,
                        width: '100px',
                        defaultContent: '',
                        visible: this.displayProductCode
                    },
                    {
                        data: 'CodeSupplier',
                        class: 'text-left',
                        orderable: true,
                        width: '100px',
                        defaultContent: '',
                        visible: this.displayProductCode
                    },
                     {
                        data: 'Barcode',
                        class: 'text-left',
                        orderable: true,
                        width: '100px',
                        defaultContent: '',
                        visible: this.displayBarcodes
                    },

                    {
                        data: 'OrderQty', defaultContent: '', class: 'border-left', render: NumberToAmountNoDecimal, visible:this.displaySupplierOrders
                    },
                    {
                        data: 'OrderTotalCost', defaultContent: '', render: NumberToAmountNoDecimal, visible:this.displaySupplierOrders
                    },
                    {
                        data: 'OrderTotalSold', defaultContent: '', render: NumberToAmountNoDecimal, visible:this.displaySupplierOrders
                    },

                    {
                        data: 'BuyQty', defaultContent: '', class: 'border-left', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'BuyTotalCost', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'BuyTotalSold', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'InvQty', defaultContent: '', render: NumberToAmountNoDecimal, class: 'border-left'
                    },
                    {
                        data: 'InvTotalCost', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'InvTotalSold', defaultContent: '', render: NumberToAmountNoDecimal, class: 'border-right'
                    },
                    {
                        data: 'SellQty', defaultContent: '', render: NumberToAmountNoDecimal, class: 'border-left'
                    },
                    {
                        data: 'SellCost', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'SellSold', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'SellRebate', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'SellNet', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'SellProfit', defaultContent: '', render: NumberToAmountNoDecimal
                    },
                    {
                        data: 'SellPercentageSold', defaultContent: '', render: NumberToPercentage, class: 'border-right'
                    },
                    {
                        data: 'SellMarkup', defaultContent: '', render: NumberToPercentage
                    },
                    {
                        data: 'PercentageProfit', defaultContent: '', render: NumberToPercentage
                    },
                    {
                        data: 'PercentageTurnover', defaultContent: '', render: NumberToPercentage
                    }
                ],
                rowGroup: {
                    startRender: function (rows, group) {
                        if (!appReport.subGrouping) {
                            return; // don't display subgroup
                        }
                        var row = $('<tr/>');
                        var nbColumns = appReport.displayProductCode ? 4 : 1;
                        row.append('<td colspan="' + nbColumns+ '">' + appReport.groupTitle + ': ' + group + '</td>');
                        var d = rows.data();
                        var mergeData = appReport.mergeEntry(d);

                        if (appReport.displaySupplierOrders) {
                            row.append('<td>' + NumberToAmountNoDecimal(sumOfArray(d, 'OrderQty')) + '</td>');
                            row.append('<td>' + NumberToAmountNoDecimal(sumOfArray(d, 'OrderTotalCost')) + '</td>');
                            row.append('<td>' + NumberToAmountNoDecimal(sumOfArray(d, 'OrderTotalSold')) + '</td>');
                        }

                        row.append('<td>' + NumberToAmountNoDecimal(sumOfArray(d, 'BuyQty')) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(sumOfArray(d, 'BuyTotalCost')) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(sumOfArray(d, 'BuyTotalSold')) + '</td>');

                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.InvQty) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.InvTotalCost) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.InvTotalSold) + '</td>');

                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.SellQty) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.SellCost) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.SellSold) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.SellRebate) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.SellNet) + '</td>');
                        row.append('<td>' + NumberToAmountNoDecimal(mergeData.SellProfit) + '</td>');
                        row.append('<td>' + NumberToPercentage(mergeData.SellPercentageSold) + '%</td>');

                        row.append('<td>' + NumberToPercentage(mergeData.SellMarkup) + '%</td>');
                        row.append('<td>' + NumberToPercentage(mergeData.PercentageProfit) + '%</td>');
                        row.append('<td>' + NumberToPercentage(mergeData.PercentageTurnover) + '%</td>');
                        return row;
                    },
                    dataSrc: 'Group',
                    enable: this.subGrouping
                },
                order: [],
                footerCallback: function (row, data, start, end, display) {
                    var api = this.api();
                    for (var i = 5; i <= 18; i++) {
                        var total = sum(api.column(i).data());
                        $(api.column(i).footer()).html(NumberToAmountNoDecimal(total));
                    }
                }
            });
            this.dataTableCreated = true;
        }
    }
});

