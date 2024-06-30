<%@ Page Title="Recalculer l'inventaire" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="InventoryRecount.aspx.cs" Inherits="WebSite.Admin.InventoryRecount" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1><img src="images/inventoryrecount.png" />Recompter l&#39;inventaire</h1>
	<div class="row">
	
        <div class="col-6 col-md-8 col-lg-9">
			<h3>Inventaire en cours</h3>
            <p>Une ou quelquefois par année, les entreprises font un recompte de leur inventaire afin de corrigé des erreurs de quantité en inventaire (erreur humaine, perte, vol, bris, oublie...).</p>
            <p>&nbsp;</p>
            <p>La procédure avec Comelin est simple:</p>
            <ol style="margin-left:20px">
                <li>Démarrer le mode inventaire.</li>
                <li>Effectuer des réceptions de marchandise sur TOUT l&#39;inventaire du magasin incluant les produits réservés.</li>
                <li>Vous pouvez aussi modifier la quantité en inventaire directement dans la fenêtre de recherche de produit</li>
                <li>Terminer le mode inventaire.</li>
                <li>Le(s) rapport(s) sont généré(s) automatiquement et disponible sur cette page.</li>
            </ol>
	
            <p>Si vous avez plus d'un magasin physique, le mode inventaire doit être initialisé pour chaque magasin individuellement.</p>
            <p>Vous pouvez utiliser plus d&#39;un ordinateur pour réceptionner les produits en même temps.</p>
            <p>Il est possible de faire des ventes durant l&#39;inventaire, <strong>si vous effectuez une seul réception du même produit </strong>lors de l&#39;inventaire. Si le produit est compté à plus d&#39;un endroit dans votre magasin, Comelin ne sera pas en mesure de savoir si le produit vendu avait ou non été compté. Dans le cas échéant, Comelin assume que le produit a été compté.</p>
	
            <asp:DropDownList ID="lstInventoryModeStoreStart" runat="server" Font-Size="16px" style="vertical-align:middle" >
            </asp:DropDownList>
            &nbsp;<asp:Button ID="cmdInventaireStart" runat="server"   Text="Démarrer le mode inventaire" OnClientClick="return confirm('Certain?');" 
                              onclick="cmdModeInventaire_Click" /> &nbsp;<asp:CheckBox ID="chkExcludeRecycleProducts" runat="server" 
                                                                                       Text="Exclure les produits recyclés" Visible="False" />
            <asp:CheckBox ID="chkRecycleProductsOnly" runat="server" 
                          Text="Seulement les produits recyclés" Visible="False" />
            <br />

	
            <div id="log"></div>
            <div class="progress">
                <div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0"
                     aria-valuemax="100" style="width: 0">
                    <span class="sr-only"></span>
                </div>
            </div>
            <i class="fa fa-spinner fa-spin" id="waiting"></i>
        </div>
        <div  id="appReports" class="col-6 col-md-4 col-lg-3" v-if="files">
            <h3>Rapport des inventaires complétés</h3>
			<div>
                <a v-for="f in files" :href="f.Url">{{f.Name}}</a>
            </div>
        </div>
    </div>

		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
        <style>
            #appReports a {display: block}
        </style>
	<script>
        var appReporst = new Vue({
            el: '#appReports',
            data: {
                files: null
            },
            mounted() {
                fetchPost('/admin/api/report/list',
                    null,
                    null,
                    result => {
                        appReporst.files = result;
                    });
            }
        });


        var websocket;
        function testWebSocket() {
            websocket = new WebSocket(_websocketurl);
            websocket.onopen = function (evt) { onOpen(evt) };
            websocket.onclose = function (evt) { onClose(evt) };
            websocket.onmessage = function (evt) { onMessage(evt) };
            websocket.onerror = function (evt) { onError(evt) };
        }

        function onOpen(evt) {
            writeToScreen("l'opération peut prendre plusieurs minutes selon le nombre de produit");
            $('#waiting').hide();
            websocket.send('pingall');
        }

        function onClose(evt) {
            writeToScreen("déconnecté :(");
            $('#waiting').hide();
        }

        function onMessage(evt) {
            var message = JSON.parse(evt.data);
            if (message === 'pongall') {
                $$('log').innerHTML = '';
            } else if (message.Type === 'StartInvMode') {
                document.location = 'InventoryRecountMonitoring.aspx?idStore=' + message.IdStore;
            } else {
                if (message.Store && message.Display) {
                    $$('log').innerHTML = '<b>' + message.Store + '</b>:' + message.Display;
                }
                $('.progress-bar').width(message.Percentage * 100 + "%");
            }
			
        }


        function onError(evt) {
            writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data);
            $('#waiting').hide();
        }

        function writeToScreen(message) {
            var pre = document.createElement("p");
            pre.style.wordWrap = "break-word";
            pre.innerHTML = message;
            $$('log').parentElement.appendChild(pre);
        }


        window.addEventListener("load", testWebSocket, false);
    </script>
</asp:Content>
