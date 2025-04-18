#!/bin/bash

# Stop Flink cluster
echo "Stopping Flink cluster..."

# Set environment variables if not already set
if [ -z "$FLINK_HOME" ]; then
    export FLINK_HOME=/opt/flink
    echo "FLINK_HOME set to $FLINK_HOME"
fi

# Stop the Flink cluster
$FLINK_HOME/bin/stop-cluster.sh

echo "Flink cluster stopped."