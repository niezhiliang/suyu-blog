---
title:  SpringBoot RabbitMq 信息手动签收 Only one ConfirmCallback is supported by each RabbitTemplate
date: 2020.01.15
tags: 
  - Java 
  - RabbitMq
  - SpringBoot
  
description: SpringBoot RabbitMq 信息手动签收 Only one ConfirmCallback is supported by each RabbitTemplate 异常处理方法
---

### 异常信息出现

在工作实际开发中，用到了队列信息，为了消息的可靠性投递，我使用到了手动签收的方式
，开始只有一个地方使用到了，客户调用接口，有一个地方需要用到异步回调，由于中间件的异步特效，我就用队列来做，
开始这一块一点问题没有，客户还在正常使用，后面由于一个其他的需求，也需要使用到了队列，后面也加上了这种手动签收的方式来做，
在本地测试的时候也没啥问题，由于以前的代码没改 所以就没测那一块的功能 。 但是推到线上客户使用的时候，其中一个队列正常签收，
但是当有客户来用第二个队列的时候，就会报上面这个异常信息。


### 异常信息解析

从异常信息字面意思来看，就是说每个RabbitTemplate对象只支持一个`ConfirmCallback`手动签收方式的回调，然后我谷歌在文档上面找到一个方法，
这个是RabbitTemplate中`setConfirmCallback`方法的代码，

![image.png](https://upload-images.jianshu.io/upload_images/14511933-50abb14f63b3227f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```java
public static void state(boolean expression, String message) {
    if (!expression) {
        throw new IllegalStateException(message);
    }
}
```
从代码中解析我们可以知道，当前`RabbitTemplate.confiirmCallback`为null，或者传过来的回调对象就是当前的这个`confiirmCallback`的时候
就不会报这个异常信息，否则就会报异常信息

### 问题的解决

由于`spring`的`Bean`默认都是单例的，这个`RabbitTemplate`也不例外，既然每个RabbitTemplate对象只支持一个回调，那我就在该Bean放入spring容器把该RabbitTemplate
设置为原型的(也就是@Scope="prototype"),具体代码如下

```java
@Bean
@Scope("prototype")
public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
    RabbitTemplate template = new RabbitTemplate(connectionFactory);
    template.setMandatory(true);
    template.setMessageConverter(new SerializerMessageConverter());
    return template;
}
```
修改完以后 再次测试，问题解决啦。




