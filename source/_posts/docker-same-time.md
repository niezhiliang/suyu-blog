---
title:  docker容器与宿主机时间同步设置
date: 2019.10.21
tags: 
  - docker 
  - docker-compose
  
description: 将docker容器/etc/localtime  和/etc/timezone 与宿主机文件共享就能实现时间同步（亲测可行）
---

### 将docker容器/etc/localtime  和/etc/timezone 与宿主机文件共享就能实现时间同步（亲测可行）

只要修改docker-compose.yml文件就好
```java
     volumes:
       - /etc/timezone:/etc/timezone
       - /etc/localtime:/etc/localtime
```