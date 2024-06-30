<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="ImportClientMultiLigne.aspx.cs" Inherits="WebSite.Admin.import.ImportClientMultiLigne" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Importation de client dans une fichier multi-ligne</h1>
	
	Format du fichier (lalooma). Fichier Excel ré-exporté en CSV, le format texte n'est pas bon puisque les champs d'information sont tronqués.
	<div>
	<code>La Looma,,,,,,,,,,<br/>
Liste des clients au  22-04-2021,,,,,,,,,,<br/>
,,,,,,,,,,<br/>
Nom,Rue 1,Rue 2,Ville,Province,Code postal,Téléphone 1,Solde à payer,Courriel,Ventes cumulées à ce jour,Champ1<br/>
 Alicia Lemelin,,,,Québec,,, 000 ,, 000 ,<br/>
  Adresse d'expédition,,,,Québec,,,,,,<br/>
,,,,,,,,,,<br/>
 CARL DESCHENES,1126 Des Chanterelles,,QUEBEC,Québec,G3K 1H7,(418) 574-1287, 000 , lander069@hotmail.com, 000 ,<br/>
  Adresse d'expédition,,,St Bruno,Québec,,,,,,<br/>
,,,,,,,,,,</code>
		</div>
	<asp:FileUpload ID="FileUpload1" runat="server" /><asp:Button ID="cmdImport" runat="server" Text="Importation" OnClick="cmdImport_Click" />
</asp:Content>
