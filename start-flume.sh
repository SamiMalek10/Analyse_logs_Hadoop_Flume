#!/bin/bash
# Script pour démarrer l'agent Flume

# Assurez-vous que le répertoire de logs existe
mkdir -p /tmp/weblogs

# Démarrer l'agent Flume
echo "Démarrage de l'agent Flume..."

    
$FLUME_HOME/bin/flume-ng agent \
    --conf $FLUME_HOME/conf \
    --conf-file ./weblog-flume.conf \
    --name weblog-agent \
    -Dflume.root.logger=INFO,console
    > flume.log 2>&1 &
    



echo "Agent Flume démarré avec PID $!"
echo "Logs de Flume dans flume.log"
