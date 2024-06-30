<%@ Page Title="Horodateur" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Punchs.aspx.cs" Inherits="WebSite.Admin.PunchPage" %>

<%@ Register Src="~/Admin/ucDateRangePicker.ascx" TagPrefix="uc1" TagName="ucDateRangePicker" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		body{font-family:Helvetica, sans-serif}
		.punchTable {margin:20px;width:600px; font-size:120%;}
		.punchTable td {text-align:right;}
		.punchTable thead {font-size:150%;}
		.punchTable thead td {width:100px; height:40px; vertical-align:middle;}
		.punchTable thead td:first-child {text-align:left; width:auto;}
		.editTime:hover { text-decoration:underline; color:#15c; cursor:pointer }
		.timeCorrected { background-color:rgb(226, 236, 158)}
		.strike { text-decoration:line-through}
		.timeError { color:Red; font-weight:bold}
		.timeout { background-color:Red}
		.currentlyOnline { background-color:LightBlue; font-weight:bold}
		.fa-check-square-o { color:Green }
		.fa-square-o { color:Gray}
		.fa-square-o:hover { color:green}
		.fa-file-text { color:Blue}
		.fa-file-text:hover { color:rgb(0, 0, 181)}
		.fa-university {margin-left: 10px;}
		.live {cursor: help}
	</style>
	
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
		<h1><img alt="" src="images/punch.png" /> Horodateur / Punch-in & Punch-out</h1>	
			<br />
	
	<div id="app">
		<currently-online></currently-online>
    </div>

	<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
<br />
	<div id=cmdAddOpenDialog  runat="server" ClientIDMode="Static" class="btn btn-warning">Ajouter une nouvelle période de temps</div> 
		<%= RenderReport() %>

	<div class="modal" id="DialogAdd" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title" id="myModalLabel">Ajouter une période</h4>
				</div>
				<div class="modal-body">
					Employé:
					<br />
					<asp:DropDownList ID="lstAddEmployee" runat="server" >
					</asp:DropDownList>
					<br />
					<br />
					Date:<br />
					<asp:TextBox ID="txtAddDate" CssClass="date" runat="server" AutoCompleteType="None" autocomplete="false" type="date" ></asp:TextBox><br />
					<br />
					du 
				<asp:TextBox ID="txtAddFromHours" runat="server" Width="25px"></asp:TextBox>
					:
				<asp:TextBox ID="txtAddFromMinutes" runat="server" Width="25px"></asp:TextBox>
					<br />
					au 
				<asp:TextBox ID="txtAddToHours" runat="server" Width="25px"></asp:TextBox>
					:
				<asp:TextBox ID="txtAddToMinutes" runat="server" Width="25px"></asp:TextBox>
					<br />
					<div id="divStores" runat="server">
						Magasin:
					<asp:DropDownList runat="server" ID="lstStore"></asp:DropDownList>
						<br />
					</div>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
					<asp:Button Text="Ajouter" runat="server" ID="cmdAdd" CssClass="btn-primary" OnClick="cmdAdd_Click"></asp:Button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div class="modal" id="modalEditBox" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">Modification</h4>
      </div>
      <div class="modal-body">
		  <iframe id="iframe" style="border: 0; width: 100%; height:400px"></iframe>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
      </div>
    </div>
  </div>
</div>
	</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
		<script src="/Admin/js/components/CurrentlyOnline.js"></script>
		<script type="text/javascript">
				var page = "/Admin/PunchEdit.aspx";

			$('#cmdDisplay').click(function () {
				// redirect with querystring
				window.location = 'Punchs.aspx?from=' + $$("from").value + '&to=' + $$("to").value;
			});
			$('.editTime').click(function () {
				var pageWithId = page + "?id=" + this.attributes["data-id"].value;
				$$('iframe').src = pageWithId;
				$('#modalEditBox').modal('show');
			});

			$('#cmdAddOpenDialog').click(function () {
				$('#DialogAdd').modal('show');
			});

			$('.fa-square-o').click(function () {
				// approve the time without editing it.
				var pageWithId = page + "?id=" + this.attributes["data-id"].value + '&automatic=true';
				var ctrl = $(this);
				$.ajax({ url: pageWithId }).done(function () {
					ctrl.removeClass('fa-square-o').addClass('fa-check-square-o');
				});
			});

			$('.fa-check-square-o').click(function () {
				// approve the time without editing it.
				var pageWithId = page + "?id=" + this.attributes["data-id"].value + '&automatic=false';
				var ctrl = $(this);
				$.ajax({ url: pageWithId }).done(function () {
					ctrl.removeClass('fa-check-square-o').addClass('fa-square-o');
				});
			});

			//$('.date').datepicker({ format: "dd/mm/yyyy" });
			$('.live').click(function () {
				alert("On ne peut pas modifier les heures de travail en cours, l'employé peut, par contre, faire un punch out et punch-in rapidement.");
			});

 

			
            var vm = new Vue({
                el: '#app'
            });
		</script>
	<style>
		.modal-backdrop {position:inherit; display: none}
		

	</style>
</asp:Content>
