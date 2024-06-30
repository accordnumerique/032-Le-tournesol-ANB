<%@ Page Language="C#" MasterPageFile="~/Fr/MP.Master" AutoEventWireup="true" CodeBehind="GenericPage.aspx.cs" Inherits="WebSite.Fr.GenericPage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="content-<%=Data.Id %>" class="generic-content">
		<h1 class="page-title"><%= Data.Title %></h1>	
		<%= Data.Content %>
	</div>
</asp:Content>