<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="LoginPage" Title="Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">

  <div class="row contentMonCompte page-login-2015">
    <div class="col-12">
      <h1>My Account</h1>
      <h2>Already have an account?</h2>
      <p>Register to manage and share your wishlist, shop online and even more!</p>
      <div class="row champsARemplir">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Email</p>
          <asp:TextBox ID="txtEmail" runat="server" AutoCompleteType="Email" ClientIDMode="Static" ></asp:TextBox>
          &nbsp;<p class="infosCompte">Password</p>
          <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" ClientIDMode="Static" ></asp:TextBox>
          <div class="forgotPassword text-right"><a href="Mot-Passe-Oublie.aspx">Forgot Password?</a></div>
          <asp:Button ID="cmdLoggin" runat="server" CssClass="btn btn-primary" ClientIDMode="Static" Text="Connect" OnClick="cmdLoggin_Click" ValidationGroup="groupLogin" />
        </div>
      </div>
      <h2>New Customer?</h2>
      <a href="Inscription.aspx" class="btn btn-primary">Register</a>
  </div>
  </div>
</asp:Content>
