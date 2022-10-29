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
* 2 bouttons selecteurs pour commander le routeur (SSR et Relais) : important il faut ajouter les levels "stop", "force", "auto" et "boost" en miniscule et dans cet ordre croissant comme sur la copie d'écran

![Capteur virtuel Energie](https://raw.githubusercontent.com/sebsalva/MaxPv-Domoticz/main/fig/selecteur.png)

![Capteur virtuel Energie](https://raw.githubusercontent.com/sebsalva/MaxPv-Domoticz/main/fig/selecteur2.png)

* Importez le script dans Evennements. Le script est de type device. Puis modifiez les variables à éditer. Exemple: 
```
-- variable à éditer ------
local debugging = false --true pour voir les logs dans la console log Dz ou false pour ne pas les voir
local adrRouteur = '192.168.1.17' --adr IP du routeur@
local Energie = 'Routeur_Energie' -- Compteur Energie Consommée
local idxCptEnergie = 12153 -- laisser à 0 si non utilisé
local EnergieRoute = 'Routeur_EnergieRoute' -- Compteur Energie Routée
local idxCptEnergieRoute = 12152 -- laisser à 0 si non utilisé
local EnergiePv = 'Routeur_Pv' -- Compteur Energie Produite, compteur d'impulsion
local idxCptPv = 0 -- laisser à 0 si non utilisé
local EnergieExp = 'Routeur_Export' -- Compteur Energie Exportée
local idxCptExp = 12200 -- laisser à 0 si non utilisé
local modeSSR = 'Routeur_SSR' -- Selecteur pour commander le SSR via MaxPV
local modeRelais = 'Routeur_Relais' -- Selecteur pour commander le relais via MaxPV
local EtatSSR ='Etat_SSR' -- Interupteur d'état du SSR 
local EtatRelais='Etat_Relais' -- Interupteur d'état du Relais
-- fin variable à éditer
--------------------------------
```

Voilà, vous pouvez maintenant contrôler MaxPv depuis votre serveurDomoticz !
