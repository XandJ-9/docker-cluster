FROM ubuntu:22.04

# 设置用户
USER root

# 安装基础工具
RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk \
    openssh-server \
    wget \
    curl \
    vim \
    net-tools \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# 创建SSH密钥（用于Hadoop集群节点间通信）
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# 启动SSH服务
RUN service ssh start

# 创建必要的目录
RUN mkdir -p /hadoop/dfs/name /hadoop/dfs/data

# 下载Hadoop安装包
# RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-3.3.6/hadoop-3.3.6.tar.gz -P /tmp

# 拷贝提前下载好的安装包
COPY hadoop-3.3.6.tar.gz /tmp/

# 解压安装Hadoop
RUN tar -zxvf /tmp/hadoop-3.3.6.tar.gz -C /opt && \
    mv /opt/hadoop-3.3.6 /opt/hadoop && \
    rm -f /tmp/hadoop-3.3.6.tar.gz

# 设置JAVA_HOME环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# 设置Hadoop环境变量
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME

# 设置Hadoop用户
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

# 配置Hadoop
RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh


# 设置工作目录
WORKDIR $HADOOP_HOME

# 格式化HDFS
# RUN hdfs namenode -format

# 复制启动脚本并设置执行权限
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

# 设置容器入口点
# ENTRYPOINT ["/opt/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
# CMD ["bash"]