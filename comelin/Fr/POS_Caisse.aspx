<%@ Page Title="Panier d'achat" Language="C#" MasterPageFile="MP.Master" AutoEventWireup="true" Inherits="WebSite.POS_Caisse" CodeBehind="POS_Caisse.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <h1>Caisse</h1>
    <div class="boxWithHeader section-identification">
      <h3>Identification</h3>
      <div class="lines">
        <div class="line">
          <label for="fname">Prénom: </label>
          <asp:TextBox ID="fname" placeholder="Prénom" runat="server" MaxLength="35" ClientIDMode="Static" autocomplete="given-name"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic"  runat="server" ControlToValidate="fname" ErrorMessage="Le prénom est requis" CssClass="valReq">requis</asp:RequiredFieldValidator>
        </div>
        <div class="line">
          <label for="lname">Nom: </label>
          <asp:TextBox ID="lname" placeholder="Nom" runat="server" MaxLength="35" ClientIDMode="Static" autocomplete="family-name"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic"  runat="server" ControlToValidate="lname" ErrorMessage="Le nom est requis" CssClass="valReq">requis</asp:RequiredFieldValidator>
        </div>
		  <div class="line login-or-email">
			  <label for="email">Courriel:</label>
			  <asp:TextBox ID="email" placeholder="Courriel" runat="server" MaxLength="99" type="email" ClientIDMode="Static" autocomplete="email"></asp:TextBox>
			  <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="email" ErrorMessage="Le courriel est requis" CssClass="valReq">requis</asp:RequiredFieldValidator>
			  <asp:RegularExpressionValidator Display="Dynamic" ID="rRegExEmail" runat="server" ControlToValidate="email" ErrorMessage="Le courriel est invalide.">Invalide</asp:RegularExpressionValidator>
		  </div>
		  <div class="line account-management" id="email-in-use">
			  <label><b>Optionnel!</b> &nbsp; Il semble vous avez déjà un compte.<br>Mot de passe:</label>
				<input type="password" id="password-already-account" placeholder="mot de passe" data-content="Mot de passe incorrect" />
				<button class="btn btn-info" id="btn-connect-already-account" >Se connecter</button> 
				  <div class="btn btn-default" onclick="LostPassword(this)" title="Réinitialisation de votre mot de passe" 
					  data-content="Un courriel vous a été envoyé. Le mot de passe est optionnel, vous pouvez entrer de nouveau vos informations pour passer votre commande.">Mot de passe oublié?</div>
		  </div>
        <div class="line">
          <label for="phone">Téléphone:</label>
          <asp:TextBox ID="phone" placeholder="Téléphone" runat="server" MaxLength="20" ClientIDMode="Static" autocomplete="tel" type="tel"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic"  runat="server" ControlToValidate="phone" ErrorMessage="Le numéro de téléphone est requis" CssClass="valReq">requis</asp:RequiredFieldValidator>
        </div>
		<div class="line" runat="server" Visible="False">
          <label for="phone">Cell:</label>
          <asp:TextBox ID="txtCell" placeholder="Cellullaire" runat="server" MaxLength="20" ClientIDMode="Static" autocomplete="tel" type="tel"></asp:TextBox>
        </div>
      </div>
    </div>
    <div class="boxWithHeader section-billing-address">
      <h3>Adresse de facturation</h3>
      <div class="lines">
        <div class="line">
          <label for="txtAddress1">Adresse: </label>
          <asp:TextBox ID="txtAddress1" placeholder="Adresse" ClientIDMode="Static" runat="server" MaxLength="40" autocomplete="street-address"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic"  runat="server" ControlToValidate="txtAddress1" ErrorMessage="L'adresse est requise" CssClass="valReq">requis</asp:RequiredFieldValidator>
        </div>
<div class="line line-address-2" runat="server">
          <label for="txtAddress2"></label>
          <asp:TextBox ID="txtAddress2" placeholder="Appartement" ClientIDMode="Static" runat="server" MaxLength="40"></asp:TextBox>
        </div>
        <div class="line">
          <label for="txtCity">Ville:</label>
          <asp:TextBox ID="txtCity" placeholder="Ville" runat="server" ClientIDMode="Static" MaxLength="30" autocomplete="address-level2"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic"  runat="server" ControlToValidate="txtCity" ErrorMessage="La ville est requise" CssClass="valReq">requis</asp:RequiredFieldValidator>
        </div>
        <div class="line">
          <label for="zip">Code postal:</label>
          <asp:TextBox ID="zip" placeholder="Code postal" runat="server" MaxLength="13" ClientIDMode="Static" autocomplete="postal-code"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic"  runat="server" ControlToValidate="zip" ErrorMessage="Le code postal est requis" CssClass="valReq">requis</asp:RequiredFieldValidator>
        </div>   
		 <div class="line">
          <label>Pays/Province:</label>
			 <div class="country-province">
			<select id="lstCountry" class="bfh-countries" data-country="<%= Country %>" data-countryList="CA"></select>
			<select id="lstProvince" class="bfh-states" data-country="lstCountry" data-state="<%= Province %>"></select></div>
             <asp:CustomValidator runat="server" CssClass="valReq" ClientValidationFunction="validateProvince">requis</asp:CustomValidator>
        </div>
      </div>
    </div>
    <div class="boxWithHeader shipping" runat="server" id="sectionShipping">
      <h3>Adresse de livraison</h3>
      <div>
	     <div><asp:RadioButton ID="radShippingAddressSame" GroupName="shippingAddress" ClientIDMode="Static" Checked="true" Text="Livrer à l'adresse de facturation" runat="server" /></div> 
		 <div><asp:RadioButton ID="radShippingAddressDifferent" GroupName="shippingAddress" ClientIDMode="Static" Text="Livrer à une adresse différente" runat="server" /></div>
        <div id="divShippingAddress" style="display: none" class="lines">
          <div class="line">
            <label for="txtShipAddress1">Adresse:</label>
            <asp:TextBox ID="txtShipAddress1" placeholder="Adresse" ClientIDMode="Static" runat="server" MaxLength="40" autocomplete="shipping street-address"></asp:TextBox>
          </div>
		  <div class="line line-address-2" runat="server">
            <label for="txtShipAddress2"></label>
            <asp:TextBox ID="txtShipAddress2" placeholder="Appartement"  ClientIDMode="Static" runat="server" MaxLength="40"></asp:TextBox>
          </div>
          <div class="line">
            <label for="txtShipCity">Ville:</label>
            <asp:TextBox ID="txtShipCity" placeholder="Ville" ClientIDMode="Static" runat="server" MaxLength="30" autocomplete="shipping address-level2"></asp:TextBox><br />
          </div>
          <div class="line">
            <label for="txtShipPostalCode">Code Postal:</label>
            <asp:TextBox ID="txtShipPostalCode" placeholder="Code Postal" ClientIDMode="Static" runat="server" MaxLength="13" autocomplete="shipping postal-code"></asp:TextBox><br />
          </div>
			 <div class="line">
          <label>Pays/Province:</label>
				  <div class="country-province">
			<select id="lstShipCountry" class="bfh-countries" data-country="<%= ShipCountry %>" data-countryList="CA"></select>
			<select id="lstShipProvince" class="bfh-states" data-country="lstShipCountry" data-state="<%= ShipProvince %>"></select>
                      <asp:CustomValidator runat="server" CssClass="valReq" ClientValidationFunction="validateProvinceShipping">requis</asp:CustomValidator>
					  </div>
		  </div>
        </div>
      </div>
    </div>
	 <div class="boxWithHeader account-management" id="divCreateAccount" runat="server" ClientIDMode="Static" >
      <h3><input id="chkCreateAccount" type="checkbox" /><label for="chkCreateAccount">Je veux me créer un compte client</label></h3>
      <div style="display: none" id="divCreateAccountInner">
        <div class="lines">
          <div class="line">
            <label>Mots de passe:</label><asp:TextBox TextMode="Password" placeholder="Mots de passe" ClientIDMode="Static" ID="txtPassword" runat="server"></asp:TextBox>
          </div>
          <div class="line">
            <label>Ré-écrire le mot de passe:</label><asp:TextBox TextMode="Password" ID="txtPasswordConfirm" ClientIDMode="Static" placeholder="Ré-écrire le mot de passe" runat="server"></asp:TextBox>
            <asp:CompareValidator Display="Dynamic" runat="server" ControlToValidate="txtPasswordConfirm" CssClass="valReq" ControlToCompare="txtPassword" ErrorMessage="mot de passe non identique"></asp:CompareValidator>
          </div>
        </div>
      </div>
    </div>
    <div runat="server" id="divReferral">
      <div class="boxWithHeader">
        <h3>Comment nous avez-vous connu?</h3>
        <div>
          <asp:DropDownList ID="lstReferal" runat="server">
            <asp:ListItem Text="spécifier..." Value="0"> </asp:ListItem>
          </asp:DropDownList>
          <br />
          <br />
          Autre:<asp:TextBox ID="txtReferal" runat="server"></asp:TextBox>
        </div>
      </div>
    </div>
	<div class="boxWithHeader note">
    <h3 id=titleNotes><h>NotesAndComments</h></h3>
    <asp:TextBox ID="txtComment" ClientIDMode="Static" runat="server" TextMode="MultiLine" Rows="4"></asp:TextBox>
	</div>
  <br style="clear: both" />
  <br />
  <%= SessionVariable.CurrentOrder.CartSummaryHtml %>
  <br />
  <div class="row" id="rowPayment">
	<div class="col align-self-end">
		<asp:Button ID="cmdComplete" CssClass="btn btn-primary btn-lg" ClientIDMode="Static" runat="server" OnClick="cmdComplete_Click" Text="Payer" />
		<asp:ValidationSummary style="clear:both" id="ValidationSummary1" runat="server"  HeaderText="Erreurs:"> </asp:ValidationSummary>
	</div>  
  </div>
    

</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
	<script src="/js/bootstrap-formhelpers-fr.min.js"></script>
	
  <script src="/js/pos_caisse.js?v=8" type="text/javascript"></script>
</asp:Content>