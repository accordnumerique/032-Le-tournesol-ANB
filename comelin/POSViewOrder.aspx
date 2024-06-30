<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="POSViewOrder.aspx.cs" Inherits="WebSite.POSViewOrder" EnableViewState="false" %>
<!DOCTYPE html>
<html>
<head runat="server">
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<title>Facture / Order</title>
</head>
<body>
	<div style="font-family: Calibri;  font-size:14px">
		<table style="width: 100%">
			<tr>
				<td style="width:33%">#<%= OrderId %></td>
				<td style="width:33%; text-align: center">
					<div id="divTitle" runat="server" ClientIDMode="Static" style="display: inline-block; background-color: #ffcb97;  border: solid 1px #ff7f00; box-sizing: border-box; padding: 10px; text-align: center; font-size: 18px;"></div>
				</td>
				<td style="width:33%; text-align: right">
					<asp:Literal ID="lblOrderDate" runat="server">2015-1-1</asp:Literal><br />
				</td>
			</tr>
			<tr>
				<td style="text-align: left;">
					<img id="logo" runat="server" width="150" style="width: 150px;margin: 10px 0;" /><br />
					<%= HeaderText %>
				</td>
				<td></td>
				<td style="vertical-align: bottom">
					<div style="float: right; text-align: center">
						<asp:Literal ID="lblBillingAddress" runat="server" />
					</div>
				</td>
			</tr>
		</table>
	<br />
	<table style="width: 100%; border: 0; border-collapse: collapse; margin-bottom: 8px" cellpadding="5">
		<tr style="background-color: #eee; border: 1px black solid; font-weight: bold">
			<td style="white-space:nowrap;min-width: 70px;"><%=Translation.GetText("CartQuantity") %></td>
			<td runat=server id=colCode>Code</td>
			<td style="min-width: 70px;" runat=server id=colBarCode>BarCode</td>
			<td style="min-width: 70px;" runat=server id=colSupplierCode><%=Translation.GetText("SupplierCode")%></td>
			<td><%=Translation.GetText("CartItem") %> </td>
			<td id="colAttrib1" runat="server" Visible="False">filtre #1</td>
			<td id="colAttrib2" runat="server" Visible="False">filtre #2</td>
			<td id="colAttrib3" runat="server" Visible="False">filtre #3</td>
			<td id="colVolume" runat="server" Visible="False">Volume</td>
			<td style="text-align: right;min-width: 70px;" runat=server id=colCost Visible="False"><%=Translation.GetText("Cost")%> </td>
			<td style="text-align: right;min-width: 70px;" runat="server" id="colPrice"><%=Translation.GetText("CartUnitPrice") %> </td>
			<td style="text-align: right; min-width: 70px;" id="colTotal" runat="server">Total </td>
            <td style="text-align: right; width: 20px;" id="colTax" runat="server">Tax </td>
		</tr>
		<asp:Literal ID="lblLines" runat="server" />
	</table>
	
	<table style="width: 100%">
		<tr>
			<td>
				<p><%=Translation.GetText("TotalItems") %>: <asp:Literal runat="server" id="lblNbArticles"></asp:Literal><br/></p>
		<p id="divPayment" runat="server"><%=Translation.GetText("CartPayment") %>: <asp:Literal ID="lblPaymenetMode" runat="server">Visa</asp:Literal></p>
		<p><asp:Literal ID="lblNote" runat="server" /></p>
			</td>
			<td align="right">
				<table cellpadding=6 style="width: 300px; border-spacing: 0">
				<tr runat="server" id="rowTotalCost" Visible="false">
					<td>Total <%=Translation.GetText("Cost") %> </td>
					<td style="text-align: right"><asp:Literal ID="lblTotalCost" runat="server" /> </td>
				</tr>

				<tr runat="server" id="rowGlobalDiscount" Visible="False">
					<td><%=Translation.GetText("Rebate")%></td>
					<td style="text-align: right"><asp:Literal ID="lblGlobalDiscount" runat="server" /> </td>
				</tr>
				<tr runat="server" id="rowPayWithPoints" Visible="False">
					<td><%=Translation.GetText("PaymentFidelityPoints")%></td>
					<td style="text-align: right"><asp:Literal ID="lblPayWithPoints" runat="server" /> </td>
				</tr>
				<tr runat="server" id="rowSubTotalItem">
					<td>Total <%=Translation.GetText("GlobalProducts") %> </td>
					<td style="text-align: right"><asp:Literal ID="lblSubTotalItem" runat="server" /> </td>
				</tr>
				<tr runat="server" id="rowPreparationFee" Visible="False">
					<td><%=Translation.GetText("PreparationFee")%></td>
					<td style="text-align: right"><asp:Literal ID="lblPreparationFee" runat="server" /> </td>
				</tr>
				<tr runat="server" id="rowTransport">
					<td><%= TransportLabel %></td>
					<td style="text-align: right"><asp:Literal ID="lblTransport" runat="server" /> </td>
				</tr>
				<tr runat="server" id="rowSubTotal">
					<td style="border-top: solid 1px black"><%=Translation.GetText("CartSubTotal") %> </td>
					<td style="text-align: right; border-top: solid 1px black"><asp:Literal ID="lblSubTotal" runat="server" /> </td>
				</tr>
				<tr runat="server" id="rowtps">
					<td><%=Translation.GetText("Tax1") %> #<%= Tax1 %> </td>
					<td style="text-align: right"><asp:Literal ID="lblTPS" runat="server" /> </td>
				</tr>
				<tr runat="server" id="rowtvp">
					<td><%=Translation.GetText("Tax2") %> #<%= Tax2 %> </td>
					<td style="text-align: right"><asp:Literal ID="lblTVP" runat="server" /> </td>
				</tr>
				<tr runat=server id=rowTotal >
					<td style="border-top: solid 1px black"><b>Total</b> </td>
					<td style="font-weight: bold; text-align: right;border-top: solid 1px black"><asp:Literal ID="lblTotal" runat="server" /> </td>
				</tr>
					
				<tbody runat="server" id="tbodyPayment">
					<%= RenderPaymentRows() %>
				</tbody>
			</table>
			</td>
		</tr>
	</table>
		<div style="text-align: center; clear: both;padding: 5px 0;"><%= FotterText%></div>
	<div style="float:left" id="divSignature" runat="server" Visible="false">
		<img runat="server" id="imgSignature" style="width: 250px" />	<br/>
		<asp:Label runat="server" ID="lblSignatureName" Font-Names="monospace" Text="test"></asp:Label><br>
		<asp:Label runat="server" ID="lblSignatureDate" Font-Names="" Text="test"></asp:Label>
	</div>
	<div style="float:right;text-align: center">
		<div style="display: inline-block">
			<%= Delivery %>
		</div>
		<div style="display: inline-block">
		<img runat="server" id="imgBarcode"/>	</div>
		
		

	</div>
       <%=QrCode %>
	<pre><%= PaymentReceipts %></pre>
		
		</div>
	<asp:Literal runat="server" EnableViewState="False" ID="customCSS"></asp:Literal>
</body>
</html>