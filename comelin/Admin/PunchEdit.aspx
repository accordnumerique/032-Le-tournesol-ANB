<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PunchEdit.aspx.cs" Inherits="WebSite.Admin.PunchEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html lang="fr">
<head runat="server">
    <title></title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<style>
			body{ font-family:Helvetica}

		</style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    	<asp:Literal ID=lblEmployeeName runat=server></asp:Literal>
			<br />
			<div style="width:120px"><span style="width:120px"><strong>Début</strong></span></div>
			<asp:TextBox ID="txtOriStartHours" runat="server" Width="25px" Enabled="False" ReadOnly="True"></asp:TextBox>
&nbsp;:
			<asp:TextBox ID="txtOriStartMinutes" runat="server" Width="25px" Enabled="False" ReadOnly="True"></asp:TextBox>
&nbsp; (correction:
			<asp:TextBox ID="txtCorrectedStartHours" runat="server" Width="25px"></asp:TextBox>
			:
			<asp:TextBox ID="txtCorrectedStartMinutes" runat="server" Width="25px"></asp:TextBox>
			)<br />
			<br />
			<div style="width:120px"><strong>Fin</strong>:<br />
			</div>
			<asp:TextBox ID="txtOriEndHr" runat="server" Width="25px" Enabled="False" ReadOnly="True"></asp:TextBox>
&nbsp;:
			<asp:TextBox ID="txtOriEndMinutes" runat="server" Width="25px" Enabled="False" ReadOnly="True"></asp:TextBox>
&nbsp; (correction:
			<asp:TextBox ID="txtCorrectedEndHr" runat="server" Width="25px"></asp:TextBox>
			:
			<asp:TextBox ID="txtCorrectedEndMinutes" runat="server" Width="25px"></asp:TextBox>
			)<br />
			<br />
			<strong>Note<br />
			</strong>
			<asp:TextBox ID="txtNotes" runat="server" Height="54px" TextMode="MultiLine" Width="318px"></asp:TextBox>
			<br />
			<asp:CheckBox ID="chkIsAdmin" runat="server" Text="Temps administratif" /> <span style="font-size: 0.9em">(non inclue dans le  <a target="_blank" href="report/PerformanceWeb.aspx">rapport de performance</a>)</span>
			<br />
			<asp:CheckBox ID="chkCancel" runat="server" Text="Annuler la période de temps" />
			<br />
			<asp:Button runat="server" CssClass="btn btn-primary" ID=cmdSave Text="Approuver &amp; Sauvegarder" onclick="cmdSave_Click" />
    </div>
    </form>
</body>
</html>
