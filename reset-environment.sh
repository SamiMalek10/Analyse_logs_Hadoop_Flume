#!/bin/bash
echo "🧹 Nettoyage complet de l'environnement Hadoop / Hive / Flume..."

# === 1. Supprimer les bases de métastore Hive ===
echo "📁 Suppression du metastore Hive..."
rm -rf ~/opt/hive/metastore_db
rm -rf /tmp/hive
rm -rf /tmp/root/ 2>/dev/null

# === 2. Supprimer les fichiers HDFS ===
echo "🗑️ Suppression des données HDFS : raw, processed, tmp_input..."
hdfs dfs -rm -r -skipTrash /user/sami/logs/raw 2>/dev/null
hdfs dfs -rm -r -skipTrash /user/sami/logs/processed 2>/dev/null
hdfs dfs -rm -r -skipTrash /user/sami/logs/tmp_input 2>/dev/null

# === 3. Supprimer les anciens fichiers locaux si nécessaire ===
echo "📦 Nettoyage des fichiers locaux de compilation..."
rm -rf build lib input_files.txt_

