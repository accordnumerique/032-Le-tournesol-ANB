<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportDatabaseCubeCart.aspx.cs" Inherits="WebSite.Admin.PageImportDatabaseCubeCart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  <p>Importer base de donnée CubeCart</p>
  <p>&nbsp;</p>
  Base de donnée MySql
  <asp:TextBox ID="txtDatabaseName" runat="server"></asp:TextBox>
&nbsp;<asp:Button ID="cmdCheck" runat="server" OnClick="cmdCheck_Click" Text="Check" />
  <br />
</asp:Content>
