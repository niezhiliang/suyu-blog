---
title:  springboot 整合rabbitmq消费时Channel shutdown: channel error
date: 2019.11.13
tags: 
  - SpringBoot
  - Java 
  - RabbitMQ
  - 工作问题
  
description: 
---

### 异常信息

```java
2019-11-13 14:07:18.431  INFO 10702 --- [ 127.0.0.1:5672] c.f.o.a.l.rabbitmq.publisher.TestSender  : 信息投递成功，messageId:39f52873-37ca-49b1-9054-b71bf7cf26c8
----收到消息，开始消费-----
d订单id：39f52873-37ca-49b1-9054-b71bf7cf26c8
--------消费完成--------
2019-11-13 14:07:18.438 ERROR 10702 --- [ 127.0.0.1:5672] o.s.a.r.c.CachingConnectionFactory       : Channel shutdown: channel error; protocol method: #method<channel.close>(reply-code=406, reply-text=PRECONDITION_FAILED - unknown delivery tag 1, class-id=60, method-id=80)
```
<!-- more -->

### 代码
这个就是今天在引入spring-boot-amqp的时候，测试消息投递和消费信息的时候报了上面这个异常，下面贴出rabbitmq中信息投递端和消费端的代码

- 信息投递端
```java
@Component
@Slf4j
public class CallBackSender {

    @Autowired
    private RabbitTemplate rabbitTemplate;


    final RabbitTemplate.ConfirmCallback confirmCallback = new RabbitTemplate.ConfirmCallback() {

        /**
         *
         * @param correlationData 唯一标识，有了这个唯一标识，我们就知道可以确认（失败）哪一条消息了
         * @param ack  是否投递成功
         * @param cause 失败原因
         */
        @Override
        public void confirm(CorrelationData correlationData, boolean ack, String cause) {
            String messageId = correlationData.getId();
            //返回成功，表示消息被正常投递
            if (ack) {

                log.info("信息投递成功，messageId:{}",messageId);

            } else {
                log.error("消费信息失败，messageId:{} 原因:{}",messageId,cause);
            }
        }
    };

    /**
     * 信息投递的方法
     * @param pageDTO
     */
    public void send(CallBackPageDTO pageDTO) {
        //设置投递回调
        rabbitTemplate.setConfirmCallback(confirmCallback);
        CorrelationData correlationData = new CorrelationData();
        correlationData.setId(pageDTO.getMessageId());

        rabbitTemplate.convertAndSend("liveness-exchange",
                "liveness.callback",
                pageDTO,
                correlationData);
    }
}
```

- 信息消费端
```java
@Component
@Slf4j
public class CallBackReceiver {

    /**
     * 监听回调页面
     * @param backPageDTO
     * @param headers
     * @param channel
     */
    @RabbitListener(
            bindings = @QueueBinding(                    //数据是否持久化
                    value = @Queue(value = "liveness-queue",durable = "true"),
                    exchange = @Exchange(name = "liveness-exchange",
                            durable = "true",type = "topic"),
                    key="liveness.callback"
            )
    )
    @RabbitHandler
    public void onTest(@Payload CallBackPageDTO backPageDTO, @Headers Map<String,Object> headers, Channel channel) throws IOException {
        System.out.println("----收到消息，开始消费-----");
        Long deliveryTag = (Long) headers.get(AmqpHeaders.DELIVERY_TAG);

        Response response = null;
        String result = null;
        try {
            response = OkHttp.Post(backPageDTO.getNotifyUrl(), JSON.toJSONString(backPageDTO));
            result = response.body().string();
        } catch (Exception e) {
            result = e.getMessage();
            log.error("回调发生异常：{},访问地址：{}",e.getMessage(),backPageDTO.getNotifyUrl());
        } finally {

        }
        /**
         *  取值为 false 时，表示通知 RabbitMQ 当前消息被确认
         *  如果为 true，则额外将比第一个参数指定的 delivery tag 小的消息一并确认
         */
        channel.basicAck(deliveryTag,false);
        System.out.println("--------消费完成--------");
    }
}
```

### 解决办法

从信息投递代码来看，有一个回调`confirm()`方法，里面的代码是我们手动去签收信息的消费情况，而spring-boot-starter-amqp默认是自动签收信息的方式，
我查资料看到一个说发生这种情况是 `double ack问题` 我也似懂非的，大概意思就是消费结果签收了两次，我们代码里面是写的手动签收，但是系统还有一次自动
签收，所以就想到了是不是需要配置一下让rabbitmq手动签署，就不会触发自动签收的功能勒

于是我就将rabbitmq配置文件配置成了手动签收，再去测试的时候就不会报这个异常信息啦

```yaml
spring:
  rabbitmq:
    addresses: 127.0.0.1:5672
    username: springcloud
    password: 123456
    #虚拟主机地址
    virtual-host: /
    #连接超时时间
    connection-timeout: 15000
    publisher-confirms: true
    publisher-returns: true
    template:
      mandatory: true
    #消费端配置
    listener:
      simple:
        #消费端
        concurrency: 5
        #最大消费端数
        max-concurrency: 10
        #自动签收auto  手动 manual
        acknowledge-mode: manual
        #限流（海量数据，同时只能过来一条）
        prefetch: 1
```



