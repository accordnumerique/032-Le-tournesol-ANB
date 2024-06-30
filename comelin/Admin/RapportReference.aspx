<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RapportReference.aspx.cs" Inherits="WebSite.Admin.RapportReference" %>
<%@ Register Src="~/Admin/ucDateRangePicker.ascx" TagPrefix="uc1" TagName="ucDateRangePicker" %>
<!DOCTYPE html>
<html lang="fr">
<head runat="server">
    <title>Rapport de référence</title>
	<script src="https://cdn.jsdelivr.net/combine/npm/jquery@3.3.1/dist/jquery.min.js,gh/twbs/bootstrap@4.1.3/dist/js/bootstrap.min.js,npm/moment@2.22.2/moment.min.js"></script>
    
	<script src="/admin/js/admin.js" type="text/javascript"></script>
	<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<link href="/Admin/css/bootstrap-datepicker3.min.css" rel="stylesheet" />
  <style>
    body { font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif}
     .stat { background-color: #92cfe4; border-radius:5px; padding: 10px; width: 350px; margin: 10px; height:70px;}
     .stat .title { padding-top:15px;float:left}
    .stat .total { float:right; font-size:40px;}
    .product { width:100%; font-weight:bold; margin-top:10px }
    .product img { float:left;clear:both; margin-right:10px}
    .product a { float:left; width:540px}
    .qty { font-weight:bold;font-size:1.1em; float:left  }
  </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width:600px; margin-left:auto; margin-right:auto">
      <uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
      <%= RenderReport() %>    
      </div>
    </form>
  <script>
	$('#cmdDisplay').click(function () {
      // redirect with querystring
      window.location = 'RapportReference.aspx?q=' + GetQueryStringAsString('q') + '&from=' + $$("from").value + '&to=' + $$("to").value;
    });
  </script>
</body>
</html>
