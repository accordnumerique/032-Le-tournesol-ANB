// Comelin interaction general (c) Jean-Claude Morin 2018-2020
// Utilise le framework VueJs 2.0
function $$(element) { return document.getElementById(element); } // shortcut
function exist(variable) {return variable in window;} // more intuitive

function func_exists(functionName){  return (typeof window[functionName] === 'function'); }

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

if ($.notify) {$.notify.defaults({className: "success"});} // notification by default display the success 


// wrapper to avoid using jQuery (planning to phase it out)

function hide(selector) {
  const elements = document.querySelectorAll(selector);
  elements.forEach((element) => {
    element.style.display = 'none';
  });
}

function OnLoaded(callback) {
  document.addEventListener('DOMContentLoaded', callback);
}

var timerAutoHide;

function Comelin() {
	if (!window._cart) {
		console.warn('_status not defined');
		window._cart = {};
	}
	if (!window._cart.NbItems) {
		window._cart.NbItems = 0;
	}

	if (!window._session) {
		console.warn('_session not defined');
		window._session = {};// to avoid errors
	}

    Vue.component('t', {
		props: ['code'],
		template: '<span :class=getCode>{{getText}}</span>',
		computed: {
			getCode() {
				var code = this.code;
				if (code === undefined) {
					code = this.$slots.default[0].text;
				}
				return code;
			},
            getText () {
				var c = this.getCode;
                var result = _Text[c];
                if (result === undefined) {
                    console.warn("Text : '" + c + "' not found");
                }
                return result;
            }
		}
    });

    Vue.component('h', {
        props: ['code'],
        template: '<span :class=getCode v-html=getText></span>',
        computed: {
			getCode() {
				var code = this.code;
				if (code === undefined) {
					code = this.$slots.default[0].text;
				}
				return code;
			},
			getText() {
				return _Text[this.getCode];
			}
		}
    });

    Vue.prototype.formatPrice = (value) => {
        if (value === undefined) {
            return '';
        }
        return Intl.NumberFormat(getLang() + '-CA', {minimumFractionDigits:2, maximumFractionDigits:2 }).format(value) + '$'; // not using style:'currency' because it add extra space with the $
    }

    Vue.component('price', {
        template: '<span>{{getText()}}</span>',
        methods: {
            getText () {
                let amount = this.$slots.default[0].text; 
                return this.formatPrice(amount);
            }
        }
        });

    Vue.component('product-price',
        {
            props: ['product'],
            template: '<div v-if="product.Price">' +
                '<span v-if="product.PriceDiscount"><del class="price-original">{{formatPrice(product.Price)}}</del> ' +
                '<span class="price-discount" :value="product.PriceDiscount">{{formatPrice(product.PriceDiscount)}}</span>' +
                '</span>' +
                '<span v-else :value="product.Price">{{formatPrice(product.Price)}}</span><span class="price-max" v-if="product.PriceMax && product.PriceMax != product.Price"> - {{formatPrice(product.PriceMax)}}</span>' +
                '</div>',
            created() {
                if (this.product) {
                    if (!this.product.PriceDiscount) {
                        this.$set(this.product, 'PriceDiscount', undefined);
                    }
                }
            }
        });
    Vue.component('category-listing-custom', {
        props: ['categories'],
        data: function() {
            return {
				selectedCategories:null
            }
        },
        mounted() {
            if (!this.categories) {
				return;
            }
			// return the list of categories object from the props specified, find them from the assume-available global properties '_categories'.
            var lookup = GetCategoryLookup();
            var result = [];
            for (var idCat of Array.parse('[' + this.categories + ']')) {
                var cat = lookup[idCat];
                if (cat) {
                    result.push(cat);
                }
            }
            this.selectedCategories = result;
        },
        template: '<div v-if=selectedCategories><slot :cats="selectedCategories"></slot></div>'
    });
	Vue.component('open-hours', {
		props: ['openinghours', 'multistore'],
		template: '<div>' +
			'<h4 v-if=multistore>{{openinghours.StoreName}}</h4>' +
			'<div class="openHours">' +
			'<time v-if="multistore" class=rightnow  @click="isToogle = !isToogle">' +
			'<t v-if=isOpen code=Open class=isOpen></t>' +
			'<t v-if=!isOpen code=Closed class=isClosed></t>' +
			'<span>{{fromToStr(getTodayOpenHour())}}</span>' +
			'<i class="fa fa-chevron-down" v-if=isToogle ></i><i class="fa fa-chevron-up" v-if="!isToogle && multistore"></i></time>' +
						
						'<time  v-if="!isToogle" v-for="(o, i) in openhours.Normal"  itemprop="openingHours" :datetime="datetimestr(o,i)" >' +
							'<span class=date>{{dayOfWeekStr(i)}}</span>' +
							'<span v-if="o.IsOpen" class=time>{{fromToStr(o)}}</span>' +
							'<t v-else code="Closed" class=closed></t>' +
						'</time>' +
					'</div>' +
					'<div v-if="!isToogle && openhours.Exceptions"  class="openHoursEx" >' +
						'<h3><t>OpenHoursExceptions</t></h3>' +
						'<time  v-for="(o, i) in openhours.Exceptions">' +
							'<span class=date>{{dateStr(o.Date)}}</span>' +
							'<span v-if="o.IsOpen" class=time>{{fromToStr(o)}}</span>' +
							'<t v-else code="Closed" class=closed></t>' +
						'</time>' +
					'</div></div>',
		data: function () {
			return {
				isToogle: this.multistore,
				openhours: this.openinghours.Hours
			}
		},
		computed: {
			isOpen: function () { // determine if the store is open 'right now'
				var oh = this.getTodayOpenHour();
				if (!oh.IsOpen) {
					return false;
				}
				return moment() > moment(oh.From, ['HH:mm']) && moment() < moment(oh.To, ['HH:mm']);
			}
		},
		methods: {
			getTodayOpenHour: function () {
				// check for exception first
				if (this.openinghours.Hours.Exceptions) {
					for (var oh of this.openinghours.Hours.Exceptions) {
						if (moment().isSame(moment(oh.Date), 'day')) {
							return oh;
						}
					}
				}
				var indexToday = moment().day();
				for(i = 0; i <this.openhours.Normal.length; i++) {
					if (i === indexToday) {
						return this.openhours.Normal[i];
					}
				}
				return null;
			},
			datetimestr: function (timeRange, dayNumber) {
				return moment().startOf('isoWeek').add(dayNumber, 'day').locale('en').format('dd') + ' ' + this.time(timeRange.From) + ':' + this.time(timeRange.To);
			},
			dateStr: function (dateTime) {
				return moment(dateTime).format('ddd D MMM');
			},
			time: function (dateTime) {
				return moment(dateTime, ['HH:mm']).format('HH:mm');
			},
			dayOfWeekStr: function (dayNumber) {
				return this.getDay(dayNumber).format('dddd');
			},
			getDay(dayNumber) {
				return moment().startOf('isoWeek').add(dayNumber, 'day');
			},
			fromToStr: function (oh) {
				if (!oh.IsOpen) {
					return '';
				}
				return this.time(oh.From) + ' - ' + this.time(oh.To);
			}
        }
	});

    Vue.mixin({
        methods: {
            NumberToAmount: str => str?.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '$' 
}
    });


    Vue.component('filter-single-attribut-value',
        {
            props: ['f', 'idprefix'],
			template: `<li>
<a :href="f.Url" rel="nofollow">
<i :id="idprefix + 'av' + f.Id" class="fa fa-fw" :class="{'fa-check-square-o': f.Checked, 'fa-square-o': !f.Checked }"></i>
<span class="t">{{f.Label}}</span><span class="count">({{f.Count}})</span>
</a>
</li>` });
    Vue.component('filter-single-attribut',
        {
            props: ['af', 'collapseover'],
            template: `
<div id=filterByAttributes>
<h3 class="filter-title">{{af.Label}}</h3>
<ul v-if="getShowAll()" :id="'list-attribut-' + af.IdAttribute">
    <filter-single-attribut-value v-for="f in af.Filters" :f=f :key="f.Id" :idprefix="'a' + af.IdAttribute"></filter-single-attribut-value>
</ul>
<ul v-else>
    <filter-single-attribut-value v-for="f in getMostPopular()" :f=f :key="f.Id"></filter-single-attribut-value>
    <span class=unhide @click="displayAll()"><t>CategoryViewMore</t>...</span>
</ul>
</div>`,
            data() {
                return {
                    isOpen: false 
                }
            },
            methods: {
                getShowAll() {
                    return this.isOpen || this.af.Filters.length < this.getMaxBeforeCollapse();
                },
                getMaxBeforeCollapse() {
                    return this.collapseover ?? 15;
                },
                getMostPopular() {
                    var total = this.af.Filters.length;
                    var listCount = new Uint32Array(total);
                    for (var i = 0; i < total; i++) {
                        listCount[i] = this.af.Filters[i].Count;
                    }
                    listCount.sort(); // sort by count
                    var minToInclude = listCount[total - this.getMaxBeforeCollapse()]; // get the nth x last to know where to stop
                    if (minToInclude === listCount[0]) {
                        this.isOpen = true; // all visible
                    }
                    var topValue = [];
                    for (var a of this.af.Filters) { // display in the original normal order
                        if (a.Count >= minToInclude) {
                            topValue.push(a);    
                        }
                    }
                    return topValue;
                },
                displayAll() {
                    this.isOpen = true;
                }
            }
        });

	Vue.component('filter-by-attributes', {
		props: ['filters', 'collapseover'],
		template: `<div>
<nav v-if="filters" v-for="af in filters" :id="'filter-attribut-' + af.IdAttribute" class="menu-filter" >
<filter-single-attribut :af=af :collapseover=collapseover ></filter-single-attribut>
</nav>
</div>`
    });

    Vue.component('time-range', {
		props: ['from', 'to'],
		template: `<span class=timerange><template v-if=from><t>from</t> {{formatDate(from)}} <t>to</t></template><t v-else>PromotionUntil</t> {{formatDate(to)}}</span>`,
        methods: {
            formatDate: function (date) {
                return moment(date).format("D MMM");
            },
        }
    });

    Vue.component('newsletter-subscribe', {
		template: `<span class='newsletter'><input class="input-name" v-model=name :placeholder="NamePlaceHolder" autocomplete='name' id="txtNewsletterName" />
<input class="input-email" v-model=email type="email" :placeholder="EmailPlaceHolder" autocomplete='email' id="txtNewsletter" />
<div class="btn btn-dark btn-ok" @click="subscribe"><t>ButtonNewsletter</t></div></span>`,
		props:['position'],
        data() {
            return {
				name: '',
				email: ''
            }
        },
        computed: {
			NamePlaceHolder() {
				return _Text['Name'];
            },
			EmailPlaceHolder() {
				return _Text['Email'];
            },
        },
        methods: {
            subscribe(e) {
				var ctrl = e.target;
				var msgPosition = this['position'] ?? 'right';
				fetchPost('/api/newsletter', { Name: this.name, Email: this.email}, ctrl, function (result) {
                    if (result.Msg) {
						var options = {position: msgPosition};
                        if (result.Added) {
							notify(result.Msg, ctrl, options);
                        } else {
							notifyError(result.Msg, ctrl, options);
                        }
                    }
				});
            }
        }
    });

	  Vue.component('page-generic', {
		props: ['id'],
		template: `<a v-if=p :href="p.Url">{{p.Title}}</a>`,
        computed: {
            p() { 
			var idSearch = this.id;
			return window._genericPages.find(p => p.Id == idSearch) }

        }
    });

	Vue.component('widget-boxes', { // mh
        props: ['id'],
        data() { return {boxes: []}
        },
        created() {
            const apiURL = `/api/widget-box/?id=${this.id}`;
            fetch(apiURL)
                .then(response => response.json())
                .then(data => {
                    this.boxes = data.Boxes;
                })
                .catch(error => {console.error(error); });
        }
    });

	Vue.component('checkbox', {
		props: ['checked'],
		template: `<div class=checkbox @click=click style="cursor:pointer">
		<i :class="{'fa-check-square-o':checked, 'fa-square-o':!checked}" class='fa fa-fw'></i><slot></slot></span>
</div>`,
		methods: {
			click() {
				this.$emit('click');
			}
		}
	});

    Vue.component('filter-new-products', {
        template: `<filter-checkbox class-name="filter-promo" :keyword=keywordi13n><slot><t>CategoryNew</t></slot></filter-checkbox>`,
        computed: {
            keywordi13n() {
                return getLang() == 'fr' ? 'Nouveautes' : 'Latest';
            }
        }
    });

    Vue.component('filter-discount-products', {
        template: `<filter-checkbox class-name="filter-new" keyword="Promos"><slot><t>Promotions</t></slot></filter-checkbox>`
    });

    Vue.component('filter-in-stock', {
        template: `<filter-checkbox class-name="filter-instock" :keyword="keywordi13n"><slot><t>InStock</t></slot></filter-checkbox>`,
		computed: {
            keywordi13n() {
                return getLang() == 'fr' ? 'EnInventaire' : 'InStock';
            }
        }
    });

	Vue.component('filter-checkbox', {
		props: ['className', 'keyword'],
		template: `<checkbox :class=className class=filterDiscout :checked=isChecked @click=toogle><slot></slot></checkbox>`,
		computed: {
			isChecked() {
				const url = window.location.href;
				return url.includes(this.subPath);
			},
			subPath() {
				return '/' + this.keyword;
			}
		},
		methods: {
			toogle() {
				window.location.href = this.isChecked ? this.getUrlWithout() : this.getUrlWith();
			},
			getUrlWith() {
				return window.location.href + this.subPath;
			},
			getUrlWithout() {
				return window.location.href.replace(this.subPath, "");
            }
		}
	});

   vm = new Vue({
        components: window._components,
		el: '#b',
        data: {
			productsNew: window._newProducts, // list of new products 
			productsStar: window._starProducts, // list of product stars
			events: null, // next events
			boxes: window._boxes, // first set of boxes data 
			boxes2: window._boxes2, // second set of boxes data 
			freeText: window._freeText, // free text with title
			banners: window._banners, // banners for homepage
			categories: window._categories, // primary/secondary categories for navigation
			cart: window._cart, // .NbItems, .Itemstotal, 
			session: window._session, // .IsLogged, .Name, .Email
			wishList: window._wishList, // .NbWishList
			showInventory: window._showInventory, // if the quantity in stock is displayed or not
			/**
			product page
			*/
			productData: window._productData, // single product page
			attribsLookup: null, // attribute indexed by their own id
			matrix: null,
			matrixFilters: window._matrixFilters, // array of attribute that are use to filter the list of product
			matrixProductsMatchingFilter: null,
			matrixMaxElementBeforeDropDown: window._matrixMaxElementBeforeDropDown,
			allImages: null, // all images of the matrix
            bilingual: window._bilingual, // true  false
			urlBilingual: window._urlBilingual, // url to flip language 
			listing: window._listing, // list of multiple products
			suggestions: window._suggestions,

			genericPages: window._genericPages,
			links: window._links,
			brandLeading: window._brandLeading,
			promotions: window._promotions,
			email: window._email,
			tel: window._phone,
			address: window._address,
			addressLink: window._addressLink,
			facebook: window._facebook,
			instagram: window._instagram,
			openHours: null,
			storeOpenHours: window._openHours,
			giftCardSpecificationsNumber: window._giftCardSpecifications,
			giftCardSpecificationsValue: {},
            lang: getLang()
},
		computed: {
			urlCategoryImage: function () {
				if (this.listing) {
					return this.listing.UrlCategoryImage ?? this.listing.UrlBrandImg;
				}
				return null;
			},
            displayAvailability:function() {
				return !this.productData.IsCombine && (!this.matrixProductsMatchingFilter || this.matrixProductsMatchingFilter.length === 1);
            },
            displayNotificationRequest:function() {
				return !this.productData.IsOutOfStock && !this.productData.Discontinued;
            }
        },
		methods: {
			getText (code) {
				return _Text[code];
			},
			navigate: function (url) {
				document.location = url;
			},
			// price with rebate but without the included items
            getEffectivePrice() {
				var p = this.productData;
                if (p.PriceDiscount) {
                    return p.PriceDiscount;
                }
                if (p.PriceBase) {
					return p.PriceBase;
                }
                return p.Price;
            },
            urlWithLang(relativeUrl) {
                return '/' + this.lang + '/' + relativeUrl;
            },
			datetimestr: function (timeRange, dayNumber) {
				return moment().startOf('isoWeek').add(dayNumber, 'day').locale('en').format('dd') + ' ' + this.time(timeRange.From) + ':' + this.time(timeRange.To);
			},
			dateStr: function (dateTime) {
				return moment(dateTime).format('ddd D MMM');
			},
			time: function (dateTime) {
				return moment(dateTime, ['HH:mm']).format('HH:mm');
			},
			dayOfWeekStr: function (dayNumber) {
				return moment().startOf('isoWeek').add(dayNumber, 'day').format('dddd');
			},
            getCanBeAddedToCart(product) {
                if (product.CanBeAddedToCartOriginalValue != undefined) {
                    return product.CanBeAddedToCartOriginalValue;
                }
                return product.CanBeAddedToCart;
            },
            setCanBeAddedToCart(product, value) {
                if (product.CanBeAddedToCartOriginalValue === undefined) {
                    product.CanBeAddedToCartOriginalValue = product.CanBeAddedToCart; // backup
                }
                product.CanBeAddedToCart = value;
            },
			setFilterSelected: function (filter, selection) {
                if (this.matrixFilters === null || this.matrixFilters.length === 0) {
                    return; // this page do not have filtered matrix
                }

				if (selection === -1) {
					// "unselect" everything
					filter.selected = selection;
				} else if (selection && selection.selectedIndex) {
					// this is actually the drop down list
					filter.selected = filter.Values[selection.selectedIndex]; // parseInt(selection.options[selection.selectedIndex].value);
				} else if (Number.isInteger(selection)) {
					// assume it the id of the value selected
					filter.selected = filter.Values.find(v => v.Id == selection);
				} else {
					// filter is an object part of matrixFilters
					filter.selected = selection; // selection can be null if the filter is removed	
				}
				
				this.matrixProductsMatchingFilter = this.matrix.filter(p => this.matchFilter(p));
                if (this.matrixProductsMatchingFilter.length === 1) {
					// single product matching the filter
                    var matchingProduct = this.matrixProductsMatchingFilter[0];
					var productUrl = matchingProduct.Url;
					if (productUrl !== document.location.pathname) {
						document.location = productUrl; // redirect
                    } else {
                        this.productData.CanBeAddedToCart = this.getCanBeAddedToCart(matchingProduct);
                        this.productData.IsRequiredAmount = matchingProduct.IsRequiredAmount;
                        this.productData.PriceMax = matchingProduct.PriceMax;
                        this.productData.Price = matchingProduct.Price;
                        this.productData.PriceDiscount = matchingProduct.PriceDiscount;
						this.setPrimaryImage(matchingProduct.UrlImage); // the image need to be set here as it could have been wrong for instance set via the filter size
                        $('.dispo').show();
                    }
                } else {
                    this.setCanBeAddedToCart(this.productData, false); // prevent to be purchase, as it's NOT the products displayed
					if (this.matrixProductsMatchingFilter.length > 1) {
						var prices = this.matrixProductsMatchingFilter.map(function (o) { return o.Price; });
						this.productData.Price = Math.min.apply(Math, prices);
						this.productData.PriceMax = Math.max.apply(Math, prices);

                        this.productData.PriceDiscount = 0;
                        for (var o of this.matrixProductsMatchingFilter) {
                            if (o.PriceDiscount) {
                                this.productData.PriceDiscount = o.PriceDiscount;
                            }
                        }
						if (this.matrixProductsMatchingFilter.find(p => p.Id === this.productData.Id)) {
							this.setPrimaryImage(this.productData.UrlImage); // the current product is in the filter
						} else {
							this.setPrimaryImage(this.matrixProductsMatchingFilter[0].UrlImage); // matrix view, display image of the first product matching
							this.setImagesAtStart(this.matrixProductsMatchingFilter);
						}
                    } else {
						// no product match, probably because on the filter on custom fields is not selected, try to pick an images on at least those that would fix the selected attrib
						var productsMatching = this.matrix.filter(p => this.matchFilter(p, true));
						if (products.length != productsMatching.length) {
							 if (productsMatching.length > 0) {
								this.setPrimaryImage(productsMatching[0].UrlImage);
							}
							this.setImagesAtStart(productsMatching);
                        }
                    }
                }
				// update the filter options to display visual cue if an option is not available
				// loop all buttons (all filter type and filters value, then for each of them check all products if at least one match)
				for (var j = 0; j < this.matrixFilters.length; j++) {
					let attribFilter = this.matrixFilters[j];
                    for (var i = 0; i < attribFilter.Values.length; i++) {
						let v = attribFilter.Values[i];
						this.checkIfAnyProductsMatch(attribFilter, v);
                    }
				}
            },
            setImagesAtStart(productsMatching) {
				var matchedImages = [];
				var remainingImages = [];
                if (this.allImages == null) {
					this.allImages = this.productData.Images; // keep a copy of all images
                }
				for (var i = 0; i < this.allImages.length; i++) {
				  var image = this.allImages[i];
				  var idImage = this.getImageId(image.Url);
				  // Check if the image URL is in the list
				  var app = this;
				  var match = productsMatching.find(function(product) {
					return app.getImageId(product.UrlImage) === idImage || (product.Photos && product.Photos.includes(idImage));
				  });

				  if (match) {
					matchedImages.push(image); // Move matched image to the matchedImages array
				  } else {
					remainingImages.push(image); // Move unmatched image to the remainingImages array
				  }
				}
				var reorderedArray = matchedImages;
				if (matchedImages.length == 0) {
					reorderedArray = matchedImages.concat(remainingImages).slice(0, 9); // include image from other products
				}
				var reorderedListUrl = reorderedArray.map(function(obj) {
				  return obj.Url;
				});
				Vue.set(this.productData, 'Images', reorderedArray);
				this.productData.Images = [...reorderedArray];
				this.productData.Photos = [...reorderedListUrl];
            },
			getImageId(url) {
			  var urlParts = url.split('/');
			  var idIndex = urlParts.findIndex(function(part) {
				return !isNaN(parseInt(part));
			  });

			  if (idIndex !== -1 && idIndex + 1 < urlParts.length) {
				return parseInt(urlParts[idIndex + 1]);
			  }
			  return null; // Return null if ID extraction fails
			},
            checkIfAnyProductsMatch(attribut, value) {
                value.Disabled = false;
                for (var p of this.matrix) {
                    if (this.matchExistFiltersWithException(p, attribut, value)) {
                        return;
                    }
                }
                value.Disabled = true; // no product match it! :(
            },
			// determine if the product match the selected filter
			matchFilter: function (product, allowPartialMatch) {
				for (var attribFilter of this.matrixFilters) {
                    if (allowPartialMatch && attribFilter.selected == -1) {
						continue; // partial match to "view all"
                    }
					if (!attribFilter.selected) {
						continue;
					} else {
						// make sure the product have this attribute with the same value
						var productAttrib = product.Attribs[attribFilter.Id];
						if (!productAttrib || productAttrib.indexOf(attribFilter.selected.Id) === -1) {
							return false;
						}
					}
				}
				return true;
			},
			// check if the product would match all currently selected filter with one exception (pretest if product would fit a future value)
			matchExistFiltersWithException: function (product, filterException, filterExceptionValue) {
				for (var attribFilter of this.matrixFilters) {
					if (attribFilter.selected == -1) {
						// none is selected, so not filtered;
						continue;
					}
					if (attribFilter === filterException) {
						// thats the exception
						if (!this.matchFilterValue(product, attribFilter.Id, filterExceptionValue.Id)) {
							return false;
						}
					} else {
						// test the normal filter already selected
						if (!attribFilter.selected) {
							continue;
						} else if (!this.matchFilterValue(product, attribFilter.Id, attribFilter.selected.Id)) {
							return false;
						}
					}
				}
				return true;
			},
            matchFilterValue(product, filterId, filterValue) {
				if (!product.Attribs) {
					return false;
				}
				var productAttrib = product.Attribs[filterId];
				if (!productAttrib || productAttrib.indexOf(filterValue) === -1) {
					return false;
				}
				return true;
            },
			getMatrixAttribName: function (idAttrib) {
				return this.attribsLookup[idAttrib].Title;			
			},

			getMatrixProductAttribNames: function (product, attribs) {
				var result = '';
				for (var a of attribs) {
					if (result.length > 0) {
						result += ' ';
					}
					result += this.getMatrixProductAttribName(product, a);
				}
				return result;
			},
			getMatrixProductAttribName: function (product, idAttrib) {
				// get the name of the matrix attribute, this works only if there is a single attribute
				if (this.attribsLookup) {
					var attrib = this.attribsLookup[idAttrib];

					// find the product selected value
					var valueSelected = product.Attrib[attrib.Id];

					// find the name of that value in the attribut description
					var values = attrib.Values;
					for (var i in values) {
						var attribValue = values[i];
						if (attribValue.Id === valueSelected) {
							return attribValue.Text;
						}
					}
					
				}
				return null;
			},
			addToCart: function (product, event) {
				var notificationArea = $(document);
				if (event) {
					notificationArea = $(event.target);
				}
				var ctrlAmount = $$('txtAmount');
				var amount = null;
				if (ctrlAmount) {
					amount = parseFloat(ctrlAmount.value);
				}

				if (!product.Id || !this.cart || (product.IsRequiredAmount && !amount)) {
					document.location = product.Url; // template product
					return;
				}

				this.removeNotification();
				var urlAjax = '/api/add-to-cart?idProduct=' + product.Id;
				var specs = null;
                if (product.Specifications || this.giftCardSpecificationsNumber) {
					specs = {};
                    if (this.giftCardSpecificationsNumber && this.giftCardSpecificationsNumber.length == 3) {
                        specs[this.giftCardSpecificationsNumber[0]] = this.giftCardSpecificationsValue.From;
						specs[this.giftCardSpecificationsNumber[1]] = this.giftCardSpecificationsValue.To;
						specs[this.giftCardSpecificationsNumber[2]] = this.giftCardSpecificationsValue.Msg;
                    }
                    for (var i in product.Specifications) {
						var specificationDef = product.Specifications[i];
						// ask for values
						var spec = prompt(specificationDef.Label);
						if (!spec && specificationDef.IsRequired) {
							notificationArea.notify(specificationDef.Label, 'error');
							return;
						}
						specs[specificationDef.Id] = spec;
                    }
					
					urlAjax += '&specification=' + encodeURIComponent(JSON.stringify(specs));
                }

				// check if a input control is present, if soo get the quantity
				var ctrlQty = $$('txtQty');
				if (ctrlQty) {
					qty = parseInt(ctrlQty.value);
					if (!isNaN(qty)) {
						urlAjax += '&qty=' + qty;
					}
				}

				// check if a input control is present for price (gift card)
				if (!isNaN(amount)) {
					urlAjax += '&amount=' + amount;
				}

				if (exist('wishlistId')) {
					urlAjax = urlAjax + '&idCustomerWishList=' + wishlistId;
				}

				jQuery.ajax(urlAjax)
					.done(function (data) {
						if (data.Error) {
							notifyError(data.Error, notificationArea, {position: 'bottom'});
							return;
						} 
						vm.$set(vm, 'cart', data);

						if (exist('_FacebookPixel')) {
							// get price without the $
							var price = GetPriceNoSymbol(data.LastProductAddedPrice);
							fbq('track', 'AddToCart', { value: price, currency: 'CAD', content_name: data.LastProductAddedTitle, content_type:'product',content_ids:product.Id.toString() });
						}
                        if (exist('gtag')) {
							gtag("event", "add_to_cart", {currency: "CAD",value: price,items: [GetGoogleProductById(product.Id)]});
                        }

						Vue.nextTick(function () {
							var cartNotification = jQuery('#cart-notification');
							cartNotification.slideDown();
							timerAutoHide = setTimeout(function () {
								cartNotification.slideUp();
							}, 7000);
						});
					});
			},
			ProductNotificationSet: function (set, event) {
				// set the query to the server
				var query = { IdProduct: this.productData.Id, Email: this.cart.Email, Set: set }
                fetchPost('/Api/Product-Notification/', query, null, (response) => {
                    vm.productData.Notify = set;
                });
            },
			wishListAdd: function (product, event) {
				if (!product.Id || !this.cart) {
					document.location = product.Url; // template product
					return;
				}
				if (!this.session.IsLogged) {
					// customer not logged, must go via the connection
					document.location = '/fr/POS_VoirListeCadeaux.aspx?addProduct' + product.Id;
					return;
				}
				this.removeNotification();
				var component = this;
				jQuery.ajax('/api/wishlist-add/?idProduct=' + product.Id)
					.done(function (data) {
						 if (exist('gtag')) {
							gtag("event", "add_to_wishlist", {currency: "CAD",value: product.Price, items: [GetGoogleProductById(product.Id)]});
                        }
						component.updateWishlist(data, event);
					});
			},
			wishListRemove: function (product, event) {
				if (!product.Id || !this.cart || !this.session.IsLogged) {
					return;
				}
				jQuery('#wishlist-notification').hide();
				var component = this;
				jQuery.ajax('/api/wishlist-remove/?idProduct=' + product.Id).done(function (data) {
					component.updateWishlist(data, event);
				});
			},
			updateWishlist: function (data, event) {
				this.wishList = data;
				wishListNotification(event);
			},
			isInWishList: function (product) {
                return this.wishList && this.wishList.Products && this.wishList.Products.includes(product.Id);
			},
			removeNotification: function () {
				if (timerAutoHide) {
					clearTimeout(timerAutoHide);
				}
				jQuery('.notification').hide();
			},

			formatDate: function (date) {
				return moment(date).format("D MMM");
			},
			availabilityTag: function (product) {
				if (product.Qty > 0) {
					return "InStock";
				} else if (product.IsPreOrder) {
					return "PreOrder";
				} else if (!product.CanBeViewOnline) {
					return "Discontinued";
				} else {
					return "OutOfStock";
				}
			},
			search: function (eventOrIdentifier) {
				var textToSearch;
				if (typeof (eventOrIdentifier) === 'string') {
					textToSearch = jQuery(eventOrIdentifier).val();
				} else {
					textToSearch = event.target.value;
				}
				triggerSearch(textToSearch);
			},
			setPrimaryImage: function (photoUrl) {
				if (!photoUrl) {
					return; // don't erase the photo
				}
				var img = $$('imgPicturePrimary');
				if (img != null) {
					var size = img.dataset["size"];
					if (!size) {
						size = 750;
					}
					img.src = this.getImageUrlWithSize(photoUrl, size);
					img.fullScreenUrl = this.getImageUrlWithSize(photoUrl, '1000');
				}
			},
			getImageUrlWithSize: function (imageUrl, sizeWanted) {
                if (!imageUrl) {
                    return null;
                }
				// check if the url contains the /wSIZE/ in the name
                const newImageUrlFormat = /\/(w[\d]+)\//;
                if (imageUrl.match(newImageUrlFormat)) {
                    const uri = new URL(imageUrl, document.location);
                    return  uri.toString().replace(newImageUrlFormat, '/w' + sizeWanted + '/');;  
                } else {
                    const uri = new URL(imageUrl, document.location);
                    uri.searchParams.set('size', sizeWanted);
                    return uri.toString();
                }
			},
            newLineToBr: function (input) {
                if (!input) {
                    return input;
                }
                return input.replace(/(?:\r\n|\r|\n)/g, '<br>');
            },
            hasAttrib: function(product, idAttrib, value) {
                var values = this.getAttribValues(product, idAttrib);
                if (!values) {
                    return false;
                }
                if (!value) {
                    value = 1; // yes
                }
                return values.includes(value); 
            },
            hasAttribMultipleValues(product, idAttrib) {
                var values = this.getAttribValues(product, idAttrib);
                if (!values) {
                    return false;
                }
                return values.length > 1; 
            },
            getAttribValues(product, idAttrib) {
                if (!product.Attribs) {
                    return null;
                }
                return product.Attribs[idAttrib];
            }
		},
		mounted: function () {
			// legacy
			if (this.storeOpenHours && this.storeOpenHours.length >= 1) {
				this.openHours = Object.assign({ }, this.storeOpenHours[0].Hours); // clone
				if (this.openHours.Normal.length === 8) {
					this.openHours.Normal = this.openHours.Normal.slice(1); // remove first value, 		
				}
			}

			if (this.productData && this.productData.Photos) {
				this.setPrimaryImage(this.productData.Photos[0]);
				if (exist('_FacebookPixel')) {
					// send to facebook the view content
					let facebookViewContentInfo = { value: this.productData.Price, currency: 'CAD', content_name: this.productData.Title};
                    if (this.productData.Id) {
						facebookViewContentInfo.content_type = 'product';
						facebookViewContentInfo.content_ids = this.productData.Id
                    } else {
						facebookViewContentInfo.content_type = 'product_group';
						facebookViewContentInfo.content_ids = products.map(p => p.Id);
                    }
					fbq('track', 'ViewContent', facebookViewContentInfo);
				}
			}
			if (window._attribFilter) {
				this.matrix = window.products;
                this.matrixProductsMatchingFilter = this.matrix;
				this.matrixFilters = [];
				this.attribsLookup = {};
						// add reactivity
				this.matrixDisplayPrice = false; // set to false if they all have the same price
				this.matrixDisplayImage = false; // set to false
				if (window.products && window.products.length >= 1) {
					var firstProduct = window.products[0];
					for (p of window.products) {
						if (p.Price !== firstProduct.Price || p.PriceDiscount !== firstProduct.PriceDiscount) {
							this.matrixDisplayPrice = true;
						}
						if (p.UrlImage) {
							this.matrixDisplayImage = true;
						}
					}
				}
				for (att of window.attribs) {
				// check if the attrib must be display in filter
					if (window._attribFilter.indexOf(att.Id) !== -1) {
						this.matrixFilters.push(att);
					}
					this.attribsLookup[att.Id] = att;
					if (att.Values.length === 1) {
						att.selected = att.Values[0];
					} else {
						// default selected value
						if (window.product) {
							this.setFilterSelected(att, product.Attrib[att.Id]);
						} else {
							// matrix
							if (!_WebMatrixFilterSelectAllByDefault) {
								this.setFilterSelected(att, -1); // de-select the select all
							}
						}
					}
				}
				// auto selection via querystring
                const params = new URLSearchParams(document.location.search);
                
                for(var attrib of params.keys()) {
					var filter = this.matrixFilters.find(f => f.Title === attrib); // check if a filter exist on that attrib
                    if (filter) {
                        var value = filter.Values.find(v => v.Text === params.get(attrib));
                        if (value) {
                            this.setFilterSelected(filter, value.Id);
                        }
                    }
                    
                }
			} else {
				// legacy code
				if (window.products && window.products.length > 1 && window.attribs.length === 1) { // if there is a single attrib
					this.matrix = window.products;
				}
			}
		}
		});

	function wishListNotification(event) {
		var cartNotification = jQuery('#wishlist-notification');
		if (cartNotification.length) {
			cartNotification.slideDown();
			timerAutoHide = setTimeout(function () {
				cartNotification.slideUp();
			}, 7000);
		} else if (event) {
			$(event.target).notify(event.target.getAttribute('title'));
		}
	}

	this.load = function (settings) {
		if (!settings) {
			return;
		}
		if (settings.bilingual != null) {
			vm.bilingual = settings.bilingual;
		}
		var newProductsSettings = settings.newProducts;
		if (newProductsSettings) {
			if (!newProductsSettings.nb) {
				newProductsSettings.nb = 6; // default value
			}
			// want to load the new products
			jQuery.ajax('/api/NewProducts?nb=' + newProductsSettings.nb + getAddLangQueryString()).done(function (data) {
				vm.$set(vm, 'productsNew', data);
				if (newProductsSettings.callback) {
					vm.$nextTick(newProductsSettings.callback);
				}
			}).fail(function () {
				$.notify('erreur de chargement des produits nouveaux', 'error');
			});
		}

		var starProductsSettings = settings.starProducts;
		if (starProductsSettings) {
			if (!starProductsSettings.nb) {
				starProductsSettings.nb = 6; // default value
			}
			// want to load the star products
			jQuery.ajax('/api/starProducts?nb=' + starProductsSettings.nb + getAddLangQueryString()).done(function (data) {
				vm.$set(vm, 'productsStar', data);
				if (starProductsSettings.callback) {
					vm.$nextTick(starProductsSettings.callback);
				}
			}).fail(function () {
				$.notify('erreur de chargement des produits vedettes', 'error');
			});
		}

		var eventSettings = settings.events;
		if (eventSettings) {
			if (!eventSettings.nb) {
				eventSettings.nb = 1; // default value
			}
			// want to load the star products
			jQuery.ajax('/api/events?nb=' + eventSettings.nb + getAddLangQueryString()).done(function (data) {
				vm.$set(vm, 'events', data);
				if (eventSettings.callback) {
					vm.$nextTick(eventSettings.callback);
				}
			}).fail(function () {
				$.notify('erreur de chargement des événements', 'error');
			});
		}

		if (settings.categories) {
			if (!settings.categories.level) {
				settings.categories.level = 1; // default value
			}

			jQuery.ajax('/api/Categories?level=' + settings.categories.level + getAddLangQueryString()).done(function (data) {
				vm.$set(vm, 'categories', data);
				if (settings.categories.callback) {
					vm.$nextTick(settings.categories.callback);
				}
			}).fail(function () {
				$.notify('erreur de chargement des categories', 'error');
			});
		}
	}
	return this;
}



function GetCategoryLookup() {
    let lookup = {};
	AddToLookupRecursive(lookup, window._categories);   
    return lookup;
}

function AddToLookupRecursive(lookup, lst) {
    if (!lst) {
		return;
    }
	 for (var cat of lst) {
            lookup[cat.Id] = cat;
		 AddToLookupRecursive(lookup, cat.SubCategories);
        }
}

function isMobile() {
	return window.matchMedia("only screen and (max-width: 767px)").matches;
}

function triggerSearch(query) {
	if (!query) {
		return; // do not search empty query
	}
    if (func_exists('onSearching')) {
        onSearching(query);
    }
	query = query.replace('&', '|');
	query = query.replace('*', ' ').replace('%', ''); // the * is not a supported valid character in .NET url
	document.location = "/" +getLang() + "/" + encodeURIComponent(query) + "-q";
}

function getLang() {
	var lang = jQuery('html').attr('lang');
	if (!lang) {
		return "fr";
	}
	if (lang.length > 2) {
		return lang.substr(0, 2);
	}
	return lang;
}

function getAddLangQueryString() {
	return '&lang=' + getLang();
}

function RedirectWithScroll(url) {
	var scroll = $(window).scrollTop();
	if (scroll != 0) {
		url += '?scroll=' + Math.round(scroll);
	}
	document.location = url;
}

function updateURLParameter(originalUrl, key, value) {
	var q = $.query.load(originalUrl);
	q.set(key, value);
	return q.toString();
}

$(function () {
	// Page load Completed
	$(".PDThum").click(function () { // obsolete 2019-1-17
		console.warn('Obsolete method img thumnail image called');
		var img = $$('imgPicturePrimary');
		img.src = vm.getImageUrlWithSize(this.src, 350);
		img.srcset = this.attributes["data-srcset"].value;
	});
    $('*[data-target=".search-toogle"]').mouseup(() => setTimeout(() => { $('#search-top').focus(); }, 100));
	$('#search, .search-text').keypress(function (e) {
		if (e.keyCode == '13') {
			e.preventDefault();
			triggerSearch(this.value);
		}
	});

	$("i.fa-search, .search-icon,#btnSearch").click((e) => { 
		var parent = e.target.parentElement;
		var ctrlInput = parent.querySelector('input');
		if (!ctrlInput) {
			ctrlInput = parent.parentElement.querySelector('input');
		}
		if (!ctrlInput) {
			console.log('Cannot find input control associated with the search button');
		} else {
			document.body.style.cursor = 'wait';
           	triggerSearch(ctrlInput.value);
           	document.body.style.cursor = 'default';
    		e.preventDefault(); 
		}
	});

	initCartSummary();
	PriceRangeFilter();
	ImagePopupSetup();
	$('.redirector select').change(function (e) {
		RedirectWithScroll(this.value);
	});
	InitFilterByStore();

	$('.menu-filter li a input').click(function () {
		this.parentElement.click();
	});

	// Big meny in mobile, trigger level 3 menu
    $('body').on('click', '.toogle-level-2', function() {
        $(this.nextElementSibling).toggle();
        return false;
    });

	if ($.query) {
		var scrollTo = $.query.get('scroll');
		if (scrollTo) {
			$(window).scrollTop(scrollTo);
		}
	}

	if (screen.width < 400) {
		var mvp = document.getElementById('vp');
		if (mvp) {
			mvp.setAttribute('content', 'width=400');
		}
	}

	$('#cmdNewsletter').click(function () {
		// subscribe to newsletter
		var email = $$('txtNewsletter').value;
		if (email) {
			$('.newsletter-result').hide(); // hide previous result
            var name = $('#txtNewsletterName').val();
			$.ajax('/api/newsletter?email=' + email + '&name=' + name).done(function (result) {
				$('.newsletter-result .email-address').html(result.Email);
				var sectionToShow;
				if (result.Error) {
					// invalid email
					sectionToShow = '#newsletter-result-invalid';
				} else if (result.Added) {
					// added to the list
					sectionToShow = '#newsletter-result-added';
				} else {
					// already added
					sectionToShow = '#newsletter-result-not-added';
				}
				$(sectionToShow).show();
			});
		}
	});

	$("select.form-control").change(function () {
		var href = $(this).val();
		if (href) {
			window.location.href = href;
		}
	});

	$('#open-search').click(function () {
		$('#top-search-bar').slideDown();
		document.getElementById('search').focus();
	});

	$('#close-search').click(function () {
		$('#top-search-bar').hide('slow');
	});

	window.onscroll = function () {
		$('#scroll-to-top').toggle(document.body.scrollTop > 20 || document.documentElement.scrollTop > 20);
	};

	$('#scroll-to-top').click(function () {
		$('html, body').animate({ scrollTop: 0 }, 'slow');
	});

	$('#search-result').on('shown.bs.collapse', function () {
		$('#search').trigger('focus');
	});

	if (window.location.hash.substr(1) == 'tlm') {
		// remove cookie that filter per store
		setCookie(cookieNameFilterByStore, '0', 1000);
	}
});

// text replacement
if (exist('_Text')) {
	for(e of document.querySelectorAll('t')) {
		var code = e.innerHTML; // innerText can be modified with css capitalized letter for instance
		var value = _Text[code];
		if (value != undefined) {
			var span = document.createElement('span');
            span.className = code;
			span.innerText = value;
			e.outerHTML = span.outerHTML;
		}
	}
	
	for (e of document.querySelectorAll('h')) {
		var code = e.innerText;
		var value = _Text[code];
		if (value != undefined) {
			var span = document.createElement('span');
            span.className = code;
			span.innerHTML = value;
			e.outerHTML = span.outerHTML;
		}
	}
}

var cookieNameFilterByStore = 'mag';
function InitFilterByStore() {
	var ctrlFilterByStore = $('#container-open-filter-by-store, .container-open-filter-by-store');
	if (ctrlFilterByStore.length === 0) {
		return;
	}
	if (window.PickStoreEnable && exist('storesName') && Object.keys(storesName).length > 1) {

		$('#cmdStorePreference').click(function () {
			// set cookie
			var storeSelected = $('input[type=radio]:checked', '.modal-body').val();
			fetch('/api/store/set?IdStore=' + storeSelected).then(response => document.location = $.query.SET('idStore', storeSelected).toString() );
			return;
		});

		var idStore = _storeSelected;
		var qsMag = $.query.get("mag");
		// create options
		var options = $$('other-stores');
		if (options) {
			if (PickStoreCanViewAllStore) {
				var op = document.createElement('input');
				op.type = 'radio';
				op.value = '0';
				op.name = 'stores';
				op.id = 'store-0';
				options.appendChild(op);
				var label = document.createElement('label');
				label.htmlFor = op.id;
				label.innerText = options.attributes['data-text'].value + 'Tous les magasins';
				options.appendChild(label);
				options.appendChild(document.createElement('br'));
			}
			for (var property of Object.keys(storesName)) {
				// do stuff
				var op = document.createElement('input');
				op.type = 'radio';
				op.value = property;
				op.name = 'stores';
				op.id = 'store' + property;
				if (qsMag == storesName[property]) {
					idStore = property;
				}
				options.appendChild(op);
				var label = document.createElement('label');
				label.htmlFor = op.id;
				label.innerText = options.attributes['data-text'].value + storesName[property];
				options.appendChild(label);
				options.appendChild(document.createElement('br'));
			}

			var filterActive = storesName[idStore];
			var active = false;
			if (idStore === "-1") {
				$('#store-express').prop("checked", true);
				filterActive = 'Express 24H';
				active = true;
			} else {
				if (!filterActive) {
					filterActive = null; // 'Filtre par magasin';
					$('#store-0').prop( "checked", true );
				} else {
					$('#store' + idStore).prop( "checked", true );
					active = true;
				}
			}
			if (filterActive) {
                var filter = $$('cmdOpenFilterByStore');
                if (filter) {
                    filter.innerText = filterActive;
                }
			}
			
			ctrlFilterByStore.toggleClass('active', active);
		}

		ctrlFilterByStore.css('display', 'inline-block');


		if (window.location.hash === '#options' || !exist('_storeSelected') || (!_storeSelected && !PickStoreCanViewAllStore)) {
			$("#store-picker").modal();
		}
	}
}


function PriceRangeFilter() {
	var range = $$('slider-price');
	if (!range) {
		return;
	}
	noUiSlider.create(range, {
		start: [_priceRangeMinFiltered, _priceRangeMaxFiltered], // Handle start position
		step: _priceRangeStep, // Slider moves in increments of '5'
		margin: _priceRangeStep, // Handles must be more than '5' apart
		connect: true, // Display a colored bar between the handles
		behaviour: 'tap-drag', // Move handle on tap, bar is draggable
		range: {
			'min': _priceRangeMin,
			'max': _priceRangeMax
		},

	});
	range.noUiSlider.on('update', function () {
		var selectedRange = range.noUiSlider.get();
		var minSelected = parseInt(selectedRange[0]);
		var maxSelected = parseInt(selectedRange[1]);
		$$('slider-price-min').innerText = minSelected;
		$$('slider-price-max').innerText = maxSelected;
	});
	range.noUiSlider.on('change', function () {
		var selectedRange = range.noUiSlider.get();
		var minSelected = parseInt(selectedRange[0]);
		var maxSelected = parseInt(selectedRange[1]);
		var originalValue = range.noUiSlider.options.range;
		if (minSelected == originalValue.min && maxSelected == originalValue.max) {
			document.location = _priceRangeToUrlWithoutPrice;
		} else {
			document.location = _priceRangeToUrlWithoutPrice + '/' + minSelected + '-r' + maxSelected;
		}
	});
}

function swapImageWithParent(imgClicked) {
	var src = imgClicked.src;
	var hiRezImg = imgClicked.attributes["data-hi-rez"];
	if (hiRezImg) {
		src = hiRezImg.value;
	}
	$(imgClicked).parent().parent().find('.product-image-primary').attr("src", src);
}
/* Cart Update */ 

function updateQuantity(input) {
    var currentValue = parseInt(input.val());
    var previousValue = parseInt(input.attr("previousValue"));
    if (!isNaN(currentValue) && currentValue != previousValue) {
        var tag = input.attr('tag');
        RequestUpdateLineToServer(tag, currentValue, "input[type=number][tag='" + tag + "'");
        input.attr("previousValue", currentValue); // Update the previousValue attribute to the new value
    } else {
        if (isNaN(currentValue)) {
            input.val(previousValue); // Reset to previousValue if the current is not a number
        }
    }
}

function initCartSummary() {
  $(".quantitySummary")
    .focusin(function () { $(this).next().show(); })
	.on('mouseup mousedown', function () {
        updateQuantity($(this));
    })
    .bind('blur keydown', function (e) {
        if (e.type == 'blur' || e.keyCode == '13') {
            e.preventDefault();
            updateQuantity($(this));
        }
    });
	$(".removeFromCart").click(function () {
		RequestUpdateLineToServer($(this).attr('tag'), 0);
  });
  $("#radSummaryShip").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=1');
  });
  $("#radSummaryPickup").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=4');
    setTimeout(() => { $('#rowSummaryPickup .fa-info-circle').click(); }, 100); // must be on a timer since the html get updated
  });
  $("#radSummaryCarrier").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=2');
  });
  $("#radSummaryLocal").click(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=3');
	  setTimeout(() => { $('#rowSummaryLocal .fa-info-circle').click(); }, 100); // must be on a timer since the html get updated
  }); 
  $("#radSummaryDropLocation").click(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=5');
  });
  $("#lstSummaryShippingStore").change(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shippingStore&value=' + this.value);
  });
  $("#lstSummaryShippingDropLocation").change(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=5&store=' + this.value);
  });
  $("#lstStoreLocalShipping").change(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=3&store=' + this.value);
  });
  $("#cmdAddPromoCode").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=promo&value=' + $$('txtPromoCode').value);
  });
  $("#lstPoints").change(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=points&value=' + $$('lstPoints').value);
  });
  var input = $$("txtPromoCode");
  if (input) {
  	input.addEventListener("keyup", function (event) {
  		if (event.keyCode === 13) {
  			event.preventDefault();
  			document.getElementById("cmdAddPromoCode").click();
  		}
  	});
  }

  $(".PromoCodeDelete").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=promoDelete&value=' + $(this).attr('tag'));
  });
  $("#txtCarrierName").change(function() {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=carrier&value=' + this.value, 'txtCarrierClientId');
  });
  $("#txtCarrierClientId").change(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=carrierClientId&value=' +this.value, 'cmdComplete');
	});
  if (typeof (initCartSummaryCustom) == typeof (Function)) {
    initCartSummaryCustom();
  }
  var popoverCtrls = $('[data-toggle="popover"]');
  if (popoverCtrls.popover) {
		popoverCtrls.popover();
	}
}


$(document).mouseup(function (e) {
    $(document).on("click", ".popover", function () {
        $(this).closest(".popover").popover('hide'); // auto close popup
        //return false;
    });
});

function RequestUpdateLineToServer(tag, value, idCtrlDisplayNotification) {
	RequestUpdateToServer('/Ajax/CartUpdate.ashx?tag=' + tag + '&qty=' + value, idCtrlDisplayNotification, idCtrlDisplayNotification);
}

function RequestUpdateToServer(urlAjax, idCtrlToFocus, idCtrlDisplayNotification) {
    $('.popover').hide();
	$.ajax({
		 	url: urlAjax,
		 	success: function (html) {
		 		$$("cart").innerHTML = html;
		 		initCartSummary(); // rebind the new fields
		 		if (idCtrlToFocus) {
		 			$(idCtrlToFocus).focus();
		 		}
		 		if (idCtrlDisplayNotification) {
		 			// if any message, display it at the ctrl
		 			var msg = $('#cart > .user-message .msg-content');
					 if (msg) {
					 	$(idCtrlDisplayNotification).popover({content: msg.text(), trigger: 'focus', placement:"bottom"});
					 	$(idCtrlDisplayNotification).popover('show');
					 }
				 }
		 	},
		 	error: function (jqXhr, textStatus, errorThrown) {
		 		$.notify('Erreur lors de la modification du panier ' + errorThrown, 'error');
		 	}
		});
}

function clickButton(e, buttonid) {
  var evt = e ? e : window.event;
  var bt = $$(buttonid);
  if (bt) {
    if (evt.keyCode == 13) {
      bt.click();
      return false;
    }
  }
}

function SearchSelection(source, eventArgs) {
  document.location = "search.aspx?q=" + eventArgs.get_text();  
}

function search(searchBox, event) {
  if (event.keyCode == 13) {
    document.location = 'Search.aspx?q=' + encodeURI(searchBox.value);
    event.cancelBubble = true;
    event.returnValue = false;
    return false; 
  }
  return true;
}


$(document).scroll(function () {
	var y = $(this).scrollTop();
	if (y > 400) {
		$('.visibleBottom').fadeIn();
	} else {
		$('.visibleBottom').fadeOut();
	}
});

function UnHide(ctr) {
  $(ctr).hide();
  $(ctr).siblings().removeClass('hide');
}

// Navigate to the url specified in the option of the select input
function selectNavigateTo(sel) {
  document.location.href = sel.options[sel.selectedIndex].getAttribute('data-url');
}

function RedirectToLoginPage(extraQueryString) {
  var lang = 'fr';
  if (document.location.href.indexOf('/en/') !== -1) {
    lang = 'en';
  }
	var url = '/' + lang + '/login.aspx';
	if (extraQueryString) {
		url += extraQueryString;
	}
	document.location = url;
}

function ImagePopupSetup() {
	var modal = $$('modalImage');
	var img = $$('imgPicturePrimary');
	var modalImg = $$("img01");
	var captionText = $$("caption");
	if (img && modal) {
		img.onclick = function () {
			modal.style.display = "block";
			if (this.fullScreenUrl) {
				modalImg.src = this.fullScreenUrl;
			} else {
				modalImg.src = this.srcset; // obsolete with fullScreenUrl
			}
			if (captionText) {
				captionText.innerHTML = this.alt;
			}
		}

		// Get the <span> element that closes the modal
		var span = document.getElementsByClassName("close")[0];

		// When the user clicks on <span> (x), close the modal
		span.onclick = function () {
			modal.style.display = "none";
		}
	}

}

/* code to be remove, wishlist not using VueJs... yet  */
function WishListOperation(add, idProduct) {
	var operation = add ? 'add' : 'remove';
	$.ajax('/ajax/wishlish.axd?operation=' + operation + '&idProduct=' + idProduct).done(function (data) {
		if (data.LoginRequired) {
			RedirectToLoginPage("?Action=Wishlist&AddWishLish=" + idProduct);
			return;
		}
		if (data.NbProducts == 0 && !exist("displayWishlistCountZero")) {
			data.NbProducts = '';
		}
		$(".wishlist-nb-items").html(data.NbProducts);
		if (data.Error) {
			$.notify(data.Error);
		}
		if (add) {
			$('.add-to-wishlish').addClass('hide');
			$('.remove-from-wishlish').removeClass('hide');
		} else {
			$('.add-to-wishlish').removeClass('hide');
			$('.remove-from-wishlish').addClass('hide');

			// remove the item from the list (in the listing page)
			$('#wishlist-product-' + idProduct).hide();
		}
	});
}

var emailLinks = document.getElementsByClassName('email');
for (i = 0; i < emailLinks.length; i++) {
	var ctrl = emailLinks[i];
	
	var email = ctrl.getAttribute('data-email') + '@' + ctrl.getAttribute('data-domain');
	ctrl.href = 'mailto:' + email;
	ctrl.innerText = email;
}


function setCookie(cname, cvalue, exdays) {
	var d = new Date();
	d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
	var expires = "expires=" +d.toUTCString();
	document.cookie = cname + "=" + cvalue + "; " + expires + "; path=/";
}

function getCookie(cname) {
	var name = cname + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') c = c.substring(1);
		if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
	}
	return "";
}

function shuffle(a) {
	var j, x, i;
	for (i = a.length - 1; i > 0; i--) {
		j = Math.floor(Math.random() * (i + 1));
		x = a[i];
		a[i] = a[j];
		a[j] = x;
	}
}

/* obsolete function that should be remove when every web site is using the vuejs framework  2019-2-11 */
function addToCart(idProduct, ctr, requestConfirmation, notused, wishlistId) {
	console.warn('Obsolete add to cart');
	if (requestConfirmation) {
		if (typeof g_PreventAddToCartIfOutOfStock !== 'undefined') {
			$.notify(g_PreventAddToCartIfOutOfStock);
			return;
		}
		if (!confirm(strOutOfStock)) {
			return;
		}
	}
	var divLoading = $('<div id=loading style="width:200px; position:absolute">Chargement / Loading...</div>').insertAfter($('body'));
	var offset = $(ctr).offset();
	offset.top += 30;
	divLoading.offset(offset);
	var urlAjax = '/api/add-to-cart?idProduct=' + idProduct;

	// check if a input control is present, if soo get the quantity
	var ctrlQty = $$('txtQty');
	if (ctrlQty) {
		qty = parseInt(ctrlQty.value);
		if (!isNaN(qty)) {
			urlAjax += '&qty=' + qty;
		}
	}

	// check if a input control is present for price (gift card)
	var ctrlAmount = $$('txtAmount');
	var amount;
	if (ctrlAmount) {
		amount = parseFloat(ctrlAmount.value);
		if (!isNaN(amount)) {
			urlAjax += '&amount=' + amount;
		}
	}

	if (wishlistId != undefined) {
		urlAjax = urlAjax + '&idCustomerWishList=' + wishlistId;
	}
	if (timerAutoHide) {
		clearTimeout(timerAutoHide);
	}
	$.ajax({
		url: urlAjax,
		success: function (json) {
			divLoading.hide();
			var cartNotification = $("#cart-notification");
			if (cartNotification.length === 0) {
				// if the page have no cart notification section, the user is redirected to the cart summary.
				document.location = "/" + $('html').attr('lang') + '/POS_Sommaire.aspx';
				return;
			}

			var cartCountCtrl = $('.cart-nb-items');
			if (cartCountCtrl.length > 0) {
				var cartRecentItemTitle = $$('cart-recent-item-title');
				if (cartRecentItemTitle) {
					cartRecentItemTitle.innerText = json.LastProductAddedTitle;
				}
				var cartRecentItemImage = $$('cart-recent-item-image');
				if (cartRecentItemImage) {
					cartRecentItemImage.src = json.LastProductAddedImage;
				}
				var cartRecentItemPrice = $$('cart-recent-item-price');
				if (cartRecentItemPrice) {
					cartRecentItemPrice.innerText = json.LastProductAddedPrice;
				}

				if (json.Messages) {
					for (var i = 0; i < json.Messages.length; i++) {
						$.notify(json.Messages[i]);
					}
				}
				cartNotification.slideDown();
				timerAutoHide = setTimeout(function () {
					cartNotification.slideUp();
				}, 5000);

			}

			if (exist('_FacebookPixel')) {
				// get price without the $
				var price = GetPriceNoSymbol(json.LastProductAddedPrice);
				fbq('track', 'AddToCart', { value: price, currency: 'CAD', content_name: json.LastProductAddedTitle });
			}

		},
		error: function (jqXHR, textStatus, errorThrown) {
			$.notify('Error: ' + errorThrown);
		}
	});
}

function GetPriceNoSymbol(strPrice) {
	return strPrice.slice(0, -2).replace(',', '.');
}

$('body').on('click', function (e) {
	$('[data-toggle=popover]').each(function () {
		// hide any open popovers when the anywhere else in the body is clicked
		if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
			$(this).popover('hide');
		}
	});
});

function notifyError(msg, ctrl, options) {
    notify({ Category: 3, Text: msg }, ctrl, options);
}

/* Notify the user about some
 msg can be a string or a UserMessage structure
 */
function notify(msg, ctrl, options) {
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
					text = '��';
                } else {
                    text = '!';
                }
            } else {
                return; // this is a notification message
            }
            
        }
        var translationValue = _Text[text];
        if (translationValue) {
            text = translationValue;
        } 
        if (msg && msg.Title) {
            text = msg.Title + '\n' + text;
        }
    }

    if (!options) {
		options = {};
    }
	options.className = classNotification;
	notification.notify(text, options);
}

// return the google product (for google analytic) by id of the Comelin
function GetGoogleProductById(idProduct) {
	if (exist('_GoogleProducts')) {
		return _GoogleProducts.find(product => product.item_id == idProduct);
	}
}

function fetchPost(url, dataObj, ctrl, callback, finallyCallback) {
    $('body').addClass('waiting');
    let error = null;
    fetch(url, {
            method: 'post',
            body: JSON.stringify(dataObj)
        }).then(response => {
            if (!response.ok) {
                error = response.statusText; // continue with response.json to get the stream error details
                if (!error) {
					error = "Error / Erreur";
                }
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
                notify(response,ctrl);
            }
        }).catch((error) => {
            notifyError(error + '\n' + url,ctrl);
        }).finally(() => {
            $('body').removeClass('waiting');
            if (finallyCallback) {
                finallyCallback();
            }
        });
}

// Query String Modification https://github.com/alrusdi/jquery-plugin-query-object  2.2.3 [Obsolete, use URI builtin object]
new function (e) { var t = e.separator || "&", n = !1 !== e.spaces, r = (e.suffix, !1 !== e.prefix ? !0 === e.hash ? "#" : "?" : ""), i = !1 !== e.numbers; jQuery.query = new function () { var e = function (e, t) { return null != e && null !== e && (!t || e.constructor == t) }, u = function (e) { for (var t, n = /\[([^[]*)\]/g, r = /^([^[]+)(\[.*\])?$/.exec(e), i = r[1], u = []; t = n.exec(r[2]) ;) u.push(t[1]); return [i, u] }, s = function (t, n, r) { var i = n.shift(); if ("object" != typeof t && (t = null), "" === i) if (t || (t = []), e(t, Array)) t.push(0 == n.length ? r : s(null, n.slice(0), r)); else if (e(t, Object)) { for (var u = 0; null != t[u++];); t[--u] = 0 == n.length ? r : s(t[u], n.slice(0), r) } else (t = []).push(0 == n.length ? r : s(null, n.slice(0), r)); else if (i && i.match(/^\s*[0-9]+\s*$/)) { t || (t = []), t[c = parseInt(i, 10)] = 0 == n.length ? r : s(t[c], n.slice(0), r) } else { if (!i) return r; var c = i.replace(/^\s*|\s*$/g, ""); if (t || (t = {}), e(t, Array)) { var o = {}; for (u = 0; u < t.length; ++u) o[u] = t[u]; t = o } t[c] = 0 == n.length ? r : s(t[c], n.slice(0), r) } return t }, c = function (e) { var t = this; return t.keys = {}, e.queryObject ? jQuery.each(e.get(), function (e, n) { t.SET(e, n) }) : t.parseNew.apply(t, arguments), t }; return c.prototype = { queryObject: !0, parseNew: function () { var e = this; return e.keys = {}, jQuery.each(arguments, function () { var t = "" + this; t = (t = t.replace(/^[?#]/, "")).replace(/[;&]$/, ""), n && (t = t.replace(/[+]/g, " ")), jQuery.each(t.split(/[&;]/), function () { var t = decodeURIComponent(this.split("=")[0] || ""), n = decodeURIComponent(this.split("=")[1] || ""); t && (i && (/^[+-]?[0-9]+\.[0-9]*$/.test(n) ? n = parseFloat(n) : /^[+-]?[1-9][0-9]*$/.test(n) && (n = parseInt(n, 10))), n = !n && 0 !== n || n, e.SET(t, n)) }) }), e }, has: function (t, n) { var r = this.get(t); return e(r, n) }, GET: function (t) { if (!e(t)) return this.keys; for (var n = u(t), r = n[0], i = n[1], s = this.keys[r]; null != s && 0 != i.length;) s = s[i.shift()]; return "number" == typeof s ? s : s || "" }, get: function (t) { var n = this.GET(t); return e(n, Object) ? jQuery.extend(!0, {}, n) : e(n, Array) ? n.slice(0) : n }, SET: function (t, n) { var r = e(n) ? n : null, i = u(t), c = i[0], o = i[1], a = this.keys[c]; return this.keys[c] = s(a, o.slice(0), r), this }, set: function (e, t) { return this.copy().SET(e, t) }, REMOVE: function (t, n) { if (n) { var r = this.GET(t); if (e(r, Array)) { for (tval in r) r[tval] = r[tval].toString(); var i = $.inArray(n, r); if (!(i >= 0)) return; t = (t = r.splice(i, 1))[i] } else if (n != r) return } return this.SET(t, null).COMPACT() }, remove: function (e, t) { return this.copy().REMOVE(e, t) }, EMPTY: function () { var e = this; return jQuery.each(e.keys, function (t, n) { delete e.keys[t] }), e }, load: function (e) { var t = e.replace(/^.*?[#](.+?)(?:\?.+)?$/, "$1"), n = e.replace(/^.*?[?](.+?)(?:#.+)?$/, "$1"); return new c(e.length == n.length ? "" : n, e.length == t.length ? "" : t) }, empty: function () { return this.copy().EMPTY() }, copy: function () { return new c(this) }, COMPACT: function () { return this.keys = function t(n) { var r = "object" == typeof n ? e(n, Array) ? [] : {} : n; "object" == typeof n && jQuery.each(n, function (n, i) { if (!e(i)) return !0; !function (t, n, r) { e(t, Array) ? t.push(r) : t[n] = r }(r, n, t(i)) }); return r }(this.keys), this }, compact: function () { return this.copy().COMPACT() }, toString: function () { var i = [], u = [], s = function (e) { return e += "", e = encodeURIComponent(e), n && (e = e.replace(/%20/g, "+")), e }, c = function (t, n) { var r = function (e) { return n && "" != n ? [n, "[", e, "]"].join("") : [e].join("") }; jQuery.each(t, function (t, n) { "object" == typeof n ? c(n, r(t)) : function (t, n, r) { if (e(r) && !1 !== r) { var i = [s(n)]; !0 !== r && (i.push("="), i.push(s(r))), t.push(i.join("")) } }(u, r(t), n) }) }; return c(this.keys), u.length > 0 && i.push(r), i.push(u.join(t)), i.join("") } }, new c(location.search, location.hash) } }(jQuery.query || {});


if (exist('vueComponents')) {
	for (var i = 0; i < vueComponents.length; i++) {
		vueComponents[i](); // register the components
	}
}

comelin = Comelin({}); // automatically init the script and create the Vue object

function shareOnPinterest() {
	var url ='https://www.pinterest.com/pin/create/button/?url=' + window.location.href
			+ '&description=' + encodeURI(document.title);
	if (exist('_productData')) {
	    url +=  '&media=' + new URL(_productData.UrlImage, document.baseURI).href;
	}
	window.open(url);
}

// popup usage: <div id=popup data-name="popup1" data-expiration="7">...</div>
OnLoaded(() => {
	var popup = $$('popup');
	if (popup) {
		if (shouldOpenPopup(popup)) {
			console.log('open popup');
			setTimeout(function(){$(popup).fadeIn();}, 5000);
			// fermer par le X
		  $(popup).find('#closeBtn,#modal-fond,.close').on('click',function(){
		   	$(popup).fadeOut();
		  });
		}
 	}
});
function shouldOpenPopup(element) {
    var currentName = element.dataset.name || "noname";
    var currentTime = new Date().getTime();
    var nbDaysExpiration = element.dataset.expiration || 7;
    var expirationTime = nbDaysExpiration * 24 * 60 * 60 * 1000;
	const storageEntryName = 'popupData'
    var storedData = JSON.parse(window.localStorage.getItem(storageEntryName) || '{}');
    if (storedData.name && storedData.time) {
        if (storedData.name === currentName && (currentTime - storedData.time < expirationTime)) {
            return false; // Same name and not yet expired
        }
    }
    storedData = { name: currentName, time: currentTime };
    window.localStorage.setItem(storageEntryName, JSON.stringify(storedData));
    return true;
}