<%@ page title="" language="C#" masterpagefile="MP.master" autoeventwireup="true" inherits="WebSite.Fr._default" codebehind="Default.aspx.cs" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <%= HomePageModules %>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
    <link href="https://unpkg.com/vueperslides/dist/vueperslides.css" rel="stylesheet">
    <script src='https://unpkg.com/vueperslides@2.14.0/dist/vueperslides.umd.min.js'></script>           
    <script src="/js/homepage.js<%=JsVersion %>"></script>
	<script>
		var banner = document.getElementById('banners');
		if (banner) {
			if (banner.childNodes.length > 1) {
				$.getScript("/js/jquery.cycle.js", function () {
					$('#banners').cycle({ pager: '#bannerPager', fx: 'scrollHorz', prev: '#bannerPrevious', next: '#bannerNext', delay: 2000, timeout:4000, slideExpr: 'a' });
				});
			} else {
				banner.classList.add('single');
			}
		}
		

	</script>

	
</asp:Content>
