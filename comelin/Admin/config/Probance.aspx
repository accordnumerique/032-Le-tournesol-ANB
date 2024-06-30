<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Probance.aspx.cs" Inherits="WebSite.Admin.config.ProbanceConfigPage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <h2>Configuration Probance</h2>
    <p>&nbsp;</p>
    <div id="appConfigProbance">
        <div class="row">
            <clabel>Activer</clabel>
            <coption><input type="checkbox" v-model="config.Enable" id="chkEnable" /> <label for="chkEnable">Activer le module Probance</label></coption>
        </div>
        <div class="row">
            <clabel><h5>Configuration SFTP</h5></clabel>
            <coption>(données disponible dans la section Administration / Technique)</coption>
        </div>
        <div class="row">
            <clabel>Serveur SFTP </clabel>
            <coption><input  v-model="config.SftpHost" placeholder="data.probance.ca" /></coption>
        </div>
        <div class="row">
            <clabel>Utilisateur</clabel>
            <coption><input  v-model="config.Username" /></coption>
        </div>
        <div class="row">
            <clabel>Mot de passe</clabel>
            <coption><input  type="password" v-model="config.Pass" /></coption>
        </div>
        <div class="row">
            <clabel><h5>Exportation Catalogue produit</h5></clabel>
            <coption>(Les 'produits' représentent les matrices dans Comelin)</coption>
        </div>
        <div class="row">
            <clabel>string1</clabel>
            <coption><attrib-select :attribselected=config.IdAttributProduct1 disabledvalue=true @attribselected=setIdAttributProduct1></attrib-select>
            </coption>
        </div>
        <div class="row">
            <clabel>string2</clabel>
            <coption><attrib-select :attribselected=config.IdAttributProduct2 disabledvalue=true @attribselected=setIdAttributProduct2></attrib-select>
            </coption>
        </div>
        <div class="row">
            <clabel>string3</clabel>
            <coption><attrib-select :attribselected=config.IdAttributProduct3 disabledvalue=true @attribselected=setIdAttributProduct3></attrib-select>
            </coption>
        </div>
        <div class="row">
            <clabel><h5>Exportation Catalogue article</h5></clabel>
            <coption>(Les 'articles' représentent les produits qui font partie d'une matrice dans Comelin)</coption>
        </div>
        <div class="row">
            <clabel>string1</clabel>
            <coption><attrib-select :attribselected=config.IdAttributArticle1 disabledvalue=true @attribselected=setIdAttributArticle1></attrib-select>
            </coption>
        </div>
        <div class="row">
            <clabel>string2</clabel>
            <coption><attrib-select :attribselected=config.IdAttributArticle2 disabledvalue=true @attribselected=setIdAttributArticle2></attrib-select>
            </coption>
        </div>
        <div class="row">
            <clabel>string3</clabel>
            <coption><attrib-select :attribselected=config.IdAttributArticle3 disabledvalue=true @attribselected=setIdAttributArticle3></attrib-select>
            </coption>
        </div>
        <div class="row">
            <clabel>string4</clabel>
            <coption><attrib-select :attribselected=config.IdAttributArticle4 disabledvalue=true @attribselected=setIdAttributArticle4></attrib-select>
            </coption>
        </div>
        <div class="row">
            <clabel>string5</clabel>
            <coption><attrib-select :attribselected=config.IdAttributArticle5 disabledvalue=true @attribselected=setIdAttributArticle5></attrib-select>
            </coption>
        </div>
        <div id="barSave">
            <div class="container">
                <div class="btn btn-primary" @click="save" id="cmdSave">
                    Sauvegarder
                </div>
                <input type="checkbox" id="chkUpload" v-model="uploadFiles" /> <label for="chkUpload">Téléversé le fichier sur Probance</label>
                <div class="btn btn-secondary" id="cmdGenerateFiles" @click="generateDownloadFileProductAndUpload">Générer fichiers</div>
            </div>
        </div>
        <div class="row" v-if="urlFilesToDownload">
            <clabel>fichiers</clabel>
            <coption>
                <a v-for="f in urlFilesToDownload" :href="f">{{f}}</a>
            </coption>
        </div>
        
        <div v-if="config.LastExport">
            Dernier export: <time-ago :datetime="config.LastExport"></time-ago> <span class="button" @click="reinitprobance($event)">ré-initialisé...</span>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <style>
        #appConfigProbance > .row {margin-bottom: 20px}
        .attribs-select >.filter { width: 300px}
    </style>
    <script src="/Admin/js/components/report.js"></script>
    <script>
        Vue.component('clabel',
            {
                template: '<div class="col col-sm-3"><div style="width:100%; text-align:right"><slot></slot></div></div>'
            });
        Vue.component('coption',
            {
                template: '<div class="col col-sm-9"><slot></slot></div>'
            });
        var appConfigProbance = new Vue({
            el: '#appConfigProbance',
            data: {
                config: window._probanceSettings,
                uploadFiles: false,
                urlFilesToDownload: null

            },
            methods: {
                reinitprobance(e) {
                    fetchPost('/admin/api/probance/reset', null, e.target);

                },
                save() {
                    fetchPost('/admin/api/setting?key=_Probance&value=' + encodeURIComponent(JSON.stringify(this.config)), null, '#cmdSave');
                },
                generateDownloadFileProductAndUpload() {
                    fetchPost('/admin/api/probance/generateDownloadFileProductAndUpload', this.uploadFiles, '#cmdGenerateFiles' /*, 
                        (answer)=> {
                            appConfigProbance.urlFilesToDownload = answer;
                            
                        }*/);
                },
                setIdAttributProduct1(id) {
                    this.config.IdAttributProduct1 = id;
                },
                setIdAttributProduct2(id) {
                    this.config.IdAttributProduct2 = id;
                },
                setIdAttributProduct3(id) {
                    this.config.IdAttributProduct3 = id;
                },
                setIdAttributArticle1(id) {
                    this.config.IdAttributArticle1 = id;
                },
                setIdAttributArticle2(id) {
                    this.config.IdAttributArticle2 = id;
                },
                setIdAttributArticle3(id) {
                    this.config.IdAttributArticle3 = id;
                },
                setIdAttributArticle4(id) {
                    this.config.IdAttributArticle4 = id;
                },
                setIdAttributArticle5(id) {
                    this.config.IdAttributArticle5 = id;
                }
            }
        });
    </script>
</asp:Content>
