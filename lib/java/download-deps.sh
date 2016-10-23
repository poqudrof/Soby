#!/bin/bash

mkdir tmp
cd tmp 

## download SVGExtended
wget https://github.com/poqudrof/SVGExtended/releases/download/v1.0/SVGExtended.tgz
tar -xf SVGExtended.tgz

## Download Processing Video
wget https://github.com/processing/processing-video/releases/download/latest/video.zip
unzip video.zip

## Download toxiclibscore
wget https://bitbucket.org/postspectacular/toxiclibs/downloads/toxiclibs-complete-0020.zip
unzip toxiclibs-complete-0020.zip

for i in $( ls ); do
    if [[ -d $i ]]; then
	echo dir: $i
	cp -R $i/library/* ..
    fi
done
