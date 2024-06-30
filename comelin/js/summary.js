// Cart summary page
// Comelin
// Jean-Claude Morin  april 2020
$(document).ready(function () {
	if (exist('_popMessage')) {
		$('#cmdBilling').popover({
			html: true,
			placement: 'top',
			title: _popMessage.Title + ' <a href="#" class="close" data-dismiss="alert">&times;</a>',
			content: _popMessage.Message,
        }).on('hide.bs.popover', function(shownEvent) {
            setTimeout(() => $(shownEvent.target).popover('dispose'), 100);
        });
		$('#cmdBilling').popover('show');
    }

    $('#cmdBilling').click(function(e) {
        var radSummaryPickup = $$('radSummaryPickup');
        if (radSummaryPickup && radSummaryPickup.checked) {
            var lstSummaryShippingStore = $$('lstSummaryShippingStore');
            if (lstSummaryShippingStore && !lstSummaryShippingStore.value) {
                console.log('Magasin non sélectionner');
                $('#cmdBilling').popover({
                    html: true,
                    placement: 'top',
                    title: document.querySelector('label[for="radSummaryPickup"]').innerText + ' <a href="#" class="close" data-dismiss="alert">&times;</a>',
                    content: _Text["StoreNoSelected"],
                    trigger: 'focus'
                });
                $('#cmdBilling').popover('show');
                e.preventDefault();
                return false;
            }
        }
		
    });
});