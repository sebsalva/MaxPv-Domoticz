-- Doc API MaxPV https://github.com/Jetblack31/MaxPV version 3.32
--API /api/get?data=XX lecture data de fonctionnement
--XX
--01 : tension secteur
--02 : courant mesuré par la pince ampèremétrique
--03 : puissance active
--04 : puissance apparente
--05 : puissance routée
--06 : puissance importée
--07 : puissance exportée
--08 : cosinus phi
--09 : index du compteur d’énergie routée (en kWh)
--10 : index du compteur d’énergie importée (en kWh)
--11 : index du compteur d’énergie exportée (en kWh)
--12 : index du compteur d’énergie produite (compteur à impulsion en kWh)
--13 : puissance produite (lié au compteur à impulsion)
--14 : mode de fonctionnement du SSR (0 = STOP, 1 = FORCE, 9 = AUTO)
--15 : mode de fonctionnement du relais (0 = STOP, 1 = FORCE, 9 = AUTO)
--16 : délai minimal de déclenchement du SSR (ms)
--17 : délai moyen de déclenchement du SSR (ms)
--18 : délai maximal de déclenchement du SSR (ms)
--19 : tension de point milieu (Vbias)
--20 : byte de statut/erreurs (en binaire)
--// Signification des bits
--(0 = LSB bit de droite, 7 = MSB bit de gauche)
--// bits 0..3 : informations
--bit 0: Routage en cours
--bit 1: Commande de routage à 100 %
--bit 2: Relais secondaire de délestage activé
--bit 3: Exportation d'énergie
--// bits 4..7 : erreurs
--bit 4: Anomalie signaux analogiques : ADC I/V overflow, biasOffset
--bit 5: Anomalie taux d'acquisition
--bit 6: Anomalie furtive Détection passage à 0 (bruit sur le signal)
--bit 7: Anomalie majeure Détection passage à 0
--21 : durée de fonctionnement du routeur (jjj:hh:mm:ss)
--22 : nombre d’échantillons par secondes traités
--23 : référence du jour pour l’index journalier d’énergie routée (kWh)
--24 : référence du jour pour l’index journalier d’énergie importée (kWh)
--25 : référence du jour pour l’index journalier d’énergie exportée (kWh)
--26 : référence du jour pour l’index journalier d’énergie produite (kWh)
--/api/action?xxxx 
--booston : mise en marche du mode BOOST
--boostoff : arrêt du mode BOOST
--------------------------------
-- variable à éditer ------
local debugging = false --true pour voir les logs dans la console log Dz ou false pour ne pas les voir
local adrRouteur = '192.168.1.17' --adr IP du routeur@
local Energie = 'maison' -- Compteur Energie Consommée
local idxCptEnergie = 12153 -- laisser à 0 si non utilisé
local EnergieRoute = 'Routeur_EnergieRoute' -- Compteur Energie Routée
local idxCptEnergieRoute = 12152 -- laisser à 0 si non utilisé
local EnergiePv = 'Routeur_Pv' -- Compteur Energie Produite, compteur d'impulsion
local idxCptPv = 0 -- laisser à 0 si non utilisé
local EnergieExp = 'Routeur_Export' -- Compteur Energie Exportée
local idxCptExp = 0 -- laisser à 0 si non utilisé
local modeSSR = 'Routeur_SSR' -- Selecteur pour commander le SSR via MaxPV
local modeRelais = 'Routeur_Relais' -- Selecteur pour commander le relais via MaxPV
local EtatSSR ='Etat_SSR' -- Interupteur d'état du SSR 
local EtatRelais='Etat_Relais' -- Interupteur d'état du Relais
-- fin variable à éditer
--------------------------------
local index=-1
local delay=5
--------------------------------
--fonction d'affichage de Logs
function see_logs (s)
    if (debugging) then 
        print ('PvRouter LOG '..s);
    end
    return
end	
-- fonction de split par séparateur
function mysplit (inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   local t={}
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
   end
   return t
end
-- Fonction de mise à jour Compteur Energie
function update(device, id, power, energy)
-- affiche les Wh négatifs en cas d'injection. Decommenter pour rester à 0wh
    --if power < 0 then
     --   power=0
    --end
    index=index+1
    energy=tonumber(energy)*1000
    commandArray[index] = {['UpdateDevice'] = id .. "|0|" .. power .. ";" .. energy}
    return
end
--fonction time difference
function timediff (mode)
    s = otherdevices_lastupdate[mode]
    t1 = os.time()
    year = string.sub(s, 1, 4)
    month = string.sub(s, 6, 7)
    day = string.sub(s, 9, 10)
    hour = string.sub(s, 12, 13)
    minutes = string.sub(s, 15, 16)
    seconds = string.sub(s, 18, 19)
    t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
    return os.difftime (t1, t2)
end
--fonction change etat Interupteur SSR Relais
function ChangeState(statessr,staterelais,ch)
    -- mise à jour des etats des selecteurs dans domoticz (pour l'instant en attente)
    local modes = {
        ['0']=0;
        ['1']=10;
        ['9']=20;
        ['stop']='0';
        ['force']='1';
        ['auto']='9';
        };
local sEtatSSR =otherdevices[modeSSR];
local sEtatRelais =otherdevices[modeRelais];
if statessr~=modes[sEtatSSR] and timediff(modeSSR) >5*delay then
    commandArray[modeSSR]='Set Level '..modes[statessr];
    see_logs('SSR changing state: '..statessr);
end
if staterelais~=modes[sEtatRelais] and timediff(modeRelais) >5*delay then
    commandArray[modeRelais]='Set Level '..modes[staterelais];
    see_logs('Relais changing state old new: '..modes[sEtatRelais] .. staterelais);
end
if string.sub(ch,8,8) == '1' and otherdevices[EtatSSR]=='Off' then
    commandArray[EtatSSR]='On' 
elseif string.sub(ch,8,8) == '0' and otherdevices[EtatSSR]=='On' then
    commandArray[EtatSSR]='Off' 
end
if string.sub(ch,6,6) == '1' and otherdevices[EtatRelais]=='Off' then
    commandArray[EtatRelais]='On' 
elseif string.sub(ch,6,6) == '0' and otherdevices[EtatRelais]=='On' then
    commandArray[EtatRelais]='Off' 
end
end
-- fonction mise à jour Interrupteurs Relais et SSR dans Domoticz
function updaterouter(statessr,staterelay)
see_logs('Etat routeur modifié')
if statessr~=nil then
    index=index+1
    if statessr == 'boost' then
     commandArray[index] = {['OpenURL'] ='http://'..adrRouteur..'/api/action?booston'}
    else 
    commandArray[index] = {['OpenURL'] ='http://'..adrRouteur..'/api/set?ssrmode&value='..statessr}
    end
end
if staterelay~=nil then
    index=index+1
    commandArray[index] = {['OpenURL'] ='http://'..adrRouteur..'/api/set?relaymode&value='..staterelay}
end
end
commandArray = {}
--selecteur selectionné ?
if devicechanged[modeSSR] or devicechanged[modeRelais] then 
    updaterouter(devicechanged[modeSSR],devicechanged[modeRelais])
else
-- mise à jour toutes les delay secondes pour éviter une surcharge
time = os.date("*t")
if time.sec % delay == 0 then 
Cmd ='curl http://'..adrRouteur..'/api/get?alldata'
config=assert(io.popen(Cmd))
            ret = config:read('*all')
            config:close();
see_logs(ret)
tab=mysplit(ret,',')
if tab[20] == nil then 
    return
    end
if idxCptEnergie >0 then update(Energie, idxCptEnergie, tab[3], tab[10]) end
if idxCptEnergieRoute >0 then update(EnergieRoute, idxCptEnergieRoute, tab[5], tab[9]) end
if idxCptPv >0 then update(EnergiePv, idxCptPv, tab[13], tab[12]) end
if idxCptExp >0 then update(EnergieExp, idxCptExp, tab[7], tab[11]) end
ChangeState(tab[14],tab[15],tab[20])
end
end
return commandArray
