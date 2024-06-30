<%@ Page Title="Importer des produits" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportProducts.aspx.cs"
	 Inherits="WebSite.Admin.ImportProduct" ValidateRequest="false" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  <h1>
    <img src="/Admin/images/import-customer.png" />
    Importer des produits</h1>

  <div id="step1" runat="server" visible="false">
    Le fichier doit être en format txt (tab-delimited)
	<br />
    La première ligne sera considérer comme une entête (pas un produit)
	<br />
    <asp:FileUpload ID="file" runat="server" />
      &nbsp;<asp:CheckBox ID="chkMatrixAcomba" runat="server" Text="Matrice Acomba" />

      <asp:CheckBox ID="chkMatrixWooCommerce" runat="server" Text="Matrice WooCommerce" ToolTip="Woocommerce en exportation des produits en format CSV" />

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
            <asp:TextBox ID="txtField1" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader1" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField1" runat="server" /><asp:DropDownList ID="lstAttrib1" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField2" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader2" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField2" runat="server" /><asp:DropDownList ID="lstAttrib2" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField3" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader3" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField3" runat="server" /><asp:DropDownList ID="lstAttrib3" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField4" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader4" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField4" runat="server" /><asp:DropDownList ID="lstAttrib4" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField5" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader5" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField5" runat="server" /><asp:DropDownList ID="lstAttrib5" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField6" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader6" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField6" runat="server" /><asp:DropDownList ID="lstAttrib6" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField7" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader7" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField7" runat="server" /><asp:DropDownList ID="lstAttrib7" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField8" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader8" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField8" runat="server" /><asp:DropDownList ID="lstAttrib8" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField9" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader9" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField9" runat="server" /><asp:DropDownList ID="lstAttrib9" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField10" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader10" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField10" runat="server" /><asp:DropDownList ID="lstAttrib10" runat="server" />
          </td>
        </tr>
         <tr>
          <td>
            <asp:TextBox ID="txtField11" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader11" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField11" runat="server" /><asp:DropDownList ID="lstAttrib11" runat="server" />
          </td>
        </tr>
         <tr>
          <td>
            <asp:TextBox ID="txtField12" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader12" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField12" runat="server" /><asp:DropDownList ID="lstAttrib12" runat="server" />
          </td>
        </tr>
         <tr>
          <td>
            <asp:TextBox ID="txtField13" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader13" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField13" runat="server" /><asp:DropDownList ID="lstAttrib13" runat="server" />
          </td>
        </tr>
		   <tr>
          <td>
            <asp:TextBox ID="txtField14" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader14" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField14" runat="server" /><asp:DropDownList ID="lstAttrib14" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField15" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader15" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField15" runat="server" /><asp:DropDownList ID="lstAttrib15" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField16" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader16" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField16" runat="server" /><asp:DropDownList ID="lstAttrib16" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField17" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader17" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField17" runat="server" /><asp:DropDownList ID="lstAttrib17" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField18" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader18" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField18" runat="server" /><asp:DropDownList ID="lstAttrib18" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField19" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader19" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField19" runat="server" /><asp:DropDownList ID="lstAttrib19" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField20" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader20" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField20" runat="server" /><asp:DropDownList ID="lstAttrib20" runat="server" />
          </td>
        </tr>
      
        <tr>
          <td>
            <asp:TextBox ID="txtField21" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader21" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField21" runat="server" /><asp:DropDownList ID="lstAttrib21" runat="server" />
          </td>
        </tr>
         <tr>
          <td>
            <asp:TextBox ID="txtField22" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader22" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField22" runat="server" /><asp:DropDownList ID="lstAttrib22" runat="server" />
          </td>
        </tr>
         <tr>
          <td>
            <asp:TextBox ID="txtField23" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader23" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField23" runat="server" /><asp:DropDownList ID="lstAttrib23" runat="server" />
          </td>
        </tr>
		   <tr>
          <td>
            <asp:TextBox ID="txtField24" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader24" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField24" runat="server" /><asp:DropDownList ID="lstAttrib24" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField25" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader25" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField25" runat="server" /><asp:DropDownList ID="lstAttrib25" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField26" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader26" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField26" runat="server" /><asp:DropDownList ID="lstAttrib26" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField27" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader27" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField27" runat="server" /><asp:DropDownList ID="lstAttrib27" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField28" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader28" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField28" runat="server" /><asp:DropDownList ID="lstAttrib28" runat="server" />
          </td>
        </tr>
        <tr>
          <td>
            <asp:TextBox ID="txtField29" runat="server" CssClass="sample-value" />
          </td>
          <td>
            <asp:TextBox ID="txtHeader29" runat="server"></asp:TextBox>
          </td>
          <td>
            <asp:DropDownList ID="lstField29" runat="server" /><asp:DropDownList ID="lstAttrib29" runat="server" />
          </td>
        </tr>
      

      </tbody>
    </table>

    <br />
      <br />
    <asp:CheckBox ID="chkImportInventory" runat="server" Text="Ajouter dans l'inventaire (au lieu de créer les produits)" />
      <br />
	      <asp:CheckBox ID="chkDeleteTransactions" runat="server" Text="Effacer tous les transactions précédentes" />

	  <br />
	  <asp:CheckBox ID="chkDoNotImportIfInventoryIs0" runat="server" Text="Ne pas importer si inventaire est à 0"  />

	  <br />
	  <asp:CheckBox ID="chkBulkAssignInventoryToReferenceUnit" runat="server" Text="(Vrac): Asisgné l'inventaire au format 1Kg / 1unité" Checked="True"  />

	  <br />
	  <asp:CheckBox ID="chkCodeBarCodeMixed" runat="server" Text="&quot;Démêler&quot; les codes et code à barre"  />

	  <br />
	  <br />
	  Si le produit n&#39;est pas dans le fichier d&#39;inventaire<br />
&nbsp;&nbsp;&nbsp;
    <asp:CheckBox ID="chkInventoryReset" runat="server" Text="Reset d'inventaire à 0" />
      <br />
&nbsp;&nbsp;&nbsp;
    <asp:CheckBox ID="chkDeleteProductNotImported" runat="server" Text="Effacer le produit" />
    <br />
	      <br />
	  Si le produit n&#39;est pas dans la base de donnée. Compare avec
	  <asp:DropDownList ID="lstMatchBy" runat="server">
		  <asp:ListItem>Barcode ou Code</asp:ListItem>
		  <asp:ListItem>Reference</asp:ListItem>
		  <asp:ListItem>Code Fournisseur</asp:ListItem>
		  <asp:ListItem>Barcode seulement</asp:ListItem>
		  <asp:ListItem>Titre de produit</asp:ListItem>
	  </asp:DropDownList>
	  <br />
   &nbsp;&nbsp;&nbsp; <asp:CheckBox ID="chkIfNotFoundImport" runat="server" Text="Importer le produit" Checked="True" /> dans <asp:TextBox runat="server" id="txtIfNotFoundImportIn"/>
	      <br />
&nbsp;&nbsp;&nbsp;

	  <br/>
    <asp:CheckBox ID="chkUpdateExisting" runat="server" Text="Mettre à jour si le produit existe" Checked="True" />
    <br />
    <br />

    <br />

    <asp:Button ID="cmdImport" runat="server" Text="Importer" OnClick="cmdImport_Click" />
    &nbsp;
		<asp:DropDownList ID="lstStore" runat="server">
</asp:DropDownList>

	  <br />
		<asp:Button ID="cmdDuplicate" runat="server" OnClick="cmdDuplicate_Click" Text="Duplicata?" />

  </div>
	<hr/>
	<a href="ImportProductGoDaddy.aspx">E-commerce GoDaddy</a>
	<style>
		.sample-value {width: 250px; margin-right: 10px; margin-bottom: 5px}
	</style>
</asp:Content>
