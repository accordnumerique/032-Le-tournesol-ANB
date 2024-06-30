// Comelin.com
$(function () {
	$('#radShippingAddressDifferent').click(function () {
		RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipDifferentAddress&value=true');
		$('#divShippingAddress').show('slow');
	});
	$('#radShippingAddressSame').click(function () {
		RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=shipDifferentAddress&value=false');
		$('#divShippingAddress').hide('slow');
	});

	// update the cart (shipping price or tax may be affected)
	$('#lstCountry').change(function () {
		UpdateCountryOrProvince("country", this.selectedOptions[0]);
	});
	$('#lstProvince').change(function () {
		UpdateCountryOrProvince("province", this.selectedOptions[0]);
	});
	$('#lstShipCountry').change(function () {
		UpdateCountryOrProvince("shipCountry", this.selectedOptions[0]);
	});
	$('#lstShipProvince').change(function () {
		UpdateCountryOrProvince("shipProvince", this.selectedOptions[0]);
	});

	$('#chkCreateAccount').click(function () {
		$('#divCreateAccountInner').toggle('slow');
	});

	$('.line').click(function () {
		$('.line').removeClass('active');
		this.classList.add('active');
		$(this).find('input').focus();
	});

	$('#txtComment').change(function () {
		UpdateCountryOrProvince("note", this);
	});

	$('#email').change(function () {
		if (!_session.CanDisplayPersonalInfo) {
			// check with server if the email already have an account
			$.ajax('/api/EmailInUse?email=' + document.getElementById('email').value).done(function (response) {
				console.log(response);
				if (response.IsInUse) {
					ShowLoginSection();
					$('#divCreateAccount').hide();
				} else {
					$('#email-in-use').hide();
					$('#divCreateAccount').show();
				}
			});
		}
	});

	if (!_session.CanDisplayPersonalInfo && _session.IsLogged) {
		ShowLoginSection();
	}
	if (_session.IsLogged) {
		document.getElementById('email').value = _session.Email;
		$('#divCreateAccount').hide();
	}

	$('#btn-connect-already-account').click(function () {
		var email = document.getElementById('email').value;
        var ctrlPassword = document.getElementById('password-already-account');
		var password = ctrlPassword.value;
		fetchPost('/api/login', {Email: email, Password: password}, ctrlPassword, (response) => {
            location.reload();
		});
		return false; // prevent post-back
	});
	
	if (exist('_Text')) {
		var section = $$('divInteracTransfer');
		if (section) {
			section.innerHTML = _Text.PaymentInteracTransferMsg_2;
		}
	}

	if ($$('lstProvince').value == '') {
		// auto detect country
		fetch('https://admin.comelin.com/api/geo')
		.then(response => response.json())
		.then(data => {
                    try {
                        $('#lstCountry, #lstShipCountry').val(data.countryCode).trigger('change'); // change will trigger the province dropdown to update
                        $('#lstProvince').val(data.region);
                        $('#lstShipProvince').val(data.region);
                        // remove data not needed (cause issue with url encoding)
                        delete data.isp;
                        delete data.timezone;
                        delete data.org;
                        delete data.as;
                        delete data.city;
                        RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=setAddress&value=' + JSON.stringify(data));
                    } catch (e) {
                        alert(_Text['CountryNotDeserved'] + ': ' + data.country);
                    } 
					
				}
		);

	}
    document.getElementById('cmdComplete').value = _Text.Payment;

	if (exist('_DisableSelfRegister')) {
		hide('.section-identification, .shipping, .section-billing-address');
	}
});

function LostPassword(ctrl) {
	$.ajax('/api/LostPassword?email=' +$$('email').value).done(function (response) {
		console.log(response);
		if (response.EmailSent) {
			$(ctrl).popover('show');
		} else {
			$(ctrl).popover({ content: response.Error, trigger: 'focus' });
			$(ctrl).popover('show');
		}
	});
}

function ShowLoginSection() {
	$('#email-in-use').show();
	$('#password-already-account').focus();
}

function UpdateCountryOrProvince(property, optionSelected) {
	RequestUpdateToServer('/Ajax/CartUpdate.ashx?action=' + property + '&value=' + optionSelected.text + '&code=' + optionSelected.value);
}

function UpdateShippingSection() {
	var ctrl = document.getElementById('radSummaryShip');
	if (ctrl) {
		var haveShipping = document.getElementById('radSummaryShip').checked;
		if (!haveShipping) {
			var radSummaryShippingOption = document.getElementById('radSummaryCarrier');
			if (radSummaryShippingOption) {
				haveShipping = radSummaryShippingOption.checked;
			}
		}
		if (!haveShipping) {
			var radSummaryLocal = document.getElementById('radSummaryLocal');
			if (radSummaryLocal) {
				haveShipping = radSummaryLocal.checked;
			}
		}
		$('.shipping').toggle(haveShipping);
	}
}

UpdateShippingSection();

$(document).on('change', '#radSummaryPickup,#radSummaryShip,#radSummaryCarrier,#radSummaryLocal', UpdateShippingSection);

function validateProvince(source, arguments) {
   arguments.IsValid = $$('lstProvince').selectedIndex != 0;
}
function validateProvinceShipping(source, arguments) {
   arguments.IsValid = $$('radShippingAddressSame').checked ||  $$('lstShipProvince').selectedIndex != 0;
}



$('.bfh-countries').attr('data-countryList', window.shippingCountries);

// https://github.com/vlamanna/BootstrapFormHelpers
// http://js.nicdn.de/bootstrap/formhelpers/docs/assets/js/bootstrap-formhelpers-countries.js
!function(a){"use strict";var b=function(b,c){if(this.options=a.extend({},a.fn.bfhcountries.defaults,c),this.$element=a(b),this.options.countrylist){this.countryList=[],this.options.countrylist=this.options.countrylist.split(",");for(var d in BFHCountriesList)a.inArray(d,this.options.countrylist)>=0&&(this.countryList[d]=BFHCountriesList[d])}else this.countryList=BFHCountriesList;this.$element.is("select")&&this.addCountries(),this.$element.is("span")&&this.displayCountry(),this.$element.hasClass("bfh-selectbox")&&this.addBootstrapCountries()};b.prototype={constructor:b,addCountries:function(){var a=this.options.country;this.$element.html(""),this.$element.append('<option value=""></option>');for(var b in this.countryList)this.$element.append('<option value="'+b+'">'+this.countryList[b]+"</option>");this.$element.val(a)},addBootstrapCountries:function(){var a,b,c,d=this.options.country;a=this.$element.find('input[type="hidden"]'),b=this.$element.find(".bfh-selectbox-option"),c=this.$element.find("[role=option]"),c.html(""),c.append('<li><a tabindex="-1" href="#" data-option=""></a></li>');for(var e in this.countryList)1==this.options.flags?c.append('<li><a tabindex="-1" href="#" data-option="'+e+'"><i class="icon-flag-'+e+'"></i>'+this.countryList[e]+"</a></li>"):c.append('<li><a tabindex="-1" href="#" data-option="'+e+'">'+this.countryList[e]+"</a></li>");b.data("option",d),d&&(1==this.options.flags?b.html('<i class="icon-flag-'+d+'"></i> '+this.countryList[d]):b.html(this.countryList[d])),a.val(d)},displayCountry:function(){var a=this.options.country;1==this.options.flags?this.$element.html('<i class="icon-flag-'+a+'"></i> '+this.countryList[a]):this.$element.html(this.countryList[a])}},a.fn.bfhcountries=function(c){return this.each(function(){var d=a(this),e=d.data("bfhcountries"),f="object"==typeof c&&c;e||d.data("bfhcountries",e=new b(this,f)),"string"==typeof c&&e[c]()})},a.fn.bfhcountries.Constructor=b,a.fn.bfhcountries.defaults={country:"",countryList:"",flags:!1},a(window).on("load",function(){a("form select.bfh-countries, span.bfh-countries, div.bfh-countries").each(function(){var b=a(this);b.bfhcountries(b.data())})})}(window.jQuery);