---
title: 工作中常用的SQL优化
date: 2019.11.26
tags: 
  - SQL 
  - SQL优化
  - MySql
  
description: 工作中常用的sql优化
---


1、查询语句中不要使用 *

```sql
select * from t
```

修改建议：
```sql
select id from t
```

2、尽量减少子查询，使用关联查询（left join,right join,inner join）替代

```sql
select id from t where name (select name from t1)
```

修改建议：
```sql
select t.id from t left join t2 on t.id = t2.t1.id where
name = t2.name
```

3、应尽量避免在 where 子句中对字段进行 null 值判断，否则将导致引擎放弃使用索引而进行全表扫描，如：

```sql
select id from t where num is null
```
修改建议：
最好不要给数据库留`NULL`，尽可能使用`NOT NULL` 填充数据库 可以在`num`上设置默认值0,确保`num`列没有`NULL`值，然后这样查询：

```sql
select id from t where num = 0
```

4、应尽量避免在 where 子句中使用 != 或 <> 操作符，否则将引擎放弃使用索引而进行全表扫描

5.应尽量避免在 where 子句中使用 or 来连接条件，如果一个字段有索引，一个字段没有索引，将导致引擎放弃使用索引而进行全表扫描
```sql
select id from t where num=10 or Name = 'admin'
```
修改建议：
```sql
select id from t where num = 10
union all
select id from t where Name = 'admin'
```

6、 `in` 和 `not in` 也要慎用，否则会导致全表扫描，如：

```sql
select id from t where num in (1,2,3)
```

修改建议：
对于连续的数值，能用`between`就不要用`in`:
```sql
select id from  t where num begin 1 and 3
```

很多时候用`exists`代替`in`是一个好的选择

```sql
select num from a where num in (select num from b)
```
建议：
```sql
select num from a where exists(select 1 from b where num = a.num)
```

7、下面的查询也会导致全表扫描：
```sql
select id from t where name like '%abc%'
```
若要提高效率，可以考虑全文检索

8、应尽量避免在 where 子句中对字段进行表达式操作，这将导致引擎放弃使用索引而进行全表扫描。如：

```sql
select id from t where num/2 = 100
```

应该为：

```sql
select id from t where num = 100 * 2
```

9、`Update` 语句，如果只更改1、2个字段，不要Update全部字段，否则频繁调用会引起明显的性能消耗，同时带来大量日志。

10、索引并不是越多越好，索引固然可以提高相应的 `select` 的效率，但同时也降低了 `insert` 及 `update` 的效率，因为 `insert` 或 `update` 时有可能会重建索引，
所以怎样建索引需要慎重考虑，视具体情况而定。一个表的索引数最好不要超过6个，若太多则应考虑一些不常使用到的列上建的索引是否有 必要。




  
  
  