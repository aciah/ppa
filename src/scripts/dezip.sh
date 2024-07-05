#!/bin/bash
# # VERSION 1.0
# AUTHOR : association ACIAH
# Licence : GPL V3
# Modifications : Gérard Ruau (membre association ACIAH), 12 mai 2024
# NAME : dezip;sh 
# DESCRIPTION : script pour décompresser en utilisant une seule touche
# RACCOURCIS : ce script est placé dans le dossier $HOME/.config/caja/scripts
# et est appelé par le raccourci : F10 dans Caja et F12 dans Thunar (problème raxxourcis GTK !)

# Décommenter les deux lignes suivantes pour récupérer les log du script et les afficher en direct dans un terminal
#  exec 1>>/var/log/aciah/dezip.log 2>>/var/log/aciah/dezip.log
#  xterm -e "tail -f /var/log/aciah/dezip.log" &

aplay /usr/local/share/advl/beep.wav

FILE="$1"
Y="$(pwd)"
mkdir $HOME/Dossier-dezip

cp "$FILE" $HOME/Dossier-dezip

ZIPDIR=$HOME/Dossier-dezip
TMP=/tmp/zipfiles
cd "$ZIPDIR"
rm tmp/zipfiles 2>/dev/null

# Détermination de l'extension du fichier
FILE_PATH="$FILE"
FILENAME="$(basename $FILE_PATH)"
EXTENSION="${FILENAME##*.}"

#Extraction des fichiers en fonction des extensions
    if [ ! -z $EXTENSION ]
        then
            case $EXTENSION in

                #####pour les fichiers .zip
                zip)
                    for i in *.zip
                        do
                            DOSSIER=$(basename $FILE .zip)
                            mkdir "$DOSSIER"
                            unzip -o "$i" -d "$DOSSIER"
                            rm "$ZIPDIR"/*.zip
                        done
                ;;
                
                #####pour les fichiers .tar.gz
                gz)
                    for f in *.tar.gz
                        do
                            DOSSIER=$(basename $FILE .gz)
                            mkdir "$DOSSIER"
                            tar zxvf "$f" -C  "$ZIPDIR"
                            rm "$ZIPDIR"/*.tar.gz
                            rmdir "$ZIPDIR"/*.tar
                        done
                ;;
                    
                #####pour les fichiers .tar.bz2
                bz2)
                   for k in *.tar.bz2
                        do
                            DOSSIER=$(basename $FILE .bz2)
                            mkdir "$DOSSIER"
                            tar jxvf "$k" -C  "$ZIPDIR"
                            rm "$ZIPDIR"/*.tar.bz2
                            rmdir "$ZIPDIR"/*.tar
                        done
                ;;
                
                #####pour les fichiers non gérés ci-dessus : ouverture du gestionnaire d'archives => fonctionne mieux avec xarchiver
                *)
                    xarchiver --extract-to="$ZIPDIR" "$1"
                    #      file-roller "$1"
                    rm "$ZIPDIR"/"$FILENAME"
                ;;

            esac
    fi

sleep 3
# on peut modifier la vitesse, le timbre de voix ainsi que le volume de espeak, voir espeak --help dans un terminal
espeak -a 300 -v mb-fr1 -s 130 "le document ob tenu est dans le Dossier-dezip qui sera ouvert"
aplay /usr/local/share/advl/beep.wav
aplay /usr/local/share/advl/beep.wav
caja  $HOME/Dossier-dezip


############################################




#!/bin/bash
# script pour décompresser une archive. Version obsolète
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


