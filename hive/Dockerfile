# 使用已经构建好的hadoop-base:3.3.6镜像作为基础镜像
FROM hadoop-base:3.3.6

# 上传hive安装包
COPY apache-hive-3.1.3-bin.tar.gz /tmp/

# 解压hive安装包
RUN tar -zxvf /tmp/apache-hive-3.1.3-bin.tar.gz -C /opt && \
    mv /opt/apache-hive-3.1.3-bin /opt/hive && \
    rm -f /tmp/apache-hive-3.1.3-bin.tar.gz

COPY conf/* /opt/hive/conf/*

# 设置环境变量
ENV HIVE_HOME=/opt/hive
ENV PATH=$PATH:$HIVE_HOME/bin
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=hive

# 配置hive
RUN echo "export HIVE_HOME=/opt/hive" >> /etc/profile && \
    echo "export PATH=$PATH:$HIVE_HOME/bin" >> /etc/profile


# 暴露hive端口
EXPOSE 10000:10000
EXPOSE 10002:10002

# 启动hive
CMD ["/usr/sbin/sshd", "-D"]