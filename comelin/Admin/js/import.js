// Utility function relation to importation
// Comelin - JcMorin 2022-2-16


Vue.component('generic-importer', {
    props: ['title', 'url', 'filename'],
    data() {
        return {
            fileToUpload: null,
            isPreviewMode: true,
            stats: null,
            isWaiting: false,
            isImported: false,
            options: {}
        }
    },
    methods: {
        fileSelected(event) {
            this.isPreviewMode = true;
            this.fileToUpload = event.target.files[0];
            this.isImported = false; // re-enable the upload button
            this.sendToServer(event);
        },
        upload(event) {
            this.isPreviewMode = false;
            this.sendToServer(event);
        },
        sendToServer(event) {
            this.isWaiting = true;
            var btn = event.target;
            var formData = new FormData();
            formData.append('file', this.fileToUpload);
            this.options.IsPreview = this.isPreviewMode;
            formData.append('inputparam', JSON.stringify(this.options));
            var component = this;
            fetchPostForm(this.url,
                formData,
                btn,
                (response) => {
                    component.stats = response;
                    if (!component.isPreviewMode) {
                        component.isImported = true;    
                    }
                },
                () => { component.isWaiting = false;});
        }
    },
    template:`<div class="importer">
                <div class=title>{{title}}</div>
<div class=options>
<i class="fa fa-cog"></i> Options:<br>
<label><input type=checkbox v-model=options.IsCreateOnly>Création seulement (ignore si déja existant) </label>
<label><input type=checkbox v-model=options.IsUpdateOnly>Mise à jour seulement (ignore les nouveaux) </label>
 <slot name="options" v-bind:options="options"></slot>
</div>
Nom original du fichier: <code>{{filename}}</code><br/>
                <input type="file" @change="fileSelected"/> 
                <div v-if="isWaiting" class="waiting">
                    en traitement...
                </div>
                <template v-else>
                    <div v-if="fileToUpload && isPreviewMode" class="preview">Prévisualisation</div>
                    <import-result :stats="stats"></import-result>
                    <div v-if="!isImported" class="btn btn-primary" @click="upload">Importé</div>
                </template>
            </div>`
});

Vue.component('object-stats',
    {
        props: ['counters'],
        data() {
            return {
                isErrorDetailOpen: false
            }
        },
        methods: {
            getCreated() {
                return this.counters.NbCreated ?? 0;
            },
            getUpdated() {
                return this.counters.NbUpdated ?? 0;
            },
            getSkipped() {
                return this.counters.NbSkipped ?? 0;
            },
            getError() {
                if (!this.counters.Errors) {
                    return 0;
                }
                return this.counters.Errors.length;
            },
            getTotal() {
                return this.getCreated() + this.getUpdated() + this.getSkipped() + this.getError();
            },
            getStyle(count) {
                return { 'flex-grow': count };
            }
        },
        template: `
<div class=obj>
<div class=chart>
    <div class=added v-if="getCreated()" :style="getStyle(getCreated())">Ajouté: {{ getCreated() }}</div>
    <div class=modified v-if="getUpdated()" :style="getStyle(getUpdated())">MAJ: {{  getUpdated() }}</div>
    <div class=skipped v-if="getSkipped()" :style="getStyle(getSkipped())">Ignoré: {{ getSkipped() }}</div>
    <div @click="isErrorDetailOpen=!isErrorDetailOpen" class=errors v-if="getError()" :style="getStyle(getError())">Erreur: {{ getError() }}</div>
</div>
    <div v-if="isErrorDetailOpen" class='view-errors'>

<ul>
<li v-for="errorData in counters.Errors"><div class=text>{{errorData.Error}}</div><div class=data>{{errorData.Data}}</div></li>
</ul>
    </div>
</div>
` });

Vue.component('import-result', {
    props: ['stats'],
    methods: {
        getObjectName(objectType) {
            if (objectType === 'Product') {
                return "Produits";
            } else if (objectType === 'Customer') {
                return "Clients";
            }
            return objectType;
        }
    },
    template:`<div class='import-stats' v-if=stats>
<div v-for="(value, objectType) in stats.Objs">
    {{getObjectName(objectType)}}
    <object-stats :counters=value></object-stats>

</div>

<div><i>Durée: {{stats.ImportTime}}ms</i></div></div>`
});

function GetFormDataWithFile(ctrIdFileInput, btn, inputParam) {
    var fileInput = $$(ctrIdFileInput);
    if (fileInput.files.length === 0) {
        notifyError('Aucun fichier sélectionné', btn);
        return null;
    }
    var formData = new FormData();
    formData.append('file', fileInput.files[0]);
    if (inputParam) {
        formData.append('inputparam', JSON.stringify(inputParam));
    }
    return formData;
}