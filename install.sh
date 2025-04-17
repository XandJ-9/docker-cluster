#!/bin/bash

# 获取当前主机名
HOSTNAME=$(hostname)

# 设置工作目录
cd /opt

# 根据主机名安装对应组件
case $HOSTNAME in
    "master")
        echo "Installing components for master node"
        # 复制并解压Hadoop
        echo "unzip hadoop-3.3.6.tar.gz"
        cp packages/hadoop-3.3.6.tar.gz /opt/hadoop/
        cd /opt/hadoop && tar -zxf hadoop-3.3.6.tar.gz --strip-components=1 && rm -f hadoop-3.3.6.tar.gz
        
        # 复制并解压Spark
        echo "unzip spark-3.5.0-bin-hadoop3.tgz"
        cp packages/spark-3.5.0-bin-hadoop3.tgz /opt/spark/
        cd /opt/spark && tar -zxf spark-3.5.0-bin-hadoop3.tgz --strip-components=1 && rm -f spark-3.5.0-bin-hadoop3.tgz
        
        # 复制并解压Hive
        echo "unzip apache-hive-3.1.3-bin.tar.gz"
        cp packages/apache-hive-3.1.3-bin.tar.gz /opt/hive/
        cd /opt/hive && tar -zxf apache-hive-3.1.3-bin.tar.gz --strip-components=1 && rm -f apache-hive-3.1.3-bin.tar.gz
        
        # 复制并解压Flink
        echo "unzip flink-1.18.0-bin-scala_2.12.tgz"
        cp packages/flink-1.18.0-bin-scala_2.12.tgz /opt/flink/
        cd /opt/flink && tar -zxf flink-1.18.0-bin-scala_2.12.tgz --strip-components=1 && rm -f flink-1.18.0-bin-scala_2.12.tgz
        ;;
    
    "worker1")
        echo "Installing components for worker1 node"
        # 复制并解压Hadoop
        echo "unzip hadoop-3.3.6.tar.gz"
        cp packages/hadoop-3.3.6.tar.gz /opt/hadoop/
        cd /opt/hadoop && tar -zxf hadoop-3.3.6.tar.gz --strip-components=1 && rm -f hadoop-3.3.6.tar.gz
        
        # 复制并解压Hive
        echo "unzip apache-hive-3.1.3-bin.tar.gz"
        cp packages/apache-hive-3.1.3-bin.tar.gz /opt/hive/
        cd /opt/hive && tar -zxf apache-hive-3.1.3-bin.tar.gz --strip-components=1 && rm -f apache-hive-3.1.3-bin.tar.gz
        ;;
    
    "worker2")
        echo "Installing components for worker2 node"
        # 复制并解压Hadoop
        echo "unzip hadoop-3.3.6.tar.gz"
        cp packages/hadoop-3.3.6.tar.gz /opt/hadoop/
        cd /opt/hadoop && tar -zxf hadoop-3.3.6.tar.gz --strip-components=1 && rm -f hadoop-3.3.6.tar.gz
        
        # 复制并解压HBase
        echo "unzip hbase-2.5.5-bin.tar.gz"
        cp packages/hbase-2.5.5-bin.tar.gz /opt/hbase/
        cd /opt/hbase && tar -zxf hbase-2.5.5-bin.tar.gz --strip-components=1 && rm -f hbase-2.5.5-bin.tar.gz
        ;;
    
    "worker3")
        echo "Installing components for worker3 node"
        # 复制并解压Hadoop
        echo "unzip hadoop-3.3.6.tar.gz"
        cp packages/hadoop-3.3.6.tar.gz /opt/hadoop/
        cd /opt/hadoop && tar -zxf hadoop-3.3.6.tar.gz --strip-components=1 && rm -f hadoop-3.3.6.tar.gz
        
        # 复制并解压Spark
        echo "unzip spark-3.5.0-bin-hadoop3.tgz"
        cp packages/spark-3.5.0-bin-hadoop3.tgz /opt/spark/
        cd /opt/spark && tar -zxf spark-3.5.0-bin-hadoop3.tgz --strip-components=1 && rm -f spark-3.5.0-bin-hadoop3.tgz
        
        # 复制并解压Flink
        echo "unzip flink-1.18.0-bin-scala_2.12.tgz"
        cp packages/flink-1.18.0-bin-scala_2.12.tgz /opt/flink/
        cd /opt/flink && tar -zxf flink-1.18.0-bin-scala_2.12.tgz --strip-components=1 && rm -f flink-1.18.0-bin-scala_2.12.tgz
        ;;
    
    "worker4")
        echo "Installing components for worker4 node"
        # 复制并解压Hadoop
        echo "unzip hadoop-3.3.6.tar.gz"
        cp packages/hadoop-3.3.6.tar.gz /opt/hadoop/
        cd /opt/hadoop && tar -zxf hadoop-3.3.6.tar.gz --strip-components=1 && rm -f hadoop-3.3.6.tar.gz
        
        # 复制并解压Presto
        echo "unzip presto-server-0.285.tar.gz"
        cp packages/presto-server-0.285.tar.gz /opt/presto/
        cd /opt/presto && tar -zxf presto-server-0.285.tar.gz --strip-components=1 && rm -f presto-server-0.285.tar.gz
        ;;
    
    *)
        echo "Unknown hostname: $HOSTNAME"
        exit 1
        ;;
esac

# 设置环境变量
if [ -d "$HADOOP_HOME" ]; then
    echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bashrc
fi

if [ -d "$HBASE_HOME" ]; then
    echo 'export PATH=$PATH:$HBASE_HOME/bin' >> ~/.bashrc
fi

if [ -d "$SPARK_HOME" ]; then
    echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> ~/.bashrc
fi

if [ -d "$HIVE_HOME" ]; then
    echo 'export PATH=$PATH:$HIVE_HOME/bin' >> ~/.bashrc
fi

if [ -d "$FLINK_HOME" ]; then
    echo 'export PATH=$PATH:$FLINK_HOME/bin' >> ~/.bashrc
fi

# 刷新环境变量
source ~/.bashrc
