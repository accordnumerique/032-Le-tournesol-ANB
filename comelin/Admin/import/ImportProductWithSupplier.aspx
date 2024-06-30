<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportProductWithSupplier.aspx.cs" Inherits="WebSite.Admin.onetime.ImportProductWithSupplier" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	Import product<br />
	<asp:FileUpload ID="file" runat="server" />
	<br />
<br />
<asp:CheckBox ID="chkUtf8" runat="server" Text="UTF-8" />
	<br />
<asp:CheckBox ID="chkInventory" runat="server" Text="Replace Inventory" Checked="True" />
	<br />
<br />
<asp:Button ID="cmdImport" runat="server" OnClick="cmdImport_Click" Text="Importer" />
</asp:Content>
