<%@ Page Title="Portfolio" Language="C#" MasterPageFile="~/en/MP.Master" AutoEventWireup="true" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
<div id="projects">
	<portfolio inline-template>
		<div>
			<div v-if="PrimaryProject">
				<a :href="PrimaryProject.Url"><img :src="getPrimaryPhoto(PrimaryProject)"/></a>
				<h1 id="portfolio-text">
				{{portfolio.Title.Text}}			
				</h1>
				<div class="text-center portfolio-text-2" v-html="textToHtml(portfolio.Description.Text)"></div>
			</div>
			<div v-if="portfolio" id="squarre-boxes">
				<div v-for="(p, index) in portfolio.Projects" class="project">
					<a :href="p.Url" class="square img-bg" v-bind:style='{ backgroundImage: `url("${getPrimaryPhoto(p)}")` }'>
					</a>
					<div class="lines line-text">{{p.Title.Text}}</div>
				</div>
			</div>
			</div>
	</portfolio>
</div>
<script src="/js/components/portfolio.js"></script>
</asp:Content>

