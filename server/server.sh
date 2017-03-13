#!/bin/bash
if [ $(id -u) != '0' ];then
    echo "run this script as root user please!!!!";
    exit 0;
fi
echo "--------------starting";
path=`pwd`
echo "--------------configing the ssh";
if [ -f "sshd_config" ];then
    cp -f sshd_config /etc/ssh/sshd_config
else
    echo "sshd_config does'nt exist,please copy it to `pwd`,then reexec the script!";
    echo "quit!";exit 0;
fi
if [ ! -d "$HOME/.ssh" ];then
    mkdir $HOME/.ssh
fi
chmod 755 .ssh;
cp -f  id_rsa.pub $HOME/.ssh/
cat $HOME/.ssh/id_rsa.pub > $HOME/.ssh/authorized_keys
chmod 644 authorized_keys 
echo "after 20s the server will reboot";
sleep 20;
echo "------rebooting------";
reboot;
