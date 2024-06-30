<%@ page title="Éditeur de pages personnalisé" language="C#" masterpagefile="~/Admin/AdminMP.Master" autoeventwireup="true" codebehind="GenericPageEditor.aspx.cs" inherits="WebSite.Admin.GenericPageEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#divEditors .row input[type=text] { width: 100%; }
		#frameEditor { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: white; }
		#frameEditorClose { position: fixed; bottom: 5px; left: 5px; z-index: 10; }
		.page-hidden{color:red}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div class="container-fluid" id="app">
        <h1><img src="images/generic-page.png"/> Éditeur de pages personnalisées <help style="float:right" url="articles/cr%C3%A9ation-d-une-page-d-information-sur-la-boutique-en-ligne-comelin"></help></h1>
		<div class="row">
			<nav class="col col-12 col-md-2" id="navigation">
				<asp:Button ID="cmdAddNew" runat="server" Text="Ajouter une page" OnClick="cmdAddNew_Click" CssClass="btn btn-default" />
				
				<div v-if="pages" id="divExistingPages">
					<div v-for="p in pages">
						<a :href="'GenericPageEditor.aspx?id=' + p.Id">{{p.Title.Fr}}</a> <a :href="p.Path.Fr" target="_blank"><i class="fa fa-globe" :class="{'page-hidden' : !p.Visible}" ></i></a>
					</div>
				</div>
			</nav>
			<div v-if="genericPage" class="col col-12 col-md-10" id="divEditors">
				<div class="row ">
					<div class="col-4">Lien ajoutée sur le site web</div>
					<div class="col"><input  v-model:value="genericPage.Visible" type="checkbox" id="chkVisible" /> <label for="chkVisible">Visible</label></div>
				</div>
				<div class="row" v-if="genericPage.Visible">
					<div class="col-4">Ordre d'affichage</div>
					<div class="col"><input  v-model:value="genericPage.DisplayOrder" type="number" /></div>
				</div>
				<div class="row row-bilingual">
					<div class="col-2">Titre</div>
					<div class="col"><bilingual-text :text="genericPage.Title"></bilingual-text></div>
				</div>
				<div class="row row-bilingual">
					<div class="col-2">Url</div>
					<div class="col"><bilingual-text :text="genericPage.Path"></bilingual-text></div>
				</div>
                <div class="row row-bilingual">
                    <div class="col-2">Meta-Description (SEO)</div>
                    <div class="col"><bilingual-text :text="genericPage.MetaDescription"></bilingual-text></div>
                </div>
                <div class="row row-bilingual">
                    <div class="col-2">Meta-Keywords (SEO)</div>
                    <div class="col"><bilingual-text :text="genericPage.MetaKeywords"></bilingual-text></div>
                </div>
				<h3>Contenu<span class="english"> en français</span></h3>
				<div v-if="genericPage.Content" v-html="genericPage.Content.Fr" class="generic-content"></div>
				<div class="btn btn-default" id="cmdEditFr" @click="edit('Fr')">Modifier le contenu</div>
				<div class="english">
					<hr/>
					<h3>Contenu en anglais</h3>
					<div v-if="genericPage.Content" v-html="genericPage.Content.En"></div>
					<div class="btn btn-default" id="cmdEditFr" @click="edit('En')">Modifier le contenu</div>
				</div>
				<iframe v-show="editMode" name="frameEditor"  id="frameEditor" src="HtmlEditor.aspx"></iframe>
				<div v-show="editMode" id="frameEditorClose" @click="closeEditor" class="btn-primary btn">Sauvegarder Text</div>
				
				<div style="display: flex; justify-content: space-between; margin:15px 0">
					<div id="cmdSave" class="btn btn-primary" @click="save">Sauvegarder la page</div>
					<div id="cmdDelete" class="btn btn-danger" @click="deletePage">Effacer la page</div>
				</div>
			</div>

		</div>
	</div>
	<% Response.WriteFile("Homepage-configure-link.html"); %>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		var appEditors = new Vue({
			el: '#app',
			data: {
				pages: window._pages,
				genericPage: window._genericPage,
				editMode: false,
				editLang: 'Fr',
				ctrlEdit: null /* control is getting edit (hidden field)*/
			},
			methods: {
				edit: function (lang) {
					this.editMode = true;
					this.editLang = lang;
					$$('frameEditor').contentWindow.SetHtml(this.genericPage.Content[lang]);
				},
				closeEditor: function () {
					this.genericPage.Content[this.editLang] = $$('frameEditor').contentWindow.GetHtml();
					this.editMode = false;
					this.save();
				},
				save: function () {
					var ctrlSave = $$('cmdSave')
					fetchPost('/admin/api/generic-page', this.genericPage, ctrlSave,  function (data) {
						appEditors.pages = data;
						$(ctrlSave).notify('Page sauvegardée');
                    });
				},
				deletePage: function() {
					if (confirm('Effacer?')) {
						this.genericPage.Delete = true;
                        fetchPost('/admin/api/generic-page', this.genericPage, $$('cmdDelete'), function (data) {
							appEditors.pages = data;
							appEditors.genericPage = null;
							$.notify('Page effacé');
						}, 'json');
					}
				}
			}
		});

	</script>
</asp:Content>

