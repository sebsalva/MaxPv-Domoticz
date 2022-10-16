# MaxPv-Domoticz
A Lua script for Domoticz servers allowing to control MaxPv

### Script Lua qui permet :
* l'affichage de l'énergie consommée (Wh)
* l'affichage de l'énergie routée
* l'affichage de l'état du relais SSR
* l'affichage de l'état du relais tout ou rien
* de modifier le fonctionnement du routeur pour le SSR
* de modifier le fonctionnement du routeur pour le relais

Le script peut ensuite être compléter de façon identique pour afficher la production, les erreurs, le voltage, etc.

### Commencez par créer :
* 2 capteurs virtuels Energie et notez leurs noms et Idx
![Capteur virtuel Energie](https://raw.githubusercontent.com/sasa27/MaxPv-Domoticz/master/fig/energie.png)

* 2 Interrupteurs virtuels
* 2 bouttons selecteurs : important il faut ajouter les levels "stop", "force" et "auto" en miniscule comme sir la copie d'écran

![Capteur virtuel Energie](https://raw.githubusercontent.com/sasa27/MaxPv-Domoticz/master/fig/selecteur.png)

![Capteur virtuel Energie](https://raw.githubusercontent.com/sasa27/MaxPv-Domoticz/master/fig/selecteur2.png)

* Importez le script dans Evennements. Le script est de type device. Puis modifiez les variables à éditer
![Capteur virtuel Energie](https://raw.githubusercontent.com/sasa27/MaxPv-Domoticz/master/fig/code.png)


Voilà, vous pouvez maintenant contrôler MaxPv depuis votre serveurDomoticz !
