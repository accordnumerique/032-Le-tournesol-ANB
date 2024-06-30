// script for Sales details page
var appSalesDetails = new Vue({
    el: '#appSalesDetails',
    data: {
        entries: null, // downloaded
        dataTableCreated: false,
        dirty: false,
        total: 0
    },
    methods: {
        filterChanged() {
            this.dirty = computeSearchUrl(this.$children) !== document.location.search;
        },
        updateReport() {
            redirectWithFilter(this.$children);
        }
    }
});


$.ajax(_urlQuery + window.location.search).done(function(result) {
    var total = NormalizedData(result);
	$$('total').innerHTML = NumberToAmount(total);
	$('.sssGrid').dataTable({
		data: result,
		paging:false,
		order: [[0, 'desc'], [3, 'asc']],
		columns: [
            { data: "Date", render: FormatPropDateTimeAgo },
			{
				"data": null,
				"render": {
					"_": "Invoice",
					"display": function(row) {
						return '<a href="' + row.WebUrl + '">' + row.Invoice + '</a>';
					}
				}
			},
			{ data: 'Store', visible: window._multistore },
			{ data: 'Employee', defaultContent : ''},
            { data: 'Name'},
            { data: 'Qty', sClass:'alignRight' },
            { data: 'Title' },
            { data: 'Category', defaultContent : ''},
			{ data: 'Price', render:NumberToAmount , sClass:'alignRight'},
            {
				data: null,
				render: {
					"_": "RebatePercentage",
					"filter": "RebatePercentage_display",
					"display": "RebatePercentage_display"
				}, sClass:'alignRight'
			},
            { data: 'Cost', render:NumberToAmount , sClass:'alignRight'},
			{
				data: null,
				render: {
					"_": "Profit",
					"filter": "Profit_display",
					"display": "Profit_display"
				}, sClass:'alignRight'
			},
			{ data: 'Info', sClass:'nowrap' }
		],
		footerCallback: function (row, data, start, end, display) {
			var api = this.api();
            $(api.column(0).footer()).html(end + ' factures');
            DataTableSumColumn(api, 5, NumberToQuantity);
            DataTableSumColumn(api, 8, NumberToAmount);
            DataTableSumColumn(api, 10, NumberToAmount);
        }
	});
});

function NormalizedData(result) {
    var total = 0;
    // fix empty value and compute stuff
    for (var i = 0; i < result.length; i++) {
        var row = result[i];
        if (!row.Name) {
            row.Name = '';
        }
        if (!row.Price) {
            row.Price = 0;
        }
        if (!row.Cost) {
            row.Cost = 0;
        }
        if (!row.RebatePercentage) {
            row.RebatePercentage = 0;
            row.RebatePercentage_display = '';
        } else {
            row.RebatePercentage_display = (row.RebatePercentage * 100).toFixed(1) + '%';
        }
        if (row.Price > 0 && row.Cost !== 0) {
            row.Profit = ((row.Price - row.Cost) / row.Price);	
        } else {
            row.Profit = 0;
        }
        if (!row.Cost) {
            row.Cost = 0;
        }
        if (row.Profit) {
            row.Profit_display = (row.Profit * 100).toFixed(1) + '%';
        } else {
            row.Profit_display = row.Profit = '';
        }
        // info field
        row.Info = '';
        if (row.IsWeb) {
            row.Info += '<span class="web" title="Vente web"></span>';
        }
        if (row.IsInactiv) {
            row.Info += '<span class="inactiv" title="Dernier vendu"></span>';
        }
        if (row.IsOutOfStock) {
            row.Info += '<span class="outofstock" title="En rupture d\'inventaire"></span>';
        }
        total += row.Price;
    }
    return total;
}

