#!/bin/bash
# Script d'installation des composants Hadoop pour le projet d'analyse de logs

echo "Installation des dépendances..."
sudo apt-get update
#sudo apt-get install -y openjdk-8-jdk wget curl openssh-server rsync

# Configuration Java
#echo "Configuration de Java..."
#echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
#source ~/.bashrc

# Téléchargement et installation de Hadoop
#echo "Installation de Hadoop..."
#wget https://downloads.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
#tar -xzf hadoop-3.3.4.tar.gz
#sudo mv hadoop-3.3.4 /usr/local/hadoop

# Configuration de Hadoop
#echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
#echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> ~/.bashrc
#echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >> ~/.bashrc
#source ~/.bashrc

# Téléchargement et installation de Flume
echo "Installation de Flume..."
wget https://downloads.apache.org/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz
tar -xzf apache-flume-1.11.0-bin.tar.gz
sudo mv apache-flume-1.11.0-bin /home/sami/opt/flume-1.11.0

# Configuration de Flume
echo "export FLUME_HOME=/home/sami/opt/flume-1.11.0" >> ~/.bashrc
echo "export PATH=\$PATH:\$FLUME_HOME/bin" >> ~/.bashrc
source ~/.bashrc

# Téléchargement et installation de Hive
#echo "Installation de Hive..."
#wget https://downloads.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
#tar -xzf apache-hive-3.1.3-bin.tar.gz
#sudo mv apache-hive-3.1.3-bin /usr/local/hive

# Configuration de Hive
echo "export HIVE_HOME=/home/sami/opt/hive" >> ~/.bashrc
echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> ~/.bashrc
source ~/.bashrc

# Nettoyage des archives téléchargées
rm apache-flume-1.11.0-bin.tar.gz

echo "Installation terminée!"
