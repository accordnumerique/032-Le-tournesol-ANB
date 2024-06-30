<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="fr_Confirmation" Title="Order confirmed" Codebehind="Confirmation.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" Runat="Server">
  <div id="page-confirmation">
<h1>Order Confirmed</h1>
	  <div style="text-align:center">A copy will also be sent by email</div><br/>
  <asp:Literal ID=lblLastOrderConfirmation runat="server" EnableViewState=false></asp:Literal>
<br />
	<div class="container">
		<a class="btn btn-primary" href="./" >Return to web site</a>		
	</div>
</div>
</asp:Content>
