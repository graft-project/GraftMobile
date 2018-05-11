#!/bin/bash
a=0
for i in MAJOR_VERSION MINOR_VERSION BUILD_VERSION
do
v1[$a]=`grep -E "(^| )$i( |=|$)" GraftMobileClient.pro |sed 's/#.*//' | grep -o '[0-9]*'`
v1[$a]=`echo ${v1[$a]} | awk '{print $NF}'`
a=$a+1
done
B_VERSION="${v1[0]}.${v1[1]}.${v1[2]}"
echo $B_VERSION > version.txt
echo $B_VERSION
