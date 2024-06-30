<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="FileEditor.aspx.cs" Inherits="WebSite.Admin.config.FileEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1 runat="server" id="h1"></h1>
	<div id="editor" style="width: 100%;min-height: 200px" runat="server" ClientIDMode="Static" ></div>
	<div class="btn btn-primary" id="cmdSave">Sauvegarder</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script src="//ajaxorg.github.io/ace-builds/src-min-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
<script>
	var editor = ace.edit("editor");
	editor.getSession().setUseWorker(false);
	editor.setOptions({
		theme: "ace/theme/monokai",
		autoScrollEditorIntoView: true,
		maxLines: 30,
		minLines: 2
	});
	editor.getSession().setMode("ace/mode/" + $.query.get('type'));
    $('#cmdSave').click(function() {

    	fetch('/admin/api/editor/save' + document.location.search, {
			method: 'POST',
			body: editor.getValue(),
			headers: {
				'Content-Type': 'text/plain'
			}
		})
			.then(response=>response.json())
			.then(function () {			
				$('#cmdSave').notify('Sauvegardé', {position:'right'});
			});
    });

	</script>
	  <style type="text/css" media="screen">
    body {
        overflow: hidden;
    }
	#editor{margin-top:20px}
	#cmdSave {margin-top: 20px;}

  </style>
</asp:Content>
