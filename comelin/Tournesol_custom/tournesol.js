(function ()
{
    function onDOMContentLoaded()
    {
        $("#tbs-search").keyup(function(e){
            if(e.keyCode == 13)
            {
                document.location = window.location.pathname.substring(0, 3) + "/" + e.currentTarget.value + "-q";
            }
        });

        var currentLang = window.location.pathname.substring(1, 3) || "fr";
        $("body").addClass("text-hide-" + (currentLang == "fr" ? "en" : "fr"));


        if (window.location.pathname.toLocaleLowerCase() === "/fr/" ||
            window.location.pathname.toLocaleLowerCase() === "/en/")
        { 
            $("body").addClass("page-home");
        }
    } // onDOMContentLoaded

    document.addEventListener('DOMContentLoaded', onDOMContentLoaded);
}());