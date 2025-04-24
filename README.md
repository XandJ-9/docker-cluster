# Docker大数据集群

## 集群架构

本项目使用Docker Compose搭建了一个完整的大数据处理集群，包含以下组件：
- Hadoop HDFS：分布式文件系统
- YARN：资源调度管理
- Spark：分布式计算引擎
- Flink：流处理引擎
- Hive：数据仓库
- HBase：分布式数据库
- Presto：分布式SQL查询引擎
- MySQL：元数据存储

## 集群节点信息

| 容器名称 | 角色 | 主要服务 | 端口映射 | 挂载目录 |
|---------|------|---------|----------|----------|
| master  | 主节点 | HDFS NameNode<br>YARN ResourceManager<br>Spark Master<br>Flink JobManager | 9870 (HDFS UI)<br>8088 (YARN UI)<br>10002 (DataNode UI)<br>8080 (Spark UI)<br>8081 (Flink UI) | /hadoop<br>/spark<br>/hive<br>/flink |
| worker1 | 工作节点 | HDFS DataNode<br>YARN NodeManager<br>Hive Worker | - | /hadoop<br>/hive |
| worker2 | 工作节点 | HDFS DataNode<br>YARN NodeManager<br>HBase Worker | - | /hadoop<br>/hbase |
| worker3 | 工作节点 | HDFS DataNode<br>YARN NodeManager<br>Spark Worker<br>Flink TaskManager | - | /hadoop<br>/spark<br>/flink |
| worker4 | 工作节点 | HDFS DataNode<br>YARN NodeManager<br>Presto Worker | - | /hadoop<br>/presto |
| mysql   | 数据库节点 | MySQL Server | - | /var/lib/mysql |

## 使用说明

### 环境要求
- Docker Engine
- Docker Compose
- 至少8GB内存
- 至少20GB可用磁盘空间


## 组件版本

| 组件名称 | 版本 | 说明 |
|---------|------|------|
| Hadoop | 3.3.6 | 作为基础组件，提供HDFS和YARN服务 |
| Hive | 3.1.3 | 与Hadoop 3.3.x完全兼容 |
| HBase | 2.5.5 | 支持Hadoop 3.x版本 |
| Spark | 3.5.0 | 支持Hadoop 3.x，可与Hive 3.x集成 |
| Flink | 1.18.0 | 支持Hadoop 3.x，提供最新特性 |
| Presto | 0.285 | 可连接Hive、HBase等数据源 |
| MySQL | 8.0 | 用于存储Hive元数据 |

## 组件下载链接

| 组件名称 | 下载链接 |
|---------|---------|
| Hadoop 3.3.6 | https://archive.apache.org/dist/hadoop/core/hadoop-3.3.6/hadoop-3.3.6.tar.gz |
| Hive 3.1.3 | https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz |
| HBase 2.5.5 | https://archive.apache.org/dist/hbase/2.5.5/hbase-2.5.5-bin.tar.gz |
| Spark 3.5.0 | https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz |
| Flink 1.18.0 | https://archive.apache.org/dist/flink/flink-1.18.0/flink-1.18.0-bin-scala_2.12.tgz |
| Presto 0.285 | https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.285/presto-server-0.285.tar.gz |

## 安装配置说明

### 组件安装步骤
1. 将下载好的组件包放置在对应目录中：
   - 将hadoop-3.3.6.tar.gz放在hadoop目录
   - 将apache-hive-3.1.3-bin.tar.gz放在hive目录
   - 将hbase-2.5.5-bin.tar.gz放在hbase目录
   - 将spark-3.5.0-bin-hadoop3.tgz放在spark目录
   - 将flink-1.18.0-bin-scala_2.12.tgz放在flink目录
   - 将presto-server-0.285.tar.gz放在presto目录

2. 准备配置文件：
   - 在hadoop/etc/hadoop/目录下准备core-site.xml、hdfs-site.xml、yarn-site.xml等配置文件
   - 在hive/conf/目录下准备hive-site.xml配置文件
   - 在hbase/conf/目录下准备hbase-site.xml配置文件
   - 在spark/conf/目录下准备spark-defaults.conf配置文件
   - 在flink/conf/目录下准备flink-conf.yaml配置文件
   - 在presto/etc/目录下准备config.properties配置文件

3. 构建基础镜像
   ```bash
   docker build -f Dockerfile -t cluster:1.0 . 
   ```
   这个镜像是准备基础的服务器环境，包含了hadoop、hive、hbase、spark、flink、presto等组件的安装， 这个镜像的构建比较耗时，因此单独构建好，后续有修改就不用重复构建。
   在基础镜像之上在构建一层，这一步主要是因为需要更换配置文件，因此单独将上传配置文件的步骤放到一层
   ```bash
   docker build -f Dockerfile2 -t cluster:2.0 .
   ```


### 服务启动流程
基础准备，启动服务器集群容器
   以下是启动各服务的流程：
   启动所有集群节点
   ```
   docker-compose up -d
   ```

一键启动： docker exec -i master /opt/start.sh

1. 启动hadoop服务
   ```
   # 初始化文件系统
   docker exec -i master hdfs namenode -format
   docker exec -i master /opt/hadoop/sbin/start-all.sh
   ```
   docker exec -i master /opt/hadoop/bin/mapred --daemon start historyserver

2. 启动hive服务

   2.1 创建Hive用户：
   ```bash
   docker exec -i mysql mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS hive;"
   ```

   > 注意：由于本样例要在一个容器中运行多个大数据的组件，因此需要将各个组件(hadoop,hive,hbase,spark,flink,presto等)拷贝到容器中，
   > 因此这个过程会比较耗时
   
   2.2 初始化hive元数据:
   ```bash
   docker exec -i master /opt/hive/bin/schematool -dbType mysql -initSchema
   ```
   
   2.3 启动hive服务：
   ```bash
   # hive元数据服务
   docker exec -i -d master /opt/hive/bin/hive --service metastore
   ```

3. 启动spark服务 
   由于在配置spark-default.conf中配置了`hdfs://master:9000/spark-logs`路径，因此需要先创建这个目录
   ```
   docker exec -i master hdfs dfs -mkdir /spark-logs
   ```
   ```bash
   docker exec -i master /opt/spark/sbin/start-all.sh
   ```
   测试spark：
   ```bash
   docker exec -i master spark-submit --master yarn --deploy-mode cluster --class org.apache.spark.examples.JavaSparkPi /opt/spark/examples/jars/spark-examples_2.12-3.5.0.jar
   ```

4. 验证服务状态：
   - 访问HDFS UI (http://localhost:9870)：
     * 检查NameNode是否处于active状态
     * 确认所有DataNode已注册并处于live状态
     * 验证HDFS存储容量是否正常

   - 访问YARN UI (http://localhost:8088)：
     * 检查ResourceManager是否正常运行
     * 确认所有NodeManager已注册
     * 查看集群资源使用情况

   - 访问Spark UI (http://localhost:8080)：
     * 验证Spark Master状态
     * 检查Worker节点是否已连接
     * 查看可用执行器数量

   - 访问Flink UI (http://localhost:8081)：
     * 确认JobManager运行状态
     * 检查TaskManager注册情况
     * 查看可用任务槽数量

5. 测试集群功能：
   - 执行HDFS基本操作：
     ```bash
     docker exec -it master hdfs dfs -mkdir /test
     docker exec -it master hdfs dfs -put /opt/hadoop/README.txt /test/
     docker exec -it master hdfs dfs -ls /test/
     ```

   - 提交Spark测试作业：
     ```bash
     docker exec -it master spark-submit --class org.apache.spark.examples.SparkPi \
       $SPARK_HOME/examples/jars/spark-examples*.jar 10
     ```

   - 运行Flink示例程序：
     ```bash
     docker exec -it master flink run $FLINK_HOME/examples/streaming/WordCount.jar
     ```

### 注意事项
1. 首次启动时，各个组件的初始化可能需要一些时间
2. 确保所有必要的端口未被其他服务占用
3. 数据持久化存储在Docker卷中，删除卷将导致数据丢失
4. 配置文件位于各个组件的目录中，可以根据需要进行修改

### 常见问题解决
1. 如果HDFS无法启动，检查：
   - NameNode目录权限是否正确
   - core-site.xml和hdfs-site.xml配置是否正确

2. 如果YARN服务无法启动，检查：
   - yarn-site.xml配置是否正确
   - 各节点的hostname是否能够正确解析

3. 命令行执行`docker exec -i master /opt/hadoop/sbin/start-all.sh`与`docker exec -it master /opt/hadoop/sbin/start-all.sh`执行脚本的区别，
   如果添加了参数`-t`，那么脚本运行结束后，容器中的进程退出，导致服务启动失败

4. 如果Hive服务启动失败，检查：
   - MySQL服务是否正常运行
   - hive-site.xml中的数据库连接配置是否正确