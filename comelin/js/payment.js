// Comelin, payment page - 2021 JcMorin

Vue.component('form-line',
    {
        template: `<div class="line row no-gutters" @click=focusInput($event)>
        <label class="col col-sm-4">
        <slot name="label"></slot>
        </label>
        <div class="col col-sm-8">
        <slot name="info"></slot>
        </div>
        </div>`,
        methods: {
            focusInput(e) {
                $(this.$el).find('input').focus();
            }
        }
    });
var appPaymentPage = null;
Vue.component('payment-page',
    {
        data() {
            return {
                view: window._viewPayment,
                giftCardNumberToAdd : null,
                paymentInProgress: false,
                payment : window._payment // the actual payload send to the server
            };
        },
        computed: {
            ccExpirationMonthsOptions() {
                var lst = [];
                lst.push({ Text: "(" + _Text['Month'] + ")" });
                
                for (var i = 0; i < 12; i++) {
                    var date = moment([2000, i, 1]);
                    lst.push({ Text: date.format('MM MMMM'), Value: date.format('MM') });
                }
                return lst;
            },
            ccExpirationYearsOptions() {
                var lst = [];
                lst.push("(" + _Text['Year'] + ")");
                var start = moment().year();
                for (var i = 0; i < 10; i++) {
                    lst.push(start + i);
                }
                return lst;
            },
            paymentInfoSelected() {
                return this.view.PaymentMethods.find(m => m.PaymentMethod === this.payment.PaymentMethod);
            }
        },
        watch: {
            view(newVal) {
                if (this.view.RedirectUrl) {
                    document.location.href = this.view.RedirectUrl;
                }
            },
            'payment.PaymentMethod'(newVal) {
                if (newVal === 'PayPal' && !this.paymentInfoSelected.DisplayCreditCard) {
                    ScriptPayPal();
                }
            }
        },
        created() {
            if (!this.payment) {
                this.payment = {};
            }
            if (!this.payment.Card) {
                this.payment.Card = {};
            }
            if (this.view.PaymentMethods.length === 1) {
                this.payment.PaymentMethod = this.view.PaymentMethods[0].PaymentMethod;
            }
            if (this.view.RecaptchaSiteKey) {
                loadScript("https://www.google.com/recaptcha/api.js?render=" + this.view.RecaptchaSiteKey);
            }
            appPaymentPage = this;
        },
        mounted() {
            if (this.view.IncludeFacebookScript) {
                fbq('track', 'InitiateCheckout', { value: this.view.Order.Total, currency: 'CAD' });
            }
        },
        methods: {
            paymentClick() {
                
                if (!this.paymentInfoSelected) {
                    $('#lstPaiementMode').notify('Choisir un mode de paiement', 'error');
                    return;
                }
                if (this.paymentInfoSelected.DisplayCreditCard) {
                    var card = this.payment.Card;
                    if (!validateCardNumber(card.Number)) {
                        notifyError('CreditCardNumberInvalid', '#txtCreditCardNumber');
                        return;
                    }
                    if (!card.Year) {
                        notifyError('ExpirationDateInvalid', '#lstExpirationYear');
                        return;
                    }
                    if (!card.Month) {
                        notifyError('ExpirationDateInvalid', '#lstExpirationMonth');
                        return;
                    }
                    if (!card.Cvd) {
                        notifyError('', '#txtCvv');
                        return;
                    }
                }
                if (this.view.RecaptchaSiteKey) {
                    grecaptcha.ready(function() {
                        grecaptcha.execute();
                    });
                } else {
                    this.submitCompletePayment();
                }
            },
            submitCompletePayment(token) {
                if (this.paymentInProgress) {
                    return; // already in progress
                }
                this.paymentInProgress = true;
                fetchPost('/api/payment/complete', this.payment, '#cmdPay', (viewReturned) => {
                    this.view = viewReturned;
                }, () => {
                    this.paymentInProgress = false;
                });
            },
            addGiftCard() {
                fetchPost('/api/payment/add-gift-card?number=' + this.giftCardNumberToAdd, null, '#cmdGiftCard', (viewReturned) => {
                    this.view = viewReturned;
                    this.giftCardNumberToAdd = null;
                });
            },
            removeGiftCard(number) {
                fetchPost('/api/payment/remove-gift-card?number=' + number, null, '#cmdGiftCard', (viewReturned) => {
                    this.view = viewReturned;
                });
            }
        }
    });

function recaptchaCallback(token) {
    appPaymentPage.payment.ReCaptchaToken = token;
    appPaymentPage.submitCompletePayment();
}

// http://stackoverflow.com/questions/6176802/how-to-validate-credit-card-number
function validateCardNumber(number) {
    if (!number) {
        return false;
    }
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

function ScriptPayPal() {
    document.body.style.cursor = 'wait';
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
}
