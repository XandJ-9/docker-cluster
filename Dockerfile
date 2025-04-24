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

# 设置JAVA_HOME环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin


# 准备hadoop相关文件
COPY ./.pkgs/hadoop-3.3.6.tar.gz /opt/hadoop-3.3.6.tar.gz
# 安装hadoop
RUN mkdir -p /opt/hadoop && \
    tar -zxvf /opt/hadoop-3.3.6.tar.gz -C /opt/hadoop --strip-components=1 && \
    rm -rf /opt/hadoop-3.3.6.tar.gz


# 准备hive相关文件
COPY ./.pkgs/apache-hive-3.1.3-bin.tar.gz /opt/apache-hive-3.1.3-bin.tar.gz 
# 安装hive
RUN mkdir -p /opt/hive && \
    tar -zxvf /opt/apache-hive-3.1.3-bin.tar.gz -C /opt/hive --strip-components=1 && \
    rm -rf /opt/apache-hive-3.1.3-bin.tar.gz


# 准备hbase相关文件
COPY ./.pkgs/hbase-2.5.5-bin.tar.gz /opt/hbase-2.5.5-bin.tar.gz
# 安装hbase
RUN mkdir -p /opt/hbase && \
    tar -zxvf /opt/hbase-2.5.5-bin.tar.gz -C /opt/hbase --strip-components=1 && \
    rm -rf /opt/hbase-2.5.5-bin.tar.gz


# 准备spark相关文件
COPY ./.pkgs/spark-3.5.0-bin-hadoop3.tgz /opt/spark-3.5.0-bin-hadoop3.tgz
# 安装spark
RUN mkdir -p /opt/spark && \
    tar -zxvf /opt/spark-3.5.0-bin-hadoop3.tgz -C /opt/spark --strip-components=1 && \
    rm -rf /opt/spark-3.5.0-bin-hadoop3.tgz


# 准备flink相关文件
COPY ./.pkgs/flink-1.18.0-bin-scala_2.12.tgz /opt/flink-1.18.0-bin-scala_2.12.tgz
# 安装flink
RUN mkdir -p /opt/flink && \
    tar -zxvf /opt/flink-1.18.0-bin-scala_2.12.tgz -C /opt/flink --strip-components=1 && \
    rm -rf /opt/flink-1.18.0-bin-scala_2.12.tgz


# 准备presto相关文件
COPY ./.pkgs/presto-server-0.285.tar.gz /opt/presto-server-0.285.tar.gz
# 安装presto
RUN mkdir -p /opt/presto && \
    tar -zxvf /opt/presto-server-0.285.tar.gz -C /opt/presto --strip-components=1 && \
    rm -rf /opt/presto-server-0.285.tar.gz


# 设置工作目录
WORKDIR /opt

# 启动SSH服务并保持容器运行
CMD ["/usr/sbin/sshd","-D"]