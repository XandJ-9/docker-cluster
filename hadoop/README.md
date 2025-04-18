# 单独使用docker构建hadoop集群


## 构建基础镜像
```
docker build -t hadoop-base:3.3.6 .
```

## 构建hadoop集群镜像

基础镜像：hadoop-base:3.3.6

容器角色
| 容器名称 | 角色 | 主要服务 | 端口映射 | 挂载目录 |
|---------|------|---------|----------|----------|
| master  | 主节点 | HDFS NameNode<br>YARN ResourceManager<br> | 9870 (HDFS UI)<br>8088 (YARN UI)<br>10002 (DataNode UI) |
| worker1 | 工作节点 | HDFS DataNode<br>YARN NodeManager | - | /hadoop |
| worker2 | 工作节点 | HDFS DataNode<br>YARN NodeManager| - | /hadoop |
| worker3 | 工作节点 | HDFS DataNode<br>YARN NodeManager | - | /hadoop |
| worker4 | 工作节点 | HDFS DataNode<br>YARN NodeManager | - | /hadoop<br> |

使用docker-compose构建hadoop集群
```
docker-compose up -d
```


启动集群
  使用docker-compose启动容器后，需要手动启动一下集群（这里不知道怎么才能让docker-compose up执行时，就启动hadoop服务，所以手动处理这一步）
  进入master容器，执行以下命令
  ```
  docker exec -it master /opt/hadoop/sbin/start-all.sh
  ```
