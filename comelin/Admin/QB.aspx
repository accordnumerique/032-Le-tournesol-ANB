<%@ Page Title="Integration avec Quickbooks Online" Async="true" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="QB.aspx.cs" Inherits="WebSite.Admin.QB" %>
<%@ Register Src="~/Admin/ucDateRangePicker.ascx" TagPrefix="uc1" TagName="ucDateRangePicker" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		.qbdate {background-color: lightyellow; padding: 10px; margin: 5px; font-weight: bold;display: inline-block}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
		<% if (AutoData.AccessToken != null) {
				Response.Write(@"<script> 
if (window.opener) {
	window.opener.location.reload();
	window.close();
}</script>");
			}
    %>
	<h3>Integration avec Quickbooks Online</h3>
		<div id="connect" runat="server" visible="false">
			<asp:ImageButton ID="btnC2QB" runat="server" AlternateText="Connect to Quickbooks" ImageUrl="Images/QuickbooksConnect.png" OnClick="ImgC2QB_Click" />
		</div>
		<div id="divConnected" runat="server" visible="false">
			<div style="float: right"><asp:Button ID="btnRevoke" runat="server" Text="Déconnexion" OnClick="ImgRevoke_Click" /></div>
			<p>
				<asp:Label runat="server" ID="lblConnected" Visible="false">"Vous êtes connecter à Quickbooks Online!"</asp:Label>
			</p>
            <asp:DropDownList runat="server" ID="lstStore" ClientIDMode="Static"/>
			<uc1:ucDateRangePicker runat="server" ID="ucDates" />
			<br />
			<br />
			<asp:Button ID="cmdSync" runat="server" OnClick="cmdSync_Click" CssClass="btn-warning" Text="Synchroniser le journal" />
&nbsp;<br />
			<br />
			<p>
				<asp:Label runat="server" ID="lblQBOCall" Visible="false"></asp:Label>
			</p>
			<p>
				<asp:Literal ID="txtLog" runat="server"></asp:Literal>
			</p>
		</div>
</asp:Content>
