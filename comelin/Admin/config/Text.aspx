<%@ Page Title="Textes affichés" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Text.aspx.cs" Inherits="WebSite.Admin.config.Text" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<script src="//cdn.datatables.net/t/dt/jszip-2.5.0,pdfmake-0.1.18,dt-1.10.11,b-1.1.2,b-html5-1.1.2,b-print-1.1.2/datatables.min.js" type="text/javascript"></script>
	<link href="//cdn.datatables.net/t/dt/jszip-2.5.0,pdfmake-0.1.18,dt-1.10.11,b-1.1.2,b-html5-1.1.2,b-print-1.1.2/datatables.min.css?p=1" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/tinymce/4.9.11/tinymce.min.js" integrity="sha512-3tlegnpoIDTv9JHc9yJO8wnkrIkq7WO7QJLi5YfaeTmZHvfrb1twMwqT4C0K8BLBbaiR6MOo77pLXO1/PztcLg==" crossorigin="anonymous"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
	<div id="app-dic-manager">
        <h1>Gestionnaire du dictionnaire de base
            <help style="float:right" url="articles/administration-site-web-texte"></help>
        </h1>
		<div id="tableResult">
			<div id="divEditCurrent" class="modal" tabindex="-1" role="dialog" data-backdrop="false" >
				<div class="modal-dialog" role="document" v-if="current">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title">Modification du texte</h5>
							<button type="button" class="close" aria-label="Close" @click="current = null">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<div v-if="current.Module">Section <code>{{current.Module}}</code> &nbsp; </div>Code: <code v-if="current.OriginalText && current.OriginalText.Text">{{current.Code}}</code><input v-else v-model="current.Code" />  <br/>
							{{current.Description}}<br/>
							Valeur par défaut:<br/>
							<bilingual-text id="readText" :text="current.OriginalText" readonly="true" :multiline="current.IsMultiline"></bilingual-text><br/>
							Votre texte personnalisé: <bilingual-text id="editText" :text="current.Text" :multiline="current.IsMultiline"></bilingual-text><br/>
							</div>
								<div class="modal-footer">
							<div v-if="current.Text.Fr" class="btn btn-danger" @click="deleteCurrent">Remettre valeur par défaut</div>
									<div class="btn btn-primary savebutton" @click="saveCurrent">Sauvegarder le texte</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<table id="tableEntries">
				<thead>
					<tr>
						<th>Section</th>
						<th>Code</th>
						<th>Fr</th>
						<th>En</th>
						<th></th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tfoot>
				<tr>
					<th></th>
					<th></th>
					<th></th>
					<th></th>
					<th></th>
					<th></th>
					<th></th>
				</tr>
				</tfoot>
			</table>
        <div class="btn btn-default" @click="add">Ajouter du texte</div> (pour webmaster seulement)
	</div>
	
	<style>
		#divEditCurrent {margin:20px}
		td.code {color:darkgray; font-family: monospace}
		td.edit > i.fa-edit {cursor: pointer; font-size: 2em}
		#tableEntries td {vertical-align: baseline}
		#tableEntries tr.odd { background-color: #ECECFF; }
		.modal-dialog {max-width: 80%;}
	</style>
	</asp:Content>
	<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
	<script>
		var appDicManager = new Vue({
			el: '#app-dic-manager',
			data: {
				dictionnary: window._entries,
				current: null,
			},
			watch: {
				current: function (val) {
					if (val) {
						// check for default value for bilingual
						if (!val.Text) {
							val.Text = { Fr: '', En: '' };
						}
						$('#divEditCurrent').modal('show');
					} else {
						$('#divEditCurrent').modal('hide');
					}
				}
			},
			methods: {
				add: function() {
					this.current = { P: true };
					this.dictionnary.unshift(this.current);
					updateGrid();
				},
				deleteCurrent: function () {
					if (confirm('confirmation?')) {
						this.current.IsDeleted = true;
						this.current.Text = { Fr: '', En: '' };
						this.save();
					}
				},
				saveCurrent: function () {
					this.current.IsDeleted = false;
					if (this.current.IsHtml) { 
						// hack to get the content
						for (var editor of tinymce.editors) {
							if (editor.getContainer().parentElement.classList.contains('lang-fr')) {
								this.current.Text.Fr = editor.getContent();
							} else if (editor.getContainer().parentElement.classList.contains('lang-en')) {
								this.current.Text.En = editor.getContent();
							}
						}
						destroyHtmlEditor();
					}
					this.save();
                },
				save: function (event) {
					
					updateGrid();
					fetch('/admin/api/dictionary/custom/save', {
							method: 'POST',
							body: JSON.stringify(appDicManager.current)
					}).then(response => {
						if (response.status >= 400 && response.status < 600) {
							throw new Error("Bad response from server");
						}
							return response.json();
						})
						.then(response => {
							$('.savebutton').notify('sauvegardé');
							appDicManager.current = null;
						}).catch(function () {
							$.notify('Erreur de sauvegarde!!!', 'error');
						}).finally(function () {  });
				},
				editEntry: function(entry) {
					this.current = null;  // must be else, if the dialog was not close property the value can be the same.
					this.current = entry;
					if (this.current.IsHtml) {
					setTimeout(function() {
						tinyMCE.init({
							mode: "specific_textareas",
							selector: "#editText textarea",
							relative_urls: false,
							convert_urls: false,
							entity_encoding: 'raw',
							verify_html: false, /* to allow custom component */
                            forced_root_block :'',
							language_url: '/js/tinymce/langs/fr_FR.js',
							plugins: "textcolor,table,save,image,media,contextmenu,paste,fullscreen,hr,link,code,lists",
							menubar: 'edit,insert,view,format,table,tools',
							toolbar: 'undo | redo | bold | italic | fontselect | formatselect | fontsizeselect | forecolor | backcolor | alignleft | aligncenter | alignright | alignjustify | bullist | numlist | outdent | indent | link | table | hr | code',
							});
						}, 100); // must be delayed, because VueJs didn't create the item yet


						// http://archive.tinymce.com/forum/viewtopic.php?id=35710
						$(document).on('focusin', function (e) {
							if ($(e.target).closest(".mce-window").length) {
								e.stopImmediatePropagation();
							}
						});
					} else {
						destroyHtmlEditor();
					}
				}
			},
			mounted: function () {
				var hash = window.location.hash;
				if (hash) {
					// check if the section exist, if so edit it.
					this.editEntry(this.dictionnary.find(a => a.Code == hash.substr(1)));
				}
				
			}
		});

		function edit(row) {
			appDicManager.editEntry(_entries[row]);
		}


		function destroyHtmlEditor() {
			for (var editor of tinymce.editors) {
				editor.destroy();
			}
		}

        $('#divEditCurrent').on('hidden.bs.modal', checkRedirection);
		
        function checkRedirection() {
            if ($.query.get('redirect')) {
                document.location = document.referrer;
            }
        }

		function updateGrid() {
			dataTable.clear();
			for (var e of _entries) {
				dataTable.row.add(e);
			}
			dataTable.draw();
		}

		$(function () {

			dataTable = $('#tableEntries').DataTable({
				data: _entries,
				order: [[0, 'asc'], [1, 'asc']],
				columns: [
					{
						data: "Module",
						defaultContent: '',
					},
					{
						data: "Code",
						defaultContent: '',
						className: 'code'
					},
					{
						data: "Text.Fr",
						render: function (data, type, row, position) {
							if (data) {
								return '<b>' + data + '</b>';
							} else if (row.OriginalText) {
								return row.OriginalText.Fr;
							}
						},
						defaultContent: '',
					},
					{
						data: "Text.En",
						render: function (data, type, row, position) {
							if (data) {
								return '<b>' + data + '</b>';
							} else if (row.OriginalText) {
								return row.OriginalText.En;
							}
						},
						defaultContent: '',
						visible: _bilingual
					},
					{
						render: function(data, type, row, position) {
							return '<i class="fa fa-edit" onclick="edit(' + position.row + ')"></i>';
						},
						defaultContent: '',
						orderable: false,
						className: 'edit'
					},
						{
							data: "Text.En",
							defaultContent: '',
							visible: false
						}, {
							data: "Text.Fr",
							defaultContent: '',
							visible: false
						},
				]
			});
		});
	</script>
</asp:Content>
