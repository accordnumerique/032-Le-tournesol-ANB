<%@ Page Title="Rapport quantité vendu" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ReportQty.aspx.cs" Inherits="WebSite.Admin.ReportByAttrib" EnableViewState="false" %>
<%@ Register src="ucDateRangePicker.ascx" tagname="ucDateRangePicker" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script type="text/javascript">
		google.charts.load('current', {'packages':['corechart']});
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img alt="" src="images/attribut.png" />Rapport quantité vendu</h1>
	
	<p>Regrouper par
		<asp:DropDownList ID="lstAttrib1" runat="server" ClientIDMode="Static">
		</asp:DropDownList>
	</p>
	<asp:CheckBox ID="chkGroupByStore" runat="server" Text="Regrouper par magasin" ClientIDMode="Static" /><br/>
	<asp:CheckBox ID="chkGroupByBrand" runat="server" Text="Regrouper par marque" ClientIDMode="Static" /><br/>
	<asp:CheckBox ID="chkGroupByProductType" runat="server" Text="Regrouper par type de produits" ClientIDMode="Static" /><br/>
	<uc1:ucDateRangePicker ID="ucDateRangePicker1" runat="server" />
	<br/>
	<br/>
	<%= Result %>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		function GetUrl() {
			var url = document.location.href;
			url = updateURLParameter(url, "from", $$("from").value);
			url = updateURLParameter(url, "to", $$("to").value);
			var byStore = $$("chkGroupByStore");
			if (byStore) {
				url = updateURLParameter(url, "group-by-store", byStore.checked);
			}
			url = updateURLParameter(url, "group-by-brand", $$("chkGroupByBrand").checked);
			url = updateURLParameter(url, "group-by-category", $$("chkGroupByProductType").checked);
			url = updateURLParameter(url, "attrib1", $$("lstAttrib1").value);
			return url;
		}

	</script>
</asp:Content>
