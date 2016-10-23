#!/bin/bash

mkdir -p tmp
mkdir -p lib/java
mkdir -p src

cd tmp

echo "Download and extract propane"
gem fetch propane
gem unpack propane*.gem

cd propane*

echo "Copy the source code" 
cp -R lib/propane.rb ../../src/
cp -R lib/propane ../../src/propane

echo "Copy the jars"
cp -R lib/*.jar ../../lib/java/

echo "Cleaning"
cd ../..
rm -rf tmp
