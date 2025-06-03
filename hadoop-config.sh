#!/bin/bash
# Configuration de Hadoop en mode pseudo-distribué

# Configuration de SSH sans mot de passe
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# Test de la connexion SSH
ssh localhost "echo SSH fonctionne correctement"

