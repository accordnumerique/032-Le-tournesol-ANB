<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="MP.Master" AutoEventWireup="true" Inherits="WebSite.POS_Caisse" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <h1>Checkout</h1>
    <div class="boxWithHeader section-identification">
      <h3>Identification</h3>
      <div class="lines">
        <div class="line">
          <label for="fname">First name: </label>
          <asp:TextBox ID="fname" placeholder="First name" runat="server" MaxLength="35"  ClientIDMode="Static" autocomplete="given-name"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="fname" ErrorMessage="First name is required" CssClass="valReq">required</asp:RequiredFieldValidator>
        </div>
        <div class="line">
          <label for="lname">Last name: </label>
          <asp:TextBox ID="lname" placeholder="Last name" runat="server" MaxLength="35"  ClientIDMode="Static" autocomplete="family-name"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="lname" ErrorMessage="Last name is required" CssClass="valReq">required</asp:RequiredFieldValidator>
        </div>
        <div class="line login-or-email">
          <label for="email">Email:</label>
          <asp:TextBox ID="email" placeholder="Email" runat="server" MaxLength="99"  type="email" ClientIDMode="Static" autocomplete="email"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="email" ErrorMessage="Email is required" CssClass="valReq">required</asp:RequiredFieldValidator>
          <asp:RegularExpressionValidator Display="Dynamic" ID="rRegExEmail" runat="server" ControlToValidate="email" ErrorMessage="Le courriel est invalide.">Invalide</asp:RegularExpressionValidator>
        </div>
  <div class="line" id="email-in-use" class="account-management">
				<label>Optional! It seems you already have an account. Password:</label>
				<input type="password" id="password-already-account" placeholder="password" data-content="Wrong password" />
				<button class="btn btn-default" id="btn-connect-already-account" >Sign in</button>
  <div class="btn btn-info" onclick="LostPassword(this)" title="Re-initialized your password" 
					  data-content="An email has been send. The password is optional, you can fill the form again to send your order.">Mot de passe oublié?</div>
			  </div>
        <div class="line">
          <label for="phone">Phone:</label>
          <asp:TextBox ID="phone" placeholder="Phone" runat="server" MaxLength="20"  ClientIDMode="Static" autocomplete="tel" type="tel"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="phone" ErrorMessage="Phone is required" CssClass="valReq">required</asp:RequiredFieldValidator>
        </div>
		<div class="line" runat="server" Visible="False">
          <label for="phone">Cell:</label>
          <asp:TextBox ID="txtCell" placeholder="Cell" runat="server" MaxLength="20"  ClientIDMode="Static" autocomplete="tel" type="tel"></asp:TextBox>
        </div>
      </div>
    </div>
    <div class="boxWithHeader section-billing-address">
      <h3>Billing Address</h3>
      <div class="lines">
        <div class="line">
          <label for="txtAddress1">Address: </label>
          <asp:TextBox ID="txtAddress1" placeholder="Address" ClientIDMode="Static" runat="server" MaxLength="40" autocomplete="street-address"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="txtAddress1" ErrorMessage="Address is required" CssClass="valReq">required</asp:RequiredFieldValidator>
        </div>
        <div class="line line-address-2" runat="server">
          <label for="txtAddress2"></label>
          <asp:TextBox ID="txtAddress2" placeholder="Appartement" ClientIDMode="Static" runat="server" MaxLength="40"></asp:TextBox>
        </div>
        <div class="line">
          <label for="txtCity">City:</label>
          <asp:TextBox ID="txtCity" placeholder="City" runat="server" ClientIDMode="Static" MaxLength="30" autocomplete="address-level2"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="txtCity" ErrorMessage="City is required" CssClass="valReq">required</asp:RequiredFieldValidator>
        </div>
        <div class="line">
          <label for="zip">Zip/Postal Code:</label>
          <asp:TextBox ID="zip" placeholder="Zip/Postal Code" runat="server" MaxLength="13" ClientIDMode="Static" autocomplete="postal-code"></asp:TextBox>
          <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="zip" ErrorMessage="Zip/Postal Code is required" CssClass="valReq">required</asp:RequiredFieldValidator>
        </div>
        <div class="line">
          <label>Country/Province:</label>
           <div class="country-province">
			<select id="lstCountry" class="bfh-countries" data-country="<%= Country %>" data-countryList="CA,US"></select>
			<select id="lstProvince" class="bfh-states" data-country="lstCountry" data-state="<%= Province %>"></select></div>
            <asp:CustomValidator runat="server" CssClass="valReq" ClientValidationFunction="validateProvince">required</asp:CustomValidator>
        </div>
      </div>
    </div>
    <div class="boxWithHeader shipping"  runat="server" id="sectionShipping">
      <h3>Shipping address</h3>
      <div>
<div><asp:RadioButton ID="radShippingAddressSame" GroupName="shippingAddress" ClientIDMode="Static" Checked="true" Text="Ship to billing address" runat="server" /></div>
        <div><asp:RadioButton ID="radShippingAddressDifferent" GroupName="shippingAddress" ClientIDMode="Static" Text="Ship to a different address" runat="server" /></div>
        <div id="divShippingAddress" style="display: none" class="lines">
          <div class="line">
            <label for="txtShipAddress1">Address:</label>
            <asp:TextBox ID="txtShipAddress1" placeholder="Address" ClientIDMode="Static" runat="server" MaxLength="40" autocomplete="shipping street-address"></asp:TextBox>
          </div>
		  <div class="line line-address-2" runat="server">
            <label for="txtShipAddress2"></label>
            <asp:TextBox ID="txtShipAddress2" placeholder="Appartement" ClientIDMode="Static" runat="server" MaxLength="40"></asp:TextBox>
          </div>
          <div class="line">
            <label for="txtShipCity">City:</label>
            <asp:TextBox ID="txtShipCity" placeholder="City" ClientIDMode="Static" runat="server" MaxLength="30" autocomplete="shipping address-level2"></asp:TextBox><br />
          </div>
          <div class="line">
            <label for="txtShipPostalCode">Zip/Postal Code:</label>
            <asp:TextBox ID="txtShipPostalCode" placeholder="Zip/Postal Code" ClientIDMode="Static" runat="server" MaxLength="13" autocomplete="shipping postal-code"></asp:TextBox><br />
          </div>
          <div class="line">
            <label>Country/Province:</label>
        <div class="country-province">
			<select id="lstShipCountry" class="bfh-countries" data-country="<%= ShipCountry %>" data-countryList="CA,US"></select>
			<select id="lstShipProvince" class="bfh-states" data-country="lstShipCountry" data-state="<%= ShipProvince %>"></select>
            <asp:CustomValidator runat="server" CssClass="valReq" ClientValidationFunction="validateProvinceShipping">required</asp:CustomValidator>
					  </div>
          </div>
        </div>
      </div>
    </div>
    <div class="boxWithHeader account-management" id="divCreateAccount" runat="server" ClientIDMode="Static">
      <h3><input id="chkCreateAccount" type="checkbox" /><label for="chkCreateAccount">I would like to create an account for the next purchase</label></h3>
      <div style="display: none" id="divCreateAccountInner">
        <div class="lines">
          <div class="line">
            <label>Password:</label><asp:TextBox TextMode="Password" placeholder="Password" ClientIDMode="Static" ID="txtPassword" runat="server"></asp:TextBox>
          </div>
          <div class="line">
            <label>Password confirmation:</label><asp:TextBox TextMode="Password" ID="txtPasswordConfirm" ClientIDMode="Static" placeholder="Password confirmation" runat="server"></asp:TextBox>
            <asp:CompareValidator Display="Dynamic" runat="server" ControlToValidate="txtPasswordConfirm" CssClass="valReq" ControlToCompare="txtPassword" ErrorMessage="password not identical"></asp:CompareValidator>
          </div>
        </div>
      </div>
    </div>
    <div runat="server" id="divReferral">
      <div class="boxWithHeader">
        <h3>How did you found us?</h3>
        <div>
          <asp:DropDownList ID="lstReferal" runat="server">
            <asp:ListItem Text="specify..."> </asp:ListItem>
          </asp:DropDownList>
          <br />
          <br />
          Other: <asp:TextBox ID="txtReferal" runat="server"></asp:TextBox>
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
		<asp:Button ID="cmdComplete" CssClass="btn btn-primary btn-lg" ClientIDMode="Static" runat="server" OnClick="cmdComplete_Click" Text="Payment" />
		<asp:ValidationSummary style="clear:both" id="ValidationSummary1" runat="server"  HeaderText="Erreurs:"> </asp:ValidationSummary>
	</div>  
  </div>
  

</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
	<script src="../js/bootstrap-formhelpers.min.js"></script>
	
  <script src="/js/pos_caisse.js?v=8" type="text/javascript"></script>
</asp:Content>
