FROM ubuntu:22.04

# 安装基础工具
RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk \
    openssh-server \
    wget \
    curl \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# 创建SSH密钥
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# 启动SSH服务
RUN service ssh start

# 复制大数据组件安装包
# COPY packages /opt/packages
# 准备hadoop相关文件
COPY ./.pkgs/hadoop-3.3.6.tar.gz /opt/service/hadoop-3.3.6.tar.gz
# 安装hadoop
RUN tar -zxvf /opt/service/hadoop-3.3.6.tar.gz -C /opt/service && \
    mv /opt/service/hadoop-3.3.6 /opt/service/hadoop && \
    rm -rf /opt/service/hadoop-3.3.6.tar.gz && \
    echo "export HADOOP_HOME=/opt/service/hadoop" >> /etc/profile && \
    echo "export PATH=$HADOOP_HOME/bin:$PATH" >> /etc/profile

# 准备hive相关文件
COPY ./.pkgs/apache-hive-3.1.3-bin.tar.gz /opt/service/apache-hive-3.1.3-bin.tar.gz 
# 安装hive
RUN tar -zxvf /opt/service/apache-hive-3.1.3-bin.tar.gz -C /opt/service && \
    mv /opt/service/apache-hive-3.1.3-bin /opt/service/hive && \
    rm -rf /opt/service/apache-hive-3.1.3-bin.tar.gz && \
    echo "export HIVE_HOME=/opt/service/hive" >> /etc/profile && \
    echo "export PATH=$HIVE_HOME/bin:$PATH" >> /etc/profile

# 准备hbase相关文件
COPY ./.pkgs/hbase-2.5.5-bin.tar.gz /opt/service/hbase-2.5.5-bin.tar.gz
# 安装hbase
RUN tar -zxvf /opt/service/hbase-2.5.5-bin.tar.gz -C /opt/service && \
    mv /opt/service/hbase-2.5.5-bin /opt/service/hbase && \
    rm -rf /opt/service/hbase-2.5.5-bin.tar.gz && \
    echo "export HBASE_HOME=/opt/service/hbase" >> /etc/profile && \
    echo "export PATH=$HBASE_HOME/bin:$PATH" >> /etc/profile

# 准备spark相关文件
COPY ./.pkgs/spark-3.5.0-bin-hadoop3.tgz /opt/service/spark-3.5.0-bin-hadoop3.tgz
# 安装spark
RUN tar -zxvf /opt/service/spark-3.5.0-bin-hadoop3.tgz -C /opt/service && \
    mv /opt/service/spark-3.5.0-bin-hadoop3 /opt/service/spark && \
    rm -rf /opt/service/spark-3.5.0-bin-hadoop3.tgz  && \
    echo "export SPARK_HOME=/opt/service/spark" >> /etc/profile && \
    echo "export PATH=$SPARK_HOME/bin:$PATH" >> /etc/profile

# 复制安装脚本
# COPY install.sh /opt/install.sh
# RUN chmod +x /opt/install.sh

# 设置工作目录
WORKDIR /opt

# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# 启动SSH服务并保持容器运行
CMD ["/usr/sbin/sshd","-D"]