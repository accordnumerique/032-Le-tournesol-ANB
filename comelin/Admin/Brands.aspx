<%@ Page Title="Marques et Distributeurs" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Brands.aspx.cs" Inherits="WebSite.Admin.Brands" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Marques et Distributeurs</h1>
	<table id="grid" style="display: none; width: 100%">
		<thead>
			<tr>
				<th>Id</th>
				<th>Nom de l'entreprise</th>
				<th>Nom du contact</th>
				<th>Téléphone</th>
				<th>Cell</th>
				<th>Fax</th>
				<th>Adresse</th>
				<th>Courriel</th>
				<th>Site web</th>
				<th>Montant minimal</th>
				<th>Délai livraison</th>
				<th>Note</th>
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
		</tr>
		</tfoot>
	</table>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		$('#grid').show().DataTable({
			ajax: '/<%= WebSite.Admin.BrandsListingHandler.Url %>',
			sAjaxDataProp: null,
			columns: [
				{ data: "Id", defaultContent: '' },
				{ data: "TitleFr", defaultContent: '' },
				{ data: "Name", defaultContent: '' },
				{ data: "Phone", defaultContent: '' },
				{ data: "Cell", defaultContent: '' },
				{ data: "Fax", defaultContent: '' },
				{ data: "Address", defaultContent: '' },
				{ data: "Email", defaultContent: '' },
				{ data: "WebSite", defaultContent: '' },
				{ data: "MinAmount", defaultContent: '', render: NumberToAmount, sClass: 'alignRight' },
				{ data: "Delay", defaultContent: '', sClass: 'alignRight' },
				{ data: "Notes", defaultContent: '' }
			],
			order: [[0, 'asc']]
		});
	</script>
</asp:Content>
