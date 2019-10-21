#!/bin/bash

cd blog-temp

scp *.md root@www.isuyu.cn:/usr/local/suyu-blog/source/_posts

git pull

cd blog-temp

mv *.md ../source/_posts


git status

git add .

git commit -m 'm'

git push

rm -f -r *.md


echo 'puslish success...





