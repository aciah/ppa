#!/bin/sh
# requiert zenity, curl et scrot
# capture d'écran améliorée, envoie l'image à Photofiltre, Gimp ou Dessin.
# auteur : thuban@yeuxdelibad.net
# penser à bien contrôler les adresses aux lignes 18 - 21 et 24 ci-dessous.

IMAGE=~/capt-$(date +%d-%H-%M).png  #on envoie la capture à la racine

R=$(zenity --list --height=225 --text "Capture d'écran"\
    --radiolist --column "" --column "Capturer..." --print-column=2 \
    TRUE "1: ouvrir photofiltre" \
    FALSE "2: ouvrir gimp" \
    FALSE "3: ouvrir Dessin"\
    | cut -d':' -f1)
    
case $R in 
    1 ) #on envoie l'image vers photofiltre
        scrot $IMAGE -d 1 -s -e 'wine /opt/PhotoFiltre7/PhotoFiltre7.exe $f'
        ;;
    2 ) #on envoie l'image vers gimp
        scrot $IMAGE -d 1 -s -e 'gimp $f'
        ;;
    3 ) #on envoie l'image vers Dessin
        scrot $IMAGE -d 1 -s -e 'drawing $f'
        ;;
   
esac

exit 0

