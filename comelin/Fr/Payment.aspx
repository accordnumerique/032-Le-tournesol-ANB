<%@ Page Language="C#" EnableViewState="false" MasterPageFile="MP.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="WebSite.Fr.PaymentPage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <payment-page inline-template id="appPaymentPage">
        <div>
            <h1><t>CheckoutPayment</t></h1>
            <div class="lines">
                <div class="line row no-gutters" id="rowTotal">
                    <label class="col col-sm-4">Total</label>
                    <div  class="col col-sm-8">
                        {{NumberToAmount(view.TotalToPaid)}}
                    </div>
                </div>
			    <div class="line row no-gutters">
				    <label class="col col-sm-4" for="lstPaiementMode"><t>PaymentMode</t>:</label>
				    <div  class="col col-sm-8">
				        <select id="lstPaiementMode" v-model="payment.PaymentMethod">
					        <option v-for="mode in view.PaymentMethods" :value="mode.PaymentMethod">{{mode.Label}}</option>
                        </select>
				        <div v-if="paymentInfoSelected" v-html="paymentInfoSelected.MoreInformation" :class="payment.PaymentMethod"></div>
                    </div>
			    </div>
			    <div id="divCreditCard" v-if="paymentInfoSelected && paymentInfoSelected.DisplayCreditCard">
                    <form-line>
                        <template v-slot:label><t>CreditCardName</t>:</template>
                        <template v-slot:info><input ID="txtCreditCardNameHolder" maxlength="41" autocomplete="cc-name" v-model="payment.Card.Name"/></template>
                    </form-line>
                    <form-line>
                        <template v-slot:label><t>CreditCardNumber</t>:</template>
                        <template v-slot:info><input ID="txtCreditCardNumber" maxlength="19" autocomplete="cc-number"  v-model="payment.Card.Number"/></template>
                    </form-line>
				    <form-line>
					    <template v-slot:label><t>CVV</t>:</template>
                        <template v-slot:info><input ID="txtCvv" maxlength="4" style="width: 75px" autocomplete="cc-csc" v-model="payment.Card.Cvd" /></template>
                    </form-line>
				    
                    <form-line>
                        <template v-slot:label><t>ExpirationDate</t>:</template>
                        <template v-slot:info>
                             <select ID="lstExpirationMonth" autocomplete="cc-exp-month" v-model="payment.Card.Month">
                                 <option v-for="m in ccExpirationMonthsOptions" :value="m.Value">{{m.Text}}</option>
                             </select>
                            <select id="lstExpirationYear" autocomplete="cc-exp-year" v-model="payment.Card.Year">
                                <option v-for="y in ccExpirationYearsOptions" :value="y">{{y}}</option>
                            </select>
                        </template>
                    </form-line>
			    </div>
                <form-line v-if="view.DisplayGiftCard" id="divGiftCard">
                    <template v-slot:label><t>GiftCard</t>:</template>
                    <template v-slot:info>
                        <div v-if="view.GiftCards" v-for="g in view.GiftCards" class="gift-card">
                            <code class="number">#{{g.Number}}</code> <span class="amount">{{NumberToAmount(g.Amount)}}</span> <i class="fa fa-times" @click="removeGiftCard(g.Number)"></i>
                        </div>
                        <input id="txtGiftCard" autocomplete="off" placeholder="numéro" v-model="giftCardNumberToAdd"  />
                        &nbsp; <div v-if="giftCardNumberToAdd" id="cmdGiftCard" class="btn btn-secondary" @click="addGiftCard"><t>Apply</t></div>

                    </template>
                </form-line>
                <form-line v-if="view.RecaptchaSiteKey">
                    <template v-slot:info>
                        <div class="g-recaptcha" :data-sitekey="view.RecaptchaSiteKey" data-callback="recaptchaCallback" data-size="invisible"></div>
                    </template>
                </form-line>
            </div>
		<div class="row">
			<div class="col col-12  text-right">
				<div v-if="payment && payment.PaymentMethod === 'PayPal'" >
					<div id="payPalButtonPlaceHolder" class="paypal"></div>
                </div>
                <div v-else id="cmdPay" class="btn btn-primary btn-lg" @click="paymentClick"><t>Payment</t></div>		
			</div>
		</div>	
        </div>
    </payment-page>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<%= Page.JsInclude("/js/payment.js") %>
    
</asp:Content>
