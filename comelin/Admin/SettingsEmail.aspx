<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="SettingsEmail.aspx.cs" Inherits="WebSite.Admin.SettingsEmail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="app-email-configuration">
		<h2>Configuration SMTP   <help url="articles/utiliser-votre-serveur-courriel-smtp-d-entreprise"></help></h2>
			<div id="divUseComelinSMTP">
                <label><input type="checkbox" v-model="config.UseSendGrid" /> SendGrid</label>
			</div>
		<div>
			
            <div v-if="config.UseSendGrid">
                <label  title="Le courriel d'envoi sera fait via SendGrid">
                    <input type="checkbox" v-model="config.UseSendGridWithGenericAccount" />Utiliser un compte générique (@comelin.com)
                </label>
            </div>
			<div v-else>
			    <div class="form-inline">
				    <div class="form-group mb-2">
				    <input type="text"  class="form-control" id="txtServer" v-model="config.Server" placeholder="Serveur" style="width:300px" :disabled="config.UseSendGrid">
					    <input type="number" class="form-control" id="txtPort"  v-model="config.Port" placeholder="Port" value="587" style="width: 100px" :disabled="config.UseSendGrid"> 
					    <label><input type="checkbox" v-model="config.SSL" v-if="!config.UseSendGrid" /> SSL</label> 
				    </div>
			    </div>
			    <div class="form-inline">		
				    <div class="form-group mb-2 ">
                        <input type="text"  class="form-control" id="txtUsername" v-model="config.Username" placeholder="Nom d'utilisateur / courriel" style="width:300px">
                        <input type="password" class="form-control" id="txtPassword" v-model="config.Password" placeholder="Mot de passe" style="width:150px">
					   
				    </div>
					    
			      </div>
			    
			    </div>
			
            <div style="flex-basis: 100%" v-if="!config.UseSendGridWithGenericAccount">
                <span v-if="!editSender"> Courriel "DE": <span :class="{danger: EmailFrom != config.Username}">{{EmailFrom}}</span> </span><i class="fa fa-cog" title="Configuration de l'expéditeur" @click="editSender = !editSender"></i>
                <div v-if="editSender">
                    <h2>Configuration de l'expéditeur (mode avancé)</h2>
                    <div class="form-group mb-2"><div>FROM: <input  v-model="config.From" type="email" class="form-control"/></div></div>
                    <div class="form-group mb-2"><div>SENDER: <input v-model="config.Sender" type="email" class="form-control"/></div></div>
                    <div class="form-group mb-2"><div>REPLY-TO: <input v-model="config.ReplyTo" type="email" class="form-control"/></div></div>
                </div>
            </div>
			

            </div>
			<div class="btn btn-primary mb-2" @click="Save" id="cmdSaveSMTP" style="margin-top:20px">Sauvegarder</div><br/>
		<div class="form-inline">
		Envoyer un courriel test à: <input v-model="sendTestEmailTo" class="form-control" type="email" id="txtTestEmail" /> 
		<div v-if="sendTestEmailTo" class="btn btn-default" @click="SendEmail" id="cmdSendTestEmail">Envoyer</div>
			</div>
		<hr/>
		
		<div>
			<b>Le serveur SMTP dépend de votre fournisseur de courriel.</b>
			<br/><br/>
			Vidéotron:  smtp.videotron.ca / 587 (pas SSL)<br/>
			Bell/Sympatico:  smtphm.sympatico.ca / 587<br/>
			Office 365: smtp.office365.com / 587<br />
            Microsoft/Live/Outlook/Hotmail: smtp-mail.outlook.com / 587 <a href="https://soutien.comelin.com/portal/fr-ca/kb/articles/configuration-pour-l-envoie-de-courriel-avec-microsoft-outlook-office-365-exchange">aide</a><br />
			Google GSuite Corporatif: smtp-relay.gmail.com / 587<br/>
			Google Gmail Personnel: smtp.gmail.com / 587<br/>
			Les comptes Gmail demande parfois <a href="https://support.google.com/accounts/answer/185833?hl=fr">un mot de passe généré par application.</a>
		</div>
		<hr/>
		<div class="row" style="font-weight: bold; color:darkslateblue; border-bottom:solid darkslateblue 1px;padding-bottom: 10px; margin-bottom: 30px;" >
			<div class="col-8 col-lg-3" >
				 Date et heure
			</div>
			<div class="col-4 col-lg-1" style="text-align: right">
				Temps
			</div>
			<div class="col-12 col-lg-3">
				Destinataire
			</div>
			<div class="col-10 col-lg-5">
				Sujet du courriel
			</div>
		</div>
		<div class="row log-email" v-if="logs" v-for="log in logs">
			<div class="col-8 col-lg-3" v-html="FormatDateTimeAgo(log.DateTime)">
				 
			</div>
			<div class="col-4 col-lg-1" style="text-align: right">
				{{log.Duration}} sec
			</div>
			<div class="col-12 col-lg-3">
				{{log.SendTo}}
			</div>
			<div class="col-10 col-lg-5">
				{{log.Title}}
			</div>
			<div class="col-2 col-lg-2"></div>
			<div class="col-2 col-lg-2" :class="{'text-danger':log.Status !== 1}">
				{{log.StatusStr}}
			</div>
			<div class="col-10 col-lg-8" style="font-weight:bold">
				{{log.Error}}
				<div style="font-weight: normal;color:#aaa ">
					
					<span v-if="log.SocketOption"><i class="fa fa-lock" style="margin-right: 10px" title="SSL"></i> 
                        <span v-if="log.SocketOption == 1">auto</span> 
                        <span v-if="log.SocketOption == 2">TLS implicite</span> 
                        <span v-if="log.SocketOption == 3">TLS explicit</span> 

					</span>
					<span v-if="log.UseComelin">envoyé avec le serveur de Comelin</span>
					{{log.SmtpServer}}
				</div>
				
				
			</div>
		</div>
	</div>
		<div class="modal fade" id="modal-sending">
		  <div class="modal-dialog" role="document">
			<div class="modal-content">
			  <div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">Envoie du courriel...</h5>
			  </div>
			</div>
		  </div>
		</div>
		</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<script>
		var vm = new Vue({
			el: '#app-email-configuration',
			data: {
				config: window._SMTP, /* { Server: "gmail.com", Port: 587, SSL: true, UseComelin:false }*/
				sendTestEmailTo: '', // test email
				logs: null,
				EmailFrom: window._EmailFrom,
				editSender: false,
			},
			methods: {
				FormatDateTimeAgo: function (strDate, separateLine) {
					return FormatDateTimeAgo(strDate, separateLine);
				},
				Save: function () {
					fetch('/admin/api/setting?key=_SMTP&value=' + encodeURIComponent(JSON.stringify(this.config))).then(response => response.json())
						.then(response => {
							if (!response.Error) {
								$('#cmdSaveSMTP').notify('Sauvegardé!');
							} else {
								$('#cmdSaveSMTP').notify(response.Error, 'error');
							}
						});
				},
				SendEmail: function () {
					jQuery('#modal-sending').modal('show');
					fetch('/admin/api/send-test-email-to?email=' + this.sendTestEmailTo).then(response => response.json())
						.then(response => {
							if (response.Status === 1) {
								$('#cmdSendTestEmail').notify('Envoyé');
								if (this.logs) {
									this.logs.unshift(response);
								}
							} else {
								$('#cmdSendTestEmail').notify(response.Error, 'error');
							}
						})
						.catch(function (err) {
							$('#cmdSendTestEmail').notify(err, 'error');
						}).finally(function () {
							jQuery('#modal-sending').modal('hide');
						});
				}
			},
			mounted: function () {
				this.$nextTick(function() {
					fetch('/admin/api/email/logs').then(response => response.json())
						.then(response => {
							this.logs = response;
						});
				});
				this.editSender = this.config.Sender;
			}
		})


	</script>
	<style>
		.TimeAgo {display: block}
		.log-email {padding-bottom: 30px; margin-bottom: 30px; border-bottom: 1px solid #ddd}
		.text-danger {font-weight:bold}
		.danger {color:red}
		.fa-cog {cursor: pointer; padding:2px}
		#txtTestEmail{ margin: 0 5px}
        #chkStartTls {margin-left: 20px}
	</style>
</asp:Content>
