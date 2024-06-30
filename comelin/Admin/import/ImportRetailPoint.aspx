<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportRetailPoint.aspx.cs" Inherits="WebSite.Admin.import.ImportRetailPoint" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Importation de retail point</h1>
	<ol>
		<li>Se connecter sur le poste <b>SERVEUR</b></li>
		<li>Ouvrir "<b>Centre de Contrôle HFSQL</b>"</li>
		<li>Les données sont partiellement dans le répertoire "01" (autre chiffre pour autre magasin)</li>
	</ol>
	<hr/>
	Fichier "lineX": <asp:FileUpload ID="uploadFileLineX" runat="server" />
	<br />
	<code>select * from &quot;lineX&quot;</code><hr/>
	Fichier "lineY": <asp:FileUpload ID="uploadFileLineY" runat="server" />
	<br />
	<code>select * from &quot;lineY&quot;</code><hr/>
	Fichier "lineZ": <asp:FileUpload ID="uploadFileLineZ" runat="server" />
	<br />
	<code>select * from &quot;lineZ&quot;</code><hr/>
	Fichier &quot;matrice&quot; <asp:FileUpload ID="uploadFileMatrix" runat="server" />
&nbsp;(export de la base de donnée)<br />
	<code>select numprodfou, "01\PRODUITM".CdProduit, cdscale, NumSeqX, NumSeqY, NumSeqZ, specificat, "01\PRODUITM".QteEnMain, "01\PRODUITM".rp_barcode, DESCRIPTL1, "01\PRODUIT".COUTRFOU, "01\PRODUIT".PRIX1, CDFOURN, datecreati, DEPARTMENT, SUBDEPARTM, RP_BARCODE, SEASON
from "01\PRODUITM" 
inner join "01\PRODUIT" on "01\PRODUIT".CdProduit = "01\PRODUITM".CdProduit
	<br />
	<br />
	where qteenmain > 0</code>
	
	<hr/>
	<br />
	
	Fichier "clients" <asp:FileUpload ID="uploadFileCustomer" runat="server" />
	<code>
    <br />
    select cdclient, prenom, nomfamille, lignedadd1, lignedadd2, appartemen, cdville, cdprovet, cdpays, codepostal, tel, telautre, email, memo, datecreati, creditf, accountbal, preflang, fidelpoints, consent_pub 
from clients</code>
	<br />
    <br />
    Fichier carte cadeau et note de crédit: <asp:FileUpload ID="uploadFileGiftCardAndCreditNote" runat="server" />
	&nbsp;<br />
    <code>select * from &quot;01\GIFTCERT&quot;</code><br />
	<br />
	Export en avec menu contextuelle sur les la grillee de résultat. Ouvrir dans EXCEL, puis exporter en CSV.<br/>
	
	
	<br />
	<asp:CheckBox ID="chkCombineXYZ" runat="server" Checked="True" Text="Combiner les X ensemble, les Y ensembles et les Z ensemble" />
	<br />
&nbsp;&nbsp;&nbsp;
	<asp:CheckBox ID="chkRemoveAttribUnused" runat="server" Text="Enlever les valeurs non utilisés" Checked="True" />
	<br />
	<asp:CheckBox ID="chkOnlyInventory" runat="server" Text="Mettre seulement l'inventaire à jour" />
	<br />
	<asp:CheckBox ID="chkYOver1000Only" runat="server" Text="Seulement les produits non trouvés" />
	<br />
	
	
	<br />

	<asp:Button ID="cmdGo" runat="server" Text="Importation" OnClick="cmdGo_Click" />

&nbsp;
<asp:DropDownList ID="lstStore" runat="server">
</asp:DropDownList>

	<br />
	<br />
	<br />
	<asp:Button ID="cmdImportMatricIdNotDigit" runat="server" OnClick="cmdFindMissingProducts" Text="Trouver les produits qui manque" />

</asp:Content>
