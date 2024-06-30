<%@ Page Title="Édition du message sur la page d'accueil" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="HomePageMessageEditor.aspx.cs" Inherits="WebSite.Admin.HomePageMessageEditor" ValidateRequest="false"%>

<%@ Register Src="~/Admin/ucFileUpload.ascx" TagPrefix="uc1" TagName="ucFileUpload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/tinymce/4.9.11/tinymce.min.js" integrity="sha512-3tlegnpoIDTv9JHc9yJO8wnkrIkq7WO7QJLi5YfaeTmZHvfrb1twMwqT4C0K8BLBbaiR6MOo77pLXO1/PztcLg==" crossorigin="anonymous"></script>
  <style>
		.imgDelete, .imgModify { cursor:pointer; float:left }
	.mceEditor { margin-bottom:20px}    
	#langSelection { margin: 20px}
	#langSelection input { clear:left }
	.btn-default {float: left; clear: both}
	.infoBoxHomePage img {max-width: 300px; max-height: 300px}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  <div id="langSelection">
    <input type="radio" id="radFr" name="lang" /><label for="radFr">Français</label>
    <input type="radio" id="radEn" name="lang" /><label for="radEn">Anglais</label>
  </div>
  <h1><img alt="" src="images/MessageHomePage.png">Message sur la page d&#39;accueil</h1>
	
  <div class="langfr">
  <asp:TextBox ID=txtMessageFr ClientIDMode=Static CssClass="mceEditor" runat=server Width="700px" TextMode=MultiLine Rows=9 />
  </div>
  <div class="langen">
  <asp:TextBox ID=txtMessageEn ClientIDMode=Static CssClass="mceEditor" runat=server Width="700px" TextMode=MultiLine Rows=9 />
  </div>
	<br />
	<uc1:ucFileUpload runat="server" ID="ucFileUpload" />
	<br />
	<br />
  <asp:Button ID="cmdSave" runat="server" Text="Sauvegarder" OnClick="cmdSave_Click" />
	<% Response.WriteFile("Homepage-configure-link.html"); %>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
  <script>
    var localStorageLangTag = "adminlang";
	
    tinyMCE.init({
      mode: "specific_textareas",
      selector: ".mceEditor",
      relative_urls: false,
      language_url : '/js/tinymce/langs/fr_FR.js',
      plugins: "textcolor,table,save,image,media,contextmenu,paste,fullscreen,hr,link,code",
      menubar: 'edit,insert,view,format,table,tools',
      toolbar: 'undo | redo | bold | italic | fontselect | fontsizeselect | forecolor | backcolor | alignleft | aligncenter | alignright | alignjustify | bullist | numlist | outdent | indent | link | table | hr | code',
      force_p_newlines: false,
      forced_root_block: ''
    });

    $('#radFr').click(function () {
    	$('.langen').hide();
    	$('.langfr').show();
    	localStorage[localStorageLangTag] = 'fr';
    	tinymce.activeEditor = tinyMCE.editors[0];
    });

    $('#radEn').click(function () {
    	$('.langfr').hide();
    	$('.langen').show();
    	localStorage[localStorageLangTag] = 'en';
    	tinymce.activeEditor = tinyMCE.editors[1];
    });

    // load the last lang
    var lang = localStorage[localStorageLangTag];
    if (lang == 'en') {
      $$('radEn').click(); // select french by default and hide english stuff    
    } else {
      $$('radFr').click(); // select french by default and hide english stuff    
    }

  </script>
</asp:Content>

