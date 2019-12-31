---
title: 服务器配置免密登录
date: 2019.12.31
tags: 
  - Linux 
  - 服务器
  
description: 服务器通过配置秘钥对达到免密登录效果
---

#### 1.生成密钥对

      ssh-keygen

输入完代码后，会提示你输入密码啥的，既然是免密我们就不设置密码 一直按回车就好

运行结束以后， 默认在 ~/.ssh目录生成两个文件： 
    id_rsa ：私钥 
    id_rsa.pub ：公钥
    
#### 2.导入公钥到认证文件,更改权限

- 本地机器

      cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys  

      cd  ~/.ssh

      scp id_rsa.pub root@${服务器ip}:~

- 服务器
    
      cat ~/id_rsa.pub >> ~/.ssh/authorized_keys 
    
    //在服务器上更改权限(必须)
     
      chmod 755 ~

      chmod 700 ~/.ssh

      chmod 600 ~/.ssh/authorized_keys  
    
#### 3.常见问题及解决方案

- 生成密钥并上传至远程主机后，任然不可用 

      打开服务器的 /etc/ssh/sshd_config 这个文件，取消注释。

      #AuthorizedKeysFile .ssh/authorized_keys
    
- 重启服务器的ssh服务。

      #RHEL/CentOS系统

      service sshd restart

      #ubuntu系统

      service ssh restart

      #debian系统

      /etc/init.d/ssh restart
    
    
这些都设置完成，试下能不能进行无密登录吧
