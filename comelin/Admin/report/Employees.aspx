<%@ Page Title="Liste des employés" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" CodeBehind="Employees.aspx.cs" Inherits="WebSite.Admin.report.Employees" %>
<asp:Content runat="server" ID="Cp" ContentPlaceHolderID="cp">

    <div id="appReportEmployee">
        <table id="table">
            <thead>
            <tr>
                <th>Actif</th><th>Nom</th><th>Création</th><th>Dernière connexion</th>
            </tr>
            </thead>
        </table>
    </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="cpFooter">
    <script>
    
        const urlGetEmployeeData = "/admin/employe/list";
        const urlEmployeeSetEnable = "/admin/employe/enable";
        
        var appEmployeeList = new Vue({
            el:'#appReportEmployee',
            data: {
                entries: null, // downloaded
                dataTableCreated: false,
                dataTable: null
            },
            methods: {
                downloadData() {
                    let c = this;
                    fetchPost(urlGetEmployeeData + document.location.search, null, null, data => {
                        c.entries = data.Employees;
                        if (c.dataTable != null) {
                            dataTable.clear().rows.add(data.Employees).draw(); // table already created, just update the source
                        } else {
                            c.createDataTable();
                        }
                    });
                },
                createDataTable() {
                    dataTable = $('#table').DataTable({
                        data: this.entries,
                        columns: [
                            {  
                                defaultContent:false,
                                data: renderCheckboxEmployeeEnable
                            },
                            {  data: 'Name'},
                            {  mData: function (source, type, val) { return FormatPropDate(source, type, val, 'DateCreated'); } },
                            {  mData: function (source, type, val) { return FormatPropDate(source, type, val, 'DateLastConnection'); } }
                        ],
                        order: [[0, 'desc'],[1, 'asc']]
                    
                    });
                 }
            },
            mounted() {
                this.downloadData(); 
            }

        })
        
        function renderCheckboxEmployeeEnable(row) {
             var id = row.Id;
                                    var isChecked = row.IsEnable;
                                    var isCheckedStr = isChecked ? 'checked' : '';
                                    var template = '<input type=checkbox onclick=enableToggleEmployee(this) ' + isCheckedStr + ' data-id=' + id + ' />'
                                    return template
        }

        function enableToggleEmployee(ctrl) {
            var payload = { IdEmployee: ctrl.dataset["id"], IsEnable: ctrl.checked };
            fetchPost(urlEmployeeSetEnable, payload);
        }
        

    </script>

</asp:Content>
