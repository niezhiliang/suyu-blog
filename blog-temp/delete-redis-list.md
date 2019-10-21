---
title:  Java spring-boot-starter-data-redis  redis删除list中的值
date: 2019.10.21
tags: 
  - Redis
  - Java 
description: redis基于trim函数和leftPop函数删除list中所有的值
---

```java
    /**
     * 删除list集合
     * @param key
     */
    public void delete(String key) {
        //保留集合中索引0，0之间的值，其余全部删除  所以list只有有一个值存在
        listOperations.trim(key,0,0);
        //将list中的剩余的一个值也删除
        listOperations.leftPop(key);
    }
```