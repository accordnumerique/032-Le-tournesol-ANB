<%@ Page Title="" Language="C#" MasterPageFile="~/Fr/emails/Email.Master" AutoEventWireup="true" Inherits="WebSite.Fr.emails.PageNewComputer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="server">
	<p>Un ordinateur (<%= Request.QueryString["computerName"] %>) qui s'identifie comme le point de vente <%= Request.QueryString["pos"] %> a besoin d'une authorization pour pouvoir continuer.</p>
	<br />
	<a href="<%= Settings.Current.WebSite + "/Admin/Security.aspx" %>">Voir les permissions...</a>
	
</asp:Content>
