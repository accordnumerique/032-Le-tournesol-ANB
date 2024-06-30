(function ()
{
    function onDOMContentLoaded()
    {
        var topbar = document.getElementById('topbar');
        var newSibling = document.createElement('div');
        topbar.parentNode.insertBefore(newSibling, topbar.nextSibling);

        loadFromTemplate(newSibling, "tbs-menu", function ()
        {
            // Replace menu to the new element
            var navbarNav = document.getElementsByClassName("navbar-nav")[0];
            var tbsMenuitem = document.querySelector(".tbs-menu .tbs-menuitem .items");
            tbsMenuitem.appendChild(navbarNav);

            moveElement(".divSignIn", "#divSignIn-move");
            moveElement("#search-top", "#search-top-move");
            moveElement("#lnkWishlist", "#lnkWishlist-move");
            moveElement("#lnkViewCart", "#lnkViewCart-move");
        });

        var currentLang = window.location.pathname.substring(0, 3) || "fr";
        document.getElementsByTagName("body")[0].classList.add("text-hide-" + (currentLang == "fr" ? "en" : "fr"));

        if (window.location.pathname.toLocaleLowerCase() === "/fr/" ||
            window.location.pathname.toLocaleLowerCase() === "/en/")
        { 
            document.getElementsByTagName("body")[0].classList.add("page-home");
        }

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

    function loadFromTemplate(divDestination, strTemplate, callBack)
    {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/Tournesol_custom/templates/' + strTemplate + '.html', true);
        xhr.onreadystatechange = function ()
        {
            if (xhr.readyState === 4 && xhr.status === 200)
            {
                divDestination.outerHTML = xhr.responseText;
                callBack(divDestination);
            }
        };
        xhr.send();
    }


    document.addEventListener('DOMContentLoaded', onDOMContentLoaded);
}());