#!/bin/bash

INSTALL_ROOT=$HOME/Java

mkdir -p $INSTALL_ROOT

pushd $INSTALL_ROOT
  curl -L -b "oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin -O
  chmod u+x jdk-6u45-linux-x64.bin
  ./jdk-6u45-linux-x64.bin
  rm jdk-6u45-linux-x64.bin
  for version in 7u75-b13 8u40-b26; do
      curl -L -b "oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/$version/jdk-`echo $version | cut -d \- -f 1`-linux-x64.tar.gz -O
      tar xvf jdk-`echo $version | cut -d \- -f 1`-linux-x64.tar.gz
      rm jdk-`echo $version | cut -d \- -f 1`-linux-x64.tar.gz
  done
popd

METAPATH='$PATH'
for path in $(ls $INSTALL_ROOT | sort -r); do
  METAPATH=$INSTALL_ROOT/$path/bin:$METAPATH
done

echo Add the following line to the end of your .bashrc:
echo PATH=$METAPATH

