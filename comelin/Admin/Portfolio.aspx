<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Portfolio.aspx.cs" Inherits="WebSite.Admin.PortfolioPage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="page-portfolio">
		<div class="row" id="portfolios">
			<div v-if="settings.CanCreate" class="col-12 col-md-2" id="menu">
				<div v-for="p in portfolioSorted">
					<a  :href="'Portfolio.aspx?id=' + p.Id">{{p.Title.Fr}}</a>	
					<i class="fa fa-times" @click="deletePortfolio(p)" title="Effacer un portfolio"></i>
				</div>
				
				<div class="btn btn-default" id="cmdAddPortfolio" @click="add">Ajouter</div>
				
			</div>
			<div class="col-12 col-md-10"  v-if="portfolio">
				
				<div v-if="project" id="project-edit">
					<h1>Modifier un project</h1>
					<div class="row">
						<div class="col-2">
							Nom
						</div>
						<div  v-if="project"  class="col-10">
							<bilingual-text :text="project.Title"></bilingual-text>
						</div>
					</div>
					<div class="row">
						<div class="col-2">
							Description
						</div>
						<div  v-if="project"  class="col-10">
							<bilingual-text :text="project.Description" multiline="true"></bilingual-text>
						</div>
					</div>
					<div>
						<h2>Photos</h2>
						<div id="photos">
							<draggable v-model="project.UrlImages">
								<div v-for="(urlPhoto, index) in project.UrlImages" class="photo">
									<i class="fa fa-arrows" aria-hidden="true" title="Changer l'ordre des photos"></i>
									<i v-if="project.PhotoDefault == index" class="fa fa-check-circle" style="cursor:default" title="Photo par défaut"></i>
									<i v-else  class="fa fa-circle-thin" @click="project.PhotoDefault = index" title="Mettre la photo par défaut"></i>
									<img :src="urlPhoto"/>
									<i class="fa fa-times" @click="deletePhoto(index)" title="Effacer une photo"></i>
								</div>
							</draggable>
						</div>
						<div id="dropzone">Clicker <b>ou</b> Glisser votre image ici</div>
					</div>

					<div class="btn btn-default" @click="returnToProject">Sauvegarder & Retour aux projets</div>
				</div>
				

				<div id="portfolio">
				<h1>Modification d'un portfolio</h1>
			
				<div class="row">
					<div class="col-2">
						Titre
					</div>
					<div class="col-10">
						<bilingual-text :text="portfolio.Title"></bilingual-text>
					</div>
				</div>
				<div class="row">
					<div class="col-2">
						Description
					</div>
					<div class="col-10">
						<bilingual-text :text="portfolio.Description" multiline="true"></bilingual-text>
					</div>
				</div>
				</div>
				<hr/>
				<div id="project">
					<h2>Projets</h2>
					<div v-if="portfolio.Projects" id="projects">
						<draggable v-model="portfolio.Projects">
							<div  class="project" v-for="(p, order) in portfolio.Projects">
								<i class="fa fa-arrows" aria-hidden="true" title="Changer l'ordre des projects"></i>
								<i v-if="portfolio.ProjectDefault == order" class="fa fa-check-circle" style="cursor:default" title="Projet par défaut"></i>
								<i v-else  class="fa fa-circle-thin" @click="portfolio.ProjectDefault = order" title="Mettre le projet par défaut"></i>
								<span @click="editProject(p)" >#{{order + 1}} {{p.Title.Fr}}</span> <i class="fa fa-pencil-square-o" @click="editProject(p)" title="Modifier un projet"></i>
								<i class="fa fa-times" @click="deleteProject(order, p)" title="Effacer un projet"></i>
							</div>
						</draggable>
					</div>
					<div class="btn btn-secondary" @click="addProject">Ajouter un project</div>
				</div>
				<hr/>
				<div class="btn btn-primary" @click="update" id="cmdSave">Sauvegarder</div>
			</div>
			
		</div>
	</div>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.7.0/Sortable.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Vue.Draggable/2.17.0/vuedraggable.min.js"></script>

	<script src="js/dropzone.min.js"></script>
	<script>
		var vm = new Vue({
			el: '#portfolios',
			data: {
				settings: window._portfolioSettings,
				portfolios: window._portfolios,
				portfolio: window._portfolio,
				project:null // current project selected
			},
			methods: {
				add: function () {
					this.saveToServer({ Title: { Fr: 'Nouveau', En: 'New' } }, function (newData) {
						window.location = 'Portfolio.aspx?id=' + newData.Id;
					});
				},
				update: function (event) {
					this.saveToServer(this.portfolio, function () {
						if (event) {
							$(event.target).notify('sauvagarder!');
						} else {
							$.notify('sauvagarder!');
						}
						
					});
				},
				deletePortfolio : function (portfolio) {
					if (confirm('Effacer le portfolio ' + portfolio.Title.Fr + '?')) {
						$.ajax({
							url: '/<%= Comelin.Api.PortfolioDelete.Url %>?id=' + portfolio.Id,
							success: function () {
								vm.portfolios = vm.portfolios.filter(function (item) { return item.Id != portfolio.Id }); // remove existing
								$.notify('portfolio effacé!');
							}
						});
					}
				},
				saveToServer: function (p, callback) {
					$.ajax({
						type: 'POST',
						url: '/<%= Comelin.Api.PortfolioSave.Url %>',
						dataType: 'json',
						data: JSON.stringify(p),
						success: function(newData) {
							// add to portfolios object
							vm.portfolios = vm.portfolios.filter(function(item) { return item.Id != newData.Id }); // remove existing
							vm.portfolios.push(newData);
							if (callback) {
								callback(newData);
							}
						}
					});
				},
				addProject: function () {
					// create a project server side and select it
					if (!this.portfolio.Projects) {
						Vue.set(vm.portfolio, 'Projects', []); // init the array with reactivity
					}
					var newPortfolioProject = {};
					newPortfolioProject.Title = {};
					newPortfolioProject.Title.Fr = 'Nouveau projet';
					newPortfolioProject.Description = {};
					newPortfolioProject.PhotoDefault = 0;
					this.portfolio.Projects.push(newPortfolioProject);
					this.project = newPortfolioProject; // set the default project selected
					this.$nextTick(function () {
						initDropZone();
					});
				},
				editProject: function (project) {
					this.project = project;
					this.$nextTick(function () {
						initDropZone();
					});
				},
				deletePhoto: function (index) {
					if (confirm('Effacer la photo?')) {
						this.project.UrlImages.splice(index, 1);
					}
					
				},
				deleteProject: function (index, project) {
					if (confirm('Effacer le projet ' + project.Title.Fr + '?')) {
						this.portfolio.Projects.splice(index, 1);
					}
				},
				returnToProject: function () {
					this.project = null;
					this.update();
				}
 			},
			computed: {
				portfolioSorted: function () {
					this.portfolios.sort(function (a, b) {
						var nameA = a.Title.Fr.toUpperCase(); // ignore upper and lowercase
						var nameB = b.Title.Fr.toUpperCase(); // ignore upper and lowercase
						if (nameA < nameB) {
							return -1;
						}
						if (nameA > nameB) {
							return 1;
						}

						// names must be equal
						return 0;
					});
					return this.portfolios;
				}
			},
			mounted: function () {
				
			}
		});
		function initDropZone() {
			var element = $$('dropzone');
			if (element) {
				myDropzone = new Dropzone(element, {
					url: "/api/upload-image",
					acceptedFiles: "image/*",
					maxFiles: 100,
					resizeWidth: 1000,
					resizeHeight: 1000,
					maxfilesexceeded: function (file) {
						this.removeAllFiles();
						this.addFile(file);
					},
					success: function (file, done) {
						console.log("uploaded" + file.name);
						if (!vm.project.UrlImages) {
							Vue.set(vm.project, 'UrlImages', []); // init the array with reactivity
						}
						var url = "/upload/files/" + file.name;
						vm.project.UrlImages.push(url);
						
						//myDropzone.reset();
					},
					complete: function (file) {
						this.removeFile(file);
					},
					error: function (err) {
						alert(err);
					}
				});
			}
		}
	</script>
</asp:Content>
