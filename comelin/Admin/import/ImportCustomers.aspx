<%@ Page Title="Importer des clients" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportCustomers.aspx.cs" Inherits="WebSite.Admin.ImportCustomer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>
		<img src="/Admin/images/import-customer.png" />
		Importer des clients</h1>

	<div id="step1" runat="server" visible="false">
		Le fichier doit être en format txt (tab-delimited)
	<br />
		La première ligne sera considérer comme une entête (pas un client)
	<br />
		<br />
		<asp:FileUpload ID="file" runat="server" />

		<asp:CheckBox ID="chkCharset1052" runat="server" Text="Charset CP-1252" Checked="True" />
		      <br />
	  Délimiteur:
	  <asp:TextBox ID="txtDelimiter" runat="server" Width="52px">,</asp:TextBox>
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

			</tbody>
		</table>

		<br />

		Mettre les clients dans le groupe:<br />
		<br />
		<asp:DropDownList ID="lstGroup" runat="server">
		</asp:DropDownList>
		<br />
		<br />
		<asp:CheckBox ID="chkUpdateIfExisting" runat="server" Text="Mettre à jour si existant"  Checked="True"/>
		<br />
		<asp:CheckBox ID="chkPointsAdd" runat="server" Text="Aditionner les points au points existant"/>
		<br />
		<br />
		Facteur de conversion de point:
		<asp:TextBox ID="txtPointConversionFactor" runat="server" TextMode="Number" Width="115px">1</asp:TextBox>
&nbsp;(les points importés seront multiplié par ce chiffre. Comelin ne supporte PAS les points avec des décimaux.
		<br />
		<br />
		<br />

		<asp:Button ID="cmdImport" runat="server" Text="Importer" OnClick="cmdImport_Click" />
		&nbsp;</div>
</asp:Content>
