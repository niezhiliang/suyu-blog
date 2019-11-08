---
title: Spring Cloud Bus动态刷新属性以及集成WebHooks
date: 2019.11.08
tags: 
  - Java 
  - SpringCloud
  - RabbitMQ
description: springcloud bus 动态刷新项目中的配置文件属性值
---

### config模块

- Maven依赖如下

```xml
    <dependencies>
        <!-- eureka client -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <!-- config server -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-server</artifactId>
        </dependency>
        <!-- 消息总线依赖 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-bus-amqp</artifactId>
        </dependency>
    </dependencies>

```

- 配置文件如下

```yaml
spring:
  application:
    name: fxq-config
  cloud:
    config:
      server:
        git:
          uri: http://git.test.cc/nzl/fxq-open-api-conf.git
          username: nzl
          password: 123456
  #rabbitmq配置
  rabbitmq:
    addresses: 127.0.0.1:5672
    username: springcloud
    password: 123456

eureka:
  client:
    service-url:
      defalutZone: http://localhost:8761/eureka/
  instance:
    prefer-ip-address: true


#将bus-amqp刷新属性的方法暴露出去默认是不暴露的
management:
  endpoints:
    web:
      exposure:
        include: "*"
```
#### config模块下需要注意的点
**1：** config为了安全默认是将动态刷新配置的endpoints是不开放的，所以我们配置完`消息总线`后访问地址：
http://127.0.0.1:7777/actuator/bus-refresh 发现会报404，要想让`actuator/bus-refresh`该endpoints暴露出来
必须在config模块的配置文件添加以下配置：
```yaml
management:
  endpoints:
    web:
      exposure:
        include: "*"
```
这个时候再去访问就能访问到了

**2：** `actuator/bus-refresh`该endpoints是以`POST`的方式暴露出来的所以要以`POST`的方式去请求

### 需要刷新配置的业务模块

- Maven依赖如下

```xml
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-bus-amqp</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-hystrix</artifactId>
            <version>1.4.7.RELEASE</version>
        </dependency>
    </dependencies>
```

- 配置文件如下

```yaml
server:
  port: 8899
spring:
  application:
    name: fxq-identity
  cloud:
    config:
      discovery:
        enabled: true
        service-id: FXQ-CONFIG
      profile: dev

eureka:
  client:
    service-url:
      defalutZone: http://localhost:8761/eureka/
  instance:
    prefer-ip-address: true

#feign开启服务降级
feign:
  hystrix:
    enabled: true
```

#### 业务模块下需要注意的点

**1：** 在需要刷新的类上面加上`@RefreshScope`注解

**2：** 当修改了配置文件只需要去手动访问下`http://127.0.0.1:7777/actuator/bus-refresh`再去读取属性的时候就刷新啦

### 配置WebHooks得到自动属性配置
其实git为我们提供了一个钩子，每次提交代码都可以去访问一个链接，通过这个钩子，我们就能达到修改完配置自动刷新配置的效果
![webhooks](https://suyu-img.oss-cn-shenzhen.aliyuncs.com/webhooks.png)












