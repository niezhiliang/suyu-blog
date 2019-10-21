#!/bin/bash

git status

git add .

git commit -m 'm'

git push


cd blog-temp

scp *.md root@www.isuyu.cn:/usr/local/suyu-blog/source/_posts

git pull


cd blog-temp

rm -f -r *.md


echo 'puslish success...





