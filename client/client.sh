#!/bin/bash
if [ $(id -u) != '0' ];then
    echo "请在超级管理员下运行此脚本";
    exit 0;
fi
echo "请按照提示输入配置，如果输错后已经按下回车，请按CTR-C停止，并重新运行此脚本"
echo "路由器自动配置脚本,准备开始";
#当前路径
path=`pwd`
export AUTOSSH_LOGLEVEL=7;export AUTOSSH_LOGFILE="$path/logfile"; export AUTOSSH_POLL=30;
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
if [ -f "autossh.ipk" ];then
    opkg  install ./autossh.ipk;
else
    echo "autossh.ipk不存在，请将此文件拷贝至当前目录:`pwd`"后重新配置;
    echo "程序退出！";exit 0;
fi;
echo "----------安装完成------";
echo "----------生成脚本------";
echo "autossh -f -N -M $port_listen -R 0.0.0.0:$port_serve:$ip_sbox:$port_sbox -o StrictHostKeyChecking=no -i $path/id_rsa_drop  root@$ip_serve;" >autossh.sh
echo "autossh -f -N -M $(($port_listen-1000)) -R 0.0.0.0:$(($port_serve-1000)):localhost:22 -o StrictHostKeyChecking=no -i $path/id_rsa_drop  root@$ip_serve;"  >>autossh.sh 
#     autossh -f -N  -M 42341  -R 0.0.0.0:4000:192.168.31.10:4000 -i /root/.ssh/id_rsa_drop  root@182.61.32.129
echo "----------生成脚本完成-----";
echo "----------设置自启动，覆盖rc.local,请勿在rc.local下设置其他自启动------";
echo "export HOME=$HOME;sh $path/autossh.sh" >/etc/rc.local
echo "----------自启动设置完成------";
echo "20s后路由器将重启，按CTR-C阻止";
sleep 20;
echo "------正在重启------";
reboot;
