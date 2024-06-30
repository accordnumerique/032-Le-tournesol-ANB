<%@ Page Title="Configuration des modes de paiements" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="WebSite.Admin.SettingsAdminPage" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<div id="setting-comelin">
				<div>			
					<div  class="form-horizontal" id="sectionPayments">
						<h2><i class="fa fa-credit-card"></i> Mode de paiement</h2>
						<div>
							<label>visible</label>
							<label>
							 <span class="english">Français</span>
							</label>
							<div class="checkbox">
								<div style="font-weight: bold" class="english pm">
									Anglais
								</div>
								<span>Cocher pour vérifier le montant lors de la fermeture de caisse.</span>
							</div>
						</div>
                        <div class="read-only-fake">
                            <input type="checkbox" />
                            <label>
                                <asp:TextBox runat="server" ID="txtPaymentInteracFr" placeholder="Interac"></asp:TextBox></label>
                            <div class="checkbox">
                                <div style="font-weight: bold;" class="english pm">
                                    <asp:TextBox runat="server" placeholder="Interac" ID="txtPaymentInteracEn"></asp:TextBox>
                                </div>
                                <asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentInterac" />
                            </div>
                        </div>
                        <div class="read-only-fake">
                            <input type="checkbox" />
                            <label>
                                <asp:TextBox runat="server" ID="txtPaymentVisaFr" placeholder="Visa"></asp:TextBox></label>
                            <div class="checkbox">
                                <div style="font-weight: bold;" class="english pm">
                                    <asp:TextBox runat="server" placeholder="Visa" ID="txtPaymentVisaEn"></asp:TextBox>
                                </div>
                                <asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentVisa" />
                            </div>
                        </div>
                        <div class="read-only-fake">
                            <input type="checkbox" />
                            <label>
                                <asp:TextBox runat="server" ID="txtPaymentMasterCardFr" placeholder="MasterCard" ></asp:TextBox></label>
                            <div class="checkbox">
                                <div style="font-weight: bold;" class="english pm">
                                    <asp:TextBox runat="server" placeholder="MasterCard" ID="txtPaymentMasterCardEn" ></asp:TextBox>
                                </div>
                                <asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentMasterCard" />
                            </div>
                        </div>

                        <div  class="read-only-fake">
                            <input type="checkbox"/>
							<label><asp:TextBox runat="server" ID="txtPaymentAmexFr" placeholder="Amex" ></asp:TextBox></label>
							<div class="checkbox">
								<div style="font-weight: bold;" class="english pm">
									<asp:TextBox runat="server" placeholder="Amex"  ID="txtPaymentAmexEn" ></asp:TextBox> 
								</div>
								<asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentAmex" />  <i>(* en semi-intégration inclue tous les cartes de crédit qui ne sont pas Visa et MasterCard)</i>
							</div>
						</div>

						<div  class="read-only-fake">
                            <input type="checkbox"/>
							<label><asp:TextBox runat="server" placeholder="PayPal" ID="txtPaymentPayPalFr" ></asp:TextBox></label>
							<div class="checkbox">
								<div style="font-weight: bold;" class="english pm">
									<asp:TextBox runat="server" placeholder="PayPal" id="txtPaymentPayPalEn" ></asp:TextBox>
								</div>
								<asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentPayPal" />
							</div>
						</div>
                        <div  class="read-only-fake">
                            <input type="checkbox"/>
                            <label><asp:TextBox runat="server" placeholder="Notes de crédit" ID="txtPaymentCreditNoteFr" ></asp:TextBox></label>
                            <div class="checkbox">
                                <div style="font-weight: bold;" class="english pm">
                                    <asp:TextBox runat="server" placeholder="Credit Notes" id="txtPaymentCreditNoteEn" ></asp:TextBox>
                                </div>
                                <i><a href="https://www.comelin.com/notes-de-credit.aspx">Notes de crédit</a></i>
                            </div>
							
                        </div>
						<div class="read-only-fake">
                            <input type="checkbox"/>
							<label><asp:TextBox runat="server" placeholder="" ID="txtPaymentInteracTransferFr"></asp:TextBox></label>
							<div class="checkbox">
								<div style="font-weight: bold;" class="english pm">
									<asp:TextBox runat="server" placeholder="" id="txtPaymentInteracTransferEn"></asp:TextBox> 
								</div>
								<asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentInteracTransfer" />  <i></i>
							</div>
						</div>

						<div>
                            <input type="checkbox"/>
							<label><asp:TextBox runat="server" placeholder="" ID="txtPaymentGeneric1Fr"></asp:TextBox></label>
							<div class="checkbox">
								<div style="font-weight: bold;" class="english pm">
									<asp:TextBox runat="server" placeholder="" id="txtPaymentGenericEn"></asp:TextBox>  
								</div>
								<asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentGeneric" /> <i>(mode de paiement sans fonctionnalité interne)</i>
							</div>
						</div>
						<div>
                            <input type="checkbox"/>
							<label><asp:TextBox runat="server" placeholder="" ID="txtPaymentGeneric2Fr"></asp:TextBox></label>
							<div class="checkbox">
								<div style="font-weight: bold;" class="english pm">
									<asp:TextBox runat="server" placeholder="" id="txtPaymentGeneric2En"></asp:TextBox>
								</div>
								<asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentGeneric2" />  <i>(mode de paiement sans fonctionnalité interne)</i>
							</div>
						</div>
						<div>
                            <input type="checkbox"/>
							<label><asp:TextBox runat="server" placeholder="Chèque" ID="txtPaymentCheckFr"></asp:TextBox></label>
							<div class="checkbox">
								<div style="font-weight: bold;" class="english pm">
									<asp:TextBox runat="server" placeholder="Check" id="txtPaymentCheckEn"></asp:TextBox>
								</div>
								<asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentCheck" /> <i>(mode de paiement sans fonctionnalité interne)</i>
							</div>
						</div>
						<div>
                            <input type="checkbox"/>
							<label><asp:TextBox runat="server" placeholder="Autre" ID="txtPaymentOtherFr"></asp:TextBox></label>
							<div class="checkbox">
								<div style="font-weight: bold;" class="english pm">
									<asp:TextBox runat="server" placeholder="Other" id="txtPaymentOtherEn"></asp:TextBox>
								</div>
								<asp:CheckBox runat="server" Text="Décompte" ID="chkPaymentOther" /> <i>(mode de paiement sans fonctionnalité interne)</i>
							</div>
						</div>
		
					</div>
					<br />
					<asp:Button runat="server" Text="Sauvegarder" CssClass="btn-primary" OnClick="Save_Click" />
				</div>
		</div>
		</asp:Content>

	<asp:Content ID="Content1" ContentPlaceHolderID="cpFooter" runat="server">
	<style>
		h2 img {max-width: 32px}
		.pm {width: 250px;display: inline-block;}
		.read-only-fake input[type=text] {background-color: #e9ecef}
	</style>
	<script>
		$(".number-only").inputFilter(function (value) {
			return /^\d*$/.test(value);
		});


		$('.form-horizontal > div').addClass('form-group');
		$('.form-group input[type=text], textarea').addClass('form-control');
        $('.form-group > *:first-child').addClass('col-sm-1 col-md-1 control-label');
		$('.form-group > *:nth-child(2)').addClass('col-sm-3 col-md-2 control-label');
		$('.form-group > *:nth-child(3)').addClass('col-sm-8 col-md-9 form-inline');


		$(document).ready(function () {
			$('#sidebar-container .list-group > a').addClass('bg-dark list-group-item list-group-item-action');
			$('#sidebar-container .list-group > a > div').addClass('d-flex w-100 justify-content-start align-items-center');
			$('#sidebar-container .list-group > a > div .fa').addClass('fa-fw');
			$('#sidebar-container .list-group > a > div .fa').addClass('fa-fw');

			// check inital check state
            for (var c of $('.form-group > *:first-child')) {
                if ($(c).siblings().find('input[type=text]').val() === '_') {
                    c.checked = false;
                    $(c).siblings().hide();
                } else {
                    c.checked = true;
                }
            }


            $('.form-group > *:first-child').click(function() {
                if (this.checked) {
                    $(this).siblings().find('input[type=text]').val('');
                } else {
                    $(this).siblings().find('input[type=text]').val('_');
                    $(this).siblings().find('input[type=checkbox]').prop( "checked", false );
                }
                $(this).siblings().toggle(this.checked);
            });
        });
	</script>



</asp:Content>
