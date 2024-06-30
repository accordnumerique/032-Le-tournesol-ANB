<%@ Page Title="Références" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Referrers.aspx.cs" Inherits="WebSite.Admin.PageReferrers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
    #grid { margin:20px;}
    #grid td, #grid th { padding:8px}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="images/references.png"> Référence Partenaires</h1>
	Les références vous permettront d'avoir des statistiques sur les ventes si un de vos partenaires web vous envoies des visiteurs.	&nbsp;<asp:GridView ID="grid" ClientIDMode="Static" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="id"  OnRowEditing="grid_RowEditing" OnRowUpdating="grid_RowUpdating" OnRowDeleting="grid_RowDeleting">
    <Columns>
      <asp:BoundField DataField="Id" HeaderText="id" InsertVisible="False" ReadOnly="True" Visible="false" />
      <asp:BoundField DataField="Code" HeaderText="Code" SortExpression="Code" />
      <asp:BoundField DataField="Name" HeaderText="Nom" SortExpression="Name" />
      <asp:HyperLinkField DataTextField="Name" DataTextFormatString="Rapport" DataNavigateUrlFields="IdEncryptedEncoding" DataNavigateUrlFormatString="RapportReference.aspx?q={0}"   />
      <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" CancelText="Annuler le changement" DeleteText="Effacer" EditText="Modifier" UpdateText="Confirmation" />
    </Columns>
  </asp:GridView>
  
    <div id="appConfiguration">
    <config-section label="Options">
        <check id="displayWelcome" setting="_RefDisplayWelcome">Afficher un message de bienvenue lors de la première visible</check>

    </config-section>
        <div v-if="nbPropertiesToSave" id="barSave">
            <div class="container">
                <div class="btn btn-primary" @click="save" id="cmdSave">
                    Sauvegarder
                    <span v-if="nbPropertiesToSave > 1">{{nbPropertiesToSave}} modifications</span>
                    <li v-if="DEBUG" v-for="(v, k) in settingsPropertiesUpdate">{{k}} - {{v}}</li>
                </div>
            </div>
        </div>
    </div>
    
    <h2>Intégration</h2>
    <p>Le <code>code</code> de référence doit être mis dans le url pour s'activer. Il peut-être mis sur la page d'accueil ou n'importe quelle page de la boutique en ligne (une catégorie de produits ou un produit en particulier). Une notification est visible pour confirmer que la référence a été bien mise.<br/>
        [Url de votre site]?ref=[code]<br/>
        
        Ex: <a href="https://demo.comelin.com/fr/Enfant-c75?ref=scout">https://demo.comelin.com/fr/Enfant-c75<span style="font-weight: bold; color:red">?ref=scout</span></a>
    </p>
  <br />
    
    <asp:Button runat="server" Text="Ajouter nouvelle référence" ID="cmdAdd" OnClick="cmdAdd_Click" />

    <asp:SqlDataSource ID="SqlReferrers" runat="server" ConnectionString="<%$ ConnectionStrings:SqlServer %>" DeleteCommand="DELETE FROM [Referrers] WHERE [id] = @id" InsertCommand="INSERT INTO [Referrers] ([code], [name]) VALUES (@code, @name)" SelectCommand="SELECT [id], [code], [name] FROM [Referrers] ORDER BY [datesince] DESC" UpdateCommand="UPDATE [Referrers] SET [code] = @code, [name] = @name WHERE [id] = @id">
        <DeleteParameters>
            <asp:Parameter Name="id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="code" Type="String" />
            <asp:Parameter Name="name" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="code" Type="String" />
            <asp:Parameter Name="name" Type="String" />
            <asp:Parameter Name="id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <script src="/admin/js/configuration.js"></script>
    </asp:Content>