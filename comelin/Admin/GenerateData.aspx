<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GenerateData.aspx.cs" Inherits="WebSite.Admin.GenerateData" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    	<h1>Data Generators</h1>
				<%= UserMessage.Write() %>
			<asp:Button ID="cmdGenerateCustomer" runat="server" onclick="cmdGenerateCustomer_Click" Text="Generate 1 Customer " />
			<br />
			<br />
    
    </div>
    <asp:Button ID="cmdGenerateSale" runat="server" onclick="cmdGenerateSale_Click" Text="Generate one sale" />
    <br />
		<br />
		<asp:Button ID="cmdReceiveStock" runat="server" onclick="cmdReceiveStock_Click" Text="Generate Receice Stock" />
    </form>
</body>
</html>
