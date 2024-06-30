<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="CommunicationEdit.aspx.cs" Inherits="WebSite.Admin.CommunicationEdit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="page-communication-edit">
		<h1>Edition du message </h1>
		<div id="lang">
			<input type="radio" id="langFr" name="lang" checked="checked" @click="setFrench"><label for="langFr">Français</label>
			<input type="radio" id="langEn" name="lang" @click="setEnglish"><label for="langEn">Anglais</label>
		</div>
		<div id="cmdAddName" class="button pull-right addText">Ajouter Nom</div>
		<div id="cmdAddProduct" class="button pull-right addText">Ajouter Produit</div>
		<div>Sujet du courriel:
			<input v-if="english" type="text" style="width: 300px" v-model="communication.TitleEn" />
			<input v-else type="text" style="width: 300px" v-model="communication.TitleFr" /></div>
		<br />
		<iframe name="frameEditor" id="frameEditor" src="HtmlEditor.aspx"></iframe>

		<br />
		<div id="cmdSave" class="button" @click="save">Sauvegarder</div>
		<div id="cmdPreviewOpenDialog" class="button">Test / Prévisualisation</div>
	</div>



	<div class="modal" tabindex="-1" role="dialog"  id=dialogPreview >
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Test et Prévisualisation</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        			<iframe name=framePreview id=framePreview style="width:670px; height:70vh;"></iframe>
      </div>
      <div class="modal-footer">
        Courriel du client: <input type=text id=txtEmail /><br /><div id=cmdPreview class=button>Prévisualisation</div>&nbsp;<div id=cmdSendTestEmail class=button>Envoyer courriel test</div>
      </div>
    </div>
  </div>
</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">

	<script>
		var _lang = 'fr';
		var LOCAL_STORAGE_EMAIL = 'emailTestCommunication';
		$(function() {
			if (_communication.Id === 4) {
				// product price change
				$('#cmdAddProduct').show();
			}
		});

		var vm = new Vue({
			el : '#page-communication-edit',
			data: {
				communication: _communication,
				english: false
			},
            computed: {
                lang() {
					return this.english ? "en" : "fr";
                }
            },
			methods: {
				setFrench: function () {
					if (!this.english) {
						return;
					}
					this.GetHtmlContent();
					this.english = false;
					_lang = 'fr';
					$$('frameEditor').contentWindow.SetHtml(this.communication.HtmlFr);
				},
				setEnglish: function () {
					if (this.english) {
						return;
					}
					this.GetHtmlContent();
					this.english = true;
					_lang = 'en';
					$$('frameEditor').contentWindow.SetHtml(this.communication.HtmlEn);
				},
				save: function () {
					this.GetHtmlContent();
					$.ajax({
						type: "POST",
						url: "/admin/api/communication/save?id=" + _communication.Id,
						data: JSON.stringify(vm.communication),
						dataType: 'json'
					}).done(function () {
						$('#cmdSave').notify('Sauvegardé!');
					}).fail(function (e) {
						notify(e.statusCode);
					});
				},
				GetHtmlContent: function () {
					if (this.english) {
						this.communication.HtmlEn = $$('frameEditor').contentWindow.GetHtml(); 
					} else {
						this.communication.HtmlFr = $$('frameEditor').contentWindow.GetHtml();
					}
					
				}
			}
		});

		// create the iframe
		$('iframe#frameEditor').attr('src', 'HtmlEditor.aspx');

		$('iframe#frameEditor').on('load', function () {
			// when the iframe is loaded, set the content
			console.log('iframe load completed');
			$$('frameEditor').contentWindow.SetHtml(_communication.HtmlFr);

			$('#cmdAddName').click(function () {
				AppendHtml('{0}');
			});
			$('#cmdAddProduct').click(function () {
				AppendHtml('{1}');
			});

			$('#cmdPreviewOpenDialog').click(function () {
				if (_idCommunication == 23) {
				    urlPreview = '/api/gift-card/print-layout?amount=100&barcode=1234567890&from=Bob&to=Alice&message=Merci&date=5+Jan+2023&lang=' + vm.lang;
				    window.open(urlPreview);
				    return;
                } 
				$('#dialogPreview').modal();
				var emailSaved = localStorage[LOCAL_STORAGE_EMAIL];
				if (emailSaved != null) {
					$$('txtEmail').value = emailSaved;
					$('#cmdPreview').trigger('click');
				}
			});
		});



		$('#cmdPreview').on('click', function () {
			console.log('preview is clicked');
			// convert the email to a userid
			var email = $$('txtEmail').value
			$.ajax({ url: "AjaxCommunication.ashx?id=" + _idCommunication + "&action=getUserId&value=" + encodeURIComponent(email) }).done(function (data) {
				var idCustomer = parseInt(data);
				if (idCustomer !== 0) {
					// it's a valid email
					localStorage[LOCAL_STORAGE_EMAIL] = email; // save for next session
					var urlPreview ='/' + _lang + '/emails/?idCustomer=' + data + '&idCommunication=' + _idCommunication + '&from=Bob&to=Alice&Message=Merci';
					$('iframe#framePreview').attr('src', urlPreview);
				} else {
					$('#txtEmail').notify('Un client doit exister avec ce courriel', 'error');
				}
			});
		});

		$('#cmdSendTestEmail').on('click', function () {
			console.log('request send previous email');
			// convert the email to a userid
			var email = $$('txtEmail').value;
			$.ajax({ url: "AjaxCommunication.ashx?id=" + _idCommunication + "&action=sendEmail&value=" + encodeURIComponent(email) + "&lang=" + _lang }).done(function (data) {
				if (data) {
					$.notify("Courriel test pour " + email + '. ' + data, 'error');
				} else {
					$.notify("Envoyé à " + email, 'success');
				}
		    
			});
		});

		function AppendHtml(html) {
			$$('frameEditor').contentWindow.AppendHtml(html);
		}
		window.addEventListener('resize', SetFrameHeight);
		function SetFrameHeight() {
			$$('frameEditor').height = window.innerHeight - 300;
		}

		SetFrameHeight();
	</script>
	<style>
		#frameEditor{width:100%;}
		.addText { display: none}
		.modal-dialog {height: 90%; max-width: 700px}
		.modal-content {height:100%}
	</style>
</asp:Content>
