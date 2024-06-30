<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.BannersPage" CodeBehind="Banners.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<script type="text/javascript" src="/js/jquery.cycle.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="images/banners.png" /> Bannières sur la page principale</h1>
	<div id="bannerPager"></div>
	<h2>Nouvelle</h2>
	<div class=button id=cmdOpenAddBannerDialog>Ajouter une bannière...</div>
	<h2>Effacer / Changer l'ordre</h2>
	<%= WriteBannersEdit %>
	
	<div class="modal" tabindex="-1" role="dialog" id="dialogAddNewBanner">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Ajouter une nouvelle bannière</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div id=bilingualMsg runat=server>Si vous voulez que image qui ne soit pas dans les 2 langues renommer votre image avec le prefix "fr-" ou "en-".<br /></div>
				Image:<br />
				<asp:FileUpload ID="FileUploadBannerImage" runat="server" /><br /><br />
				Lien:<br /><asp:TextBox ID="txtBannerLink" runat="server" Width="300"></asp:TextBox><br /><asp:CheckBox ID="chkOpenLinkNewTab" Text="Ouvrir dans un nouvel onglet" runat="server" /><br/><br/>
					<div class="row">
					<div class="col">
						Titre
					</div>
                    </div>
					<div class="bilingual-text row">
						<div class="col-12"><span class="lang-label bilingual">Français</span>
							<asp:TextBox runat="server" ID="txtNewBannerTitleFr"></asp:TextBox><br/>
						</div>
						<div class="col-12"><span class="lang-label bilingual lang-en">English</span>
							<asp:TextBox CssClass="lang-en" runat="server" ID="txtNewBannerTitleEn"></asp:TextBox><br/>
						</div>
					</div>
					
				</div>
				<div class="modal-footer">
					<asp:Button ID="cmdAddBanner" runat="server" Text="Ajouter" onclick="cmdAddBanner_Click" />
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	<% Response.WriteFile("Homepage-configure-link.html"); %>

		<script type="text/javascript">
			$(function () {
				$('#cmdOpenAddBannerDialog').click(function () {
					$('#dialogAddNewBanner').modal();
				});

				$("#itemsort").on('hover', function () {
					$("#itemsort").sortable({
						update: function () {
							var inputs = $('#itemsort').serialize();
							$.post("./Ajax/BannersSaveOrder.ashx", inputs, alert("Order saved."));
						}
					});
				});
			});

		</script>
	<style>
		.banner{max-height: 200px; max-width: 400px; width: auto}
	</style>
</asp:Content>
