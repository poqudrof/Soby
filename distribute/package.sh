#!/bin/bash


mkdir -p src

# Depedencies
cp -R  ../lib/java* lib/

# Soby source 
cp -R  ../lib/soby.rb src/
cp -R  ../lib/soby src/

rm lib/java/*.sh
rm lib/java/*.txt
rm -rf lib/java/tmp

# Binary
cp ../bin/soby-bin.rb src/


# # Rawr
# rawr install

# # build jar
rake rawr:jar
# # build exe
rake rawr:bundle:exe
# # build app
rake rawr:bundle:app

zip -r soby-windows.zip package/windows
zip -r soby-osx.zip package/osx
tar -cvf soby.tar package/jar 
