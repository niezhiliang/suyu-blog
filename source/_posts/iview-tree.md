---
title:  iview tree组件获取选中的子节点 getCheckedNodes
date: 2018.11.15
tags: 
  - Vue
  - iview
  - 前端 

description: 获取tree组件中选中的子节点
---

```javascript
        <Tree :data="menus" ref="tree" show-checkbox multiple style="display:inline-block"></Tree>
        
  export default {
    data () {
      return {
        menus: []
     }
    },
    created() {
      this.getTree()
    },
    methods: {
      getTree: function () {
        http.get("/menu/tree").then((res) => {
          if (res.code === 100) {
             this.menus.push(res.data);
          }
        })
      },
      //获取tree组件的选中子节点
      getNodes: function () {
        console.log(this.$refs.tree.getCheckedNodes())
      }
    }
  }
```
