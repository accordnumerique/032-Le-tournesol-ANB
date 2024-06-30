(function ()
{
    function onDOMContentLoaded() {
        var topbar = document.getElementById('topbar');
        var newSibling = document.createElement('div');
        topbar.parentNode.insertBefore(newSibling, topbar.nextSibling);

        loadFromTemplate(newSibling, "tbs-menu", function() {
            var tbsMenuitem = document.querySelector(".tbs-menu .tbs-menuitem");

            // Replace menu to the new element
            var navbarNav = document.getElementsByClassName("navbar-nav")[0];
            tbsMenuitem.appendChild(navbarNav);
            
            var mNPL = document.getElementById("mNPL");
            mNPL.className = "";
            tbsMenuitem.appendChild(mNPL);
        });
    } // onDOMContentLoaded


    function loadFromTemplate(divDestination, strTemplate, callBack) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/Tournesol_custom/templates/'+ strTemplate +'.html', true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                divDestination.outerHTML = xhr.responseText;

                callBack(divDestination);
            }
        };
        xhr.send();
    }

    document.addEventListener('DOMContentLoaded', onDOMContentLoaded);
}());