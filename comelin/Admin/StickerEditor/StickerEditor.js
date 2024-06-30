// Sticker editor
// By Jean-claude Morin 2019-12-19
// Comelin

var _colors = ['#D6EBFF', '#B8FFB6', '#FFF3B6', '#FCC9C9', '#FADCF5', 'Silver', '#B6FFF6', '#7fc57a', '#FAE377', '#FF9090', '#fdd291', '#8A8A8A'];
var _displayUnitPixel = 'px';
var _displayUnitInch = 'po';
var _displayUnitMm = 'mm';
var _displayUnitCm = 'cm';

var _fontsDefault = [
    'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', 'Georgia', 'Helvetica', 'Impact', 'Lucida Console',
    'Lucida Sans Unicode', 'Oswald', 'Palatino','Segoe UI', 'Times New Roman', 'Trebuchet MS', 'Verdana'
];
var PageName = 'sticker-editor.aspx';

Vue.component('input-length', {
	props: ['value'],
	data: function () {
		return {
			displayUnit: function () {
				return this.$root.displayUnit;
			}
		}
	},
	computed: {
		valueConverted: {
			get: function () {
				if (Number.isNaN(this.value)) {
					return '';
				}
				
				return round(this.value / this.$root.unitConversionRatio, this.$root.unitConversionNbDecimal);
			},
			set: function (newValue) {
				if (Number.isNaN(newValue)) {
					return;
				}
				this.value = Math.round(newValue * this.$root.unitConversionRatio);
			}
		}
	},
	template: `<span class="form-inline input-length"><label><slot></slot></label> <span class='input-group'><input class="form-control" type="number"
			v-bind:value="valueConverted"
			v-on:input="$emit('input', $event.target.value * $root.unitConversionRatio)">
			<span class ='input-group-append'>
				<span class ='input-group-text'>{{displayUnit() }} </span>
			</span></span>
		</span>`
});


appSticker = new Vue({
    el: '#app-sticker',
    data: {
        IdStickerDefault: window._IdStickerDefault,
        elementType: {
            FreeText: { Code: 'FreeText', Description: 'Champs de texte libre' },
            Image: { Code: 'Image', Description: 'Image' },
            Title: { Code: 'Title', Description: 'Titre du produit' },
            Category: { Code: 'Category', Description: "Catégorie complète" },
            MainCategory: { Code: 'MainCategory', Description: "Catégorie principale (département)" },
            CategoriesSecondary: { Code: 'CategoriesSecondary', Description: "Catégories secondaires" },
            Description: { Code: 'Description', Description: 'Description web' },
            Volume: { Code: 'Volume', Description: 'Poids/Volume du produit' },
            Code: { Code: 'Code', Description: 'Code du produit' },
            Brand: { Code: 'Brand', Description: 'Marque du produit' },
            Price: { Code: 'Price', Description: 'Prix de vente' },
            PriceDiscount: { Code: 'PriceDiscount', Description: 'Prix rabais' },
            Barcode: { Code: 'Barcode', Description: 'Code à barres' },
            Attrib: { Code: 'Attrib', Description: 'Champs personnalisé' },
            NoteInternal: { Code: 'NoteInternal', Description: 'Note interne' },
            NoteScreen: { Code: 'NoteScreen', Description: "Note affiche à l'écran" },
            TextField1: { Code: 'TextField1', Description: _Text["TextField1"] },
            TextField2: { Code: 'TextField2', Description: _Text["TextField2"] },
            TextField3: { Code: 'TextField3', Description: _Text["TextField3"] },
            Supplier: { Code: 'Supplier', Description: 'Fournisseur' },
            DatePrint: { Code: 'DatePrint', Description: "Date d'impression" },
            DateExpiration: { Code: 'DateExpiration', Description: "Date de péremption" },
            QRCode: { Code: 'QRCode', Description: "Code QR" },
            SupplierCode: { Code: 'SupplierCode', Description: "Code Fournisseur" },
            Tax: { Code: 'Tax', Description: "Tax" }
        },
        printerName: null,
        sticker: null,
        displayUnit: _displayUnitPixel,
        editElement: null,
        previewCode: '',
		imageVersion: 1,
        ws: null,
        stickers: window._stickers,
        stickersOpen: false,
        attribs: window._attribs,
        attribsLookup: null,
        taxes: window._taxes,
        taxesLookup: null,
        bulkUnits: window._bulkUnitInfos,
        fonts: window._fontsDefault,
        isExtraFontsLoaded: false,
		groups: _groups
	},
	computed: {
		unitConversionRatio: function() {
			if (this.displayUnit === _displayUnitPixel) {
				return 1;
			} else if (this.displayUnit === _displayUnitInch) {
				return 98;
			} else if (this.displayUnit === _displayUnitMm) {
				return 3.85826771654;
			} else if (this.displayUnit === _displayUnitCm) {
				return 38.5826771654;
			}
			return 1;
		},
		unitConversionNbDecimal: function () {
			if (this.displayUnit === _displayUnitInch) {
				return 2;
			} else if (this.displayUnit === _displayUnitCm) {
				return 1;
			}
			return 0;
		}
	},
	watch: {
		displayUnit: function(val) {
			this.$emit('displayUnitChanged', val);
			localStorage["StickerUnitType"] = val;
		},
        'editElement.Type': function (newValue, oldValue) {
			// check if the fonts is in the list;
            if (newValue && !this.canElementBeVariableLength(newValue)) {
				this.editElement.Bound.VariableHeight = false; 
            }
        }
	},
	methods: {
		canElementBeVariableLength: function (elementType) {
			var types = this.elementType;
			return elementType == types.TextField1.Code || elementType == types.TextField2.Code || elementType == types.TextField3.Code || elementType == types.Description.Code
		},
        getElementsVariableLength: function (currentElementEdit) {
            return this.sticker.Elements.filter(e => e.Bound.VariableHeight && e !== currentElementEdit);
        },
		duplicate : function (stickerToDuplicate) {
			if (confirm("Dupliquer l'étiquette " +stickerToDuplicate.Name + '?')) {

				stickerToDuplicate.Id = 0; // set id to 0 for re-save to new sticker
				stickerToDuplicate.Name += 'copy';
				this.sticker = stickerToDuplicate; // set as current stick
				this.save(); // will cause redirect
			}
		},
		elementSummary: function (el) { // this a summary of the element, this is visible in the left menu to pick the right element
			var summary = '';
			
			switch (el.Type) {
				case this.elementType.Title.Code:
					if (el.LangEn) {
						summary += '[EN]';
					}
					if (el.TitleIncludeBrand) {
						summary += '[Marque]';
					}
					if (el.TitleIncludeAttrib) {
						summary += '[Champs p.]';
					}
					if (el.TitleIncludeVolume) {
						summary += '[Vol]';
					}
					break;
				case this.elementType.FreeText.Code:
					summary = el.Content;
					break;
				case this.elementType.Price.Code:

					if (el.PricePerUnit > 1) {
						var unit = this.bulkUnits.find(b => b.Id === el.PricePerUnit);
						if (unit) {
							summary = "/" + el.PricePerUnitQty + unit.Name;
						}
					} else if (el.PricePerUnitDisplay) {
						summary = "avec unité";
					}
                    if (el.PriceGroup > 0) {
                        var groupName = _groups.find(g => g.Id === el.PriceGroup).Name;
                        if (groupName) {
                            summary += ' Groupe ' + groupName;
                        }
                    }
                    break;
				case this.elementType.Image.Code:
					summary = '<img src="' + el.UrlImage +'" style="width:' + el.Bound.Width + 'px; height:' + el.Bound.Height + 'px" />';
					break;
				case this.elementType.Attrib.Code:
					var attrib = this.attribsLookup[el.IdAttrib];
					if (attrib) {
						summary += ' ' + attrib.NameFr;
					}
					break;
			}
			if (el.Condition === 'Attrib') {
				var attrib = this.attribsLookup[el.ConditionIdAttrib];
				if (attrib) {
					summary += ' si ' + attrib.NameFr;
					if (attrib.Values) {
						var attribValue = attrib.Values.find(av => av.Id === el.ConditionAttribValue);
						if (attribValue) {
							summary += ' ' + attribValue.TitleFr;
						}
					}
				}
			}
			if (el.Condition === 'Tax') {
				var t = this.taxesLookup[el.ConditionTaxCode];
				if (t) {
					summary += ' si [' + t.TaxCode + ']';
				}
			}
			return summary;
		},
		getImageFolder: function(id) {
			return Math.floor(id / 1000) * 1000;
		},
		setTitle: function(stickerName) {
			document.title = "Étiquette: " + stickerName;
		},
		getElementId: function(el) {
			return this.sticker.Elements.indexOf(el);
		},
		getColor: function(el) {
			return _colors[(this.getElementId(el)) % _colors.length];
		},
		canEditStyle: function (el) {
			if (el.Type === this.elementType.Image.Code) {
				return false;
			} else if (el.Type === this.elementType.Barcode.Code) {
				return !el.HideNumber;
			} 

			return true; // all other type have style
		},
		darker: function (color) {
			if (!color) {
				return color;
			}
			return shadeColor(color, -40);
		},
		addElement: function () {
			if (!this.sticker.Elements) {
				this.sticker.Elements = [];
			}
            var newElement = {
                Type: this.elementType.FreeText.Code,
                Content: 'Texte #' + (this.sticker.Elements.length + 1),
                FontSize: 10,
                Align: 'Center',
                HideNumber: false,
                Bound: { Width: this.sticker.Bound.Width, Height: 20, X: 0, Y: 0 },
                Condition: 'Always',
                TitleIncludeBrand: true,
                TitleIncludeAttrib: true,
                TitleIncludeVolume: true,
                FontSizeAuto: true
        };
			this.sticker.Elements.push(newElement);
			this.editElement = newElement;
		},
		deleteElement: function (element) {
			if (confirm('Effacé ' + this.elementType[element.Type].Description + '?') ) {
				this.$delete(this.sticker.Elements, this.sticker.Elements.indexOf(element));
				this.editElement = null;
				return true;
			}
			return false;

		},
		getBound: function(sticker) {
			var bound = sticker.Bound;
			return {
				width: bound.Width + 'px',
				height: bound.Height + 'px',
				marginLeft: bound.X + 'px',
				marginTop: bound.Y + 'px'
			}
		},
		getStyles: function(e) {
			var bound = e.Bound;
			var s = {
				width: bound.Width + 'px',
				height: bound.Height + 'px',
				left: bound.X + 'px',
				top: bound.Y + 'px',
				fontSize: e.FontSize + 'px'
			}
			s.backgroundColor = this.getColor(e);
			s.borderColor = this.darker(this.getColor(e));

			if (e === this.editElement) {
				s.borderWidth = "0.6px";
				s.borderStyle = 'solid';
			}
			if (e.Font) {
				s.fontFamily = e.Font;
			}
			return s;
		},
		getClasses: function(element) {
			return {
				bold: element.Bold,
				selected: element === this.editElement,
				alignLeft: element.Align === 'Left',
				alignCenter: element.Align === 'Center',
				alignRight: element.Align === 'Right',
			}
		},
		uploadImage: function () {
			// https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
			var formData = new FormData();
			var fileField = document.querySelector('input[type="file"]');
			formData.append('image', fileField.files[0]);
			fetch('/admin/api/image/upload?type=Sticker', {
				method: 'POST',
				body: formData
			}).then(response => response.json())
				.then(response => {
					this.editElement.IdImage = response.IdImage;
					this.editElement.UrlImage = response.UrlImage;
					this.imageVersion++;
					appSticker.$forceUpdate(); // else the image is not refreshed
				});
		},
		save: function() {
			$('body').addClass('waiting');
			fetch('/admin/api/sticker/save?id=' + this.sticker.Id, {
				method: 'post',
				body: JSON.stringify(this.sticker)
			}).then(response => {
                    if (!response.ok) {
                        throw response.statusText;
                    }
                    return response.json();
                })
				.then(response => {
					if (!this.sticker.Id) {
						// first save, redirect to the page
						document.location = PageName + "?id=" +response.Id;
					}
					this.sticker.Id = response.Id;
					$('#cmdSave').notify('Sauvegardé!');
				}).catch((error) => {
					$('#cmdSave').notify('Erreur de sauvegarde: ' + error, 'error'); 
				}).finally(() => {
					$('body').removeClass('waiting');
				});
		},
		deleteSticker: function (s) {
			if (confirm('Effacé ' + s.Name + '?')) {
				$('body').addClass('waiting');
				fetch('/admin/api/sticker/delete?id=' + s.Id).then(response =>  response.json())
                    .then(response => {
						if (response) {
							// delete with success
							this.$delete(appSticker.stickers, appSticker.stickers.indexOf(s));
							if (s === appSticker.sticker) {
								// current one is delete, go to blanc sticker
								document.location = PageName;
							}
						}

					}).catch((error) => {
						$.notify("Erreur d'effacement" + error, 'error');
					}).finally(() => {
						$('body').removeClass('waiting');
					});
			}
		},
		addPreviewCode: function () {
			if (!this.sticker.PreviewProductCodes) {
				this.sticker.PreviewProductCodes = [];
			}
			this.sticker.PreviewProductCodes.push(this.previewCode);
			this.previewCode = ''; // clear value for future
		},
		removePreviewCode: function (code) {
			this.sticker.PreviewProductCodes.splice(this.sticker.PreviewProductCodes.indexOf(code), 1);
		},
		print: function (code) {
			this.ws.send(JSON.stringify({ ProductCode: code, IdSticker: this.sticker.Id}));
		},
		setDefaultSticker : function() {
			fetch('/admin/api/setting?key=IdStickerDefault&value=' + this.sticker.Id)
				.then(response => response.json())
				.then(response => {
					appSticker.IdStickerDefault = this.sticker.Id;
					$('#cmdStickerDefault').notify('Sauvegardé!');
				})
				.catch((error) => {
					$('#cmdStickerDefault').notify('Erreur de sauvegarde: ' + error, 'error');
				});
		},
		connectionWs: function () {
			if (!this.ws || this.ws.readyState === 3) {
				console.log('Establishing connection to Comelin');
				var webSocketUrl = 'ws://localhost:7789/sticker-print';
				this.ws = new WebSocket(webSocketUrl);
				this.ws.onmessage = function (msg) {
					var data = JSON.parse(msg.data);
					if (data.PrinterName) {
						appSticker.printerName = data.PrinterName;
					} else if (data.Error) {
						jQuery.notify(data.Text, 'error');
                    } else if (data.Type === 'FontsRequestResult') {
                        appSticker.fonts = data.Fonts;
                        appSticker.isExtraFontsLoaded = true;
                        appSticker.addFontsInUseButMissing();
                    }

				}
				this.ws.onclose = function () {
					appSticker.printerName = null;
				};
			}
		},
		getElementId: function (element) {
			return this.sticker.Elements.indexOf(element) + 1;
		},
        loadAllFonts: function () {
            this.ws.send(JSON.stringify({ GetFonts: true }));
        },
        addFontsInUseButMissing: function () {
            for (var s of this.stickers) {
                for (var e of s.Elements) {
                    if (e.Font) {
                        // check the font exist;
                        if (this.fonts.findIndex(i => i === e.Font) === -1) {
                            this.fonts.unshift(e.Font);
							console.log('Add font: ' + e.Font);
                        }
                    }
                }
            }
        }
	},
	mounted: function () {
		// get the sticker data
		var id = parseInt(new URLSearchParams(window.location.search).get('id'));
		
		if (!id) {
			// new sticker
			this.sticker = {
				Name: 'Étiquette 2" x 1"',
				Bound: { Width: 196, Height: 98, X: 0, Y: 0 },
				Elements: []
			}
		} else {
			fetch('/admin/api/sticker/get?id=' + id).then(response => response.json())
			.then(response => {
				if (response === null) {
					$.notify('Sticker not found', 'error');
				} else {
					this.sticker = response;
				}

			});
		}

		// create a attrib lookup by id
		this.attribsLookup = {};
		for (a of this.attribs) {
			this.attribsLookup[a.Id] = a;
		}
		this.taxesLookup = { };
		for (t of this.taxes) {
			this.taxesLookup[t.TaxCode]= t;
			}
		setInterval(this.connectionWs, 2000);
		var localStorageStickerUnitType = localStorage["StickerUnitType"];
		if(localStorageStickerUnitType) {
			this.displayUnit = localStorageStickerUnitType;
		}
        this.addFontsInUseButMissing();
    }
});


function shadeColor(t, n) { var r = parseInt(t.substring(1, 3), 16), g = parseInt(t.substring(3, 5), 16), i = parseInt(t.substring(5, 7), 16); return r = parseInt(r * (100 + n) / 100), g = (g = parseInt(g * (100 + n) / 100)) < 255 ? g : 255, i = (i = parseInt(i * (100 + n) / 100)) < 255 ? i : 255, "#" + (1 == (r = r < 255 ? r : 255).toString(16).length ? "0" + r.toString(16) : r.toString(16)) + (1 == g.toString(16).length ? "0" + g.toString(16) : g.toString(16)) + (1 == i.toString(16).length ? "0" + i.toString(16) : i.toString(16)) }
function round(value, decimals) {
	return Number(Math.round(value + 'e' + decimals) + 'e-' + decimals);
}

// open a websocket connection to send print command to the real printer




