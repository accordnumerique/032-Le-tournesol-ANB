<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="InventoryAdjustement.aspx.cs" Inherits="WebSite.Admin.report.InventoryAdjustement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="vueAppGeneric">
        <h1>Rapport d'ajustement d'inventaire</h1>
        <inventory-adjustment inline-template>
            <div>
                <filter-date-range @filterchanged="filterChanged"></filter-date-range>
                <filter-store @filterchanged="filterChanged"></filter-store>
                <filter-category @filterchanged="filterChanged"></filter-category>
                <filter-brand @filterchanged="filterChanged"></filter-brand>
                <filter-supplier @filterchanged="filterChanged"></filter-supplier>
                <filter-attrib instance="1" @filterchanged="filterChanged"></filter-attrib>
                <filter-attrib instance="2" @filterchanged="filterChanged"></filter-attrib>
                <report-grouping instance="1" required="true" label="Regroupement" @filterchanged="filterChanged" showadj="true" grouping-init="Adjustment"></report-grouping>
                <report-grouping instance="2" label="Sous-regroupement" @filterchanged="filterChanged" showadj="true"></report-grouping>
                <div class="btn btn-primary" @click="fetchReport" ref="btnReport">Voir le rapport</div>
                <code>{{tmp}}</code>
            </div>
        </inventory-adjustment>
    </div>
    
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <%= this.JsInclude("/admin/js/components/report.js")  %>
    <script>
        Vue.component('inventory-adjustment', 
            {
                data() {
                    return {
                        entries: null, // downloaded
                        dataTableCreated: false,
                        groupTitle: null,
                        subGroupTitle: null,
                        displayProductCode: false,
                        title: 'Rapport d\'ajustement d\'inventaire',
                        dirty: false,
                        tmp: null
                }
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
                        fetchPost('/admin/api/report/adjustment' + computedQuery, null, this.$refs.btnReport, data => {
                            if (setState) {
                                globalSetUrl(document.location.pathname + computedQuery, data.Title);
                            }
                            c.displayProductCode = data.DisplayProductCode;
                            c.entries = data.Groups;
                            c.title = data.Title;
                            c.groupTitle = data.GroupByTitle;
                            c.subGroupTitle = data.SubGroupTitle;
                            if (c.dataTableCreated) {
                                _dataTable.clear().rows.add(data.Presentations).draw(); // table already created, just update the source
                            }
                            c.tmp = JSON.stringify(data);
                        });
                    }
                },
                mounted() {
                    this.fetchReport(); // will fetch the data using the query string   
                    let c = this;
                    window.addEventListener("popstate", () => { c.downloadData(document.location.search, false); });
                }
            });


        var app = new Vue({
            el:'#vueAppGeneric'

        });

      
    </script>
</asp:Content>
