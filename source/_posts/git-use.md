---
title:  git 创建分支，切换分支，合并分支，删除本地分支，删除远程分支
date: 2019.07.02
tags: 
  - Git 

description: 工作中git使用到的一些常用命令
---

- 创建一个新分支并选择创建好的分支

```
git checkout -b dev
Switched to a new branch "dev"
//查看本地分支
git branch 
//把本地的分支推动到远程仓库
git status 

git add .

git commit -m 'add branch dev'

git push --set-upstream origin dev

```
这个时候在你的git仓库就可以看到我们刚才新建的dev分支啦
![这里写图片描述](https://img-blog.csdn.net/20180511172751375?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MDgyMzA0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 本地切换分支（切换之前必须把当前分支的代码进行push操作）

```
//切换到dev分支
git checkout dev

// 切换到master分支
git checkout master
```
![这里写图片描述](https://img-blog.csdn.net/20180511173341817?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MDgyMzA0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 合并分支(在合并之前必须把该分支代码push到git仓库上)
```
git merge dev
```
- 删除本地dev分支
```
git branch -d dev

```
![这里写图片描述](https://img-blog.csdn.net/2018051117381871?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MDgyMzA0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
- 删除远程dev分支
```
git push -d origin dev
```
![这里写图片描述](https://img-blog.csdn.net/20180511173938852?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MDgyMzA0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

删除本地分支

	git branch -d dev


### 打tag

1：打 tag 标签(在commit 之后，push之前，去添加tag)

	git tag -a v1.0 -m “commit version 1.0”

加上 -f 覆盖原有的tag 

	git tag -f v1.0

2：push 到远程仓库（打完tag之后，去push即可）

push所有tag到远程仓库：

	git push origin –tags (注意tags前是两个短横杠)
	
	push单个tag到远程仓库：git push origin [tagname]
	
3：删除 tag 便签

	git tag -d v1.0

4：查看 tag 标签

	git tag

5：切换标签

	git checkout v1.0

### 远程仓库操作：
1：从远程仓库上删除 tag 

	git push origin :refs/tags/v1.0