<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="LoginPage" Title="Login" CodeBehind="Login.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
	<h1>Mon compte</h1>
  <div class="row contentMonCompte page-login-2015">
    <div class="col-12">
      
      <h2>Vous avez déjà un compte?</h2>
      <p>Connectez-vous pour pouvoir enregistrer et partager votre liste de souhaits, faire des achats en ligne, et encore plus!</p>
      <div class="row champsARemplir">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Adresse courriel</p>
          <asp:TextBox ID="txtEmail" runat="server" AutoCompleteType="Email" ClientIDMode="Static" ></asp:TextBox>
          <p class="infosCompte">Mot de passe</p>
          <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" ClientIDMode="Static" ></asp:TextBox>
          <div class="forgotPassword text-right"><a href="Mot-Passe-Oublie.aspx">Mot de passe oublié?</a></div>
          <asp:Button ID="cmdLoggin" runat="server" CssClass="btn btn-primary" ClientIDMode="Static" Text="Se connecter" OnClick="cmdLoggin_Click" ValidationGroup="groupLogin" />
        </div>
      </div>
      <h2>Vous êtes un nouveau client?</h2>
      <p>Créez-vous un compte afin de pouvoir enregistrer vos informations de compte, votre liste de souhaits, effectuer des achats en ligne. et encore plus!</p>
      <a href="Inscription.aspx" class="btn btn-primary">S'inscrire</a>
    </div>
  </div>
</asp:Content>
