// Pour Buk & Nola, décembre 2018
// script pour la home page
// Jean-Claude Morin
// Comelin
if (!('vueComponents' in window)) {
	vueComponents = []; // list of components to register
}
vueComponents.push(function () {
	var server = '';

	componentPortfolio = Vue.component('portfolio', {
		data: function () {
			return {
				portfolio: null,
				primaryProject: null
			}
		},
		methods: {

			getPrimaryPhoto: function (project) {
				if (!project.UrlImages) {
					return null;
				}
				if (!project.PhotoDefault) {
					project.PhotoDefault = 0;
				}
				return server + project.UrlImages[project.PhotoDefault];
			},
			getProjectUrl: function (index) {
				return server + '/fr/portfolio/' + this.portfolio.Id + '/' + index;
			},
			setPortfolio(data) {
				this.portfolio = data;

			},
			textToHtml(text) {
				if (text) {
					return text.replace(/(?:\r\n|\r|\n)/g, '<br>');
				}
			}
		},
		computed: {
			PrimaryProject: function () {
				if (this.portfolio) {
					return this.portfolio.Projects[this.portfolio.ProjectDefault];
				}
				return null;
			}
		},
		mounted: function () {
			var instance = this;
			$.ajax({
				url: server + '/api/portfolio/default',
				dataType: 'json',
				success: function (data) {
					instance.setPortfolio(data);
				}
			});
		}
	});

}); // add to vueComponents array
