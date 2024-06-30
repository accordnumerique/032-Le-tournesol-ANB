<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportProductGoDaddy.aspx.cs" Inherits="WebSite.Admin.onetime.ImportProductGoDaddy" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	
	<p>
		Url de la boutique en ligne par GoDaddy:</p>
	<p>
		<asp:TextBox ID="txtUrl" runat="server" Width="90%"></asp:TextBox>
	</p>
	<asp:Button ID="cmdImport" runat="server" OnClick="cmdImport_Click" Text="Importer" />
	<br />
	
</asp:Content>
