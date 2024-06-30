<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemoryStats.aspx.cs" Inherits="WebSite.Admin.MemoryStats" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Memory stats</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    Memory usage: <%= GC.GetTotalMemory(true).ToString("N") %>
    </div>
    </form>
</body>
</html>
