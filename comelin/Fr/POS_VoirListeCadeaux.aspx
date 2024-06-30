<%@ Page Title="Liste Cadeaux" Language="C#" MasterPageFile="~/Fr/MP.Master" AutoEventWireup="true" CodeBehind="POS_VoirListeCadeaux.aspx.cs" Inherits="WebSite.Fr.POS_VoirList" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>La liste de cadeaux de <span><%=WishlishFirstName %></span></h1>
<div class="row contentListeCadeauxListing listEmpty listNotEmpty pageListeCadeauxListing">
	<div class="col-12">
		<div class="row processusContent emptyList" id="divEmptyList" runat="server"> <!--Debut Liste vide-->
		<div class="col-12">
							<p class="textEmpty">Votre liste est vide.</p>
		</div>
  </div>
					<div class="row notEmptyList"> <!--Debut Liste rempli-->

	<asp:Literal runat=server ID=templateWishList EnableViewState=false>
              <div class="col-12 listProduits {2}" id="wishlist-product-{7}">
							<div class="boxListProduits">
								<div class="row">
									<div class="col-12 col-sm-3">
										<div class="imgList text-center">
										  <a href="{5}">
											{1}
	  </a>
										</div>
									</div>
									<div class="col-12 col-sm-9">
										<h2>{3} {0}</h2>
										<div class="prix">{4}</div>
										<a href="#" onclick="WishListOperation(false, {7})" class="retireDeListe">
<span class="vcenter"><i class="fa fa-remove"></i> Retirer de ma liste de cadeaux</span></a>

										<div class="btnListe">
										  <span class="btn btn-primary buyFor" onclick="addToCart({7}, this, false, null,{9})">Acheter pour {8}</span>
										  <span class="btn btn-default addCart" onclick="addToCart({7}, this, false)">Ajouter au panier</span>
										</div>
                    <p class="alreadyBoughtProduct">Quelqu'un a été plus rapide que vous! Ce produit a déjà été acheté.</p>
									</div>
								</div>
							</div>
						</div>
	</asp:Literal>
						<div class="col-12 listCadeauxShare">
							<div class="row">
								<div class="col-6"><a href="javascript:window.print();"><span><i class="fa fa-print"></i> Imprimer la liste de cadeaux</span></a></div>
								<div class="col-6"><span>Partager ma liste de cadeaux</span><a href="mailto:?body=<%= HttpUtility.UrlEncode(Request.Url.ToString()) %>"> <i class="fa fa-envelope"></i></a>
									<a href="https://www.facebook.com/sharer/sharer.php?u=<%= HttpUtility.UrlEncode(Request.Url.ToString()) %>"> <i class="fa fa-facebook"></i></a></div>
							</div>
	</div>
					</div> <!--Fin Liste rempli-->
				</div>
			</div>
					
</asp:Content>
