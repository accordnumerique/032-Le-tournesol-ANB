<%@ Page Language="C#" MasterPageFile="MP.master" AutoEventWireup="true" Inherits="ForgotPasswordPage" Title="Lost Password?" CodeBehind="Mot-Passe-Oublie.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
  <div class="row page-forgot-password contentMonCompte contentMotPasseOublie">
    <div class="col-12">
      <h1>Lost password</h1>
      <h2>Did you forgot your password?</h2>
      <p>Write the associated email address with your account and an email with instruction will be send to you.</p>
      <div class="row champsARemplir">
        <div class="col-12 col-sm-4">
          <p class="infosCompte">Email</p>
          <asp:TextBox ID="txtPasswordRecovery" runat="server" Width="218px" ValidationGroup="groupReset"></asp:TextBox>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPasswordRecovery" ErrorMessage="*"
            ValidationGroup="groupReset" />
          <br />
          <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtPasswordRecovery" Display="Dynamic"
            ErrorMessage="Invalid format" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="groupReset"></asp:RegularExpressionValidator>
          <asp:Button ID="cmdLostPassword" runat="server" CssClass="btn btn-primary" Text="Send" Width="250px" OnClick="cmdRecuperatePassword_Click"
            ValidationGroup="groupReset" />
        </div>
      </div>
    </div>
  </div>
</asp:Content>
