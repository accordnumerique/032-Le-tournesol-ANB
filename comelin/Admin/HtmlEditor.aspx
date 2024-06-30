<!DOCTYPE>
<html>
<head>
    <title>Éditeur html</title>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Trumbowyg/2.26.0/trumbowyg.min.js" integrity="sha512-ZfWLe+ZoWpbVvORQllwYHfi9jNHUMvXR4QhjL1I6IRPXkab2Rquag6R0Sc1SWUYTj20yPEVqmvCVkxLsDC3CRQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Trumbowyg/2.26.0/langs/fr.min.js" integrity="sha512-Lm4FmZmqh2vXcK+zMhscAMdwkYtobg+0oKS5gIA38zOfeuXGte+7Xvcm5yViyrea4iNgKTQlsDu/NLaIaRlvuA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Trumbowyg/2.26.0/plugins/upload/trumbowyg.upload.min.js" integrity="sha512-tblyvFBkJg7Wlsx8tE+bj1HhrMSP4BtbeMNBoWlu2EtqZW24x52TZoP1ueepV4UbKfFz67Nsjucw++2Joju/nA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Trumbowyg/2.26.0/plugins/colors/trumbowyg.colors.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Trumbowyg/2.26.0/plugins/indent/trumbowyg.indent.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Trumbowyg/2.26.0/plugins/fontsize/trumbowyg.fontsize.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/trumbowyg@2.26.0/dist/ui/trumbowyg.min.css" integrity="sha256-c7+l8OhiSNisK+hC/5rU8aFy4WL/4Rz1/6GrGac9U6c=" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/trumbowyg@2.26.0/dist/plugins/colors/ui/trumbowyg.colors.min.css">
</head>
<body>
    <textarea id="wyg"></textarea>
    <script>
        var wyg = $('#wyg');
        wyg.trumbowyg({
            btns: [['viewHTML'],
            ['undo', 'redo'], // Only supported in Blink browsers
            ['formatting'],
            ['strong', 'em', 'del'],
            ['fontsize','superscript', 'subscript'],
            ['foreColor', 'backColor'],
            ['link','upload'],
            ['justifyLeft', 'justifyCenter', 'justifyRight', 'justifyFull'],
            ['indent', 'outdent'],
            ['unorderedList', 'orderedList'],
            ['horizontalRule'],
            ['removeformat']
            ],
            lang: 'fr',
            autogrow: true,
            resetCss: true,
            plugins: {
                upload: {
                    // Some upload plugin options, see details below
                    serverPath: '/api/image/upload/Trumbowyg',
                    data: [{ name: 'type', value: 'WebSite' }]
                }
            },
             semantic: false
        });
        wyg.trumbowyg('execCmd', { cmd: 'fullscreen' }); // full screen
        function SetHtml(html) {
            if (!html) {
                html = '';
            }
            wyg.trumbowyg('html', html);
        }

        function GetHtml() {
            return wyg.trumbowyg('html');
        }

        function AppendHtml(data) {
            wyg.trumbowyg('execCmd',
                {
                    cmd: 'insertHTML',
                    param: data,
                    forceCss: false
                });
        }
    </script>
</body>
</html>
