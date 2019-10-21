---
title:  vue2.0 父子组件通讯 传参 方法调用
date: 2018.04.09
tags: 
  - 前端
  - Vue

description: vue父子组件之间的参数传递与获取
---

#### vue子组件获取父组件参数
-------
子组件使用props:[ 'message' ]来接受
父组件通过引入子组件 并创建一个:message的参数来进行传递

##### 父组件：
```javascript
<template>
  <div>
    <h1>父窗体</h1>
  <son :params="user" :msg="message"></son>
  </div>
</template>

<script>
  import son from '@/pages/son'
  export default {
    data() {
      return {
        user:{
          name: 'suyu',
          sex: 'boy',
          age: '22'
        },
        message: 'this from parent components'
      }
    },
    components:{ son }
  }
</script>


```
##### 子组件：
```javascript
<template>
  <div>
    <h1>子组件</h1>
     单属性：{{ msg }}
     对象：{{ params }}
  </div>
</template>

<script>
  export default {
    data() {
      return {

      }
    },
    props: [ 'params' ,'msg']
  }
</script>

```

#### vue父组件获取子组件参数和方法
子组件跟平时一样定义变量
父组件通过引入子组件 并创建使用  ref 来监听子组件的变量和方法
最后使用 this.$refs.refName.xxx来访问变量和方法

##### 父组件：
```javascript
<template>
  <div>
    <h1>父窗体</h1>
  <son ref="sonone"></son>
  </div>
</template>

<script>
  import son from '@/pages/son'
  export default {
    mounted () {
      this.getVal()
    },
    methods:{
      getVal:function () {
        this.$refs.sonone.sendMsg()//调用子组件的方法
        console.log(this.$refs.sonone.msg)//调用子组件的变量
      }
    },
    components:{ son }
  }
</script>
```
##### 子组件：
```javascript
<template>
  <div>
    <h1>子组件</h1>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        msg: 'this msg from son component'
      }
    },
    methods: {
      sendMsg: function () {
        console.log(this.msg)
      }
    }
  }
</script>

```
#### vue子组件调用父组件方法
父组件声明一个方法
父组件通过引入子组件 并创建使用  @xxx 来传递声明的方法
最后子组件使用  this.$emit('xxx','参数')来访问该方法

##### 父组件：
```javascript
<template>
  <div>
    <h1>父窗体</h1>
  <son @func="fun"></son>
  </div>
</template>

<script>
  import son from '@/pages/son'
  export default {
    data() {
      return {
      }
    },
    methods:{
    //声明方法
      fun: function (data) {
        console.log(data)
      }
    },
    components:{ son }
  }
</script>
```
##### 子组件：
```javascript
<template>
  <div>
    <h1>子组件</h1>
  </div>
</template>

<script>
  export default {
    data() {
      return {
      }
    },
    mounted(){
     //调用父组件的方法
      this.$emit('func','this is parent function')
    }
  }
</script>


```