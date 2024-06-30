// Comelin interaction general (c) Jean-Claude Morin (version pre-2018 sans VueJs)

function $$(element) { return document.getElementById(element); } // shortcut
function exist(variable) {return variable in window;} // more intuitive

//https://stackoverflow.com/questions/126100/how-to-efficiently-count-the-number-of-keys-properties-of-an-object-in-javascrip
if (!Object.keys) {
	Object.keys = function (obj) {
		var keys = [],
            k;
		for (k in obj) {
			if (Object.prototype.hasOwnProperty.call(obj, k)) {
				keys.push(k);
			}
		}
		return keys;
	};
}

var _DisplayPrimaryImageSize = 350;

// this method can be override if the search is customized
function triggerSearch(query) {
  searchFor(query);
}

function searchFor(query) {
	query = query.replace('&', '|');
  document.location = "/" + $('html').attr('lang') + "/" + encodeURIComponent(query) + "-q";
}

function RedirectWithScroll(url) {
	var scroll = $(window).scrollTop();
	if (scroll != 0) {
		url += '?scroll=' + Math.round(scroll);
	}
	document.location = url;
}
 
$(function() {
	// Page load Completed
	$(".PDThum").click(function() {
		var img = $$('imgPicturePrimary');
		img.src = updateURLParameter(this.src, 'size', _DisplayPrimaryImageSize);
		img.srcset = this.attributes["data-srcset"].value;
	});

	$('#search').value = $.query.get('q');

	$('#search, .search-text').keypress(function(e) {
		if (e.keyCode == '13') {
			e.preventDefault();
			triggerSearch(this.value);
		}
	});

	initCartSummary();

	$(document).ajaxError(function(event, jqxhr, settings, exception) {
		alert('Erreur de javascript ' + settings.url);
	});

	if (typeof gIsLogged != 'undefined' && gIsLogged) {
		$('.visibleIfAnonymous').hide();
	} else {
		$('.visibleIfLogged').hide();
	}

	$('.wrap-single-produit').responsiveEqualHeightGrid();

	UpdateECommerceData();
	PriceRangeFilter();
	ImagePopupSetup();
	$('.redirector select').change(function (e) {
		RedirectWithScroll(this.value);
	});
	InitFilterByStore();

	$('.menu-filter li a input').click(function () {
		this.parentElement.click();
	});

	if ($.query) {
		var scrollTo = $.query.get('scroll');
		if (scrollTo) {
			$(window).scrollTop(scrollTo);
		}
	}
});

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

	for(e of document.querySelectorAll('h')) {
		var code = e.innerText;
		var value = _Text[code];
		if (value != undefined) {
			var span = document.createElement('span');
			span.innerHTML = value;
			e.outerHTML = span.outerHTML;
		}
	}
}

var cookieNameFilterByStore = 'inv';
function InitFilterByStore() {
	var ctrlFilterByStore = $$('container-open-filter-by-store');
	if (ctrlFilterByStore) {

		$('#cmdStorePreference').click(function () {
			// set cookie
			var storeSelected = $('input[type=radio]:checked', '.modal-body').val();
			setCookie(cookieNameFilterByStore, storeSelected, 1000);
			console.log('Cookie set to : ' + storeSelected);
			location = window.location.href.split('#')[0];
		});

		var idStore = getCookie(cookieNameFilterByStore);

		// create options
		var options = $$('other-stores');
		if (options) {
			for (var property in storesName) {
				if (storesName.hasOwnProperty(property)) {
					// do stuff
					var op = document.createElement('input');
					op.type = 'radio';
					op.value = property;
					op.name = 'stores';
					op.id = 'store-' + property;
					options.appendChild(op);
					var label = document.createElement('label');
					label.htmlFor = op.id;
					label.innerText = options.attributes['data-text'].value + storesName[property];
					options.appendChild(label);
					options.appendChild(document.createElement('br'));
				}
			}

			var filterActive = storesName[idStore];
			var active = false;
			if (idStore === "-1") {
				$$('store-express').checked = true;
				filterActive = 'Express 24H';
				active = true;
			} else {
				if (!filterActive) {
					filterActive = 'Filtre par magasin';
					$$('store-0').checked = true;
				} else {
					$$('store-' + idStore).checked = true;
					active = true;
				}
			}
		}

		
		$$('cmdOpenFilterByStore').innerText = filterActive;
		if (active) {
			ctrlFilterByStore.style.backgroundColor = '#fce4a7';
		} else {
			ctrlFilterByStore.style.backgroundColor = null;
		}

		ctrlFilterByStore.style.display = 'inline-block';
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
function initCartSummary() {
  $(".quantitySummary")
    .focusin(function () { $(this).next().show(); })
	.bind('blur keydown', function (e) {
	if (e.type == 'blur' || e.keyCode == '13') {
		// prevent postback
		e.preventDefault();
		var input = $(this);
		var currentValue = parseInt(input.val());
		var previousValue = parseInt(input.attr("previousValue"));
		if (!isNaN(currentValue) && currentValue != previousValue) {
		 	// submit the form
		 	RequestUpdateLineToServer($(this).attr('tag'), currentValue);
		} else {
		 	if (isNaN(currentValue)) {
		 		// set back the original value
		 		input.val(previousValue);
		 	}
		 	return false;
		}
	}
	return true;
	});
	$(".removeFromCart").click(function () {
		RequestUpdateLineToServer($(this).attr('tag'), 0);
  });
	$("#radSummaryShip").click(function () {
		RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=1');
	});
	$("#radSummaryPickup").click(function () {
		RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=4');
	});
	$("#radSummaryCarrier").click(function() {
	  RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=2');
	  });
	$("#radSummaryLocal").click(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=3');
  	});
  $("#radSummaryDropLocation").click(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=5');
  	});
  $("#lstSummaryShippingStore").change(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shippingStore&value=' +this.value);
  });
  $("#lstSummaryShippingDropLocation").change(function () {
  	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipping&value=5&store=' +this.value);
});
$("#cmdAddPromoCode").click(function() {
  RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=promo&value=' +$$('txtPromoCode').value);
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

  $("#cmdAddPromoCode").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=promo&value=' + $$('txtPromoCode').value);
  });
  $(".PromoCodeDelete").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=promoDelete&value=' + $(this).attr('tag'));
  });
  $("#radShippingAddressDifferent").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipDifferentAddress&value=true');
  });
  $("#radShippingAddressSame").click(function () {
    RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipDifferentAddress&value=false');
  });
  if (typeof (initCartSummaryCustom) == typeof (Function)) {
    initCartSummaryCustom();
  }
}

function RequestUpdateLineToServer(tag, value) {
  RequestUpdateToServer('/Ajax/CartUpdate.ashx?tag=' + tag + '&qty=' + value);
}

function RequestUpdateToServer(urlAjax) {
	$.ajax({
		 	url: urlAjax,
		 	done: function (html) {
		 		$$("cart").innerHTML = html;
		 		initCartSummary(); // rebind the new fields
		 	},
		 	fail: function (jqXhr, textStatus, errorThrown) {
		 		alert('Error: ' + errorThrown);
		 	}
		});
}

var timerAutoHide;
function addToCart(idProduct, ctr, requestConfirmation, notused, wishlistId) {
	if (requestConfirmation) {
		if (typeof g_PreventAddToCartIfOutOfStock !== 'undefined') {
			alert(g_PreventAddToCartIfOutOfStock);
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
			UpdateECommerceFromData(json); // update cart count

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

			var price = parseFloat(json.LastProductAddedPrice.slice(0, -2));
			if (exist('_FacebookPixel')) {
				// get price without the $
				fbq('track', 'AddToCart', { value: price, currency: 'CAD', content_name: json.LastProductAddedTitle });
			}
		},
		fail: function (jqXHR, textStatus, errorThrown) {
			alert('Error: ' + errorThrown);
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

function UnHide(ctr) {
  $(ctr).hide();
  $(ctr).siblings().removeClass('hide');
}

// Navigate to the url specified in the option of the select input
function selectNavigateTo(sel) {
  document.location.href = sel.options[sel.selectedIndex].getAttribute('data-url');
}

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
      alert(data.Error);
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

function UpdateECommerceData() {
	$.ajax('/ajax/loginStatus.axd').done(function (data) {
		if (data.IsLogged) {
			/* le client est connecter */
			$(".customer-name").html(data.Name);
			$(".customer-logged-visible").show();
		} else {
			/* le client n'est pas connecter */
			$(".customer-not-logged-visible").show();
		}
		UpdateECommerceFromData(data);

		if (data.NbWishList == 0 && !exist("displayWishlistCountZero")) {
			data.NbWishList = '';
		}
		$(".wishlist-nb-items").html(data.NbWishList); /* nombre d'article dans la liste cadeau */
	});
}

function UpdateECommerceFromData(data) {
	$(".cart-nb-items").html(data.NbItems); /* nombre d'articles dans le panier */
	if (data.ItemsTotal) {
		$(".cart-items-total").html(data.ItemsTotal.toFixed(2)); /* valeur total des articles dans le panier */
	}
	$('.cart-empty').toggle(data.NbItems === 0);
	$('.cart-not-empty').toggle(data.NbItems !== 0);
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

$('#cmdNewsletter').click(function (event) {
	event.preventDefault();
  // subscribe to newsletter
  var email = $$('txtNewsletter').value;
  if (email) {
    $('.newsletter-result').hide(); // hide previous result
    $.ajax('/api/newsletter?email=' + email).done(function (result) {
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
        sectionToShow ='#newsletter-result-not-added';
      }
      $(sectionToShow).show();
      $('html, body').animate({
        scrollTop: $(sectionToShow).offset().top
      }, 500);
    });
  }
});

function ImagePopupSetup() {
	// image popup http://www.w3schools.com/howto/howto_css_modal_images.asp
	var modal =$$('modalImage');

	// Get the image and insert it inside the modal - use its "alt" text as a caption
	var img = $$('imgPicturePrimary');
	var modalImg =$$("img01");
	var captionText =$$("caption");
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
	//document.body.scrollTop = 0; // For Chrome, Safari and Opera 
	//document.documentElement.scrollTop = 0; // For IE and Firefox
	$('html, body').animate({ scrollTop: 0 }, 'slow');
});

if (window.location.hash.substr(1) == 'tlm') {
	// remove cookie that filter per store
	setCookie(cookieNameFilterByStore, '0', 1000);
}

function setCookie(cname, cvalue, exdays) {
	var d = new Date();
	d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
	var expires = "expires=" + d.toUTCString();
	document.cookie = cname + "=" + cvalue + "; " + expires;
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


$('body').on('click', function (e) {
	$('[data-toggle=popover]').each(function () {
		// hide any open popovers when the anywhere else in the body is clicked
		if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
			$(this).popover('hide');
		}
	});
});



/**
 * http://stackoverflow.com/a/10997390/11236
 */
function updateURLParameter(e, t, n) { var r = ""; var i = e.split("?"); var s = i[0]; var o = i[1]; var u = ""; if (o) { i = o.split("&"); for (var a = 0; a < i.length; a++) { if (i[a].split("=")[0] != t) { r += u + i[a]; u = "&" } } } var f = u + "" + t + "=" + n; return s + "?" + r + f }



// jQuery.query - Query String Modification and Creation for jQuery Written by Blair Mitchelmore (blair DOT mitchelmore AT gmail DOT com) 
// https://github.com/alrusdi/jquery-plugin-query-object
new function(settings){var $separator=settings.separator||'&';var $spaces=settings.spaces===false?false:true;var $suffix=settings.suffix===false?'':'[]';var $prefix=settings.prefix===false?false:true;var $hash=$prefix?settings.hash===true?"#":"?":"";var $numbers=settings.numbers===false?false:true;jQuery.query=new function(){var is=function(o,t){return o!=undefined&&o!==null&&(!!t?o.constructor==t:true);};var parse=function(path){var m,rx=/\[([^[]*)\]/g,match=/^([^[]+)(\[.*\])?$/.exec(path),base=match[1],tokens=[];while(m=rx.exec(match[2]))tokens.push(m[1]);return[base,tokens];};var set=function(target,tokens,value){var o,token=tokens.shift();if(typeof target!='object')target=null;if(token===""){if(!target)target=[];if(is(target,Array)){target.push(tokens.length==0?value:set(null,tokens.slice(0),value));}else if(is(target,Object)){var i=0;while(target[i++]!=null);target[--i]=tokens.length==0?value:set(target[i],tokens.slice(0),value);}else{target=[];target.push(tokens.length==0?value:set(null,tokens.slice(0),value));}}else if(token&&token.match(/^\s*[0-9]+\s*$/)){var index=parseInt(token,10);if(!target)target=[];target[index]=tokens.length==0?value:set(target[index],tokens.slice(0),value);}else if(token){var index=token.replace(/^\s*|\s*$/g,"");if(!target)target={};if(is(target,Array)){var temp={};for(var i=0;i<target.length;++i){temp[i]=target[i];}
target=temp;}
target[index]=tokens.length==0?value:set(target[index],tokens.slice(0),value);}else{return value;}
return target;};var queryObject=function(a){var self=this;self.keys={};if(a.queryObject){jQuery.each(a.get(),function(key,val){self.SET(key,val);});}else{jQuery.each(arguments,function(){var q=""+this;q=q.replace(/^[?#]/,'');q=q.replace(/[;&]$/,'');if($spaces)q=q.replace(/[+]/g,' ');jQuery.each(q.split(/[&;]/),function(){var key=decodeURIComponent(this.split('=')[0]||"");var val=decodeURIComponent(this.split('=')[1]||"");if(!key)return;if($numbers){if(/^[+-]?[0-9]+\.[0-9]*$/.test(val))
val=parseFloat(val);else if(/^[+-]?[0-9]+$/.test(val))
val=parseInt(val,10);}
val=(!val&&val!==0)?true:val;if(val!==false&&val!==true&&typeof val!='number')
val=val;self.SET(key,val);});});}
return self;};queryObject.prototype={queryObject:true,has:function(key,type){var value=this.get(key);return is(value,type);},GET:function(key){if(!is(key))return this.keys;var parsed=parse(key),base=parsed[0],tokens=parsed[1];var target=this.keys[base];while(target!=null&&tokens.length!=0){target=target[tokens.shift()];}
return typeof target=='number'?target:target||"";},get:function(key){var target=this.GET(key);if(is(target,Object))
return jQuery.extend(true,{},target);else if(is(target,Array))
return target.slice(0);return target;},SET:function(key,val){var value=!is(val)?null:val;var parsed=parse(key),base=parsed[0],tokens=parsed[1];var target=this.keys[base];this.keys[base]=set(target,tokens.slice(0),value);return this;},set:function(key,val){return this.copy().SET(key,val);},REMOVE:function(key){return this.SET(key,null).COMPACT();},remove:function(key){return this.copy().REMOVE(key);},EMPTY:function(){var self=this;jQuery.each(self.keys,function(key,value){delete self.keys[key];});return self;},load:function(url){var hash=url.replace(/^.*?[#](.+?)(?:\?.+)?$/,"$1");var search=url.replace(/^.*?[?](.+?)(?:#.+)?$/,"$1");return new queryObject(url.length==search.length?'':search,url.length==hash.length?'':hash);},empty:function(){return this.copy().EMPTY();},copy:function(){return new queryObject(this);},COMPACT:function(){function build(orig){var obj=typeof orig=="object"?is(orig,Array)?[]:{}:orig;if(typeof orig=='object'){function add(o,key,value){if(is(o,Array))
o.push(value);else
o[key]=value;}
jQuery.each(orig,function(key,value){if(!is(value))return true;add(obj,key,build(value));});}
return obj;}
this.keys=build(this.keys);return this;},compact:function(){return this.copy().COMPACT();},toString:function(){var i=0,queryString=[],chunks=[],self=this;var encode=function(str){str=str+"";if($spaces)str=str.replace(/ /g,"+");return encodeURIComponent(str);};var addFields=function(arr,key,value){if(!is(value)||value===false)return;var o=[encode(key)];if(value!==true){o.push("=");o.push(encode(value));}
arr.push(o.join(""));};var build=function(obj,base){var newKey=function(key){return!base||base==""?[key].join(""):[base,"[",key,"]"].join("");};jQuery.each(obj,function(key,value){if(typeof value=='object')
build(value,newKey(key));else
addFields(chunks,newKey(key),value);});};build(this.keys);if(chunks.length>0)queryString.push($hash);queryString.push(chunks.join($separator));return queryString.join("");}};return new queryObject(location.search,location.hash);};}(jQuery.query||{});


/**
 * Javascript-Equal-Height-Responsive-Rows
 * https://github.com/Sam152/Javascript-Equal-Height-Responsive-Rows
 */
(function ($) {
	'use strict'; $.fn.equalHeight = function () {
		var heights = []; $.each(this, function (i, element) {
			var $element = $(element); var elementHeight; var includePadding = ($element.css('box-sizing') === 'border-box') || ($element.css('-moz-box-sizing') === 'border-box'); if (includePadding) { elementHeight = $element.innerHeight(); } else { elementHeight = $element.height(); }
			heights.push(elementHeight);
		}); this.css('height', Math.max.apply(window, heights) + 'px'); return this;
	}; $.fn.equalHeightGrid = function (columns) {
		var $tiles = this.filter(':visible'); $tiles.css('height', 'auto'); for (var i = 0; i < $tiles.length; i++) {
			if (i % columns === 0) {
				var row = $($tiles[i]); for (var n = 1; n < columns; n++) { row = row.add($tiles[i + n]); }
				row.equalHeight();
			}
		}
		return this;
	}; $.fn.detectGridColumns = function () { var offset = 0, cols = 0, $tiles = this.filter(':visible'); $tiles.each(function (i, elem) { var elemOffset = $(elem).offset().top; if (offset === 0 || elemOffset === offset) { cols++; offset = elemOffset; } else { return false; } }); return cols; }; var grids_event_uid = 0; $.fn.responsiveEqualHeightGrid = function () {
		var _this = this; var event_namespace = '.grids_' + grids_event_uid; _this.data('grids-event-namespace', event_namespace); function syncHeights() { var cols = _this.detectGridColumns(); _this.equalHeightGrid(cols); }
		$(window).bind('resize' + event_namespace + ' load' + event_namespace, syncHeights); syncHeights(); grids_event_uid++; return this;
	}; $.fn.responsiveEqualHeightGridDestroy = function () { var _this = this; _this.css('height', 'auto'); $(window).unbind(_this.data('grids-event-namespace')); return this; };
})(window.jQuery);


