#!/bin/bash
if [ $(id -u) != '0' ];then
    echo "run this script as root user please!!!!";
    exit 0;
fi
echo "--------------starting";
path=`pwd`
echo "--------------configing the ssh";
if [ -f "sshd_config" ];then
    if [ -f "/etc/ssh/sshd_config.bk" ];then
        echo "config file exists,choose to override ,y/n?"
        read t
        if [ $t = "y" ]; then
            echo "override it"
            cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.bk
        else
            echo "don't override"
        fi
    else
        echo "backup the config file"
        cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.bk
    fi
    echo "override config file"
    cp -f sshd_config /etc/ssh/sshd_config
else
    echo "sshd_config does'nt exist,please copy it to `pwd`,then reexec the script!";
    echo "quit!";exit 0;
fi
if [ ! -d "$HOME/.ssh" ];then
    echo "doesn't exist .ssh dir,now creating "
    mkdir $HOME/.ssh
fi
chmod 755 $HOME/.ssh;
cp -f  id_rsa.pub $HOME/.ssh/
cat $HOME/.ssh/id_rsa.pub > $HOME/.ssh/authorized_keys
chmod 644 $HOME/.ssh/authorized_keys 
echo "after 20s the server will reboot";
sleep 20;
echo "------rebooting------";
reboot;
