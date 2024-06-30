//
/*
S'assurer d'ajouter le html suivant après : <!-- end of b --> dans MP.Master & de créer le champ texte "postalCodeShipping" dans le panneau admin
<div id="postalcodehidden" style="display:none;visibility:hidden;"><t>postalCodeShipping</t></div>
*/
//
jQuery(document).ready(function () {
				
    if (jQuery('div#b').hasClass('page-caisse') && jQuery('#postalcodehidden') && jQuery('#postalcodehidden').text().length != 0){
    	// S'assurer que tous input code postal est à 6 carractères maximum
		jQuery('#zip').attr('maxlength', 6);
		// Vérification codes postaux et validation
		jQuery(function verification_codePostal (){
			var admitPostal = jQuery('#postalcodehidden, #zip');
			var admitPostalValue = jQuery(admitPostal).text().toLowerCase();
			// Enlever toutes les virgules
			var postalResult = admitPostalValue.replace(/,/g, "");
			// Validation du code postal avant de submit
			jQuery('#cmdComplete').on('click', function() {
				if (document.getElementById('radSummaryLocal').checked ) { //Livraison locale
					jQuery('.checkFalseMsg').remove();
					var postalValueCheckoutEntry = document.getElementById("zip").value.toLowerCase();
					var postalValueCheckout = postalValueCheckoutEntry;
					// vérifier la quantité de caractères et enlever la partie non nécessaire
					if(postalValueCheckout.length === 4 ){
						var postalValueTrim = postalValueCheckout.slice(0, -1);
					}else if(postalValueCheckout.length === 5 ){
						var postalValueTrim = postalValueCheckout.slice(0, -2);
					}else if(postalValueCheckout.length === 6 ){
						var postalValueTrim = postalValueCheckout.slice(0, -3);
					}else{
						var postalValueTrim = postalValueCheckout;
					}
					// Vérifier s'il y a une entrée valide
					let result = postalResult.match(postalValueTrim);
					// Vérifier un match de caractère entre le input et la valeur définie dans <t>postalCodeShipping</t>
					if ( result !== null || result > 0 ) {
						jQuery('.checkFalseMsg').remove();
					}else{
						jQuery('.cartSummary.cartTotal').append("<p style='display:flex;padding:20px;background-color:#f8f8f8;margin-bottom:0;color:red;font-size:1.2em;font-weight:600;' class='checkFalseMsg'>Malheureusement, nous n'offrons pas la livraison dans votre secteur. Optez plutôt pour la cueillette en magasin !</p>");
						return false;
					};
				} else {
					jQuery('.checkFalseMsg').remove();
				};
			});
	    });
	}
	
});