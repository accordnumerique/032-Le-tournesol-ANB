<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="NotificationsByCustomer.aspx.cs" Inherits="WebSite.Admin.report.NotificationsByCustomer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <div id="appReportNotifications">
        <h1>Liste des clients avec notifications de produits lorsqu'ils seront de retour en inventaire</h1>
        <div v-if="ListCustomer">
            <div v-for="c in ListCustomer">
                <h3>{{c.CustomerName}}</h3>
                <div class="products">
                    <div v-for="p in c.Products" class="p">
                        <a :href="p.Url"><img :src="p.UrlImage" loading="lazy" /><div class="title">{{p.Title}}</div></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <script>
        var appReportNotifications = new Vue({
            el: '#appReportNotifications',
            data: {
                ListCustomer: null
            },
            mounted() {
                var app = this;
                fetchPost('/admin/api/notification-per-customer',
                    null,
                    null,
                    (dataReceived) => {
                        app.ListCustomer = dataReceived.List;
                    });
            }
        });

    </script>
    <style>
        .products{    display: flex;
            flex-wrap: wrap;}
        .p { max-width: 150px; padding: 5px; text-align: center; }
        .p a{ text-decoration: none; color:#333}
        .p img {
            width: 140px; height: 140px
        }
    </style>
</asp:Content>
