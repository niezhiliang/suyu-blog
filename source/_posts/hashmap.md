---
title: HashMap面试题以及答案
date: 2019.10.23
tags: 
  - Java 
  - HashMap
  - 面试
description: 平常面试中出现比较频繁关于HashMap面试题
---

#### HashMap工作原理

HashMap基于hashing原理，我们通过put()和get()方法存储和获取对象。当我们将键值对传递给put()方法时，它调用键对象
的hashCode方法来计算hashcode，然后找到了bucket位置来存储值对象。当获取对象时，通过键对象的equals()方法找到正确
的键值对，然后返回值对象。HashMap使用链表来解决碰撞问题，当发生碰撞了，对象将会存储在链表的下一个节点中。HashMap在
每个链表节点中储存键值对象。

#### HashMap当两个不同的键对象的hashcode相同会发生什么，调用get()会如何键值对中的值

 首先在调用put()方法时，会先调用键对象的hashCode方法来计算hashcode，计算出hashcode以后，找到对应的bucket位置
 ，查看该bucket中已经有值，如果有值说明此时发生了碰撞，那么新添加的键对象会保存在该bucket位置的链表中，当调用get()方法来获取
 键对象的值时，会遍历当前链表通过键对象的equals()方法来找到正确的键对象并返回相应的值。
 
 #### HashMap和Hashtable的区别
 
 HashMap和Hashtable都实现了Map接口，主要区别有：线程安全性，同步（synchronization），以及速度。
 
 **1.** HashMap几乎等价于Hashtable，除了HashMap是非线程安全的，并且可以接受null（HashMap可以接受为null的键值（key）
 和值（value），而Hashtable不行）。
 
 **2.** HashMap是非线程安全的，而Hashtable是线程安全的，这意味着Hashtable是线程安全的，多个线程可以共享一个Hashtable；
 而如果没有正确的同步的话，多个线程是不能共享HashMap的。Java5提供了ConcurrentHashMap，它是Hashatable的替代，比Hashtable
 的扩展性更好。
 
 **3.** 另一个区别是HashMap的迭代器（iterator）是fail-fast迭代器，而Hashtable的enumerator迭代器不是fail-fast。所以当
 有其它线程改变了HashMap的结构（增加或者移除元素），将会抛出ConcurrentModificationException,但迭代器本身的remove()方法
 移除元素，则不会抛出ConcurrentModificationException异常。但这个并不是一个一定发生的行为，要看JVM。这条同样也是Enumeration
 和Iterator的区别。
 
 **4.** 由于Hashtable是线程安全的也是synchronized，所以在单线程环境下它比HashMap要慢。如果不需要同步，只需要单一线程，那么使用
 HashMap性能要好过Hashtable。
 
 **5.** HashMap不能抱着随时间的推移Map中的元素次序是不变的。
 
 
 #### HashMap和HashSet的区别
 
 | 区别 | HashSet | HashMap |
 | :---: | :---: | :---:| 
 | 内部实现 | 基于HashMap | 基于数组、链表、红黑树 
 | 元素特点 | 无序不重复 | 键值对、键不可重复 
 | implements | Set | Map 
 | hashCode | 来自元素自身属性 | hashCode(key)^hachCode(value) 
 | 检索速度 | 慢 | 快 
 
 #### 为什么HashMap中String、Integer这样的包装类适合作为key键
 
 由于String和Integer等包装类型都是final修饰的，具有不可变性保证了key的不可更改性，不会出现获取hashcode不同的情况，有效的减少了发生Hash碰撞的几率。
 而且包装类型内部已经重写了equals()和hashCode()方法。
 
 #### HashMap中的key若Object类型则需实现哪些方法？
 
 需实现hashCode()和equals()方法，hashCode()方法就算需要存储数据的储存位置，实现不恰当会导致严重的Hash碰撞，equals()方法主要就是
 包装键key在hash表中的唯一性。
 
 #### 如果使HashMap同步
 HashMap可以通过下面的语句进行同步：
```java
Map m = Collections.synchronizeMap(hashMap);
```
#### Jdk1.8中HashMap有哪些新特性
Jdk1.7的时候HashMap是基于数组和链表实现的，为了提高HashMap的性能，利用红黑树快速增删改查的特点，Jdk1.8在链表的基础上引入了红黑树，当键值的hash不发生冲突时，
键值存放在数组当中，hash发生冲突（碰撞）时，存放在链表中，当链表长度大于8的时候，将链表转换成红黑树来存储键值。

#### HashMap的加载因子是多少，如果这个加载因子越大或加载因子越小有什么优缺点？
默认的加载因子是0.75，HashMap的初始化容量为16，也就是当HashMap中的元素 > 容量 x ${加载因子}时就会触发扩容，扩容后的容量为原来容量的2倍
如果加载因子大于0.75，优点：容量的填满的元素越多，链表变长，空间利用率高，缺点：hashcode冲突的概率加大，查找的效率变低。
如果加载因子越小，优点：键值的hashcode冲突概率就低，链表短 查询的速度就越快。缺点：填满容量的的元素就少，空间利用率就低。
默认因子为0.75是一个容量利用率和避免hashcode碰撞的折中值。













 