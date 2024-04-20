#!/bin/sh
# Script qui convertit les fichiers sélectionnés en document txt
# script nécessaire pour notre script : A-lire-et-obtenir-le-texte
# nécessite le script player.py
# v.1.2
OLDIFS=$IFS
IFS=""

mkdir $HOME/Machine-a-lire/
File="$1" # $1 est le fichier passé en paramètre
Y="$(PWD)" # Les guillemets évitent la cata si ton répertoire courant comprenait 1 ou plusieurs espaces !
FILE=`basename ${File%.*}`
#TYPE=`mimetype -b $File`
File=`basename $File`

#réalise une conversion de $1 
for filename in $@; do
unoconv --doctype=document --format=txt  "${filename%\.*}.txt" "$1"
done
for filename in $@; do
unoconv --doctype=document --format=txt -o /home/aciah/Machine-a-lire/"${filename%\.*}.txt" "$filename"
done
sleep 1
x-terminal-emulator -e /usr/local/bin/player.py /home/aciah/Machine-a-lire/"${filename%\.*}.txt"
#rm -f -r $HOME/Machine-a-lire/
exit 0
