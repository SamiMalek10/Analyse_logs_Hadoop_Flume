#!/bin/bash
# Script pour compiler le programme MapReduce

# Créer un répertoire pour la compilation
mkdir -p build
mkdir -p lib

# Variables pour les dépendances Hadoop
HADOOP_CLASSPATH=$(hadoop classpath)

# Compiler le programme Java
echo "Compilation de LogAnalyzer.java..."
javac -cp $HADOOP_CLASSPATH -d build LogAnalyzer.java

# Créer un JAR
echo "Création du JAR..."
jar -cvf lib/log-analyzer.jar -C build .

echo "Compilation terminée. JAR disponible dans: lib/log-analyzer.jar"
