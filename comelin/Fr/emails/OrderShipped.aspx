<%@ Page Title="Confirmation d'expédition -" Language="C#" MasterPageFile="~/Fr/emails/Email.Master" AutoEventWireup="true" Inherits="WebSite.Fr.emails.OrderShippedPage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
<%
	string trackingCode = Request.QueryString["tracking"];
	if (trackingCode == null || trackingCode.StartsWith("Envel", StringComparison.CurrentCultureIgnoreCase)) {
		// enveloppe
		Response.Write(@"Votre colis a été expédié par Postes Canada dans une enveloppe.<br />
Prévoir 3-4 jours ouvrables pour recevoir la marchandise.");
	} else {
		trackingCode = trackingCode.Trim();

		if (trackingCode.StartsWith("YOJ-") || (trackingCode.Length == 11 && trackingCode.EndsWith("-00"))) {
			// Courant plus
			Response.Write(string.Format(@"Votre colis a été expédié par Courant plus.<br />Vous pouvez repérer le colis sur le site web de <a href=""https://courrierpro.courrierplus.com/c2000web/?SuiviCie=2&SuiviMulti={0}"">Courant plus</a>", trackingCode));
		} else if (trackingCode.Length == 12 && trackingCode.StartsWith("33")) {
			// purolator
			Response.Write(string.Format(@"Votre colis a été expédié par PUROLATOR.<br />Vous pouvez repérer le colis sur le site web de <a href=""https://www.purolator.com/fr/shipping/tracker?pin={0}"">PUROLATOR</a>", trackingCode));
		} else if (trackingCode.Length == 22 && trackingCode.StartsWith("D", StringComparison.CurrentCultureIgnoreCase)) {
			// canpar
			Response.Write(string.Format(@"Votre colis a été expédié par CANPAR.<br />Vous pouvez repérer le colis sur le site web de <a href=""https://www.canpar.com/fr/track/TrackingAction.do?locale=fr&type=0&reference={0}"">Canpar</a>", trackingCode));
		} else if (trackingCode.Length <= 9 && trackingCode.StartsWith("W", StringComparison.CurrentCultureIgnoreCase)) {
			// dicom
			Response.Write(string.Format(@"Votre colis a été expédié par DICOM.<br />Vous pouvez repérer le colis sur le site web de <a href=""https://www.dicom.com/en/dicomexpress/tracking/load-tracking/{0}?Division=DicomExpress"">DICOM</a>", trackingCode));
		} else if (trackingCode.StartsWith("1Z")) {
			// UPS
			Response.Write(string.Format(@"Votre colis a été expédié par UPS.<br />Vous pouvez repérer le colis sur le site web de <a href=""http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums={0}"">UPS</a>", trackingCode));
		} else if (trackingCode.Length == 16) {
			// assume canada post
			Response.Write(string.Format(@"Votre colis a été expédié par Postes Canada.<br />Vous pouvez repérer le colis sur le site web de <a href=""http://www.canadapost.ca/cpotools/apps/track/personal/findByTrackNumber?trackingNumber={0}&LOCALE=fr"">Postes Canada</a>", trackingCode));
		} else if (trackingCode.Length == 9 && trackingCode.StartsWith("502")) {
			// assume Nationex
			Response.Write(string.Format(@"Votre colis a été expédié par Nationex.<br />Vous pouvez repérer le colis sur le site web de <a href=""https://www.nationex.com/en/track/tracking-report/?tracking%5B%5D={0}"">Nationex</a>", trackingCode));
		} else if (trackingCode.Length == 12 && Util.StrToInt64(trackingCode) > 0) {
			// fex ed
			Response.Write(string.Format(@"Votre colis a été expédié par FedEx.<br />Vous pouvez repérer le colis sur le site web de <a href=""https://www.fedex.com/apps/fedextrack/?tracknumbers={0}&language=fr&cntry_code=ca"">FedEx</a>", trackingCode));
		} else if (trackingCode.Length == 12) { /* letters and numbers */
		    // BoxKnight  
		    Response.Write(string.Format(@"Votre colis a été expédié par BoxKnight.<br />Vous pouvez repérer le colis sur le site web de <a href=""https://www.tracking.boxknight.com/tracking?trackingNo={0}"">BoxKnight</a>", trackingCode));
		} else {
			// don't know
			Response.Write(string.Format(@"Votre colis a été expédié (<a href=""https://track.aftership.com/?tracking-numbers={0}&language=fr"">repérer le colis</a>)", trackingCode));
		}
		Response.Write(string.Format("<br />Numéro de référence: <b>{0}</b>", trackingCode));
	}
%>

<br />
<h3>Copie de la facture</h3>
<br />
<%
System.Net.WebClient client = new System.Net.WebClient();
client.Encoding = Encoding.UTF8;
string url = null;
try {
    url = Settings.Current.WebSite + Request.QueryString["orderUrl"];
    Response.Write(client.DownloadString(url));
} catch (Exception ex) {
    ExceptionLog.Log(string.Format("Failed to download url or in ordershipped. Url: {0}", url), ex);
}

 %>
      
</asp:Content>
