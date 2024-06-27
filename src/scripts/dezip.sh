#!/bin/bash
# script pour décompresser une archive. Voir une nouvelle version.
# on peut régler le clavier pour lancer ce script avec la touche F10.

aplay /usr/local/share/advl/beep.wav

File="$1"
Y="$(pwd)"
mkdir $HOME/Dossier-dezip
cp "$File" /home/aciah/Dossier-dezip       # si aciah est le nom du dossier personnel. Sinon remplace aciah par le user.

ZIPDIR=$HOME/Dossier-dezip
TMP=/tmp/zipfiles
cd "$ZIPDIR"
rm tmp/zipfiles 2>/dev/null

for i in ./*.zip; do
    dossier=${i::-4}
    mkdir "$dossier"
    unzip -o "$i" -d "$dossier" 
    subdirs=$(find "$dossier" -type d -printf ".\n" | wc -l)
    if [[ $subdirs -gt 1 ]]; then
        mv ./$dossier/*/* ./$dossier/*
    
#    rm /home/aciah/Dossier-dezip/*.zip

    fi
done

sleep 5
espeak -a 300 -v mb-fr1 -s 150 "le document ob tenu se trouve dans le Dossier-dezip"

rm /home/aciah/Dossier-dezip/*.zip

caja  /home/aciah/Dossier-dezip


