<%@ Page Title="Configuration d'un magasin" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Magasin.aspx.cs" Inherits="WebSite.Admin.config.Magasin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="appStore">
		
        
		<div id="index" v-if="stores">

			<h1>Magasins</h1>
			<a v-for="s in stores" :href="'Magasin.aspx?id=' + s.Id" :class="{actif:s.Enable}">{{s.Name}}</a>
			
			<div class="internal btn btn-primary" @click="addStore($event)">Ajouter un magasin</div>
		</div>
		<div class="container">
            <h1><help style="float:right" number="2061"></help></h1>
			<div class="row" v-if="multistore">
				<div>Nom du magasin</div>
				<input v-model="store.Name" id="store-name"/>		
			</div>
			<div class="row internal">
				<label>Actif</label>
				<label class="switch"><input type="checkbox" v-model="store.Enable"> <span class="slider round"></span></label>		
			</div>
			<div class="row" v-if="multistore">
				<label>Magasin par default</label>
				<label class="switch"><input type="checkbox" v-model="store.IsDefault" :disabled="store.IsDefault"> <span class="slider round"></span></label>		
			</div>
			<div class="row">
				<label>Visible en ligne
				</label>
				<label class="switch"><input type="checkbox" v-model="store.VisibleOnline"> <span class="slider round"></span></label>		
			</div>
			<div class="row" v-if="!store.VisibleOnline">
				<label>Inventaire inclus dans les quantités disponibles en ligne.
				</label>
				<label class="switch"><input type="checkbox" v-model="store.InventoryForShipping"> <span class="slider round"></span></label>		
			</div>
			<div class="row">
				<label>Livraison par la poste.
				</label>
				<label class="switch"><input type="checkbox" v-model="store.ShipByMail"> <span class="slider round"></span></label>		
			</div>
			<div class="row">
				<label>Livraison locale
				</label>
				<label class="switch"><input type="checkbox" v-model="store.ShipLocal"> <span class="slider round"></span></label>		
			</div>
			<div class="row">
				<label>Le client peut collecter en magasin
				</label>
				<label class="switch"><input type="checkbox" v-model="store.InventoryForPickup"> <span class="slider round"></span></label>		
			</div>
			<div class="row" v-if="multistore">
				<label>Couleur de l'inventaire affiché dans Comelin
				</label>
				<input v-model="store.Color" type="color"/>
			</div>
            <div class="row" v-if="multistore">
                <label>Courriel de l'administrateur du magasin
                </label>
                <input v-model="store.EmailAdmin" type="email" :placeholder="emailAdmin" />
            </div>
            <div class="row">
                <label>Notification par courriel si la caisse ne balance pas.
                </label>
                <label class="switch"> <input v-model="store.DisableEmailNotificationCashierUnbalance" type="checkbox" :true-value="false" :false-value="true"  /> <span class="slider round"></span></label>
            </div>
            <div class="row" v-if="multistore">
                <label>Courriel vente (factures et réservations)
                </label>
                <input v-model="store.EmailCustomers" type="email" :placeholder="emailCustomers" />
            </div>
            <div class="row" v-if="multistore">
                <label>Courriel commande fournisseur du magasin
                </label>
                <input v-model="store.EmailSupplierOrder" type="email" :placeholder="emailSupplierOrder" />
            </div>
			<h2>Facture</h2>
			<div class="row" id="entete">
				<div>Logo / entête de facture<br/>
					<input type="file" accept="image/*"/><div class="btn btn-secondary" @click="uploadImage">Téléversement</div>
				</div>
				<img v-if="store.UrlLogo" id="imgLogo" :src="store.UrlLogo"/>
				
			</div>
			<div class="row">
                <label>Largeur imprimé sur facture </label><div><div class="input-group"><input class="form-control" v-model="store.LogoWidth" placeholder="100" style="width:70px" /><div class="input-group-append"><span class="input-group-text">%</span></div></div></div>
            </div>
			<div class="row" v-if="multistore">
				<label>Copier le logo pour tous les magasins
				</label>
				<label class="switch"><input type="checkbox" v-model="store.CopyAllStoreLogo"> <span class="slider round"></span></label>		
			</div>
			<div class="row">
				<div>Entête de facture
				</div>
				<textarea v-model="store.PrintTop" id="txtPrintTop"></textarea>
			</div>
			<bilingual-text :text="store.PrintBottomInStore" placeholder="Message de bas de facture en magasin" multiline="true" class="narrow"></bilingual-text>				
			<bilingual-text :text="store.PrintBottomOnline" placeholder="Message de bas de facture en ligne" multiline="true" class="narrow"></bilingual-text>
			
			<h4>Afficher un code QR dans le bas de vos facture</h4>
            <bilingual-text :text="store.QRCodeUrl" placeholder="url de code QR" class="narrow"></bilingual-text>		
            <bilingual-text :text="store.QRCodeMsg" placeholder="message affiché sous le code QR" class="narrow"></bilingual-text>		

            <div class="row" v-if="multistore">
				<label>Copier le bas de facture pour tous les magasins
				</label>
				<label class="switch"><input type="checkbox" v-model="store.CopyAllStoreFooter"> <span class="slider round"></span></label>		
			</div>
			<h2>Réservations</h2>
            <bilingual-text :text="store.PrintReservationBottom" placeholder="Message de bas des réservations" multiline="true" class="narrow"></bilingual-text>

			<h2 id="heures">Heures d'ouverture</h2>
			<div v-for="dayOfWeek in daysOfWeek" class="row">
				<div>{{dayOfWeek.Name}}</div>
				<div>
					<span v-if="store.OpeningHours.Normal[dayOfWeek.id].IsOpen">de <input required type="time" class="from" v-model="store.OpeningHours.Normal[dayOfWeek.id].From"/> à <input required type="time" class="to" v-model="store.OpeningHours.Normal[dayOfWeek.id].To"/></span> 
					<span v-else class="open-hours-close">fermé</span>
					<label class="switch"><input type="checkbox" v-model="store.OpeningHours.Normal[dayOfWeek.id].IsOpen"> <span class="slider round"></span></label>
				</div>
			</div>
			<div class="indent">
			<h3>Jours d'exception à l'horaire régulier</h3>
			Entrez ici les heures d'ouverture pour certaines dates spécifiques. Par exemple, vous pouvez inscrire que votre magasin est fermé certains jours fériés. Ces exceptions seront affichées sur votre site 30 jours au préalable et seront automatiquement retirés au-delà de la date en question.
			<div class="indent" v-for="openHours in store.OpeningHours.Exceptions">
				<div class="row">
					<div>{{formatDate(openHours.Date)}} <span v-if="isExpired(openHours.Date)" @click="AddYear(openHours)" class="badge badge-info" style="cursor: pointer">Ajouter une année</span></div>
					<div>
						<span v-if="openHours.IsOpen">de <input required type="time" class="from" v-model="openHours.From"/> à <input required type="time" class="to" v-model="openHours.To"/></span> 
						<span v-else class="open-hours-close">fermé</span>
						<label class="switch"><input type="checkbox" v-model="openHours.IsOpen"> <span class="slider round"></span></label>
						<i class="fa fa-times" @click="removeException(openHours)"></i>
					</div>
				</div>
			</div>
				
			<div><input type="date" v-model="openHourDate"/> <div class="btn btn-secondary" @click="addOpenHoursException">Ajouter exception</div></div>
			</div>
			<br/>
			<h2 id="tax">Taxes</h2>
			<div class="row ">
				<label>Numéro de taxe TPS</label>
				<input v-model="store.Tax1" />		
			</div>
			<div class="row">
				<div>Numéro de taxe TVQ</div>
				<input v-model="store.Tax2"/>		
			</div>
			<div class="row" v-if="multistore">
				<label>Copier les numéros de taxes pour tous les magasins				</label>
				<label class="switch"><input type="checkbox" v-model="store.CopyAllStoreTaxes"> <span class="slider round"></span></label>		
			</div>
			<div class="row">
				<div>Code de taxes par défaut (laisser vide pour le Québec)</div>
				<input v-model="store.TaxCode" style="width: 50px" />		
			</div>
			<div class="row">
				<div>Code de Province par défaut (pour les nouveaux clients)</div>
				<input v-model="store.Province" style="width: 50px" />		
			</div>
			<div class="multi-store">
			<h2 id="distribution">Commande au fournisseur</h2>
			<div class="row">
				<div class="col">Distribution de l'inventaire entre les magasins. Ratio:</div>
				<input v-model="store.DistributionWeight" style="width: 50px" />		
			</div>
                <div class="row">
                    <div class="col">Pourcentage conservé dans le magasin courant avant de calculer les ratios de distribution: (pour minimiser les transfers)</div>
					<div>
					<span class="input-group">
                        <input v-model="store.DistributionPercentageKeep" class="form-control" style="width: 50px" />		
                        <span  class="input-group-text">%</span>		
                    </span>
                    </div>
                </div>
			</div>
			
			<h2>Tiroirs caisses</h2>
			<div v-if="viewCashiers">
				<div v-for="cashier in store.CashierNames">
				<span class="cashier-name">{{cashier}}</span> <i class="fa fa-times cashier-delete" @click="cashierRemove(cashier)"></i>
				</div>
				<input v-model="cashierName" placeholder="nom du tiroir caisse" /> <div class="btn btn-secondary" @click="addCashier">Ajouter</div>
			</div>
			<div v-else class="row">
				<label>Ce magasin à plus d'un tiroir caisse (argent comptant)</label>
				<label class="switch"><input type="checkbox" v-model="viewCashiers"> <span class="slider round"></span></label>	
			</div>
			<div class="btn btn-primary" @click="save" id="cmdSave">Sauvegarder</div>
	</div>
	</div>
	</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<style>
		.container {max-width: 700px;margin-top:30px}
		.container > .row {margin-bottom: 20px}
		#index a {margin-bottom: 10px;width: 220px;padding: 10px;font-size: 25px;text-align: center;text-decoration: none;clear: both;background-color: #E3E3E3; color:rgb(99, 99, 99)}
		#index a.actif{background-color: rgb(255, 234, 167);color:rgb(243, 157, 0)}
		#store-name,#txtPrintTop  {width: 50%}
		 #txtPrintTop {height: 100px}
		.row > div.space, .row{justify-content:space-between }
		.narrow textarea {max-width: 400px}
		#imgLogo {max-width: 200px}
		#cmdSave {margin-top:20px}
		#appStore input[type=email] {width: 40%}
		.fa-times{cursor:pointer}
	</style>
	
	<script>
		$('#appStore .container > .row > *:first-child').addClass('col');
		if (!_store.CashierNames) {
			_store.CashierNames = [];
		}
		if (!_store.OpeningHours) {
			_store.OpeningHours = {};
		}
		var normalTime = _store.OpeningHours.Normal;
		if (!normalTime) {
			normalTime = _store.OpeningHours.Normal = [];
		}
		var daysOfWeek = [{ id: 0, Name: 'Lundi' }, { id: 1, Name: 'Mardi' }, { id: 2, Name: 'Mercredi' }, { id: 3, Name: 'Jeudi' }, { id: 4, Name: 'Vendredi' }, { id: 5, Name: 'Samedi' }, { id: 6, Name: 'Dimanche' }];
		for (var day of daysOfWeek) {
			var openHourDay = normalTime[day.id];
			if (!openHourDay) {
				openHourDay = normalTime[day.id] = {};
			}
			if (!openHourDay.From) {
				openHourDay.From = '09:00';
			}
			if (!openHourDay.To) {
				openHourDay.To = '17:00';
			}
		}
		var exceptions = _store.OpeningHours.Exceptions;
		if (!exceptions) {
			exceptions = _store.OpeningHours.Exceptions = [];
		}
		var appStore = new Vue({
			el: '#appStore',
			data: {
				store: _store,
				stores: _stores,
				multistore: window._multistore,
				cashierName: '',
				viewCashiers: _store.CashierNames.length > 0,
				daysOfWeek: window.daysOfWeek,
				openHourDate: new Date(),
				emailAdmin: window._EmailAdmin,
				emailSupplierOrder: window._EmailSupplierOrder,
                emailCustomers: window._EmailCustomers
            },
            methods: {
                addStore(e) {
					fetchPost('/admin/api/store/add', null, e.target, (result) => {
                        appStore.stores.push(result);
                        $(e.target).notify('Magasin ajouté');
                    });
                },
				removeException: function (date) {
					this.store.OpeningHours.Exceptions = this.store.OpeningHours.Exceptions.filter(c => c !== date);
				},
				formatDate: function (date) {
					return FormatDate(date);
				},
				addOpenHoursException: function () {
					// validate the date
					var d = moment(this.openHourDate);
					if (d.isValid()) {
						this.store.OpeningHours.Exceptions.push({ Date: d.toDate() });
						this.openHourDate = new Date();
					}
					
				},
				cashierRemove: function (cashierName) {
					this.store.CashierNames = this.store.CashierNames.filter(c => c !== cashierName);

				},
				addCashier: function () {
					if (this.cashierName) {
						this.store.CashierNames.push(this.cashierName);
						this.cashierName = ''; // reset to let enter another one
					}
					
				},
                isExpired(date) {
                    return moment().isAfter(date);
                },
                AddYear(openHour) {
                    openHour.Date = moment(openHour.Date).add(1, 'y').toDate();
                },
				uploadImage: function() {
					// https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
					var formData = new FormData();
					var fileField = document.querySelector('input[type="file"]');
					formData.append('image', fileField.files[0]);
					fetch('/admin/api/image/upload?type=Store', {
							method: 'POST',
							body: formData
						}).then(response => response.json())
						.then(response => {
							var isForceUpdateRequired = !appStore.store.UrlLogo;
							this.store.IdImage = response.IdImage; // update obj
							this.store.UrlLogo = response.UrlImage; // live update
                            if (isForceUpdateRequired) {
								appStore.$forceUpdate(); // 
                            }
							
						});
				},
				save: function() {
					$('body').addClass('waiting');
					fetch('/admin/api/store/save?id=' + this.store.Id, {
							method: 'post',
							body: JSON.stringify(this.store)
					})
						.then(response => response.json())
						.then(response => {
							if (response.Error) {
								$('#cmdSave').notify('Erreur de sauvegarde: ' + response.Error, 'error');
								return;
							} 
							if (!this.store.Id) {
								// first save, redirect to the page
								document.location = PageName + "?id=" + response.Id;
							}
							this.store.Id = response.Id;
							$('#cmdSave').notify('Sauvegardé!');
						}).catch((error) => {
							$('#cmdSave').notify('Erreur de sauvegarde: ' + error, 'error');
						}).finally(() => {
							$('body').removeClass('waiting');
						});
				},
			},
			mounted: function() {
				if (this.store) {
					// replace the current store object in the arrary
					for (var i = 0; i < this.stores.length; i++) {
						if (this.stores[i].Id == this.store.Id) {
							this.stores[i] = this.store;
						}
					}
				}
			}
		});
		function isValidDate(d) {
			return d instanceof Date && !isNaN(d);
		}
	</script>
</asp:Content>
