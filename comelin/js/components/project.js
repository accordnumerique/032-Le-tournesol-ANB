// Script pour afficher un project dans un portfolio 
// Comelin par Jean-Claude Morin
// décembre 2018

if (!('vueComponents' in window)) {
	vueComponents = []; // list of components to register
}
vueComponents.push(function () {
	Vue.component('project', {
		data: function () {
			return {
				project: _project,
				projectPrevious: _projectPrevious,
				projectNext: _projectNext
			}
		},
		methods: {
			getPrimaryPhoto: function (project) {
				if (!project.UrlImages) {
					return null;
				}
				return project.UrlImages[project.PhotoDefault];
			},
			textToHtml(text) {
				if (text) {
					return text.replace(/(?:\r\n|\r|\n)/g, '<br>');
				}
			}
		},
		created:function () {
			document.title = this.project.Title.Text;
		},
		mounted: function () {
			$('#projectPhotos').find('img').on('load', (function () {
				// image is loaded now
				if ($(this).width() / $(this).height() > 1) {
					var classes = this.parentElement.classList;
					classes.add('col-12');
					classes.remove('col-6');
				} else {
					$(this).addClass('tall');
				}
			}));
		}
	});
	
}); // add to vueComponents array
