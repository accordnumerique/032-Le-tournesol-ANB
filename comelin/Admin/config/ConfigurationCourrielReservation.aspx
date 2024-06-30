<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ConfigurationCourrielReservation.aspx.cs" Inherits="WebSite.Admin.config.ConfigurationCourrielReservation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="page-edit-email-reservation">
	<h2>Récupération en magasin</h2>
	<h5>En préparation</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStatePreparationInStorePickupMsg"><i class="fa fa-edit"></i></a><h>ReservationStatePreparationInStorePickupMsg</h>
	<h5>Complété</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStateReadyInStorePickupMsg"><i class="fa fa-edit"></i></a><h>ReservationStateReadyInStorePickupMsg</h>
	
	<h2>Livraison par la poste</h2>
	<h5>En préparation</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStatePreparationShipByMailMsg"><i class="fa fa-edit"></i></a><h>ReservationStatePreparationShipByMailMsg</h>
	<h5>Complété</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStateReadyShipByMailMsg"><i class="fa fa-edit"></i></a><h>ReservationStateReadyShipByMailMsg</h>
	
	<h2>Livraison locale</h2>
	<h5>En préparation</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStatePreparationLocalDeliveryMsg"><i class="fa fa-edit"></i></a><h>ReservationStatePreparationLocalDeliveryMsg</h>
	<h5>Complété</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStateReadyLocalDeliveryMsg"><i class="fa fa-edit"></i></a><h>ReservationStateReadyLocalDeliveryMsg</h>
	
	
	<h2>Points de chute</h2>
	<h5>En préparation</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStatePreparationDropLocationMsg"><i class="fa fa-edit"></i></a><h>ReservationStatePreparationDropLocationMsg</h>
	<h5>Complété</h5>
	<a class="msg" href="/admin/config/Text.aspx?redirect=true#ReservationStateReadyDropLocationMsg"><i class="fa fa-edit"></i></a><h>ReservationStateReadyDropLocationMsg</h>
	</div>
	<style>
		a.msg {margin-right: 10px; font-weight: bold}
		#page-edit-email-reservation p {display: inline-block}
	</style>
</asp:Content>
