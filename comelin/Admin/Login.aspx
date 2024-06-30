<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebSite.Admin.PageLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		#divLogin {text-align: center; height: 100%;padding: 0;margin: 0;display: flex;align-items: center;justify-content: center;flex-direction: column;}
		#cmdConnect {margin-top:20px;display: block}
		h3{margin:20px}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id=divLogin title="Connection">
			<h3>Panneau administratif</h3>
		<h4>Connexion à Comelin</h4>
			<asp:TextBox ID="txtPassword" runat="server" ClientIDMode=Static TextMode=Password Font-Size="20px" autocomplete="current-password"></asp:TextBox>
			
			<asp:Button ID="cmdConnect" ClientIDMode="Static" runat="server" CssClass="btn btn-primary" Text="Se connecter" onclick="cmdConnect_Click" />
	</div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		var ctrl = $$('txtPassword');
		ctrl.focus();
		ctrl.addEventListener("keydown", checkCapsLock);
		
		var isCaplookNotificationSent = false;
        function checkCapsLock(event) {
            if (isCaplookNotificationSent || !event.getModifierState) {
				return;
            }
            let isCapsLockOn = event.getModifierState("CapsLock");
            if(isCapsLockOn) {
                console.log("Caps Lock turned on");
				isCaplookNotificationSent = true;
				notifyError('Clavier en majuscule (Caps Lock)', ctrl);
            } 
        }
	</script>
</asp:Content>
