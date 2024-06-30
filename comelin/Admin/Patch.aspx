<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.Patch"  CodeBehind="Patch.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="images/patch.png" /> Patch du système</h1>
<p>Version déployé: <%= CurrentVersion %></p>
<p>Version database: <%= LatestVersion %></p>
	<p>&nbsp;</p>
	<p>
		<asp:Button ID="cmdApplyUpdate" runat="server" onclick="cmdApplyUpdate_Click" Text="Appliquer la mise à jour (DB)" />
	</p>
	<p>
		
	</p>
</asp:Content>
