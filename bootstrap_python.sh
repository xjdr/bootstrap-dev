#!/bin/bash

INSTALL_ROOT=/opt/python
CPY=$INSTALL_ROOT/CPython
PYPY=$INSTALL_ROOT/PyPy

SANDBOX=/tmp/python-sandbox

CURL='curl -k'

if [[ ! -d $INSTALL_ROOT ]]
then
  sudo mkdir -p $INSTALL_ROOT
fi

if [[ ! -d $SANDBOX ]]
then
  sudo mkdir -p $SANDBOX
fi

sudo chown $(whoami): $INSTALL_ROOT
sudo chown $(whoami): $SANDBOX

pushd $SANDBOX
  for version in 2.6.9 2.7.9 3.4.3; do
    $CURL https://www.python.org/ftp/python/$version/Python-$version.tgz -o Python-$version.tgz
    rc=$?
    if [[ $rc != 0 ]]
    then
      exit
    fi
    tar xzf Python-$version.tgz
    pushd Python-$version
      LDFLAGS=-L$SANDBOX/readline/lib CFLAGS=-I$SANDBOX/readline/include \
        ./configure --prefix=$INSTALL_ROOT/CPython-$version && make -j5 && make install
    popd
    rm -f Python-$version.tgz
  done

  $CURL https://pypi.python.org/packages/source/s/setuptools/setuptools-15.1.tar.gz -o setuptools-15.1.tar.gz
  rc=$?
  if [[ $rc != 0 ]]
  then
    exit
  fi
  $CURL https://pypi.python.org/packages/source/p/pip/pip-6.1.1.tar.gz -o pip-6.1.1.tar.gz
  rc=$?
  if [[ $rc != 0 ]]
  then
    exit
  fi

  for interpreter in $CPY-2.6.9/bin/python2.6 \
                     $CPY-2.7.9/bin/python2.7 \
                     $CPY-3.4.3/bin/python3.4; do
    # install distribute && pip
    for base in setuptools-15.1 pip-6.1.1; do
      tar xzf $base.tar.gz
      pushd $base
        $interpreter setup.py install
      popd
      rm -rf $base
    done
  done

  rm -f setuptools-15.1.tar.gz pip-6.1.1.tar.gz
popd

METAPATH='$PATH'
for path in $(ls $INSTALL_ROOT | sort -r); do
  echo -ne 'export PYTHON_HOME='$INSTALL_ROOT'/'$path'\n' >> ${HOME}'/.python_home'
done

## Python Home
#[[ -s ${HOME}/.python_home ]] && source ${HOME}/.python_home

rm -rf $SANDBOX

