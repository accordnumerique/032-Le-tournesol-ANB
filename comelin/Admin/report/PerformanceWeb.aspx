<%@ Page Title="Rapport de performance web" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true" CodeBehind="PerformanceWeb.aspx.cs" Inherits="WebSite.Admin.report.PerformanceWeb" %>

<%@ Register Src="~/Admin/ucDateRangePicker.ascx" TagPrefix="uc1" TagName="ucDateRangePicker" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
	<h1>Rapport de performance web</h1>
	<uc1:ucDateRangePicker runat="server" ID="ucDateRangePicker" />
	
	<div id="appPerformance">
		<table style="_width: 100%;"> 
			<thead>
			<tr class="storeName" >
				<th><!-- --></th>
				<th v-for="s in stores">{{s.Name}}</th>
				<th v-if="multistores">Total</th>
				</tr>
			</thead>
			<tbody>
			
				<tr>
					<th>Ventes plancher 
						<template v-if="ShowFilter"><i class="fa fa-minus-circle" v-if="ExpandInStore" @click="ExpandInStore = !ExpandInStore"></i><i class="fa fa-plus-circle" v-else="ExpandInStore" @click="ExpandInStore = !ExpandInStore"></i></template>
					</th>
					<td v-for="s in stats">{{NumberToAmount(s.SalesInStore)}}</td>
					<td v-if="multistores">{{NumberToAmount(Sum(stats, 'SalesInStore'))}}</td>
				</tr>
				<template v-if="ExpandInStore && DeliveryOptions">
					<tr v-for="d in DeliveryOptions" class="indent">
						<th>{{d.Name}}</th>
						<td v-for="s in stats">{{NumberToAmount(DisplayDeliveryAmount(s.SalesInStorePerDeliveryOption,d))}}</td>
						<td v-if="multistores">{{NumberToAmount(Sum2(stats, 'SalesInStorePerDeliveryOption', d.Option))}}</td>
					</tr>
				</template>
				<tr>
					<th>Ventes Web 
						<template v-if="ShowFilter">
							<i class="fa fa-minus-circle" v-if="ExpandWeb" @click="ExpandWeb = !ExpandWeb"></i><i class="fa fa-plus-circle" v-else="ExpandWeb" @click="ExpandWeb = !ExpandWeb"></i>
						</template>
							</th>
					<td v-for="s in stats">{{NumberToAmount(s.SalesOnline)}}</td>
					<td v-if="multistores">{{NumberToAmount(Sum(stats, 'SalesOnline'))}}</td>
				</tr>
				
				<template v-if="ExpandWeb && DeliveryOptions">
					<tr v-for="d in DeliveryOptions" class="indent">
						<th>{{d.Name}}</th>
						<td v-for="s in stats">{{NumberToAmount(DisplayDeliveryAmount(s.SalesOnlinePerDeliveryOption,d))}}</td>
						<td v-if="multistores">{{NumberToAmount(Sum2(stats, 'SalesOnlinePerDeliveryOption', d.Option))}}</td>
					</tr>
				</template>

				<tr>
					<th>Frais de poste</th>
					<td v-for="s in stats">{{NumberToAmount(s.ShippingFees)}}</td>
					<td v-if="multistores">{{NumberToAmount(Sum(stats, 'ShippingFees'))}}</td>
				</tr>
				<tr class="total">
					<th>Total</th>
					<td v-for="s in stats">{{NumberToAmount(s.SalesInStore + s.SalesOnline + s.ShippingFees)}}</td>
					<td v-if="multistores">{{NumberToAmount(Sum(stats, 'SalesInStore') + Sum(stats, 'SalesOnline') + Sum(stats, 'ShippingFees'))}}</td>
				</tr>
				
				<tr>
					<th>Nombre d'item vendu</th>
					<td v-for="s in stats">{{s.NbItemsSold}}</td>
					<td v-if="multistores">{{Sum(stats, 'NbItemsSold')}}</td>
				</tr>
				<tr>
					<th>Nombre de facture</th>
					<td v-for="s in stats">{{s.NbInvoices}}</td>
					<td v-if="multistores">{{Sum(stats, 'NbInvoices')}}</td>
				</tr>
				<tr>
					<th>Moyenne d'item par facture</th>
					<td v-for="s in stats">{{SafeDivision(s.NbItemsSold,s.NbInvoices)}}</td>
					<td v-if="multistores">{{SafeDivision(Sum(stats, 'NbItemsSold'), Sum(stats, 'NbInvoices'))}}</td>
				</tr>
				<tr>
					<th>Moyenne $$ par facture</th>
					<td v-for="s in stats">{{NumberToAmount(SafeDivision(s.SalesInStore + s.SalesOnline + s.ShippingFees,s.NbInvoices))}}</td>
					<td v-if="multistores">{{NumberToAmount(SafeDivision(Sum(stats, 'SalesInStore') + Sum(stats, 'SalesOnline') + Sum(stats, 'ShippingFees'), Sum(stats, 'NbInvoices')))}}</td>
				</tr>
				<tr v-if="ReservationDatePlanned">
					<th>Ratio jour</th>
					<td v-for="s in stats">{{s.RatioDay.toFixed(2)}}</td>
					<td v-if="multistores">{{(Sum(stats, 'RatioDay') / stats.length).toFixed(2)}}</td>
				</tr>
				<tr>
					<th>Nombre de colis expédiés</th>
					<td v-for="s in stats">{{s.NbInvoiceShipped}}</td>
					<td v-if="multistores">{{Sum(stats, 'NbInvoiceShipped')}}</td>
				</tr>
				
				<tr>
					<th>Heures travaillées</th>
					<td v-for="s in stats">{{s.NbHours.toFixed(1)}}</td>
					<td v-if="multistores">{{Sum(stats, 'NbHours').toFixed(1)}}</td>
				</tr>
				
				<tr>
					<th>Ratio vente total / heure</th>
					<td v-for="s in stats">{{NumberToAmount(SafeDivision(s.SalesInStore + s.SalesOnline + s.ShippingFees,s.NbHours))}}</td>
					<td v-if="multistores">{{NumberToAmount(SafeDivision(Sum(stats, 'SalesInStore') + Sum(stats, 'SalesOnline') + Sum(stats, 'ShippingFees'), Sum(stats, 'NbHours')))}}</td>
				</tr>
				
			</tbody>
		</table>
		
	</div>
	</asp:Content>

	<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
	<style>
		#appPerformance table {text-align:right }
		#appPerformance table td, #appPerformance table th {padding:5px 10px}
		#appPerformance .total td, #appPerformance .total th {border-top:1px solid black; padding-bottom:  20px;font-weight: bold; color:rgb(120, 65, 0)}
		tr.indent {background-color: rgb(237, 237, 237)}
		tr.indent th {font-weight: normal }
		.fa-minus-circle, .fa-plus-circle {cursor: pointer}
	</style>
	<script>

		var appPerformance = new Vue({
			el: '#appPerformance',
			data: {
				stores: window._stores,
				multistores: window._stores.length > 1, 
				stats: window._PerformanceWebData.PerformanceWebPerStore,
				ReservationDatePlanned: window._ReservationDatePlanned,
				ExpandWeb: false,
				ExpandInStore: false,
				ShowFilter: window._DeliveryOptions != null && window._DeliveryOptions.length >= 2,
				DeliveryOptions: window._DeliveryOptions
			},
			methods: {
				NumberToAmount(number) {
					return NumberToAmount(number);
				},
				SafeDivision(a, b) {
					if (b == 0) {
						return 0;
					}
					return (a / b).toFixed(2);
				},
				Sum(array, propertyName) {
					return array.reduce(function(a, b) {
						return a + b[propertyName];
					}, 0);
				},
				DisplayDeliveryAmount(dic, deliveryOption) {
					if (!dic) {
						return 0;
					}
					return dic[deliveryOption.Option];
				},
				Sum2(array, propertyName, propertyName2) {
					return array.reduce(function(a, b) {
						var p = b[propertyName];
						if (p) {
							p = p[propertyName2];
						}
						if (!p) {
							return a;
						}
						return a + p;
					}, 0);
				}
			}
		});
		
	</script>
</asp:Content>
