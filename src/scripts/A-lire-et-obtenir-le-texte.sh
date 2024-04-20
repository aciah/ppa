Lorsqu'on scanne un document, par exemple une lettre administrative, on obtient un document image jpg ou un pdf-image 
qu'on ne peut faire lire par un lecteur d'écran, qu'on ne peut pas modifier. Le script ci-dessous transforme les documents
en fichiers textes .txt et lance la lecture par espeak. Il fournit aussi le texte, permettant de réutiliser ce texte. 
La reconnaissaince OCR par Tesseract donne d'assez bons résultats. On peut régler le clavier pour lancer ce script avec la touche F8.

# ﻿#!/bin/sh
# VERSION 2.0
# AUTEUR  Jean-Yves ROCHER
# Modifications : ACIAH et Pierre Estrem, avril 2024
# NAME : Lecture à la volée
# DESCRIPTION : Script permettant la lecture en direct de fichiers images jpg, png, tif, pdf, doc, docx, odt.
# Dépendances : espeak, unoconv, pandoc, player.py et notre script conv-txt.sh
# Décommenter les deux lignes suivantes pour récupérer les log du script et les afficher en direct dans un terminal
# exec 1>>/var/log/aciah/lireALaVolee.log 2>>/var/log/aciah/lireALaVolee.log
# xterm -e "tail -f /var/log/aciah/lireALaVolee.log" &

 FICHIER=`basename $1`
 FILE=`basename ${FICHIER%.*}`
 CHEMIN=`dirname $1`
 REPLECTURE="$HOME"/Machine-a-lire
 TYPE=`mimetype -i -b $1`

aplay /usr/local/share/advl/beep.wav

######## Fichier de type doc  ############

if [ ! -z "`echo "$TYPE" | grep -i 'doc' `" ]; then
espeak -a 200 -v mb-fr1 -s 150 "patien tez"
fi
$HOME/.config/caja/scripts/conv-txt.sh "$1"


######### Fichier de type PDF   #########
mkdir $HOME/Machine-a-lire
 if [ ! -z "`echo "$TYPE" | grep -i 'pdf' `" ]; then
         pdftoppm -r 200 -tiff "$CHEMIN"/"$FICHIER" "$REPLECTURE"/alavolee
             for alavolee in "$REPLECTURE"/*.tif; do
tesseract "$alavolee" volee
x-terminal-emulator -e /usr/local/bin/player.py volee.txt
             done

mv volee.* ${1%\.*}.txt
rm $HOME/Machine-a-lire/alavolee*
fi
########  Fichier de type PNG ou JPG   #####
  if [ ! -z "`echo "$TYPE" | grep -i -e 'png' `" ]; then echo  
tesseract "$CHEMIN"/"$FICHIER" resul
x-terminal-emulator -e /usr/local/bin/player.py resul.txt
mv resul.txt ${1%\.*}.txt
  fi

  if [ ! -z "`echo "$TYPE" | grep -i -e 'jpeg' `" ]; then echo  
tesseract "$CHEMIN"/"$FICHIER" result
x-terminal-emulator -e /usr/local/bin/player.py result.txt
mv result.txt ${1%\.*}.txt
  fi


######## Fichier de type docx  ############

if [ ! -z "`echo "$TYPE" | grep -i 'docx' `" ]; then
espeak -a 200 -v mb-fr1 -s 150 "patien tez"
fi
pandoc "$CHEMIN"/"$FICHIER"

espeak -a 200 -v mb-fr1 -s 130 "lecture termi née"

######## Fichier de type odt  ############

if [ ! -z "`echo "$TYPE" | grep -i 'odt' `" ]; then
espeak -a 200 -v mb-fr1 -s 150 "patien tez"
fi
odt2txt "$CHEMIN"/"$FICHIER"

espeak -a 200 -v mb-fr1 -s 130 "lecture termi née"

exit 0
