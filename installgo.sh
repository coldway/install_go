#!/bin/bash

# 安装golang脚本
# $1 = 1.13
# usage: sh installgo.sh 1.23.2

intsallVersion=$1
if [ -z "$1" ]; then
  echo "入参为空"
  exit 0
fi

FILENAME=go$1.darwin-amd64.tar.gz
DIR=go$1

FILENAME=go$1.darwin-amd64.tar.gz

OS_TYPE=$(uname)
case "$OS_TYPE" in
Darwin)
  FILENAME=go$1.darwin-amd64.tar.gz
  ;;
Linux)
  FILENAME=go$1.linux-amd64.tar.gz
  ;;
*)
  echo "Unsupported operating system: $OS_TYPE"
  return 0
  ;;
esac
if [ -d "$DIR" ]; then
  echo "目录 $DIR 存在。"
else
  echo "目录 $DIR 不存在。"
  if [ -f "$FILENAME" ]; then
    echo "文件 ${FILENAME} 存在。"
  else
    #release address : https://go.dev/dl/
    wget https://go.dev/dl/$FILENAME
    if [ $? -ne 0 ]; then
      echo "下载失败，请检查网络连接或URL或版本:$intsallVersion"
      exit 1
    fi
    mkdir $DIR
    tar -xvf $FILENAME -C $DIR
    rm $FILENAME
  fi
fi

# 检查 go 命令是否可用
if command -v go &>/dev/null; then
  echo "Go is installed."
  # 打印 Go 的版本信息
  go version
  installPath=$(which go)
  echo $installPath
  # 检查写入权限
  if [ -w "$installPath" ]; then
    echo "当前用户有写入权限"
    ln -snf $PWD/$DIR/go/bin/go $installPath
    ls -al $installPath
  else
    echo "当前用户没有写入权限"
    mkdir -p $HOME/usr/local/bin
    ln -snf $PWD/$DIR/go/bin/go $HOME/usr/local/bin/go
    echo 'export PATH=$HOME/usr/local/bin:$PATH' >>~/.bash_profile
    source ~/.bash_profile
  fi
else
  echo "Go is not installed."
  goDefaultPath=/usr/local/bin
  if [ -w "$goDefaultPath" ]; then
    echo "当前用户有写入权限"
    ln -snf $PWD/$DIR/go/bin/go $goDefaultPath/go
    ls -al $goDefaultPath/go
  else
    echo "当前用户没有写入权限"
    mkdir -p $HOME/usr/local/bin
    ln -snf $PWD/$DIR/go/bin/go $HOME/usr/local/bin/go
    ls -al $HOME/usr/local/bin/go
    echo 'export PATH=$HOME/usr/local/bin:$PATH' >>~/.bash_profile
    source ~/.bash_profile
    . ~/.bash_profile
  fi
fi
export PATH=$HOME/usr/local/bin:$PATH
echo "安装完毕"
echo $PATH
echo $(which go)
echo $(go version)
