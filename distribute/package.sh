#!/bin/bash

mkdir -p src

# Depedencies
cp -R  ../lib/java* lib/

# Soby source 
cp -R  ../lib/soby.rb src/
cp -R  ../lib/soby src/

# Binary
cp ../bin/soby-bin src/

