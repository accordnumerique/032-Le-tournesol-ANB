<%@ page title="Configuration de la page d’accueil" language="C#" masterpagefile="~/Admin/AdminMP.Master" autoeventwireup="true" codebehind="HomePageConfigure.aspx.cs" inherits="WebSite.Admin.ConfigureHomePage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Configuration de la page d'accueil </h1>
    <img class="help-page top-right" data-kb="comelin/panneau-administration/site-web-personnalisation/page-d-accueil" />
	<div id="homeprop">
        
		<h3>Titre de la page web</h3>
        
		<div>
		<div class="row">
			<div class="col-12 col-md-6">
				Titre <span class="english">français</span>: <input data-homeprop="title" data-lang="Fr">
			</div>
			<div class="col-12 col-md-6">
				<div class="english">Titre anglais: <input data-homeprop="title" data-lang="En"></div>
			</div>
		</div>
		<h3>Meta description (moteur de recherche)</h3>
		<div class="row">
			<div class="col-12 col-md-6">
				<div>Description <span class="english">français</span>: <input data-homeprop="description" data-lang="Fr" type="text" multiple="multiple"></div>
			</div>
			<div class="col-12 col-md-6">
				<div class="english">Description anglais: <input data-homeprop="description" data-lang="En"></div>
			</div>
		</div>
	</div>
	</div>
	<ul id="lstModules" class="sortable-list">
		<li data-module="h1" data-enable="true">
			<div>
				<div>Mission / Slogan</div>
				<div>Sera le "H1" de votre page.</div>
			</div>
		</li>
		<li data-module="freetext" data-enable="true">
			<div>
				<div>Espace d'écriture libre</div>
				<div><a href="/Admin/HomePageMessageEditor.aspx">configuration...</a></div>
			</div>
		</li>
        <li data-module="banners">
			<div>
				<div>Bannière rotative</div>
				<div><label for="chkBannerContainer">Pleine largeur d'écran: </label> <input id="chkBannerContainer" type="checkbox" data-key="<%=Settings.BannerFullWidthTag%>"></div>
				<div><a href="/Admin/Banners.aspx">configuration...</a></div>
                <div><a href="#" data-toggle="collapse" data-target="#config-banners-html">configuration avancée / HTML...</a>
                    <div id="config-banners-html" class="collapse">HTML pour la bannière rotative: <br/>
                        <textarea  data-key="_homepageBanners"></textarea></div>
                </div>
			</div>
		</li>
		<li data-module="newproducts" data-enable="true">
			<div>
				<div>Nouveautés</div>
				<div class="row">
					<div class="col-12 col-md-6">
						<div>Nombre de semaine considéré comme nouveauté: <input class="small-input" data-key="<%=Settings.NewProductNbWeeksTag %>"></div>
					</div>
					<div class="col-12 col-md-6">
						<div>Nombre maximum de produits affichés: <input class="small-input" data-key="<%=Settings.NewProductCountMaxTag%>"></div>
					</div>
				</div>
				<div><a href="#" data-toggle="collapse" data-target="#config-products-new">configuration avancée / HTML...</a>
					<div id="config-products-new" class="collapse">HTML des nouveaux produits: <br/>
						<textarea  data-key="<%=Settings.NewProductsTemplateTag%>"></textarea></div>
				</div>
			</div>
		</li>
		<li data-module="starproducts">
			<div>
				<div>Produits vedettes</div>
				<div class="row">
					<div class="col-12 col-md-6">
						<div>Description <span class="english">français</span>: <input data-key="<%=Settings.StarProductsDescriptionFrTag %>"></div>
					</div>
					<div class="col-12 col-md-6">
						<div class="english">Description anglais: <input data-key="<%=Settings.StarProductsDescriptionEnTag %>"></div>
					</div>
				</div>				
				<div>Nombre de produits vedettes: <input class="small-input" data-key="<%=Settings.NbStarProductsTag%>"></div>
				<div><a href="#" data-toggle="collapse" data-target="#config-products-star">configuration avancée / HTML...</a>
					<div id="config-products-star" class="collapse">HTML des produits vedettes: <br/>
						<textarea  data-key="<%=Settings.StarProductsTemplateTag%>"></textarea></div>
				</div>
			</div>
		</li>
		<li data-module="brands">
			<div>
				<div>Marques de produits en rotations</div>
				<div>Ajouter les images sur les marques dans le logiciel Comelin à partir du gestionnaire de marque.</div>
			</div>
		</li>
		<li data-module="boxes">
			<div>
				<div>
					Boîtes avec images et liens (1e set)
				</div>
				<div><a href="/Admin/HomePageInfoBox.aspx?set=1">configuration...</a></div>
			</div>
		</li>
		<li data-module="boxes2">
			<div>
				<div>
					Boîtes avec images et liens (2e set)
				</div>
				<div><a href="/Admin/HomePageInfoBox.aspx?set=2">configuration...</a></div>
			</div>
		</li>
		<li data-module="promotions">
			<div>
				<div>
					Afficher les promotions en vigueurs
				</div>
			</div>
		</li>
		<li data-module="liquidations">
			<div>
				<div>
					Afficher les liquidations en vigueurs
				</div>
			</div>
		</li>
		<li data-module="instagram" style="display: none">
			<div>
				<div>
					Instagram
				</div>
				<div class="col-12 col-md-6">
						<div>Nom Instagram @: <input data-key="<%=Settings.InstagramUsernameTag %>"></div>
					</div>
					<div class="col-12 col-md-6">
						<div>Nombre de photos: <input class="small-input" data-key="<%=Settings.InstagramNbPhotoTag %>"></div>
					</div>
			</div>
		</li>
		<li data-module="links">
			<div>
				<div>
					Afficher des liens
				</div>
				<div><a href="/Admin/Links.aspx">configuration...</a></div>
				<div><a href="#" data-toggle="collapse" data-target="#config-links">configuration avancée / HTML...</a>
					<div id="config-links" class="collapse">HTML des liens: <br/>
						<textarea  data-key="<%=Settings.LinksTemplateTag %>"></textarea></div>
				</div>
			</div>
		</li>
        <li data-module="freetext2" data-enable="true">
            <div>
                <div>Espace d'écriture libre #2</div>
                <div><a href="/Admin/HomePageMessageEditor.aspx?id=freetext2">configuration...</a></div>
            </div>
        </li>
        <li data-module="freetext3" data-enable="true">
            <div>
                <div>Espace d'écriture libre #3</div>
                <div><a href="/Admin/HomePageMessageEditor.aspx?id=freetext3">configuration...</a></div>
            </div>
        </li>
		
        <li data-module="html1" data-enable="true">
            <div>
                <div>Code HTML libre #1</div>
                <div><a href="#" data-toggle="collapse" data-target="#config-html-1">Modification...</a>
                    <div id="config-html-1" class="collapse">
                        <textarea class="data" data-moduleprop="Data" ></textarea></div>
                </div>
            </div>
        </li>
        <li data-module="html2" data-enable="true">
            <div>
                <div>Code HTML libre #2</div>
                <div><a href="#" data-toggle="collapse" data-target="#config-html-2">Modification...</a>
                    <div id="config-html-2" class="collapse">
                        <textarea class="data" data-moduleprop="Data" ></textarea></div>
                </div>
            </div>
        </li>
        <li data-module="html3" data-enable="true">
            <div>
                <div>Code HTML libre #3</div>
                <div><a href="#" data-toggle="collapse" data-target="#config-html-3">Modification...</a>
                    <div id="config-html-3" class="collapse">
                        <textarea class="data" data-moduleprop="Data" ></textarea></div>
                </div>
            </div>
        </li>
	</ul>
	<br style="margin:20px"/>
	<input class="btn btn-success" value="Sauvegarder" id="cmdSave" style="position: fixed; bottom: 0"  />
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">

	<script src="js/jquery-sortable-min.js"></script>
	<script>
        if(performance.navigation.type == 2){
            location.reload(true); // force reload on back button
        }
        $('.sortable-list li').prepend('<i class="fa fa-arrows-v fa-2x" style="width:20px"></i> <label class="switch" style="width:62px"><input type="checkbox"><span class="slider round"></span></label>');
        $('.sortable-list li > div > div:first-child').after("<div class=row> \
					<div class='col-12 col-md-6'> \
						<div class=col>Titre <span class=english>français</span>: <input class=titlefr></div> \
					</div> \
					<div class='col-12 col-md-6'> \
						<div class='col english'>Titre anglais: <input class=titleen></div> \
					</div> \
				</div>");
        $('.sortable-list').sortable({handle:'.fa-arrows-v'});

        $('.sortable-list > li').addClass('table-layout');
        $('.sortable-list > li > div input, #homeprop input').addClass('form-control');
        
        var <%=Settings.NbStarProductsTag%> = <%=Settings.Current.NbStarProducts%>;
        var <%=Settings.NewProductNbWeeksTag%> = <%=Settings.Current.NewProductNbWeeks%>;
        var <%=Settings.NewProductsTemplateTag%> = '<%=HttpUtility.JavaScriptStringEncode(Settings.Current.NewProductsTemplate)%>';
        var <%=Settings.NewProductCountMaxTag%> = <%=Settings.Current.NewProductCountMax%>;
        var <%=Settings.StarProductsDescriptionFrTag%> = '<%=HttpUtility.JavaScriptStringEncode(Settings.Current.StarProductsDescriptionFr)%>';
        var <%=Settings.StarProductsDescriptionEnTag%> = '<%=HttpUtility.JavaScriptStringEncode(Settings.Current.StarProductsDescriptionEn)%>';
        var <%=Settings.StarProductsTemplateTag%> = '<%=HttpUtility.JavaScriptStringEncode(Settings.Current.StarProductsTemplate)%>';
        var <%=Settings.LinksTemplateTag%> = '<%=HttpUtility.JavaScriptStringEncode(Settings.Current.LinksTemplate)%>';

        var <%=Settings.InstagramUsernameTag%> = '<%=HttpUtility.JavaScriptStringEncode(Settings.Current.InstagramUsername)%>';
        var <%=Settings.InstagramNbPhotoTag%> = <%=Settings.Current.InstagramNbPhoto%>;


        if (!exist('homepageSettings')) {
            homepageSettings = {};
        } 

        $().ready(function() {
            // page title and meta description
            $.each($('input[data-homeprop], textarea[data-homeprop]'), function (index, ctrl) {
                var prop = homepageSettings[ctrl.getAttribute('data-homeprop')];
                if (prop) {
                    prop = prop[ctrl.getAttribute('data-lang')];
                    if (prop) {
                        ctrl.value = prop;
                    }
                } 
            });

            // place the module is order defined
            if (homepageSettings.Modules) {
                for (var i = homepageSettings.Modules.length - 1; i >= 0; i--) {
                    var module = homepageSettings.Modules[i];
                    var moduleName = module.Name;
                    $("#lstModules li[data-module='" + moduleName + "']").prependTo('#lstModules'); // put in the right order
                }


                for (var i = homepageSettings.Modules.length - 1; i >= 0; i--) {
                    var module = homepageSettings.Modules[i];
                    var moduleName = module.Name;
					
                    var ctrl = document.querySelector("#lstModules li[data-module='" + moduleName + "']");
                    if (!ctrl) {
                        continue;
                    }
                    if (module.Title && module.Title.Fr) {
                        ctrl.querySelector('.titlefr').value = module.Title.Fr;	
                    } else {
                        ctrl.querySelector('.titlefr').value = '';
                    }
                    if (module.Title && module.Title.En) {
                        ctrl.querySelector('.titleen').value = module.Title.En;	
                    } else {
                        ctrl.querySelector('.titleen').value = '';
                    }
                    ctrl.querySelector("input[type='checkbox']").checked = module.Enable;

                    var dataNode = ctrl.querySelector('[data-moduleprop]'); // input or textarea
                    if (dataNode) {
                        dataNode.value = module[dataNode.dataset["moduleprop"]];
                    }
                }
            }
		
            // set other inputs with data-key attribut
            $.each($('input[data-key],textarea[data-key]'), function (index, ctrl) {
                var value = eval(ctrl.getAttribute('data-key'));
                if (ctrl.type === "checkbox") {
                    ctrl.checked = value;
                } else {
                    ctrl.value = value;	
                }
            });
        });
	

        var cmdSave = $$('cmdSave');
        cmdSave.onclick = function () {
            cmdSave.disabled = true;

            // configuration before the module
            $.each($('input[data-homeprop], textarea[data-homeprop]'), function (index, ctrl) {
                var prop1 = ctrl.getAttribute('data-homeprop');
                if (prop1) {
                    var prop2 = ctrl.getAttribute('data-lang');
                    if (prop2) {
                        if (!homepageSettings[prop1]) {
                            homepageSettings[prop1] = {} /*create a new object*/
                        }
                        homepageSettings[prop1][prop2] = ctrl.value;
                    } else {
                        homepageSettings[prop1] = ctrl.value;
                    }
                }
            });

            // module configuration
            // create backup to preserve other information such as the data field
            var moduleBackup = {};
            if (homepageSettings.Modules) {
                for (var m of homepageSettings.Modules) {
                    moduleBackup[m.Name] = m;
                }    
            }
            
            homepageSettings.Modules = []; // reset the array
            var lstModules = $$('lstModules');
            for (var i = 0; i < lstModules.children.length; i++) {
                var node = lstModules.children[i];
                var moduleName = node.dataset.module;

                var module = moduleBackup[moduleName];
                if (!module) {
                    module = {Name: moduleName};
                }
                module.Enable = node.querySelector('input[type=checkbox]').checked;
                var dataNode = node.querySelector('[data-moduleprop]'); // input or textarea
                if (dataNode) {
                    module[dataNode.dataset["moduleprop"]] = dataNode.value;
                }

                var fr = node.querySelector('.titlefr');
                if (fr.value) {
                    if (!module.Title) {
                        module.Title = {};
                    }
                    module.Title.Fr = fr.value;
                } else if (module.Title) {
                    module.Title.Fr = null;
                }
                var en = node.querySelector('.titleen');
                if (en.value) {
                    if (!module.Title) { 
                        module.Title = {};
                    }
                    module.Title.En = en.value;
                } else if (module.Title) {
                    module.Title.En = null;
                }
                homepageSettings.Modules.push(module);
            }

            let formData = new FormData();
            formData.append('<%=Settings.HomePageSettingsTag%>',JSON.stringify(homepageSettings));

            // add other control with data-key attribute
            $.each($('input[data-key], textarea[data-key]'), function (index, ctrl) {
                var value = ctrl.value;
                if (ctrl.type === "checkbox") {
                    value = ctrl.checked;
                }
                formData.append(ctrl.getAttribute('data-key'),value);
            });
            cmdSave.disabled = true;


            fetch("/admin/api/setting",
                    {
                        body: formData,
                        method: "post"
                    }).then(response => {
                    return response.json();
                })
                .then(response => {
                    if (!response.Error) {
                        $(cmdSave).notify('Sauvegardé!');
                    } else {
                        $(cmdSave).notify(response.Error, 'error');
                    }
                }).catch((error) => {
                    $(cmdSave).notify(error, 'error');
                });;

            cmdSave.disabled = false;
        }


        // Allow tab on the text area
        $(document).delegate('textarea', 'keydown', function(e) {
            var keyCode = e.keyCode || e.which;
            if (keyCode == 9) {
                e.preventDefault();
                var start = this.selectionStart;
                var end = this.selectionEnd;
                // set textarea value to: text before caret + tab + text after caret
                $(this).val($(this).val().substring(0, start) + "\t" + $(this).val().substring(end));
                this.selectionStart = this.selectionEnd = start + 1; // put caret at right position again// put caret at right position again
            }
        });
    </script>
	<style>
			  #lstModules {padding-left: 0}
		.table-layout {display:table;width:100%;}
		.table-layout > * {display:table-cell}
		.small-input {width: 50px}
		#chkBannerContainer {display: inline;width: 16px;vertical-align: bottom;}
		/*checkbox as switch. ref: https://www.w3schools.com/howto/howto_css_switch.asp */
		.switch{position:relative;display:inline-block;width:60px;height:34px;vertical-align:top}.switch input{display:none}.slider{position:absolute;cursor:pointer;top:0;left:0;right:0;bottom:0;background-color:#ccc;-webkit-transition:.4s;transition:.4s}.slider:before{position:absolute;content:"";height:26px;width:26px;left:4px;bottom:4px;background-color:#fff;-webkit-transition:.4s;transition:.4s}input:checked+.slider{background-color:#2196F3}input:focus+.slider{box-shadow:0 0 1px #2196F3}input:checked+.slider:before{-webkit-transform:translateX(26px);-ms-transform:translateX(26px);transform:translateX(26px)}.slider.round{border-radius:34px}.slider.round:before{border-radius:50%}
		/* dragable content ref: https://johnny.github.io/jquery-sortable/ */
		.dragged { position: absolute; opacity: 0.5; z-index: 2000; }
		.sortable-list li{ margin: 10px 0; border: 1px solid lightgray; list-style: none; padding: 10px }
		.sortable-list li > div {width: 100%}
		.sortable-list li > div > div:first-child {font-weight: bold; font-size: 1.1em}
		.sortable-list li .fa-arrows-v {cursor: move !important; vertical-align: top; margin-top: 3px}
		.sortable-list li .switch {margin: 0 10px}
		.sortable-list li.placeholder { position: relative;  }
		.sortable-listli.placeholder:before { position: absolute; /** Define arrowhead **/ }
		textarea {width: 100%; height: 500px;    font-family: monospace;background: url(http://i.imgur.com/2cOaJ.png);background-attachment: local;background-repeat: no-repeat;    font-size: 11.3px;padding-left: 35px;padding-top: 12px;border-color:#ccc;-moz-tab-size : 4;-o-tab-size : 4;tab-size : 4;}
	</style>
</asp:Content>
