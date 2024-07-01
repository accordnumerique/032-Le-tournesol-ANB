(function ()
{
    function onDOMContentLoaded()
    {
        var currentLang = window.location.pathname.substring(0, 3) || "fr";
        document.getElementsByTagName("body")[0].classList.add("text-hide-" + (currentLang == "fr" ? "en" : "fr"));

        if (window.location.pathname.toLocaleLowerCase() === "/fr/" ||
            window.location.pathname.toLocaleLowerCase() === "/en/")
        { 
            document.getElementsByTagName("body")[0].classList.add("page-home");
        }

        document.getElementById("search-top").autofocus = false;
        moveElement("#search-top", "#search-top-move");
        moveElement("#lnkWishlist", "#lnkWishlist-move");
        moveElement("#lnkViewCart", "#lnkViewCart-move");
    } // onDOMContentLoaded

    function moveElement(selectorOrigin, selectorDestination) {
        var elementOrigin = document.querySelector(selectorOrigin);
        if (!elementOrigin)
        {
            return;
        }

        var elementDestination = document.querySelector(selectorDestination);
        if (!elementDestination)
        {
            return;
        }
        elementDestination.appendChild(elementOrigin);
    }

    document.addEventListener('DOMContentLoaded', onDOMContentLoaded);
}());