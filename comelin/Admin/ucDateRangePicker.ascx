<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucDateRangePicker.ascx.cs" Inherits="WebSite.Admin.ucDateRangePicker" %>
<div id="divFilterByCategory" runat="server" Visible="False" class="filter" >	
	Catégorie:
	<select runat="server" id="lstCategories" clientidmode="Static" enableviewstate="False" multiple="True" style="display: none" class="select2" data-placeholder="Catégories" />	
</div>	
<div id="divFilterBrandOrSupplier" runat="server" Visible="False" class="filter" data-placeholder="Marque ou fournisseur">
	Marques ou distributeurs:
	<select class="select2" runat="server" id="lstBrands" clientidmode="Static"  EnableViewState="False" data-placeholder="Marque ou distributeur"></select>
&nbsp;</div>

<div class="filter" id="filter-by-date">
<label for="from">du</label>
<input type="date" id="from" name="from">
<label for="to">au</label>
<input type="date" id="to" name="to">
	</div>
<div class="btn btn-primary" id=cmdDisplay >Afficher</div>  