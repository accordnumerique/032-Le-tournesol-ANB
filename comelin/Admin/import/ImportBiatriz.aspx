<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="appAdmin">

        <h1>Importation du fichier des clients.</h1>
        <import-biatriz-customer inline-template>
            <div>
                <h3>Fichier &quot;clients clé membre.pdf&quot;</h3>
                <input type="file" id="fileCustomer" />
                <div class="btn btn-primary" @click="upload">Téléversé</div>
            </div>
        </import-biatriz-customer>
        <import-biatriz-customer-credit inline-template>
            <div>
                <h3>Fichier &quot;clients avec crédits dans leur compte.pdf&quot; </h3>
                <input type="file" id="fileCustomerCredit" />
                <div class="btn btn-primary" @click="upload">Téléversé</div>
            </div>
        </import-biatriz-customer-credit>
        
        <i>copier coller le TEXTE du PDF dans un fichier texte. format UTF-8</i><br/>
        <i>Importation original faite avec l'entreprise Biotop</i>
    </div>
    <br />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    
    <script>
        Vue.component('import-biatriz-customer', {
            methods: {
                upload(event) {
                    var btn = event.target;
                    var formData = GetFormDataWithFile('fileCustomer', btn);
                    if (!formData) {
                        return;
                    }
                    fetchPostForm('/admin/api/import/biatriz/customer',
                        formData,
                        btn,
                        (response) => {
                            notify('Importation de ' + response.NbCreated + ' clients (' + response.NbUpdated + " mis à jour)", btn);
                        });
                }
            }
        });
        Vue.component('import-biatriz-customer-credit', {
            methods: {
                upload(event) {
                    var btn = event.target;
                    var formData = GetFormDataWithFile('fileCustomerCredit', btn);
                    if (!formData) {
                        return;
                    }
                    fetchPostForm('/admin/api/import/biatriz/customer-credit',
                        formData,
                        btn,
                        (response) => {
                            notify('Importation de ' + response.NbCreated + ' clients (' + response.NbUpdated + " mis à jour)", btn);
                        });
                }
            }
        });

    </script>
    <script src="/Admin/js/import.js"></script>
    <script src="/Admin/js/admin-vue.js"></script>
    
</asp:Content>
