<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMP.Master" AutoEventWireup="true"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="server">
    <h1>Catégories</h1>
    <div id="appCategories">
        <div id="loading" v-if="loading">Chargement...</div>
        <div v-else>
            <tree-menu 
                :nodes="categories" 
                :depth="0"
            ></tree-menu>

        </div>
    </div>
    
    <script type="text/x-template" id="tree-menu">
   <div class="tree-menu">
    <div class="label-wrapper" @click="toggleChildren">
      <div :style="indent" :class="labelClasses">
        <i v-if="nodes && label" class="fa" :class="iconClasses"></i>
        <span v-html=label></span>
        
      </div>
    </div>
    <tree-menu 
      v-if="showChildren"
      v-for="node in nodes" 
      :nodes="node.SubCategories" 
      :label="node.Title + '<span class=nbId>#' + node.Id + '</span>'"
      :depth="depth + 1"   
    >
    </tree-menu>
  </div>
</script>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cpFooter" runat="server">
    <script>
        Vue.component('tree-menu', { 
            template: '#tree-menu',
            props: [ 'nodes', 'label', 'depth' ],
            data() {
                return {
                    showChildren: true
                }
            },
            computed: {
                iconClasses() {
                    return {
                        'fa-plus-square-o': !this.showChildren,
                        'fa-minus-square-o': this.showChildren
                    }
                },
                labelClasses() {
                    return { 'has-children': this.nodes }
                },
                indent() {
                    return { transform: `translate(${this.depth * 50}px)` }
                }
            },
            methods: {
                toggleChildren() {
                    this.showChildren = !this.showChildren;
                }
            }
        });
        var appCategories = new Vue({
            el: '#appCategories',
            data: {
                //loading:true,
                categories: null
            },
            computed: {
                loading() {
                    return this.categories == null;
                } 
            },
            mounted() {
                fetchPost('/api/categories?level=10&all=true', null, null, (dataReceived) => appCategories.categories = dataReceived);
            },
            
        });

    </script>
    <style>
        .loading { background-color: white;border: orange;margin: 20px; padding: 20px; min-width: 50%; margin-left: auto;margin-right: auto}
        .nbId { margin-left: 5px; color:#4682b4}
        
    </style>
</asp:Content>
