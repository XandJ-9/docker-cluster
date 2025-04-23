#!/bin/bash

# Start Presto server
echo "Starting Presto server..."

# Set environment variables if not already set
if [ -z "$PRESTO_HOME" ]; then
    export PRESTO_HOME=/opt/presto
    echo "PRESTO_HOME set to $PRESTO_HOME"
fi

# Start Presto server
$PRESTO_HOME/bin/launcher start

echo "Presto server started. Web UI available at http://master:8080"