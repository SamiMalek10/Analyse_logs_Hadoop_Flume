#!/bin/bash
# Configuration robuste et corrigée de Hive

echo "🔧 Début de la configuration Hive..."

# 1. Nettoyage et initialisation du metastore
echo "🧹 Nettoyage des métadonnées précédentes..."
rm -rf ~/opt/hive/metastore_db 2>/dev/null
rm -rf /tmp/hive 2>/dev/null

echo "🛠️ Initialisation du metastore Derby..."
$HIVE_HOME/bin/schematool -dbType derby -initSchema --verbose

# 2. Vérification des données HDFS
echo "📂 Vérification des données HDFS..."
hdfs dfs -ls /user/sami/logs/processed/*/
hdfs dfs -cat /user/sami/logs/processed/*/* | head -n 5

# 3. Création des tables avec le bon chemin
echo "💾 Création des tables Hive..."

cat > /tmp/hive_setup.hql <<EOF
-- Création de la base de données
CREATE DATABASE IF NOT EXISTS log_analysis;
USE log_analysis;

-- Table externe pointant vers le bon chemin (avec le sous-dossier daté)
CREATE EXTERNAL TABLE IF NOT EXISTS raw_logs (
    key STRING,
    value INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/user/sami/logs/processed/20250513_175100';

-- Vérification des données chargées
SELECT COUNT(*) FROM raw_logs;
EOF

# Exécution du script HQL
$HIVE_HOME/bin/hive -f /tmp/hive_setup.hql

# 4. Création des tables analytiques
cat > /tmp/hive_analytics.hql <<EOF
USE log_analysis;

-- Table pour les endpoints
CREATE TABLE IF NOT EXISTS endpoint_stats AS
SELECT
    regexp_extract(key, '^endpoint:(.*)\$', 1) AS endpoint,
    value AS count
FROM raw_logs
WHERE key LIKE 'endpoint:%';

-- Table pour les codes de statut
CREATE TABLE IF NOT EXISTS status_stats AS
SELECT
    regexp_extract(key, '^status:([0-9]+)\$', 1) AS status,
    value AS count
FROM raw_logs
WHERE key LIKE 'status:%';

-- Table pour les IPs
CREATE TABLE IF NOT EXISTS ip_stats AS
SELECT
    regexp_extract(key, '^ip:(.*)\$', 1) AS ip,
    value AS count
FROM raw_logs
WHERE key LIKE 'ip:%';

-- Vérification finale
SHOW TABLES;
SELECT * FROM endpoint_stats LIMIT 5;
EOF

# Exécution
$HIVE_HOME/bin/hive -f /tmp/hive_analytics.hql

echo "✅ Configuration terminée avec succès! Les tables sont prêtes."



