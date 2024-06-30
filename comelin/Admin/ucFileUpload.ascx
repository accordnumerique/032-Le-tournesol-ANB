<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucFileUpload.ascx.cs" Inherits="WebSite.Admin.ucFileUpload" %>

<script src="js/dropzone.min.js"></script>

<div id="dropzone">Clicker <b>ou</b> Glisser votre image ici</div>

<script>
	function initDropZone() {
		var element = document.getElementById('dropzone');
		if (element) {
			myDropzone = new Dropzone(element, {
				url: "/api/upload-image",
				acceptedFiles: "image/*",
				maxFiles: 20,
				resizeWidth: 1920,
				resizeHeight: 1000,
				maxfilesexceeded: function (file) {
					this.removeAllFiles();
					this.addFile(file);
				},
				success: function (file, done) {
					console.log("uploaded" + file.name);
					var files = JSON.parse(done)["FilesUrl"];
					for (var i = 0; i < files.length; i++) {
						tinymce.activeEditor.insertContent('<img src="' + files[i] + '" />');
					}
					
				},
				complete: function (file) {
					this.removeFile(file);
				},
				error: function (err) {
					alert(err);
				}
			});
		}
	}

	$(function() {
		initDropZone();
	});
</script>