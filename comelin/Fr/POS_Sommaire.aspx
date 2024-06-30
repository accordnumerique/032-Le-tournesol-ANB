<%@ Page Title="Panier d'achat" Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="WebSite.POS_Sommaire" CodeBehind="POS_Sommaire.aspx.cs"  %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Panier d'achat</h1>
	<div id="pageSummary">
		<%= CartSummaryHtml %>
	</div>
	<div class="row" id="rowSummaryActions">
		<div class="col align-self-start">
            <a class="btn btn-default" href="<%=SessionVariable.LastCategoryVisited %>"><t>ContinueShopping</t></a>
		</div>
		<div class="col">
            <a href="POS_Caisse.aspx" id="cmdBilling" class="btn btn-primary btn-lg">Passer à la caisse</a>
		</div>
	</div>
	
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
	<script src="/js/summary.js" type="text/javascript"></script>
</asp:Content>