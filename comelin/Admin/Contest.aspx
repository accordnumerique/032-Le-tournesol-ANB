<%@ Page Title="Concours" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Contest.aspx.cs" Inherits="WebSite.Admin.Contest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img alt="" src="images/contest.png" /> Concours</h1>
<p>&nbsp;</p>
Il y a présentement <%=NbCustomerContest %> clients enregistrés au concours.<br />
<br />
<h1>Faire un tirage au sort?</h1>
	Comelin choisit au hasard un client parmi ceux dont l'option "participer au concours" est activée dans leur profil.<br />
	
	Tous les clients sont automatiquement inscrits lorsqu'ils effectuent un achat dans Comelin. Il est aussi possible d'inscrire un client en sélectionnant l'option "participer au concours" dans son profil.<br />
	<br />
<asp:Button ID="cmdContest" runat="server" Text="Faire le tirage au sort!" onclick="cmdContest_Click" />
<h1>Débuter l'enregistrement à un nouveau concours </h1>
Vous pouvez retirer l'option "participer au concours" de tous vos clients actuels, ce qui fera en sorte que seul les clients effectuant des achats à partir de maintenant seront inscrits au concours.
<br />
<b>Cette option est non réversible!</b>

<br />
	<br />
	<asp:Button ID="cmdNewContest" runat="server" onclick="cmdNewContest_Click" 
		Text="Nouveau concours" OnClientClick="return confirm('Certain?')" />

</asp:Content>
