<%@ Page Title="Title" Language="C#" MasterPageFile="../AdminMP.Master" CodeBehind="CustomersSummary.aspx.cs" Inherits="WebSite.Admin.report.CustomersSummary" %>

<asp:Content runat="server" ContentPlaceHolderID="cp">
    <div id="appCustomerSummary">
        <h1>Rapport sommaire des nouveaux clients</h1>
        <filter-date-range @filterchanged="filterChanged"></filter-date-range>
        <div class="btn btn-primary" @click="fetchReport" ref="btnReport">Voir le rapport</div>
        <div class="loading" v-if="!report">chargements</div>
        <div v-else>
            <div class="boxes">
                <div class="box">
                    <div>Nombre de clients total</div>
                    <div class="sub-data">{{report.NbCustomersTotal}}</div>
                </div>
                <div class="box">
                    <div>Nouveau clients</div>
                    <div class="sub-data">
                        {{report.NbCustomersNew}}
                    </div>
                </div>
                <div class="box">
                    <div>Anciens clients</div>
                    <div class="sub-data">
                        {{report.NbCustomers - report.NbCustomersNew}}
                    </div>
                </div>
            </div>
          
            <table class="sssGrid">
                <thead>
                    <tr>
                        <th></th>
                        <th v-for="s in report.Stores">{{s.StoreName}}</th>
                    </tr>
                </thead>
                <tbody>
                <tr>
                    <th>Nombre
                        <br/><span class="nc">de nouveaux clients</span></th>
                    <td v-for="s in report.Stores">
                        {{getNbCustomerNewPerStore(s.IdStore)}}
                    </td>
                </tr>
                <tr>
                    <th>Nombre
                        <br/><span class="nc">d'anciens clients</span></th>
                    <td v-for="s in report.Stores">
                        {{getNbCustomerOldPerStore(s.IdStore)}}
                    </td>
                </tr>
                <tr>
                    <th>Pourcentage des clients
                        <br/><span class="nc">qui sont des nouveaux clients</span></th>
                    <td v-for="s in report.Stores" :title="getPercentageNewCustomerPerStoreTitle(s.IdStore)">
                        {{getPercentageNewCustomerPerStore(s.IdStore)}}
                    </td>
                </tr>
                <tr>
                    <th>Nombre de ventes
                        <br/><span class="nc">à des nouveaux clients</span>
                    </th>
                    <td v-for="s in report.Stores">
                        {{getNbSalesPerStore(s.IdStore)}}
                    </td>
                </tr>
                <tr>
                    <th>Percentage du nombre de ventes
                        <br/><span class="nc">à des nouveaux clients</span>
                    </th>
                    <td v-for="s in report.Stores">
                        {{getPercentageNbSalesPerStore(s.IdStore)}}
                    </td>
                </tr>
                <tr>
                    <th>Montant vendu
                        <br/><span class="nc">à des nouveaux clients</span>
                    </th>
                    <td v-for="s in report.Stores">
                        {{getSalesPerStore(s.IdStore)}}
                    </td>
                </tr>
                <tr>
                    <th>Pourcentage des ventes
                        <br/><span class="nc">à des nouveaux clients</span>
                    </th>
                    <td v-for="s in report.Stores" :title="getSalesPercentagePerStoreTitle(s.IdStore)">
                        {{getSalesPercentagePerStore(s.IdStore)}}
                    </td>
                </tr>
                </tbody>
                
            </table>
            
   
                <div :id="'chartNewCustomer' + s.IdStore" class="chart" v-for="s in report.Stores"></div>
       

            <div v-if="report.Regions">
                <table class="sssGrid" id="gridPerRegion">
                    <thead>
                        <tr>
                            <th>
                            </th>
                            <th v-for="s in report.Stores">{{s.StoreName}}</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr v-for="region in report.Regions">
                        <th>{{region.Name}}</th>
                        <td v-for="s in report.Stores">{{getNewCustomerPerRegion(s.IdStore, region.Id)}}</td>
                    </tr>
                    </tbody>
                </table>
                
                <div :id="'chartRegion' + s.IdStore" class="chart chartRegion" v-for="s in report.Stores"></div>
            </div>

        </div>
    </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
    <%= this.JsInclude("/admin/js/components/report.js")  %>
    <script>
        var app = new Vue({
            el: '#appCustomerSummary',
            data: {
                report: null,
                dirty: false,
            },
            methods: {
                fetchReport() {
                    this.downloadData(this.computedQuery(), true);
                },
                filterChanged() {
                    this.dirty = this.computedQuery() !== document.location.search;
                },
                computedQuery() {
                    return computeSearchUrl(this.$children);
                },
                downloadData(computedQuery, setState) {
                    let c = this;
                    fetchPost('/admin/api/customers/summary' + computedQuery, null, this.$refs.btnReport, data => {
                        if (setState) {
                            globalSetUrl(document.location.pathname + computedQuery);
                        }
                        if (!data.NbCustomersNew) {
                            data.NbCustomersNew = 0;
                        }
                        if (!data.NbCustomers) {
                            data.NbCustomers = 0;
                        }
                        c.report = data;
                        this.DisplayChart();
                    });
                },
                getNbCustomerNewPerStore(idStore) {
                    return this.getStoreStats(idStore).NbCustomersNew;
                },
                getNbCustomerOldPerStore(idStore) {
                    var s = this.getStoreStats(idStore);
                    if (!s.NbCustomers) {
                        return "-";
                    }
                    if (!s.NbCustomersNew) {
                        s.NbCustomersNew = 0;
                    }
                    return s.NbCustomers - s.NbCustomersNew;
                },
                getPercentageNewCustomerPerStore(idStore) {
                    var stats = this.getStoreStats(idStore);
                    if (!stats.NbCustomersNew) {
                        return "-";
                    }
                    return NumberToPercentage(stats.NbCustomersNew / stats.NbCustomers) + " %";
                },
                getPercentageNewCustomerPerStoreTitle(idStore) {
                     var stats = this.getStoreStats(idStore);
                     if (!stats.NbCustomersNew) {
                        return null;
                    }
                 
                    return this.getPercentageNewCustomerPerStore(idStore) + " des ventes ont a été faites à nouveaux clients ( " 
                        + stats.NbCustomersNew + ' / ' +  stats.NbCustomers + " )";
                },
                getNbSalesPerStore(idStore) {
                    return this.getStoreStats(idStore).NbSalesNew;
                },
                getPercentageNbSalesPerStore(idStore) {
                    var stats = this.getStoreStats(idStore);
                    if (!stats.NbSalesNew) {
                        return "-";
                    }
                    return NumberToPercentage(stats.NbSalesNew / stats.NbSales) + " %";
                },
                getSalesPerStore(idStore) {
                    return NumberToAmount(this.getStoreStats(idStore).SalesNewCustomers);
                },
                getSalesPercentagePerStore(idStore) {
                    var stats = this.getStoreStats(idStore);
                    if (!stats.SalesNewCustomers) {
                        return "-";
                    }
                    return NumberToPercentage(stats.SalesNewCustomers / stats.TotalSales) + " %";
                },
                getSalesPercentagePerStoreTitle(idStore) {
                    var stats = this.getStoreStats(idStore);
                    return "Vente par des nouveaux clients: " + NumberToAmount(stats.SalesNewCustomers) + '\n' +
                        "Vente total: " + NumberToAmount(stats.TotalSales);
                },
                getStoreStats(idStore) {
                    return this.report.PerStores.find(s => s.IdStore == idStore);
                },
                getNewCustomerPerRegion(idStore, idRegion) {
                    var stats = this.getStoreStats(idStore);
                    if (!stats.NbCustomerPerRegion) {
                        return null;
                    }
                    return stats.NbCustomerPerRegion[idRegion];
                },
                DisplayChart() {
                    google.charts.load("current", { packages: ["corechart"] });
                    google.charts.setOnLoadCallback(this.drawChart);

                },
                drawChart() {
                    for (var store of this.report.Stores) { // one chart per store
                        this.drawChartNewCustomer(store);
                        if (this.report.Regions) {
                            this.drawChartPerRegion(store);
                        }
                    }
                },
                drawChartNewCustomer(store) {
                    var stats = this.getStoreStats(store.IdStore);
                    var data = [['Type de clients', 'Nombre de clients']];
                    data.push(['Nouveau', stats.NbCustomersNew]);
                    data.push(['Ancien', stats.NbCustomers - stats.NbCustomersNew]);
                    var options = { title: store.StoreName, is3D: true };
                    var chart = new google.visualization.PieChart(document.getElementById('chartNewCustomer' + store.IdStore));
                    chart.draw(google.visualization.arrayToDataTable(data), options);
                },
                 drawChartPerRegion(store) {
                    var data = [['Région', 'Nombre de clients']];
                     for (var region of this.report.Regions) {
                            data.push([region.Name, this.getNewCustomerPerRegion(store.IdStore, region.Id)]);
                     }
                    var options = { title: store.StoreName, is3D: true };
                    var chart = new google.visualization.PieChart(document.getElementById('chartRegion' + store.IdStore));
                    chart.draw(google.visualization.arrayToDataTable(data), options);
                }
            },
            mounted() {
                this.fetchReport(); // will fetch the data using the query string   
                let c = this;
                window.addEventListener("popstate", () => { c.downloadData(document.location.search, false); });
            }

        });




    </script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <style>
        .sssGrid td, .sssGrid th {
            padding: 10px 20px;
            text-align: right
        }
        .sssGrid tbody th {
            text-align: left
        }
        .nc {
            font-weight: normal;
            color: grey
        }
        .chart {
            height: 300px;
            width: 500px;
            display: inline-block
        }
        .chartRegion {
            height:600px;
            width: 800px;
        }
    </style>
</asp:Content>
