<%@ Page Title="Projet" Language="C#" MasterPageFile="~/Fr/MP.Master" AutoEventWireup="true" CodeBehind="Project.aspx.cs" Inherits="WebSite.Fr.Project" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<project inline-template>
		<div class="row">
			<div class="col-12 col-md-3">
				<h1>{{project.Title.Text}}</h1>
				<p class="project-description" v-html="textToHtml(project.Description.Text)"></p>
			</div>
			<div class="col-12 col-md-9">
				<div id="projectPhotos" class="row">
					<div v-for="(img, index) in project.UrlImages"  class="col-6" >
					<img :src="img" />	
					</div>
					
				</div>
				<div id="go-to-top"><a href="#" onclick="window.scrollTo(0,0); return false;">
					<i class="fa fa-long-arrow-up" title="Naviguer en haut" style="max-height:20px"></i>
				</a></div>	
			</div>
			<div class="col-12">
				<div v-if="projectNext" id="other-project">
					<a id="project-previous"  :href="projectPrevious.Url" :title="projectPrevious.Title"><i class="fa fa-chevron-left"></i></a>
					<span>Autres projets</span>
					<a id="project-next"  :href="projectNext.Url" :title="projectNext.Title"><i class="fa fa-chevron-right"></i></a>
				</div>		
			</div>
		</div>
	</project>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script src="/js/components/project.js"></script>
</asp:Content>
