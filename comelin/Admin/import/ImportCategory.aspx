<%@ Page Title="Importer des catégories, marques ou distributeurs" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportCategory.aspx.cs" Inherits="WebSite.Admin.ImportCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>
		<img src="/admin/images/import-customer.png" />
		Importer des catégories, marques ou distributeurs</h1>

	<div id="step1" runat="server" visible="false">
		Le fichier doit être en format txt (tab-delimited)
	<br />
		La première ligne sera considérée comme une entête
	<br />
		<asp:FileUpload ID="file" runat="server" />
        <br />
		Delimitateur:
	  <asp:TextBox ID="txtDelimiter" runat="server" Width="52px">,</asp:TextBox>

		<br />
		Type:
		<asp:DropDownList ID="lstCategoryType" runat="server">
			<asp:ListItem Value="1">Catégorie</asp:ListItem>
			<asp:ListItem Value="2">Marque</asp:ListItem>
			<asp:ListItem Value="4">Distributeur</asp:ListItem>
		</asp:DropDownList>

		<br />
		<br />

		<asp:Button ID="cmdUpload" runat="server" Text="Upload" OnClick="cmdUpload_Click" />
	</div>

	<div id="step2" runat="server" visible="false">

		<asp:Button ID="cmdRestart" runat="server" Text="Recommencer avec un autre fichier" OnClick="cmdRestart_Click" />

		<table>
			<thead>
				<tr>
					<td>Example d'information</td>
					<td>Entête</td>
					<td>Type d'information</td>
				</tr>
			</thead>
			<tbody>

				<tr>
					<td>
						<asp:TextBox ID="txtField1" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader1" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField1" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField2" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader2" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField2" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField3" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader3" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField3" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField4" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader4" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField4" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField5" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader5" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField5" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField6" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader6" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField6" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField7" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader7" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField7" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField8" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader8" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField8" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField9" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader9" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField9" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField10" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader10" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField10" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField11" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader11" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField11" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField12" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader12" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField12" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField13" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader13" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField13" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField14" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader14" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField14" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField15" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader15" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField15" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField16" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader16" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField16" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<asp:TextBox ID="txtField17" runat="server" Width="200px" />
					</td>
					<td>
						<asp:TextBox ID="txtHeader17" runat="server"></asp:TextBox>
					</td>
					<td>
						<asp:DropDownList ID="lstField17" runat="server" />
					</td>
				</tr>
			</tbody>
		</table>

		<asp:CheckBox ID="chkImportNew" runat="server" Checked="True" Text="Importer les nouveaux" />
		<br />
		<asp:CheckBox ID="chkImportExisting" runat="server" Checked="True" Text="Importer les existants" />
		<br />
		<br />

		<asp:Button ID="cmdImport" runat="server" Text="Importer" OnClick="cmdImport_Click" />
		

	</div>
	
			<hr/>
		<a href="ImportSupplierBest.aspx">Importer les fournisseurs de BEST</a>
</asp:Content>
