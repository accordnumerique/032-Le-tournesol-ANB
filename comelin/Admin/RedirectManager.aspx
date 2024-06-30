<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="RedirectManager.aspx.cs" Inherits="WebSite.Admin.RedirectManager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img alt="" src="images/redirect.png" /> Redirection</h1>
	
	<p>Les redirections permettre de ne pas perdre les anciens url et les redirigé vers une nouvelle page.</p><br /><br />
	<span style="width:70px; float:left">Prefix: </span><input id=txtPrefix style="width:300px" type=text /> <span class=help>Le prefix peut-être seulement le début du URL </span><br />
	<div style="width:70px; float:left">Url: </div><input id=txtRedirect style="width:300px" type=text /> <span class=help>L'URL redirigée</span><br />
	<span class=button id=cmdAdd>Ajouter</span>
	
	<div id=redirections>
	<%= RenderCustomRedirect %>
	</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		$('#cmdAdd').click(function () {
			var uri = "AjaxRedirectManager.ashx?action=add&prefix=" + encodeURIComponent($$('txtPrefix').value) + "&redirect=" + encodeURIComponent($$('txtRedirect').value);
			$.ajax({
				url: uri,
				success: function (html) {
					$$('redirections').innerHTML = html;
					$$('txtPrefix').value = '';
					$$('txtRedirect').value = '';
				}
			});
		});

		function deleteRedirection(id) {
			var uri = "AjaxRedirectManager.ashx?action=delete&id=" + id;
			$.ajax({
				url: uri,
				success: function (html) {
					$$('redirections').innerHTML = html;
				}
			});
		}
	</script>
</asp:Content>
