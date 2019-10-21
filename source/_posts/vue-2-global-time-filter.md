---
title:  vue2.0 定义时间日期的全局过滤器
date: 2018.04.09
tags: 
  - 前端
  - Vue

description: vue2.0 定义时间日期的全局过滤器
---


##### 我们使用的时间格式化插件是：vue-moment

- 安装插件 
```javascript
npm  install vue-moment --save
```

- 在src目录的main.js下面引入vue-monent
```javascript
import moment from 'moment'
```
- main.js里面定义全局时间过滤器
```javascript
Vue.filter('time', function (value, formatString) {
  formatString = formatString || 'YYYY-MM-DD HH:mm';
  return moment(value).format(formatString);
})
```

- 使用只要在双花括号里面用  I time 就ok啦
```javascript
<template>
  <div>
    <h1>全局过滤器</h1>
    <span>这是没有用过滤器的时间：{{ dateTime }}</span> <br/>
    <span>这是使用了过滤器的时间：{{ dateTime | time}}</span>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        dateTime: ''
      }
    },
    mounted() {
      this.getTime()
    },
    methods:{
      getTime: function () {
      //获取当前时间戳
        this.dateTime  = Date.parse(new Date());
      }
    }
  }
</script>
```

效果图

![这里写图片描述](https://img-blog.csdn.net/20180409144628965?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MDgyMzA0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)