// Comelin march 2020
// utility VueJs components for reporting
// Author: JcMorin
Vue.component('date-range', {
    template: `<div class="filter" id="filter-by-date">
<label for="from">du</label>
<input type="date" v-model="fromInternal">
<label for="to">au</label>
<input type="date" v-model="toInternal">
	</div>`,
    props: ['from', 'to'],
    computed: {
        fromInternal: {
            get() {
                return this.from;
            },
            set(value) {
                this.$emit('datefromchanged', value);
            }
        },
        toInternal: {
            get() {
                return this.to;
            },
            set(value) {
                this.$emit('datetochanged', value);
            }
        }
    }
});

/* Select components */
function GetSelectComponentGeneric(label, fetchUrl, displayProperty, cssClass) {
    return {
    template: `<select :id=id multiple="true" data-placeholder="` + label + `" v-if=listElements class="` + cssClass + `">
            </select>`,
    props: ['selected'],
    data() {
        return {
            id: 'select' + Math.random().toString(36).substring(7), // random id
            listElements:null
        }
    },
    mounted() {
        let c = this;
        fetch(fetchUrl).then(response => response.json()) 
            .then(data => {
                    c.listElements = data;
                }
            );
    },
    updated() {
        Select2Init(this, this.listElements, displayProperty);
    }
}
}

Vue.component('supplier-select',  GetSelectComponentGeneric('Fournisseurs', '/admin/api/suppliers', 'Title', 'supplier-select'));
Vue.component('employee-select',  GetSelectComponentGeneric('Employé·e·s', '/admin/api/employees', 'Username', 'employee-select'));
Vue.component('brand-select',  GetSelectComponentGeneric('Marques', '/admin/api/brands', 'Title', 'brand-select'));
Vue.component('category-select',  GetSelectComponentGeneric('Catégories', '/admin/api/category/flatmode', 'Title', 'category-select'));
Vue.component('store-select',  GetSelectComponentGeneric('Magasins', '/admin/api/store/list', 'Name', 'store-select'));
Vue.component('customer-group-select',  GetSelectComponentGeneric('Groupes', '/admin/api/customer-groups', 'Name', 'customer-group-select'));



/* filters  */
Vue.component('filter-date-range',
            {
                template: `<div class="filter">
            <div class="title">Période:</div>
            <div class="options">
                <date-range :from="dateFrom" @datefromchanged="setDateFrom" @datetochanged="setDateTo" :to="dateTo"></date-range>
            </div>
        </div>`,
                 data() {
                    return {
                        dateFrom: null,
                        dateTo: null
                    }
                },
                methods: {
                    setDateFrom(date) {
                        this.dateFrom = date;
                        console.log('From: ' + date);
                        this.$emit('filterchanged');
                    },
                    setDateTo(date) {
                        this.dateTo = date;
                        console.log('To: ' + date);
                        this.$emit('filterchanged');
                    },
                    getQueryString() {
                        return 'from=' + this.dateFrom + '&to=' + this.dateTo;
                    },
                    parseFromQueryString() {
                        var today = new Date().format('yyyy-mm-dd');
                        this.dateFrom = GetQueryStringAsString('from', today);
                        this.dateTo = GetQueryStringAsString('to', today);
                    }
                },
                mounted() {
                    this.parseFromQueryString();
                    var c = this;
                    window.addEventListener("popstate", () => { c.parseFromQueryString(); });
                }
            });


function GetFilterComponentGeneric(label, queryLabel, selectComponentTag, extraCssClass) {
    var cssClass = 'filter';
    if (extraCssClass) {
        cssClass += ' ' + extraCssClass;
    }
    return {
        template:`<div class="` + cssClass + `">
    <div class="title">` + label + `</div>
    <` + selectComponentTag + ` @selected="setElements" :selected="elementsSelected"></` + selectComponentTag + `>
</div>`,
        data() {
            return { elementsSelected: null };
        },
        methods: {
            setElements(elements) {
                this.elementsSelected = elements;
                this.$emit('filterchanged');
            },
            getQueryString() {
                if (this.elementsSelected && this.elementsSelected.length > 0) {
                    return this.queryString + '=[' + this.elementsSelected + ']';
                }
            },
            parseFromQueryString() {
                this.elementsSelected = GetQueryStringAsArrayOfInt(this.queryString);
            }
        },
        mounted() {
            this.queryString = queryLabel;
            this.parseFromQueryString();
            var c = this;
            window.addEventListener("popstate", () => { c.parseFromQueryString(); });
        }
    }
}

Vue.component('filter-store', GetFilterComponentGeneric('Magasin', 'stores', 'store-select', 'multi-store'));
Vue.component('filter-category', GetFilterComponentGeneric('Catégories', 'cat', 'category-select'));
Vue.component('filter-brand', GetFilterComponentGeneric('Marques', 'brands', 'brand-select'));
Vue.component('filter-supplier', GetFilterComponentGeneric('Fournisseurs', 'suppliers', 'supplier-select'));
Vue.component('filter-employees', GetFilterComponentGeneric('Employé·e·s', 'employees', 'employee-select'));
Vue.component('filter-customer-group', GetFilterComponentGeneric('Groupes de client', 'idGroup', 'customer-group-select'));

function GetFilterCheckboxComponentGeneric(label, queryLabel, extraCssClass) {
     var cssClass = 'filter';
    if (extraCssClass) {
        cssClass += ' ' + extraCssClass;
    }
    return {
       
        template: `<div class="` + cssClass + `">
            <label class="title">` + label + `
                <input type="checkbox" v-model=isSelected /> 
            </label>
        </div>`,
        data() {
            return { isSelected: null };
        },
        methods: {
            parseFromQueryString() {
                this.isSelected = GetQueryStringAsBool(this.queryString);
            },
            getQueryString() {
                 if (this.isSelected) {
                    return this.queryString + '=true';
                }
            }
        },
        mounted() {
            this.queryString = queryLabel;
            this.parseFromQueryString();
            var c = this;
            window.addEventListener("popstate", () => { c.parseFromQueryString(); });
        }
    }
}

Vue.component('filter-online-only',  GetFilterCheckboxComponentGeneric('Vente en ligne seulement', 'isSaleOnlineOnly', 'online-only-select'));



Vue.component('filter-attrib',
    {
        props: ['instance'],
        template:`<div>
            <div class="title">Champs personnalisés #{{instance}}</div>
            <attrib-select @attribselected="setAttrib" :attribselected="attribSelected" @attribvaluesselected="setAttribValue" :attribvaluesselected="attribValuesSelected"></attrib-select>
        </div>`,
        data() {
            return {
                attribSelected: null,
                attribValuesSelected: null
            }
        },
        methods: {
            setAttrib(attrib) {
                this.attribSelected = attrib;
                this.$emit('filterchanged');
            },
            setAttribValue(attribValue) {
                this.attribValuesSelected = attribValue;
                this.$emit('filterchanged');
            },
            getQueryString() {
                if (this.attribSelected) {
                    var url = this.queryStringAttrib + "=" + this.attribSelected;
                    if (this.attribValuesSelected && this.attribValuesSelected.length > 0) {
                        url += "&" + this.queryStringAttribValue + "=" + this.attribValuesSelected;
                    }
                    return url;
                }
            }
        },
        mounted() {
            this.queryStringAttrib = 'attrib' + this.instance;
            this.queryStringAttribValue = 'attribValues' + this.instance;
            this.attribSelected = GetQueryStringAsString(this.queryStringAttrib);
            this.attribValuesSelected = GetQueryStringAsArrayOfInt(this.queryStringAttribValue);
        }
    });

const GroupingByAttribType = 'Attrib';

function groupingToUrl(grouping) {
    if (!grouping) {
        return '';
    } else if (grouping.Type === GroupingByAttribType) {
        return grouping.IdAttrib;
    } else {
        return grouping.Type;
    }
}

const GroupingNone = 'None';

function urlToGrouping(v) {
    if (!v || v === GroupingNone) {
        return null;
    } else if (typeof (v) === 'number' || isPositiveInteger(v)) {
        return { Type: GroupingByAttribType, IdAttrib: v };
    } else {
        return { Type: v}
    }
}

function addToElement(elementTotal, el, field) {
    var v = el[field];
    if (v) {
        elementTotal[field] += v;
    }
}

function sumOfArray(array, field) {
    var total = 0;
    for (var i = 0; i < array.length; i++) {
        var el = array[i];
        var value = el[field];
        if (value) {
            total += value;    
        }
        
    }
    return total;
}


var g_attribSelectCachingListAttribut = null;

// Allow to select a simple custom field and values
Vue.component('attrib-select', {
    template: `<div class="attribs-select">
 <div class=filter><select :id=idAttrib v-if=attribs multiple="true" class="a"></select></div>
 <div class=filter><select :id=idAttribValue v-if=attribsValues  multiple="true" class="v"></select></div>
</div>
`,
    props: ['attribselected','attribvaluesselected', 'disabledvalue'],
    data() {
        return {
            idAttrib: 'selectAttrib' + Math.random().toString(36).substring(7), // random id
            idAttribValue: 'selectAttribValue' + Math.random().toString(36).substring(7), // random id
            attribs:null,
            attribsValues:null,
            displayValue:true
        }
    },
    methods: {
        UpdateAttributValueControl: function (valueSelected) {
            // update the attribute value based on the attrib selected
            if (valueSelected) {
                if (this.displayValue) {
                    let c = this;
                    fetch('/admin/api/attribvalues/list?id=' + valueSelected).then(response => response.json()) // fetch the attribut
                        .then(data => {
                            c.attribsValues = data;
                        }
                        );
                }
            } else {
                this.attribsValues = null; // remove the dropdown
                if (jQuery().select2) {
                    $("#" + this.idAttribValue).select2('destroy');
                }
                delete this[this.idAttribValue]; // mark as control not created
            }
        }
    },
    mounted() {
        this.displayValue = !this.disabledvalue;
        if (!g_attribSelectCachingListAttribut) {
            let c = this;
            fetch('/admin/api/attrib/list').then(response => response.json()) // fetch the attribut
                .then(data => {
                        c.attribs =  g_attribSelectCachingListAttribut =  data;
                    }
                );

        }else {
            this.attribs = g_attribSelectCachingListAttribut;
        }
    },
    updated() {
        if (Select2Init(this, this.attribs, 'Name', this.idAttrib, 'attribselected', 1)) {
            let c = this;
            $('#' + this.idAttrib).on('select2:select select2:unselect', function (e) {
                let valueSelected = $('#' + c.idAttrib).val();
                if (valueSelected && valueSelected.length > 0) {
                    valueSelected = valueSelected[0]; // first value, there is a limit of only one anyway
                } else {
                    valueSelected = null;
                }
                c.UpdateAttributValueControl(valueSelected);
            });
            this.UpdateAttributValueControl(this.attribselected); // initial select
        }
        Select2Init(this, this.attribsValues, 'Title', this.idAttribValue, 'attribvaluesselected');
    }
});


// redirect to url where each childre control can implement getQueryString to build the url
function redirectWithFilter(childrenFilter) {
    document.location = document.location.pathname + computeSearchUrl(childrenFilter);
}

function isPositiveInteger(n) {
    return n >>> 0 === parseFloat(n);
}

function computeSearchUrl(childrenFilter) {
    var filters = [];
    childrenFilter.forEach(filter => {
        if (filter.getQueryString) {
            var query = filter.getQueryString();
            if (query) {
                filters.push(query);
            }
        }
    });
    var queryString = "?";
    if (filters.length > 0) {
        queryString += filters.join('&');
    }
    return queryString;
}

function Select2Init(vueComponent, data, textProperty, ctrlId, eventName,  maxItem) {
    if (!ctrlId) {
        ctrlId = vueComponent.id;
    }
    if (!vueComponent[ctrlId] && data != null) {
        vueComponent[ctrlId] = true; // avoid running twice
        var P1 = loadScript('https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js');
        var P3 = loadCss('https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css');

        let dataref = data;
        if (!eventName) {
            eventName = 'selected';
        }
        Promise.all([P1,  P3]).then(() => {
            var obj = $('#' + ctrlId);
            var data = $.map(dataref, function (obj) { // the select2 control required id and text property
                obj.id = obj.Id; 
                obj.text = obj[textProperty];
                return obj;
            });
            obj.select2({data:data, width:'100%', maximumSelectionLength:maxItem});
            if (vueComponent[eventName]) {
                obj.val(vueComponent[eventName]).trigger('change'); // initial selected value
            }
            obj.on('select2:select select2:unselect', function (e) {
                let selected = obj.val();
                if (!selected || selected.length === 0) {
                    vueComponent.$emit(eventName, null); // nothing selected
                } else {
                    if (maxItem === 1) {
                        selected = selected[0]; // sent it as number and not array
                    }
                    vueComponent.$emit(eventName, selected); 
                }
                
            });
        });
        return true;
    }
    return false;
}