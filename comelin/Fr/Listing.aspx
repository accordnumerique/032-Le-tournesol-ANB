<%@ Page Title="" Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" CodeBehind="Listing.aspx.cs" Inherits="WebSite.Fr.ListingPage2" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
		<div class="d-md-none" id="btn-open-filter" data-toggle="collapse" data-target=".filters" title="Filtres de recherche">
			<i class="fa fa-filter" ></i> Filtres
		</div>
		<div class="row">
		<div class="col-md-3 col-12 col-xl-2 collapse filters" id="menu-left">
			<div class="d-md-none collapse filters text-right" data-toggle="collapse" data-target=".filters">
				<i class="fa fa-times" data-toggle="collapse" data-target=".filters" title="Filtres de recherche"></i>
			</div>	
			<nav class="nav nav-pills nav-stacked">
				<h3><t>ByCategory</t></h3>
				<%= RenderMenuForSubCategory %>
				                <nav class="menu-filter">
                    <h3 class="filter-title"><t>FilterOptions</t></h3>
                    <filter-new-products></filter-new-products>
                    <filter-discount-products></filter-discount-products>
                    <filter-in-stock></filter-in-stock>
                </nav>
                <%= RenderFilterByBrand %>
				<%= RenderFilterByPrice %>
                <filter-by-attributes :filters="listing.FilterByAttribs"></filter-by-attributes>
			</nav>
		</div>
		
		<div class="col">
			
			<div class="Listing">
				
				<div style="text-align: center" v-if="listing.UrlBrandImg" >
					<img :src="listing.UrlBrandImg" :alt="listing.Title" style="max-height: 300px"/>	
				</div>
				
				<h1>
					
					{{listing.Title}}
				</h1>
			</div>
			

			<div class="row">
				<div class="col-sm-12" id="category-description">
					<%= Description %>
				</div>
			</div>

			<div v-if="promotions" class="promotions">
				<a v-for="promotion in promotions" class="row" :href="promotion.Url" style="color:black;margin-bottom: 20px;text-decoration: none">
					<div class="col" style="flex-grow: 0;" :class="{ 'col-12' : promotion.IdImage }">
						<img :src="promotion.ImageUrl"/>
					</div>
					<div class="col">
						<b>{{promotion.Title}}</b>
						<span class="badge-pill badge-info" v-if="promotion.DateUtil"><time-range :from="promotion.DateFrom" :to="promotion.DateUtil"></time-range></span>
						<span class="badge-pill badge-info" v-if="promotion.ValidOnlyOnline">Seulement en ligne</span>
						<span class="badge-pill badge-info" v-if="promotion.ValidOnlyInStore">Seulement en magasin</span>
						<br />
						<span class="promo-description" v-html="promotion.Description"></span>
					</div>
				</a>
			</div>

			<div class="row">
				<div class="col-12">
					<asp:Literal ID="subCategoryTemplate" runat="server">
					  <div class="catblockHorizontal ">
						<a href="{2}" {4}><img src="{3}"><div><span class="title">{0}</span><span class="desc">{1}</span></div></a> 
					  </div>
					</asp:Literal>
				</div>
			</div>
			<div class="row listing-produits">
				<!--using VueJs rendering of each products using this template. methods are found in comelin.js-->
				<div :id="p.Id" class="col-6 col-sm-4 col-lg-3 col-xl-2" v-for="p in listing.Products">
					<div class="single-product-flex">
						<div class="produit-image">
							<a :href="p.Url"><img class="product-image-primary" :src="getImageUrlWithSize(p.UrlImage, 300)" :alt="p.Title" /></a>
						</div>
						<div class='product-images-small'>
							<img  v-if="p.Photos.length > 1"  v-for="img in p.Photos.slice(0,5)" class='product-image-small' :alt="p.Title" :data-hi-rez="img"
									:src="getImageUrlWithSize(img, 50)" onclick="swapImageWithParent(this)"  />
						</div>
						<div v-if="p.PromoShort" class="PRebate" :title="p.PromoLong">{{p.PromoShort}}</div>
                        
						<div class="proIcon">
                            <div v-if="p.IsPreOrder" class="proNew proMsg"><t>PreOrder</t></div>
							<div v-if="p.IsNew" class="proNew proMsg"><t>NewProduct</t></div>
                            <div v-if="p.IsSpecialOrder" class="proSwap proSpecialOrder proMsg"><t>SpecialOrder</t></div>
							<div v-if="p.DateAvailableAt" class="proPreOrder proMsg">prévu le {{formatDate(p.DateAvailableAt)}}</div>
                            <div v-else-if="p.IsOutOfStock" class="proBO proMsg" ><t>OutOfStock</t></div>
						</div>
						
						<div class="titre">
							<div v-if="p.CanBeAddedToCart" class="product-add-to-cart" @click="addToCart(p, $event)"></div>	
							<a :href="p.Url">{{p.TitleNoExtra}}</a>
						</div>
						<a :href="p.UrlBrand" class="product-brand" v-if="p.Brand">{{p.Brand}}</a>
						<div class="prix" v-if="p.Price">
							<span v-if="p.PriceDiscount"><del class="price-original">{{formatPrice(p.Price)}}</del> 
								<span class="price-discount">{{formatPrice(p.PriceDiscount)}}</span>
							</span>
							<span v-else>{{formatPrice(p.Price)}}</span><span class="price-max" v-if="p.PriceMax && p.PriceMax != p.Price"> - {{formatPrice(p.PriceMax)}}</span>
						</div>
						
						<div class="promotion-detail" v-if="p.PromoShortInStore">
							<div class="promo-title">{{p.PromoShortInStore}}</div>
							<span class="promo-description">{{formatPrice(p.PriceInStore)}}</span>
							<div class="promo-flair"><div class="promo-location">En magasin seulement</div></div>
						</div>

					</div>
				</div>
			</div>
			<br />
			<div id="wrap-pagination">
				<%= RenderPagination %>
			</div>
		</div>
	</div>
	<select id="lstSorting" runat="server" ClientIDMode="Static" Visible="False" />
</asp:Content>
