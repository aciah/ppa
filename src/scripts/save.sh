#!/bin/bash
# script facilitant l'enregistrement d'un document LibreOffice Writer.
# le script crée le dossier A-attente.
# le document s'enregistre sous le nom a-classer..
# on peut ensuite reprendre ce document pour modifier son nom et le déplacer.

mkdir $HOME/A-attente
rm $HOME/A-attente/a-classer5.odt
sleep 1
mv $HOME/A-attente/a-classer4.odt $HOME/A-attente/a-classer5.odt
mv $HOME/A-attente/a-classer3.odt $HOME/A-attente/a-classer4.odt
mv $HOME/A-attente/a-classer2.odt $HOME/A-attente/a-classer3.odt
mv $HOME/A-attente/a-classer1.odt $HOME/A-attente/a-classer2.odt
mv $HOME/A-attente/a-classer.odt $HOME/A-attente/a-classer1.odt
xdotool key ctrl+shift+s
sleep 1
xdotool key Delete
sleep 1
#xdotool type "a-classer-document-du-$(date +%d-%m-%Hheures-%M)"
xdotool type $HOME/A-attente
sleep 1
xdotool key Return
sleep 1
xdotool key Alt+n
sleep 1
xdotool key Delete
sleep 1
xdotool type "a-classer"
sleep 2
xdotool key Return Return
sleep 1
espeak -a 200 -v mb-fr1 -s 150 "le document s'appelle : a-classer."
sleep 1
espeak -a 200 -v mb-fr1 -s 150 "il est dans le dossier A-attente."
caja $HOME/A-attente
