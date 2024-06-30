<%@ page title="Intégration avec logiciel de comptabilité" language="C#" masterpagefile="~/Admin/AdminMP.Master" autoeventwireup="true" codebehind="AccountingIntegration.aspx.cs" inherits="WebSite.Admin.AccountingIntegrationPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#app > .row .row label {margin-bottom: 15px}
		.cent {width: 120px}
		.config {margin-bottom: 20px}
		.fa-object-group {margin-left: 10px}
		.fa-sitemap {margin-left: 5px}
		.group {width: 45px; margin-right: 15px; margin-left: 5px}
		.headert {margin-top: 10px; margin-bottom: 10px}
		.headert span {display: inline-block}
		.fa-info-circle{cursor: pointer}
		.fa-info-circle:hover {color:blue}
		.ttd{display: none}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="app">
			<h1>Intégration avec logiciel de compatibilité 
		<select v-model="settings.Platform">
			<option value="0">Aucun</option>
			<option value="1">QuickBooks Online</option>
			<option value="2">Acomba</option>
			<option value="3">Sage</option>
            <option value="4">Avantage</option>
		</select>
                <help url="articles/integration-avec-les-logiciels-comptables-quickbook-en-ligne-sage50-acomba"></help>
			</h1>
		<div class="row" v-if="settings.Platform > 0">
			<div class="col-xs-12 col-sm-6">
				<h2>Crédit</h2>
				<div v-if="!settings.SalesByDepartement">
					<h5>Ventes regroupées <div class="btn btn-default btn-SalesByDepartement" @click="settings.SalesByDepartement = true">séparer les ventes par catégories/départements</div></h5>
					<div class="row">
						<div class="col-sm-3">Comelin</div>
						<div class="col-sm-9">Compte logiciel comptable</div> 
					</div>
					<div class="row">
						<label class="col-sm-3">Vente</label>
						<div class="col-sm-9">
							<input v-model="settings.AccountSales" /></div> 
					</div>
					<div class="row">
						<label class="col-sm-3">Vente en ligne</label>
						<div class="col-sm-9">
							<input v-model="settings.AccountSalesOnline" /></div>
					</div>
				</div>
				<div v-if="settings.SalesByDepartement">
					<h5>Ventes par départements <div class="btn btn-default btn-SalesByDepartement" @click="settings.SalesByDepartement = false">regrouper les ventes en une seule entrée</div></h5>
					<div class="row headert">
						<div class="col-sm-3">Catégorie</div>
						<div class="col-sm-9">Compte logiciel comptable</div> 
					</div>
					<div class="row" v-for="cat in settings.AccountByCategories">
						<label class="col-sm-3">{{cat.Title}}</label>
						<div class="col-sm-9">
							<input v-model="cat.Account" />
						</div>
					</div>
					<hr />
				</div>
				<div class="row">
					<label class="col-sm-3">Frais de préparation</label>
					<div class="col-sm-9">
						<input v-model="settings.AccountPreparationFee" /></div>
				</div>
				<div class="row">
					<label class="col-sm-3">Transport</label>
					<div class="col-sm-9">
						<input v-model="settings.AccountShipping" /></div>
				</div>
				<div v-if="settings.TaxesByProvinces">
					<h5>Taxes par province <div class="btn btn-default btn-TaxesByProvinces" @click="settings.TaxesByProvinces = false">Taxes regroupés</div></h5>
					<div class="row" v-for="cat in settings.AccountByTaxCode">
						<label class="col-sm-3">{{cat.Title}}</label>
						<div class="col-sm-9">
							<input v-model="cat.Account" />
						</div>
					</div>
					<hr />
				</div>
				<div v-else>
					<h5>Taxes regroupées <div class="btn btn-default btn-TaxesByProvinces" @click="settings.TaxesByProvinces = true">Entrées séparées par code de taxes</div></h5>
					<div class="row">
						<label class="col-sm-3">TPS</label>
						<div class="col-sm-9">
							<input v-model="settings.AccountTPS" /></div>
					</div>
					<div class="row">
						<label class="col-sm-3">TVQ</label>
						<div class="col-sm-9">
							<input v-model="settings.AccountTVQ" /></div>
					</div>
				</div>
				
				<div class="row">
					<label class="col-sm-3">Dépôt de sécurité</label>
					<div class="col-sm-9">
						<input v-model="settings.AccountSecurityDeposit" /></div>
				</div>
				<div class="row">
					<label class="col-sm-3">Cartes cadeaux (ajustement) 
						<i class="fa fa-info-circle" @click="ToggleTip($event)"></i><span class="ttd">Cartes cadeaux données, payées partiellement ou expirées.</span></label>
					<div class="col-sm-9">
						<input v-model="settings.AccountGiftCardAjustement" /></div>
				</div>
			</div>
			<div class="col-xs-12 col-sm-6">
				<h2>Débit (mode de paiement)</h2>
				<a class="config" href="/Admin/Settings.aspx#sectionPayments">configurer les modes de paiement</a>
				<div class="row headert">
						<div class="col-sm-3">Comelin</div>
						<div class="col-sm-9"><span class="cent">Compte logiciel comptable</span><span style="margin-left: 15px">Grouper / Séparer</span></div> 
					</div>
				<div class="row" v-for="(p, pId) in settings.Paiements" v-if="p.Name">
					<label class="col-sm-3">{{p.Name}}</label>
					<div class="col-sm-9">
						<input class="cent"  v-model="p.Account" /> 
						<span title="Regrouper les modes de paiement dans une seul entrée de journal">
<i class="fa fa-object-group" aria-hidden="true"></i><input class="group" type="number" :value="p.Group" @input="p.Group = safeParseInt($event.target.value)" /> 
</span>
						<span title="Créer une entrée de journal pour chaque transaction">  <input type="checkbox" v-model="p.SeparateEntry" /><i class="fa fa-sitemap" aria-hidden="true"></i> </span>
					</div>
				</div>
			</div>
			<div class="col-xs-12">
				<div v-on:click="save" class="btn btn-success">Sauvegarder</div>	
				<a v-if="settings.Platform == 1" href="QB.aspx">intégration QuickBooks</a>
				<a v-if="settings.Platform == 2" href="Acomba.aspx">intégration Acomba</a>
			</div>
			
		</div>
		
	</div>
	<script>
		// update object with payment method name
		if (!_accountingSettings) {
			_accountingSettings = {};
		}
		if (!_accountingSettings.Paiements) {
			_accountingSettings.Paiements = [];
		}

		if (!_accountingSettings.SalesByDepartement) {
			_accountingSettings.SalesByDepartement = false;
		}

		// make sure all payments method are present in the settings
		for (var i = 0; i < _paymentMethodNames.length; i++) {
			var kv = _paymentMethodNames[i];
			var method = _accountingSettings.Paiements.find(function(e) {
				return e.Method == kv.Id;
			});
			if (!method) {
				// not found, add it
				method = {Method : kv.Id};
				_accountingSettings.Paiements.push(method);
			}
			method.Name = kv.Name;
		}

		// make sure all department are present.
		if (!_accountingSettings.AccountByCategories) {
			_accountingSettings.AccountByCategories = [];
		}
		for (var i in _categoriesName) {
			var kv = _categoriesName[i];
			var cat = _accountingSettings.AccountByCategories.find(function(e) { return e.IdCategory == kv.Id; });
			if (!cat) {
				// not found, add it
				cat = {IdCategory : kv.Id};
				_accountingSettings.AccountByCategories.push(cat);
			}
			cat.Title = kv.Title;
		}
		// remove category that no longer exist
		_accountingSettings.AccountByCategories = _accountingSettings.AccountByCategories.filter(function (cat) { return !cat.IdCategory || _categoriesName.find(function(e) { return e.Id == cat.IdCategory; }); });
		var catOther = _accountingSettings.AccountByCategories.find(function(e) { return e.IdCategory === 0 || !e.IdCategory; });
		if (!catOther) {
			// not found, add it
			catOther = {IdCategory : 0, Title : 'Non catégorisé'};
			_accountingSettings.AccountByCategories.push(catOther);
		}

		var vue = new Vue({
			el: '#app',
			data: {
				settings: _accountingSettings
			},
			methods: {
				save: function(e) {
					var dataToPost = {};
					dataToPost._AccountingSetting = JSON.stringify(this.settings);
					var btn = e.currentTarget;
					$.post("/<%=WebSite.Admin.Api.ApiSettings.Url %>", dataToPost).fail(function(data) {
						if (data.Error) {
							alert(data.Error);
						}
					}).done(function() {
						$(btn).notify('Sauvegardé!', "success");
					});

				},
				safeParseInt: function(input) {
					if (!input || !parseInt(input)) {
						return 0;
					}
					return parseInt(input);
				},
				ToggleTip: function(event) {
					$(event.target).notify(event.target.nextElementSibling.innerText);
				}
			}
			
		});

		$.notify.defaults({ className: "info" });
	</script>
</asp:Content>
