#!/bin/bash
# Script pour démarrer et arrêter les services Hadoop

function start_hadoop() {
    echo "Démarrage des services Hadoop..."
    $HADOOP_HOME/sbin/start-dfs.sh
    $HADOOP_HOME/sbin/start-yarn.sh
    
    # Vérification du statut des services
    echo "Vérification des services Hadoop..."
    jps
    
    echo "Vérification du mode safe mode..."
    hdfs dfsadmin -safemode leave
    
    # Créer les répertoires nécessaires dans HDFS
    echo "Création des répertoires dans HDFS..."
    hdfs dfs -mkdir -p /user/sami
    hdfs dfs -mkdir -p /user/sami/logs
    hdfs dfs -mkdir -p /user/sami/logs/raw
    hdfs dfs -mkdir -p /user/sami/logs/processed
    hdfs dfs -mkdir -p /user/sami/logs/output
    
    echo "Hadoop a démarré avec succès."
}

function stop_hadoop() {
    echo "Arrêt des services Hadoop..."
    $HADOOP_HOME/sbin/stop-yarn.sh
    $HADOOP_HOME/sbin/stop-dfs.sh
    
    echo "Hadoop a été arrêté."
}

# Menu pour choisir l'action
case "$1" in
    start)
        start_hadoop
        ;;
    stop)
        stop_hadoop
        ;;
    restart)
        stop_hadoop
        start_hadoop
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
