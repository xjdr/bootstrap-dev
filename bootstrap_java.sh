#!/bin/bash

INSTALL_ROOT=/opt/java

if [[ ! -d $INSTALL_ROOT ]]
then
  sudo mkdir -p $INSTALL_ROOT
fi

sudo chown $(whoami): $INSTALL_ROOT

pushd $INSTALL_ROOT
  for version in 7u75-b13 8u40-b26; do
      java_pkg=jdk-`echo $version | cut -d \- -f 1`-linux-x64.tar.gz
      if [[ ! -e $java_pkg ]]
      then
        curl -L -b "oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/$version/jdk-`echo $version | cut -d \- -f 1`-linux-x64.tar.gz -O
        rc=$?
        if [[ $rc != 0 ]]
        then
          exit
        fi
        if [[ -e $java_pkg ]]
        then
          tar xvf $java_pkg
          rm $java_pkg
        else
          exit
        fi
      fi
  done
popd

METAPATH='$PATH'
for path in $(ls $INSTALL_ROOT | sort -r); do
  echo -ne 'export JAVA_HOME='$INSTALL_ROOT'/'$path'\n' >> ${HOME}'/.java_home'
done

## Java Home
#[[ -s ${HOME}/.java_home ]] && source ${HOME}/.java_home
