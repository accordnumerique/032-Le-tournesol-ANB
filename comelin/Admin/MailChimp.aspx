<%@ Page Title="Mail Chimp integration" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="MailChimp.aspx.cs" Inherits="WebSite.Admin.MailChimpAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Mail Chimp <help url="articles/integration-au-service-d-infolettres-mailchimp"></help></h1>

	<h3>Api Key</h3>

	<asp:TextBox runat="server" ID="txtApiKey" Width="350px"></asp:TextBox>
	&nbsp;<asp:Button ID="cmdTest" runat="server" OnClick="cmdTest_Click" Text="Connexion" />
	<br />
	Vous devez <a href="https://us12.admin.mailchimp.com/account/api/">créer une clé API</a> pour permettre à Comelin d'ajouter et d'enlever des inscriptions à votre compte MailChimp.


	<div runat="server" visible="False" id="divLists">
		<br />
		<br />
		Choisir la liste qui sera utilisé pour inscrire et dé-inscrire vos clients<br />


		<br />
		Liste existante:
	<asp:DropDownList ID="lstList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="lstList_SelectedIndexChanged">
	</asp:DropDownList>
		<br />
		<br />
		<div style="margin-left: 10px" id="divCompare" runat="server" Visible="true">
			Inscriptions<br />
			<br />
			Comelin: <span style="font-weight: bold" runat="server" id="lblComelinCount"></span><br />
			<span runat="server" id="lblListName"></span>: <span style="font-weight: bold" runat="server" id="lblMailChimpCount"><br />
			<br />
			</span><asp:Button ID="cmdTransferToMailChimp" runat="server" Text="Transférer la liste de clients" OnClick="cmdTransferToMailChimp_Click" /> <p>La syncronisation est faite normalement <b>une</b> seule fois au début. Ensuite, Comelin syncronise les nouveaux contacts automatiquement.</p>
			<br />
			<br />
			<asp:Button ID="cmdSyncUnsubscribe" runat="server" OnClick="cmdSyncUnsubscribe_Click" Text="Synchroniser les désinscriptions" />
		</div>
		<br />
	</div>
	<br />


</asp:Content>
