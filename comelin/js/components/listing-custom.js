// Script pour afficher des produits spécifique avec des ids ou une catégorie
// Comelin par Jean-Claude Morin
// décembre 2018

if (!('vueComponents' in window)) {
    vueComponents = []; // list of components to register
}
vueComponents.push(function () {
    Vue.component('listing-by-product', {
        props: ['ids'],
        data: function () {
            return {
                products: null
            }
        },
        methods: {

        },
        mounted() {
            var component = this;
            fetch('/api/listing/by-ids?ids=' + this.ids)
                .then(response => response.json())
                .then(response => {
                    vm.$set(component, 'products', response);
                });
        }
    });

});