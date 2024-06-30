// home page Comelin
if (document.getElementsByTagName('vueper-slides')) {
    InitSlider();
}

function InitSlider() {
    if (!window._components) {
        window._components = {};
    }
    const { VueperSlides, VueperSlide } = vueperslides;
    window._components.VueperSlides = VueperSlides;
    window._components.VueperSlide = VueperSlide;

    // using https://github.com/antoniandre/vueper-slides/
    window._components.bs = Vue.component('brand-slider',
        {
            components: { VueperSlides, VueperSlide },
            template: `<vueper-slides v-if=slides id="brandSlider" autoplay class="no-shadow"
                   :duration ="2000"
                   :arrows="false" 
                   :bullets="false" 
                   :visible-slides="6"
                   :gap="3"
:touchable="false"
:initSlide=2
                   :slide-ratio="1 / 6"
                   :breakpoints="{ 800: { visibleSlides: 2, slideMultiple: 1, slideRatio:0.5 } }">
        <vueper-slide v-for="b of slides" :key="b.Id" :content="b.Html"></vueper-slide>
    </vueper-slides>`,
            data: function() {
                return {
                    slides: null
                }
            },
            mounted() {
                var instance = this;
                $.ajax('/Api/BrandImage?nb=20').done(function(e) {
                    shuffle(e);
                    for (var brand of e) {
                        brand.Html = "<a href='" + brand.Url + "'><img src='" +  brand.Image + "?size=150' title='" + brand.Title + "' alt='" + brand.Title + "' /></a>";
                    }
                    instance.slides = e;
                    // duplicate the list for smoother transaction since the plugin do not do loop properly
                    const nb = e.length;
                    for (var i = 0; i < nb; i++) {
                        const copy = Object.assign({}, e[i]);
                        copy.Id = -copy.Id; // so id are unique
                        instance.slides.push(copy);

                    }
                });
            }
        });
}
