---
title: Java8 文件与base64 byte[] 流之间的转换
date: 2019.11.21
tags: 
  - Java 
  
description: 工作中经常用到文件与base64 等其他状态的互相转换，每次都记不住，只好把各种文件的转换方法写个博客记录下来，方便下次使用的时候，直接复制就好。
---

### File转Base64

```java
//文件路径转换base64
Base64.getEncoder().encodeToString(Files.readAllBytes(Paths.get("../data/1.jpg")))


```

### Base64转File

```java
Files.write(Paths.get("../data/1.jpg"), Base64.getDecoder().decode(base64),StandardOpenOption.CREATE);
```

### File转InputStream

```java
InputStream in = new InputStream(new FileInputStream(File));
```

### InputStream转File

```java
Files.copy(inputStream,new File("/data/2.jpg").toPath(),StandardCopyOption.REPLACE_EXISTING);
```

### Base64转byte[]

```java
//1.java8
byte[] bytes = Base64.getDecoder().decode(base64)

//2.
byte[] bytes = new BASE64Decoder().decodeBuffer(base64)
```

### byte[]转Base64

```java
byte[] bytes = Files.readAllBytes(Paths.get("../data/1.jpg");
String base64 =  Base64.getEncoder().encodeToString(bytes);
```

### File转byte[]

```java
//1.文件路径获取
byte[] bytes = Files.readAllBytes(Paths.get("../data/1.jpg");

//2.File获取
byte[] bytes = null;
BufferedOutputStream bufferedOutput = new BufferedOutputStream(new FileOutputStream(file)).write(bytes);
```

### byte[]转File
```java
Files.write(Paths.get("../data/2.jpg"),bytes , StandardOpenOption.CREATE);

```

### 文件复制

```java
Files.copy (Paths.get("/data/1.jpg"),new FileOutputStream (new File ("/data/2.jpg")));

```