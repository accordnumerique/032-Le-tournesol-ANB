<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <h1>Copie des images sur images1.comelin.com</h1>
    <div id="appSyncImage">
        <div v-if="!status">Chargements...</div>
        <div v-else>
            <div>Nombre de photo syncroniser: {{status.NbImagesSynced}} <a v-if="status.NbImagesSynced" href="#" @click="reset($event)">ré-initialisé / recommencer</a></div>
            <div>Nombre de photo à syncroniser: {{status.NbImages - status.NbImagesSynced}}</div>
            <div>Nombre de photo total: {{status.NbImages}}</div>
            

            <div v-if="status.IsRunning" @click="stop($event)" class="btn btn-danger" >Arrêt!</div>
            <div v-else @click="start($event)" class="btn btn-primary">Démarrer la copies des images</div>
            <br/>
            <code>{{status.Msg}}</code>
            
            <div v-if="status.NbErrors" style="color:red">
                Nombre d'erreur: <code style="font-size: 20px">{{status.NbErrors}}</code><br/>
                {{status.Error}}
            </div>
        </div>
        
        <a href="/admin/api/images-sync/logs" target="_blank">logs</a>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <script>
        var appSyncImage = new Vue({
            el: '#appSyncImage',
            data: {
                status: null
            },
            methods: {
                start(e) {
                    fetchPost("/admin/api/images-sync/start", null, e.target, null);
                },
                stop(e) {
                    fetchPost("/admin/api/images-sync/stop", null, e.target, null);
                },
                reset(e) {
                    fetchPost("/admin/api/images-sync/reset", null, e.target, null);
                },
            },
            mounted() {
                // open a websocket to receive live notification
                let ws = new WebSocket(WebSocketUrl + '/admin/ws/sync-images');
                ws.onmessage = function(msg) {
                    appSyncImage.status = JSON.parse(msg.data);
                };
                //ws.open();


                fetchPost("/admin/api/images-sync/status", null, null, (s) => {
                    if (!s.NbImagesSynced) {
                        s.NbImagesSynced = 0; // 0 no serialized
                    }
                    this.status = s;
                });
            }
        });
    </script>
</asp:Content>
