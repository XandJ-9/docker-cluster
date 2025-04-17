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
COPY packages /opt/packages

# 复制安装脚本
COPY install.sh /opt/install.sh
RUN chmod +x /opt/install.sh

# 设置工作目录
WORKDIR /opt

# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# 启动SSH服务并保持容器运行
CMD ["/usr/sbin/sshd","-D"]