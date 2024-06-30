<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="GiftReinitialize.aspx.cs" Inherits="WebSite.Admin.GiftReinitialize" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
		<h1><img src="images/giftcard.png" />Réinitialiser des Cartes Cadeaux</h1>
		Scanner les cartes cadeaux une à la fois.<br />
		<br />
		Si la carte cadeau est vide elle sera réinitialisée (toutes les transactions seront effacées)<br />
		<br />
		<asp:TextBox ID="txtCardNumber" runat="server" ontextchanged="txtCardNumber_TextChanged" Width="159px"></asp:TextBox>
		<br />
		<br />

</asp:Content>
