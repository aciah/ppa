Ce script permet notamment de lancer la lecture d'un livre sonore, en utilisant VLC

#!/bin/sh

# VERSION 2.0
# Auteur : Association ACIAH - avril 2023
# Licence : GPL - v3

# MODIFICATIONS : Association ACIAH, Gérard Ruau  - juin 2024
#                 Simplifié le script en supprimant l'ouverture d'une fenêtre de Terminal et de variables non utilisées ;
#                 modifié la commande cvlc en svlc car lors de la fermeture avant la fin de la vidéo,
#                 le processus continuait de tourner
# NOM : D-lire-avec-VLC.sh
# DESCRIPTION : Script permettant de lire avec VLC

# RACCOURCIS : Ce script est placé dans le dossier $HOME/.config/caja/scripts
# et est appelé par le raccourci : F12
# 


# $1 est le fichier passé en paramètre
File="$1"

svlc --play-and-exit "$File"

exit 0

