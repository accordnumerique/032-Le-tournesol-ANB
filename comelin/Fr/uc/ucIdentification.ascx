<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucIdentification.ascx.cs" Inherits="WebSite.uc.ucIdentification" %>
<div class="col-12 col infosInscription">
  <div class="sectionInscription">
    <h2>Identification</h2>
    <div class="champsARemplir">
      <div class="row">
        <div class="col-6">
          <p class="infosCompte">Prénom</p>
          <asp:TextBox ID="txtFirstName" runat="server" ClientIDMode="Static" autocomplete="given-name"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqFirstName" Display="Dynamic" runat="server" ControlToValidate="txtFirstName" ErrorMessage="Le prénom est requis" CssClass="valReq"></asp:RequiredFieldValidator>
        </div>
        <div class="col-6">
          <p class="infosCompte">Nom</p>
          <asp:TextBox ID="txtNom" runat="server" MaxLength="35" ClientIDMode="Static" autocomplete="family-name"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqLastName" Display="Dynamic" runat="server" ControlToValidate="txtNom" ErrorMessage="Le nom est requis" CssClass="valReq"></asp:RequiredFieldValidator>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Courriel</p>
          <asp:TextBox ID="txtEmail" runat="server" MaxLength="99" type="email" ClientIDMode="Static" autocomplete="email"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqEmail" Display="Dynamic" runat="server" ControlToValidate="txtEmail" ErrorMessage="Le courriel est requis" CssClass="valReq"></asp:RequiredFieldValidator>
          <asp:RegularExpressionValidator ID="rRegExEmail" Display="Dynamic" runat="server" ControlToValidate="txtEmail" ErrorMessage="Le courriel est invalide."></asp:RegularExpressionValidator>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Téléphone</p>
          <asp:TextBox ID="txtPhone" runat="server" MaxLength="99" type="tel" ClientIDMode="Static" autocomplete="tel"></asp:TextBox>
        </div>
      </div>
    </div>
  </div>
  <div class="sectionInscription" id="sectionPassword">
    <h2>Mot de passe</h2>
    <div class="champsARemplir">
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Nouveau mot de passe</p>
          <asp:TextBox TextMode="Password" ClientIDMode="Static" ID="txtPassword" runat="server"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqPassword" Display="Dynamic" runat="server" ControlToValidate="txtPassword" ErrorMessage="Le mot de passe est requis" CssClass="valReq"></asp:RequiredFieldValidator>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Confirmer le mot de passe</p>
          <asp:TextBox TextMode="Password" ID="txtPasswordConfirm" ClientIDMode="Static" runat="server"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqPasswordConfirm" Display="Dynamic" runat="server" ControlToValidate="txtPasswordConfirm" ErrorMessage="La confirmation du mot de passe est requise" CssClass="valReq"></asp:RequiredFieldValidator>
          <asp:CompareValidator ID="valReqPasswordSame" Display="Dynamic" runat="server" ControlToValidate="txtPasswordConfirm" CssClass="valReq" ControlToCompare="txtPassword" ErrorMessage="mot de passe non identique"></asp:CompareValidator>
        </div>
      </div>

    </div>
</div>
</div>