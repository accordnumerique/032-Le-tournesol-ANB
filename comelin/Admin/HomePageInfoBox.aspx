<%@ Page Title="Images avec liens" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="HomePageInfoBox.aspx.cs" Inherits="WebSite.Admin.HomePageInfoBox" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style src="/css/Comelin2018.min.css" type="text/css" />
  <style>
  .imgDelete, .imgModify { cursor:pointer; float:left }
#langSelection { margin: 20px}
#langSelection input { clear:left }
.btn-default {float: left; clear: both}
.infoBoxHomePage img {max-width: 200px; max-height: 200px;display: block}
.title1,.title2 {display: block}
.langfr {width: 220px; text-align: center; margin: 15px }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  <div id="langSelection">
    <input type="radio" id="radFr" name="lang" /><label for="radFr">Français</label>
    <input type="radio" id="radEn" name="lang" /><label for="radEn">Anglais</label>
  </div>
  <h1><img alt="" src="images/MessageHomePage.png">Images avec liens</h1>
  <br />
	<div class="row">
		<%= RenderInfoBoxes %>
	</div>
	<div class="btn btn-primary" onclick="OpenEditInfoboxDialog()">Ajouter</div>
  
	
	<% Response.WriteFile("Homepage-configure-link.html"); %>
	
	
	<div class="modal" tabindex="-1" role="dialog" id="modalEditBox">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Modification d'une boîte</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <input type="hidden" id="txtMessageBoxId" runat="server" ClientIDMode=Static />
      <input type="hidden" id="txtLang" runat="server" value="fr" ClientIDMode=Static />
      Titre 1: <asp:TextBox ID="txtTitle1" runat="server" ClientIDMode="Static" ></asp:TextBox><br />
      <br />
      Titre 2: <asp:TextBox ID="txtTitle2" runat="server" ClientIDMode="Static" ></asp:TextBox><br />
      <br />
      Image: <asp:FileUpload id="file" runat="server" /><br />
      <br />
      Lien: <asp:TextBox ID="txtUrl" ClientIDMode=Static runat="server"></asp:TextBox><br />
          <br/>
          Ordre d'affichage: <asp:TextBox ID="txtDisplayOrder" MaxLength="2" ClientIDMode=Static runat="server"></asp:TextBox><br />
      </div>
      <div class="modal-footer">
         <asp:Button Text="Save" ID="cmdSaveBox" runat="server" OnClick="cmdSaveBox_Click"  />
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
  <script>
    var localStorageLangTag = "adminlang";
	
    $('#radFr').click(function () {
    	$('.langen').hide();
    	$('.langfr').show();
    	$$('txtLang').value = localStorage[localStorageLangTag] = 'fr';
    });

    $('#radEn').click(function () {
    	$('.langfr').hide();
    	$('.langen').show();
    	$$('txtLang').value = localStorage[localStorageLangTag] = 'en';
    });

    // create
    function OpenEditInfoboxDialog(set) {
      // clear field
    	$$('txtTitle1').value = $$('txtTitle2').value = $$('txtUrl').value = '';
    	$('#modalEditBox').modal();
    	$$('txtTitle1').focus();
    }

    // load the last lang
    var lang = localStorage[localStorageLangTag];
    if (lang == 'en') {
      $$('radEn').click(); 
    } else {
      $$('radFr').click(); 
    }

    // edit
    function InfoBoxEdit(id, lang, url, text1, text2, displayOrder) {
      OpenEditInfoboxDialog();
      $$('txtMessageBoxId').value = id;
      $$('txtLang').value = lang;
      $$('txtUrl').value = url;
      $$('txtTitle1').value = text1;
      $$('txtTitle2').value = text2;
        if (displayOrder) {
             $$('txtDisplayOrder').value = displayOrder;
        } else {
             $$('txtDisplayOrder').value = '';
        }
    }

    // delete
    function InfoBoxDelete(id, text) {
      if (confirm('Effacer ' + text + '?')) {
        document.location = "HomePageInfoBox.aspx?delete=" + id + "&set=" + $.query.get('set');
      }
    }

  </script>
</asp:Content>
