#!/bin/bash

# Stop Presto server
echo "Stopping Presto server..."

# Set environment variables if not already set
if [ -z "$PRESTO_HOME" ]; then
    export PRESTO_HOME=/opt/presto
    echo "PRESTO_HOME set to $PRESTO_HOME"
fi

# Stop Presto server
$PRESTO_HOME/bin/launcher stop

echo "Presto server stopped."