<%@ Page Title="Config" Language="	C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebSite.Admin.ConfigurationPage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="appConfiguration" class="app-config" v-cloak>
		<div id="search-bar">
			<div class="container">
                <div>
					<i class="fa fa-search"></i>
					<input placeholder="Recherche" v-model="search"  id="txtSearch"/>
				</div>
			</div>
		</div>
		<div id="index">
			<h1 @click="search = ''; ">Configurations</h1>
			<a v-for="s in sections" @click="search = '#' + s.id" v-html="s.firstElementChild.innerHTML" :class="{'indent':s.classList.contains('sub-section')}"></a>
		</div>
		<div class="container">
			<div id="mainSection">
				<config-section id="INF" fontawesome="building" label="Information sur la compagnie">
					<config id="nom" setting="name">Nom de l'entreprise</config>
					<config id=courriel setting="Email" label="Courriel de l'entreprise"></config>
                    
                    <visible-if visible="Email">
                        <check class="indent" id="courriel-visible" setting="_IsEmailVisible">Courriel visible sur les pages Web</check>
                    </visible-if>
                    <config id=telephone setting="_Phone" label="Numéro de téléphone (visible en ligne)"></config>
                    <config id=adresse setting="_Address" label="Adresse (visible en ligne)"></config>
                    <config id=adresseLien setting="_AddressLink" label="Liens Google Maps"></config>
					
					<lnk href="/admin/SettingsEmail.aspx">Configuration SMTP pour l'envoi du courriel <help url="articles/utiliser-votre-serveur-courriel-smtp-d-entreprise"></help></lnk>
					<config id="courrielAdmin" setting="EmailAdmin" label="Courriel de l'administrateur"></config>
					<lnk href="Magasin.aspx">Configuration des magasins / entrepôts / boutiques</lnk>
					<lnk href="Magasin.aspx#heures">Heures d'ouverture</lnk>
				</config-section>
				
				<config-section id="SUP" icon="/admin/images/order-supplier.png" label="Commandes fournisseurs" help-url="articles/commande-fournisseur-et-reception-marchandises">
					<check id="qte-min" setting="DisableQuantityMinTag" reverse="true">Utiliser les quantités minimums</check>
					<check id="date-prevue" setting="SupplierOrderSetDateAvailable">Assigner par défaut la date prévue au produit (pré-commande)</check>
					<config id="four-courriel" setting="_EmailSupplierOrder">Courriel de correspondance</config>
					<check id="four-courriel-cc" setting="_EmailSupplierOrderBcc">Recevoir une copie conforme du courriel envoyé</check>
					<sub-section id="fournisseur-impression" label="Impression" fontawesome="print">
						<p>Les options ci-dessous affecteront aussi l'affichage des réceptions de marchandise.</p>
						<check id="four-imp-regroup" setting="_SupplierOrderPrintGroupByBrand">Regroupement par marque</check><br/>
						<check id="four-imp-code" setting="_SupplierOrderPrintCode">Code de produit</check>
						<check id="four-imp-barcode" setting="_SupplierOrderPrintBarCode">Code à barres</check>
						<check id="four-imp-cout" setting="_SupplierOrderPrintCost">Coût du produit</check>
						<check id="four-imp-vol" setting="_SupplierOrderPrintVolume">Volume</check>
					</sub-section>
					<sub-section id="reception" label="Réception de marchandise" icon="/admin/images/receives_stock.png">
						<check id="reception-code-bc-req" setting="RequireCodeOrBarCode">Exiger un code de produit ou code à barre.</check>	
						<check id="reception-impression-defaut" setting="RestockPrintReservationDefault">Impression des articles mis en réservations (valeur par défaut).</check>
					</sub-section>
				</config-section>

				<config-section id="FAC" icon="/admin/images/facturation.png" label="Facturation" help-url="comelin/panneau-administration/configuration/facturation">
					<check id="combiner-qte" setting="ScanSeparatedLine">Scanner sur les lignes séparées (ne pas combiner les quantités)</check>
					<check id="promocode-unique" setting="PromoCodeMultiple">Permettre l'utilisation de plusieurs codes promotionnels dans la même commande.</check>
					<check id="montant-exact" setting="PaymentCashAutomaticallyEnterExactAmount">Suggérer le montant exact lors de paiement en argent comptant</check>
					<check id="classer-produits" setting="InvoicePrintSort">Classer les produits sur la facture par titre</check>
					<check id="imprimer-categorie" setting="InvoicePrintProductCategory">Imprimer la catégorie des produits sur les factures</check>
					<check id="demander-nom" setting="EnableAskServedByBefore">Demander le nom de l'employé (Vous avez été servi par...)</check>
					<visible-if visible="EnableAskServedByBefore">
						<check id="demander-mot-de-passe" setting="ServedByAskPassword">Demander à l'employé d'entrer son mot de passe si plusieurs employés sont connectés.</check>
						<check id="employe-facturation" setting="EnableBilledBy">Permettre à un employé, autre que celui qui a servi le client, de faire la facturation</check>
					</visible-if>
					<lnk href="Magasin.aspx#entete">Entête et bas de facture</lnk>
					<sub-section label="Option d'impression de facture 80mm" id="impression80" fontawesome="print" class=notoc>
						<check id="affiche-code" setting="PrintProductCode">Afficher le code de produit</check>
						<visible-if visible="PrintProductCode">
							<check class="indent" id="affiche-code-debut" setting="PrintProductCodeEnd" reverse="true">Code de produit visible au début de la description</check>
						</visible-if>
						<check id="affiche-marque" setting="PrintBrand">Afficher la marque du produit</check>
						<check id="regrouper" setting="InvoicePrintSort">Classer les produits sur la facture par titre</check>
                        <check id="imprimer-categories" setting="InvoicePrintProductCategory">Imprimer les catégories des produits</check>
						
					</sub-section>
					<sub-section label="Option d'impression de facture 8½ x 11..." id="impression8_11" fontawesome="print"  class=notoc>
						<check id="affiche-code-811" setting="_DisplayProductCode">Afficher le code de produit</check>
						<check id="affiche-barcode" setting="_DisplayProductBarcode">Afficher le barcode</check>	
					</sub-section>
					<sub-section icon="/admin/images/customer.png" label="Client" id="Client" help-url="articles/configuration-initiale-client">
						<check id="vente-anonyme" setting="RejectAnonymousSales" reverse="true">Permettre de faire des ventes sans demander le nom du client (anonyme)</check>
						<check id="curseur-client" setting="CursorInintialAtCustomer" >Position initiale du curseur pour sélectionner le client</check>
						<check id="courriel-client" setting="InvoiceSendEmailCheckByDefault">Copie par courriel sélectionné par défaut</check>
						<check id="impression-courriel-client" setting="InvoicePrintCustomerEmail">Impression de l'adresse courriel du client</check>	
						<check id="impression-tel-client" setting="InvoicePrintCustomerPhone">Impression du numéro de téléphone du client</check>	
						<check id="impression-adresse-client" setting="InvoicePrintCustomerAddress">Impression de l'adresse du client</check>	
						<check id="compte-recevable" class="internal" setting="ModuleAccountReceivable" >Module comptes clients</check>
						<check id="date-anniversaire" setting="DisableAnniversary" reverse="true">Date d'anniversaire</check>
						<visible-if visible="DisableAnniversary" reverse="true" class="indent">
							<check id="date-anniversaire-mois" setting="DisableBirthdayDay" reverse="true">Jour du mois</check>	
							<check id="date-anniversaire-année" setting="EnableBirthday" >Année de naissance</check>
						</visible-if>
						<check id="region" setting="EnableRegion">Region administrative</check>
                        <sub-section id="points" FontAwesome="certificate" label="Points de fidélisation" help-url="articles/programmation-de-points-fid%C3%A9lit%C3%A9s" >
							<check id="module-points" setting="Stamp">Activer le module de points de fidélisation</check>
							<visible-if visible="Stamp">
								<config-number id="point-tranche" setting="StampReceiveEvery" suffix="$">Lorsque le client achète une tranche de</config-number>
								<config-number id="point-recu" setting="PointsReceived" suffix="pts">il obtient</config-number>
								<config-number id="point-exchange" setting="StampExchangeNb" suffix="pts">Le client peut échanger</config-number>
								<config-number id="point-exchange-qte" setting="StampExchangeValue" suffix="$">pour obtenir des articles d'une valeur de </config-number>
                                <check id="point-tx-inclue" setting="PointRebateIncludedTx">Le rabais inclue les taxes</check>
								<config-number id="point-exchange-max" setting="PointExchangeLimit" suffix="pts" placeholder="sans limite">Nombre maximal de points par échange</config-number>
								<check setting="PointsGivenOnline" label="Le client obtient des points lors des achats en ligne"></check>
								<check setting="_PointsCanBeUseOnline" label="Le client peut utiliser les points dans la boutique en ligne."></check>
								
								<check ID="point-ne-donner-pas-de-rabais" setting="PointsNotGivenIfAnyRebateTag" label="Ne jamais donner de points s'il y a un rabais."></check>
								<check ID="point-paiement-ne-donne-pas-de-point" setting="PointsNotGivenIfPaiementWithPoints" label="Ne donne pas de points sur le montant payé avec des points"></check>
								<check ID="point-paiement-note-de-credit" setting="PointsNotGivenIfPaiementWithCreditNote" label="Ne donne pas de points sur le montant payé avec des notes de crédit"></check>
								<check ID="point-si-tout-les-groupes-donne-des-points" setting="PointsIfAllGroupsGivePoints" label="Groupes multiples: Donne des points si TOUS les groupes donnent des points."></check>
								<check ID="point-avertissement-si-peut-prendre-les-points" setting="PointsWarningIfCustomerCanUsePoints" label="Avertissement lors du paiement si le client peut utiliser ses points"></check>

							</visible-if>
						</sub-section>
					</sub-section>
					
					<sub-section id="Paiement" label="Mode de paiement" fontawesome="credit-card" >
                        <lnk href="/admin/Settings.aspx">Renommer les modes de paiement</lnk>
					</sub-section>
					<sub-section id="sous-total" label="Sous-totaux pour facture et écran-Client"  icon="/admin/images/second-monitor.png" class="internal"  >
						<div v-for="idCat in settingIdCategoriesSubTotal">
							<div>{{idCat}} <i class="fa fa-times" @click="settingIdCategoriesSubTotalRemove(idCat)"></i></div>
						</div>
						<div><input v-model="idCategoriesSubTotalAdd" /> <div class="btn btn-primary" @click="settingIdCategoriesSubTotalAdd">Ajouter</div></div>
					</sub-section>
					<check id="module-facture-courriel" setting="ModuleEmailInvoice">Module communication client</check>
					<check id="fermeture-montant-pareil" setting="CashCountingKeepSameBalance" >Fermeture de caisse: proposer un dépôt avec le montant des ventes pour garder la même balance dans la petite caisse d'une journée à l'autre</check>
				</config-section>
                <config-section id="CarteCadeau" label="Cartes cadeaux" icon="/admin/images/giftcard.png" help-url="articles/activation-et-configuration-des-cartes-cadeaux">
                    <check id="CarteCadeauActive" setting="HideGiftCards" reverse="true">Activer le module carte cadeau</check>
                    <visible-if visible="HideGiftCards" reverse="true">
						<div class="internal">
                        <config id="CarteCadeauRegEx" setting="GiftCardPattern">RegEx de la carte cadeau</config>
                        Ex: <code>^(([\d]{2,3})|(17\d{6}))$</code>
                        </div>
                        <lnk href="/admin/GiftReinitialize.aspx">Réinitialisation des cartes cadeaux</lnk>
                    </visible-if>
                    <config-number id="carte-cadeau-max" setting="GiftCardMax" placeholder="1000" label="Montant maximal (à l'activation)"></config-number>
					<check id="CarteCadeauInstant" setting="_GiftCardInstantDelivery" defaultvalue="true">
                        Lors d'un achat en ligne: activation et envoie du courriel automatisé avec le numéro de la carte cadeau
                    </check>
					<p>Prendre note que la carte sera active seulement lorsque la transaction est complétée en magasin.</p>
                    <check setting="_GiftCardEmailIfSendInStore">Lors des achats en magasin: envoie du courriel avec le numéro de la carte cadeau</check>
					<lnk href="/admin/Communication.aspx">Activation et modification du courriel pour les cartes cadeaux</lnk>
                </config-section>
				
				<config-section id="PUN" icon="/admin/images/punch.png" label="Horodateur">
					<lnk href="/admin/Punchs.aspx">Rapport et modifications des heures travaillées</lnk>
					<check setting="_PunchGroupByStore">Regrouper les heures de travail par magasin</check>
				</config-section>
				
				<config-section id="TRA"  label="Livraison et transport" icon="/admin/images/transport.png" help-url="comelin/panneau-administration/configuration/livraison-et-transport">
                    <config-bilingual id="pickup-info" setting="_InStorePickupInfo" label="Instruction pour la récupération en magasin" multiple="true" ></config-bilingual>
					<config-bilingual id="local-def" setting="_ShippingLocalDef" label="Description de la zone pour la 'livraison locale'" multiple="true" ></config-bilingual>
					<lnk href="Transport.aspx">Configuration des frais de transport</lnk>
                    <lnk v-if="multistore" href="Magasin.aspx">Magasins qui font la livraison</lnk>
					<sub-section id="CHU" fontawesome="map-marker" label="Points de chute...">
					    <config id="points-chute" setting="DropLocations" Label="Liste des points de chute" multiple="true"></config>
                        <config-bilingual id="chute-info" setting="_DropLocationInfo" label="Instruction pour les points de chute" multiple="true" ></config-bilingual>
					</sub-section>
					<check id="transporteur" setting="CarrierSpecific">Le client peut indiquer son transporteur et son numéro de client.</check>
					<config id="liv-pays" setting="_ShippingCountries" label="Liste des code de pays séparé par des virgules (ex: CA,US):"></config>
					<sub-section class="internal" label="Intégration avec ShipDay">
						<check setting="_ShipDay.IsEnable">Activé le module sur les livraisons locales</check>
						<config setting="_ShipDay.ApiKey">Clé API</config>
                    </sub-section>
				</config-section>

				<config-section  id="MKT" label="Marketing" FontAwesome="th">
					<check id="infolettre" class="internal" setting="ModuleNewsletter" label="Module infolettre"></check>
					<check id="newsletter-check-by-default" setting="NewsletterSubscribeByDefault" label="Inscription de nouveaux clients à l'infolettre automatiquement"> </check>
					<lnk href="/admin/mailchimp.aspx">Configuration MailChimp (infolettre/newsletter)</lnk>
					<lnk href="/admin/communication.aspx">Courriel automatisé (création de compte, panier abandonné...)</lnk>
					<lnk icon="/images/referral.png" href="/admin/Referral.aspx">Sondage sur les sources (comment vous nous avez connus?)</lnk>	
					<lnk href="/admin/Contest.aspx">Concours / Tirage au sort</lnk>	
				</config-section>

				<config-section id="PRO" icon="/admin/images/product.png" label="Produits" help-url="comelin/panneau-administration/configuration/produits">
					<check id="vrac" setting="ModuleBulk">Vrac / Gestion de volumes, unités et balance</check>
                    <check id="specification" setting="ModuleSpecification"  class="internal" help-url="articles/specification-dun-produit-lors-de-lachat">Module spécification d'un produit lors de l'achat</check>
                    <check id="reapprovisionnement" setting="ProductNoReOrderByDefault">Les produits ne sont PAS réapprovisionnés chez le fournisseur par défaut (ex: vêtements).</check>
					<visible-if visible="ModuleBulk">
						<check id="vracmanual" visible setting="ModuleBulkManual" class="internal indent">Association manuel des relations de produits</check>
					</visible-if>
                    <check id="code-produit" setting="ProductCodeUsingBarCode">Utiliser le code à barres (auto-généré ou non) comme 'Code de produit' automatiquement.</check>
					<check id="code-fournisseur" setting="DisplaySupplierCode">Code de fournisseur</check>
					<visible-if visible="DisplaySupplierCode" class="indent">
						<check  id="code-fournisseur-en-ligne" setting="DisplaySupplierCodeOnline">Visible au client / en ligne</check>	
					</visible-if>
					<check id="produit-code-visible-en-ligne" setting="DisplayProductCodeOnline">Code de produit visible en ligne</check>
                    <check id="product-barcode-visible-en-ligne" setting="_DisplayProductBarcodeOnline">Code à barres visible en ligne</check>
					<check id="prix-par-magasin" setting="PricePerStore"  v-if="multistore">Prix configurable par magasin</check>
					<sub-section label="Drapeaux de notifications" icon="/admin/images/flags.png" id="drapeaux" help-url="articles/utiliser-les-drapeaux-pour-faciliter-la-gestion-d-inventaire">
						<check  id="DrapeauRouge" setting="FlagRed" icon="/admin/images/flags/flag_red.png">Ajouter automatiquement la notification du changement de prix.</check>	
						<visible-if visible="FlagRed" class="indent">
                            <check class="indent" id="DrapeauRougePrixAugmente" setting="FlagRedIncreaseOnly" >Seulement si le prix augmente.</check>	
                            <check class="indent" id="DrapeauRougeSansInventaire" setting="FlagRedWithoutInventory" >Même si le produit n'est pas en inventaire.</check>	
                        </visible-if>
						<config id="DrapeauJaune" setting="FlagYellow" label="Drapeau jaune (générique)" icon="/admin/images/flags/flag_yellow.png"></config>
						<config id="DrapeauVert" setting="FlagGreen" label="Drapeau vert (générique)" icon="/admin/images/flags/flag_green.png"></config>
						<config id="DrapeauMauve" setting="FlagPurple" label="Drapeau mauve (générique)" icon="/admin/images/flags/flag_purple.png"></config>
                        <config id="DrapeauOrange" setting="FlagOrange" label="Drapeau orange (générique)" icon="/admin/images/flags/flag_orange.png"></config>
                        <config id="DrapeauNoir" setting="FlagBlack" label="Drapeau noir (générique)" icon="/admin/images/flags/flag_black.png"></config>
                        <config id="DrapeauTurquoise" setting="FlagTeal" label="Drapeau turquoise (générique)" icon="/admin/images/flags/flag_teal.png"></config>
					</sub-section>
					<sub-section icon="/admin/images/adjustement.png" label="Ajustement d'inventaire" id="ajustement" help-url="articles/cr%C3%A9ation-des-types-d-ajustements-d-inventaire">
						<config setting="InventoryAjustementCategories" multiple="true" label="Catégorie de justification (Vol / perte, démonstration, personnel, défectueux...)"></config>
					</sub-section>
					<lnk href="/admin/StickerEditor/Sticker-editor.aspx" help-url="articles/configuration-des-%C3%A9tiquettes">Configurer les étiquettes</lnk>
					
					<config-number id="avertissement-profit" suffix="%" setting="ProfitAlertPercentage">Alerte si le prix de vente donne un profit inférieur à</config-number>
					<config id="code-taxe-default" setting="TaxCodeDefault" label="Code de taxe par défaut pour les nouveaux produits" placeholder="S" maxlength="1"></config>
					
					<sub-section id="creation" label="Module de création" icon="/admin/images/creation.png">
						<check id="creation-liste" setting="_CreationHideSubItems" reverse="true">Site web: Afficher la liste de produits (si l'option n'est pas sélectionner, les composantes resteront secrètes au client.</check>
						<check id="creation-auto" setting="_CreationAutoBuild" label="Fabrication du produit automatiquement si la quantité en inventaire tombe négative et que les composantes sont disponibles."></check>
						<config-number id="creation-cout" setting="CreationCostMarkup" suffix="%">Suggestion du coût: total des matériaux multipliés par </config-number>
						<config-number id="creation-prix" setting="CreationSaleMarkup" suffix="%">Suggestion du prix: total des matériaux multipliés par </config-number>
					</sub-section>
					<check id="chiffre-vérificateur" setting="StickerWithPriceIncludeVerificationPrice" label="Scanneur: Code à barre avec prix inclue le chiffre vérificateur"></check>
                    <config-number id="prix-poids-nb-chiffres" setting="StickerWithPriceIncludedNbDigits" label="Scanneur: Code à barre avec prix nombre de chiffres"></config-number>
                    <check id="barcode-avec-prix" setting="DisableBarcorePriceWildcard" label='Scanneur: Ne pas considéré le caractère "*" pour un prix variable.'></check>
					
					<check id="regroupement-marque" setting="GroupByIncludeBrand" class="internal">Regroupement des produits inclue la marque.</check>
				</config-section>
				
                <config-section id="RAP" icon="/admin/images/reservations.png" label="Rapports">
			        <config setting="SummaryNbDaysAvailable" defaultvalue="15"  id="sommaire-vente-nb-jours" label="Sommaire des ventes: nombre de jours visible par les employés"></config>
					<check id="rapport-voir-code-barres" setting="_ReportDisplayBarcodes">Voir les codes à barres</check>
			    </config-section>
			
				<config-section id="RES" icon="/admin/images/reservations.png" label="Réservations" help-url="comelin/panneau-administration/configuration/r%C3%A9servation">
					<check id="recupmag" setting="ReservationAutoDeliveryType">Mettre automatiquement la livraison à "Récupérer en magasin" si à "Payer et emporter"</check>
					<check id="imprimer-reservation" setting="PrintReservation">Imprimer par défaut les réservations</check>
                    <check id="popup-notes" setting="ReservationPopupNotes"  defaultvalue="true">Afficher les notes à l'écran avant la facturation</check>
					<check id="web-res-employee" setting="WebOrderDoNotAssignEmployee" reverse="true">Assigner les ventes web à l'employé qui fait la facturation</check>
					<check id="res-date-planned" setting="ReservationDatePlanned" class="internal">Date planifié pour complété</check>
					<config id="res-cat" setting="ReservationCategories" multiple="true" title="Organization de vos réservations">Catégorisation des réservations</config>
					<config id="res-loc" setting="ReservationEmplacements" multiple="true" title="Liste des endroits que vous mettez vos colis (pour les trouver plus rapidement lorsque le client vient le chercher)">Localisation des réservations</config>
					<check id="res-nip" setting="ReservationGenerateNip">Generation automatique d'un NIP de récupération si récupérer en magasin.</check>
                    <visible-if visible="ReservationGenerateNip">
                        <check id="res-nip-at-creation" class="indent"  setting="ReservationGenerateNipAtCreation">NIP généré à la création de la réservation.</check>
					    <check id="res-nip4" class="indent"  setting="ReservationGenerateNip4Digits">NIP avec 4 chiffres.</check>
                        <check id="res-nipchange" class="indent"  setting="ReservationNipCanBeChanged">NIP peuvent-être modifiés/assignés.</check>
                    </visible-if>
					<config id="res-email-css" setting="_ReservationShippingEmailCC" title="Un courriel sera envoyé lorsqu'une commande web est complété avec l'option de livraison (locale ou poste)">Courriel de notification si la commande est avec livraison</config>
					<sub-section label="Dépôt de sécurité" icon="/admin/images/securitydeposit.png" class="indent" id="depot">
						<p>Le dépôt de sécurité demandé est toujours arrondi au 5$ près.</p>
						<check id="depot-securite-obligatoire" setting="SecurityDepositAskAlways">Toujours demander un dépôt de sécurité</check>	
						<config-number setting="SecurityDepositIfInStock" suffix="%">Article est en inventaire</config-number>
						<config-number setting="SecurityDepositIfNotInStock" suffix="%">Article n'est pas en inventaire</config-number>
					</sub-section>
					<sub-section label="Rendez-vous"  id="rendezvous" class="indent internal" fontawesome="calendar">
						<check id="rendez-vous" setting="Appointement" label="Module de rendez-vous (réservation avec date/heure)" ></check>
						<visible-if visible="Appointement" class="indent"  complete-hide="true"  >
							<check id="rendez-vous-period" setting="AppointementPeriodOfTheDay" label="Période de temps seulement (matin, midi, pm)"></check>	
							<config-number id="alerte-incomplete" setting="AppointementAlertIncompleteNbHours" suffix="hrs">Alerte lorsque la commande est incomplète avant la date</config-number>
							<config-number id="alerte-complete" setting="AppointementAlertCompleteNbHours" suffix="hrs">Alerte lorsque la commande est complete après la date</config-number>
						</visible-if>
					</sub-section>
					
				</config-section>

				<config-section id="SEC" fontawesome="lock" label="Sécurité">
					<check id="auth-manuel" setting="_AuthorizedInstallation">Autoriser manuellement les ordinateurs qui ont accès</check>
					<visible-if visible="_AuthorizedInstallation"  complete-hide="true" ><lnk  href="/admin/Security.aspx">Liste des ordinateurs qui ont accès</lnk></visible-if>
					<div class="internal">
						<config id="guid" setting="Authentication" label="GUID d'identification" class="wide"></config>
						<config-number id="port" setting="NotificationPort" label="Port de communication"></config-number>
					</div>
				</config-section>

				<config-section id="WEB" icon="/admin/images/website.png" label="Site web" help-url="comelin/panneau-administration/configuration/site-web">
                    <config setting="WebSite" class="internal">Url base (exemple.comelin.com)</config>
                    <check class="internal" setting="DisableWebSite" reverse="true">Site web / Boutique en ligne</check>
                    <config setting="UrlCanonical" class="internal indent">Url canonique (exemple.com)</config>
                    <visible-if visible="UrlCanonical"><check setting="_UrlRedirect" class="internal indent">Redirection automatique au Url canonique</check></visible-if>
                    <check id="temp-page-active" setting="_TmpPage">Page d'accueil temporaire / sans boutique en ligne</check>
                    <visible-if visible="_TmpPage">
                        <lnk href="/admin/config/Text.aspx#" class="indent">Configuration des textes sur la page temporaire</lnk>
					</visible-if>
                    <visible-if visible="_TmpPage" reverse="true"><visible-if visible="DisableWebSite">
                        <config setting="_UrlExternal">Url externe au lieu de la boutique en ligne (facebook, wordpress...)</config>
                    </visible-if> </visible-if>
                    <lnk href="Favicon.aspx">Configuration du favicon</lnk>
                    <check id="img-externe" class="internal" setting="ImagesExternal" >Images hébergées sur serveur externe (images.comelin.com) <a href="/Admin/sync-images/">synchro manuelle</a></check>
					<visible-if visible="DisableWebSite" reverse="true" class="indent">
						<check setting="bilingual" >Bilingue</check>	
						<check setting="DefaultLangFr" >Français par défaut</check>
					</visible-if>
                    <check setting="_CanCreateAccount" id="creer-compte">Les clients peuvent se créer un compte en ligne</check>
					<visible-if visible="_CanCreateAccount" reverse="true" class="indent"><check setting="_CanViewSiteAnonymous" defaultvalue="true" id="voir-anonyme">Les clients anonymes peuvent naviguer la boutique en ligne</check></visible-if>
                    
                    <check setting="DisableWishList" reverse="true" id="liste-cadeau">Permettre aux clients de se faire une liste cadeaux</check>
					<check id="copie-courriel" setting="bccAdminInvoice">Recevoir un courriel lors des commandes Internet (si plusieurs courriel, séparer par virgule)</check>
					<config id="copie-courriel-specific" setting="EmailOnInternetOrder" :placeholder="settings['EmailAdmin']">Spécifier le courriel (si différent du courriel administratif)</config>
                    <config-number id="matrice-nombre" setting="_MatrixMaxElementBeforeDropDown" placeholder="10" title="Si le nombre de filtre est supérieur, un menu déroulant sera visible.">Nombre maximale de filtre visible horizontale.</config-number>
					
					<sub-section label="Facebook / Instagram" id="facebook" FontAwesome="facebook-official">
						<config-number id="facebook" prefix="https://www.facebook.com/" setting="_Facebook" label="Page Facebook"></config-number>
						<config id="facebook-messenger" label="Messagerie" multiple="true" setting="_FacebookChat" placeholder="copier le script qui commence par <!-- Load Facebook SDK " help-url="articles/int%C3%A9gration-de-la-messagerie-facebook-chat"></config>
						<config-number id="instagram" prefix="https://www.instagram.com/" setting="_Instagram" label="Page Instagram"></config-number>
						<config id="facebook-pixel" setting="_FacebookPixel" placeholder="Chiffres seulement" help="https://www.facebook.com/business/help/952192354843755?id=1205376682832142">Facebook Pixel</config>
					</sub-section>
                    <sub-section id="flux" label="Flux / Exportation automatisé">
                        <check setting="ExportAll">Facebook / Instagram / Google Commerce: Exporter TOUS les produits (si l'option n'est pas activée, vous devez les sélectionner manuellement) <help url="articles/intégration-facebook-facebook-google-commerce-et-le-panier-bleu"></help></check>
                        <div id="facebook-flux">Commerce: flux de données: <code><%=Settings.WebSite %>/flux</code> <help url="articles/intégration-facebook-facebook-google-commerce-et-le-panier-bleu"></help></div> 
                        <check id="flux-titre" setting="_FluxIncludeMatrixTitle" defaultvalue="true">
                            Le titre des produits dans le flux de données incluent les champs personnalisés comme la grandeurs, couleurs, etc.
                        </check>
                    </sub-section>
					
					<sub-section fontawesome="google" label="Google" id="google">
                    <config id="google-tags-manager" setting="_GoogleTagManager" placeholder="GTM-XXXXXXXX" pattern="GTM-\w{7,12}" validation="Doit commencer par GTM-">Google Tag Manager [Container]</config>
                    <config id="google-analytic4" setting="_GoogleAnalytic4" placeholder="G-XXXXXXXX" pattern="G-\w{9,12}" validation="Doit commencer par G-">Google Analytic 4 (GA4)</config>
					<config id="google-tags" setting="_GoogleSiteTag" placeholder="AW-XXXXXXX" pattern="AW-\d{8,12}" maxlength="15" validation="Doit commencer par AW-">Google Ads - Site Tag / Balise Google</config>
                    <config id="google-ads-conversion-id" setting="_GoogleAdsConversionId" placeholder="XXXXXXXXXXXXXX">Google Ads - Conversion Id</config>
                    <config id="google-ads-conversion-label" setting="_GoogleAdsConversionLabel" placeholder="XXXXXXXXXXX">Google Ads - Conversion label</config>
                    <config id="google-analytic" setting="_GoogleAnalytic" placeholder="UA-XXXXXXXX-X" pattern="UA-\d{5,10}-\d{1,3}" validation="Doit commencer par UA-">Google Analytic (ancien)</config>
                    </sub-section>

                    <check id="recherche-fuzzy" setting="_IsSearchFuzzyEnable" >Recherche en ligne cherche aussi les mots avec erreurs mineurs (manque une lettre par exemple). Le temps de recherche sera plus lent.</check>
					<check id="marque-premier-plan" setting="BrandLeading" class="internal">Permettre de choisir des marques de premier plan (souvent pour y faire un menu de navigation)</check>
                    <visible-if visible="BrandLeading">
                        <config-number  id="premier-plan-bonus" setting="BrandLeadingBonus" suffix="%">Bonus de placement lors des recherches</config-number>
					</visible-if>
                    <check id="note-ecran" setting="_WebDisplayScreenNote">Afficher la "note à l'écran" dans la fiche de produit.</check>
                    <check id="non-tangible-group" setting="_GroupProductNotTangible">Facturation: Regrouper les produits non tangible ensemble (ex: consigne)</check>
					<sub-section label="Matrice" id="matrice" open="true">
                        <check id="matrice-group" setting="_GroupProductOnline">Regrouper les produits qui font parti de la même matrice en un seul</check>
                        <visible-if visible="_GroupProductOnline">
                            <check id="matrice-voir-tout" setting="_WebMatrixFilterSelectAllByDefault">État initial de la matrice: voir tous les produits</check>	
                        </visible-if>
                    </sub-section>
					<sub-section label="Inventaire" id="inv" open="true">
					    <check id="qte-inv" setting="_WebDisplayInventory">Afficher les quantités en inventaire</check>
					    <check id="transfert-en-inventaire" setting="TransfertCountAsInStock">Inclure les produits en transfert comme 'en inventaire' dans le magasin de destination</check>
                        <check id="transfert-visible" setting="_TransferCountDisplay" defaultvalue="true">Afficher en ligne les quantités en transfert</check>
					    <check id="commande-en-inventaire" setting="SupplierOrderCountAsInStock">Inclure les produits en commande chez le fournisseur comme 'en inventaire'</check>
					    <check id="commande-en-inventaire-visible" setting="_SupplierOrderCountDisplay">Afficher en ligne la quantité en commande chez le fournisseur</check>
						<check id="inventaire-fichier" setting="_InventoryUploadFile" class="internal">Permettre de téléverser une fichier pour les décomptes d'inventaire.</check>
                        </sub-section>
					<sub-section label="Rupture d'inventaire" id="rup" FontAwesome="window-close">
						<div>La visibilité du produit en ligne est configurable <b>par produit</b>. Si vous voulez qu'un produit spécifique puisse être commandé en tout temps, utiliser "Commande spéciale" ou "Sans inventaire".</div>
						<check id="rupt-visible" setting="ProductDefaultHideIfOutOfStock" reverse="true">Visible en ligne même si en rupture d'inventaire (valeur défaut pour les <b>nouveaux</b> produits créés)</check>
						<check id="pre-achat" setting="ProductDefaultCanBePreOrder">Permettre l'achat des produits en commande chez le fournisseur (valeur défaut pour les <b>nouveaux</b> produits créés)</check>
						<check id="rupt-achat" setting="PreventAddToCartIfOutOfStock" reverse="true">Permettre l'achat de <b>tous</b> les produits en rupture d'inventaire. <i class="fa fa-warning" title="Déconseillé"></i></check>
					</sub-section>
					<config-list id="classement-web-defaut" setting="_ListingSortingDefault" label="Ordre d'affichage des produits - classement par défaut">
						<option>Par défaut / variable</option>
                        <option value="4">Nouveauté</option>
                        <option value="5">Marque</option>
                    </config-list>
					<sub-section id="mag" label="Sélection de magasin" v-if="multistore" FontAwesome="map-marker">
						Option qui permet au client de choisir son magasin et voir l'inventaire associé. Si l'option n'est pas activée, tous les inventaires sont visibles.<br/>
						<check id="choisir-mag" setting="_PickStoreEnable">Permettre au client de <b>choisir</b> leur magasin</check>
						<visible-if visible="_PickStoreEnable">
                            <check id="choisir-mag-visible-produit" setting="_PickStoreShowProductOtherStore">Permettre de <b>voir</b> les produits non disponible dans le magasin choisi</check>
							<check id="choisir-tous-mags" setting="_PickStoreCanViewAllStore">Permettre au client de <b>voir</b> tous les inventaires</check>
							<visible-if visible="_PickStoreCanViewAllStore">
								<check id="achat-non-dispo" setting="_PickStoreCanOrderIfNotInSelectedStore">Permettre au client d'<b>acheter</b> un produit <b>non disponible</b> dans le magasin sélectionné.</check>
							</visible-if>
						</visible-if>
					</sub-section>
					
					<sub-section id="msg-facturation" label="Message avant le paiement" FontAwesome="commenting-o">
						<div>Message visible sur la page du sommaire de panier, juste avant la facturation.</div>
                        <a href="Text.aspx#MessageCartFooterTitle">configurer titre du message</a><br/>
						<a href="Text.aspx#MessageCartFooter">configurer contenu du message</a>
					</sub-section>
					<check id="option-web" setting="CanSetReservationAsWeb">Permettre d'assigner manuellement une réservation comme 'Web'</check>
					<check id="cat-img-auto" setting="_CategoryImgAssignAuto" defaultvalue="true">Assignation automatique d'une image aux catégories <i class="fa fa-info-circle" title="Prend une photo parmi les produits de la catégorie qui sont en inventaire. Cette fonction ajoute un délai (performance)"></i></check>
					<sub-section id="mode-paiement" label="Mode de paiement" FontAwesome="credit-card">
						<check id="pas-de-paiement" setting="_DoNoRequestPayement">Ne pas demander de paiement en ligne (jamais)</check>
                        <check id="paiement-requis-recuperer" setting="_RequiredPaymentIfNotShipping">Paiement requis pour même si récupérer en magasin</check>
                        <config-number id="paiement-max" setting="_PaymentOnlineMaxTriedPerHour" suffix="/hr">Nombre maximal de tentative de paiement par heure</config-number>
						
				
						<sub-section id="Bambora" label="Bambora / FirstData" FontAwesome="credit-card" help-url="articles/configuration-de-la-passerelle-de-paiement-bambora-first-data">
							<p>Bambora est une passerelle pour le traitement des cartes de crédit</p>
							<check id="BamboraActif" setting="_FirstData.Enable">Activé</check>
							<config id="BamboraNb" setting="_FirstData.MerchantId" label="Numéro de marchand"></config>
							<config id="BamboraApiKey" setting="_FirstData.PaymentsApiKey" label="Clé api"></config>
							<check id="BamboraAddress" setting="_FirstData.ValidateAddress" label="Validation de l'adresse postale (vérifier aussi les options de sécurité dans Bambora)"></check>
                            <check id="Bambora3DSecure" setting="_FirstData.Secure3D" class="internal">3D sécure</check>
							<lnk href="https://web.na.bambora.com/admin/">Accès Bambora en ligne</lnk>
						</sub-section>
						<sub-section id="Paypal" label="PayPal / Braintree" FontAwesome="paypal" help-url="articles/int%C3%A9gration-du-compte-marchand-de-paypal">
							<p>PayPal offre des comptes Business qui offrent un <a target="_blank" href="https://developer.paypal.com/developer/applications/">API</a> pour valider les paiements. </p>
							<config id="paypal-access-token" setting="_PayPalApiPassword" label="AccessToken"></config>
						</sub-section>
                        <sub-section id="PayPalPro" label="PayPal Pro / PayFlow" FontAwesome="paypal" help-url="articles/configuration-de-paypal-pro">
                            <p>PayPal Pro est un compte commercial de PayPal (nécessite une approbation / activation)</p>
                            <check id="PayPalProEnable" setting="_PayPalProSettings.IsEnable">Activé</check>
                            <check id="PayPalProIsLive" setting="_PayPalProSettings.IsLive" reverse="true">Mode test</check>
                            <config id="PayPalProPartner" setting="_PayPalProSettings.Partner" label="Partenaire (Partner)"></config>
                            <config id="PayPalProVendor" setting="_PayPalProSettings.Vendor" label="Vendeur (Vendor)"></config>
                            <config id="PayPalProUser" setting="_PayPalProSettings.User" label="Utilisateur (User)"></config>
                            <config id="PayPalProPassword" setting="_PayPalProSettings.Password" label="Mot de passe"></config>
                            <lnk href="https://manager.paypal.com/">PayPal Manager</lnk>
                        </sub-section>
                        <sub-section id="moneris" label="Moneris (en ligne)" FontAwesome="credit-card">
						    <check id="moneris-actif" setting="_MonerisEnable">Activer</check>
						    <visible-if visible="_MonerisEnable" class="indent">
							    <check id="moneris-demo" setting="_MonerisDemoMode">Mode DEMO / Test</check>	
							    <config id="moneris-clientid" setting="_MonerisClientId">Code client (ClientID)</config>
							    <config id="moneris-apikey" setting="_MonerisApiKey">Clé d'API (API Key)</config>
						    </visible-if>
                        </sub-section>
                        <sub-section id="square" label="Square" FontAwesome="money" help-url="articles/int%C3%A9gration-au-paiement-square">
						    <check id="square-actif" setting="_SquareEnable">Activer</check>
						    <visible-if visible="_SquareEnable" class="indent">
							    <config id="moneris-apikey" setting="_SquareApiKey">Clé d'API (API Key)</config>
						    </visible-if>
                        </sub-section>
					    <sub-section id="sezzle" label="Sezzle" FontAwesome="money">
                            <check id="sezzle-actif" setting="_SezzelEnable" >Activer</check>
                            <visible-if visible="_SezzelEnable">
                                <config id="sezzle-publickey" setting="_SezzelPublicKey">Clé d'API public (Public Key)</config>
                                <config id="sezzle-privatekey" setting="_SezzelPrivateKey">Clé d'API privé (Private Key)</config>
                                <check id="sezzle-sandbox" setting="_SezzelSandBox" font-awesome="money">Mode TEST (Sandbox)</check>
                                <lnk href="https://dashboard.sezzle.com/merchant/settings/apikeys">Clé api Sezzle</lnk>
                            </visible-if>
                        </sub-section>
					</sub-section>
                    <sub-section id="recaptchat" label="ReCaptcha" help-url="articles/recaptcha">
                        <check setting="_Recaptcha.Enable">Activé</check>
						<visible-if visible="_Recaptcha.Enable">
                            <config setting="_Recaptcha.SiteKey" class="wide">Site key</config>
                            <config setting="_Recaptcha.SecretKey" class="wide">Secret key</config>
							<lnk href="https://www.google.com/recaptcha/admin/create">Créer un ReCaptcha</lnk>
                        </visible-if>
                    </sub-section>
                    <sub-section id="Probance" label="Probance" class="internal">
                        <lnk href="Probance.aspx">(module de marketing)  - Configuration</lnk>
					</sub-section>
                    <sub-section id="prog" label="Programmation" FontAwesome="terminal">
						<lnk href="/admin/config/FileEditor.aspx?type=javascript">Ajout d'un script JavaScript sur le site Web</lnk>
						<lnk href="/admin/config/FileEditor.aspx?type=css">Ajout de CSS sur le site Web</lnk>
						<lnk href="/admin/config/FileEditor.aspx?type=css&file=invoice">Ajout de CSS pour les factures par courriel</lnk>
						<config id="variable-generic-1" setting="_VariableGeneric1"><t>VariableGeneric1</t></config>
						<config id="UrlCallBackReservation" setting="_UrlCallBackReservation" help="articles/url-de-rappel-des-réservations-webhook">Url de rappel sur les réservations (Webhook / callback)</config>
					</sub-section>
					<sub-section id="diag" label="Diagnostic" FontAwesome="fire-extinguisher" class="internal">
						<sub-section id="caching-prix" label="Prix des produits">
                            <check id="caching-prix-dump" setting="CachingPriceSetting.AutoDump"> Auto dump statistique</check>
							<visible-if visible="CachingPriceSetting.AutoDump"><config-number id="caching-prix-dump-hours" setting="CachingPriceSetting.AutoDumpHours" suffix="heures"> à tous les </config-number></visible-if>
                            <config-number id="caching-prix-temps" setting="CachingPriceSetting.MinCachingDuration">Duration minimal du cache</config-number>
                        </sub-section>
						
                    </sub-section>
				</config-section>
				
				<config-section id="Transfert" icon="/admin/images/transport.png" label="Transfert entre magasin">
					<config-number id="transfert-nb-jour-retard" setting="NbDaysToConsiderTransferLate">Nombre de jours pour avertissement</config-number>
					<check id="employes-voir-autres-inventaires" setting="DisabledViewOtherInventory" reverse="true">Les employés peuvent voir les inventaires des autres magasins même s'il ne sont pas assignés.</check>
					<check id="imprimer-transfert" setting="PrintTransferReceipt">Imprimer transfert pour réception rapide</check>
					<visible-if visible="PrintTransferReceipt">
                        <check id="tranfert-reception-unique" setting="TransferReceiptSingleUse">Réception de transfert intégrale (ne pas permettre une réception en plusieurs transactions)</check>
                    </visible-if>
					<check id="transfert-sans-reception" setting="TransferNoReStock">Les transferts de marchandise ne demandent pas de réception (ajoute automatiquement dans l'autre inventaire).</check>
				</config-section>


				
				
	
			</div>
		<div v-if="nbPropertiesToSave" id="barSave">
			<div class="container">
				<div class="btn btn-primary" @click="save" id="cmdSave">
					Sauvegarder
					<span v-if="nbPropertiesToSave > 1">{{nbPropertiesToSave}} modifications</span>
					<li v-if="DEBUG" v-for="(v, k) in settingsPropertiesUpdate">{{k}} - {{v}}</li>
				</div>
			</div>
		</div>
	</div>
</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
<style>
    .container-fluid {padding: 0} 
    #cfacebook .input-group, #cinstagram .input-group {width: 66%}
    #ccode-taxe-default input {width: 50px}
    #cpoint-exchange-max .input-group {width: 150px}
    .highlight {background-color: rgb(255, 235, 59)}
    .partialHidden {opacity: 0.25}
    #index .help-page {display: none}
    #cUrlCallBackReservation {flex-direction: column}
    #cUrlCallBackReservation input {width: 100%}
</style>
        <script>
        if(performance.navigation.type == 2){
            location.reload(true); // force reload on back button
        }
			
        </script>
		<script src="https://dziadalnfpolx.cloudfront.net/blog/wp-content/uploads/2011/02/jquery-highlight1.js"></script>
<script src="/admin/js/configuration.js<%=JsVersion %>"></script>
</asp:Content>
