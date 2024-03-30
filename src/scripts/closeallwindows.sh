#!/bin/bash
#Auteur :      Christophe L. et association ACIAH
#licence :     GNU General Public Licence v3
# Dépendances : wmctrl -> sudo apt-get install wmctrl
# Description : Fermeture de toutes les fenêtres ouvertes
#
#
BURO="Desktop"

case $LANG in
	fr*)
        BURO="Bureau"
        ;;

esac

### end trads

WIN_IDs=$(wmctrl -l | grep -vwE "($BURO)$|xfce4-panel$" | cut -f1 -d' ')
for i in $WIN_IDs; do 
    wmctrl -ic "$i";
done


# Keep checking and waiting until all windows are closed 
while [ $WIN_IDs ]; do 
    sleep 0.1; 
    WIN_IDs=$(wmctrl -l | grep -vwE "($BURO)$|xfce4-panel$" | cut -f1 -d' ')
done

exit 0
