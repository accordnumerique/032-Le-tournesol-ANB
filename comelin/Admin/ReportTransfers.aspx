<%@ Page Title="Rapport de transfert en magasin" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ReportTransfers.aspx.cs" Inherits="WebSite.Admin.PageReportTransfer" %>
<%@ Register src="ucDateRangePicker.ascx" tagname="ucDateRangePicker" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  <h1 runat="server" id="lblTitle"></h1>
  <uc1:ucDateRangePicker ID="ucDateRangePicker1" runat="server" />
  <div style="width:100%; height:50px"></div>
  <table id="table" style="width: 100%;" class="sssGrid">
    <thead>
      <tr><th># Transfert</th>
        <th>Date</th>
        <th>Qté</th>
        <th>Coût Matériel</th>
        <th>Coût Transport</th>
        <th>Coût Main d'oeuvre</th>
        <th>Coût Total</th>
        <th>Sous total</th>
          <th>TPS</th>
          <th>TVQ</th>
          <th>Total avec taxe</th>
        <th>Code produit</th>
          <th>Code Taxe</th>
        <th>Description du produit transférer</th>
          <th>Catégorie</th>
          <th>Marque</th>
      </tr>
    </thead>
    <tfoot>
      <tr>
          <th></th>
        <th></th>
        <th></th>
        <th></th>
          <th></th>
        <th></th>
        <th></th>
          <th></th>
          <th></th>
          <th></th>
          <th></th>
          <th></th>
          <th></th>
          <th></th>
          <th></th>
          <th></th>
      </tr>
    </tfoot>
  </table>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
  <script>
    $(function () {
      $('#table').dataTable({
        "sAjaxSource": 'ReportTransfer.axd' + window.location.search,
        "aaSorting": [[0, 'desc']],
        "aoColumnDefs": [
      { "aTargets": [0], "sWidth": "100" }, // transfer #
      { "aTargets": [1], "sWidth": "150", "mData": function (source, type, val) { return FormatPropDate(source, type, val, 1); } },
      { "aTargets": [2], "sWidth": "100", "sClass": "alignRight" },
      { "aTargets": [3], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 3); } },
      { "aTargets": [4], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 4); } },
      { "aTargets": [5], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 5); } },
      { "aTargets": [6], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 6); } },
      { "aTargets": [7], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 7); } }, 
            { "aTargets": [8], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 8); } }, 
            { "aTargets": [9], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 9); } }, 
            { "aTargets": [10], "sWidth": "50" }, 
            { "aTargets": [11], "sWidth": "100" }

        ],
        footerCallback: function (row, data, start, end, display) {
            var api = this.api();
            $(api.column(2).footer()).html(NumberToQuantity(sum(api.column(2).data())));
            for (var i = 3; i <= 10; i++) {
                var total = sum(api.column(i).data());
                $(api.column(i).footer()).html(NumberToAmount(total));
            }
        }
      });
    });
  </script>
</asp:Content>
