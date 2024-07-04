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

        if (window.location.pathname.toLocaleLowerCase() === "/fr/" ||
            window.location.pathname.toLocaleLowerCase() === "/en/")
        { 
            $("body").addClass("page-home");
        }
    } // onDOMContentLoaded

    document.addEventListener('DOMContentLoaded', onDOMContentLoaded);
}());