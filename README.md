# install_go
一键安装golang

## 版本更改：默认安装到 which go 文件
    若没有$(which go) 修改权限，安装到$HOME/usr/local/bin/go下
## 首次安装：
    若有/usr/local/bin权限，安装到/usr/local/bin/go下
    否则：安装到 $HOME/usr/local/bin/go 下