<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="fr_Account" Title="Compte Client" CodeBehind="Account.aspx.cs" %>

<%@ Register Src="uc/ucIdentification.ascx" TagPrefix="uc1" TagName="ucIdentification" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
	<div class="pageMonCompte col">
		<h1><%= CustomerName %></h1>
		<div class="row">
			<uc1:ucIdentification runat="server" ID="ucIdentification" />
			<div class="col">
				<h2>Préférence</h2>
				<div>
					<h4>Recevoir l'infolettre:</h4>
					<asp:CheckBox ID="chkNewsletter" Text="Je veux recevoir l'infolettre concernant les nouveautés &amp; promotions."	runat="server" Checked="True" /><br />
					<br />
				</div>
				<asp:Button ID="cmdModify" runat="server" CssClass="btn btn-primary" Text="Modifier le Compte Client" OnClick="cmdModify_Click" />
			</div>
		</div>
		<div class="panel panel-default" id="panelPOs">
			<div class="panel-heading">Commandes en cours</div>
			<div class="panel-body" runat="server" id="lblNoReservations">
				<p>Aucunes commandes</p>
			</div>
			<%= Reservations %>
		</div>

		<div class="panel panel-default" id="ordersHistory">
			<div class="panel-heading">Historique des commandes complétés</div>
			<div class="panel-body" runat="server" id="lblNoCompletedOrders">
				<p>Aucunes commandes complétées</p>
			</div>

			<%= CompletedOrders %>
		</div>
	</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
	<script src="/js/bsasper.js"></script>
	<script>
		$(function () {
			$("input").bsasper();
		});
	</script>
</asp:Content>