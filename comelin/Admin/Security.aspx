<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Security.aspx.cs" Inherits="WebSite.Admin.Security" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
<h1><img alt="" src="images/security.png" /> Sécurité</h1>
<p>Gestion des ordinateurs qui sont autorisées ou pas à communiquer avec la base de donnée.</p><br /><br />
<table id=table style="width:100%" class=sssGrid>
	<thead><tr><th>Autorisé</th><th>Ordinateur</th><th>POS</th><th>Dernière Connexion</th><th>Installation</th><th>IP</th></tr></thead>
	</table>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			$('#table').dataTable({
				"sAjaxSource": 'AjaxComputers.ashx' + window.location.search,
				"aaSorting": [[3, 'desc']]
			});
		});
	</script>
</asp:Content>
