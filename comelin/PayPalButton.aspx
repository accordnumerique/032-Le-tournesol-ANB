<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PayPalButton.aspx.cs" Inherits="WebSite.PayPalButton" %>
 <div id="paypal-button" class="paypal"></div>

<script>
	braintree.client.create({
		authorization: '<%= ClientToken  %>'
	}, function (clientErr, clientInstance) {
		if (clientErr) {
			console.error('Error creating client:', clientErr);
			return;
		}
		<% if(IsSandBox) { %>	
		$.notify('Environment Test', 'info');
		<% } %>	
		// Create a PayPal Checkout component.
		braintree.paypalCheckout.create({
			client: clientInstance
		}, function (paypalCheckoutErr, paypalCheckoutInstance) {
			if (paypalCheckoutErr) {
				console.error('Error creating PayPal Checkout:', paypalCheckoutErr);
				return;
			}
			// Set up PayPal with the checkout.js library
			paypal.Button.render({
				env: '<%= Env %>', // or 'sandbox' or 'production'

				payment: function () {
					return paypalCheckoutInstance.createPayment({
						flow: 'checkout', // Required
						amount: <%= Amount %>, // Required
						currency: 'CAD', // Required
						locale: 'fr_CA',
						enableShippingAddress: true,
						shippingAddressEditable: false,
						shippingAddressOverride: <%= CustomerAddressComplete  %>
					});
				},
				onAuthorize: function (data, actions) {
					return paypalCheckoutInstance.tokenizePayment(data)
						.then(function (payload) {
							$('#paypal-button').html('confirmation...');
		
							$.ajax('/<%=BrainTreeCallback.Url %>?clienttoken=' + payload.nonce)
								.done(function (result) {
									if (result.Error) {
										$.notify(result.Error, 'error');
									} else if (result.UrlRedirect) {
										// completed!
										document.location = result.UrlRedirect;
									}
								});
						}).catch(function (a) {
							$.notify(a, 'error');
						});
				},

				onCancel: function (data) {
					console.log('checkout.js payment cancelled', JSON.stringify(data, 0, 2));
				},

				onError: function (err) {
					$.notify(err.code, 'error');
					console.error('checkout.js error', err);
				}
			}, '#paypal-button').then(function () {
				// The PayPal button will be rendered in an html element with the id
				// `paypal-button`. This function will be called when the PayPal button
				// is set up and ready to be used.
			});

		});
	});
</script>
