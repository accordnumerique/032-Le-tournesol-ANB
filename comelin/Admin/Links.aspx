<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Links.aspx.cs" Inherits="WebSite.Admin.AdminPageLinks" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Liens</h1>
	<div id="editor-links">
		<div class="btn btn-primary" style="float:right;margin-bottom: 20px" @click="addLink">Ajouter un lien</div>
		
		<draggable v-model="links">
			<div v-for="(link, index) in links" class="link">
				<i class="fa fa-arrows" aria-hidden="true" title="Changer l'ordre des liens"></i>
				<div>
				<bilingual-text :text="link.Title" placeholder="Titre"></bilingual-text>
				<bilingual-text :text="link.Url" placeholder="Url de navigation"></bilingual-text>
				</div>
				<i class="fa fa-times" @click="linkDelete(index)" title="Effacer le lien"></i>
			</div>
		</draggable>
		<div class="btn btn-primary" @click="addLink">Ajouter un lien</div>
		<div class="btn btn-primary" @click="save" id="cmdSave">Sauvegarder</div>
	</div>
		<% Response.WriteFile("Homepage-configure-link.html"); %>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
		<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.7.0/Sortable.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Vue.Draggable/2.17.0/vuedraggable.min.js"></script>
	<script>
		var vm = new Vue({
			el: '#editor-links',
			data: {
				links: window._links
			},
			methods: {
				linkDelete: function(index) {
					if (confirm('Effacer le lien?')) {
						this.links.splice(index, 1);
					}

				},
				addLink: function () {
					var newLink = { Title: {}, Url: {}};
					this.links.push(newLink);
				},
				save: function () {
					var dataToPost = {};
					dataToPost.<%=Settings.LinksTag %> = JSON.stringify(this.links);
					$.post("/<%=WebSite.Admin.Api.ApiSettings.Url %>", dataToPost)
					.done(function() {
						$('#cmdSave').notify('Sauvegarder!', { position: "right", className: "success" });
					}).fail(function(data) {
						if (data.Error) {
							alert(data.Error);
						};
					});
				}
			}
		});
	</script>
</asp:Content>
