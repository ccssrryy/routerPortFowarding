#!/bin/bash
echo "请按照提示输入配置，如果输错后已经按下回车，请按CTR-C停止，并重新运行此脚本"
echo "路由器自动配置脚本,准备开始";
path=`pwd`
echo "输入分配的服务器ip地址:";
read ip_serve;
echo "输入分配的公网ip服务器端口号:";
read port_serve;
echo "输入sbox ip地址:";
read ip_sbox;
echo "输入sbox 端口:";
read port_sbox;
echo "输入分配的心跳检测端口:";
read port_listen;
echo "----------开始安装autossh------";
opkg  -i ./autossh.ipk;
echo "----------安装完成------";
echo "----------生成脚本------";
echo "autossh -R 0.0.0.0:$port_serve:$ip_sbox:$port_sbox -M $port_listen root@$ip_serve -i $path/id_rsa_drop >$path/log 2>$path/autossh_log" >autossh.sh
echo "----------生成脚本完成-----";
echo "----------设置自启动，覆盖rc.local,请勿在rc.local下设置其他自启动------";
echo "export HOME=`$HOME`;sh $path/autossh.sh" /etc/rc.local
echo "----------自启动设置完成------";
echo "20s后路由器将重启，按CTR-C阻止";
wait 20;
echo "------正在重启------";
reboot;
