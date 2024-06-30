<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="fr_Confirmation" Title="Confirmation d'une commande" Codebehind="Confirmation.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" Runat="Server">
<div id="page-confirmation">
  <h1>Confirmation de la commande</h1>
<div style="text-align:center">Une copie vous sera également transmise par courriel</div><br>
  <asp:Literal ID=lblLastOrderConfirmation runat="server" EnableViewState=false></asp:Literal>
<br />
	<div class="container">
		<a class="btn btn-primary" href="./" >Retourner au site web</a>		
	</div>
</div>
</asp:Content>