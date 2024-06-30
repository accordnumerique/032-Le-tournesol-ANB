// Integration de Comelin dans les sites web
// (c) Comelin 2018
/**
 
 Exemple d'utilisation

		var comelin = new Comelin({
		id:'app',
		website:'example.com',
		newProduct: {
			nb: 4,
			callback: myFunction
		},
		starProducts: {
			nb: 3
		},
		events: {
			nb: 1
		},
		categories { level: 2}
 });

 aussi vous pouvez utiliser 
 comelin.load({
	starProducts: {
			nb: 4, 
			callback: onProductsStar
		}
 })

  */



function Comelin(settings) {
	var idCtlr = settings.id;
	if (!idCtlr) {
		console.log('Comelin must be imitated with the property id, the id can be the a root element of the page.');
		return;
	}
	var ctrl = document.getElementById(idCtlr);
	if (!ctrl) {
		console.log('Element ' + idCtlr + ' non trouvé');
		return;
	}
	var website = settings.website;
	var isLocal = true;
	if (website) {
		isLocal = false; // the website is defined some functions will not be available because of CORS
	} else {
		website = ''; // the website is not defined, so we assume it's same domaine
	}
	

	vm = new Vue({
		el: '#' +idCtlr,
		data: {
			productsNew: null,
			productsStar: null,
			events: null,
			categories:null,
			cart: null,
			wishlist: null,
			local: isLocal,
			website : website
		},
		methods: {
			AddToCart: function(product) {
				if (!product.Id || !this.cart) {
					document.location = product.Url; // template product
					return;
				}
				this.removeNotification();
				jQuery.ajax(website + '/api/add-to-cart/?idProduct=' +product.Id)
					.done(function (data) {
						vm.$set(vm, 'cart', data);
						var cartNotification = jQuery('#cart-notification');
						cartNotification.slideDown();
						timerAutoHide = setTimeout(function () {
							cartNotification.slideUp();
						}, 7000);
					});
			},
			AddToWishlist: function (product) {
				if (!product.Id || !this.cart) {
					document.location = product.Url; // template product
					return;
				}
				if (!this.cart.IsLogged) {
					// customer not logged, must go via the connection
					document.location = website + '/fr/POS_VoirListeCadeaux.aspx?addProduct' +product.Id;
				}
				this.removeNotification();
				jQuery.ajax(website + '/api/wishlist-add?idProduct=' + product.Id)
					.done(function (data) {
						vm.$set(vm, 'wishlist', data);
						var cartNotification = jQuery('#wishlist-notification');
						cartNotification.slideDown();
						timerAutoHide = setTimeout(function () {
							cartNotification.slideUp();
						}, 7000);
					});
			},
			removeNotification: function () {
				if(timerAutoHide) {
					clearTimeout(timerAutoHide);
				}
				jQuery('.notification').hide();
			},
			formatPrice: function (value) {
				return Intl.NumberFormat('fr-CA', { style: 'currency', currency: 'CAD' }).format(value);
			},
			search: function (eventOrIdentifier) {
				var textToSearch;
				if (typeof(eventOrIdentifier) === 'string') {
					textToSearch = jQuery(eventOrIdentifier).val();
				} else {
					textToSearch = event.target.value;
				}
				triggerSearch(textToSearch);
			}
		}
	});


	function triggerSearch(query) {
		if (!query) {
			return; // do not search empty query
		}
		query = query.replace('&', '|');
		document.location = website + "/" + getLang() + "/" + encodeURIComponent(query) + "-q";
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

	// load cart info
	if (isLocal) { // can only display cart information if on the same domain name
		jQuery.ajax(website + '/api/cart-info').done(function (data) {
			vm.$set(vm, 'cart', data);
		}).fail(function () { $.notify('Erreur de chargement du panier. Le panier fonctionne seulement sur le même nom de domaine.', 'error'); });
	}

	this.load = function (settings) {
		var newProductsSettings = settings.newProducts;
		if (newProductsSettings) {
			if (!newProductsSettings.nb) {
				newProductsSettings.nb = 6; // default value
			}
			// want to load the new products
			jQuery.ajax(website + '/api/NewProducts?nb=' + newProductsSettings.nb).done(function (data) {
				setUrlWithDomain(isLocal,website, data);
				vm.$set(vm, 'productsNew', data);
				if (newProductsSettings.callback) {
					vm.$nextTick(newProductsSettings.callback);
				}
			}).fail(function () { $.notify('erreur de chargement des produits nouveaux', 'error'); });
		}

		var starProductsSettings = settings.starProducts;
		if (starProductsSettings) {
			if (!starProductsSettings.nb) {
				starProductsSettings.nb = 6; // default value
			}
			// want to load the star products
			jQuery.ajax(website + '/api/starProducts?nb=' + starProductsSettings.nb).done(function (data) {
				setUrlWithDomain(isLocal,website, data);
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
			jQuery.ajax(website + '/api/events?nb=' + eventSettings.nb).done(function (data) {
				setUrlWithDomain(isLocal,website, data);
				vm.$set(vm, 'events', data);
				if (eventSettings.callback) {
					vm.$nextTick(eventSettings.callback);
				}
			}).fail(function () {
				$.notify('erreur de chargement des événements', 'error');
			});
		}

		var eventCategories = settings.categories;
		if (eventCategories) {
			if (!eventCategories.level) {
				eventCategories.level = 1; // default value
			}

			jQuery.ajax(website + '/api/Categories?level=' + eventCategories.level).done(function (data) {
				setUrlWithDomain(isLocal,website, data);
				vm.$set(vm, 'categories', data);
				if (eventCategories.callback) {
					vm.$nextTick(eventCategories.callback);
				}
			}).fail(function () {
				$.notify('erreur de chargement des categories', 'error');
			});
		}
	}

	this.load(settings);
	return this;
}

function setUrlWithDomain(isLocal, website, data) {
    if (!isLocal) {
        for (var i = 0; i < data.length; i++) {
            var obj = data[i];
            // set url to absolute
            obj.Url = website + obj.Url;
            if (obj.UrlImage && !obj.UrlImage.startsWith('http')) {
				obj.UrlImage = website + obj.UrlImage; // image url could be absolute if externaly hosted
            }
            if (obj.UrlBrand) {
                obj.UrlBrand = website + obj.UrlBrand;
            }
            if (obj.SubCategories) {
                setUrlWithDomain(isLocal, website, obj.SubCategories);
            }
        }
    }
}

 var timerAutoHide; // timer pour cacher la notification d'ajout au panier	