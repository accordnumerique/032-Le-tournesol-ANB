<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebSite.Fournisseur.PageSupplierIntranet" %>

<%@ Register src="../Admin/ucDateRangePicker.ascx" tagname="ucDateRangePicker" tagprefix="uc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Accès Fournisseurs</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	<link href="/Admin/css/bootstrap-datepicker3.min.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/bs4/jszip-2.5.0/dt-1.10.25/b-1.7.1/b-html5-1.7.1/b-print-1.7.1/rg-1.1.3/datatables.min.css"/>

	<script src="https://code.jquery.com/jquery-2.2.3.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
	<script src="/admin/js/bootstrap-datepicker.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/v/bs4/jszip-2.5.0/dt-1.10.24/b-1.7.0/b-html5-1.7.0/b-print-1.7.0/rg-1.1.3/datatables.min.js"></script>

	<style>
		
		.not-active {filter: grayscale(90%);opacity: 0.5;-webkit-filter: grayscale(90%); }
		.img-renewal,.img-date-planned{cursor: pointer}
		.InfoSummary {background-color:lightgrey; padding: 10px; margin: 10px; display: inline-block}
		.full-width {width:100% !important}
		<%= CssRule %>
	</style>

</head>
<body style="margin:10px">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>
	    <h1>Accès Fournisseurs <t>CompanyName</t></h1>

		<div runat="server" id="divLogin">
			<div class="container" style="max-width: 500px">
					<%= UserMessage.Write() %>
				<div class="row" id="divIdentification" runat="server" Visible="False">
					<h3>Identification</h3>
					<div class="form-group">
						<label for="txtEmail">Courriel</label>
						<asp:TextBox type="email" class="form-control" ID="txtEmail" placeholder="Courriel" runat="server"  ClientIDMode="Static"></asp:TextBox><br/>
						Votre courriel doit avoir été inscrit au préalable par l'entreprise pour avoir accès à cette section réservée aux fournisseurs.
					</div>
					<asp:Button runat="server" id="cmdIdentification" CssClass="btn btn-primary" Text="Suivant" OnClick="cmdIdentification_Click" />
				</div>
				<div class="row" id="divAuthentification" runat="server" Visible="False">
					<h3>Authentification</h3>
					<div runat="server" Visible="False" id="divIdentificationFailed">Le courriel <%=Email %> n'est pas associée à aucun fournisseur. 
						<asp:Button runat="server" id="cmdTryAnotherEmail" CssClass="btn btn-primary" Text="Essayé un autre courriel" OnClick="cmdTryAnotherEmail_Click"  />
					</div> 
					<div runat="server" Visible="False" id="divIdentificationSuccess">Le courriel <%=Email %> est associé à <t>SupplierName</t><br/>
						<div class="form-group">
							<div id="divEnterPassword" runat="server">
							<label for="txtPassword">Mot de passe</label>
							<asp:TextBox type="password" class="form-control" ID="txtPassword" placeholder="Mot de passe" runat="server" ClientIDMode="Static"></asp:TextBox>
								<asp:Button runat="server" id="cmdConnect" CssClass="btn btn-primary" Text="Connexion" OnClick="cmdConnect_Click"   />
							<br />
								</div>
							<div id="divInfoRequestPassword" runat="server">
							 	<div  id="lblIfPasswordLost" runat="server">Si vous n'avez pas de mot de passe ou oublié un accès vous sera envoyé par courriel: </div>
								<asp:Button runat="server" id="cmdSendPassword" CssClass="btn btn-primary" Text="Assigner un mot de passe par courriel" OnClick="cmdSendPassword_Click"   />
								
                                &nbsp;
								
                                <asp:Button runat="server" id="cmdChangeEmail" CssClass="btn btn-primary" Text="Utiliser un autre courriel" OnClick="cmdChangeEmail_Click"    />
							</div>
						</div>
					</div> 
				</div>
			</div>
		</div>
		<div id="divReport" runat="server" Visible="False">
			<div style="float:right"><asp:Button ID="cmdLogOut" runat="server" Text="Deconnexion" CssClass="btn btn-default" OnClick="cmdLogOut_Click" /></div>
			
			<asp:DropDownList ID="lstStore" EnableViewState="False" runat="server" ClientIDMode="Static" />
			<uc1:ucDateRangePicker ID="ucDateRangePicker1" runat="server"  />
			
			<h1>Inventaire et ventes</h1>
			
			<div class="InfoSummary">
				<h4>Vente</h4>
				Nombre vendu: <%= NbSales %><br/>
				Total coût: <%= TotalCost.ToString("c") %><br/>
				Total prix de vente: <%= TotalSales.ToString("c") %><br/>
			</div>
			<div class="InfoSummary">
				<h4>Inventaire</h4>
				Nombre d'article: <%= InvNbItemsStr  %><br/>
				Total coût: <%= InvTotalCost.ToString("c") %><br/>
				Total prix de vente: <%= InvTotalSales.ToString("c") %><br/>
			</div>
			<table class="sssGrid full-width">
				<thead>
					<tr><td></td><td>Code <t>Supplier</t></td><td>Code</td><td>Produit</td><td>Qté inv</td><td>Qté réservé</td><td><t>Cost</t>></td>
						<td><t>CartPrice</t></td><td>Qté vendu</td><td>Qté commandé</td><td>Total</td></tr>
				</thead>
				<tbody>
					<%= DataTableInvAndSales %>
				</tbody>
				<tfoot>
				<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
						<td></td><td></td><td></td><td></td></tr>
				</tfoot>
			</table>
		</div>
		<div  id="dialog-calendar" class="modal fade" tabindex="-1" role="dialog">
		  <div class="modal-dialog" role="document">
			<div class="modal-content">
			  <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">Date prévue de réception en magasin</h4>
			  </div>
			  <div class="modal-body">
				<p><input id="date-planned-selector" ></p>
			  </div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-default" id="cmdDateRemove">Enlever la date</button>
				<button type="button" class="btn btn-primary" id="cmdDateSet">Assigner la date</button>
			  </div>
			</div><!-- /.modal-content -->
		  </div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
    </form>

<script>
 // copy from comelin.js
 // text replacement
 function $$(element) { return document.getElementById(element); } // shortcut
function exist(variable) {return variable in window;} // more intuitive

if (exist('_Text')) {
	for(e of document.querySelectorAll('t')) {
		var code = e.innerText;
		var value = _Text[code];
		if (value != undefined) {
			var span = document.createElement('span');
			span.innerText = value;
			e.outerHTML = span.outerHTML;
		}
	}

	for(e of document.querySelectorAll('h')) {
		var code = e.innerText;
		var value = _Text[code];
		if (value != undefined) {
			var span = document.createElement('span');
			span.innerHTML = value;
			e.outerHTML = span.outerHTML;
		}
	}
}

function DataTableSumColumn(api, columnNumber, formatting, valueFunction) {
    var c = api.column(columnNumber);
    var total = c.data().reduce(function(a, b) {
        var vA = a;
        var vB = b;
        if (valueFunction) {
            vB = valueFunction(vB);
        }
        if (vB) {
            return vA + vB;
        }
        return vA;
    }, 0);
    $(c.footer()).html(formatting(total));
}

// format a number for a quantity with up to 3 digits visible
function NumberToQuantity(number, type) {
	if (!type || type === 'display' || type === 'smart') {
		if (!number) {
            if (type === 'smart') {
                return null;
            }
			return 0;
		}
		return number.toLocaleString(defaultCulture, { minimumFractionDigits: 0, maximumFractionDigits: 3 });
	}
    return number; // use raw number for sorting
}

// Datatable formatting of a number
// number: the number ot be displayed
// type: the context used, can be display, filter or "_" for fallback
function NumberToAmount(number, type) {
    if (!type || type === 'display' || type === 'smart') {
        if (!number) {
            if (type === 'smart') {
                return null;
            }
            number = 0;
        }
        var extra = '';
        if (type === 'display' || type === 'smart') {
            extra = ' $';
        }
        return number.toLocaleString(defaultCulture, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + extra;
    }
	return number; // use raw number for sorting
}

let defaultCulture = 'fr-CA';

	$('#cmdDisplay').click(function () {
		// redirect with query string
		window.location = GetUrl();
	});
</script>

	<script>


		function SetDateFromAndTo() {
			var ctrlTo = $$("to");
			var ctrlFrom = $$("from");
			if (ctrlTo && ctrlFrom) {
				var formatDate = 'YYYY-MM-DD';
				// we can assume the filter is present
				ctrlTo.max = ctrlFrom.max = moment().format(formatDate);
				var strFrom = $.query.get('from');
				if (strFrom != '') {
					ctrlFrom.value = strFrom;
				} else {
					var dateBeginMonth = moment();
					dateBeginMonth.date(1);
					ctrlFrom.value = dateBeginMonth.format(formatDate);
				}
				var strTo = $.query.get('to');
				if (strTo != '') {
					ctrlTo.value = strTo;
				} else {
					ctrlTo.valueAsDate = new Date();
				}
			}
		}


		// default value for dataTable
if ($.fn.dataTable != undefined) {
  $.extend($.fn.dataTable.defaults, {
    sPaginationType: "full_numbers",
    deferRender: true,
    pageLength: 25,
    dom: 'lBfrtip',
    buttons: [
		  {
		  	extend: 'copy',
		  	text: 'Copier',
		  	exportOptions: { orthogonal: 'export' }
		  },
		  {
		  	extend: 'excel',
			title:null, /* prevent top row */
		  	exportOptions: { orthogonal: 'export' },
		  	footer: true
		  },
		  {
		  	extend: 'pdf',
		  	exportOptions: { orthogonal: 'export' },
		  	orientation: 'landscape',
		  	footer: true
		  },
		  {
		  	extend: 'print',
		  	text: 'Imprimer',
			footer: true,
		  	customize: function (win) {
				  $(win.document.body)
					  .css('font-size', '10pt');
		  		$(win.document.body).find('table')
					.addClass('compact')
					.css('font-size', 'inherit');
		  	}
		  }
    ],
    oLanguage: { "sUrl": "/js/datatabletranslation.txt" }   
  });
}

		$('.sssGrid').dataTable({
			aaSorting: [[1, "asc"]],
			footerCallback: function (row, data, start, end, display) {
				var api = this.api();

				var count = api.column(3).data().length;
				$(api.column(3).footer()).html(count + ' produits');

				DataTableSumColumn(api, 4, NumberToQuantity, parseFloat);
				DataTableSumColumn(api, 5, NumberToQuantity, parseFloat);

                var totalCost = api.data().reduce(function (a, b) {
                    return parseFloat(a + parseFloat(b[6]) * parseFloat(b[8])); 
                }, 0);
		        $(api.column(6).footer()).html(NumberToAmount(totalCost));
				DataTableSumColumn(api, 8, NumberToQuantity, parseFloat);
				DataTableSumColumn(api, 9, NumberToQuantity, parseFloat);			
				DataTableSumColumn(api, 10, NumberToAmount, parseFloat);
			}
		});

		var _productId = 0;
		var _ctrlClicked;
		$('.img-renewal.not-active').click(function() {
			if (confirm("Désactivé l'option de renouveller le produit?")) {
				var img = this;
				_productId = this.parentElement.parentElement.attributes["data-id"].value;
				$.ajax('/Fournisseur/DesactivateRenewal?idProduct=' + _productId)
					.done(function () {
						img.classList.remove('not-active');
					}).fail(function( jqXHR, textStatus ) {
						alert( "Request failed: " + textStatus );
					});
			}
		});
		$('.img-renewal').attr('title', 'Le produit ne sera pas recommandé');
		$('.img-renewal.not-active').attr('title', "Le produit peut être recommandé. Clicker pour qu'il ne soit pas recommandé (fin de lot par example)");
		function GetUrl() {
			var ctrlStore = $$("lstStore");
			var store = '';
			if (ctrlStore) {
				store = ctrlStore.value;
			}
			return $.query.set('from', $$("from").value).set('to', $$("to").value).set('store', store);
		}

		$("#date-planned-selector").datepicker({ format: "dd/mm/yyyy" });
		$('.img-date-planned').click(function() {
			// pop the calendar
			_ctrlClicked = this;
			_productId = this.parentElement.parentElement.attributes["data-id"].value;
			$$('date-planned-selector').value = $(_ctrlClicked).next().html();
			$('#dialog-calendar').modal();
		});
		const apiPathUpdateProduct = '/Fournisseur/Date';
		$('#cmdDateRemove').click(function () {
			$.ajax(apiPathUpdateProduct + '?idProduct=' + _productId + '&date=remove')
					.done(function () {
						_ctrlClicked.classList.add('not-active');
						$('#dialog-calendar').modal('hide');
						$(_ctrlClicked).next().html('');
					}).fail(function (jqXHR, textStatus) {
						alert("Request failed: " + textStatus);
					});
		});

		$('#cmdDateSet').click(function () {
			var datePicked = $$('date-planned-selector').value;
			$.ajax(apiPathUpdateProduct + '?idProduct=' + _productId + '&date=' + datePicked)
					.done(function () {
						_ctrlClicked.classList.remove('not-active');
						$(_ctrlClicked).next().html(datePicked);
						$('#dialog-calendar').modal('hide');
					}).fail(function (jqXHR, textStatus) {
						alert("Request failed: " + textStatus);
					});
		});

		// jquery.query https://github.com/alrusdi/jquery-plugin-query-object
		new function(e){var t=e.separator||"&",n=!1!==e.spaces,r=(e.suffix,!1!==e.prefix?!0===e.hash?"#":"?":""),i=!1!==e.numbers;jQuery.query=new function(){var e=function(e,t){return null!=e&&null!==e&&(!t||e.constructor==t)},u=function(e){for(var t,n=/\[([^[]*)\]/g,r=/^([^[]+)(\[.*\])?$/.exec(e),i=r[1],u=[];t=n.exec(r[2]);)u.push(t[1]);return[i,u]},s=function(t,n,r){var i=n.shift();if("object"!=typeof t&&(t=null),""===i)if(t||(t=[]),e(t,Array))t.push(0==n.length?r:s(null,n.slice(0),r));else if(e(t,Object)){for(var u=0;null!=t[u++];);t[--u]=0==n.length?r:s(t[u],n.slice(0),r)}else(t=[]).push(0==n.length?r:s(null,n.slice(0),r));else if(i&&i.match(/^\s*[0-9]+\s*$/)){t||(t=[]),t[o=parseInt(i,10)]=0==n.length?r:s(t[o],n.slice(0),r)}else{if(!i)return r;var o=i.replace(/^\s*|\s*$/g,"");if(t||(t={}),e(t,Array)){var c={};for(u=0;u<t.length;++u)c[u]=t[u];t=c}t[o]=0==n.length?r:s(t[o],n.slice(0),r)}return t},o=function(e){var t=this;return t.keys={},e.queryObject?jQuery.each(e.get(),(function(e,n){t.SET(e,n)})):t.parseNew.apply(t,arguments),t};return o.prototype={queryObject:!0,parseNew:function(){var e=this;return e.keys={},jQuery.each(arguments,(function(){var t=""+this;t=(t=t.replace(/^[?#]/,"")).replace(/[;&]$/,""),n&&(t=t.replace(/[+]/g," ")),jQuery.each(t.split(/[&;]/),(function(){var t=decodeURIComponent(this.split("=")[0]||""),n=decodeURIComponent(this.split("=")[1]||"");t&&(i&&(/^[+-]?[0-9]+\.[0-9]*$/.test(n)?n=parseFloat(n):/^[+-]?[1-9][0-9]*$/.test(n)&&(n=parseInt(n,10))),n=!n&&0!==n||n,e.SET(t,n))}))})),e},has:function(t,n){var r=this.get(t);return e(r,n)},GET:function(t){if(!e(t))return this.keys;for(var n=u(t),r=n[0],i=n[1],s=this.keys[r];null!=s&&0!=i.length;)s=s[i.shift()];return"number"==typeof s?s:s||""},get:function(t){var n=this.GET(t);return e(n,Object)?jQuery.extend(!0,{},n):e(n,Array)?n.slice(0):n},SET:function(t,n){if(!t.includes("__proto__")){var r=e(n)?n:null,i=u(t),o=i[0],c=i[1],a=this.keys[o];this.keys[o]=s(a,c.slice(0),r)}return this},set:function(e,t){return this.copy().SET(e,t)},REMOVE:function(t,n){if(n){var r=this.GET(t);if(e(r,Array)){for(tval in r)r[tval]=r[tval].toString();var i=$.inArray(n,r);if(!(i>=0))return;t=(t=r.splice(i,1))[i]}else if(n!=r)return}return this.SET(t,null).COMPACT()},remove:function(e,t){return this.copy().REMOVE(e,t)},EMPTY:function(){var e=this;return jQuery.each(e.keys,(function(t,n){delete e.keys[t]})),e},load:function(e){var t=e.replace(/^.*?[#](.+?)(?:\?.+)?$/,"$1"),n=e.replace(/^.*?[?](.+?)(?:#.+)?$/,"$1");return new o(e.length==n.length?"":n,e.length==t.length?"":t)},empty:function(){return this.copy().EMPTY()},copy:function(){return new o(this)},COMPACT:function(){return this.keys=function t(n){var r="object"==typeof n?e(n,Array)?[]:{}:n;if("object"==typeof n){jQuery.each(n,(function(n,i){if(!e(i))return!0;!function(t,n,r){e(t,Array)?t.push(r):t[n]=r}(r,n,t(i))}))}return r}(this.keys),this},compact:function(){return this.copy().COMPACT()},toString:function(){var i=[],u=[],s=function(e){return e+="",e=encodeURIComponent(e),n&&(e=e.replace(/%20/g,"+")),e},o=function(t,n){var r=function(e){return n&&""!=n?[n,"[",e,"]"].join(""):[e].join("")};jQuery.each(t,(function(t,n){"object"==typeof n?o(n,r(t)):function(t,n,r){if(e(r)&&!1!==r){var i=[s(n)];!0!==r&&(i.push("="),i.push(s(r))),t.push(i.join(""))}}(u,r(t),n)}))};return o(this.keys),u.length>0&&i.push(r),i.push(u.join(t)),i.join("")}},new o(location.search,location.hash)}}(jQuery.query||{});

		SetDateFromAndTo();
	</script>
</body>
</html>
