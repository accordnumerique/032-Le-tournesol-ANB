<%@ Page Title="Effacement d'un point de vente / odinateur" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="POSDelete.aspx.cs" Inherits="WebSite.Admin.POS_Delete" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<p>
		Effacement d&#39;un ordinateur / point de vente:</p>
	<p>
		1. Choisir le magasin:</p>
	<p>
		<asp:DropDownList ID="lstStore" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstStore_SelectedIndexChanged">
		</asp:DropDownList>
	</p>
	2. Choisir le point de vente&nbsp; / ordinateur qui sera supprimé<br />
	<asp:DropDownList ID="lstPosToDelete" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstPosToDelete_SelectedIndexChanged">
	</asp:DropDownList>
	<br />
	<br />
	3. Choisir le point de vente / ordinateur qui remplace (aura les transactions assignées)<br />
	<asp:DropDownList ID="lstPOSTOReplace" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstPOSTOReplace_SelectedIndexChanged">
	</asp:DropDownList>
	<br />
	<br />
	<asp:Button ID="cmdDelete" runat="server" OnClick="cmdDelete_Click" Text="Supprimer" />
	<br />
</asp:Content>
