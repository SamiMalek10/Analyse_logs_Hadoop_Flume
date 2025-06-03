#!/bin/bash
# Script pour arrêter tous les composants du pipeline d'analyse de logs

echo "Arrêt du pipeline d'analyse de logs..."

# Arrêt de l'agent Flume
echo "Arrêt de l'agent Flume..."
pkill -f "flume-ng agent"

# Arrêt du générateur de logs
echo "Arrêt du générateur de logs..."
pkill -f "python.*generate_logs.py"

# Arrêt de Hadoop (HDFS et YARN)
echo "Arrêt de Hadoop..."
$HADOOP_HOME/sbin/stop-yarn.sh
$HADOOP_HOME/sbin/stop-dfs.sh

echo "Tous les services ont été arrêtés."
