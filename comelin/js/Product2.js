// Product module to display a single product on the product page
// Comelin 2018-8-29 Jean-Claude Morin
function $$(element) { return document.getElementById(element); } // shortcut
function exist(variable) { return variable in window; } // more intuitive

function BindProduct(product) {
	if (!product) {
		// bind the template
		// temporary hide the buy button
		$('#cmdAddToCart, .dispo, .add-to-wishlish').hide();
		return;
	}
	// temporary code redirect
	RedirectWithScroll(product.Url);
}

function CreateCombineModule() {
	var moduleAttribs = document.getElementById('combine-choices');
	// build the attrib drop-down
	if (moduleAttribs && exist('attribs') && exist('products') && products.length >= 1) {

		for (var i = 0; i < attribs.length; i++) {
			var attrib = attribs[i];
			var div = document.createElement('div');
			div.attributes['data-attrib-id'] = attrib.Id;
			div.id = 'combine-' + attrib.Id;
			div.classList.add('attrib');
			var title = document.createElement('span');
			title.classList.add('attrib-title');
			title.innerText = attrib.Title;
			div.appendChild(title);
			moduleAttribs.appendChild(div);
			// create the drop-down
			var select = document.createElement('select');
			select.attributes['data-attrib-id'] = attrib.Id;
			if (attrib.Values.length >= 1) {
				var emptyOption = document.createElement('option');
				if (getLang() === 'fr') {
					emptyOption.text = 'Sélectionner...';
				} else {
					emptyOption.text = 'Select...';
				}
				
				select.appendChild(emptyOption); // add empty option
			}
			for (var iValue in attrib.Values) {
				var v = attrib.Values[iValue];
				var option = document.createElement('option');
				option.value = v.Id;
				option.text = v.Text;
				if (exist("product") && product.Attrib[attrib.Id] == v.Id) {
					option.selected = true;
				}
				select.appendChild(option);
			}
			div.appendChild(select);
		}

		// build the compatibility matrix
		if (attribs.length >= 2) {

			var a3 = null;
            if (attribs.length >= 3) {
				a3 = attribs[2];
            }
			var a2 = attribs[1];
			var aTop = attribs[0];

			// display a table with columns represent the first attribut and vertically all others combinaison
			var table = document.createElement('table');
			table.classList.add('matrix');
			var colgroup = document.createElement('colgroup');
			colgroup.appendChild(document.createElement('col'));
			table.appendChild(colgroup);
			var headerRow = document.createElement('tr');
			headerRow.appendChild(document.createElement('th')); // empty cell (top left)
			var a3Values;
			if (a3) {
				colgroup.appendChild(document.createElement('col'));
				headerRow.appendChild(document.createElement('th')); // another empty cell for a3
				a3Values = a3.Values;
			} else {
				a3Values = [{ Id: 0, Text: '' }]; // just to allow a for loop
			}
			for (var iValue in aTop.Values) { // header row
				var v = aTop.Values[iValue];
				var th = document.createElement('th');
				th.innerText = v.Text;
				headerRow.appendChild(th);
				var col = document.createElement('col');
				col.classList.add('a' + aTop.Id + '-' + v.Id);
				colgroup.appendChild(col);
			}
			table.appendChild(headerRow);
			for (var iA2 in a2.Values) { // create a row for each value
				var v2 = a2.Values[iA2];
				var a2NbRow = 0; // to be able to merge cell on the first columns (when 3 attrib exist)
				var a2FirstTh = null;
				for (var iA3 in a3Values) {
					var v3 = a3Values[iA3];
					var nbProduct = 0;
					var row = document.createElement('tr');
					var th = document.createElement('th');
					if (a3) {
                        th.classList.add('a' + a2.Id + '-' + v2.Id);
					} else {
						row.classList.add('a' + a2.Id + '-' + v2.Id);
					}
					th.innerText = v2.Text;
					if (!a3 || a2NbRow === 0) { // do not add sometimes because of rowspan
						row.appendChild(th);
						a2FirstTh = th;
					}

					if (a3) {
						//first = false;
						var tha3 = document.createElement('th');
						tha3.innerText = v3.Text;
						row.classList.add('a' + a3.Id + '-' + v3.Id);
						row.appendChild(tha3);
					}

					for (var iTop in aTop.Values) {
						var vTop = aTop.Values[iTop];
						var td = document.createElement('td');
						for (var iProduct = 0; iProduct < products.length; iProduct++) {
							var p = products[iProduct];
							if (p.Attrib[aTop.Id] == vTop.Id) {
								// good, lets check columns
								if (p.Attrib[a2.Id] == v2.Id) {
									if (!a3 || (a3 && p.Attrib[a3.Id] == v3.Id)) {
										td.attributes['data-i-product'] = iProduct;
										td.addEventListener("click", function () { BindProduct(products[this.attributes['data-i-product']]); });
										if (p.InStock) {
											td.classList.add('stock-available');
											td.innerHTML = "<span class='inv'>" + p.InStock + "</span>";
										} else {
											td.classList.add('stock-delay');
										}

										nbProduct++;
									}
								}
							}
						}
						row.appendChild(td);
					}
					if (nbProduct > 0) {
						table.appendChild(row); // add only if there is product
						a2NbRow++;
					}

				}
				// set the rowspan
				a2FirstTh.rowSpan = a2NbRow;
			}
			moduleAttribs.appendChild(table);
		}
	}

	var dropdowns = $('#combine-choices select');
	for (i = 0; i < dropdowns.length; i++) {
		var d = dropdowns[i];
		if (d.options.length == 1) {
			// single option, convert to label
			$(d).replaceWith('<span class=sp>: </span>' + d.options[0].text);
		}
	}

	$('#combine-choices select').change(function (e) {
		FindMatchingProduct();
	});
}

// find the corresponding products that match all selected attributed
function FindMatchingProduct() {
	// remove previous selected columns
	$('.selected').removeClass('selected');
	var selectedAttrib = [];
	var ctrls = document.querySelectorAll('#combine-choices select');
	var allValueSelected = true;


	for (var i = 0; i < ctrls.length; i++) {
		var ctrl = ctrls[i];
		var selectedOption = ctrl.options[ctrl.selectedIndex];
		var attribId = ctrl.attributes['data-attrib-id'];
		var attribValue = selectedOption.value;
		if (attribValue) { // a value is selected
			selectedAttrib[attribId] = attribValue;
			$('.a' + attribId + '-' + attribValue).addClass('selected');
		} else {
			allValueSelected = false;
		}
	};

	if (allValueSelected) {
		// loop products
		for (var iProduct = 0; iProduct < products.length; iProduct++) {
			var p = products[iProduct];
			var perfectMatch = true;
			for (var idAttrib in selectedAttrib) {
				var attribValue = selectedAttrib[idAttrib];
				if (p.Attrib[idAttrib] != attribValue) {
					perfectMatch = false;
					break;
				}
			}

			if (perfectMatch) {
				BindProduct(p);
				// set the url to fake a navigation and update the url
				//history.pushState(null, newProduct.Title, newProduct.Url);
				return; // stop searching
			}
		}
	}

	BindProduct(null); // do not select any product as some attributes were not selected
}

$(function () {
	CreateCombineModule();
	CollapseLongText();
});

function CollapseLongText() {
	$('.limited-height').each(function () {
		var t = this.innerText;
		console.log(t.length);
		var maxLength = this.dataset['maxLength'];
		if (!maxLength) {
			maxLength = 300;
		}
		if (t.length > maxLength) {
			// cut
			var separator = t.indexOf('.', maxLength) + 1;
			this.innerText = t.substr(0, separator);

			var viewMore = document.createElement('span');
			viewMore.innerText = t.substr(separator);
			viewMore.classList.add('extra-text');
			this.appendChild(viewMore);

			var btnViewMore = document.createElement('a');
			btnViewMore.classList.add('show-extra-text');
			btnViewMore.href = '#';
			btnViewMore.innerText = "Lire la suite...";
			btnViewMore.onclick = function () {
				this.parentNode.classList.remove('limited-height');
				this.parentNode.removeChild(this); // self remove
				return false;
			};
			this.appendChild(btnViewMore);
		}

	});
}

const elementIdVideo = 'videos';
if (exist('_videos') && $$(elementIdVideo)) {
	function setVideo() {$$(elementIdVideo).innerHTML = _videos;}setTimeout(setVideo, 1900);
}
