<%@ Page Language="C#" MasterPageFile="MP.Master" AutoEventWireup="true" Inherits="WebSite.ProductPage2" CodeBehind="Product.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
		<div class="row">
			<div class="col-sm-12 col-md-5">
				<div id="divImages">
					<div id="divPrimary">
						<img id="imgPicturePrimary" data-size="750" :src="productData.UrlImage" :alt="productData.TitleWeb"></div>
						<div  class="row" id="photos-thumb">
							<div v-for="photoUrl in productData.Photos" class="col-4">
								<img :src="photoUrl + '?size=200'" :alt="productData.TitleWeb" @click="setPrimaryImage(photoUrl)">
							</div>
						</div>
				</div>
			</div>
			<div class="col-sm-12 col-md-6 offset-md-1">
				<h1>{{ productData.TitleWeb }}</h1>
                <a v-if="productData.Brand" :href="productData.UrlBrand" class=brand>
                    {{productData.Brand}}
                </a>
				<div class="promotion-detail" v-if="productData.Promo && !productData.Promo.InStoreOnly">
					<div class="promo-title">
						{{productData.Promo.Title}}
						<time-range v-if="productData.Promo.Until" :from="productData.Promo.From" :to="productData.Promo.Until"></time-range>
					</div>
					<price v-if="productData.Promo.Price" class="future-price">{{productData.Promo.Price}}</price><div class="promo-description" v-html="productData.Promo.Description"></div>
					<div class="promo-flair">
						<div v-if="productData.Promo.InStoreOnly"  class="promo-location" ><t>PromotionInStoreOnly</t>:</div>
						<div v-if="productData.Promo.OnlineOnly" class="promo-location" ><t>PromotionOnlineOnly</t>:</div>
					</div>
				</div>

				<product-price class='prix' :product='productData'></product-price>
				<div class="price-per-volume" v-if="productData.Gr">
                    <div v-if="productData.PricePerUnit" class="price-per-unit">{{formatPrice(productData.PricePerUnit.Price)}} <span class="unit">/{{productData.PricePerUnit.Unit}}</span></div>
					<template v-else>
                        <div class="price-per-kg">{{formatPrice(getEffectivePrice() * 1000 / productData.Gr)}} /kg</div>
                        <div class="price-per-lbs">{{formatPrice(getEffectivePrice() * 453.592 / productData.Gr)}} /lbs</div>
                    </template>
                </div>
        
				<template v-if="productData.CanBeAddedToCart && !productData.IsCombine">
					<span id="divQty" v-if="productData.Code != 'CertificatCadeau'">Quantité:
					<input type="text" id="txtQty" value="1" />
					</span>
					<span id="divAmount" v-if="productData.IsRequiredAmount"><t>Amount</t>:
					<input type="text" id="txtAmount" />
					</span>
					<div id="add-to-cart" class="btn btn-primary" @click="addToCart(productData, $event)"><t>AddToCart</t></div>
					<template v-if="wishList">
                        <span v-show="!isInWishList(productData)" @click="wishListAdd(productData, $event)"><h>WishlistAdd</h></span>
                        <span v-show="isInWishList(productData)" @click="wishListRemove(productData, $event)"><h>WishlistRemove</h></span>
                    </template>
				</template>
				

				<div class="dispo" v-if="displayAvailability">
					<h3><t>ProductAvailability</t>:</h3>
					<div v-if="productData.CanBeAddedToCart">
						<div v-if="productData.DateAvailableAt" class="available-preorder">
							<t>AvailableFrom</t> {{formatDate(productData.DateAvailableAt)}}
						</div>
					</div>
					<div v-if="productData.IsEvent && productData.IsOutOfStock" id="event-out-of-stock">
						<t>EventSoldOut</t>
					</div>
					<div v-if="productData.CannotBeShipped"><t>CannotBeShipped</t></div><ul><%= Availability %></ul>
					<div v-if="productData.IsOutOfStock && !productData.Discontinued" class="out-of-stock">
						<h>OutOfStockNotificationTitle</h>
						<div v-if="!session.IsLogged && !productData.Notify"><h>OutOfStockNotificationMsg</h> 
							<input id="txtEmailNotify" type="email" v-model="cart.Email" /> </div>
						<div class="btn btn-info" v-if="productData.Notify" @click="ProductNotificationSet(false, $event)"><t>DoNotNotifyMe</t></div>
						<div class="btn btn-warning" v-else @click="ProductNotificationSet(true)"><t>NotifyMe</t></div>
					</div>
					
				</div>
				
				<div v-if="matrixFilters" id="matrix-filter">
					<div v-for="filter in matrixFilters" class="product-filter">
						<div class="matrix-filter-title" :data-filter-attribut="matrixFilters.Id">
							<span class="attrib-name">{{filter.Title}}
								<select v-if="filter.Values.length > matrixMaxElementBeforeDropDown" @change="setFilterSelected(filter, $event.target)">
									<option v-for="f in filter.Values"  :value="f.Id">{{f.Text}}</option>
								</select>
								<span v-else-if="filter.selected">: <span class="attrib-value-selected">{{filter.selected.Text}}</span></span>
							</span>							
						</div>
						<template v-if="filter.Values.length <= matrixMaxElementBeforeDropDown">
							<div v-for="f in filter.Values" @click="setFilterSelected(filter, f)" class="matrix-filter">
								<img v-if="f.UrlImage" :src="f.UrlImage" :alt="filter.Title + ': ' + f.Text" :title="filter.Title + ': ' + f.Text" :data-filter-value="f.Id" />
								<span v-else class="filter-choice" :class="{'selected': filter.selected === f, 'disabled': f.Disabled}">{{f.Text}}</span>
							</div>
							<div class="matrix-filter">
								<div v-if="filter.Values.length > 1"  @click="setFilterSelected(filter, null)" class="filter-choice choice-all"
									:class="{'selected': !filter.selected}" id="matrix-filter-view-all"> Voir tout </div>
							</div>
						</template>
					</div>
				</div>
				<div id="matrix-pictures" v-if="matrixProductsMatchingFilter && matrixProductsMatchingFilter.length > 0">
					<div class="header row">
						<div v-if="matrixDisplayImage" class="image col"></div>
						<div v-for="a in _attribDisplay" :data-attrib-header="a" class="col" style="flex-grow: 2">
							{{getMatrixAttribName(a)}}
                        </div>
						<div class="inventory col" v-if="!productData.IsNonInventory"><template v-if="showInventory">Qté </template>en inventaire</div>
						<div v-if="matrixDisplayPrice" class="matrix-price col">Prix</div>
						<div class="col col-add-cart"></div>
					</div>
					<div v-for="p in matrixProductsMatchingFilter" class="row">
						<a v-if="matrixDisplayImage" :href="p.Url" class="image col" style="flex-grow: 0.5">
							<img :src="getImageUrlWithSize(p.UrlImage,100)" :alt="getMatrixProductAttribNames(p, _attribDisplay)" :title="getMatrixProductAttribNames(p, _attribDisplay)" />
						</a>	
						<div v-for="a in _attribDisplay" class="col" style="flex-grow: 2">
							<a :href="p.Url" class="attrib-name">{{getMatrixProductAttribName(p, a)}}</a>
                            
						</div>
						<div v-if="!productData.IsNonInventory" class="inventory col" style="flex-grow: 0.5">
							<template v-if="showInventory">
								{{parseInt(p.InStock)}}
							</template>
							<template v-else>
								<i v-if="parseInt(p.InStock) > 0" class="fa fa-check-circle"></i>
								<i v-else-if="p.Soon" class="fa fa-clock-o"></i>
								<i v-else class="fa fa-times-circle"></i>
							</template>
                            <div v-if="p.CannotBeShipped" :title="getText('CannotBeShipped')">
                                <span class="fa-stack fa-lg"><i class="fa fa-truck fa-stack-1x"></i><i class="fa fa-ban fa-stack-2x text-danger"></i></span>
                            </div>
						</div> 
						<product-price v-if='matrixDisplayPrice' class='matrix-price col' :product=p></product-price>
						<div :style="{ visibility: p.CanBeAddedToCart ? 'visible' : 'hidden' }" class="btn btn-secondary col col-add-cart" @click="addToCart(p,$event)" title="Ajouter au panier"><i class="fa fa-shopping-cart"></i></div>
					</div>
				</div>
				<div id="kit" v-if="productData.SubItems">
					<h3><t>Included</t>:</h3>
					<div class="row" v-for="sub in productData.SubItems">
						<div class="col-1 kit-qty">
							{{sub.Qty}}
						</div>
						<div class="col-2 kit-img ">
							<a :href="sub.Url"><img v-if="sub.UrlImage" :src="sub.UrlImage" :alt="sub.Title" /></a>
						</div>
						<div class="col kit-title">{{sub.Title}}</div>
					</div>
				</div>
				<div id="videos"></div>
                <div style="display:none">{{matrixFilters}} <!-- iOS display issue--></div><div style="display:none">{{matrixFilters}} <!-- iOS display issue--></div>
				<div class="presale" v-if="productData.IsPreOrder"><h>PreSaleWeb</h></div>
				<%= Descriptions %>
                <div v-if="productData.TextField1" class="text-field"><span class="title"><h>TextField1</h></span>: <span v-html="newLineToBr(productData.TextField1)" class="desc"></span></div>
                <div v-if="productData.TextField2" class="text-field"><span class="title"><h>TextField2</h></span>: <span v-html="newLineToBr(productData.TextField2)" class="desc"></span></div>
                <div v-if="productData.TextField3" class="text-field"><span class="title"><h>TextField3</h></span>: <span v-html="newLineToBr(productData.TextField3)" class="desc"></span></div>
				<div v-if="productData.Code"><br /><t>GlobalProductCode</t>: {{productData.Code}}</div>
<div v-if="productData.Barcode"><br /><t>GlobalBarcode</t>: {{productData.Barcode}}</div>
				<div v-if="productData.CodeSupplier"><br />Code fournisseur: {{productData.CodeSupplier}}</div>

				<div v-if="productData.Code == 'CertificatCadeau'">
					<br/>
					<p><strong>Personnalisez votre carte cadeau</strong></p>
					<ul style="list-style: none; padding: 0px;width:600px;max-width:100%;">

						<div class="row">
							<li class="col-12 col-md-6"><input style="width: 100%;" id="carteTo" v-model="giftCardSpecificationsValue.To" type="text" name="carteTo" maxlength="100" placeholder="À" /></li>
							<li class="col-12 col-md-6"><input style="width: 100%;" id="carteFrom" v-model="giftCardSpecificationsValue.From" type="text" name="carteFrom" maxlength="100" placeholder="DE" /></li>
						</div>
						<br/>
						<div class="row">
							<li class="col-12"><textarea style="width: 100%;resize: vertical;min-height:150px;" v-model="giftCardSpecificationsValue.Msg" id="carteMsg" name="carteMsg" placeholder="MESSAGE" ></textarea></li>
						</div>
					</ul>
				</div>
				
			</div>
		</div>

	<div id="divAttribut">
		<%= RenderAttributAssigned %>
	</div>
		<!---->
	<br />
	
	<div class="row" id="rowSuggestion">
		<div class="col-12">
			<hr />
			<h3>Vous aimeriez peut-être...</h3>
		</div>
	</div>
	<div class="row large-gutter">
      <div class="col product-suggestion" v-for="s in suggestions">
        <a :href="s.Url">
        <img :src="s.UrlImage" :alt="s.Title" :title="s.Title" /></a>
        <div class="product-title">{{s.Title}}</div>
        <a v-if="s.Brand" class="product-brand" :href="s.UrlBrand">{{s.Brand}}</a>
		 <div class="product-price">
			<span v-if="s.PriceDiscount"><del class="price-original">{{formatPrice(s.Price)}}</del> 
				<span class="price-discount">{{formatPrice(s.PriceDiscount)}}</span>
			</span>
			<span v-else>{{formatPrice(s.Price)}}</span>
		</div>

      </div>
	</div>
	
	<!-- obsolete stuff -->
	<div style="display:none"><asp:Label ID="lblOutOfStock" runat="server" ClientIDMode="Static"></asp:Label></div>
	<asp:Literal runat="server" Visible="false" ID="templatePromotionLiquidation"></asp:Literal>
	<asp:Literal runat="server" Visible="false" ID="templatePromotion"></asp:Literal>
	<asp:Literal runat="server" Visible="false" ID="templatePromotionSolde"></asp:Literal>
	<asp:Literal runat="server" Visible="false" ID="templatePreOrder"></asp:Literal>
	<asp:Literal runat="server" Visible="false" ID="templatePreOrder2"></asp:Literal>
	<asp:Literal runat="server" Visible="false" ID="templateNew"></asp:Literal>
	<asp:Literal ID="templateSmallImages" runat="server"></asp:Literal>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
	<script src="\js\Product2.js"></script>
	<div id="modalImage" class="modal" onclick="this.style.display='none'">
		<div class="modal-content" >
			<span class="close" >&times;</span>
			<img id="img01">
			<div id="caption">{{ productData.TitleWeb }}</div>
		</div>
	</div>
	
	<!-- remove when flair template are removed -->
	<style>#DateAvailable {display:none}</style>
</asp:Content>
