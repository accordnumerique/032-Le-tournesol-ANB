<%@ Page Language="C#" MasterPageFile="~/fr/MP.master" AutoEventWireup="true" Inherits="WebSite.Unsubscribe" 
Title="Se désabonner / Unsubscribe" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
<div>
     <asp:Label ID="lblName" runat="server"></asp:Label><br />
      <asp:Label ID="lblEmail" runat="server"></asp:Label><br />
      <br />
      <asp:Label ID="lblUnsubscribe" runat="server" Text="Vous êtes maintenant désinscris au Journal.</br>You are now unsubscribe to the newsletter." Visible="False"></asp:Label>
      <br />
      <br />
      <asp:Label ID="lblNotSubscribe" runat="server" Text="Vous n'êtes pas inscrite au Journal.<br />You are not subscribe to the newsletter." Visible="False"></asp:Label>
      <br />
      <br />
      
      </div>
</asp:Content>