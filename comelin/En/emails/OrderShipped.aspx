<%@ Page Title="Shipping Confirmation -" Language="C#" MasterPageFile="Email.Master" AutoEventWireup="true" CodeBehind="OrderShipped.aspx.cs" Inherits="WebSite.Fr.emails.OrderShippedPage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
<%
string trackingCode = Request.QueryString["tracking"];
if (trackingCode == null || trackingCode.StartsWith("Envel", StringComparison.CurrentCultureIgnoreCase)) {
  // enveloppe
  Response.Write(@"Your package has been shipped by Canada Post in an envelope.<br />
Delivery will take about 3-4 business days.");
} else {
	trackingCode = trackingCode.Trim();

	    if (trackingCode.StartsWith("YOJ-") || trackingCode.Length == 11 && trackingCode.EndsWith("-00")) {
			// Courant plus
			Response.Write(string.Format(@"Your order has been shipped with Courant plus.<br />You can follow the status of the shipment at<a href=""https://courrierpro.courrierplus.com/c2000web/?SuiviCie=2&SuiviMulti={0}"">Courant plus</a>", trackingCode));
		} else if (trackingCode.Length == 12 && trackingCode.StartsWith("33")) {
			// purolator
			Response.Write(string.Format(@"Your order has been shipped with PUROLATOR.<br />You can follow the status of the shipment at<a href=""https://www.purolator.com/en/shipping/tracker?pin={0}"">PUROLATOR</a>", trackingCode));
		} else if (trackingCode.Length == 22 && trackingCode.StartsWith("D", StringComparison.CurrentCultureIgnoreCase)) {
			// CANPAR
			Response.Write(string.Format(@"Your order has been shipped with CANPAR.<br />You can follow the status of the shipment at<a href=""https://www.canpar.com/en/track/TrackingAction.do?locale=en&type=0&reference=D420926810000922479001{0}"">Canpar</a>", trackingCode));
		} else if (trackingCode.Length <= 11 && trackingCode.StartsWith("W", StringComparison.CurrentCultureIgnoreCase)) {
			// dicom
			Response.Write(string.Format(@"Your order has been shipped with DICOM.<br />You can follow the status of the shipment at<a href=""https://www.dicom.com/en/dicomexpress/tracking/load-tracking/{0}?Division=DicomExpress"">DICOM</a>", trackingCode));
		} else if (trackingCode.StartsWith("1Z")) {
			// UPS
			Response.Write(string.Format(@"Your order has been shipped with UPS.<br />You can follow the status of the shipment at<a href=""http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums={0}"">UPS</a>", trackingCode));
		} else if (trackingCode.Length == 16) {
			// assume canada post
			Response.Write(string.Format(@"Your order has been shipped with Postes Canada.<br />You can follow the status of the shipment at<a href=""http://www.canadapost.ca/cpotools/apps/track/personal/findByTrackNumber?trackingNumber={0}&LOCALE==en"">Postes Canada</a>", trackingCode));
		} else if (trackingCode.Length == 9 && trackingCode.StartsWith("502")) {
		    // assume Nationex
		    Response.Write(string.Format(@"Your order has been shipped with  Nationex.<br />You can follow the status of the shipment at <a href=""https://www.nationex.com/en/track/tracking-report/?tracking%5B%5D={0}"">Nationex</a>", trackingCode));
		} else if (trackingCode.Length == 12 && Util.StrToInt64(trackingCode) > 0) {
			// fex ed
			Response.Write(string.Format(@"Your order has been shipped with FedEx.<br />You can follow the status of the shipment at<a href=""https://www.fedex.com/apps/fedextrack/?tracknumbers={0}&language=en&cntry_code=ca"">FedEx</a>", trackingCode));
		} else if (trackingCode.Length == 12) { /* letters and numbers */
		    // BoxKnight  
		    Response.Write(string.Format(@"Your order has been shipped with BoxKnight.<br />You can follow the status of the shipment at <a href=""https://www.tracking.boxknight.com/tracking?trackingNo={0}"">BoxKnight</a>", trackingCode));
		} else {
			// don't know
			Response.Write(string.Format(@"Your order has been shipped (<a href=""https://track.aftership.com/?tracking-numbers={0}&language=en"">track package</a>)", trackingCode));
		}
		Response.Write(string.Format("<br />Tracking number: <b>{0}</b>", trackingCode));
	}
%>

<br />
<h3>Purchase Order Copy:</h3>
<br />
<%
System.Net.WebClient client = new System.Net.WebClient();
client.Encoding = Encoding.UTF8;
Response.Write(client.DownloadString(Settings.Current.WebSite + Request.QueryString["orderUrl"]));
 %>
      
</asp:Content>
