<%@ Page Title="Rapport de vente par heures" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ReportByTime.aspx.cs" Inherits="WebSite.Admin.ReportByTime" %>
<%@ Register TagPrefix="uc1" TagName="ucDateRangePicker" Src="~/Admin/ucDateRangePicker.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script type="text/javascript">
		google.charts.load('current', {'packages':['bar']});
	</script>
	<style>
		.day { width: 95%}
		.report-in-number {width: 100%}
		.report-in-number td {text-align: right }
		.report-in-number th {text-align: center }
		th.day-of-week { text-align: left; background-color: rgb(255, 232, 222) }
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Rapport de ventes au cours d'une journée</h1>
		<asp:DropDownList ID="lstStore" EnableViewState="False" runat="server" ClientIDMode="Static" />
	<br/>
	
	<asp:RadioButton ID="radSalesPerHours" ClientIDMode="Static" GroupName="opt" runat="server" Text="Vente en moyenne par 30 minutes" /><br/>
	<asp:RadioButton ID="radSalesTotal" ClientIDMode="Static" GroupName="opt" runat="server" Text="Total vendu par 30 minutes" /><br/>
<uc1:ucDateRangePicker ID="ucDateRangePicker1" runat="server" FilterByCategory="True" />
	<br/>
	<br/>
	<%= Result %>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		function GetUrlExtra() {
			$.query.SET('viewTotal', $$('radSalesTotal').checked.toString());
		}
		HeatMap($('.c'));
		HeatMap($('.s'));
	</script>
</asp:Content>
