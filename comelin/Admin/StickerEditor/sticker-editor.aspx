<%@ Page Title="Éditeur d'étiquette" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.StickerEditor.StickerEditorPage" CodeBehind="sticker-editor.aspx.cs"   %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">

	<div id="app-sticker" v-cloak>
	<div style="float: right"><help url="fr-ca/kb/articles/configuration-des-étiquettes"></help></div>
		<div class="row" >
			<div id="elements-list" class="col col-3"  >
				<div class="btn btn-secondary" title="Autres étiquettes" @click="stickersOpen = !stickersOpen">
					<i class="fa fa-bars" > </i>
				</div>
					
				<div class="btn btn-primary" @click="addElement" id="add-element">
					<span>Ajouter un éléments</span>
					<i class="fa fa-plus"></i>
				</div>
				<template v-if="sticker && sticker.Id">
					<div class="btn btn-secondary" @click="setDefaultSticker" id="cmdStickerDefault" v-if="sticker.Id !== IdStickerDefault" title="Mettre l'étiquette par défaut">
						<span>Mettre par défaut</span>
						<i class="fa fa-star-o"></i>
					</div>
					<div v-else class="badge badge-light" id="lblDefaultSticker">
						<i class="fa fa-star-o "></i>Étiquette par défaut
					</div>	
				</template>
					
				<div v-if="stickersOpen" id="sticker-list">
					<a href="?">Nouvelle étiquette</a>
					<div v-for="s in stickers"><a :href="'?id=' + s.Id" >{{s.Name}}
						<i class="fa fa-star-o" v-if="s.Id == IdStickerDefault"></i></a>
						<i class="fa fa-files-o duplicate" title="Dupliquer l'étiquette" @click="duplicate(s)"></i>
						<i class="fa fa-times delete" title="Effacé l'étiquette" @click="deleteSticker(s)"></i>
					</div>
						
				</div>
				<template v-if="sticker" >
					<div v-for="e in sticker.Elements" class="element" @click="editElement = e" :style="{backgroundColor:getColor(e),borderColor: darker(getColor(e))}">
						<span class="elementId">#{{getElementId(e)}}</span>
						<div>
							<i class="fa fa-times" @click.stop="deleteElement(e)"></i>
							<div>{{elementType[e.Type].Description}}</div>
							<span v-html="elementSummary(e)"></span>	
						</div>
						
					</div>	
				</template>
				
			</div>
			<div class="col col-9" v-if="sticker" >
				<div class="row"  id="sticker-header" >
					<div class="col col-12 col-lg-6">
						Nom de l'étiquette: <input v-model="sticker.Name" @change="setTitle($event.target.value)"/>
					</div>
					<div class="col col-12 col-lg-6">
						Unité de mesure: <select v-model="displayUnit">
						<option value="px">Pixel</option>
						<option value="mm">Millimètre (mm)</option>
						<option value="cm">Centimètre (cm)</option>
						<option value="po">Pouces (po)</option>
					</select>
					</div>
				</div>
				<div id="editSticker">
					<div class="form-inline">
						<span class="row-head">Taille de l'étiquette</span>
						<input-length v-model="sticker.Bound.Width">Largeur:</input-length>
						<input-length v-model="sticker.Bound.Height">Hauteur:</input-length>
						<input type="checkbox" v-model="sticker.Landscape" id="chkLandspace"/><label for="chkLandspace">Paysage</label>
						
						
					</div>
					<div class="form-inline">
                        <input type="checkbox" v-model="sticker.RepeatHorizontal" id="chkRepeatHorizontal" /> <label for="chkRepeatHorizontal">Étiquette double horizontal</label> 
                        <div v-if="sticker.RepeatHorizontal" class="indent"><input-length v-model="sticker.RepeatHorizontalMargin">espace horizontale entre les étiquettes:</input-length></div><br/>
                    </div>
                    <div class="form-inline">
                        <input type="checkbox" v-model="sticker.RepeatVertical" id="chkRepeatVertical" /> <label for="chkRepeatVertical">Étiquette double Vertical</label> 
                        <div v-if="sticker.RepeatVertical" class="indent"><input-length v-model="sticker.RepeatVerticalMargin">espace verticale entre les étiquettes:</input-length></div>
                    </div>
				</div>
				<div id="editElement" v-if="editElement != null" :style="{backgroundColor:getColor(editElement),borderColor: darker(getColor(editElement))}" class="row">
					<div class="col-12 col-lg-8">
						<span class="elementId">#{{getElementId(editElement)}}</span>
						<div class="form-inline">
							<span class="row-head">Type d'élément</span>
							<select v-model="editElement.Type">
								<option v-for="e in elementType" :value="e.Code">{{e.Description}}</option>
							</select>
						</div>
						<div class="form-inline" v-if="editElement.Type == elementType.FreeText.Code">
							<span class="row-head">Texte</span>
							<input v-model="editElement.Content" class="form-control"/>
						</div>
						<div class="form-inline" v-if="editElement.Type == elementType.Barcode.Code">
							<span class="row-head">Option</span>
							<input :checked="!editElement.HideNumber" @click="editElement.HideNumber = !editElement.HideNumber" type="checkbox" class="form-control" id="chkBarcodeDisplayCode"/><label for="chkBarcodeDisplayCode">Afficher le numéro</label>
						</div>
						<div class="form-inline" v-if="editElement.Type == elementType.Attrib.Code">
							<span class="row-head">Champs personnalisé</span>
							<select v-model="editElement.IdAttrib" id="lstAttribs">
								<option v-for="a in attribs" :value="a.Id">{{a.NameFr}} {{a.InternalNote}}</option>
							</select>
						</div>
						<div class="form-inline" v-if="editElement.Type == elementType.Image.Code">
							<span class="row-head">Fichier</span>
							<input type="file" accept="image/*"/><div class="btn btn-secondary" @click="uploadImage">Téléversement</div>
						</div>
						<div class="form-inline" v-if="editElement.Type == elementType.Price.Code" id="divPriceType">
							<span class="row-head">Type de prix</span>
							<template v-if="editElement.PricePerUnit > 0" >
							par 
							<input v-model="editElement.PricePerUnitQty" type="number" class="form-control" />	
							</template>
							
							<select v-model="editElement.PricePerUnit" class="form-control" id="lstBulkUnit">
								<option v-for="b in bulkUnits" :value="b.Id">{{b.Name}}</option>
							</select>
							
							<input type="checkbox" v-model="editElement.PricePerUnitDisplay" id="chkPricePerUnitDisplay" /><label for="chkPricePerUnitDisplay">Afficher l'unité</label>
						</div>
                        <div class="form-inline" v-if="editElement.Type == elementType.Price.Code" id="divPriceDisplayRebate">
                            <span class="row-head">Rabais / promotion</span>
                            <input type="checkbox" v-model="editElement.DisplayRebate" id="chkDisplayPriceRebate" /><label for="chkDisplayPriceRebate">Afficher le prix rabais si présent.</label>
                        </div>
                        <div class="form-inline" v-if="editElement.Type == elementType.Price.Code" id="divPriceForGroup">
                            <span class="row-head">Prix pour un groupe de client</span>
                            <select v-model="editElement.PriceGroup" id="lstGroup">
								<option value="0"></option>
                                <option v-for="g in groups" :value="g.Id">{{g.Name}}</option>
                            </select>
                        </div>
						<template  v-if="canEditStyle(editElement)">
                            <div class="form-inline">
                                <span class="row-head">Taille</span> 
                                <span class="input-group">
                                    <input v-model="editElement.FontSize" id="txtFontSize" class="form-control" style="width: 80px" />
                                    <span class="input-group-append"><span class="input-group-text">pt</span></span>
                                </span>
                            </div>	
                            <div class="form-inline">
                                <span class="row-head"></span> 
                                <input id="chkFontAutoSize" type="checkbox" v-model="editElement.FontSizeAuto"/><label for="chkFontAutoSize">Taille réduite automatiquement</label>
                            </div>
						    <div class="form-inline">
							    <span class="row-head">Style</span>
							    
							    <input id="chkbold" type="checkbox" v-model="editElement.Bold"/><label for="chkbold">Gras</label>
							    
							    <div class="btn-group" role="group" id="groupAlign" v-if="editElement.Type !== elementType.Barcode.Code">
								    <button type="button" class="btn" :class="{'btn-secondary':editElement.Align === 'Left'}" @click="editElement.Align = 'Left'"><i class="fa fa-align-left"></i></button>
								    <button type="button" class="btn" :class="{'btn-secondary':editElement.Align === 'Center'}" @click="editElement.Align = 'Center'"><i class="fa fa-align-center"></i></button>
								    <button type="button" class="btn" :class="{'btn-secondary':editElement.Align === 'Right'}" @click="editElement.Align = 'Right'"><i class="fa fa-align-right"></i></button>
							    </div>
							</div>
						    <div class="form-inline">
							    <span class="row-head">Police</span> 
							    <select id="lstFont" v-model="editElement.Font">
								    <option></option>
                                    <option v-for="f in fonts">{{f}}</option>
                                </select>
                                <div v-if="!isExtraFontsLoaded" class="btn btn-secondary" @click="loadAllFonts" title="Ajouter tous les polices de caractères installé sur le poste de travail">+</div>
						    </div>
                        </template>
						<div class="form-inline">
							<span class="row-head">Position (Coordonnée)</span>
							<div class="form-inline">
							(<input-length v-model="editElement.Bound.X" placeholder="X"></input-length>,<input-length v-model="editElement.Bound.Y"  placeholder="Y"></input-length>)
                            </div>

						</div>
                        <div class="form-inline" v-if="getElementsVariableLength(editElement).length > 0" id="positionYBasedOnAnother">
							<span class="row-head">Mettre à la suite de</span>
							<div class="form-inline">
                                <select v-model="editElement.DisplayAfter">
                                    <option value="FreeText"></option>
                                    <option v-for="e in getElementsVariableLength(editElement)" :value="e.Type" >{{elementType[e.Type].Description}}</option>
                                </select>
                            </div>
                        </div>
						<div class="form-inline">
							<span class="row-head">Taille</span>
							<div class="form-inline">
							<input-length v-model="editElement.Bound.Width">Largeur:</input-length>
							<input-length v-if="!editElement.Bound.VariableHeight" v-model="editElement.Bound.Height">Hauteur:</input-length>
                            </div>
						</div>
                            <div class="form-inline" v-if="canElementBeVariableLength(editElement.Type)">
                                <span class="row-head">Hauteur variable</span>
                                <div class="form-inline">
                                     <input id="chkVariableHeight" type="checkbox" v-model="editElement.Bound.VariableHeight" /><label for="chkVariableHeight">Hauteur selon le texte</label>
                                </div>
                            </div>
                    </div>
					<div class="col-12 col-lg-4">
						<div class="form-inline" v-if="editElement.Type == elementType.Title.Code || editElement.Type == elementType.Description.Code">
							<span class="row-head">Options</span>
							<div id="divTitleOptions">
								<div><input type="checkbox" v-model="editElement.LangEn" class="form-control" id="chkTitleLang"/><label for="chkTitleLang">Affiche le titre anglais</label></div>
								<template v-if="editElement.Type == elementType.Title.Code">
									<div><input type="checkbox" v-model="editElement.TitleIncludeBrand" class="form-control" id="chkTitleIncludeBrand"/><label for="chkTitleIncludeBrand">Inclure la marque</label></div>
									<div><input type="checkbox" v-model="editElement.TitleIncludeAttrib" class="form-control" id="chkTitleIncludeAttrib"/><label for="chkTitleIncludeAttrib">Inclure les champs personnalisés</label></div>
									<div><input type="checkbox" v-model="editElement.TitleIncludeVolume" class="form-control" id="chkTitleIncludeVolume"/><label for="chkTitleIncludeVolume">Inclure le volume</label></div>
								</template>
							</div>
						</div>

						<div class="form-inline" id="conditions">
							<span class="row-head">Condition</span>
							<div>
								<div><input type="radio" id="radConditionAlways" value="Always" v-model="editElement.Condition" name="condition" /><label for="radConditionAlways">Toujours visible</label></div>
								<div><input type="radio" id="radConditionRebate" value="Rebate" v-model="editElement.Condition" name="condition" /><label for="radConditionRebate">Si le produit est en solde</label></div>
								<div><input type="radio" id="radConditionAttrib" value="Attrib" v-model="editElement.Condition" name="condition" /><label for="radConditionAttrib">Si un champs personnalisé est présent</label></div>
								<div v-if="editElement.Condition === 'Attrib'">
									<select v-model="editElement.ConditionIdAttrib" >
										<option v-for="a in attribs" :value="a.Id">{{a.NameFr}} {{a.InternalNote}}</option>
									</select>
									
									<select v-model="editElement.ConditionAttribValue" v-if="editElement.ConditionIdAttrib > 0 && attribsLookup[editElement.ConditionIdAttrib]">
										<option v-for="v in attribsLookup[editElement.ConditionIdAttrib].Values" :value="v.Id">{{v.TitleFr}}</option>
									</select>
								</div>
								<div><input type="radio" id="radConditionTax" value="Tax" v-model="editElement.Condition" name="condition" /><label for="radConditionTax">Si le produit a un certain code de taxe</label></div>
								<div v-if="editElement.Condition === 'Tax'">
									<select v-model="editElement.ConditionTaxCode" >
										<option v-for="t in taxes" :value="t.TaxCode">[{{t.TaxCode}}] {{t.TaxName}}</option>
									</select>
								</div>
							</div>
						</div>
							
					</div>
				</div>
				<div class=previewContainer>
					<div class="preview" >
						<div :style="getBound(sticker)">
							<div v-for="e in sticker.Elements" @click="editElement = e" class="element" :style="getStyles(e)" :class="getClasses(e)">
								<template v-if="e.Type == elementType.Title.Code">Titre du produit</template>
								<template v-if="e.Type == elementType.Category.Code">Catégorie Complète</template>
                                <template v-if="e.Type == elementType.MainCategory.Code">Catégorie Principale (département)</template>
                                <template v-if="e.Type == elementType.CategoriesSecondary.Code">Catégories Secondaires</template>
								<template v-if="e.Type == elementType.Brand.Code">Marque</template>
								<template v-if="e.Type == elementType.Supplier.Code">Fournisseur</template>
                                <template v-if="e.Type == elementType.SupplierCode.Code">Code fournisseur</template>
								<template v-if="e.Type == elementType.Price.Code">12.34$</template>
								<template v-if="e.Type == elementType.PriceDiscount.Code">6.99$</template>
								<template v-if="e.Type == elementType.Code.Code">Code</template>
								<template v-if="e.Type == elementType.Volume.Code">Volume</template>
								<template v-if="e.Type == elementType.DatePrint.Code">Date impression</template>
								<template v-if="e.Type == elementType.DateExpiration.Code">{{elementType.DateExpiration.Description}}</template>
								<template v-if="e.Type == elementType.Description.Code">Description web</template>
								<template v-if="e.Type == elementType.NoteInternal.Code">Note interne</template>
								<template v-if="e.Type == elementType.NoteScreen.Code">Note à l'écran</template>
								<template v-if="e.Type == elementType.TextField1.Code">{{elementType.TextField1.Description}}</template>
                                <template v-if="e.Type == elementType.TextField2.Code">{{elementType.TextField2.Description}}</template>
                                <template v-if="e.Type == elementType.TextField3.Code">{{elementType.TextField3.Description}}</template>
                                <template v-if="e.Type == elementType.Tax.Code">Tax</template>
								<template v-if="e.Type == elementType.QRCode.Code">CODE QR</template>


								<span v-html="elementSummary(e)"></span>
								<div class="barcode " v-if="e.Type == elementType.Barcode.Code"><i class="fa fa-barcode"></i><i class="fa fa-barcode"></i></div>
							</div>
						</div>
					</div>
				</div>
				<br/>
				<div class="btn btn-primary" @click="save" id="cmdSave">Sauvegarder / Mise à jour</div>
				<hr/>
				<h3>Prévisualisation</h3>
				<div>Code de produit: <input v-model="previewCode" /><div class="btn btn-secondary" @click="addPreviewCode" id="cmdAddPreviewCode">Ajouter</div></div>
				<div v-for="productCode in sticker.PreviewProductCodes" class="stickerCtrls">
					<div class="previewContainer">
						<div class="preview">
							<img :src="'/admin/api/sticker/render?idSticker=' + sticker.Id + '&productcode=' + productCode+ '&version=' + imageVersion"/>
						</div>
					</div>
					<i class="fa fa-print" v-if="printerName" @click="print(productCode)" :title="'Imprimer avec ' + printerName"></i>
					<i class="fa fa-times" @click="removePreviewCode(productCode)"></i>
				</div>
			</div>

		</div>

	</div>
	
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
    <%= StickerEditorJs %>
</asp:Content>