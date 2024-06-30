<%@ Page  Title="Les des clients par date d'anniversaire" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" Inherits="WebSite.Admin.AdminPage"  %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="/Admin/images/birthday.png"/> Anniversaire pour <asp:DropDownList runat="server" id="lstFilterMonth" ClientIDMode="Static">
		<asp:ListItem Value="0">Tous l&#39;année</asp:ListItem>
		<asp:ListItem Value="1">Janvier</asp:ListItem>
		<asp:ListItem Value="2">Février</asp:ListItem>
		<asp:ListItem Value="3">Mars</asp:ListItem>
		<asp:ListItem Value="4">Avril</asp:ListItem>
		<asp:ListItem Value="5">Mai</asp:ListItem>
		<asp:ListItem Value="6">Juin</asp:ListItem>
		<asp:ListItem Value="7">Juillet</asp:ListItem>
		<asp:ListItem Value="8">Août</asp:ListItem>
		<asp:ListItem Value="9">Septembre</asp:ListItem>
		<asp:ListItem Value="10">Octobre</asp:ListItem>
		<asp:ListItem Value="11">Novembre</asp:ListItem>
		<asp:ListItem Value="12">Décembre</asp:ListItem>
		</asp:DropDownList>
	</h1>
	<table id="table" style="width: 100%; display: none" class="sssGrid">
		<thead>
			<tr>
				<th>Nom</th>
				<th>Téléphone</th>
				<th>Cell</th>
				<th>Courriel</th>
				<th>Adresse</th>
				<th>Ville</th>
				<th>Région</th>
				<th>Province</th>
				<th>Code Postal</th>
				<th>Date création</th>
				<th>Anniversaire</th>
				<th>Notes</th>
			</tr>
		</thead>
		<tfoot>
		<tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr>
		</tfoot>
	</table>
	</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
		<% EnsurePermission(Permission.AdvanceMarketing); %>
	<script>
		function GetAjaxUrl() {
			return '/<%= WebSite.Admin.Api.ApiBirthday.Url %>?filter=' + $$('lstFilterMonth').value;
		}

		$$('lstFilterMonth').value = ((new Date().getMonth() + 1) % 12) + 1;

		var table = $('#table').show().DataTable({
			ajax: GetAjaxUrl(),
			columns: [
				{ data: "Name" },
				{ data: "Phone", defaultContent: '' },
				{ visible:false, data: "Cell", defaultContent: '' },
				{ data: "Email", defaultContent: '' },
				{ data: "Address1", defaultContent: '' },
				{ data: "City", defaultContent: '' },
				{ data: "Region", defaultContent: '' },
				{ data: "Province", defaultContent: '' },
				{ data: "PostalCode", defaultContent: '' },
				{ visible: false, mData: function (source, type, val) { return FormatPropDate(source, type, val, 'DateCreated'); } },
				{ data: "Birthday", defaultContent: '' },
				{ visible: false, data: "Notes", defaultContent: '' },
			],
			sAjaxDataProp:null,
			order: [[9, 'asc']]
		});

		$('#lstFilterMonth').change(function () {
			table.ajax.url(GetAjaxUrl()).load();
		});
	</script>
</asp:Content>
