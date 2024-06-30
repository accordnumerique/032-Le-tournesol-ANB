// paiement page
// created by Comelin.com 2017-5-8
// Jean-Claude Morin
var _paypalInit = false;


function ShowPayPal() {
	if (_paypalInit) {
		return;
	}
	document.body.style.cursor = 'wait';
	var ctrl = this;
	$(ctrl).hide(); // hide the pay button
	$('#payPalButtonPlaceHolder').html('Un instant svp...');

	// load PayPal script
	$.when(
		$.getScript("https://js.braintreegateway.com/web/3.14.0/js/client.min.js"),
		$.getScript("https://js.braintreegateway.com/web/3.14.0/js/paypal-checkout.min.js"),
		$.getScript("https://www.paypalobjects.com/api/checkout.min.js"),
		$.Deferred(function (deferred) {
			$(deferred.resolve);
		})
	).done(function () {

		// call server to get PayPal request and script
		$.ajax('/PayPalButton.aspx').done(function (data) {
			document.body.style.cursor = null; // clear wait cursor
			$('#payPalButtonPlaceHolder').html(data);
		});
	});
	_paypalInit = true;
}

$(function () {
	$('#lstPaiementMode').change(function () {
		DisplaySelectedPaymentSection(true);
	});
	$('#imgCVV').click(function () {
		$('#divCVVHelp').toggle();
	});

	$('.line').click(function() {
		$('.line').removeClass('active');
		this.classList.add('active');
		$(this).find('input[type=text]').focus();
	});

	DisplaySelectedPaymentSection(false);

	$('#cmdPay').click(function (e) {
		if (window.getComputedStyle($$('divCreditCard')).display !== 'none') {
			// credit card
			if (!$$('txtCreditCardNameHolder').value) {
				$('#txtCreditCardNameHolder').popover('show');
				return false;
			}
			var isCreditCardValid = validateCardNumber($$('txtCreditCardNumber').value);
			if (!isCreditCardValid) {
				$('#txtCreditCardNumber').popover('show');
				e.preventDefault();
				return false;
			}
			var cvv = $$('txtCvv');
			if (cvv && cvv.value.length < 3) {
				$(cvv).popover('show');
				e.preventDefault();
				return false;
			}
			if ($$('lstExpirationMonth').selectedIndex === 0 || $$('lstExpirationYear').selectedIndex === 0) {
				$('#lbl-cc-expiration').popover('show');
				return false;
			}
		}
		return true;
	});

});


var _paymentSectionOpen = '';

function DisplaySelectedPaymentSection() {
	var selectedPaymentMode = $$('lstPaiementMode').value;

	var sectionToOpen;
	switch (selectedPaymentMode) {
		case 'Visa':
		case 'MasterCard':
		case 'Amex':
			sectionToOpen = 'divCreditCard';
			break;
		default:
			sectionToOpen = 'div' + selectedPaymentMode;
			break;
	}
	if (_paymentSectionOpen !== sectionToOpen) {
		if (_paymentSectionOpen && _paymentSectionOpen !== '') {
			$('#' + _paymentSectionOpen).hide();
		}
		$('#' + sectionToOpen).show();
		_paymentSectionOpen = sectionToOpen;

		if (window._enablePayPal) {
			if (sectionToOpen === 'divPayPal') {
				$('#cmdPay').hide();
				$('.paypal').show();
				ShowPayPal();
			} else {
				$('#cmdPay').show();
				$('.paypal').hide();
			}
		}
	}
}

// http://stackoverflow.com/questions/6176802/how-to-validate-credit-card-number
function validateCardNumber(number) {
	var no = number.replace(/\s+/g, '');  // strip spaces
	return (no && luhnCheck(no) &&
		no.length === 16 && (no[0] == 4 || no[0] == 5 && no[1] >= 1 && no[1] <= 5) ||
		no.length === 15 && (no.indexOf("34") === 0 || no.indexOf("37") === 0));
}

function luhnCheck(val) {
	var sum = 0;
	for (var i = 0; i < val.length; i++) {
		var intVal = parseInt(val.substr(i, 1));
		if (i % 2 == 0) {
			intVal *= 2;
			if (intVal > 9) {
				intVal = 1 + (intVal % 10);
			}
		}
		sum += intVal;
	}
	return (sum % 10) == 0;
}