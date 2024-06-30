<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="WebSite.HomePage" EnableViewState="false" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.min.js"></script>
    <script src="https://www.comelin.com/cdn/moment-fr.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8=" crossorigin="anonymous"></script>
    <script src="/js/comelin.js"></script>
</head>
<body>
<div id="appOnePage" style="display: none">
        <div v-if="isReady">
            <div id="header" style="">{{companyData.Name}}</div>

            <img :src="companyData.UrlLogo" :alt="companyData.Name" />
            <div id="section-custom" v-html="companyData.Html"></div>

            <div id="section-contact">
                <hr/>
                <h2><t>Contact</t></h2>
                <div v-if="companyData.Email"><a :href="'mailto:' + companyData.Email">{{companyData.Email}}</a></div>
                <div v-if="companyData.Phone"><a :href="'tel:' + companyData.Phone">{{companyData.Phone}}</a></div>
            </div>
            <div id="address" v-if="companyData.Address">
                <h2><t>Address</t></h2>
               <div id="map"></div><br/>
                <a :href="companyData.UrlAddress" target="_blank">{{companyData.Address}}</a>
            </div>
            
            <div  id="open-hours" v-if="companyData.OpenHours">
                <hr/>
                <h2><t>OpenHours</t></h2>
                <div v-for="openingHours in companyData.OpenHours">
                    <open-hours :openingHours="openingHours" :multistore="companyData.OpenHours.length > 1"></open-hours>
                </div>
            </div>
        </div>
    </div>
    <%= FacebookMessenger %>
    <style>
        #header {position: static;top: 0;width: 100%;display: block;padding: 30px 0;color: white;background-color: #2c3e50;font-size: 2em;text-transform: uppercase;}
        body {text-align: center;margin: 0;font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;font-size: 1.3em;}
        hr {padding: 0;border: none;border-top: solid 5px;text-align: center;max-width: 250px;margin: 25px auto 30px;}
        #section-contact a {text-decoration: none; color:inherit;margin-bottom:10px; display:inline-block}
        .openHours, .openHoursEx {margin-bottom: 10px;max-width: 300px;margin-left: auto;margin-right: auto; }
        
        .openHours time, .openHoursEx time {display: flex;justify-content: space-between; }
        #address a {text-decoration: none; color:inherit}
        #map {width: 425px; height: 350px}
    </style>
<script>
    <%= RenderScripts %>

    var comelin = new Comelin(); // load components for translation and open hours

    var appOnePage = new Vue({
        el: '#appOnePage',
        data: {
            title: 'test',
            companyData: null
        },
        computed: {
            isReady() {
                return this.companyData;
            },
            urlMapEmbed() {
                return "https://maps.google.com/maps?&amp;q=" + encodeURIComponent(this.companyData.Address) + "&amp;output=embed";
            }
        },
        mounted() {

            document.getElementById('appOnePage').style.display = 'block'; //make it visible

            var error;
            fetch('api/company/public-info').then(response => {
                    if (!response.ok) {
                        error = response.statusText; /* continue with response.json to get the stream error details */
                    }
                    return response.json();
                })
                .then(response => {
                    if (error) {
                        alert(error + ' ' + response);
                        return;
                    }
                    appOnePage.companyData = response;
                    if (response.Address) {
                        setTimeout(displayMap, 1000);    
                    }
                    document.title = response.Name;
                }).catch((error) => {
                    alert(error);
                });
        }
    });
    function displayMap() {
            var embed ="<iframe width='425' height='350' frameborder='0' scrolling='no'  marginheight='0' marginwidth='0'   src='https://maps.google.com/maps?&amp;q="+ encodeURIComponent(appOnePage.companyData.Address) +"&amp;output=embed'></iframe>";
            document.getElementById('map').outerHTML = embed;
    }

</script>
</body>
</html>
