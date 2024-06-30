<%@ Page Title="Configuration Internet" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SettingsWeb.aspx.cs" Inherits="WebSite.Admin.SettingsWeb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
<div class="row" id="setting-comelin">
	<!-- code inspired from https://www.codeply.com/go/7XYosZ7VH5 -->
	<div id="sidebar-container" class="sidebar-expanded d-none d-lg-block">
			<div class="list-group sticky-top sticky-offset">
					 
			<a href="#siteweb">
				<img src="images/website.png" />Site web</a>
			<a href="#sectionShipping">
				<img src="images/shipping.png" />Livraison</a>
			<a href="#sectionPayment">
				<i class="fa fa-credit-card" aria-hidden="true" style="color:rgb(95, 122, 255)"></i>Paiement</a>
                <a href="#sectionProducts">
				<img src="images/product.png" />Produit</a>
				</div>
	</div>
	<div class="col">
		<h1><img src="images/settingsweb.png" />Configuration Web</h1>
		
		<div id="sectionPayment" class="form-horizontal">
			<h2>Paiements</h2>
			<div>
				<label>Mode de paiement acceptées</label>
				<div class="">
					<asp:CheckBox runat="server" ID="chkPaiementAmex" Text="American Express" /><br/>
					<asp:CheckBox runat="server" ID="chkPaiementNet30Days" Text="Net 30 jours" />
				</div>
			</div>
			<div>
				<label for="">
					<img src="images/interact.svg" style="height: 45px" /></label>
				<div>
					<asp:TextBox ID="txtInteractEmail" AutoCompleteType="Email" runat="server" Width="400px"></asp:TextBox><br />
					Adresse courriel que les paiements seront envoyés.
				</div>
			</div>
			<div style="display: none">
				<label for="">Signature</label>
				<div>
					<asp:TextBox ID="txtPayPalApiSignature" runat="server" Width="100%" Style="max-width: 400px"></asp:TextBox>
				</div>
			</div>
		</div>
        <div id="" class="form-horizontal">
			<h2 id="sectionProducts">
				<img src="images/product.png" />Gestion des Produits</h2>
				<div>
				<label for="">Nouveauté</label>
				<div>
					<div>Les nouveautés s'enlèvent après <asp:TextBox runat="server" ID="txtNewNbWeeks" Width="60px" />semaines.</div>
					<div>Afficher un maximum de <asp:TextBox runat="server" ID="txtNewProductCountMaxListing" Width="60px" />produits (laissez vide pour tous les afficher).</div>
				</div>
			</div>
            <div>
				<label>Champs personnalisé</label>
				<div class="checkbox">
					<asp:CheckBox ID="chkProductMatrixIncludeMultipleDimensionChange" ClientIDMode="Static" runat="server" Text="Afficher tous les choix même si l'option modifie un autre champs personnalisés." />
					<br />
					Ex: Si un produit est disponible en bleu et rouge mais que le produit rouge est seulement en petit format. Si le client regarde un moyen bleu et choisi option rouge, le grandeur sera changé pour petit.
				</div>
			</div>
			<div>
				<label for="">Suggestions</label>
				<div>
					<asp:TextBox ID="txtProductNbSuggestions" runat="server" Width="60px"></asp:TextBox>
					produits en suggestion afficher par page de produits.
				</div>
			</div>
			<div>
				<label for="">Code de produit</label>
				<div class="checkbox">
					<asp:CheckBox ID="chkDisplayProductCodeOnline" runat="server" Text="Visible sur la page de produit" />
				</div>
			</div>
			<div>
				<label for="">Code de fournisseur</label>
				<div class="checkbox">
					<asp:CheckBox ID="chkDisplaySupplierCodeOnline" runat="server" Text="Visible sur la page de produit" />
				</div>
			</div>
			<div class="multi-store">
				<label for="">Inventaire disponible</label>
				<div class="checkbox">
					<asp:CheckBox ID="chkDisplayProductOnlineInventoryIsAllStores" runat="server"
						Text="Inventaire affiche &quot;en ligne&quot; est la somme de tous les magasins" />
				</div>
			</div>
			<div>
				<label for="">Taille image principale</label>
				<div>
					<asp:TextBox ID="txtProductPrimaryImageSize" runat="server" Width="60px" AutoCompleteType="None" autocomplete="off"></asp:TextBox>
				</div>
			</div>

			<div>
				<label>Titre des produits (affichage web seulement)</label>
				<div class="checkbox">
					<asp:DropDownList runat="server" ID="lstProductTitleWeb">
						<asp:ListItem Value="1">Titre</asp:ListItem>
						<asp:ListItem Value="2">[Code] Titre</asp:ListItem>
						<asp:ListItem Value="3">Titre [Code] </asp:ListItem>
						<asp:ListItem Value="4">Marque - Titre</asp:ListItem>
						<asp:ListItem Value="5">[Code] Marque - Titre</asp:ListItem>
						<asp:ListItem Value="6">Marque - Titre [Code]</asp:ListItem>
						<asp:ListItem Value="7">[Code]</asp:ListItem>
						<asp:ListItem Value="8">Brand Id</asp:ListItem>
					</asp:DropDownList>

				</div>
			</div>

			<div>
				<label>Affiché dans une colonne à part / Classement par default</label>
				<div class="checkbox">
					<asp:DropDownList runat="server" ID="lstSortingDefaultAttrib" />
					<asp:DropDownList runat="server" ID="lstSortingDefaultAttrib2" />
					<asp:DropDownList runat="server" ID="lstSortingDefaultAttrib3" />
				</div>
			</div>

			<div>
				<label for="">Nombre de produits par page</label>
				<div>
					<asp:TextBox runat="server" ID="txtNumberOfProductPerPage" Width="76px"></asp:TextBox>&nbsp;Nombre de produits visible par page avec de faire une navigation de plusieurs pages.<br />
				</div>
			</div>
			<div>
				<label for="">Champs personnalisés</label>
				<div>
					<asp:TextBox runat="server" ID="txtAttributValueVisibleMax" Width="76px"></asp:TextBox>&nbsp;Nombre de maximum de champs personnalisés en filtre.<br />
				</div>
			</div>
			<div>
				<label for="">Copie d'un produit:</label>
				<div>
					<asp:CheckBox ID="chkCopyPictureOnCreateProduct" runat="server" Text="Lorsque le produit est dupliqué, dupliquer la photo principale aussi." />
				</div>
			</div>
		</div>
			<asp:Button runat="server" Text="Sauvegarder" CssClass="btn-primary" OnClick="Save_Click" />
		
	</div>
	</div>
	<script>
		$('.form-horizontal > div').addClass('form-group row');
		$('.form-group input[type=text], textarea').addClass('form-control');
		$('.form-group > *:first-child').addClass('col-12 col-sm-3 col-md-2');
		$('.form-group > *:nth-child(2)').addClass('col-12 col-sm-9 col-md-10');

		$(document).ready(function () {
			$('#sidebar-container .list-group > a').addClass('bg-dark list-group-item list-group-item-action');
			$('#sidebar-container .list-group > a > div').addClass('d-flex w-100 justify-content-start align-items-center');
			$('#sidebar-container .list-group > a > div .fa').addClass('fa-fw');
			$('#sidebar-container .list-group > a > div .fa').addClass('fa-fw');
		});
	</script>
	<style>
		#tableBankInfo td {padding: 5px}
	</style>

</asp:Content>
