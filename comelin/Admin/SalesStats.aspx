<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SalesStats.aspx.cs" Inherits="WebSite.Admin.SalesStatsPage" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <a href="/admin/api/download-report-sales-by-day" id="download-file" class="btn btn-success">Téléchargement des données <i class="fa fa-file-excel-o"></i></a>
    <div id="chartday"></div>
    <div id="chartweek"></div>
    <div id="chartmonth"></div>
    <div id="chartyear"></div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
    <style>
        #download-file {
            margin-top: 20px
        }

            #download-file i {
                color: white !important
            }
    </style>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var dataDay = google.visualization.arrayToDataTable([<%= ChartDataDay %>]);
          var chart = new google.visualization.LineChart(document.getElementById('chartday'));
          chart.draw(dataDay, { title: 'Ventes par jour', width: 950, height: 500 });

          var dataWeek = google.visualization.arrayToDataTable([<%= ChartDataWeek %>]);
          chart = new google.visualization.LineChart(document.getElementById('chartweek'));
          chart.draw(dataWeek, { title: 'Ventes par semaine', width: 950, height: 500 });

          var dataMonth = google.visualization.arrayToDataTable([<%= ChartDataMonth %>]);
          chart = new google.visualization.LineChart(document.getElementById('chartmonth'));
          chart.draw(dataMonth, { title: 'Ventes par mois', width: 950, height: 500 });

          var dataYear = google.visualization.arrayToDataTable([<%= ChartDataYear %>]);
            chart = new google.visualization.ColumnChart(document.getElementById('chartyear'));
            chart.draw(dataYear, { title: 'Ventes par année', width: 950, height: 500 });
        }
    </script>
</asp:Content>
