<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="fr_Account" Title="Customer Account"  %>

<%@ Register Src="uc/ucIdentification.ascx" TagPrefix="uc1" TagName="ucIdentification" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
	<div class="pageMonCompte col-12">
  <h1><%= CustomerName %></h1>
	  <div class="row">
    <uc1:ucIdentification runat="server" ID="ucIdentification" />
    <div class="col-12">
      <h2>Preference</h2>
      <div>
        <h4>Receive the newsletter:</h4>
      <asp:CheckBox ID="chkNewsletter" Text="I would like to received annoucements and promotions." runat="server" Checked="True" /><br />
					<br />
				</div>
<asp:Button ID="cmdModify" runat="server" CssClass="btn btn-primary" Text="Modify customer account" OnClick="cmdModify_Click" />
      </div>
  </div>
  <div class="panel panel-default" id="panelPOs">
    <div class="panel-heading">Order placed</div>
    <div class="panel-body" runat="server" id="lblNoReservations">
      <p>No orders</p>
    </div>
    <%= Reservations  %>
  </div>

    <div class="panel panel-default">
    <div class="panel-heading">Historical orders</div>
    <div class="panel-body" runat="server" id="lblNoCompletedOrders">
      <p>No completed orders</p>
    </div>

    <%= CompletedOrders  %>
  </div>
  </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
  <script src="/js/bsasper.js"></script>
  <script>
    $(function () {
      $("input").bsasper();
    });
  </script>
</asp:Content>