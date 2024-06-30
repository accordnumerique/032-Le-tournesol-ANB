// Comelin Admin
// Jean-Claude Morin 2021

function $$(element) {
	return document.getElementById(element);
}
function exist(variable) {
	return variable in window;
}


function isNumeric(str) {
    if (typeof str != "string") return false;
    return !isNaN(str) && !isNaN(parseFloat(str));
}

var loadScript = function (uri) {
	return new Promise((resolve, reject) => {
		var tag = document.createElement('script');
		tag.src = uri;
		tag.async = true;
		tag.onload = () => {
			resolve();
		};
		var scriptTag = document.getElementsByTagName('script')[0];
		scriptTag.parentNode.insertBefore(tag, scriptTag);
	});
}

var loadCss = function (uri) {
	return new Promise((resolve, reject) => {
		var tag = document.createElement('link');
		tag.setAttribute("rel", "stylesheet");
		tag.setAttribute("type", "text/css");
		tag.setAttribute("href", uri);
		tag.async = true;
		tag.onload = () => {
			resolve();
		};
		document.getElementsByTagName("head")[0].appendChild(tag);
	});
}

// post object that will be converted to json
function fetchPost(url, dataObj, ctrl, callback) {
    return _fetchPost(url, JSON.stringify(dataObj), ctrl, callback);
}

function fetchPostForm(url, form, ctrl, callback, finallyCallback) {
    return _fetchPost(url, form, ctrl, callback, finallyCallback);
}

function _fetchPost(url, body, ctrl, callback, finallyCallback) {
    $('body').addClass('waiting');
    let error = null;
	fetch(url, {
		method: 'post',
		body: body
	}).then(response => {
		if (!response.ok) {
			error = response.statusText;
		}
		return response.json();
	})
		.then(response => {
			if (error) {
				notify(response, ctrl, error);
				return;
			}
			if (callback) {
				callback(response);
			} else {
				notify(response, ctrl);
			}
		}).catch((error) => {
			notifyError(error + '\n' + url, ctrl);
		}).finally(() => {
			$('body').removeClass('waiting');
			if (finallyCallback) {
				finallyCallback();
			}
		});
}



function notifyError(msg, ctrl) {
    notify({ Category: 3, Text: msg }, ctrl);
}

/* Notify the user about some
 msg can be a string or a UserMessage structure
 */
function notify(msg, ctrl) {
    if (Array.isArray(msg)) {
        for (var m of msg) {
            notify(m, ctrl);
        }
        return;
    }
    var notification = $;
    if (ctrl) {
        notification = $(ctrl);
    }
    let classNotification = 'info';
    let text = null;
    if (typeof msg === 'string') {
        text = msg;
    } else {
        // assume object
        if (msg) {
            if (msg.Error) {
                classNotification = 'error';
                text = msg.Error;
            } else if (msg.Category) {
                switch (msg.Category) {
                case 1:
                    classNotification = 'success';
                    break;
                case 2:
                    classNotification = 'warn';
                    break;
                case 3:
                    classNotification = 'error';
                    break;
                case 4:
                    classNotification = 'info';
                    break;
                default:
                }
                text = msg.Text;
            }
        }
        if (!text) {
            if (ctrl) {
                if (classNotification !== 'error') {
                    text = '👍';        
                }
            } else {
                return; // this is a notification message
            }
            
        }
        if (msg && msg.Title) {
            text = msg.Title + '\n' + text;
        }
    }
    notification.notify(text, classNotification);
}




var _urlSearchParam = null;
function parseQueryString() {
    _urlSearchParam = new URLSearchParams(window.location.search);
}
parseQueryString();
window.addEventListener("popstate", () => { parseQueryString();} );

function globalSetUrl(url, pageTitle) {
    window.history.pushState(null, pageTitle ?? '', url);   
    parseQueryString();
}


function GetQueryStringAsBool(queryStringKey) {
    var val = _urlSearchParam.get(queryStringKey);
    if (!val) {
        return false;
    }
    return val === 'true';
}

function GetQueryStringAsString(queryStringKey, defaultValue) {
    var val = _urlSearchParam.get(queryStringKey);
    if (!val) {
        return defaultValue;
    }
    return val;
}

// convert string encoded array of int to array object (strings are split by comma)
function GetQueryStringAsArrayOfInt(queryStringKey) {
    var val = _urlSearchParam.get(queryStringKey);
    if (!val || val === true) { // true is the empty querystring interpretation
        return null;
    }
    if (typeof(val) == "number") {
        return [val];
    }
    return trimArraySymbol(val).split(',').map(x => +x);
}
/**
 * http://stackoverflow.com/a/10997390/11236
 */
function updateURLParameter(e, t, n) { var r = ""; var i = e.split("?"); var s = i[0]; var o = i[1]; var u = ""; if (o) { i = o.split("&"); for (var a = 0; a < i.length; a++) { if (i[a].split("=")[0] != t) { r += u + i[a]; u = "&" } } } var f = u + "" + t + "=" + n; return s + "?" + r + f }

function trimArraySymbol(string) {
    while(string.charAt(0)=='[') {
        string = string.substring(1);
    }

    while(string.charAt(string.length-1)==']') {
        string = string.substring(0,string.length-1);
    }

    return string;
}


// text replacement
if (exist('_Text')) {
	for(e of document.querySelectorAll('t')) {
		var code = e.innerText;
		var value = _Text[code];
		if (value != undefined) {
			var span = document.createElement('span');
			span.innerText = value;
			e.outerHTML = span.outerHTML;
		}
	}

	for (e of document.querySelectorAll('h')) {
		var code = e.innerText;
		var value = _Text[code];
		if (value != undefined) {
			var span = document.createElement('span');
			span.innerHTML = value;
			e.outerHTML = span.outerHTML;
		}
	}
}


if ($.notify) { $.notify.defaults({ className: "success", position:"top-left" }); } // notification by default display the success 

var queryStringIdStore = 'idStore'; //filter by 1 or more store

// default value for dataTable
if ($.fn.dataTable != undefined) {
  $.extend($.fn.dataTable.defaults, {
    sPaginationType: "full_numbers",
    deferRender: true,
    pageLength: 25,
    dom: 'lBfrtip',
    buttons: [
		  {
		  	extend: 'copy',
		  	text: 'Copier',
		  	exportOptions: { orthogonal: 'export' }
		  },
		  {
		  	extend: 'excel',
			title:null, /* prevent top row */
		  	exportOptions: { orthogonal: 'export' },
		  	footer: true
		  },
		  {
		  	extend: 'pdf',
		  	exportOptions: { orthogonal: 'export' },
		  	orientation: 'landscape',
		  	footer: true
		  },
		  {
		  	extend: 'print',
		  	text: 'Imprimer',
			footer: true,
		  	customize: function (win) {
				  $(win.document.body)
					  .css('font-size', '10pt');
		  		$(win.document.body).find('table')
					.addClass('compact')
					.css('font-size', 'inherit');
		  	}
		  }
    ],
    oLanguage: { "sUrl": "/js/datatabletranslation.txt" }   
  });

 
}

let defaultCulture = 'fr-CA';

// Datatable formatting of a number
// number: the number ot be displayed
// type: the context used, can be display, filter or "_" for fallback
function NumberToAmount(number, type) {
    if (!type || type === 'display' || type === 'smart') {
        if (!number) {
            if (type === 'smart') {
                return null;
            }
            number = 0;
        }
        var extra = '';
        if (type === 'display' || type === 'smart') {
            extra = ' $';
        }
        return number.toLocaleString(defaultCulture, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + extra;
    }
	return number; // use raw number for sorting
}

// Datatable formatting of a number
// number: the number ot be displayed
// type: the context used, can be display, filter or "_" for fallback
function NumberToAmountNoDecimal(number, type) {
    if (!type || type === 'display') {
        if (!number) {
            return '';
        }
        return number.toLocaleString(defaultCulture, { minimumFractionDigits: 0, maximumFractionDigits: 0 });
    }
    if (!number) {
        return 0;
    }
    return Math.round(number); // use raw number for sorting
}


// format a number for a quantity with up to 3 digits visible
function NumberToQuantity(number, type) {
	if (!type || type === 'display' || type === 'smart') {
		if (!number) {
            if (type === 'smart') {
                return null;
            }
			return 0;
		}
		return number.toLocaleString(defaultCulture, { minimumFractionDigits: 0, maximumFractionDigits: 3 });
	}
    return number; // use raw number for sorting
}


function NumberToPercentage(number, type) {
	if (type === 'display') {
		if (number === 0) {
			return '';
		}
		return (number * 100).toFixed(1) + "%";
	}
    return round(number * 100, 1); // use raw number for sorting
}

function DataTableSumColumn(api, columnNumber, formatting, valueFunction) {
    var c = api.column(columnNumber);
    var total = c.data().reduce(function(a, b) {
        var vA = a;
        var vB = b;
        if (valueFunction) {
            vB = valueFunction(vB);
        }
        if (vB) {
            return vA + vB;
        }
        return vA;
    }, 0);
    $(c.footer()).html(formatting(total));
}

function round( number, precision )
{
    precision = precision || 0;
    return parseFloat( parseFloat( number ).toFixed( precision ) );
}

// utilities function
/**
 * Returns the sum of all items. (ignore undefined value)
 *
 * @param {Array<object>} array the array of object to make the sum
 * @param {string} propertyName Optional, properly of the object to get the value
 */
function sum(array, propertyName) {
    let total = array.reduce((accumulator, currentValue) => {
        var v = 0;
        if (!propertyName) {
            v = currentValue;
        } else {
            v = currentValue[propertyName]; // read the property
        }
        if (!v) {
            return accumulator;
        }
        return accumulator + v}, 0);
    return total;
}

function SafeDivision(input, divisor) {
    if (!divisor || !input) {
        return 0;
    }
    return input / divisor;
}

$(function () {
	$('.button, input[type=submit]').addClass('btn btn-default');

	$('.sssGrid').addClass('table table-striped table-bordered');

	$('#cmdDisplay').click(function () {
		// redirect with query string
		window.location = GetUrl();
	});


	var picker = $$('store-picker');
	if (picker) {
		var strSelectedStores = $.query.GET(queryStringIdStore);
		var selectedStored = {};
		if (strSelectedStores) {
			var splitted = ("" + strSelectedStores).split(',');
			for (var j = 0; j < splitted.length; j++) {
				selectedStored[splitted[j]] = true;
			}

		}
		for (var i = 0; i < _stores.length; i++) {
			var store = _stores[i];
			var opt = document.createElement('option');
			opt.value = store.Id;
			opt.innerHTML = store.Name;
			opt.selected = selectedStored[opt.value];
			picker.appendChild(opt);
		}
	}

	$('[data-toggle="popover"]').popover();

	var lstSelect2 = $('.select2');
	if (lstSelect2.length > 0) {
		// filter by category, load select2 script
		var P2 = loadScript('https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js');
		var P3 = loadCss('https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css');
		Promise.all([P2, P3]).then(() => {
			// call your call back
			lstSelect2.select2();
			
		});
	}

});


function GetStoreSelectedToQueryString() {
	SetToQuery(queryStringIdStore, $$('store-picker'));
}

function SetToQuery(queryStringName, ctrl) {
	if (!ctrl) {
		return;
	}
	var options = ctrl.options;
	var selectedGroups = [];
	for (var i = 0; i < options.length; i++) {
		if (options[i].selected) {
			selectedGroups.push(options[i].value);
		}
	}
	if (selectedGroups.length > 0) {
		$.query.SET(queryStringName, selectedGroups.join());
	} else {
		$.query.REMOVE(queryStringName);
	}
}


var DateFormatMoment = 'D/M/YYYY'; // obsolete



function MomentParse(strDate) {
	return moment(strDate, DateFormatMoment);
}

function MomentFormat(moment) {
	return moment.format(DateFormatMoment);
}

if ($.timeago != undefined) {
	setInterval(OnTimerTimeAgo, 1000);
	function OnTimerTimeAgo() { $(".TimeAgo").timeago(); } // Make sure the dates displaying the timeago are periodically refreshed
}


function DateJsonToDate(jsonDate) {
  if (jsonDate != undefined) {
    return new Date(parseInt(jsonDate.substr(6)));
  } else {
   return '';
  }
}

/* works with grid 1.9.4  ex: "aoColumnDefs": [					{ "aTargets": [2], "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 2); } }] */
function FormatPropAmount(source, type, val, index) {
		if (type === 'set') {
			//source.push(val);
		} else if (type === 'display') {
			var v = source[index];
			if (!v) {
				return '';
			}
			return v.toFixed(2);
		}
		return source[index];
}


function FormatPropDate(source, type, val, index) {
  return _FormatPropDateTemplate(source, type, val, index, 'yyyy/mm/dd');
}

function FormatPropDateTime(source, type, val, index) {
  return _FormatPropDateTemplate(source, type, val, index, 'yyyy/mm/dd HH:MM');
}

function _FormatPropDateTemplate(source, type, val, index, template) {
	if (type === "set") {
		source.push(val);
	} //else if (type === "display") {
		var val = source[index];
		if (!val) {
			return "";
		}
		var date;
		if (typeof (val) == "number") {
			date = new Date(val * 1000); // unix format
		} else if (val.indexOf("/Date(") === 0) {
			date = new Date(parseInt(val.substr(6))); //  "/Date(1445977674967-0400)/" 
		} else {
			date = new Date(val); // 2015-01-12T05:12:59
		}
		var year = date.getFullYear();
		if (year === 1 || year === 0) {
			return "";
		}
		return dateFormat(date, template);
	//}
	return source[index];
}

function FormatCheckBox(data) {
  if (data) {
    return "<img src='images/check.png'>";
  } else {
    return '';
  }
}

// format date to be readable by a human
function FormatDate(date, format) {
	if (date) {
		if (!format) {
			format = 'D-MMM-YYYY';
		}
		return moment(date).format(format);
	}
	return '';
}

// for datagrid
// 2022 display date prop from the JSON string format
function GridFormatDate(strDate, displayType, row, w) {
	// expecting the date in string format
    if (!strDate) {
        return null;
    }
    var date = moment(strDate);
    if (displayType === 'display' || displayType === 'filter') 
        return date.format('D-MMM-YYYY');
    return date.format('YYYY-MM-DD');
}

function FormatPropDateTimeAgo(date, eProp, row, w) {
  if (eProp === 'display')
    return FormatDateTimeAgo(date);
  if (eProp === 'filter')
    return FormatDateTimeAgo(date) + ' ' + date;
  if (eProp === 'export') 
	  return new Date(date).format('yyyy-mm-dd HH:MM:ss');
  return date;
}
function FormatPropDateAgo(eProp, date, idSort) {
  if (eProp === 'display')
    return FormatDateAgo(date);
  if (eProp === 'filter')
    return FormatDateAgo(date) + ' ' + date;
  if (idSort != undefined) {
    if (eProp === 'sort' || eProp === 'type')
      return idSort;
  }
  return date;
}


/* Heat map set color to number from the ratio of the lowest to the highest */ 
function HeatMap(dataset, minToBeIncluded) {
	var min;
	var max;
	for (var i = 0; i < dataset.length; i++) {
		var value = parseFloat(dataset[i].innerText);
		if (!max || value > max) {
			max = value;
		}
		if (!min || value < min) {
			if (!minToBeIncluded || minToBeIncluded < value) {
				min = value;
			}
			
		}
	}
	for (var i = 0; i < dataset.length; i++) {
		var value = parseFloat(dataset[i].innerText);
		dataset[i].style.backgroundColor = GetColor(min, max, value);
	}
}
function GetColor(min, max, value) {
	var relativeNumber = Math.ceil((value - min) * 250 / (max - min));
	return rgb(255, 255 - Math.ceil(relativeNumber / 2), 255 - relativeNumber);
}
function rgb(r, g, b) {
	return "rgb(" + r + "," + g + "," + b + ")";
}


var tagCheckStorage = 'checkLicense'; // tag name

$(function () {
	if (document.URL.toLowerCase().indexOf('/admin/') !== -1 && exist('_guidCompany')) {
		// admin page, check 
		if (!sessionStorage[tagCheckStorage]) {
			$.ajax({ url: "https://facture.comelin.com/api/license/check/?guid=" + _guidCompany })
			  .done(function (result) {
			  	if (result.DaysLate) {
			  		displayWarningLatePayment(result.DaysLate, result.LinkInvoices);
				  }
			  });
		}
	}
});

function displayWarningLatePayment(nbDays, link) {
	var div = document.createElement('div');
	div.classList = 'billing-warning';
	div.innerHTML = '<div><div>Votre licence Comelin est expirée depuis ' + nbDays + ' jours.</div>' +
		'<a target=_blank href="' + link + '">état de compte</a>' +
		'<div class="btn btn-success" id=btnContinue >Continuer <span id=continueIn>' + nbDays + '</span></div></div>';
	$('body').prepend(div);
	window.continueIn = nbDays;
	var repeat = setInterval(function () {
		var counter = window.continueIn;
		counter--;
		window.continueIn = counter;
		if (counter <= 0) {
			// wait is over
			clearInterval(repeat);
			sessionStorage[tagCheckStorage] = true; // avoid checking twice
			$$('continueIn').innerText = '';
			$$('btnContinue').onclick = function() {
				$('.billing-warning').remove();
			};
		} else {
			$$('continueIn').innerText = counter;
		}

	}, 1000);
}



$(function () {
	
	var ctrlTo = $$("to");
	var ctrlFrom = $$("from");
	if (ctrlTo && ctrlFrom) {
        var formatDate = 'YYYY-MM-DD';
		// we can assume the filter is present
		ctrlTo.max = ctrlFrom.max = moment().format(formatDate);
		var strFrom = $.query.get('from');
		if (strFrom != '') {
			ctrlFrom.value = strFrom;
		} else {
			var dateBeginMonth = moment();
			dateBeginMonth.date(1);
			ctrlFrom.value = dateBeginMonth.format(formatDate);
		}
		var strTo = $.query.get('to');
		if (strTo != '') {
			ctrlTo.value = strTo;
		} else {
			ctrlTo.valueAsDate = new Date();
		}
	}

});

function GetUrl() {
	$.query.SET('from', $$("from").value);
	$.query.SET('to', $$("to").value);
	var lstStore = $$("lstStore");

	if (lstStore) {
		var store = lstStore.value;
		if (store > 0) {
			$.query.SET('store', store);
		} else {
			$.query.REMOVE('store', store);
		}
	}

	var lstCategories = $$('lstCategories');
	if (lstCategories != null) {
		var brands = lstCategories.options;
		var catSelected = [];
		for (var option of brands) {
			if (option.selected) {
				catSelected.push(option.value);
			}
		}
		if (catSelected.length !== 0) {
			$.query.SET('idCats', catSelected.toString());
		} else {
			$.query.REMOVE('idCats');
		}
	}

	var lstBrands = $$('lstBrands');
	if (lstBrands) {
        var brands = lstBrands.options;
		if (brands.selectedIndex <= 0) {
            $.query.REMOVE('idBrand');
		} else {
            $.query.SET('idBrand', brands[brands.selectedIndex].value);    
        }
		
	}


	if (exist('GetUrlExtra')) {
		GetUrlExtra(); // other filer from the page
	}
	return $.query.toString();
}


// the index is the left menu that scroll only when needed
$(function () {
	var index = $$('index');
	if (index) {
		var originalIndexPosition = index.offsetTop;
		var indexHeight = index.getBoundingClientRect().height + 30;
		function moveIndex() {
			var maxOffsetValue = 0;
			if (window.innerHeight < indexHeight) {
				maxOffsetValue = window.innerHeight - indexHeight;
			}
			var offsetValue = Math.max(maxOffsetValue, (originalIndexPosition - document.scrollingElement.scrollTop)) + 'px';
			index.style.top = offsetValue;
		}
		document.addEventListener("scroll", moveIndex);
	}
	// 

	// This is for non VueJs page
    for(e of document.querySelectorAll('help')) {
        var url = e.attributes['url']?.value;
        if (url) {
            e.outerHTML =
                '<a target=_blank class="help-page" href="https://soutien.comelin.com/portal/fr-ca/kb/' + url + '"><img src="https://www.comelin.com/cdn/images/help.png" title="Aide" /></a>';
        }
    }
});

/* Vue Js modules */
if (exist('Vue')) {
    if (window.VueSelect) {
        Vue.component('v-select', VueSelect.VueSelect);    
    }

    Vue.component('time-ago', {
		props: ['datetime'],
		template:`<span v-html="FormatDateTimeAgo(this.datetime)"></span>`,
        methods: {
            FormatDateTimeAgo(date) {
                return FormatDateTimeAgo(date);
            }
        }
        });
	
	Vue.component('bilingual-text', {
		props: ['text', 'multiline', 'placeholder', 'readonly'],
		data: function () {
			return {
				bilingual: window._bilingual
			}
		},
		template: '<div class="bilingual-text row" v-if=text>' +
						'<div class=col v-if="multiline && !bilingual && placeholder">{{placeholder}}</div>' +
						'<div class="col lang-fr"><span class="lang-label" v-if=bilingual>Français</span>' +
						'<div v-if="readonly && !multiline">{{text.Fr}}</div>' +
						'<div v-else-if="readonly && multiline" v-html=text.Fr></div>' +
						'<input v-else-if="!multiline" v-model="text.Fr" :placeholder="placeholder" />' +
						'<textarea v-else v-model="text.Fr" />' +
			'</div><div  class="col bilingual lang-en"><span class="lang-label" v-if=bilingual>English</span>' +
					    '<div v-if="readonly && !multiline">{{text.En}}</div>' +
						'<div v-else-if="readonly && multiline" v-html=text.En></div>' +
						'<input v-else-if="!multiline" class="lang-en" v-model="text.En" :placeholder="placeholder" />' +
						'<textarea v-else class="lang-en" v-model="text.En"  />' +
						'</div>' + '' +
			'<div class="col-12"  v-if="multiline && placeholder && bilingual"><div class="mutli-placeholder">{{placeholder}}</div></div></div>',
		mounted: function () {
			if (!this.text) {
				console.warn("property 'text' is not set for " + this.text);
			}
		}
	});
	
	Vue.component('comelin-checkbox', {
		props: ['text', 'property'],
		computed: {
			value: {
				get: function () { return [this.property]; },
				set: function (newValue) {
					this.property = newValue;
				}
			}
		},
		template: '<div><label for=abc>{{text}}</label><input id=abc type=checkbox v-model="property"><slot></slot></div>',
	});


	Vue.component('help', {
		props: ['number', 'url'],
		template: '<a target=_blank class="help-page" :href=getUrl()><img src="https://www.comelin.com/cdn/images/help.png" title="Aide" /></a>',
        methods: {
            getUrl() {
                if (this.url) {
					return 'https://soutien.comelin.com/portal/fr-ca/kb/' + this.url;
                }
                return this.number; // assume it's the full url
            }
        }

	});
}
for (var el of document.getElementsByClassName('help-page')) {
	el.src="https://www.comelin.com/cdn/images/help.png";
	el.title="Aide";
	el.onclick = ((e) => {
		var kb = e.target.dataset["kb"];
		if (kb) {
			window.open("https://soutien.comelin.com/portal/fr-ca/kb/" + kb);
		} 
		e.stopPropagation();
		return false;
	});
};



$(document).scroll(function () {
	var y = $(this).scrollTop();
	if (y > 400) {
		$('.visibleBottom').fadeIn();
	} else {
		$('.visibleBottom').fadeOut();
	}
});

// https://stackoverflow.com/a/51874002/396337
function normalisedString(input) {
	return input.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
}


// https://stackoverflow.com/questions/469357/html-text-input-allow-only-numeric-input
(function ($) {
	$.fn.inputFilter = function (inputFilter) {
		return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function () {
			if (inputFilter(this.value)) {
				this.oldValue = this.value;
				this.oldSelectionStart = this.selectionStart;
				this.oldSelectionEnd = this.selectionEnd;
			} else if (this.hasOwnProperty("oldValue")) {
				this.value = this.oldValue;
				this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
			}
		});
	};
}(jQuery));



// jQuery.query - Query String Modification and Creation for jQuery Written by Blair Mitchelmore (blair DOT mitchelmore AT gmail DOT com) 
// https://github.com/alrusdi/jquery-plugin-query-object
new function (settings) {
	var $separator = settings.separator || '&'; var $spaces = settings.spaces === false ? false : true; var $suffix = settings.suffix === false ? '' : '[]'; var $prefix = settings.prefix === false ? false : true; var $hash = $prefix ? settings.hash === true ? "#" : "?" : ""; var $numbers = settings.numbers === false ? false : true; jQuery.query = new function () {
		var is = function (o, t) { return o != undefined && o !== null && (!!t ? o.constructor == t : true); }; var parse = function (path) { var m, rx = /\[([^[]*)\]/g, match = /^([^[]+)(\[.*\])?$/.exec(path), base = match[1], tokens = []; while (m = rx.exec(match[2])) tokens.push(m[1]); return [base, tokens]; }; var set = function (target, tokens, value) {
			var o, token = tokens.shift(); if (typeof target != 'object') target = null; if (token === "") { if (!target) target = []; if (is(target, Array)) { target.push(tokens.length == 0 ? value : set(null, tokens.slice(0), value)); } else if (is(target, Object)) { var i = 0; while (target[i++] != null); target[--i] = tokens.length == 0 ? value : set(target[i], tokens.slice(0), value); } else { target = []; target.push(tokens.length == 0 ? value : set(null, tokens.slice(0), value)); } } else if (token && token.match(/^\s*[0-9]+\s*$/)) { var index = parseInt(token, 10); if (!target) target = []; target[index] = tokens.length == 0 ? value : set(target[index], tokens.slice(0), value); } else if (token) {
				var index = token.replace(/^\s*|\s*$/g, ""); if (!target) target = {}; if (is(target, Array)) {
					var temp = {}; for (var i = 0; i < target.length; ++i) { temp[i] = target[i]; }
					target = temp;
				}
				target[index] = tokens.length == 0 ? value : set(target[index], tokens.slice(0), value);
			} else { return value; }
			return target;
		}; var queryObject = function (a) {
			var self = this; self.keys = {}; if (a.queryObject) { jQuery.each(a.get(), function (key, val) { self.SET(key, val); }); } else {
				jQuery.each(arguments, function () {
					var q = "" + this; q = q.replace(/^[?#]/, ''); q = q.replace(/[;&]$/, ''); if ($spaces) q = q.replace(/[+]/g, ' '); jQuery.each(q.split(/[&;]/), function () {
						var key = decodeURIComponent(this.split('=')[0] || ""); var val = decodeURIComponent(this.split('=')[1] || ""); if (!key) return; if ($numbers) {
							if (/^[+-]?[0-9]+\.[0-9]*$/.test(val))
								val = parseFloat(val); else if (/^[+-]?[0-9]+$/.test(val))
									val = parseInt(val, 10);
						}
						val = (!val && val !== 0) ? true : val; if (val !== false && val !== true && typeof val != 'number')
							val = val; self.SET(key, val);
					});
				});
			}
			return self;
		}; queryObject.prototype = {
			queryObject: true, has: function (key, type) { var value = this.get(key); return is(value, type); }, GET: function (key) {
				if (!is(key)) return this.keys; var parsed = parse(key), base = parsed[0], tokens = parsed[1]; var target = this.keys[base]; while (target != null && tokens.length != 0) { target = target[tokens.shift()]; }
				return typeof target == 'number' ? target : target || "";
			}, get: function (key) {
				var target = this.GET(key); if (is(target, Object))
					return jQuery.extend(true, {}, target); else if (is(target, Array))
						return target.slice(0); return target;
			}, SET: function (key, val) { var value = !is(val) ? null : val; var parsed = parse(key), base = parsed[0], tokens = parsed[1]; var target = this.keys[base]; this.keys[base] = set(target, tokens.slice(0), value); return this; }, set: function (key, val) { return this.copy().SET(key, val); }, REMOVE: function (key) { return this.SET(key, null).COMPACT(); }, remove: function (key) { return this.copy().REMOVE(key); }, EMPTY: function () { var self = this; jQuery.each(self.keys, function (key, value) { delete self.keys[key]; }); return self; }, load: function (url) { var hash = url.replace(/^.*?[#](.+?)(?:\?.+)?$/, "$1"); var search = url.replace(/^.*?[?](.+?)(?:#.+)?$/, "$1"); return new queryObject(url.length == search.length ? '' : search, url.length == hash.length ? '' : hash); }, empty: function () { return this.copy().EMPTY(); }, copy: function () { return new queryObject(this); }, COMPACT: function () {
				function build(orig) {
					var obj = typeof orig == "object" ? is(orig, Array) ? [] : {} : orig; if (typeof orig == 'object') {
						function add(o, key, value) {
							if (is(o, Array))
								o.push(value); else
								o[key] = value;
						}
						jQuery.each(orig, function (key, value) { if (!is(value)) return true; add(obj, key, build(value)); });
					}
					return obj;
				}
				this.keys = build(this.keys); return this;
			}, compact: function () { return this.copy().COMPACT(); }, toString: function () {
				var i = 0, queryString = [], chunks = [], self = this; var encode = function (str) { str = str + ""; if ($spaces) str = str.replace(/ /g, "+"); return encodeURIComponent(str); }; var addFields = function (arr, key, value) {
					if (!is(value) || value === false) return; var o = [encode(key)]; if (value !== true) { o.push("="); o.push(encode(value)); }
					arr.push(o.join(""));
				}; var build = function (obj, base) {
					var newKey = function (key) { return !base || base == "" ? [key].join("") : [base, "[", key, "]"].join(""); }; jQuery.each(obj, function (key, value) {
						if (typeof value == 'object')
							build(value, newKey(key)); else
							addFields(chunks, newKey(key), value);
					});
				}; build(this.keys); if (chunks.length > 0) queryString.push($hash); queryString.push(chunks.join($separator)); return queryString.join("");
			}
		}; return new queryObject(location.search, location.hash);
	};
}(jQuery.query || {});
