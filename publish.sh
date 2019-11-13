#!/bin/bash

cd blog-temp

scp *.md root@www.isuyu.cn:/usr/local/suyu-blog/source/_posts

git pull

cd blog-temp

mv *.md ../source/_posts

sleep 2

cd ..

git status

git add .

sleep 1

git commit -m 'm'

sleep 1

git push

rm -f -r *.md


echo 'puslish success...'





