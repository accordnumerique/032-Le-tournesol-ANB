<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="DuplicateProduct.aspx.cs" Inherits="WebSite.Admin.BarCodeDupliquer" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img alt="" src="images/cleanup-product.png" /> Produits dupliqués?</h1>
	Recherche par <a href="?by=barcode">BarCode</a> ou <a href="?by=code">Code</a> ou <a href="?by=title">Titre</a> 

	<%= Data %>
		<div id=panel style="display:none">
		<input id="txtId" type="hidden" />
		<input id="txtIdA" type="hidden" />
		<input id="txtIdB" type="hidden" />
		Titre Français: <br />
		<input id="txtTitleFr" type="text" style="width:500px" autocomplete="off" /><br />
		Titre Anglais: <br />
		<input id="txtTitleEn" type="text" style="width:500px" autocomplete="off" /><br />
		Code: <br />
		<input id="txtCode" type="text" autocomplete="off" /><br />
		Code à barre: <br />
		<input id="txtBarCode" type="text"  autocomplete="off" /><br />
		Manufacturier: <br />
		<input id="txtManufacturer" type="text" style="width:200px"  autocomplete="off"  /><br />
		Catégorie: <br />
		<input id="txtCategory" type="text" style="width:200px"  autocomplete="off"  /><br />
		<div class="button" onclick="merge(this)">Fussionner!</div>
	</div>
	
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<script type="text/javascript">
		function merg(idKeep, idDelete, titleFr,titleEn, code,barcode,manufacturer, category, buttonId) {
			document.getElementById('txtId').value = buttonId;
			document.getElementById('txtIdA').value = idKeep;
			document.getElementById('txtIdB').value = idDelete;
			document.getElementById('txtTitleFr').value = titleFr;
			document.getElementById('txtTitleEn').value = titleEn;
			document.getElementById('txtCode').value = code;
			document.getElementById('txtBarCode').value = barcode;
			document.getElementById('txtManufacturer').value = manufacturer;
			document.getElementById('txtCategory').value = category;
			$('#panel').dialog({ title: name, modal: true, minWidth: 540 });
		}
		function merge(ctr) {
			alert("Pas encore fini :(");
			return;
			$.ajax({ url: "AjaxMergeProduct.ashx",
				data: { "idA": document.getElementById('txtIdA').value,
					"idB": document.getElementById('txtIdB').value,
					"titleFr": document.getElementById('txtTitleFr').value,
					"titleEn": document.getElementById('txtTitleEn').value,
					"code": document.getElementById('txtCode').value,
					"barcode": document.getElementById('txtBarCode').value,
					"manufacturer": document.getElementById('txtManufacturer').value,
					"category": document.getElementById('txtCategory').value
				}
			}).done(function () {
				$('#panel').dialog('close');
				$('#' + document.getElementById('txtId').value).hide('slow');
			});

		}
	</script>
</asp:Content>
