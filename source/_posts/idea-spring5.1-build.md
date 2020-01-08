---
title: spring-framework-5.1.x idea编译 方便源码阅读
date: 2020.01.08
tags: 
  - Java 
  - Spring
  
description: spring-framework-5.1.x idea编译方便阅读源码和加注释
---

### github上面下载spring-framework-5.1.x源码

![WX20200108-081955@2x.png](https://upload-images.jianshu.io/upload_images/14511933-e1ec9902b5a9d3a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 将下载的源码导入到idea

#### 导入代码之前，请确保已经安装了gradle环境 

查看本地是否安装环境
```shell script
fxqdeiMac:suyu-blog fxq$ gradle -v

------------------------------------------------------------
Gradle 6.0.1
------------------------------------------------------------

Build time:   2019-11-18 20:25:01 UTC
Revision:     fad121066a68c4701acd362daf4287a7c309a0f5

Kotlin:       1.3.50
Groovy:       2.5.8
Ant:          Apache Ant(TM) version 1.10.7 compiled on September 1 2019
JVM:          1.8.0_231 (Oracle Corporation 25.231-b11)
OS:           Mac OS X 10.13.6 x86_64

```

如果没有安装，按照下面的方式安装一下

- Mac系统,输入完下面的命令完成后就能使用了

```shell script
brew install gradle
```


#### 从github中下载的代码为.zip文件 需要先将其解压

![2.png](https://upload-images.jianshu.io/upload_images/14511933-646b440875df88cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

导入以后我们就需要等待idea将其编译完成，这个时间比较长，耐心等待一下 可以去先去干的别的事。

#### idea编译完成后

- 编译完成以后如下图

![3.png](https://upload-images.jianshu.io/upload_images/14511933-6d1df7c6ef4da69b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- 注意事项

导入后的项目下面有个官方给的编译文档`import-into-idea.md`

```
## Known issues

1. `spring-core` and `spring-oxm` should be pre-compiled due to repackaged dependencies.
See `*RepackJar` tasks in the build and https://youtrack.jetbrains.com/issue/IDEA-160605).
2. `spring-aspects` does not compile due to references to aspect types unknown to
IntelliJ IDEA. See http://youtrack.jetbrains.com/issue/IDEA-64446 for details. In the meantime, the
'spring-aspects' can be excluded from the project to avoid compilation errors.
3. While JUnit tests pass from the command line with Gradle, some may fail when run from
IntelliJ IDEA. Resolving this is a work in progress. If attempting to run all JUnit tests from within
IntelliJ IDEA, you will likely need to set the following VM options to avoid out of memory errors:
    -XX:MaxPermSize=2048m -Xmx2048m -XX:MaxHeapSize=2048m
```

这句话大概意思就是 项目中某些模块依赖了`spring-core` and `spring-oxm` ，第二步是说关于依赖了`aspects`,我们这里暂时不管这个。 所以我们要先对其进行编译，编译完这两个
再去编译其他的模块。这两个模块的具体编译步骤如下图：

![4.png](https://upload-images.jianshu.io/upload_images/14511933-bbdb88c70a6ce6dd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---

![5.png](https://upload-images.jianshu.io/upload_images/14511933-91d25f7db844f4ea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- 建自己的模块

 ![6.png](https://upload-images.jianshu.io/upload_images/14511933-31440f978c33b537.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
 我们自己建的模块，只需要依赖源码的`spring-context`,这个模块包含了`ioc` `bean工厂` 等
 ![7.png](https://upload-images.jianshu.io/upload_images/14511933-3c8bb7515137387f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 编辑自定义模块

![8.png](https://upload-images.jianshu.io/upload_images/14511933-99a5b68ad8651977.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

到这里我们的源码编译就全部完成了，这个时候我们点击我们自定义模块Test.class `AnnotationConfigApplicationContext` 就是我们这个项目中的
代码，我们可以对立面的代码进行注释 删除啦。

---

接下来就可以开始快乐的源码阅读之旅的。







