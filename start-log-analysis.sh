#!/bin/bash
# Script principal pour orchestrer le pipeline d'analyse de logs

# Fonction pour afficher un menu et obtenir le choix de l'utilisateur
show_menu() {
    echo "========================================================="
    echo "  PIPELINE D'ANALYSE DE LOGS AVEC HADOOP, FLUME ET HIVE  "
    echo "========================================================="
    echo "1. Démarrer Hadoop"
    echo "2. Arrêter Hadoop"
    echo "3. Démarrer la génération de logs"
    echo "4. Démarrer la collecte de logs avec Flume"
    echo "5. Exécuter l'analyse MapReduce"
    echo "6. Configurer les tables Hive"
    echo "7. Exécuter et analyser partiellement les requêtes d'analyse Hive"
    echo "8. Exécuter et analyser complétement les requêtes d'analyse Hive"
    echo "9. Tout exécuter (Pipeline complet)"
    echo "10. Vérifier le statut des services"
    echo "11.rafraichir environment"
    echo "0. Quitter"
    echo "========================================================="
    read -p "Choisissez une option (0-9): " choice
    echo ""
    return $choice
}

# Fonction pour vérifier si un processus est en cours d'exécution
is_running() {
    local process_name=$1
    if pgrep -f "$process_name" > /dev/null; then
        return 0  # Running
    else
        return 1  # Not running
    fi
}

# Fonction pour vérifier le statut des services
check_status() {
    echo "Vérification du statut des services..."
    
    # Vérifier HDFS et YARN
    if jps | grep -q "NameNode"; then
        echo "✅ HDFS est en cours d'exécution"
    else
        echo "❌ HDFS n'est pas en cours d'exécution"
    fi
    
    if jps | grep -q "ResourceManager"; then
        echo "✅ YARN est en cours d'exécution"
    else
        echo "❌ YARN n'est pas en cours d'exécution"
    fi
    
    # Vérifier le générateur de logs
    if is_running "python.*generate_logs.py"; then
        echo "✅ Générateur de logs en cours d'exécution"
    else
        echo "❌ Générateur de logs arrêté"
    fi
    
    # Vérifier Flume
    if is_running "flume-ng"; then
        echo "✅ Agent Flume en cours d'exécution"
    else
        echo "❌ Agent Flume arrêté"
    fi
    
    # Vérifier si les répertoires HDFS existent
    echo "Contenu de HDFS:"
    hadoop fs -ls /user/$(whoami)/logs
}

# Fonction pour démarrer le pipeline complet
run_full_pipeline() {
    echo "Démarrage du pipeline complet d'analyse de logs..."
    
    # 1. Démarrer Hadoop
    echo "Étape 1: Démarrage de Hadoop..."
    bash ./hadoop-start-stop.sh start
    sleep 5
    
    # 2. Démarrer la génération de logs
    echo "Étape 2: Démarrage de la génération de logs..."
    python3 ./generate_logs.py > /dev/null 2>&1 &
    sleep 3
    
    # 3. Démarrer la collecte de logs avec Flume
    echo "Étape 3: Démarrage de la collecte de logs avec Flume..."
    bash ./start-flume.sh
    sleep 10
    
    # 4. Compiler le programme MapReduce
    echo "Étape 4: Compilation du programme MapReduce..."
    bash ./compile-mapreduce.sh
    sleep 2
    
    # 5. Attendre que les logs soient collectés
    echo "Attente de la collecte des logs (30 secondes)..."
    sleep 30
    
    # 6. Exécuter l'analyse MapReduce
    echo "Étape 5: Exécution de l'analyse MapReduce..."
    bash ./run-mapreduce.sh
    
    # 7. Configurer les tables Hive
    echo "Étape 6: Configuration des tables Hive..."
    bash ./setup-hive.sh
    
    # 8. Exécuter partiellement les requêtes d'analyse Hive
    echo "Étape 7: Exécution et analyse partielle des requêtes d'analyse Hive..."
    bash ./run-hive-analysis.sh
    
    # 9. Exécuter compeletement les requêtes d'analyse Hive
    echo "Étape 7: Exécution et analyse complet des requêtes d'analyse Hive..."
    bash ./execute-analysis.sh
    
    echo "Pipeline d'analyse de logs exécuté avec succès!"
}

# Boucle principale du menu
while true; do
    show_menu
    choice=$?
    
    case $choice in
        1)
            echo "Démarrage de Hadoop..."
            bash ./hadoop-start-stop.sh start
            ;;
        2)
            echo "Arrêt de Hadoop..."
            bash ./hadoop-start-stop.sh stop
            ;;
        3)
            echo "Démarrage de la génération de logs..."
            if is_running "python.*generate_logs.py"; then
                echo "Le générateur de logs est déjà en cours d'exécution."
            else
                python3 ./generate_logs.py > /dev/null 2>&1 &
                echo "Générateur de logs démarré avec PID $!"
            fi
            ;;
        4)
            echo "Démarrage de la collecte de logs avec Flume..."
            if is_running "flume-ng"; then
                echo "L'agent Flume est déjà en cours d'exécution."
            else
                bash ./start-flume.sh
            fi
            ;;
        5)
            echo "Exécution de l'analyse MapReduce..."
            bash ./compile-mapreduce.sh && bash ./run-mapreduce.sh
            ;;
        6)
            echo "Configuration des tables Hive..."
            bash ./setup-hive.sh
            ;;
        7)
            echo "Exécution et analyse partielle des requêtes d'analyse Hive..."
            bash ./run-hive-analysis.sh
            ;;
            
        8)
	    echo "Exécution et analyse complet des requêtes d'analyse Hive..."
	    bash ./execute-analysis.sh
	    ;;
        9)
            run_full_pipeline
            ;;
        10)
            check_status
            ;;
        11) 
            echo "refraichir environment"
            bash ./reset-environment.sh
            ;;
        0)
            echo "Sortie du programme..."
            exit 0
            ;;
        *)
            echo "Option invalide. Veuillez choisir une option entre 0 et 9."
            ;;
    esac
    
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
    clear
done
