#!/bin/bash
#enregistrer les pièces jointes d'un message Thunderbird
#nécessite cd'avoir installé espeak et xdotool

amixer -q  -D pulse sset Master toggle # on coupe le haut-parleur mais on garde espeak
sleep 1
xdotool key Alt+m
sleep 1
xdotool key j
sleep 1
xdotool key t
sleep 1
xdotool key Alt+Home
sleep 1
amixer -q  -D pulse sset Master toggle # on rétablit le haut-parleur
espeak -a 200 -v mb-fr1 -s 150 "descendez sur un dossier. Et validez deux fois"

exit 0;

