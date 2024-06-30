<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Restore.aspx.cs" Inherits="WebSite.Admin.AdminPage"  %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
	<div id="app">
        <h1>Restauration d&#39;items effacés
			<help url="articles/restaurer-un-item-supprime"></help>
        </h1>
		<select v-model="objType" @change="onChange()">
			<option v-for="(value, key) in objTypes" :value="key">{{value}}</option>
		</select>
		<div v-if="list">
			<h2>Liste des {{objTypeName}}</h2>
			<div v-for="l in list" class="item">
				<div>
					# {{l.Id}}<br/>
					<span v-if="l.Date" v-html="FormatDateTimeAgo(l.Date)"></span>
					<div class="btn btn-default" @click="undelete(l.Id, $event)">Restaurer</div>
				</div>
				<div>
				<pre>{{l.Data}}</pre>
					</div>
			</div>
		</div>
	</div>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
		<% EnsurePermission(Permission.SuperAdmin); %>
	<script>
		var _supportedObjType = {
			"Product": "produits",
			"Customer": "clients",
			"Category": "catégories",
			"Promotion": "promotions",
			"Employee": "employé(e)s",
			"GenericPage": "pages web",
			"Sticker": "étiquettes",
            "Attribut": "Champs personnalisé",
			"Transaction": "transactions/factures",
			"SupplierOrder": "commandes fournisseur"
 		}
		vm = new Vue({
			el: '#app',
			data: {
				objType: null,
				objTypes: _supportedObjType,
				list: null
			},
			computed: {
				objTypeName: function() {
					if (!this.objType) {
						return '';
					}
					return _supportedObjType[this.objType];
				}
			},
			methods: {
				FormatDateTimeAgo: function (strDate, separateLine) {
					return FormatDateTimeAgo(strDate, separateLine);
				},
				onChange() {
					console.log(this.objType);
					$.ajax('/<%= WebSite.Admin.ApiListDeletedObject.Url %>?type=' + this.objType).done(function(result) {
						vm.list = result;
					});
				},
				undelete(id, e) {
					var ctrl = e.target;
					$.ajax('/<%= WebSite.Admin.ApiUndeleteObject.Url %>?id=' + id + '&type=' + this.objType).done(function(result) {
						if (result.Success) {
							$(ctrl).notify("Restauration complétée avec succès: " + result.Msg);
						} else {
							$(ctrl).notify(result.Error, 'error');
						}
					});
				}
			}
		});
	</script>
	<style>
		.TimeAgo {display: block}
		.item { display:flex}
		.item > div {margin:0 20px 20px 0}
		pre {max-height: 150px}
	</style>
</asp:Content>

