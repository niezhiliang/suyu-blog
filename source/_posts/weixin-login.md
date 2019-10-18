---
title: 微信第三方登录前后端分离实现思路
date: 2019.09.24
tags: 
  - 微信
  - Java 
  - Vue
description: 前后端分离项目微信登录的思想，基于spring-boot-websocket实现
---
## 微信第三方登录前后端分离实现思路

### 前端实现

> 这里说一下前后端的思路，页面加载时声明一个变量`state`='时间戳+6位随机数', 前端路径生成二维码，
其中有个`state`参数需要我们传递，这个参数你传什么，微信回调的时候就会给你返回什么。
我们用之前生成那个state，当用户点击微信登录的按钮，我们就通过以state值为key和后端进行websocket连接，同时弹出二维码页面。
state对前端来说就相当于一个令牌，告诉后端是谁在使用微信登录。目的在于，当后台收到回调的时候，能准确的把数据返回当前扫码的用户，
后台在微信回调的时候能拿到`code`的值和`state`的值，通过`code`去拿`access_token`和`openid` ，
通过这两个值去请求微信用户最新信息，
后端定义好返回的状态值代表啥，无非两种状态码：1.已经绑定:取出`user`信息，
通过websocket返回给前端，2.没绑定:返回微信账户的openid和头像昵称。
前端收到后端发送的websocket信息，判断微信绑定状态，如果绑定路由跳转到登录完成页面，如果未绑定，跳转到绑定或注册页面。

<!-- more -->

##### 第一步

前端先设置好生成二维码的路径，
```javascript
this.url =
      "https://open.weixin.qq.com/connect/qrconnect?appid=" +
      this.appid +
      "&redirect_uri=" +
      this.redirect_uri +
      "&response_type=code&scope=snsapi_login&state=" +
      this.state +
      "#wechat_redirect";

```

#### 参数解释（这里直解释需要修改的参数）

| 参数名 |备注 |
|-----|------|
| appid | 这个就是申请微信登录应用的appid |
| redirect_uri | 微信的回调地址，记得这里要url转码 |
| state | 这个是微信给我们自己传递的参数，不管你传的是啥，都会在回调中给你返回回来 |

---
##### 第二步

用户点击微信登录页面，和后端进行websocket连接，连接的key就是我们生产二维码连接中的`state`

```javascript
 let wsname = "ws://www.niezhiliang.com:8086/socketServer/" + this.state;
      this.ws = new WebSocket(wsname);
      //连接成功触发
      this.ws.onopen = function(evt) {
      };
      //这个是接收后台发送信息的方法
      this.ws.onmessage = function(evt) {
        var data = JSON.parse(evt.data);
        console.log(data)
       //在这里判断后台给的状态是1还是2  并进行相应的操作
      })

```
然后再弹出二维码页面(居中显示)
```javascript
//this.url=我们在页面加载的时候拼接好的
WxLogin() {
      this.itop = (window.screen.availHeight - 500) / 2;
      //获得窗口的水平位置
      this.ileft = (window.screen.availWidth - 400) / 2;
      this.w = window.open(
        this.url,
        "newwindow",
        "height=500, width=400, top=" +
          this.itop +
          ", left = " +
          this.ileft +
          ", toolbar=no, menubar=no,scrollbars=no, resizable=no,location=no, status=no"
      );
    }
```

### 后端Java实现(websocket就不解释啦，如果不懂可以去看我的另一个项目)
 <https://github.com/niezhiliang/springbootwebsocket>

##### 第一步
这边是websocket的代码

- 配置websocket连接服务

```java
@ServerEndpoint(value = "/socketServer/{userName}")
@Component
public class SocketServer {

	private static final Logger logger = LoggerFactory.getLogger(SocketServer.class);

	/**
	 *
	 * 用线程安全的CopyOnWriteArraySet来存放客户端连接的信息
	 */
	private static CopyOnWriteArraySet<Client> socketServers = new CopyOnWriteArraySet<>();

	/**
	 *
	 * websocket封装的session,信息推送，就是通过它来信息推送
	 */
	private Session session;

	/**
	 *
	 * 服务端的userName,因为用的是set，每个客户端的username必须不一样，否则会被覆盖。
	 * 要想完成ui界面聊天的功能，服务端也需要作为客户端来接收后台推送用户发送的信息
	 */
	private final static String SYS_USERNAME = "niezhiliang9595";


	/**
	 *
	 * 用户连接时触发，我们将其添加到
	 * 保存客户端连接信息的socketServers中
	 *
	 * @param session
	 * @param userName
	 */
	@OnOpen
	public void open(Session session,@PathParam(value="userName")String userName){

			this.session = session;
			socketServers.add(new Client(userName,session));

			logger.info("客户端:【{}】连接成功",userName);

	}

	/**
	 *
	 * 收到客户端发送信息时触发
	 * 我们将其推送给客户端(niezhiliang9595)
	 * 其实也就是服务端本身，为了达到前端聊天效果才这么做的
	 *
	 * @param message
	 */
	@OnMessage
	public void onMessage(String message){

		Client client = socketServers.stream().filter( cli -> cli.getSession() == session)
				.collect(Collectors.toList()).get(0);
		sendMessage(client.getUserName()+"<--"+message,SYS_USERNAME);

		logger.info("客户端:【{}】发送信息:{}",client.getUserName(),message);
	}

	/**
	 *
	 * 连接关闭触发，通过sessionId来移除
	 * socketServers中客户端连接信息
	 */
	@OnClose
	public void onClose(){
		socketServers.forEach(client ->{
			if (client.getSession().getId().equals(session.getId())) {

				logger.info("客户端:【{}】断开连接",client.getUserName());
				socketServers.remove(client);

			}
		});
	}

	/**
	 *
	 * 发生错误时触发
	 * @param error
	 */
    @OnError
    public void onError(Throwable error) {
		socketServers.forEach(client ->{
			if (client.getSession().getId().equals(session.getId())) {
				socketServers.remove(client);
				logger.error("客户端:【{}】发生异常",client.getUserName());
				error.printStackTrace();
			}
		});
    }

	/**
	 *
	 * 信息发送的方法，通过客户端的userName
	 * 拿到其对应的session，调用信息推送的方法
	 * @param message
	 * @param userName
	 */
	public synchronized static void sendMessage(String message,String userName) {

		socketServers.forEach(client ->{
			if (userName.equals(client.getUserName())) {
				try {
					client.getSession().getBasicRemote().sendText(message);

					logger.info("服务端推送给客户端 :【{}】",client.getUserName(),message);

				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 *
	 * 获取服务端当前客户端的连接数量，
	 * 因为服务端本身也作为客户端接受信息，
	 * 所以连接总数还要减去服务端
	 * 本身的一个连接数
	 *
	 * 这里运用三元运算符是因为客户端第一次在加载的时候
	 * 客户端本身也没有进行连接，-1 就会出现总数为-1的情况，
	 * 这里主要就是为了避免出现连接数为-1的情况
	 *
	 * @return
	 */
	public synchronized static int getOnlineNum(){
		return socketServers.stream().filter(client -> !client.getUserName().equals(SYS_USERNAME))
				.collect(Collectors.toList()).size();
	}

	/**
	 *
	 * 信息群发，我们要排除服务端自己不接收到推送信息
	 * 所以我们在发送的时候将服务端排除掉
	 * @param message
	 */
	public synchronized static void sendAll(String message) {
		//群发，不能发送给服务端自己
		socketServers.stream().filter(cli -> cli.getUserName() != SYS_USERNAME)
				.forEach(client -> {
			try {
				client.getSession().getBasicRemote().sendText(message);
			} catch (IOException e) {
				e.printStackTrace();
			}
		});

		logger.info("服务端推送给所有客户端 :【{}】",message);
	}
```


- 提供给前端发送信息的api
```java
    @RequestMapping(value = "/sendpost")
    public String sendPost(@RequestBody Params params) {
        if (params.getJson() == null || params.getUserid() == null) {
            return "error";
        }
        logger.info(params.getJson()+"-----------"+params.getUserid());
        SocketServer.sendMessage(params.getJson(),params.getUserid());
        return "success";
    }
```

---
##### 第二步
这边是微信回调代码
```java
 /**
     * 微信扫码回调
     * @return
     */
    @RequestMapping(value = "/callback")
    public void callBack(Device device) {
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        RespInfo respInfo = new RespInfo();
        respInfo.setStatus(InfoCode.ERROR);
        if (code != null) {
            StringBuffer url = new StringBuffer();
            /*********获取token************/
            url.append(request_url)
                    .append("appid=")
                    .append(appid)
                    .append("&secret=")
                    .append(secret)
                    .append("&code=")
                    .append(code)
                    .append("&grant_type=")
                    .append(grant_type);
            logger.info(url.toString());
			 //调用微信查询用户基本信息的api方法
            JSONObject jsonObject =
                    JSON.parseObject(HttpUtil.getResult(url.toString()));
            //拿到openid和请求微信api使用的token
            String openid =jsonObject.get("openid").toString();
            String token = jsonObject.get("access_token").toString();

            /*********获取userinfo************/
            url = new StringBuffer();
            url.append(userinfo_url)
                    .append("access_token=")
                    .append(token)
                    .append("&openid=")
                    .append(openid);
            logger.info(url.toString());
            //通过上面拿到的token和openid获取用户的基本信息
            String result = HttpUtil.getResult(url.toString());
            WeixinInfo weixinInfo = JSON.parseObject(result,WeixinInfo.class);
            if (weixinInfo != null) {
               //这个方法是为了去除微信昵称的特殊符号，为了避免保存数据库操作报异常我把所有的昵称表情都替换成了*
                weixinInfo.setNickname(filterEmoji(weixinInfo.getNickname()));
                //插入数据库操作
                weiXinService.insertOrUpdateSelective(weixinInfo);
            }
            //通过openid去找用户是否绑定
            User user = userService.getByOpenId(openid);
            if (user == null) {//说明该微信未绑定任何账号
                respInfo.setStatus(InfoCode.INVALID_TOKEN);
                respInfo.setMessage("请先注册再进行微信绑登录操作");
                Map<String,Object> map = new HashMap<String,Object>();
                map.put("openid",openid);
                map.put("headimgurl",weixinInfo.getHeadimgurl());
                map.put("nickname",weixinInfo.getNickname());
                respInfo.setContent(map);
            } else {//这里是表示该微信已经绑定了用户账号，直接返回用户登录信息就好
                respInfo.setStatus(InfoCode.SUCCESS);
                respInfo.setContent(user);
            }
        }
        String json = JSON.toJSONString(respInfo);
        /************websocket将数据响应给前端**************/
        Map map = new HashMap();
        map.put("userid",state);
        map.put("json",json);
        String params = JSON.toJSONString(map);
        try {
            //这里是将结果通过websocket返回给前端 
            System.out.println(HttpUtil.
	    doPost(“http://www.niezhiliang.com:8086/websocket/sendpost”,params));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
```