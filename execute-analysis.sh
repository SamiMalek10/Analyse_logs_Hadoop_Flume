#!/bin/bash
# execute-analysis.sh

# Vérification des dépendances
if [ -z "$HIVE_HOME" ]; then
    echo "❌ Variable HIVE_HOME non définie"
    exit 1
fi

# Exécution du script HQL
echo "🏃 Exécution des analyses..."
$HIVE_HOME/bin/hive \
    --hiveconf hive.cli.print.header=true \
    -f "/home/sami/Desktop/Analyse_logs_Hadoop_Flume/analyze-log.hql" \
    > "rapports/full_analysis_$(date +"%Y%m%d_%H%M%S").csv"

# Vérification
if [ $? -eq 0 ]; then
    echo "✅ Analyse complète terminée"
else
    echo "❌ Erreur lors de l'exécution"
    exit 1
fi


