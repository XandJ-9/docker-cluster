#!/bin/bash

/opt/hadoop/sbin/start-all.sh

/opt/hadoop/bin/mapred --daemon start historyserver

hdfs dfs -mkdir /spark-logs

/opt/spark/sbin/start-all.sh
/opt/spark/sbin/start-history-server.sh