<%@ Page Title="Liste des ventes" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SalesList.aspx.cs" Inherits="WebSite.Admin.SalesList" %>


<%@ Register src="ucDateRangePicker.ascx" tagname="ucDateRangePicker" tagprefix="uc1" %>


<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="images/report-list.png" /> Liste de ventes</h1>
  <uc1:ucDateRangePicker ID="ucDateRangePicker1" runat="server" /><br/>
  <input type="checkbox" id="chkWebOnly" /><label for="chkWebOnly">Vente en ligne seulement</label>


  <table id="table" style="width: 100%;" class="sssGrid">
    <thead>
      <tr>
        <th>Date facture</th>
        <th style="width: 200px"># Facture</th>
        <th>Date réservation</th>
        <th style="width: 200px"># Réservation</th>
        <th>Client</th>
        <th>Transport</th>
        <th>Tax</th>
        <th>Total</th>
        <th>Magasin</th>
        <th>Web</th>
        <th>Paiement</th>
      </tr>
    </thead>
	  <tfoot>
	  <tr>
		<th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th>
	  </tr>
	  </tfoot>
  </table>

		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
  <script>
    
    // override the function from the daterange picker
    function GetUrl() {
      var url = document.location.href;
      url = updateURLParameter(url, "from", $$("from").value);
      url = updateURLParameter(url, "to", $$("to").value);
      url = updateURLParameter(url, "webonly", $$("chkWebOnly").checked);
      return url;
    }

    $(function () {

      // set query string to control
      if ($.query.get("webonly") === "true") {
        $$("chkWebOnly").checked = true;
      }

      $("#table").dataTable({
        "sAjaxSource": '/admin/ajax/SalesList.axd' + window.location.search,
        "aaSorting": [[0, 'desc'],[2, 'desc']],
        "aoColumnDefs": [
          {
            "aTargets": [0], "sWidth": "150", "sClass": "alignRight", "mData": function (source, type, val) {
              if (type === "sort" && source[6] === "") {
                // empty date will be set first
                return new Date('2099-1-1');
              }
              return FormatPropDateTime(source, type, val, 6);
            }
          },
          {
            // invoice link
            "aTargets": [1], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) {
              var invoiceId = source[0];
               if (type === 'display') {
                 if (invoiceId === 0) {
                   return "";
                 }
                 return '<a href="' + source[5] + '">' + invoiceId + '</a>';
               } else {
                 return invoiceId; // just the id
               }
             }
          }, 
          { "aTargets": [2], "sWidth": "150", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropDateTime(source, type, val, 13); } }, // reservation date
          {
            // reservations link
            "aTargets": [3], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) {
              var invoiceId = source[11];
              if (type === 'display') {
                if (invoiceId === 0) {
                  return "";
                }
                return '<a href="' + source[12] + '">C' + invoiceId + '</a>';
              } else {
                return invoiceId; // just the id
              }
            }
          },
          {
              "aTargets": [4], "sWidth": "200", "mData": function (source, type, val) {
                if (type === 'display') {
                  val = source[2];
                  var customerId = source[3];
                  if (customerId === 0) {
                    return '';
                  }
                  return '<a href="?idCustomer=' + source[3] + '">' + val + '</a>';
                } else {
                  return source[2]; // just the name of the customer
                }
              }
            }, // customer link 
           { "aTargets": [5], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 8); } },
           { "aTargets": [6], "sWidth": "100", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 7); } },
           { "aTargets": [7], "sWidth": "150", "sClass": "alignRight", "mData": function (source, type, val) { return FormatPropAmount(source, type, val, 1); } },
           { "aTargets": [8], "sWidth": "150", "mData": function (source, type, val) { return source[9]; } },
           { "aTargets": [9], "sWidth": "70", "mDataProp": function (rgData) { return FormatCheckBox(rgData[4]); } }, // is the order a web order
           { "aTargets": [10], "mData": function (source, type, val) { return source[10]; } },

          ]
      });
    });

  </script>

</asp:Content>
