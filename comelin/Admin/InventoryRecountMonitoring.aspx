<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<%
	    Page.RegisterJavascriptVariable("_InventoryUploadFile", Util.StrToBool(Settings.Current.Get("_InventoryUploadFile")));

	%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <style>    	.IsModeEnable {
                       background-color: #d5f6d8
    	}
    </style>
	<div id="inventoryMode" v-cloak>
		
		<h1>Résumé du mode inventaire {{StoreName}}</h1>
		<a href="InventoryRecount.aspx">Accueil du mode inventaire / Rapports</a>
		<template v-if="InventoryMode">
			
			<div v-if="Settings._InventoryUploadFile"><input type="file" id="fileImport" /> <div @click="uploadInventoryFile($event)" class="btn btn-secondary" alt="Le fichier doit en CSV, 1er colonne le code à barre, la 2e la quantité">Téléverser un fichier d'inventaire</div></div>
			<div class="row">
				<div class="col">Vous êtes présentement en mode 
					<b>
					<template v-if="BacksStoreMode">entrepôt / back store</template>
                    <template v-else>normal</template>
                    </b>
					<div class="btn btn-secondary" @click="IsBackStoreModeInfoVisible = !IsBackStoreModeInfoVisible">plus d'information / modifier</div>
				</div>
            </div>
			<div class="row" v-if="IsBackStoreModeInfoVisible || BacksStoreMode">
                <div class="col col-6" :class="{IsModeEnable:!BacksStoreMode}">
					<h3>Mode normal</h3>
					Les articles vendus sont déduits des quantités déjà comptées.<br></br>
                    Exemple:
                    <ul>
                        <li>Réception de 5 articles.
                        </li>
                        <li>Effectuer une <b>vente</b> d'un article.
                        </li>
                    </ul>
                    <p>Comelin assumera que l'article vendu avait été compté et assumera que votre inventaire est de 4.</p>
                    <ul>
                        <li>Réception de 5 autres articles.
                        </li>
                    </ul>
                    <p>Comelin aura un total de <b>9</b> articles.</p>
					<div class="btn btn-warning" v-if="BacksStoreMode" @click="BackStoreMode(false)">Activé le mode normal</div>
                </div>
                <div class="col col-6" :class="{IsModeEnable:BacksStoreMode}">
                    <h3>Mode Entrepôt/back store</h3>
                    Les articles vendus sont ignorés des quantités déjà comptées.<br/>
                    Exemple:
                    <ul>
                        <li>Réception de 5 articles.
                        </li>
                        <li>Effectuer une <b>vente</b> d'un article.
                        </li>
                    </ul>
                    <p>Comelin assumera que l'article vendu n'était PAS compté et assumera que votre inventaire est toujours de 5 puisque l'article vendu n'était pas dans le back store.<br/>
                        L'article vendu aurait été pris dans la partie avant du magasin et le décompte de 5 aurait été pris dans l'entrepôt / back store.</p>
                    <ul>
                        <li>Réception de 5 autres articles.
                        </li>
                    </ul>
                    <p>Comelin aura un total de <b>10</b> articles.</p>
                    <div class="btn btn-warning" v-if="!BacksStoreMode" @click="BackStoreMode(true)">Activé le mode entrepôt/back store</div>
                </div>
            </div>
			<div class="row">
				<div class="col text-right" style="margin-bottom: 20px">
					<div v-if="!step1" class="btn btn-primary" @click="step1=true">Fin du mode inventaire...</div>
					<template v-else>
						Pour les {{ArticlesTotal - ArticlesRecounted}} produits qui n'ont pas été recompté
						<div class="btn btn-danger" @click="CompleteInventoryMode(true)">Mettre les quantités à 0</div>
						<div class="btn btn-danger" @click="CompleteInventoryMode(false)">Laisser les quantités inchangés</div>	
					</template>
				
				</div>
			</div>
			<div class="row">
				<div class="col">
						<div class="recount-box">
						<div>
							<b>Articles recomptés</b>
							<h2>{{ArticlesRecounted}} / {{ArticlesTotal}}</h2>
							<div class="progress">
								<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" :style="{ width: ArticlesRecountedPercentage }" :aria-valuemax="ArticlesTotal">{{ArticlesRecountedPercentage}}</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 col-sm-6 col-lg-3 ">
					<div class="recount-box">
						<div>
							<b>Articles qui n'ont pas été recomptés</b>
							<h2>{{ArticlesTotal - ArticlesRecounted}}</h2>
							<div class="progress">
								<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" :style="{ width: ArticlesNotRecountedPercentage }" :aria-valuemax="ArticlesTotal">{{ArticlesNotRecountedPercentage}}</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-12 col-sm-6 col-lg-3 ">
					<div class="recount-box">
						<div>
							<b>Articles avec bonne quantité</b>
							<h2>{{ArticlesWithGoodQuantity.length}}</h2>
							<div class="progress">
							<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" :style="{ width: ArticlesWithGoodQuantityPercentage }" :aria-valuemax="ArticlesRecounted">{{ArticlesWithGoodQuantityPercentage}}</div>
								</div>
						</div>
					</div>
				</div>
				<div class="col-12 col-sm-6 col-lg-3 ">
					<div class="recount-box">
						<div>
							<b>Articles avec des manques</b>
							<h2>{{ArticlesMissingQuantity.length}}</h2>
							<div class="progress">
							<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" :style="{ width: ArticlesMissingQuantityPercentage }" :aria-valuemax="ArticlesRecounted">{{ArticlesMissingQuantityPercentage}}</div>
								</div>
						</div>
					</div>
				</div>
				<div class="col-12 col-sm-6 col-lg-3 ">
					<div class="recount-box">
						<div>
							<b>Articles avec des surplus</b>
							<h2>{{ArticlesWithExtraQuantity.length}}</h2>
							<div class="progress">
							<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" :style="{ width: ArticlesWithExtraQuantityPercentage }" :aria-valuemax="ArticlesRecounted">{{ArticlesWithExtraQuantityPercentage}}</div>
								</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
			<div class="col-12 col-sm-6 col-lg-3 ">
				<div class="recount-box">
					<div>
						<b>Articles qui n'ont pas été recomptés</b>
						<div v-for="p in ArticlesNotCounted">{{p.T}}
							<span class="badge badge-pill" :class="{ 'badge-danger': p.B < 0,  'badge-info': p.B > 0}">Inventaire {{p.B}}</span>
						</div>
					</div>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-lg-3 ">
				<div class="recount-box">
					<div>
						<b>Articles avec la bonne quantité</b>
						<div v-for="p in ArticlesWithGoodQuantity">{{p.T}}</div>
					</div>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-lg-3 ">
				<div class="recount-box" >
					<div v-if="ArticlesMissingQuantityTotalCost">
						<b>Valeur total (coût)</b>
						<h2>{{ArticlesMissingQuantityTotalCost.toFixed(2)}} $</h2>
					</div>
					<div v-else>
						<b>Aucun produit!</b>
					</div>
				</div>
				<div class="recount-box"  v-if="ArticlesMissingQuantityTotalCost">
					<div>
						<b>Articles avec des manques</b>
						<div v-for="p in ArticlesMissingQuantity">{{p.T}} 
							<span class="badge badge-pill" :class="{'badge-warning': p.B - p.A > 1, 'badge-danger': p.B - p.A > 3,  'badge-info': p.B - p.A <= 1}">Manque {{NumberToQuantity(p.B - p.A)}}</span>
						</div>
					</div>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-lg-3 ">	
				<div class="recount-box" >
					<div v-if="ArticlesWithExtraQuantityTotalCost">
						<b>Valeur total (coût)</b>
						<h2>{{ArticlesWithExtraQuantityTotalCost.toFixed(2)}} $</h2>
					</div>
					<div v-else>
						<b>Aucun produit!</b>
					</div>
				</div>
				<div class="recount-box">
					<div>
						<b>Articles avec des surplus</b>
						<div v-for="p in ArticlesWithExtraQuantity">{{p.T}}
							<span class="badge badge-pill" :class="{'badge-warning': p.A - p.B > 1, 'badge-danger': p.A - p.B > 3,  'badge-info': p.A - p.B <= 1}">{{NumberToQuantity(p.A - p.B)}} de trop</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		</template>
		<div v-if="!InventoryMode">
			<p>Pas en mode inventaire</p>
			<div class="btn btn-danger" @click="StartInventoryMode()">Démarré le mode inventaire</div>
		</div>
		<div class="modal fade" id="modal-downloading">
		  <div class="modal-dialog" role="document">
			<div class="modal-content">
			  <div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">Téléchargements des données...</h5>
			  </div>
			</div>
		  </div>
		</div>
	</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<style>
		body{background-color: #F9FBFD}
		.recount-box {margin-bottom: 30px}
		.recount-box > div {background-color: white; padding: 20px}
		.progress {height: 30px}
		.progress-bar {text-shadow: 1px 1px 2px black, 0 0 1em blue, 0 0 0.2em darkblue;}
	</style>
	<script>

        var setting = {};
        setting._InventoryUploadFile = window._InventoryUploadFile;
		$('.progress-bar').addClass('progress-bar-striped progress-bar-animated');
        var vm = new Vue({
            el: '#inventoryMode',
            data: {
                DicProducts: {},
                StoreName: '',
                step1: false,
                InventoryMode: false,
                Settings: setting,
				BacksStoreMode: false,
				IsBackStoreModeInfoVisible: false
			},
			computed: {
				Products() {
					// return value of the object
					return Object.values(this.DicProducts);
				},
				ArticlesTotal() {
					return Object.keys(this.DicProducts).length;
				},
				ArticlesNotCounted() {
					return this.Products.filter(function(p) {return !p.A;});
	
				},
				ArticlesRecounted() {
					var c = 0;
					this.Products.forEach(function(p) {
						if (p.A) {
							c++;
						}
					});
					return c;
				},
				ArticlesWithGoodQuantity() {
					return this.Products.filter(function(p) {return p.A && p.A === p.B;});
				},
				ArticlesMissingQuantity() {
					return this.Products.filter(function(p) {return p.A && p.A < p.B;});
				},
				ArticlesWithExtraQuantity() {
					return this.Products.filter(function(p) {return p.A && p.A > p.B;});
				},
				ArticlesRecountedPercentage() {
					return this.FormatPercentage(this.ArticlesRecounted, this.ArticlesTotal);
				},
				ArticlesNotRecountedPercentage() {
					return this.FormatPercentage(this.ArticlesTotal - this.ArticlesRecounted, this.ArticlesTotal);
				},
				ArticlesWithGoodQuantityPercentage() {
					return this.FormatPercentage(this.ArticlesWithGoodQuantity.length, this.ArticlesRecounted);
				},
				ArticlesMissingQuantityPercentage() {
					return this.FormatPercentage(this.ArticlesMissingQuantity.length, this.ArticlesRecounted);
				},
				ArticlesWithExtraQuantityPercentage() {
					return this.FormatPercentage(this.ArticlesWithExtraQuantity.length, this.ArticlesRecounted);
				},

				ArticlesMissingQuantityTotalCost() {
					var total = 0;
					this.ArticlesMissingQuantity.forEach(function (p) {
						total -= p.C * (p.A - p.B);
					});
					return total;
				},
				ArticlesWithExtraQuantityTotalCost() {
					var total = 0;
					this.ArticlesWithExtraQuantity.forEach(function (p) {
						total += p.C * (p.A - p.B);
					});
					return total;
				}
                
			},
			methods: {
                NumberToAmount: str => str.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '$' ,
				NumberToQuantity: str => str.toLocaleString(undefined, { minimumFractionDigits: 0, maximumFractionDigits: 3 }),
                uploadInventoryFile() {
                    var e = $$('fileImport');
                    if (e.files.length === 0) {
                        $(e).notify('Sélectionner un fichier', 'error');
                        return;
                    }
                    var file = e.files[0];
                    if (file) {
                        var reader = new FileReader();
                        reader.readAsText(file, "UTF-8");
                        reader.onload = function (evt) {

                            let error;
                            fetch('/admin/api/inventory-recount/upload' + window.location.search, {
                                method: 'POST',
                                body:  evt.target.result
                            }).then(response => {
                                    if (!response.ok) {
                                        error = response.statusText; // continue with response.json to get the stream error details
                                    }
                                    return response.json();
                                })
                                .then(response => {
                                    $.notify('Importation de ' + result + ' produits');
                                }).catch((error) => {
                                    notifyError(error + '\n' + url,ctrl);
                                });

                        }
                    }
                },
				StartInventoryMode() {
					if (confirm('Cette opération débutera le mode inventaire. Continuer?')) {
						this.SendToWebSocket({ Type: 'StartInventory' });
					}
					
				},
				CompleteInventoryMode: function (resetZeroValue) {
					if (confirm('Cette opération terminera le mode inventaire. Continuer?')) {
						this.SendToWebSocket({ Type: 'EndInventory', ResetZeroQuantity: resetZeroValue });
					}
				},
				FormatPercentage: function(numerator, denominator) {
					if (!denominator) {
						return '';
					}
					return (100 * numerator / denominator).toFixed(1) + '%';
				},
				FormatNumber: function (number) {
					return Number(number.toFixed(3));
				},
				BackStoreMode: function (isEnable) {
                    this.SendToWebSocket({ Type: 'BacksStoreMode', IsEnable: isEnable });
				},
				SendToWebSocket: function (obj) {
					 socket.send(JSON.stringify(obj));
				}
			},
			mounted() {
			}
		});


		// connect websocket to received live data
		var socket = new WebSocket(WebSocketUrl + '/websocket/inventory-mode/' + $.query.GET(queryStringIdStore));
		var objToMerge = {};
		socket.onmessage = function (e) {
			var obj = JSON.parse(e.data);
			
			if (obj.Type === "Inv") {
				if (objToMerge) {
					objToMerge[obj.Id] = obj; // caching to avoid UI updates and lags
				} else {
					Vue.set(vm.DicProducts, obj.Id, obj);
				}
				
			} else if (obj.Type === "StoreName") {
				vm.StoreName = obj.Name;
			} else if (obj.Type === "InventoryMode") {
				vm.InventoryMode = obj.Enable;
				vm.BacksStoreMode = obj.IsBackStoreMode;
				if (vm.InventoryMode) {
					jQuery('#modal-downloading').modal('show');
				}
				// reset some data
				vm.step1 = false;
				if (!vm.InventoryMode) {
					vm.DicProducts = {};
				}
				
			} else if (obj.Type === 'InitialSendingCompleted') {
				initialDownloadCompleted();
			} 
		};
		socket.onclose = function (event) {
			console.log("WebSocket is closed now.");
			console.log("Code: " + event.code);
			console.log("Reason: " + event.reason);
			console.log("Was Clean: " + event.wasClean);
		};
		socket.onerror = function (event) {
			console.error("WebSocket error observed:", event);
		};
		function initialDownloadCompleted() {
			if (objToMerge) {
				vm.DicProducts = objToMerge;
				objToMerge = null; // future update will be live
				jQuery('#modal-downloading, .modal-backdrop').remove(); // remove the modal downloading...
				jQuery('.modal-open').removeClass('modal-open');
			}
		}
	</script>
</asp:Content>
