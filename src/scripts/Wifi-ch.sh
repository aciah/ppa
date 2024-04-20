Script permettant de lancer une connexion wifi ou éthernet, au clavier et vocalisée si on a un lecteur d'écran.

#!/bin/bash
# Aide à la connexion 
# Version v1.0
# Auteur : Équipe Aciah et Christophe L.
# Licence GPL V3

export LC_ALL=C # Pourquoi cette commande, tout simplement pour la rendre universelle vis à vis de la langue du système

main ()

{
    dispo=$(nmcli dev | grep "wifi") # Vérification si on a bien une carte wifi
    if [ -n "$dispo" ]; then
        enable_disable_wifi 
     else
        echo "Aucune carte Wifi présente et disponible !"
        sleep 2
        exit 0  
    fi
}

Name_ssid ()

{
 SSID=`echo $(nmcli dev | grep "wifi") | rev | cut -d " " -f1 | rev`; 
 echo "Vous êtes maintenant connecté au réseau SSID : $SSID"; 
}


enable_disable_wifi ()

{
 # Je teste si j'ai une connexion ethernet dispo et active...si c'est le cas pas besoin de wifi...  

 ethernet_connected=$(nmcli dev | grep "ethernet" | grep -w "connected")
 if [ -n "$ethernet_connected" ]; then
        echo -e "Une connexion Ethernet est déjà active.\nLa connexion Wifi sera désactivée pour préserver l'autonomie."
        sleep 2
        nmcli radio wifi off
        
 else
	wifi_enabled=$(nmcli radio wifi | grep -w "disabled")      
	if [ -n "$wifi_enabled" ]; then
             echo "Activation du Wifi"
             #
             nmcli radio wifi on
             sleep 5
             if [ -n "$(nmcli dev | grep "wifi" | grep -w "connected")" ]; then
                  echo "Le wifi est activé"
                  Name_ssid
                  sleep 1
                  while true; do
    			read -p "Souhaitez-vous vous connecter à un autre Réseau Wifi O (Oui)/N (Non) ?" on
    			case $on in
        			[Oo]* ) nmtui-connect; Name_ssid ; break;;
        			[Nn]* ) exit 0;;
        			* ) printf "\033c"; echo "S'il vous plait, veuillez répondre par O (Oui)/N (Non).";;
    			esac
		 done
             else
                 echo -e "Le wifi est activé.\nVeuillez sélectionner votre réseau SSID dans la fenêtre suivante."
                 sleep 2
                 echo ""
                 read -rsp $'Frappez sur une touche pour continuer...\n' -n1 ke
                 nmtui-connect
                 echo "Le wifi est activé"
                 Name_ssid
                 sleep 2
             fi        
        else
            echo "Le Wifi est actuellement activé."
            if [ -n "$(nmcli dev | grep "wifi" | grep -w "connected")" ]; then
                 Name_ssid
            fi
            sleep 2
            
            while true; do
    		read -p "Souhaitez-vous vous connecter à un autre Réseau Wifi O (Oui)/N (Non) ou Désactiver le Wifi D (Désactiver) ?" ond
    		case $ond in
        		[Oo]* ) nmtui-connect; Name_ssid ; break;;
        		[Nn]* ) exit;;
        		[Dd]* ) echo "Désactivation du Wifi"; nmcli radio wifi off; break;;
        		* ) printf "\033c"; echo "S'il vous plait, veuillez répondre par O (Oui)/N (Non)/ D (Désactiver).";;
    		esac
	    done
            
        fi
 fi
 exit 0
}

########## main script ############
# cela efface le contenu de l'écran Terminal
printf "\033c"

main
exit 0
