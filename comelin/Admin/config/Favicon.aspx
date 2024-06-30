<%@ Page Title="Configuration du favicon" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Favicon.aspx.cs" Inherits="WebSite.Admin.config.Favicon" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="app" class="container">
        <h1>
        Assignation d&#39;un favicon à votre site web</h1>
    
    <favicon-config inline-template>
        <div>
           
            <div v-if="setting.IsEnable">
                <div id="favAssigned">Favicon assigné présentement:</div> 
                <img id="imgFavAssigned" :src="urlLiveImage" /> <span class="btn btn-danger" @click="removeFavicon" id="cmdRemove"><i class="fa fa-times"></i></span>
            </div>
            <div>
                <div id="instruction">Assigner un image qui sera votre favicon<br/>
                    <ul>
                        <li>Image de type PNG</li>
                        <li>Aspect ratio carré</li>
                        <li>Fond transparent (optionnel)</li>
                        <li>Peut être jusqu'à 256x256 pour certains téléphones.</li>
                    </ul>
                </div>
                <div id="lblSelectFile">Choisir l'image à partir de votre ordinateur:</div> <input type="file" id="fileFavicon" accept="image/png" @change="previewFiles($event)"  />
                <div  v-if="imgPreview">
                    <img id="ctrlImgPreview" :src="imgPreview"  style="max-width: 128px"/><br/>
                    <div @click="upload" class="btn btn-success" id="cmdUpload">Téléverser</div>
                </div>
                
            </div>
        </div>
    </favicon-config>
    
        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <style>
        #cmdRemove {vertical-align: top}
        #lblSelectFile,#ctrlImgPreview {margin:20px 0}
    </style>
    <script>
        Vue.component('favicon-config',
            {
                data() {
                    return {
                        setting: _faviconSetting,
                        imgPreview : null,
                        file: null
                    }
                },
                computed: {
                    urlLiveImage() {
                        return '/apple-touch-icon.png?v=' + this.setting.Version;
                    }
                },
                methods: {
                    removeFavicon(event) {
                        if (confirm(_Text["Remove"])) {
                            var vueComponent = this;
                            fetchPost('/admin/favicon/remove', null, event.ctrl, (response) => vueComponent.setting = response);
                       }
                    },
                    previewFiles(event) {
                        if (event.target.files.length > 0) {
                            this.file = event.target.files[0];
                            this.imgPreview = URL.createObjectURL(this.file);
                        }
                    },
                    upload() {
                        var data = new FormData();
                        data.append('file', this.file);
                        var vueComponent = this;
                        fetchPostForm('/admin/favicon/upload', data, event.target, (response) => {vueComponent.setting = response;
                            vueComponent.imgPreview = null; 
                        });
                    }

                }
            });
        var faviconConfig = new Vue({
            el:'#app'
        });

    </script>
</asp:Content>
