##### 1. String类能被继承吗，为什么

不能，因为String是final关键字修饰的类

#####  2.String，Stringbuffer，StringBuilder的区别？

String是不可变字符序列，Stringbuffer和StringBuilder是可变的字符序列，Stringbuffer是线程安全的StringBuilder

##### 3.ArrayList和LinkedList有什么区别

ArrayList是基于动态数组的数据结构，LinkedList是基于链表结构，ArrayList的查询速度优于LinkedList，对于
插入和删除速度LinkedList优于ArrayList。LinkedList比ArrayList更占内存，因为LinkedList的节点除了存储数据，还
存储了两个引用，一个指向前一个元素，一个指向后一个元素。

##### 4.类的实例化顺序，比如父类静态数据，构造函数，字段，子类静态数据，构造函数，字段，他们的执行顺序

父类静态数据 -> 子类静态变量 -> 父类字段 -> 父类构造函数 -> 子类字段 ->子类构造函数

##### 5.用过哪些Map，都有什么区别，HashMap是线程安全的吗,并发下使用的Map是什么，他们内部原理分别是什么，比如hashcode，扩容等

HashMap,HashTable,HashTable是线程安全的HashMap，并发下使用HashTable,内部原理是基于hash来获hashcode,调用时使用对象的hashcode方法，
拿到hashcode获取到键值对放置的bucket，判断该bucket下是否有值，如果没有，则以数组形式保存该值，如果有通过equcal方法判断值是否相等，如果相等
将该键值对放在链表的下一个节点，如果节点长度大于8则转为红黑树存储。HashMap的初始容量为16，默认的扩容因子为0.75，如果容器内的元素数量大于设置的容量 x 扩容因子
 则会进行扩容操作，扩容后的大小为 原容量的两倍。此操作还会伴随rehash()操作。

##### 6.HashMap为什么get和set那么快，concurrentHashMap为什么能提高并发
以为HashMap存取数据是对key进行了算出hashcode方法，将其放在数组特定的位置，所以能很快的就存值和取值。 `concurrentHashMap`用分离锁实现多个线程间的更深层次的共享访问
减小了请求 同一个锁的频率。
##### 7.抽象类和接口的区别，类可以继承多个类么，接口可以继承多个接口么,类可以实现多个接口么

1.抽象类和接口都不能被实例化，如果要实例化，必须通过子类来实现，子类如果不是抽象类必须实现该实现类的所有抽象方法，
接口要实现实例化，必须通过类来实现接口。
2.接口只能做方法的声明，抽象类可以做方法的声明，也可以做方法的实现
3.接口里定义的变量只能是公共非静态的常量，抽象类中的变量是普通的变量。
4.抽象类可以没有抽象方法
5.接口可以继承接口，并可以多继承接口，但是类只能单继承，但是类可以多实现

##### 8.什么情况下会发生栈内存溢出
栈是线程私有的，生命周期与线程相同，每个方法在执行的时候都会创建一个栈帧，用来存储局部变量表，操作数栈
，动态链接，方法出口信息。栈溢出实质上就是栈帧超过了栈的深度。最有可能产生栈内存溢出就是递归方法的调用，
我们可以通过`-Xss`去调整JVM栈的大小。

##### 9.NIO和IO到底有什么区别，NIO原理
1.nio是以块的方式处理数据，但是io是以最基础的字节流的形式去写入和读出。所以在效率上noi比io高出了很多。
2.nio不是和io一样用OutputStream和InputStream 输入流的形式来进行数据处理的，但又是基于这种流的形式，而是采用了通道和缓冲区的形式来进行数据处理。
3.nio的通道可以使双向的，io中的流只能是单向的。
4.nio采用多路复用的io模型，普通的io用的是阻塞的io模型。

nio实质上就是利用缓冲区来进行传输字节。


##### 10.反射中，Class.forName和ClassLoader区别
class.forName()除了将类的.class文件加载到jvm中之外，还会对类进行解释，执行类中的static块，还会执行给静态变量赋值的静态方法
classLoader只干一件事情，就是将.class文件加载到jvm中，不会执行static中的内容,只有在newInstance才会去执行static块

##### 11.tomcat结构，类加载器流程

##### 12.讲讲Spring事务的传播属性,AOP原理，动态代理与cglib实现的区别，AOP有哪几种实现方式
![image.png](https://upload-images.jianshu.io/upload_images/14511933-5eab5a5e245619d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

动态代理只能为接口创建动态代理实例，而不能对类创建动态代理。需要获得被目标类的接口信息（应用Java的反射技术），生成一个实现了代理接口的动态代理类(字节码)
，再通过反射机制获得动态代理的构造函数，利用构造函数生成导尿管太代理类的实例对象，在调用具体方法钱调用invokeHandler方法来处理。CGlib动态代理
需要依赖sam包，把被代理对象类的class文件加载进来，修改其字节码生成子类。

##### 13.Spring的beanFactory和factoryBean的区别

BeanFactory是个Factory，也就是IOC容器或对象工厂，FactoryBean是个Bean。在Spring中，所有的Bean都是由BeanFactory(也就是IOC容器)来进行管理的。
但对FactoryBean而言，这个Bean不是简单的Bean，而是一个能生产或者修饰对象生成的工厂Bean,它的实现与设计模式中的工厂模式和修饰器模式类似

##### 14.Spring加载流程
![image.png](https://upload-images.jianshu.io/upload_images/14511933-ec56afc99ff119e4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



##### 15.Spring如何管理事务的
事务管理主要包括三个接口共同完成的，
1.PlatformTransactionManager(事务管理器),主要有三个方法  commit(事务提交),rollback(事务回滚),getTransaction(获取事务状态)
2.TransactionDefinition(事务定义信息) 主要有四个方法 getIsolationLevel(获取隔离级别) getPropagationBehavior(获取传播行为) getTimeout(获取超时时间),isReadOnly(是否只读) 
3.TransactionStatus(事务具体运行状态) hasSavepoint(返回事务内部是否包含一个保存点) isCompleted(事务是否已经完成) isNewTransaction(是否是一个新事物)

1.tomcat如何调优，各种参数的意义
maxThreads(设置Tomcat最大的并发数，默认为150)
minSpareThreads(Tomcat初始化创建的线程数，默认为25)
acceptCount(同时连接人数达到maxThreads还可接收排队的连接数量)

2.常见的缓存策略有哪些，你们项目中用到了什么缓存系统，如何设计的，Redis的使用要注意什么，持久化方式，内存设置，集群，淘汰策略等

3.如何防止缓存雪崩
缓存在同一时间内大量键过期（失效），接着来的一大波请求瞬间都落在了数据库中导致连接异常,
1.设置缓存超时时间的时候加上一个随机的时间长度，比如这个缓存key的超时时间是固定的5分钟加上随机的2分钟。
2.建立备份缓存，缓存A和缓存B，A设置超时时间，B不设值超时时间，先从A读缓存，A没有读B，并且更新A缓存和B缓存;


4.用java自己实现一个LRU

5.分布式集群下如何做到唯一序列号
1.UUID 2. Redis INCR生成ID 3.数据库增长 4.雪花算法

6.设计一个秒杀系统，30分钟没付款就自动关闭交易

7.如何做一个分布式锁
Redis中有个函数setnx,通过redis.setnx(key,value)调用该函数的时候，如果该key已经存在redis中， 则该命令会执行失败，返回结果0，
如果不存在，则会将该key=value保存到redis中，并返回1，我们正好通过这一特性来 实现分布式锁，线程在执行某段代之前去获取锁，
如果获取失败表示，该代码已经有别的线程正在执行，当拿到锁的线程在执行完 代码之后，判断当前锁是否属于自己，如果是则删掉redis中的值，
把锁让出来，让其他线程能够拿到锁

8.用过哪些MQ，怎么用的，和其他mq比较有什么优缺点，MQ的连接是线程安全的吗

9.MQ系统的数据如何保证不丢失
如果是



10.分布式事务的原理，如何使用分布式事务

11.什么是一致性hash

13.如何设计建立和保持100w的长连接？

14.解释什么是MESI协议(缓存一致性)

15.说说你知道的几种HASH算法，简单的也可以

16.什么是paxos算法

17.redis和memcached 的内存管理的区别

Memcached基本只支持简单的key-value存储，不支持枚举，不支持持久化和复制等功能
Redis除key/value之外，还支持list,set,sorted set,hash等众多数据结构，提供了KEYS

