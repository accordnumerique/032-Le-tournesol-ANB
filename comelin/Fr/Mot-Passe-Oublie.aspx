<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="ForgotPasswordPage" Title="Mot de passe perdu?" CodeBehind="Mot-Passe-Oublie.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
	<h1>Mot de passe oublié</h1>
  <div class="row page-forgot-password contentMonCompte contentMotPasseOublie">
    <div class="col-12">
      
      <h2>Vous avez perdu votre mot de passe ?</h2>
      <p>Inscrivez l’adresse courriel associée à votre compte dans le champ ci-dessous, nous vous ferons parvenir les informations de votre compte par courriel.</p>
      <div class="row champsARemplir">
        <div class="col-12 col-sm-4">
          <p class="infosCompte">Adresse courriel</p>
          <asp:TextBox ID="txtPasswordRecovery" runat="server" Width="218px" ValidationGroup="groupReset"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPasswordRecovery" ErrorMessage="*"
            ValidationGroup="groupReset" />
          <br />
          <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtPasswordRecovery" Display="Dynamic"
            ErrorMessage="Format Invalide" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="groupReset"></asp:RegularExpressionValidator>
          <asp:Button ID="cmdLostPassword" runat="server" CssClass="btn btn-primary" Text="Envoyer" Width="250px" OnClick="cmdRecuperatePassword_Click"
            ValidationGroup="groupReset" />
        </div>
      </div>
    </div>
  </div>
</asp:Content>
