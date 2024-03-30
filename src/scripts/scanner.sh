#!/bin/bash
# auteur : association AXCIAH - mars 2024
# Licence : GPL v3
# Fonction : Scanner et Reconnaître - Mousepad
# Maintenance : <aciah@laposte.net>
# Shell : bash
# Nécessite les paquets espeak , scanimage, tesseract, player.py

aplay /usr/local/share/advl/beep.wav

espeak -a 150 -v mb-fr1 -s 130 "patientez un peu"

# on crée le dossier scan.
mkdir $HOME/scan
cd $HOME/scan

mv document_final4.txt document_final5.txt
mv image4.jpg image5.jpg
mv image4.pdf image5.pdf

mv document_final3.txt document_final4.txt
mv image3.jpg image4.jpg
mv image3.pdf image4.pdf

mv document_final2.txt document_final3.txt
mv image2.jpg image3.jpg
mv image2.pdf image3.pdf

mv document_final1.txt document_final2.txt
mv image1.jpg image2.jpg
mv image1.pdf image2.pdf

mv document_final.txt document_final1.txt
mv image.jpg image1.jpg
mv image.pdf image1.pdf

scanimage -x 210 -y 297 --format=tiff >$HOME/scan/image.tiff --resolution 200
sleep 2

tesseract image.tiff document_final

espeak -a 150 -v mb-fr1 -s 130 "le document ob tenu s'appelle : document_final.txt . Il s etrouve dans le dossier : Scan"

# l'ordinateur lit le document_final.txt en utilisant le fichier player.py
x-terminal-emulator -e /usr/local/bin/player.py $HOME/scan/document_final.txt

rm $HOME/scan/document_final.txt.*

# On transforme l'image tiff en image jpg et en pdf.
unoconv  -f jpg image.tiff
unoconv  -f pdf image.tiff
rm $HOME/scan/image.tiff

# on ouvre le dossier scan.
caja $HOME/scan
exit 0
