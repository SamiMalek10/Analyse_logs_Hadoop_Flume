#!/bin/bash
# Script pour exécuter le job MapReduce sur les logs

# Date courante pour les logs d'entrée et le dossier de sortie
CURRENT_DATE=$(date +"%Y/%m/%d")
YESTERDAY_DATE=$(date -d "yesterday" +"%Y/%m/%d")

# Dossier d'entrée dans HDFS
INPUT_DIR="/user/$(whoami)/logs/raw/$CURRENT_DATE"
# Alternative: Utiliser les logs d'hier si nécessaire
# INPUT_DIR="/user/$(whoami)/logs/raw/$YESTERDAY_DATE"

# Dossier de sortie dans HDFS
OUTPUT_DIR="/user/$(whoami)/logs/processed/$(date +%Y%m%d_%H%M%S)"

echo "Vérification si des données sont disponibles dans $INPUT_DIR"
hadoop fs -ls $INPUT_DIR
if [ $? -ne 0 ]; then
    echo "Aucune donnée trouvée dans $INPUT_DIR"
    echo "Vérification des répertoires disponibles..."
    hadoop fs -ls /user/$(whoami)/logs/raw/
    echo "Veuillez spécifier un répertoire d'entrée valide avec des logs."
    exit 1
fi

echo "Exécution du job MapReduce..."
echo "Entrée: $INPUT_DIR"
echo "Sortie: $OUTPUT_DIR"

# Exécuter le job MapReduce
hadoop jar lib/log-analyzer.jar LogAnalyzer $INPUT_DIR $OUTPUT_DIR

# Vérifier que le job s'est terminé avec succès
if [ $? -eq 0 ]; then
    echo "Job MapReduce terminé avec succès!"
    echo "Résultats disponibles dans HDFS: $OUTPUT_DIR"
    echo "Affichage des premiers résultats:"
    hadoop fs -cat $OUTPUT_DIR/part-r-00000 | head -n 20
else
    echo "Le job MapReduce a échoué. Vérifiez les logs pour plus d'informations."
fi
