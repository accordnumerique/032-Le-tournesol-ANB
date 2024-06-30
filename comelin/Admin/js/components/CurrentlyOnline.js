// display employee online from the variable _currentlyOnline
// JcMorin (c) Comelin November 2021



Vue.component('currently-online',
    {
        template: `<div id=currentlyOnline v-if=Stores>
<div v-for="s in Stores">
<h3 class=StoreName>{{s.StoreName}}</h3>
<div class=computers>
    <div v-for="c in s.Computers" class=computer>
        <div class=computerName>{{c.Computer}}
            <i v-if="c.ComputerName" class='fa fa-info-circle' :title="getComputerToolTip(c)"></i>
        </div>
        <div v-for="e in c.Employees" class="emp leftRight">
            <div class=employeeName>{{e.Employee}}</div>

<div class=time>{{FormatTime(e.TimePunchIn)}}</div>
        </div>
        <div class="computerFooter leftRight">
            <div>version: {{c.Version}}</div>
            <div>IP: {{c.IpAddress}}</div>
        </div>
    </div>
</div>
</div>
</div>`,
        data() {
            return {
                Stores: null
            };
        },
        methods: {
            FormatTime(t) {
                return new Date(t).toLocaleTimeString();
            },
            getComputerToolTip(computer) {
                return "Nom de l'ordinateur: " + computer.ComputerName;
            }
        },
        mounted() {
            if (window._currentlyOnline != null) {
                this.Stores = window._currentlyOnline.Stores;    
            }
            
        }
    });

