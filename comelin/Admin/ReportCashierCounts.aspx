<%@ Page Title="Rapport - Décomptes de caisse" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ReportCashierCounts.aspx.cs" Inherits="WebSite.Admin.ReportCashierCounts" %>
<%@ register src="~/Admin/ucDateRangePicker.ascx" tagprefix="uc1" tagname="ucDateRangePicker" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Rapport des décomptes de caisse</h1>
		<div class="no-print">
		<asp:DropDownList runat="server" ID="lstStore" ClientIDMode="Static"/>
		<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
			
			<div id="app-cashier-counts">
				
				<div v-for="c in cashierCounts">
					{{c.AmountCalculated}}
				</div>
			</div>
	</div>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		vm = new Vue({
			el: '#app-cashier-counts',
			data: {
				cashierCounts : _cashierCounts
			}
		})
	</script>
</asp:Content>
