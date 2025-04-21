# Hadoop 集群

这个目录包含了用于构建和运行Hadoop集群的Docker配置文件。

## 目录结构

- `Dockerfile`: 用于构建Hadoop基础镜像
- `docker-compose.yml`: 用于定义和运行多容器Hadoop应用
- `entrypoint.sh`: 容器入口点脚本，根据命令参数执行不同操作
- `etc/hadoop/`: Hadoop配置文件目录

## 使用方法

### 构建镜像

```bash
docker build -t hadoop-base:3.3.6 .
```

### 启动集群

```bash
docker-compose up -d
```

### 停止集群

```bash
docker-compose down
```

## 容器入口点

`entrypoint.sh`脚本作为容器的入口点，可以根据传入的命令参数执行不同操作：

- `hdfs`: 启动HDFS NameNode服务
- `yarn`: 启动YARN ResourceManager服务
- `start-all`: 启动所有Hadoop服务
- `stop-all`: 停止所有Hadoop服务
- `bash`: 启动bash shell

在`docker-compose.yml`中，可以通过`command`指令指定要执行的命令，例如：

```yaml
command: ["hdfs"]
```

## 访问Web界面

- HDFS NameNode: http://localhost:9870
- YARN ResourceManager: http://localhost:8088
- DataNode: http://localhost:10002
