<%@ Page Title="Password Reset / Change" Language="C#" MasterPageFile="MP.Master" AutoEventWireup="true" Inherits="WebSite.Fr.Password_Change" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  <h2>
    Change your password</h2>
  <p>
    New Password:</p>
  <p>
    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
    <asp:RequiredFieldValidator ID="RequiredFieldValidatorPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic"
      ErrorMessage="Password is required.">*</asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtPassword" Display="Dynamic"
      ErrorMessage="Password must be a minimun of 5 caracters" ValidationExpression="\w{5,60}" Font-Size="Small" /></p>
  <p>
    &nbsp;</p>
  <p>
    Password Confirmation:<br />
    <asp:TextBox ID="txtPasswordConfirm" runat="server" TextMode="Password"></asp:TextBox>
    <asp:RequiredFieldValidator ID="RequiredFieldValidatorConfirmPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic">*</asp:RequiredFieldValidator>
    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtPasswordConfirm"
      Display="Dynamic" ErrorMessage="Password mismatch" Font-Size="Small"></asp:CompareValidator>
				</p>
  <p>
    &nbsp;</p>
  <p>
<asp:Button ID="cmdSave" runat="server" CssClass="button" OnClick="cmdSave_Click" Text="Save" />
  </p>
  <p>
    &nbsp;</p>
  <p>
    <asp:Literal ID="lblErrorCode" runat="server" Text="Invalid code or already to change password." 
      Visible="False"></asp:Literal> 
  </p>

</asp:Content>
