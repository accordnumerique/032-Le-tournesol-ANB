// JavaScript pour faire un formulaire de contact
// Comelin 2018-2024 
if (!('vueComponents' in window)) {
	vueComponents = []; // list of components to register
}
vueComponents.push(function() {

	Vue.component('formulaire-contact', {
		data: function() {
			return {
				msg: {
					firstname: null,
					lastname: null,
					email: null,
					subject: '',
					message: null,
					filenames: []
				},
				subjects: _Text.FormSubjects?.split('\n'),
				notificationArea: '#send .btn'
			}
		},
		props: ['submit-text'],
		template: '<div class="row" id="form-contact">' +
			'<div class="col-12 col-sm-6"><input placeholder="' + _Text.FormFirstName + '" autocomplete="given-name" required v-model="msg.lastname"   /></div>' +
			'<div class="col-12 col-sm-6"><input placeholder="' + _Text.FormLastName + '" autocomplete="family-name" required v-model="msg.firstname"  /></div>' +
			'<div class="col-12"><input placeholder="' + _Text.Email + '" type="email" v-model="msg.email" autocomplete=email /></div>' +
			'<div class="col-12" v-if="subjects">' +
			'<select v-model="msg.subject" placeholder="" >' +
			'<option value="" selected disabled>' + _Text.FormSubject + '</option>' +
			'<option v-for="s in subjects" :value="s">{{s}}</option>' +
			'</select></div>' +
			'<div class="col-12"><textarea placeholder="Message..." v-model="msg.message" ></textarea><div id=attach @click=attach></div></div>' +
			'<div id="send"><div class="btn btn-primary" @click=submit>{{getSubmitText()}}</div></div>' +
			'</div>',
		methods: {
			getSubmitText: function() {
				var text = this.submitText;
				if (!text) {
					text = _Text.Send;
				}
				return text;
			},
			attach: function() {
				// attach a document to the message
			},
			submit: function() {
				if (!this.msg.firstname) {
					return this.displayRequiredNotification(_Text.FormFirstName);
				}
				if (!this.msg.lastname) {
					return this.displayRequiredNotification(_Text.FormLastName);
				}
				if (!this.msg.email) {
					return this.displayRequiredNotification(_Text.Email);
				}
				if (!this.msg.message) {
					return this.displayRequiredNotification(_Text.FormSubject);
				}
				var copy = this.msg;
				var ctrlNotification = this.notificationArea;
				fetchPost('/api/send-email', this.msg, ctrlNotification, function(result) {
						notify(_Text.FormConfirmation, ctrlNotification);
						// clear the forms
						copy.firstname = '';
						copy.lastname = '';
						copy.email = '';
						copy.message = '';
					});
				console.log(this.msg);
			},
			displayRequiredNotification(fieldDescription) {
				notifyError(_Text.RequiredField + ": " + fieldDescription, this.notificationArea);
			},
			initDropZone: function() {
				var element = $$('attach');
				var msg = this.msg;
				if (element) {
					myDropzone = new Dropzone(element, {
						url: "/api/upload-image?context=contact",
						acceptedFiles: "image/*",
						maxFiles: 20,
						resizeWidth: 1000,
						resizeHeight: 1000,
						maxfilesexceeded: function(file) {
							this.removeAllFiles();
							this.addFile(file);
						},
						success: function(file, done) {
							console.log("uploaded" + file.name);
							var path = JSON.parse(done).FilesUrl[0];
							msg.filenames.push(path);
							var pop = $(element);
							pop.popover({ content: _Text.DocumentAdded, trigger: 'click', placement: "bottom" });
							pop.popover('show');
							pop.on('shown.bs.popover', function() {
								setTimeout(function() {
									pop.popover("hide");
								}, 2200);
							});
						},
						complete: function(file) {
							this.removeFile(file);
						},
						error: function(err) {
							alert(err);
						}
					});
				}
			}
		},
		mounted: function() {
			var dropzoneScript = document.createElement('script');
			dropzoneScript.setAttribute('src', '/admin/js/dropzone.min.js');
			dropzoneScript.async = true;
			var comp = this;
			document.head.addEventListener("load", function(event) {
				if (event.target.nodeName === "SCRIPT" && event.target.src.indexOf('dropzone') != -1) {
					comp.initDropZone();
				}
			}, true);
			document.head.appendChild(dropzoneScript);

		}
	});
});