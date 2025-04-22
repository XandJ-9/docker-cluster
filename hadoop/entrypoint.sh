#!/bin/bash

# 启动SSH服务
echo "Starting SSH service"
service ssh start


# 设置工作目录
cd $HADOOP_HOME

# 根据传入的命令执行不同操作
COMMAND="$1"
echo "Received command: $COMMAND"

case $COMMAND in
    "hdfs")
        echo "Starting HDFS NameNode service"
        hdfs namenode -format
        hdfs namenode
        ;;
    "yarn")
        echo "Starting YARN ResourceManager service"
        yarn resourcemanager
        ;;
    "start-all")
        echo "Starting all Hadoop services"
        # $HADOOP_HOME/sbin/start-dfs.sh
        # $HADOOP_HOME/sbin/start-yarn.sh
        $HADOOP_HOME/sbin/start-all.sh 
        tail -f $HADOOP_HOME/logs/hadoop-root-namenode-master.log  # 打印日志，保持容器不退出
        ;;
    "stop-all")
        echo "Stopping all Hadoop services"
        # $HADOOP_HOME/sbin/stop-yarn.sh
        # $HADOOP_HOME/sbin/stop-dfs.sh
        $HADOOP_HOME/sbin/stop-all.sh
        ;;
    "bash")
        echo "Starting bash shell"
        /bin/bash
        ;;
    "")
        echo "No command specified"
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo "Available commands: hdfs, yarn, start-all, stop-all, bash"
        exit 1
        ;;
esac
