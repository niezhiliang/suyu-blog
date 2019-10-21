---
title:  Java8 时间的各种使用示例 Date转LocalDateTime LocalDateTime转Date 转时间戳
date: 2019.09.24
tags: 
  - Java8
  - 时间 
description: Java8最新时间的使用 时间类型的转换
---

# Java8 时间使用

#### 获取当前日期

```java
//2019-06-19
LocalDate nowLocalDate = LocalDate.now();

DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

//2019-06-19
String nowString = nowLocalDate.format(formatter);
```

#### 获取当前时间
```java
//10:03:22.237
LocalTime localTime = LocalTime.now();

DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");

//10:03:22
String stringTime = localTime.format(formatter)
```

#### 获取当前日期加时间

```java
//2019-06-19T10:06:05.463
LocalDateTime localDateTime = LocalDateTime.now();

DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

//2019-06-19 10:06:05
String dateTime = LocalDateTime.now().format(formatter);

//2019-06-19T10:37:07.407
String dateTime = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
```

#### 自定义时间(LocalDate)

```java
//10:09:20
LocalTime localTime = LocalTime.parse("10:09:20");

//2019-06-19
LocalDate localDate = LocalDate.parse("2019-06-19");

//2019-06-19T10:09:30
LocalDateTime localDateTime = LocalDateTime.parse("2019-06-19T10:09:30");
```

#### 计算两个日期的时间差

```java
//18066 获取从1970年以来的天数：toEpochDay
long days = LocalDate.now().toEpochDay();

//565 获取两个时间的天数差
long day = LocalDate.now().toEpochDay() - LocalDate.parse("2017-12-01").toEpochDay();
```

#### 判断日期的先后，isAfter/isBefore

```java
LocalDate date1 = LocalDate.parse("2019-06-19");

LocalDate date2 = LocalDate.parse("2019-06-20");
//date1是否在date2时间之前
if (date1.isBefore(date2)) {
    System.out.println("date1在date2之前");
}
//date2是否在date1时间之后
if (date2.isAfter(date1)) {
    System.out.println("date2在date1之前");
}
```

#### Date和LocalDateTime转换

```java
/**
 * Date转LocalDateTime
 * @param date
 * @return
 */
public static LocalDateTime date2LocalDate(Date date) {
    return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
}

/**
 * Date转LocalDateTime
 * @param date
 * @return
 */
public static LocalDateTime dateToLocalDate(Date date) {
    return LocalDateTime.ofInstant(Instant.ofEpochMilli(date.getTime()), ZoneId.systemDefault());

}

/**
 * LocalDateTime转Date
 * @param localDateTime
 * @return
 */
public static Date localDate2Date(LocalDateTime localDateTime) {
    return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
}

/**
 * LocalDateTime转Date
 * @param localDateTime
 * @return
 */
public static Date localDateToDate(LocalDateTime localDateTime) {
    return new Date(localDateTime.toInstant(ZoneOffset.of("+8")).toEpochMilli());
}
```

#### LocalDateTime与时间戳的使用

```java
//获取时间戳秒数
Long second = LocalDateTime.now().toEpochSecond(ZoneOffset.of("+8"));
//获取时间戳毫秒数
Long milliSecond = LocalDateTime.now().toInstant(ZoneOffset.of("+8")).toEpochMilli();

/**
 * 时间戳转LocalDateTime
 * @param timestamp
 * @return
 */
public LocalDateTime timestamToLocalDateTime(long timestamp){
    return LocalDateTime.ofInstant(Instant.ofEpochMilli(timestamp), ZoneId.systemDefault());
}

/**
 * LocalDateTime转时间戳
 * @param localDateTime
 * @return
 */
public long localDateTimeToTimestamp(LocalDateTime localDateTime){
    return localDateTime.toInstant(ZoneOffset.of("+8")).toEpochMilli();
}
```

#### 其它API

```java

//2019-06-19T10:25:30.846
LocalDateTime localDateTime = LocalDateTime.now();

//19 今天是当前月份的第几天
int dayOfMonth = localDateTime.getDayOfMonth();

//170 今天是今年的第几天
int dayOfYear = localDateTime.getDayOfYear();

//WEDNESDAY 今天是周几
DayOfWeek dayOfWeek = localDateTime.getDayOfWeek();

//3 今天是本周第几天
int dayofWeek = dayOfWeek.getValue();

//2019-06-18T10:25:30.846 获取当前时间前1天时间
LocalDateTime beforeDateTime = LocalDateTime.now().minusDays(1);

//2019-06-20T10:25:30.846 获取当前时间1天后的时间
LocalDateTime nextDateTime = LocalDateTime.now().plusDays(1);

//2019-06-19T08:27:30.400 获取当前时间的2小时之前的时间
LocalDateTime beforeHourTime = LocalDateTime.now().minusHours(2);

//2019-06-19T10:49:20.996 获取当前时间20分钟后的时间
LocalDateTime afterMinuteTime = LocalDateTime.now().plusMinutes(20);

//false 判断今年是否是闰年
boolean isLeapYear =  LocalDate.now().isLeapYear();
```

