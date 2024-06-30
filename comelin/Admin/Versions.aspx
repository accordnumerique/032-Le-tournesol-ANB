<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Versions.aspx.cs" Inherits="WebSite.Admin.Versions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
<div id="app-versions" class="container-fluid" v-cloak>
	<br/>
	<template v-if="showFutureVersions">
        <a href="Versions.aspx">Version les mises à jours récentes...</a>
        <h1>Modifications de Comelin qui n'ont <b>PAS</b> été encore appliquées à votre entreprise.</h1>
    </template>
	<template v-else>
        <a href="Versions.aspx?future=true" >Voir les versions des mises à jours <b>à venir</b>...</a>
        <h1>Modifications de Comelin depuis la version <span id="versionFrom"></span></h1>
    </template>
    
    
	<div class="btn-group" role="group" aria-label="Basic example" style="display: none">
		<button type="button" class="btn btn-secondary">Nouveauté seulement</button>
		<button type="button" class="btn btn-secondary">Nouveauté et améliorations</button>
		<button type="button" class="btn btn-secondary">Voir tout</button>
	</div>
	<p v-if="!versions || versions.length === 0">Aucune modification significative.</p>
	<div v-for="version in versions" class="version row">
		<div class="col-3 col-lg-1" :id="'v' + version.Number">
			{{version.Number}}
		</div>
		<div class="col-3 col-lg-2">
			<div v-html="FormatDateTime(version.Date)"></div>
			<time class="TimeAgo" datetime="version.Date"></time>
		</div>
		<div class="col-6">
			<div v-for="(item,i) in version.Items" class="item">
				<div class="view">
					<div :class="[item.Type, 'icon']" :title="DisplayTypeTitle(item.Type)"></div>
					<span>{{item.Title.Fr}}	</span>
                    <a v-if="item.UrlHelpPage" :href="item.UrlHelpPage" target="_blank">
                        <img src="https://cdn.comelin.com/cdn/images/help.png" class="help" style="width: 24px;">
                    </a>
                </div>
			</div>
		</div>

		<div class="col">
			<div v-if="version.Companies" v-for="c in version.Companies" class="alert alert-info">
				<a href="'Companies.aspx#' + c">{{c}}</a>
			</div>
		</div>

	</div>

</div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	
	
		<script>
			$('#versionFrom').text($.query.get('from'));
			var searchFilter = document.location.search;
			if (!searchFilter) {
				//  limit to the current version of the client
				searchFilter = '?';
			}
			searchFilter += '&company=<%= Settings.Current.Authentication %>';
			fetch('https://facture.comelin.com/api/version/list' + searchFilter).then(response => response.json()).then(response =>
			{
				InitVue(response);
			});
			function InitVue(_versions) {
				
				// make sure all version object have a list of items
				for (var v of _versions) {
					if (!v.Items) {
						v.Items = [];
					}
				}

				var vm = new Vue({
					el: '#app-versions',
					data: {
						showFutureVersions: $.query.get('future'),
						versions: _versions,
						itemTypes: [
							{ Type: 'MajorFeature', Title: 'Nouvelle fonctionnalité importante' },
							{ Type: 'MinorFeature', Title: 'Nouvelle fonctionnalité mineure' },
							{ Type: 'Improvement', Title: 'Amélioration' },
							{ Type: 'BugFixImportant', Title: 'Correction d\'un bogue important' },
							{ Type: 'BugFixMinor', Title: 'Correction bogue mineur' },
							{ Type: 'Hidden', Title: 'Information non visible aux entreprises.' }
						],
						filterItem: null
					},
					methods: {
						DisplayTypeTitle: function (itemType) {
							return this.itemTypes.find(i => i.Type == itemType).Title;

						},
						FormatDateTime: function (strDate) {
							return FormatDateTimeAgo(strDate, true);
						}

					}
				});
			}

		</script>
</asp:Content>
