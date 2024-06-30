<%@ Page Title="Configuration des frais de transport" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Transport.aspx.cs" Inherits="WebSite.Admin.config.Transport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="appConfigTransport" class="app-config">
		<div class="container">
			<h1>Configuration des frais de livraison</h1>
		<div id="list-transport-schedule">
			<b>Liste des configurations de transport</b>
			<div class="transport-schedule"  v-for="c in configs">
				<i v-if="config == c" class="fa fa-arrow-right" aria-hidden="true"></i>
				<i v-else class="fa" aria-hidden="true"></i>
			<a href="#"  @click="config = c" >#{{c.Id}} <template v-if="c.Title">{{c.Title.Fr}}</template></a> <i v-if="c.Id !== 1" class="fa fa-times" @click="deleteConfig(c)"></i>
			</div>
		</div>
		 <div v-if="!config || config.Id" class="btn btn-default" id="cmdAddConfig" @click="addConfig">Ajouter <i class="fa fa-plus" ></i></div> 
		<div v-if="config">
				<div class="section">
					
					<bilingual-text :text="config.Title" placeholder="Titre"></bilingual-text>

					<div v-if="config.Id !== 1">Configuration des frais de transports pour:<br/>
						Catégorie:
						<select v-model="config.IdCategory" >
							<option v-for="c in categories" :value="c.Id">{{c.Title}}</option>
						</select>
						<br/>Groupe de clients:
						<select v-model="config.IdGroup">
							<option v-for="g in groups" :value="g.Id">{{g.Name}}</option>
                        </select>
					</div>
				</div>
				<div class="section">
					<h3>Préparation en magasin</h3>
					
					<div class="config">
						<label class="lbl">Permettre de récupéré en magasin.</label>
						<label class="switch"><input type="checkbox" v-model="config.InStoreCanBePickup"> <span class="slider round"></span></label>
					</div>
					
					<div v-if="config.InStoreCanBePickup">
						<div class="config-number" >
							<label class="lbl">Frais de préparation</label> 
							<div class="input-group"><input class="form-control" v-model="config.InStoreFee"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
			
						<div v-if="config.InStoreFee > 0" class="config-number indent" :class="{'greyout':config.InStoreFree == 0}">
							<label class="lbl">Gratuit avec achat de plus de:</label> 
							<div class="input-group"><input class="form-control" v-model="config.InStoreFree"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
					</div>
				</div>
			
			
				<div class="section" v-if="hasDropLocations">
					<h3>Point de chutes</h3>
					<div class="config">
						<label class="lbl">Permettre de récupérer à un point de chute (<a href="/Admin/config/#TRA" target="_blank">configurer</a>).</label>
						<label class="switch"><input type="checkbox" v-model="config.DropLocationsCanBePickup"> <span class="slider round"></span></label>
					</div>
					
					<div v-if="config.DropLocationsCanBePickup">
						<div class="config-number">
							<label class="lbl">Frais de préparation</label> 
							<div class="input-group"><input class="form-control" v-model="config.DropLocationsFee"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
			
						<div v-if="config.DropLocationsFee > 0" class="config-number indent" :class="{'greyout':config.DropLocationsFree == 0}">
							<label class="lbl">Gratuit avec achat de plus de:</label> 
							<div class="input-group"><input class="form-control" v-model="config.DropLocationsFree"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
					</div>
				</div>
			
				<div class="section">
					<h3>Livraison locale</h3>
					<div class="config">
						<label class="lbl">Permettre de faire de la livraison locale.</label>
						<label class="switch"><input type="checkbox" v-model="config.CanShippedLocal"> <span class="slider round"></span></label>
					</div>
					<div v-if="config.CanShippedLocal">
						<div class="config-number">
							<label class="lbl">Frais de transport pour livraison locale.</label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedLocalFee"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
			
						<div v-if="config.ShippedLocalFee > 0" class="config-number indent" :class="{'greyout':config.ShippedLocalFree == 0}">
							<label class="lbl">Gratuit avec achat de plus de:</label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedLocalFree"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
						
						<div class="config-number">
							<label class="lbl">Frais de préparation pour livraison locale.</label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedLocalPreparationFee"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
			
						<div v-if="config.ShippedLocalPreparationFee > 0" class="config-number indent" :class="{'greyout':config.ShippedLocalPreparationFree == 0}">
							<label class="lbl">Gratuit avec achat de plus de:<br /></label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedLocalPreparationFree"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
							
						</div>
					</div>
				</div>
				
				<div class="section" >
					<h3>Par la poste / Livraison à domicile</h3>
					<div class="config">
						<label class="lbl">Permettre l'expédition par la poste.</label>
						<label class="switch"><input type="checkbox" v-model="config.ShippedCanBe"> <span class="slider round"></span></label>
					</div>
					
					<div v-if="config.ShippedCanBe">
						<div class="config-number">
							<label class="lbl">Frais de transport pour expédition par la poste.</label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedFee"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
			
						<div v-if="config.ShippedFee > 0" class="config-number indent" :class="{'greyout':config.ShippedFree == 0}">
							<label class="lbl">Gratuit avec achat de plus de:</label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedFree"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
						
						<div class="config-number">
							<label class="lbl">Frais de préparation pour livraison par la poste.</label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedPreparationFee"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
			
						<div v-if="config.ShippedPreparationFee > 0" class="config-number indent" :class="{'greyout':config.ShippedPreparationFree == 0}">
							<label class="lbl">Gratuit avec achat de plus de:</label> 
							<div class="input-group"><input class="form-control" v-model="config.ShippedPreparationFree"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
						</div>
						
						
						<div>
							<h3>Prix différent Pays / Province</h3>
							<div v-for="ex in config.ShipExceptions">
								<span v-if="ex.CountryCodes">Pays: <span class="badge badge-info" v-for="c in ex.CountryCodes">{{c}}</span></span>
								<span v-if="ex.RegionCodes">Provinces: <span class="badge badge-success"  v-for="p in ex.RegionCodes">{{p}}</span></span>
								<span v-if="ex.PostalCodes" class="exception-postal-code">Code Postal: <span class="badge badge-light" v-for="z in ex.PostalCodes">{{z}}</span></span>
								{{ex.ShippedFee}}$ / {{ex.ShippedFree}}$
								<i class="fa fa-edit" @click="configException = ex"></i>
							</div>
							<div v-if="configException" id="config-exception">
								<div class="btn btn-danger" @click="deleteException" style="float: right">Effacer</div>
								<h4>Pays</h4>
								<div v-if="configException.CountryCodes">Pays: <span class="badge badge-info" v-for="c in configException.CountryCodes">{{c}}</span></div>
								<input v-model="configExceptionAddCountry"/> <div class="btn btn-primary" @click="AddCountryException">Ajouter un pays</div>

								<div>Utiliser les <a target="_blank" href="https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes">codes de pays ISO a 2 lettres</a>. Ex: 'CA' pour Canada et 'US' pour les États-Unies</div>
								
								<div v-if="configException.CountryCodes">
									<h4>Provinces / États</h4>
									<div v-if="configException.RegionCodes">Provinces: <span class="badge badge-success"  v-for="p in configException.RegionCodes">{{p}}</span></div>
									<input v-model="configExceptionAddProvince"/> <div class="btn btn-primary" @click="AddProvinceException">Ajouter province</div>
									<div>Utiliser les <a target="_blank" href="https://www150.statcan.gc.ca/n1/pub/92-195-x/2011001/geo/prov/tbl/tbl8-fra.htm">codes de province à 2 lettres</a>. Ex: 'QC' pour Québec et 'ON' pour l'Ontario.</div>
									<div v-if="configException.CountryCodes == 'CA'">NL PE NS NB ON MB SK AB BC YT NT NU</div>
								</div>
								
								<div v-if="configException.RegionCodes" class="exception-postal-code">
									<h4>Codes postaux / Zip</h4>
									<div v-if="configException.PostalCodes">Codes Postaux: <span class="badge badge-light"  v-for="p in configException.PostalCodes">{{p}}</span></div>
									<input v-model="configExceptionAddZip"/> <div class="btn btn-primary" @click="AddZipException">Ajouter code postal</div>
									<div class="inf">Utiliser le code postaux complet ou partiel. Par example H7S inclue tous les codes postaux qui début avec H7S. Le préfixe peut avoir de 1 à 6 lettres/caractères. Les espaces et majuscule sont ignorés.</div>
															
								</div>
								
								<div v-if="configException.CountryCodes">
									<div class="config-number">
										<label class="lbl">Frais de transport pour expédition par la poste.</label> 
										<div class="input-group"><input class="form-control" v-model="configException.ShippedFee"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
									</div>
			
									<div v-if="config.ShippedFee > 0" class="config-number">
										<label class="lbl">Gratuit avec achat de plus de:</label> 
										<div class="input-group"><input class="form-control" v-model="configException.ShippedFree"> <span class="input-group-append"><span class="input-group-text">$</span></span></div>
									</div>
								</div>
								<div class="btn btn-success" @click="configException = null">Fermer</div>
							</div>
							<div class="btn btn-primary" @click="AddException" id="add-exception">Ajouter une exception</div>
						</div>
					</div>
				</div>

			
				<div class="btn btn-success" @click="save" id="cmdSave">Sauvegarder</div>
			</div>
		</div>
    </div>
    <style>
		#list-transport-schedule .transport-schedule {cursor: pointer}
		#list-transport-schedule .fa {width: 20px}
		.transport-schedule {display:block}
		.fa-times {color:red;cursor:pointer}
		#cmdSave { margin-top:20px}
		#cmdAddConfig {margin:20px 0}
		.badge { margin-right: 5px}
		.badge-light{background-color: #cddc39}
		#config-exception{ margin:20px; padding: 20px; background-color: #eee}
		h4{ font-size: 1.2em}
		.fa-edit{ cursor: pointer}
		.inf {font-style:italic; color:darkgray}
		#add-exception{ margin-top:10px}
		.exception-postal-code { display: none}
		.greyout {opacity:0.5}
	</style>
	<script>
		var appConfigTransport = new Vue({
			el: '#appConfigTransport',
			data: {
				configs: window._transportSchedules /* array of configurations */,
				config: window._transportSchedules[0], /* current configuration */
				categories: window._categories,
				groups: window._groups,
				hasDropLocations: window._hasDropLocations,
				configException: null,
				configExceptionAddCountry: null,
				configExceptionAddProvince: null,
				configExceptionAddZip:null
			},
			methods: {
				save: function () {
					// serialized and store to settings
					var serialized = JSON.stringify(this.configs);
					fetch('/admin/api/transport-schedule/save', {
						method: 'post',
						body: serialized
					})
						.then(response => response.json()).then(json => {
							if (json.Error) {
								$('#cmdSave').notify('Erreur de sauvegarde: ' + json.Error, 'error');
							} else {
								this.configs = json;
								this.config = this.configs.find(c => c.Id === this.config.Id); // reload current config
								if (!this.config) {
									this.config = window._transportSchedules[0]; // first one 
								}
								$('#cmdSave').notify('Sauvegarder');
							}
						
						}).catch((error) =>
							$('#cmdSave').notify('Erreur de sauvegarde: ' + error, 'error')
						);


				},
				deleteConfig: function (config) {
					if (confirm('Effacer la configuration : ' + config.Title + '?')) {
						this.configs = this.configs.filter(c => c !== config);
						// select first one
						this.config = this.configs[0];
					}
				},
				addConfig: function () {
					var newConfig = { Title: { Fr: 'Nouvelle configuration' } };
					
					var maxId = 0;
					for (var c of this.configs) {
						maxId = Math.max(c.Id, maxId);
					}
					newConfig.Id = maxId + 1;
					this.configs.push(newConfig);
					this.config = newConfig;
				},
				AddException: function () {
					if (!this.config.ShipExceptions) {
						this.config.ShipExceptions = [];
					}

					this.configException = {}; // create a new one
					this.config.ShipExceptions.push(this.configException);
				},
				AddCountryException: function () {
					if (this.configExceptionAddCountry == null || this.configExceptionAddCountry.length !== 2) {
						$.notify('Le code de pays doit avoir 2 charactères','error');
						return;
					}
					if (!this.configException.CountryCodes) {
						this.configException.CountryCodes = [];
					}
					this.configException.CountryCodes.push(this.configExceptionAddCountry.toUpperCase());
					this.configExceptionAddCountry = null; // clear value
				},
				AddProvinceException: function () {
					if (this.configExceptionAddProvince == null || this.configExceptionAddProvince.length !== 2) {
						$.notify('Le code de province / état doit avoir 2 charactères', 'error');
						return;
					}
					if (!this.configException.RegionCodes) {
						this.configException.RegionCodes = [];
					}
					this.configException.RegionCodes.push(this.configExceptionAddProvince.toUpperCase());
					this.configExceptionAddProvince = null; // clear value
				},
				AddZipException: function () {
					if (this.configExceptionAddZip == null || this.configExceptionAddZip.length === 0 || this.configExceptionAddZip.length > 7) {
						$.notify('Le code postal/zip doit avoir entre 1 et 6 charactères', 'error');
						return;
					}
					if (!this.configException.PostalCodes) {
						this.configException.PostalCodes = [];
					}
					this.configException.PostalCodes.push(this.configExceptionAddZip.toUpperCase());
					this.configExceptionAddZip = null; // clear value
				},
				deleteException: function () {
					var toRemove = this.configException;
					this.config.ShipExceptions = this.config.ShipExceptions.filter(c => c !== toRemove);

					this.configException = null;
				}


			}
		});
	</script>
</asp:Content>
