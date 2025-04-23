#!/bin/bash

# 启动hadoop
funtion start_hadoop() {
# 初始化
hdfs namenode -format

cd /opt/hadoop
sbin/start-all.sh


}

