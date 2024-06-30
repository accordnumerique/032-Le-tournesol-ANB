<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Sales.aspx.cs" Inherits="WebSite.Admin.report.Sales" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="app-report-sale">
        <h1>{{title}}</h1>
        <filter-date-range @filterchanged="filterChanged"></filter-date-range>
        <filter-store v-if="isMultiStore" @filterchanged="filterChanged"></filter-store>
        <filter-category @filterchanged="filterChanged"></filter-category>
        <filter-brand @filterchanged="filterChanged"></filter-brand>
        <filter-supplier @filterchanged="filterChanged"></filter-supplier>
        <filter-attrib instance="1" @filterchanged="filterChanged"></filter-attrib>
        <filter-attrib instance="2" @filterchanged="filterChanged"></filter-attrib>
        <report-grouping instance="1" required="true" label="Regroupement" @filterchanged="filterChanged"></report-grouping>
        <report-grouping instance="2" label="Sous-regroupement" @filterchanged="filterChanged"></report-grouping>
        <report-grouping instance="3" label="Sous-sous-regroupement" @filterchanged="filterChanged"></report-grouping>
        <filter-online-only></filter-online-only>
        <div id="viewReport" >
            <div class="btn btn-primary" @click="updateReport">Voir le rapport</div><div><input type="checkbox" id="chkDisplaySupplierOrders" v-model="displaySupplierOrders"  /><label for="chkDisplaySupplierOrders">Afficher les achats en cours</label></div>
        </div>
        
        <div  v-show="!dirty">
        <table id="table" v-if="entries"  style="width: 100%">
            <thead>
            <tr class="row-header-category">
                <td class="ct no-border" rowspan="2">{{groupTitle}}</td>
                <td class="ct no-border" rowspan="2">{{subGroupTitle}}</td>
                <td class="ct no-border" rowspan="2">Code</td> 
                <td class="ct no-border" rowspan="2">Code Four.</td> 
                <td class="ct no-border" rowspan="2">Code à barres</td> 
                <td colspan="3">Commandes en cours</td>
                <td colspan="3">Achats</td>
                <td colspan="3">Inventaire courant</td>
                <td colspan="7">Ventes</td>
                <td colspan="3">Budget</td>
            </tr>
            <tr>
                <td class="border-left">Qte. <br/>Ach</td>
                <td>Total <br/>Cout $</td>
                <td>Total <br/>Ven. $</td>

                <td class="border-left">Qte. <br/>Ach</td>
                <td>Total <br/>Cout $</td>
                <td>Total <br/>Ven. $</td>

                <td>Qte. <br/>Inv</td>
                <td>Total <br/>Cout $</td>
                <td>Total <br/>Ven. $</td>
                
                <td>Qte. <br/>Ven.</td>
                <td>Total <br/>Cout $</td>
                <td>Total <br/>Ven. $</td>
                <td>Total <br/>Rabais</td>
                <td>Vente <br/>Net</td>
                <td>Profit $</td>
                <td>% <br />vendu</td>
                <td>% <br />mrk. U</td>
                
                <td>% <br />profit</td>
                <td>% chiff. <br />d'affaire</td>
            </tr>
            </thead>
            <tfoot>
            <tr>
                <td></td><td></td><td></td>
                <td></td><td></td><td></td><td></td>
                <td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
            </tr>
            </tfoot>
        </table>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <%= this.JsInclude("/admin/js/components/report.js")  %>
    <%= this.JsInclude("/admin/js/sale-report.js")  %>
    <style>

     #table_wrapper {margin-top: 20px}
     #table thead .row-header-category td,#table tfoot td {border: 1px solid black;border-right: none; }
     #table thead .row-header-category td:last-child,#table tfoot td:last-child {border-right: 1px solid black; }
     #table thead tr td {text-align: center}
     #table thead tr:first-child td {text-align: center; font-weight: bold}
     #table tbody td, #table tfoot td {text-align: right}
     #table tfoot td  {font-weight: bold;}
     
     .border-left {border-left: 1px solid black}
     .border-right {padding-right: 5px}
     .no-border{border:none !important}

     .btn-group {flex-wrap: wrap}

     .attribs-select {display: flex}
     .attribs-select > div {margin-right: 10px}

     #viewReport { display: block; width: auto; margin-top: 10px}
 </style>
</asp:Content>
