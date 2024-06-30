// report for customer

/* Filter online only */
Vue.component('filter-online-only', {
    template:`<label><input type="checkbox" v-model=isOnlineOnly />ventes en ligne seulement</label>`,
    data() {
        return {
            isOnlineOnly: false
        }
    },
    watch: {
        isOnlineOnly(n, o) {
            this.$emit('filterchanged');
        }
    },
    methods: {
        getQueryString() {
            if (this.isOnlineOnly) {
                return this.queryString + '=' + this.isOnlineOnly;
            }
        },
        parseFromQueryString() {
            this.isOnlineOnly = GetQueryStringAsBool(this.queryString);
        }
    },
    mounted() {
        this.queryString = 'online';
        this.parseFromQueryString();
        var c = this;
        window.addEventListener("popstate", () => { c.parseFromQueryString(); });
    }
});


/* Filter by code */
Vue.component('filter-by-product-code', {
    template:`<input type="text" v-model=productSelected placeholder="code de produit" class="form-control" style="width: 200px; display: inline-block"  />`,
    data() {
        return {
            productSelected: null
        }
    },
    watch: {
        productSelected(n, o) {
            this.$emit('filterchanged');
        }
    },
    methods: {
        getQueryString() {
            if (this.productSelected && this.productSelected.length > 0) {
                return this.queryString + '=' + this.productSelected;
            }
        },
        parseFromQueryString() {
            this.productSelected = GetQueryStringAsString(this.queryString);
        }
    },
    mounted() {
        this.queryString = 'product';
        this.parseFromQueryString();
        var c = this;
        window.addEventListener("popstate", () => { c.parseFromQueryString(); });
    }
});

/* filter by min amount */
Vue.component('filter-amount', {
    template:`<div class="input-group" style="width: 200px;display: inline-flex;">
		<input type="text" class="form-control" v-model="amount" />
		<div class="input-group-append"><span class="input-group-text">$</span></div> 
	</div>`,
    data() {
        return {
            amount: null
        }
    },
    watch: {
        amount(n, o) {
            this.$emit('filterchanged');
        }
    },
    methods: {
        getQueryString() {
            if (this.amount && this.amount.length > 0) {
                return this.queryString + '=' + this.amount;
            }
        },
        parseFromQueryString() {
            this.amount = GetQueryStringAsString(this.queryString);
        }
    },
    mounted() {
        this.queryString = 'minAmount';
        this.parseFromQueryString();
        var c = this;
        window.addEventListener("popstate", () => { c.parseFromQueryString(); });
    }
});



var vm = new Vue({
    el: '#app-client-report',
    data: {
        interest: GetQueryStringAsBool('interest'),
        filterProduct: window._filterProduct,
        employees: null,
        dirty: false
    },
    methods: {
        filterChanged() {
            this.dirty = computeSearchUrl(this.$children) !== document.location.search;
        },
        updateReport() {
            redirectWithFilter(this.$children);
        },
        downloadReport() {
            document.location = '/admin/api/customers/download' + computeSearchUrl(this.$children)
        }
    }
});

$(function () {
    if ((GetQueryStringAsString('from') !== '') || window._interest || GetQueryStringAsString('idProduct') !== '') {
        DisplayResult();
    }
});


$('#cmdDownload').click(function () {
    // redirect with querystring
    window.location = GetUrl() + "&download=true";
});



function DisplayResult() {
    $('#table').show().dataTable({
        ajax: '/Api/Customers' + window.location.search,
        columns: [
            { data: "FirstName", defaultContent: '' },
            { data: "LastName", defaultContent: '' },
            { data: "Company", defaultContent: '' },
            { data: "Phone", defaultContent: '' },
            { visible: false, data: "Cell", defaultContent: '' },
            { data: "Email", defaultContent: '' },
            { data: "Address1", defaultContent: '' },
            { data: "City", defaultContent: '' },
            { visible: false, data: "Region", defaultContent: '' },
            { data: "State", defaultContent: '' },
            { data: "PostalCode", defaultContent: '' },
            { visible: false, mData: function (source, type, val) { return FormatPropDate(source, type, val, 'DateCreated'); } },
            { visible: false, data: "Birthday", defaultContent: '' },
            { visible: false, data: "BirthdayYear", defaultContent: '' },
            { visible: false, data: "Notes", defaultContent: '' },
            { data: "Groups", defaultContent: 0 },
            { data: "AmountPurchase", defaultContent: 0 },
            { data: "NumberInvoices", defaultContent: 0 },
            { defaultContent: '', mData: function (source, type, val) { return FormatPropDate(source, type, val, 'LastTransaction'); } },
            { data: "Points", visible: _IsPointEnable, defaultContent: 0 },
            { data: "Identifier", defaultContent: '' },
            { data: "Id", defaultContent: '' },
            { visible: false, data: "Newsletter", defaultContent: '' }
        ],
        sAjaxDataProp: null,
        order: [[11, 'desc']]
    });
}
