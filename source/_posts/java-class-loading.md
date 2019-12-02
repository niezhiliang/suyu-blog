---
title:  Java类加载机制 双亲委托模式
date: 2019.12.02
tags: 
  - Java 
  - JVM
  
description: Java类加载以及各个阶段任务分布 
---

![类加载时序图](https://upload-images.jianshu.io/upload_images/14511933-7f7fc8a513c70299.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 加载阶段

类加载阶段是由类加载器负责根据一个类的全名类读取此类的二进制字节流到JVM内部，并存储在运行时内存区的方法区内，然后将其转换为一个与目标类型对应的java.lang.Class
对象实例，这个Class对象在日后就会作为方法区中的该类的各种数据的访问入口。

JVM支持两种类型的类加载器，分别为引导类加载器（BootStrap ClassLoader） 和自定义类加载器（User-Defined Classloader）我们常用的包括 、Extension ClassLoader、
Application ClassLoader这三个类加载器。

#### BootStrap ClassLoader

BootStrap ClassLoader也称之为启动类加载器，由C++语言编写，并嵌套在JVM内部,主要负责加载`JAVA_HOME/lib`目录中的所有类型。

#### Extension ClassLoader

ExtClassLoader派生于ClassLoader,采用Java语言编写，负责加载ext文件夹（jre\lib\ext）内的类

#### Application ClassLoader

AppClassLoader派生于ClassLoader,采用Java语言编写，负责加载应用程序级别的类路径，提供的环境变量路径等

#### 双亲委托模式
一种被JVM设计者制定的类加载器的加载机制。按照双亲委托模式的规则，除了启动类加载器之外，程序中每一个类加载器都应该拥有一个超类加载器，比如Application ClassLoader
的超类加载器就是Extension ClassLoader，开发人员自定义的加载器的超类就是Application ClassLoader，当一个类加载器收到一个加载任务时，并不会立即展开加载
，而是将加载任务委派给它的超类加载器去执行，每一层的加载器都采用这种方式，直到委派给顶层的启动类加载器为止，如果超类无法加载该类，则会将类的加载内容退回给它的下一层
加载器去加载。双亲委托模式的优点就是：能有有效的确保一个类的全局唯一性。

![双亲委托模式](https://upload-images.jianshu.io/upload_images/14511933-f9f386b7eb1c7b39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


注意：Java虚拟机并没有明确要求类加载器的加载机制一定要使用双亲委托模式，只是建议这样做，而在`Tomcat`中，当默认的类加载器接收到一个加载任务时，首先会由
它自动加载，当加载失败，才会将类委派给它的超类加载器去执行，这是`Servlet`规范推荐的一种做法。


### 连接阶段

连接阶段由验证、准备、解析3个阶段构成。

#### 验证

验证主要任务就是验证类信息是否符合JVM规范，是否是一个有效的字节码文件，而验证的内容涵盖了类数据信息的格式验证、语义分析、操作验证等

#### 准备

准备阶段主要任务就是为类中所有静态变量分配内存空间，并为其设置一个初始值（由于对象还没有产生，因此实例变量将不在此操作范围内）


#### 解析

解析阶段主要任务就是将常量池中所有的符号引用全部转换为直接引用，由于Java虚拟机规范中并没有明确要求解析阶段一定要按照顺序执行，因此解析阶段可以等到初始化
以后再执行。

### 初始化阶段

初始化阶段中，JVM会将一个类中所有被static关键字标识的的代码统统执行一遍，如果执行的是静态变量，那么就会使用用户指定的值覆盖掉之前的准备阶段中JVM为其设置的初始值，
如果执行的是`static代码块` JVM就将会执行static代码中的所有操作。











   