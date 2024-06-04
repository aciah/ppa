# version de juin 2024

#!/bin/bash

# Version 1.2 - juin 2024
# Auteur : Aciah-octobre 2023
# Licence : GPL v3
# Modifications : Association ACIAH et Gérard Ruau (membre association ACIAH) 02/06/2024
# NAME : save.sh
# DESCRIPTION : Ce script essaie de simplifier l'enregistrement de documents LibreOffice.
# RACCOURCI : Ce script est placé dans le dossier /usr/local/bin

# Il y a des réglages préalables à faire : 
# - dans libre-office, faire : outils -> options -> général et décocher la ligne "utiliser les boites de dialogue libre-office" - cliquer ensuite sur Appliquer puis sur valider.
# - dans /usr/local/bin/myGtk*/TestMenu.txt  il faut préparer le raccourci 'A'

# On lance le script save.sh en faisant le menu : Alt + AltGr et la touche A, à condition d'avoir réglé cela dans le menu (voir ci-dessus).
# L'enregistrement du fichier se fait automatiquement dans le dossier '$HOME/A-attente'.
# On a tout le temps pour taper un nom de fichier et valider.
# Après validation, le gestionnaire de fichiers s'ouvre dans le dossier '$HOME/A-attente'.
# 

# Décommenter les deux lignes suivantes pour récupérer les log du script et les afficher en direct dans un terminal
#	exec 1>>/var/log/aciah/saveas.log 2>>/var/log/aciah/saveas.log
#   xterm -e "tail -f /var/log/aciah/saveas.log" &

#### Début du script
	aplay /usr/local/share/advl/beep.wav
	sleep 5

#### Les indications sont données au début du script car elles se superposent à Orca si elles sont placées à la fin
	espeak -a 200 -v mb-fr1 -s 130 "le fichier sera enregistré dans le dossier $HOME/A-attente"
	sleep 1
	espeak -a 200 -v mb-fr1 -s 130 "le dossier A-attente sera ouvert"	
	sleep 1
	espeak -a 200 -v mb-fr1 -s 130 "patientez"

#### Si le dossier $HOME/A-attente n'existe pas, on le crée
    if [ ! -d $HOME/A-attente ]
        then
            mkdir $HOME/A-attente
    fi

#### Ouverture de la fenêtre 'Enregistrer sous'
	xdotool key ctrl+shift+s
	sleep 1

#### Récupération du nom de la fenêtre (Enregistrer)
	nameloe=$(xdotool getactivewindow getwindowname)

#### Commandes pour aller dans le dossier '$HOME/A-attente'
	xdotool key Alt+n
	sleep 1
	xdotool key Delete
	sleep 1
	xdotool type $HOME/A-attente
	sleep 1
	xdotool key Return
	sleep 1

#### Commandes pour se situer au bon endroit afin de taper le nom du fichier
	xdotool key Shift+Tab
	sleep 1
	xdotool key Alt+n
	sleep 1
	xdotool key Delete # => pour compatibilité LibreOffice 24.x
	sleep 1
	espeak -a 200 -v mb-fr1 -s 130 "tapez le nom du fichier puis validez"

#### Commandes pour attendre la validation du nom du fichier et ouverture du gestionnaire de fichiers à la fermeture de la fenêtre 'Enregistrer sous'
#### La commande 'break' est là pour sortir d'une boucle infinie si non présente
	while :
		do
			if [ "$(xdotool getactivewindow getwindowname)" != "$nameloe" ]
				then
				espeak -a 200 -v mb-fr1 -s 130 "fin de l'enregistrement du fichier"
				sleep 2
				caja $HOME/A-attente
				break
			fi
		done

	exit 0












#########################################################################
# version d'avril 2024

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
