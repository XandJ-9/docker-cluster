#!/bin/bash

/opt/hadoop/sbin/start-all.sh

/opt/hadoop/bin/mapred --daemon start historyserver

# 准备spark 日志目录
hdfs dfs -mkdir /spark-logs

/opt/spark/sbin/start-all.sh
/opt/spark/sbin/start-history-server.sh

# hive metastore
/opt/hive/bin/hive --service metastore