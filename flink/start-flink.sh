#!/bin/bash

# Start Flink cluster
echo "Starting Flink cluster..."

# Set environment variables if not already set
if [ -z "$FLINK_HOME" ]; then
    export FLINK_HOME=/opt/flink
    echo "FLINK_HOME set to $FLINK_HOME"
fi

# Check if HADOOP_CONF_DIR is set
if [ -z "$HADOOP_CONF_DIR" ]; then
    export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
    echo "HADOOP_CONF_DIR set to $HADOOP_CONF_DIR"
fi

# Start the Flink cluster
$FLINK_HOME/bin/start-cluster.sh

echo "Flink cluster started. Web UI available at http://master:8081"