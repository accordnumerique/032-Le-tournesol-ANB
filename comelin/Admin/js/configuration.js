// Settings page
// Comelin
// Jean-Claude Morin 16 février 2020

$('.section input').addClass('form-control');

function ensureSettingValueIsAnObject(key) {
    if (!_settings[key]) {
        _settings[key] = '{}';
    }
}
ensureSettingValueIsAnObject("_Recaptcha");

// validate all settings exist
for(e of document.querySelectorAll('[setting]')) {
	var settingCode = e.getAttribute('setting');
	if (_settings[settingCode] == undefined) {
		//console.warn('config: Setting ' + settingCode + ' is undefined ');
		_settings[settingCode] = ''; // undefined cause issue about binding with vue js and reactivity
	}
}

function getSetting(keyComplete, container) { // get the setting value, the key support the dot notation like 'a.b'
	if (!container) {
		container = _settings;
	}
	var splitter = keyComplete.indexOf('.');

	if (splitter !== -1) {
        var firstPart = keyComplete.substr(0, splitter);
        var str = container[firstPart];
		if (!str) {
            container[firstPart] = '{}';
            return null;
		}
		var obj = JSON.parse(str);
		return obj[keyComplete.substr(splitter + 1)];
	} else {
		// direct
		return container[keyComplete];
	}
}

var appConfiguration = null;
Vue.component('config', {
	props: ['setting', 'label', 'icon', 'multiple', 'id', 'prefix', 'placeholder', 'help','defaultvalue','pattern','maxlength','validation'],
	computed: {
		value: {
			get: function () {
                if (this.setting === undefined) {
                    throw "Component 'config' " + this.id + " do not have the setting property";
                }
                rawVal = getSetting(this.setting); 
                if (rawVal === undefined) {
                    rawVal = this.defaultvalue;
                }
                return rawVal;
			},
			set: function (newValue) { appConfiguration.setAndSave(this.setting, newValue); }
		}
	},
	template: `<div class="config c" :id="'c'+ id"><img v-if=icon :src=icon ><label class=lbl :id=id>{{label}}<slot></slot><help v-if=help :number=help></help></label>

		<textarea v-if=multiple class ='form-control' v-model="value"  :placeholder="getPlaceholder()" />

		<input v-else class ='form-control' v-model = "value" :placeholder="getPlaceholder()" autocomplete="off" :pattern="pattern" :title="validation" :maxlength="maxlength" />
		</div>`,
	methods: {
		getPlaceholder: function () {
			if (this.placeholder) {
				return this.placeholder;
			}
            if (this.multiple) {
                return 'Une entrée par ligne';
            }
			return this.label;
		}
	},
	mounted: function () {
		if (!this.setting) {
			console.warn('config: Setting not defined for ' + this.label);
		}
		if (this.pattern) {
			var input = document.querySelector('#c' + this.id + ' input');
			input.addEventListener("input", function tagChange(a) { a.target.reportValidity();});
		}
	}
});

Vue.component('config-bilingual', {
	props: ['setting', 'label', 'icon', 'multiple', 'id'],
	data: function () {
		return {
			text: {}
		}
	},
	watch: {
		text: {
			handler: function (newValue, oldVal) {
				appConfiguration.setAndSave(this.setting, JSON.stringify(newValue));
			},
			deep: true
		},
	},
	template: `<div class="config-bilingual c" :id="'c'+ id" ><img v-if=icon :src=icon ><label class=lbl :id=id>{{label}}<slot></slot></label>
			<bilingual-text :text=text :multiline=multiple>
			</bilingual-text>
		</div>`,
	mounted: function () {
		if (!this.setting) {
			console.warn('config: Setting not defined for ' + this.label);
		}
		var str = _settings[this.setting];
		if (str) {
			this.text = JSON.parse(str);
		} else {
			this.text = {}
		}
	}
});


Vue.component('config-number', {
	props: ['setting', 'label', 'icon', 'suffix', 'prefix', 'id', 'placeholder'],
	computed: {
		value: {
			get: function () { return getSetting(this.setting); },
			set: function (newValue) { appConfiguration.setAndSave(this.setting, newValue); }
		}
	},
	template: `<div class="config-number c" :id="'c'+ id"><img v-if=icon :src=icon ><label :id=id class=lbl>{{label}}<slot></slot></label>
<div class="input-group">
<span class ="input-group-prepend" v-if=prefix ><span class ="input-group-text">{{prefix}}</span></span>
<input class ='form-control' v-model="value" :placeholder="getPlaceholder()" />
<span class ="input-group-append" v-if=suffix ><span class ="input-group-text">{{suffix}}</span></span>
</div>
</div>`,
	methods: {
		getPlaceholder: function () {
			if (this.placeholder) {
				return this.placeholder;
			}
			return this.label;
		}
	}, mounted: function () {
		if (!this.setting) {
		console.warn('config-number: Setting not defined for ' + this.label);
		}
		}
});


// displayed as a multiline textbox
Vue.component('config-list', {
    props: ['setting', 'label', 'icon', 'suffix', 'prefix', 'id'],
    computed: {
        value: {
            get: function () { return getSetting(this.setting); },
            set: function (newValue) { appConfiguration.setAndSave(this.setting, newValue); }
        }
    },
    template: `<div class="config-list c" :id="'c'+ id"><img v-if=icon :src=icon ><label :id=id class=lbl>{{label}}</label>
<div class="input-group">
<span class ="input-group-prepend" v-if=prefix ><span class ="input-group-text">{{prefix}}</span></span>
<select class ='form-control' v-model="value">
   <slot></slot>
</select>
<span class ="input-group-append" v-if=suffix ><span class ="input-group-text">{{suffix}}</span></span>
</div>
</div>`,
   mounted: function () {
        if (!this.setting) {
            console.warn('config-number: Setting not defined for ' + this.label);
        }
    }
});


/* link to another page (not a setting) */
Vue.component('lnk', {
	props: ['href'],
	template: `<a class="lnk c" :href=href target=_blank><span class=lbl><slot></slot></span> <i class="fa fa-external-link" aria-hidden="true"></i></a>`
});

/* setting toggle yes/no */
Vue.component('check', {
	props: ['setting', 'reverse', 'icon', 'label', 'id', 'defaultvalue'],
	computed: {
		value: {
			get: function () {
                if (!this.setting) {
					console.error('setting not set for component check ' + this.id);
					return;
                }
				rawVal = getSetting(this.setting);
                if (this.defaultvalue && (rawVal === undefined || rawVal == '')) {
                    rawVal = this.defaultvalue;
                }
				val = rawVal && (typeof(rawVal) == "boolean" || rawVal.toLocaleLowerCase() === "true");
				if (this.reverse) {
					return !val;
				}
				return val;
			},
			set: function (newValue) {
				if (this.reverse) {
					newValue = !newValue;
				}
				appConfiguration.setAndSave(this.setting, newValue.toString());
			}
		}
	},
	template: `<div class="config c" :id="'c'+ id">
		<img v-if=icon :src=icon >
		<label class="lbl" :id="id" :setting=setting>{{label}}<slot></slot></label><label class="switch">
					<input type="checkbox" v-model="value">
					<span class="slider round"></span>
				</label></div>`,
	mounted: function () {
		if (!this.setting) {
			console.log('Check ctrl with not setting value ' + this.$slots.default[0].text);
		}
    }
});

Vue.component('config-section', {
	props: ['label', 'icon','fontawesome','help','helpUrl'],
	template: `<div class="section">
		<h2><span @click=gotoSection><img v-if=icon :src=icon><i v-if=fontawesome :class ="'fa fa-' + fontawesome"></i></span>
		<span>{{label}}</span>
<help v-if='help' :number=help></help>
<help v-if='helpUrl' :url=helpUrl></help>
</h2>
		<div class='section-content'>
			<slot></slot>
		</div>
	</div>`,
	methods: {
		gotoSection: function (event) {
			// find the id of the first element by moving up in the parent element
			var it = event.target;
			var idHash = it.id;
			while (!idHash) {
				it = it.parentElement;
				idHash = it.id;
			}
			document.location.hash = "#" + idHash;
			this.$parent.searchFor(document.location.hash);
		}
	}

});

/* sub section that can be collapsed by the parent one */
Vue.component('sub-section', {
	props: ['label', 'icon', 'fontawesome','help','open','helpUrl'],
	data: function () {
		return {
			visible: this.open
		}
	},
	methods: {
		toggleVisibility: function () {
			this.visible = !this.visible;
		}
	},
	template: `<div class="sub-section c"><div class=sub-section-header @click="toggleVisibility()" :class={open:visible}><span><img v-if=icon :src=icon><i v-if=fontawesome :class ="'fa fa-' + fontawesome"></i>{{label}}
<help v-if='help' :number=help></help>
<help v-if='helpUrl' :url=helpUrl></help>
</span>
<i class="fa fa-caret-down" v-if=!visible></i>
<i class="fa fa-caret-up" v-if=visible></i>

</div>
<div class=sub-section-content :class="{'hide':!visible}"><slot></slot></div>
</div>`
});

/* section that is visible only if the setting is set to true */
Vue.component('visible-if', {
	props: ['visible', 'reverse', 'value', 'complete-hide'],
	computed: {	
		isVisible: function() {
			var rawVal = getSetting(this.visible);
			var result = rawVal && rawVal.toLocaleLowerCase() !== "false";
			if (this.reverse) {
				result = !result;
			}
			if (this.value) {
				return rawVal == this.value;
			}
			return result;
		}
	},
	template: `<div v-if="isVisible || !completeHide" :class="{partialHidden:!isVisible}" :setting=visible class='if visible'><slot></slot></div>`,
});

var _settingsOriginalValues = Object.assign({}, _settings);

appConfiguration = new Vue({
	el: '#appConfiguration',
	data: {
		settings: _settings,
		search: '',
		settingsPropertiesUpdate: {},
		sections: null,
		shippings: null,
		multistore: window._multistore,
		groups: window._groups,
		idCategoriesSubTotalAdd: null,
		DEBUG: window.__DEBUG
	},
	computed: {
		nbPropertiesToSave: function() {
			return Object.keys(this.settingsPropertiesUpdate).length;
		},
		Name: {
			get: function() { return this.settings["Name"]; },
			set: function(newValue) { this.setAndSave("Name", newValue); }
		},

		settingIdCategoriesSubTotal: {
			get: function () {
				var str = this.settings["IdCategoriesSubTotal"];
				if (!str) {
					return [];
				}
				return JSON.parse(str);
			},
			set: function (newValue) {
				var str = null;
				if (newValue && newValue.length > 0) {
					str = JSON.stringify(newValue);
				}
				this.setAndSave("IdCategoriesSubTotal", str);
			}
		}	
	},
	watch: {
		search: function () {
			this.searchFor();
		}
	},
	methods: {
		settingIdCategoriesSubTotalAdd() {
			var arr = this.settingIdCategoriesSubTotal;
			arr.push(this.idCategoriesSubTotalAdd);
			this.settingIdCategoriesSubTotal = arr;
			this.idCategoriesSubTotalAdd = '';
		},
		settingIdCategoriesSubTotalRemove(toRemove) {
			var arr = this.settingIdCategoriesSubTotal;
			arr = arr.filter(a => a != toRemove);
			this.settingIdCategoriesSubTotal = arr;
		},
		setAndSave: function (settingKeyComplete, settingValue) {
			var settingKey = settingKeyComplete;
			var splitter = settingKeyComplete.indexOf('.');
			if (splitter !== -1) {
				// this is a sub-property 
				settingKey = settingKeyComplete.substr(0, splitter); // keep only the first part, as it's the value we update in the setting

				// object store in string JSON format
				var str =  _settings[settingKeyComplete.substr(0, splitter)];
				var obj = {}
				if (str) {
					obj = JSON.parse(str);
				}
				obj[settingKeyComplete.substr(splitter + 1)] = settingValue; // assign the property to the json object
				settingValue = JSON.stringify(obj); // convert back to string
			}
			if (settingValue === getSetting(settingKey, _settingsOriginalValues)) {
				// same are original
				this.$delete(this.settingsPropertiesUpdate, settingKey); // remove from list of 
			} else {
				this.$set(this.settingsPropertiesUpdate, settingKey, settingValue);
			}
			this.$set(this.settings, settingKey, settingValue);
		},
		showConfig: function (el) {
			if (!el) {
				return;
			}
			// remove hide from element and all parent up to the section
			var it = el;
			if (it.classList) {
				it.classList.remove('hide');
			}
			
			while (it && (it.classList == null || !it.classList.contains('section'))) {
				it = it.parentElement;
				it.classList.remove('hide');
				
			}
			if (el.__vue__) {
				el.__vue__.$data["visible"] = true;
			}
			
			$(el).find('.c ').removeClass('hide');
			$('.' + el.getAttribute('setting')).find('.c ').removeClass('hide');
		},
		searchFor: function () {
			var searchForValue = this.search;
			$(".config").removeHighlight();

			if (!searchForValue) {
				// show everything
				document.location.hash = '';
				$('.section, .c').removeClass('hide');
				return;
			}

			$('.section, .c').addClass('hide');
			if (searchForValue.indexOf('#') === 0) {
				// search by section name

				var strId = searchForValue.substr(1);
				var el = $$(strId);
				// hide everything

				this.showConfig(el);
				document.location.hash = this.search;
			} else {
				document.location.hash = '';
				// check all config
				var searchValueLowerCase = normalisedString(this.search.toLocaleLowerCase());
				var nbVisible = 0;
				for (var section of document.getElementsByClassName('c')) {
                    if (section.querySelector('.sub-section') != null) {
                        continue; // avoid getting too big section
                    }
					if (normalisedString(section.textContent + section.id.toLocaleLowerCase()).indexOf(searchValueLowerCase) !== -1) {
						this.showConfig(section);
						//
						nbVisible++;
					}
				}

				// check all section name
				for (var sectionHeader of $('.section h2')) {
					var searchContent = sectionHeader.textContent + sectionHeader.id;
					if (normalisedString(searchContent.toLocaleLowerCase()).indexOf(searchValueLowerCase) !== -1) {
						this.showConfig(sectionHeader.parentElement);
						nbVisible++;
					}
				}
			}
			$('.config').highlight(searchForValue, true);
		},
		save: function () {
			let formData = new FormData();
			for (var key of Object.keys(this.settingsPropertiesUpdate)) {
				formData.append(key, this.settingsPropertiesUpdate[key]);
				}
		fetch("/admin/api/setting",
			{
			body: formData,
			method: "post"
			}).then(response => {
				return response.json();
				})
			.then(response => {
				if (!response.Error) {
					$.notify('Sauvegardé!');
					// update local caching of value
					for (var key of Object.keys(this.settingsPropertiesUpdate)) {
						_settingsOriginalValues[key] = this.settingsPropertiesUpdate[key];
					}
					this.settingsPropertiesUpdate = { }; // reset list of properties to update
			} else {
				$('#cmdSave').notify(response.Error, 'error');
				}
		}).catch((error) => {
			$('#cmdSave').notify(error, 'error');
		});;

		},
		// find the section the element belong too
		findSection: function (element) {
			return this.findParentWithClass(element, 'section');
		},
		findSubSection: function (element) {
			return this.findParentWithClass(element, 'sub-section');
		},
		findParentWithClass: function (element, className) {
			while (element) {
				if (element.classList.contains(className)) {
					return element;
				}
				element = element.parentElement;
			}
			return null;
		}
	},
    mounted: function () {
		// build left menu
		this.sections = $('.section, .section-content > .sub-section:not(.notoc)');

		for (var section of this.sections) {
			section.subSections = $(section).find('.section-content > .sub-section');
		}
		this.search = document.location.hash;
		$('.depreciated .lbl').append('<span class="badge badge-danger" title="Ce module sera retiré complétement dans le future">déprécié</span>');
		$('#mainSection').click(function (e) {
			
			if (e.target.nodeName === 'LABEL') {
				// first the first ID to set the hash
				var it = e.target;
				while (!it.id) {
					it = it.parentElement;
				}
				document.location.hash = it.id;
			}
		});
		$('#ccode-taxe-default input').attr("maxlength", 1);

		var inputGoogleAdsTag = document.querySelector("#cgoogle-tags input");
		var inputGoogleAdsConversionTag = document.querySelector("#cgoogle-ads-conversion-id input");
		inputGoogleAdsTag.addEventListener("input", function tagChange(a) { 
			if (a.target.reportValidity()) {
				inputGoogleAdsConversionTag.value = a.target.value.substr(3); // remove AW-
			}
		});
		inputGoogleAdsConversionTag.addEventListener("input", function tagChange(a) { 
			if (a.target.reportValidity()) {
				inputGoogleAdsTag.value = 'AW-' + a.target.value; // add AW-
			}
		});
    }

});

