<%@ Page Title="" Language="C#" MasterPageFile="~/Fr/MP.Master" AutoEventWireup="true" CodeBehind="Inscription.aspx.cs" Inherits="WebSite.Fr.Inscription" EnableViewState="true" ValidateRequest="true" %>
<%@ Register src="uc/ucIdentification.ascx" tagname="ucIdentification" tagprefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
  			<div class="row page-inscription">
				<div class="col-12">
					<h1>Inscription - Mon compte
          </h1>					
				</div>
				<uc1:ucIdentification ID="ucIdentification1" runat="server" />
          	</div>
          <asp:Button ID="cmdSave" ClientIDMode="Static" runat="server" Text="Créer mon compte" CssClass="btn btn-primary" OnClick="cmdSave_Click" />

		
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
  <%=Javascripts %>
</asp:Content>
