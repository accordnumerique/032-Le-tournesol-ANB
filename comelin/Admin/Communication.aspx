<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Communication.aspx.cs" Inherits="WebSite.Admin.CommunicationPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#lang { margin-bottom:7px}
		.commType { padding:10px; max-width: 900px}
		.commType div { padding-left:49px}
		.commType .t { font-size:150%; padding-bottom:5px; padding-left:0}
		.commType .t i { margin-right:5px; margin-left: 5px}
        .commType .t img {margin-right: 14px}
		.commType .t span {position: absolute; left:73px}
		#cmdPreview { margin:5px 0 5px 0}
		.t .edit {display: none; font-size: 2em; float:right}
		.commType:hover {background-color: rgb(255, 236, 209); border-radius: 4px}
		.commType:hover .edit {display: inline; color: orange; margin-left: 10px; cursor:pointer}
		#dialogEdit {background-color: white}

		.commType a{ text-decoration: none;color:black}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img alt="" src="images/email.png" />
		Communications Automatisées</h1>
    <div style="float: right"><help url="articles/communications-automatis%C3%A9es-r%C3%A9servations"></help></div>
		Ce module envoie des courriels automatiquement à vos clients selon les différents operation qui sont effectués. Pour activé un courriel automatique il faut l'activé (crochet à gauche). Pour voir ou modifier le contenu du courriel, cliquez sur le titre.
	
		<br />
		<br />
	<div class="commType">
		
		<a href="/Admin/config/ConfigurationCourrielReservation.aspx">
			<div class="t"><img src="/Admin/images/reservations.png"></img>Courriels de réservations</div>
			<div>Courriels envoyés pour confirmer la réservation et information lorsqu'elle est complétée et/ou progrès.</div>
		</a>
	</div>
	<div class=commType data-type=1 >
		<div class="t"><input type=checkbox id=chk1 runat=server ClientIDMode=Static /><i class="fa fa-user fa-fw"></i><span>Nouveau client en ligne</span></div>
		<div>Lorsque le nouveau client se créé un compte en ligne.</div>
	</div>
	<div class=commType data-type=2 >
		<div class="t"><input type=checkbox id=chk2 runat=server ClientIDMode=Static /><i class="fa fa-building fa-fw"></i><span>Nouveau client en magasin</span></div>
		<div>Lorsque le nouveau client qui passe une commande en magasin. Le courriel doit-être spécifié.</div>
	</div>
  <div class=commType data-type=8 >
		<div class="t"><i class="fa fa-key fa-fw"></i><span>Mot de passe</span></div>
		<div>Lorsque le client demande son mot de passe parce qu'elle l'a oublié.</div>
	</div>
	<div class=commType data-type=3 >
		<div class="t"><input type=checkbox id=chk3 runat=server ClientIDMode=Static /><i class="fa fa-envelope fa-fw"></i><span>Confirmation d'inscription à l'infolettre</span></div>
		<div>Lorsque le client qui s’inscrive à la newsletter en ligne.</div>
	</div>
  <div class=commType data-type=5 >
		<div class="t"><input type=checkbox id=chk5 runat=server ClientIDMode=Static /><i class="fa fa-cubes fa-fw"></i>Retour en inventaire</div>
		<div>Lorsqu'un produit n'étais plus disponible et qu'il est de nouveau en inventaire.</div>
	</div>
	<!--	<div class=commType data-type=4 >
		<div class="t"><input type=checkbox id=chk4 runat=server ClientIDMode=Static /><i class="fa fa-money fa-fw"></i>Changement de prix ou promotion</div>
		<div>Lorsque le prix d'un article baisse par rapport à la journée précédente.</div>
	</div>
	<div class=commType data-type=6 >
		<div class="t"><input type=checkbox id=chk6 runat=server ClientIDMode=Static /><i class="fa fa-bullhorn fa-fw"></i>Message sur un produit en particulier</div>
		<div>Faire manuellement une notification aux clients qui ont reservé ou surveille le produit (prix, inventaire).</div>
	</div>
  	<div class=commType data-type=10 >
		<div class="t"><input type=checkbox id=Checkbox2 runat=server ClientIDMode=Static /><i class="fa fa-bullhorn fa-fw"></i>Promotion en cours</div>
		<div>Envois un couriel lorsqu'un client le <a href="/fr/promotion.aspx">demande par lui même</a></div>
	</div> -->
	 <div class=commType data-type=12 >
		<div class="t"><input type=checkbox id=chk12 runat=server ClientIDMode=Static /><i class="fa fa-shopping-cart" aria-hidden="true"></i>
			<span>Panier abandonné depuis plus de <asp:TextBox runat="server" id="txtAbandonCartFor" ClientIDMode="Static" Font-Size="20px" Width="36px"></asp:TextBox> &nbsp;heures</span></div>
		<div>Envoi un courriel,  si un client avec un compte a laissé un article dans son panier depuis plus d'un certain temps</div>
	</div>
	<div class=commType data-type=14 >
		<div class="t"><input type=checkbox id=chk14 runat=server ClientIDMode=Static /><i class="fa fa-clock-o" aria-hidden="true"></i>
			<span>Un promotion avec temps limité s'applique sur un produit en ligne.</span></div>
		<div>Envois un courriel à la cliente le temps restant pour la promotion.</div>
	</div>
	<div class=commType data-type=11 >
		<div class="t"><i class="fa fa-key fa-fw"></i><span>Mot de passe fournisseur</span></div>
		<div>
			<label for="chk11">Section <a href="/Fournisseur/">fournisseur</a>. Mot de passe oublié.</label>	
		</div>
	</div>
	<div class=commType data-type=13 >
		<div class="t"><input type=checkbox id=chk13 runat=server ClientIDMode=Static /><i class="fa fa-gift fa-fw"></i><span>Cartes cadeaux (courriel)</span></div>
		<div>
			<label for="chk13">Envoi un courriel pour livraison instantané d'une <a href="<%= GiftCardUrl %>">carte cadeau</a> si payé en ligne.</label>	
		</div>
	</div>
    <div class=commType data-type=23 >
        <div class="t"><input type=checkbox id=chk23 runat=server ClientIDMode=Static /><i class="fa fa-gift fa-fw"></i><span>Cartes cadeaux (attachement PDF)</span></div>
        <div>
            PDF inclue dans le courriel (imprimable).
        </div>
    </div>
	<div >
		<div id=dialogEdit title="Éditeur de message" class="modal fade" >
	
		</div>
		
	</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script type="text/javascript">
		$(".t").append('<i class="fa fa-pencil-square edit"></i>');
		$('.commType .edit').click(function () {
			document.location = 'CommunicationEdit.aspx?id=' + this.parentElement.parentElement.getAttribute('data-type');
		});
		$(':checkbox').click(function (e) {
			var idMessage = this.parentNode.parentNode.getAttribute('data-type');
			$.ajax({ url: "AjaxCommunication.ashx?id=" + idMessage + "&action=enable&enable=" + (this.checked ? 'true' : 'false') });
			e.stopPropagation(); // prevent the client to open the edit dialog
		});

		
		$('#txtAbandonCartFor').change(function() {
			$.ajax({ url: "/<%=WebSite.Admin.Api.ApiSettings.Url %>?<%=WebSite.Admin.Api.ApiSettings.QueryStringKey%>=<%=Settings.AbandonCartNbHoursTag%>&<%=WebSite.Admin.Api.ApiSettings.QueryStringValue%>=" + $$('txtAbandonCartFor').value 
			}).fail(function (data) {
				if (data.Error) {
					alert(data.Error);
				}
			});
		});
	
    </script>
</asp:Content>
