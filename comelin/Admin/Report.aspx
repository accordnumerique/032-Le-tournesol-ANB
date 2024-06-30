<%@ Page Title="Rapport Quotidien" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.ReportPage" CodeBehind="Report.aspx.cs" %>
<%@ Register src="ucDateRangePicker.ascx" tagname="ucDateRangePicker" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
.tableReport {margin:0;padding:0;border:1px solid #e2e2e2;border-radius:6px;display:inline-block;}
.tableReport table{border-collapse: collapse;border-spacing: 0;margin:0;padding:0;}
.tableReport table tbody tr:last-child td:last-child {border-bottom-right-radius:6px;}
.tableReport table thead tr:first-child td:first-child {border-top-left-radius:6px;}
.tableReport table thead tr:first-child td:last-child {border-top-right-radius:6px;}
.tableReport table tbody tr:last-child  td:first-child{border-bottom-left-radius:6px;}
.tableReport tr:nth-child(odd){ background-color:#fffbf4; }
.tableReport tr:nth-child(even){ background-color:#ffffff; }
.tableReport td{vertical-align:middle;text-align:right;padding:10px;font-size:12px;font-family:Verdana;font-weight:normal;color:#000000;width:100px;}
.tableReport tbody td { border-top:1px solid #e2e2e2; }
.tableReport tr td:first-child { font-weight:bold; width:300px; text-align:left;}
.tableReport thead td{background:-o-linear-gradient(bottom, #ff7f00 5%, #bf5f00 100%);	background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #ff7f00), color-stop(1, #bf5f00) );
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr="#ff7f00", endColorstr="#bf5f00");	background: -o-linear-gradient(top,#ff7f00,#bf5f00);
	background-color:#ff7f00;text-align:center;font-size:14px;font-family:Arial;font-weight:bold;color:#ffffff;}
.up{color:Green}
.down{color:red}
.same{color:Yellow}
.up,.down,.same{clear:both; display:block}
.tableReport tr.hidden { display:none}
h3 { color:black; font-size:16px; font-weight:bold; padding-bottom:10px; margin-top:30px; margin-left: 50px  } 
h2 { width: auto}
#lnkPrevious { margin-right:10px;}
#lnkNext { margin-left:10px;}
#lblDate { font-size:20px}
.extraHtml { padding-left:15px; font-weight:normal; font-size:10px; text-decoration:underline; cursor:pointer; color:gray; white-space:nowrap;float:right}
.indent2 { margin-left:40px; font-weight:normal; color:#bf5f00}
.indent3 { margin-left:60px; font-weight:normal;}
.productToDelete { display:block; clear:left; margin:5px;}
.productToDelete a { text-decoration:none; color:gray; float:left}
.productToDelete img { width:40px; padding-right:5px; float:left }
.productToDelete div { width:45px; height:40px;  float:left}
		.cashier {margin-bottom: 5px; border:1px solid lightgray; white-space: nowrap; padding: 3px }
		.subline { float: right;text-align: right;text-decoration: none;font-size: 12px;}
		.err { color:#d8000c;background-color:#ffbaba}
		#toc {border: 1px solid darkgray; padding: 20px; margin:20px}
		#toc a { display: block; font-size: 0.9em }
	</style>
	<script>
		function showHideSubData(className) {
			$('.' + className).toggleClass('hidden');
		}
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img alt="Rapport <%= ReportTypeStr %>" src="images/report-<%= Report.Type %>.png" /> Rapport <%= ReportTypeStr %></h1>
	<a id="lnkPrevious" runat=server><img alt="Précédent" src="images/left.png" /></a> <span id=lblDate><%= Page.Title %></span> <a id="lnkNext" runat=server ><img alt="Suivant" src="images/right.png" /></a>
	<div id=divFilterByGroup>
		<uc1:ucDateRangePicker ID="ucDateRangePicker1" runat="server" />
		<br />
		Filtre par groupe: <asp:DropDownList ID=lstGroup runat=server AutoPostBack="True" onselectedindexchanged="lstGroup_SelectedIndexChanged"></asp:DropDownList>
		<div id="divFilterBySalesType" runat="server">
			&nbsp;Type de vente:
			<asp:DropDownList ID="lstReportScope" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstReportScope_SelectedIndexChanged">
				<asp:ListItem>Tous</asp:ListItem>
				<asp:ListItem>En ligne seulement</asp:ListItem>
				<asp:ListItem>En magasin seulement</asp:ListItem>
			</asp:DropDownList>
		</div>
	</div>
	<div id="divWeekSetting" runat="server" Visible="false">Semaine débute le <asp:DropDownList runat="server" ID="lstStartOfWeek" OnSelectedIndexChanged="lblStartOfWeek_SelectedIndexChanged" AutoPostBack="True">
		<asp:ListItem Value="6">Samedi</asp:ListItem>
		<asp:ListItem Value="0">Dimanche</asp:ListItem>
		<asp:ListItem Value="1">Lundi</asp:ListItem>
	</asp:DropDownList></div>
	
	
	<nav id="toc">
		
	</nav>

	<%= RenderReports() %>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		HeatMap($('#Ventes-par-marques tr td:nth-last-child(1) .Ratio'), 1);
		HeatMap($('.NbItemAvg'), 1);
		HeatMap($('.NbItemMed'), 1);
		HeatMap($('.SalesAvg'), 1);
		HeatMap($('.SalesMed'), 1);

		var toc = $$('toc');
		for (var el of document.getElementsByTagName('h3')) {
			var link = document.createElement('a');
			link.innerText = el.innerText;
			link.href = '#' + el.id;
			toc.appendChild(link);
		}
	</script>
</asp:Content>
