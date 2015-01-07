#!/bin/bash

INSTALL_ROOT=$HOME/Vim

mkdir $INSTALL_ROOT

pushd $INSTALL_ROOT
    curl ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2 -O
    tar xvf vim-7.4.tar.bz2
    pushd vim74
    ./configure --with-features=huge \
           --enable-multibyte \
           --enable-rubyinterp \
           --enable-pythoninterp \
           --with-python-config-dir=/usr/lib/python2.7/config \
           --enable-perlinterp \
           --enable-luainterp \
           --enable-gui=gtk2 \
           --enable-cscope \
           --prefix=$INSTALL_ROOT
    make VIMRUNTIMEDIR=$INSTALL_ROOT/share/vim/vim74
    make install
    popd
    rm -rf vim74
    rm -rf vim-7.4.tar.bz2
popd

METAPATH=$INSTALL_ROOT/bin

echo Add the following line to the end of your .bashrc:
echo VIM_HOME=$METAPATH
