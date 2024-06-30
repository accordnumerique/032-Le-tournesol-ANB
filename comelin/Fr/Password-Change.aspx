<%@ Page Title="Changement de mots de passe" Language="C#" MasterPageFile="~/Fr/MP.Master" AutoEventWireup="true" Inherits="WebSite.Fr.Password_Change" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  <h1>
    Changement de votre mot de passe</h1>
  <p>
    Nouveau mot de passe:</p>
  <p>
				<asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
				<asp:RequiredFieldValidator ID="RequiredFieldValidatorPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic" ErrorMessage="Le mot de passe est requis.">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtPassword"  Display="Dynamic" ErrorMessage="Le mot de passe doit avoir un minimun de 5 caractères"
					ValidationExpression="\w{5,60}" Font-Size="Small"></asp:RegularExpressionValidator></p>
  <p>
    &nbsp;</p>
  <p>
    Confirmation du mot de passe:<br />
				<asp:TextBox ID="txtPasswordConfirm" runat="server" TextMode="Password"></asp:TextBox>
				<asp:RequiredFieldValidator ID="RequiredFieldValidatorConfirmPassword" runat="server" ControlToValidate="txtPassword" Display="Dynamic" >*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtPasswordConfirm"  Display="Dynamic" 
					ErrorMessage="Les mots de passe doivent correspondre" Font-Size="Small"></asp:CompareValidator>
				</p>
  <p>
    &nbsp;</p>
  <p>
    <asp:Button ID="cmdSave" runat="server" CssClass="button" onclick="cmdSave_Click" Text="Sauvegarder" />
				</p>
  <p>
    &nbsp;</p>
  <p>
    <asp:Literal ID="lblErrorCode" runat="server" Text="Code invalide ou déjà utilisé pour changer le mot de passe." 
      Visible="False"></asp:Literal>
				</p>

</asp:Content>
