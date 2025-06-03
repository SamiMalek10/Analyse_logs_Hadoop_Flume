# Projet d'Analyse des Données de Logs avec Hadoop et Flume

Ce projet implémente un pipeline complet pour collecter, stocker et analyser des données de logs à l'aide de technologies Big Data comme Hadoop, Flume et Hive. Il démontre comment transformer des données non structurées (logs) en informations exploitables.

## Architecture du Projet
[Log Generator] → [Flume] → [HDFS] → [MapReduce] → [Hive] → 📊 [Excel Results]

Le pipeline de données comprend les étapes suivantes :
1. **Génération de logs** - Simulation de logs d'une application web
2. **Collecte de logs** - Utilisation de Flume pour capturer et transférer les logs
3. **Stockage** - Utilisation de HDFS pour stocker les logs bruts
4. **Traitement** - Utilisation de MapReduce pour analyser les logs
5. **Analyse** - Utilisation de Hive pour permettre des requêtes SQL sur les données

## Prérequis

- Une machine virtuelle Ubuntu (18.04 ou plus récente)
- Java 8 ou supérieur
- Minimum 4 Go de RAM et 20 Go d'espace disque

## Installation

1. Clonez ce dépôt ou téléchargez et extrayez les fichiers dans votre VM Ubuntu
2. Rendez tous les scripts exécutables :
   ```bash
   chmod +x *.sh
   ```
3. Exécutez le script d'installation pour installer tous les composants nécessaires :
   ```bash
   ./installation.sh
   ```

Ce script installera Hadoop, Flume et Hive avec les configurations appropriées.

## Configuration de l'environnement

1. Configurez Hadoop en mode pseudo-distribué :
   ```bash
   ./hadoop-config.sh
   ```

2. Assurez-vous que tous les fichiers de configuration sont correctement configurés :
   - `weblog-flume.conf` : Configuration de l'agent Flume
   - Les fichiers XML de configuration Hadoop dans `$HADOOP_HOME/etc/hadoop/`

## Démarrage du Pipeline

Vous pouvez démarrer chaque composant individuellement ou exécuter le pipeline complet :

### Option 1 : Pipeline complet automatisé

Exécutez le script principal qui orchestre tout le pipeline :
```bash
./start-log-analysis.sh
```

Ensuite, choisissez l'option 8 dans le menu pour exécuter le pipeline complet.

### Option 2 : Démarrage manuel étape par étape

1. Démarrez Hadoop :
   ```bash
   ./hadoop-start-stop.sh start
   ```

2. Lancez le générateur de logs simulés :
   ```bash
   python3 generate_logs.py &
   ```

3. Démarrez l'agent Flume pour collecter les logs :
   ```bash
   ./start-flume.sh
   ```

4. Compilez le programme MapReduce :
   ```bash
   ./compile-mapreduce.sh
   ```

5. Exécutez l'analyse MapReduce une fois que suffisamment de logs ont été collectés :
   ```bash
   ./run-mapreduce.sh
   ```

6. Configurez les tables Hive :
   ```bash
   ./setup-hive.sh
   ```

7. Exécutez les requêtes d'analyse Hive :
   ```bash
   ./run-hive-analysis.sh
   ```

## Exploration des Données

Après avoir exécuté le pipeline, vous pouvez explorer les données de différentes manières :

### Exploration directe des logs bruts dans HDFS
```bash
hadoop fs -ls /user/$USER/logs/raw/
hadoop fs -cat /user/$USER/logs/raw/YYYY/MM/DD/weblogs*.log | head -n 10
```

### Visualisation des résultats MapReduce
```bash
hadoop fs -ls /user/$USER/logs/processed/
hadoop fs -cat /user/$USER/logs/processed/*/part-r-00000 | head -n 20
```

### Exploration avec Hive
1. Lancez la CLI Hive :
   ```bash
   $HIVE_HOME/bin/hive
   ```

2. Exécutez des requêtes Hive :
   ```sql
   USE log_analysis;
   SHOW TABLES;
   SELECT * FROM page_trends LIMIT 10;
   ```

3. Vous pouvez également exécuter directement les requêtes du fichier `analyze-logs.hql` :
   ```bash
   $HIVE_HOME/bin/hive -f analyze-logs.hql
   ```

## Arrêt du Pipeline

Pour arrêter tous les services en cours d'exécution :
```bash
./stop-pipeline.sh
```

## Dépannage

- **Problème** : "Connection refused" lors de la connexion à HDFS
  **Solution** : Vérifiez que le NameNode est en cours d'exécution avec `jps` et redémarrez HDFS si nécessaire

- **Problème** : Flume ne collecte pas les logs
  **Solution** : Vérifiez que le répertoire `/tmp/weblogs/` existe et que le fichier `access.log` y est présent

- **Problème** : L'analyse MapReduce échoue
  **Solution** : Vérifiez que le chemin d'entrée dans HDFS existe et contient des données avec `hadoop fs -ls`

## Structure des Fichiers

```
.
├── README.md                  # Ce fichier
├── installation.sh            # Script d'installation des composants
├── hadoop-config.sh           # Configuration de Hadoop
├── hadoop-start-stop.sh       # Gestion des services Hadoop
├── generate_logs.py           # Générateur de logs simulés
├── weblog-flume.conf          # Configuration de Flume
├── start-flume.sh             # Démarrage de l'agent Flume
├── LogAnalyzer.java           # Programme MapReduce
├── compile-mapreduce.sh       # Compilation du programme MapReduce
├── run-mapreduce.sh           # Exécution du job MapReduce
├── setup-hive.sh              # Configuration des tables Hive
├── analyze-logs.hql           # Requêtes d'analyse Hive
├── run-hive-analysis.sh       # Exécution des analyses Hive
├── start-log-analysis.sh      # Script principal d'orchestration
└── stop-pipeline.sh           # Arrêt de tous les services
```

## Technologies Utilisées

- **Hadoop** : Framework de traitement distribué
- **HDFS** : Système de fichiers distribué pour le stockage des logs
- **MapReduce** : Modèle de programmation pour le traitement des logs
- **Flume** : Service de collecte et d'agrégation de logs
- **Hive** : Entrepôt de données pour l'interrogation SQL

## Pour Aller Plus Loin

- Ajoutez d'autres sources de logs (serveurs multiples, applications différentes)
- Intégrez Spark pour des analyses plus rapides
- Ajoutez un tableau de bord de visualisation avec des outils comme Superset
- Implémentez la détection d'anomalies en temps réel

# English Short Description :
##  Key Features
 - Log Generation: Python-based simulator for realistic web logs.
 
 - Real-time Ingestion: Apache Flume agents to collect and transfer logs to HDFS.

 - Distributed Storage: Hadoop HDFS for fault-tolerant, scalable storage.

 - Batch Processing: MapReduce jobs to parse, filter, and aggregate logs.

 - SQL-like Analysis: Apache Hive for querying log data with familiar syntax.

## Tech Stack
 - Hadoop (HDFS + MapReduce)

 - Apache Flume (Data ingestion)

 - Apache Hive (Data warehousing)

 - Python (Log simulation)

## Sample Use Cases
 - Track page visit trends and user behavior.

 - Detect 404 errors or suspicious traffic patterns.

 - Generate daily/weekly reports (e.g., top visited pages).

## Quick Start
* Prerequisites: Ubuntu VM, Java 8+, 4GB RAM.

## Explore Results
 - Raw Logs: hadoop fs -cat /user/logs/raw/*

 - Processed Output: hadoop fs -cat /user/logs/processed/*/part-r-00000

 - Hive Queries: Predefined in analyze-logs.hql (e.g., session analysis).

## Future Enhancements
 - Integrate Spark for real-time analytics.

 - Add Superset/Grafana dashboards.

 - Extend to multi-node clusters.

# Why This Project?
✔ Hands-on learning for Big Data tools (Hadoop/Flume/Hive).
✔ Production-ready pipeline with automation scripts.
✔ Customizable for other log formats (e.g., IoT, APIs).
