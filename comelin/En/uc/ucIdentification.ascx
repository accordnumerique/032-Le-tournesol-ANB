<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucIdentification.ascx.cs" Inherits="WebSite.uc.ucIdentification" %>
<div class="col-12 col infosInscription">  
<div class="sectionInscription">
    <h2>Identification</h2>
    <div class="champsARemplir">
      <div class="row">
        <div class="col-6">
          <p class="infosCompte">First name</p>
          <asp:TextBox ID="txtFirstName" runat="server" ClientIDMode="Static" autocomplete="given-name"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqFirstName" Display="Dynamic" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First name is required" CssClass="valReq"></asp:RequiredFieldValidator>
        </div>
        <div class="col-6">
          <p class="infosCompte">Last name</p>
          <asp:TextBox ID="txtNom" runat="server" MaxLength="35" ClientIDMode="Static" autocomplete="family-name"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqLastName" Display="Dynamic" runat="server" ControlToValidate="txtNom" ErrorMessage="Last name is required" CssClass="valReq"></asp:RequiredFieldValidator>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Email</p>
          <asp:TextBox ID="txtEmail" runat="server" MaxLength="99" type="email" ClientIDMode="Static" autocomplete="email"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqEmail" Display="Dynamic" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="valReq"></asp:RequiredFieldValidator>
          <asp:RegularExpressionValidator ID="rRegExEmail" Display="Dynamic" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is invalid."></asp:RegularExpressionValidator>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Phone</p>
          <asp:TextBox ID="txtPhone" runat="server" MaxLength="99" type="tel" ClientIDMode="Static" autocomplete="tel"></asp:TextBox>
        </div>
      </div>
    </div>
  </div>
  <div class="sectionInscription" id="sectionPassword">
    <h2>Password</h2>
    <div class="champsARemplir">
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">New password</p>
          <asp:TextBox TextMode="Password" ClientIDMode="Static" ID="txtPassword" runat="server"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqPassword" Display="Dynamic" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="valReq"></asp:RequiredFieldValidator>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-6">
          <p class="infosCompte">Confirm password</p>
          <asp:TextBox TextMode="Password" ID="txtPasswordConfirm" ClientIDMode="Static" runat="server"></asp:TextBox>
          <asp:RequiredFieldValidator ID="valReqPasswordConfirm" Display="Dynamic" runat="server" ControlToValidate="txtPasswordConfirm" ErrorMessage="Email confirmation is required" CssClass="valReq"></asp:RequiredFieldValidator>
          <asp:CompareValidator ID="valReqPasswordSame" Display="Dynamic" runat="server" ControlToValidate="txtPasswordConfirm" CssClass="valReq" ControlToCompare="txtPassword" ErrorMessage="Password not identical"></asp:CompareValidator>
        </div>
      </div>

    </div>
  </div>
</div>