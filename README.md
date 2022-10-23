# MaxPv-Domoticz
A Lua script for Domoticz servers allowing to control MaxPv

### Script Lua pour Domoticz qui permet de contrôler le Routeur Solaire MAxPv (https://github.com/Jetblack31/MaxPV). Précisemment, ce script permet :
* l'affichage de l'énergie consommée (Wh)
* l'affichage de l'énergie routée
* l'affichage de l'état du relais SSR
* l'affichage de l'état du relais tout ou rien
* de modifier le fonctionnement du routeur pour le SSR
* de modifier le fonctionnement du routeur pour le relais

Le script peut ensuite être complété de façon identique pour afficher la production, les erreurs, le voltage, etc.

### Commencez par créer :
* au moins 2  capteurs virtuels Energie (Electrique (Instantané+Compteur)) et notez leurs noms et Idx. Il vous faut un Compteur Energie Consommée, un Compteur Energie Routée, et eventuellement un Compteur Energie Produite via le compteur d'impulsion et un Compteur Energie Exportée.
![Capteur virtuel Energie](https://raw.githubusercontent.com/sebsalva/MaxPv-Domoticz/main/fig/energie.png)

* 2 Interrupteurs virtuels
* 2 bouttons selecteurs pour commander le routeur : important il faut ajouter les levels "stop", "force" et "auto" en miniscule comme sur la copie d'écran

![Capteur virtuel Energie](https://raw.githubusercontent.com/sebsalva/MaxPv-Domoticz/main/fig/selecteur.png)

![Capteur virtuel Energie](https://raw.githubusercontent.com/sebsalva/MaxPv-Domoticz/main/fig/selecteur2.png)

* Importez le script dans Evennements. Le script est de type device. Puis modifiez les variables à éditer
![Capteur virtuel Energie](https://raw.githubusercontent.com/sebsalva/MaxPv-Domoticz/main/fig/code.png)


Voilà, vous pouvez maintenant contrôler MaxPv depuis votre serveurDomoticz !
