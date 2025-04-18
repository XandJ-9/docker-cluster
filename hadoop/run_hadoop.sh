#!/bin/bash

echo "Starting SSH service"
service ssh start

echo "master" > /etc/hosts
echo "worker1" >> /etc/hosts
echo "worker2" >> /etc/hosts
echo "worker3" >> /etc/hosts
echo "worker4" >> /etc/hosts


# 获取当前主机名
HOSTNAME=$(hostname)

# 设置工作目录
cd /opt

# 根据主机名安装对应组件
case $HOSTNAME in
    "master")
        echo "Installing components for master node"
        $HADOOP_HOME/sbin/start-dfs.sh
        $HADOOP_HOME/sbin/start-yarn.sh
        # $HIVE_HOME/bin/schematool -initSchema -dbType derby
        ;;
    
    "worker1")
        echo "Installing components for worker1 node"
        ;;
    
    "worker2")
        echo "Installing components for worker2 node"
        ;;
    
    "worker3")
        echo "Installing components for worker3 node"
        ;;
    
    "worker4")
        echo "Installing components for worker4 node"
        ;;
    
    *)
        echo "Unknown hostname: $HOSTNAME"
        exit 1
        ;;
esac


# 刷新环境变量
source ~/.bashrc
