#!/bin/sh

WEBSERVICES=./webservices/*
ESPCOMMON=./esp-common/*
LUA=./*.lua
RESOURCES=./index.html

for file in $WEBSERVICES
do
	./sendfile.py $1 $file
done

for file in $ESPCOMMON
do
        ./sendfile.py $1 $file
done

for file in $LUA
do
        ./sendfile.py $1 $file
done

for file in $RESOURCES
do
        ./sendfile.py $1 $file
done
