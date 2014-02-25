Mongo part en velib
===================

Ce projet pédagogique permet d'analyser l'évolution des stations Vélib à Paris en utilisant MongoDB. La récupération des données se fait via un script Bash, lancé chaque minute par cron, et l'analyse en R en utilisant le package RMongo.

Il est ìnstallable via crontab.e, puis il faut rajouter le fichier jcdecaux.sh à cron.

```
./install.sh
sudo crontab -e
echo export cleAPI=votrecle >> ~/.profile
```

Les données sont récupérées sur le site http://developer.jcdecaux.com/ via l'API opendata temps-réel. Elles sont stockées sur un serveur amazon EC2 micro. Chaque entrée décrit une station, avec ses coordonnées géographiques wgs84 et postales, son status, son nombre de vélos présents et de places disponibles. Un exemple d'entrée est 

```
{
  "number": 123,
  "contract_name" : "Paris",
  "name": "nom station",
  "address": "adresse indicative",
  "position": {
    "lat": 48.862993,
    "lng": 2.344294
  },
  "banking": true,
  "bonus": false,
  "status": "OPEN",
  "bike_stands": 20,
  "available_bike_stands": 15,
  "available_bikes": 5,
  "last_update": <timestamp>
}
```

Nous avons placé des index géographiques bidomensionnels pour la position, et pour l'update. Nous n'avons cependant pas utilisé ces indexs pour l'analyse ici présente.

Nous avons effectué quelques traitements simples :

* Evolution du nombre de vélib à une stations 
* Cartographie des caractéristiques des stations :
  + Ouvertes ou fermées ;
  + Vides, pleines ou entièrement disponibles :
  + Taux de remplissage des stations.

Les résultats sont dans le dossier results/.

Matthieu Bizien, Mathilde Didier et Jean-Marie John-Mathews
