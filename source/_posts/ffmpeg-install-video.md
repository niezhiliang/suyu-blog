---
title: Linux系统静态安装FFmpeg 并使用Jave开源框架进行视频压缩
date: 2019.12.31
tags: 
  - Java 
  - FFmpeg
  
description: ffmpeg静态安装 超级简单的安装，还有视频压缩过程中踩的坑
---

### Ffmpeg安装

```shell script
#x86下载二进制文件
wget https://www.moerats.com/usr/down/ffmpeg/ffmpeg-git-32bit-static.tar.xz
#x86_64下载二进制文件
wget https://www.moerats.com/usr/down/ffmpeg/ffmpeg-git-64bit-static.tar.xz

#解压文件
tar xvf ffmpeg-git-*-static.tar.xz && rm -rf ffmpeg-git-*-static.tar.xz

#将ffmpeg和ffprobe可执行文件移至/usr/bin方便系统直接调用
mv ffmpeg-git-*/ffmpeg  ffmpeg-git-*/ffprobe /usr/bin/

#查看版本
ffmpeg
ffprobe
```
#### 测试转换

> 在网上找了很多的安装方式，安装完以后执行普通的命令都没问题，执行复杂一点的命令就会报异常，后面查询资料知道可以通过
>静态方式来安装，后面找到个静态安装的博客，我就把他的安装方式搬过来了，确实 静态安装太简单，还不报错。

- 简单命令，就是讲一个mp4格式的视频转换为avi格式
```shell script
ffmpeg -i test.mp4 test.avi
```

- 复杂命令，具体每个命令啥意思 自行百度吧

```shell script
ffmpeg -i test.mp4 -vcodec flv -b 40000 -r 15 -s 300x600 -acodec libmp3lame -ab 164000 -ac 1 -ar 22050 -f flv -y test.flv
```
按照普通的方式安装的ffmpeg,会报一个异常信息`unknown encoder 'libmp3lame'`,意思就是没有这个解码格式还是啥，反正就是FFmpeg的
安装没有配置好。

### Jave框架的压缩代码
```java
        File source = new File("/Users/fxq/Desktop/test2.avi");
        File target = new File("/Users/fxq/Desktop/test.flv");
        AudioAttributes audio = new AudioAttributes();
        audio.setCodec("libmp3lame");
        audio.setBitRate(new Integer(64000));
        audio.setChannels(new Integer(1));
        audio.setSamplingRate(new Integer(22050));
        VideoAttributes video = new VideoAttributes();
        video.setCodec("flv");
        video.setBitRate(new Integer(160000));
        video.setFrameRate(new Integer(15));
        video.setSize(new VideoSize(300, 600));
        EncodingAttributes attrs = new EncodingAttributes();
        attrs.setFormat("flv");
        attrs.setAudioAttributes(audio);
        attrs.setVideoAttributes(video);
        Encoder encoder = new Encoder();
        encoder.encode(source, target, attrs);
```

执行官网的代码报下面这个异常
```java
15:34:16.721 [main] INFO it.sauronsoftware.jave.DefaultFFMPEGLocator - ffmpeg.home does not exists, use default bin path: 
/var/folders/0q/t9dryqfs5p10rn55f86p1wcw0000gn/T/jave-1
15:34:16.820 [main] INFO it.sauronsoftware.jave.FFMPEGExecutor - exec cmd: [/var/folders/0q/t9dryqfs5p10rn55f86p1wcw0000gn/T/jave-1/ffmpeg-mac, -i, /Users/fxq/Desktop/test2.avi,
 -vcodec, flv, -b, 160000, -r, 15, -s, 300x600, -acodec, libmp3lame, -ab, 64000, -ac, 1, -ar, 22050, -f, flv, -y, /Users/fxq/Desktop/test.flv]
Exception in thread "main" it.sauronsoftware.jave.EncoderException:     Metadata:
	at it.sauronsoftware.jave.Encoder.processErrorOutput(Encoder.java:872)
	at it.sauronsoftware.jave.Encoder.encode(Encoder.java:834)
	at it.sauronsoftware.jave.Encoder.encode(Encoder.java:712)
```


从上面可以看出，`Jave`该框架给我们生成了转换的命令，我首先拿这个命令去本地执行，发现命令没问题，能正常压缩文件，那肯定是出现在压缩后面的代码，我就断点一句一句代码去找，看下到底是哪里出错了。
后面发现执行命令后，该框架还会对日志进行检查，判断执行是否成功等。
![image.png](https://upload-images.jianshu.io/upload_images/14511933-fd4122c6924bbffd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

参考了部分博客后，发现既然是在校验日志的时候发生异常的，那我就不让它去做校验不就好了嘛。就自己写了一个类继承`Encoder.java`类，重写校验日志的方法就好啦。就顺利解决了这个问题。

```java
public class MyEncoder extends Encoder {

    public MyEncoder(FFMPEGLocator locator) {
        super(locator);
    }

    @Override
    protected void processErrorOutput(EncodingAttributes attributes, BufferedReader errorReader, File source, EncoderProgressListener listener) throws EncoderException, IOException {
        //屏蔽错误处理
        try {
            String line;
            while ((line = errorReader.readLine()) != null) {
                System.out.println(line);
            }
        }
        catch (Exception exp) {
            System.out.println("file convert error message process failed. "+exp);
        }
    }
}
```

然后使用我们自己的类，来对视频进行压缩，这个问题就顺利解决掉啦

```java
        File source = new File("/Users/fxq/Desktop/test2.avi");
        File target = new File("/Users/fxq/Desktop/test.flv");
        AudioAttributes audio = new AudioAttributes();
        audio.setCodec("libmp3lame");
        audio.setBitRate(new Integer(64000));
        audio.setChannels(new Integer(1));
        audio.setSamplingRate(new Integer(22050));
        VideoAttributes video = new VideoAttributes();
        video.setCodec("flv");
        video.setBitRate(new Integer(160000));
        video.setFrameRate(new Integer(15));
        video.setSize(new VideoSize(300, 600));
        EncodingAttributes attrs = new EncodingAttributes();
        attrs.setFormat("flv");
        attrs.setAudioAttributes(audio);
        attrs.setVideoAttributes(video);
        //这个构造方法是怕找不到ffmpeg路径，可以不传参数的
        Encoder encoder = new MyEncoder(new MyFFMPEGExecute());
        encoder.encode(source, target, attrs);

```

#### 参考资料：

[静态安装FFmpeg：https://www.moerats.com/archives/719/](https://www.moerats.com/archives/719/)

[Jave官网：https://www.sauronsoftware.it/projects/jave/](https://www.sauronsoftware.it/projects/jave/)













