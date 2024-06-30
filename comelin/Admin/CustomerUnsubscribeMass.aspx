<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="CustomerUnsubscribeMass.aspx.cs" Inherits="WebSite.Admin.CustomerUnsubscribeMass" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Désabonnement massive que la newsletter. Un courriel par ligne.</h1>
	<p>
		<asp:TextBox runat="server" ID=txtEmail Width="400" TextMode="MultiLine" Rows=20></asp:TextBox>
	</p>
	<p>
		<asp:Button runat="server" ID=cmdUnsubscribe Text="Désabonner" onclick="cmdUnsubscribe_Click" />
	</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
</asp:Content>
