#!/bin/bash
 
MONGO=/usr/bin
HOME=/home/ubuntu
cleAPI=$(cleAPI)

#Attention: changer le contrat Toulouse par celui de votre ville
status=$(curl -w %{http_code} -s "https://api.jcdecaux.com/vls/v1/stations?contract=Toulouse&apiKey=${cleAPI}" -o $HOME/all_stations.json $1)
 
if [ $status -ne 200 ]
then
error_detail=$(cat $HOME/all_stations.json)
echo "[$(date +"%d-%m-%Y_%T")] [JCDecauxAPI] [ERROR] Message for status '$status': $error_detail"
else
echo "[$(date +"%d-%m-%Y_%T")] [JCDecauxAPI] [OK]"
 
mongoimport_status=$($MONGO/mongoimport --jsonArray -db velos -c stations --file $HOME/all_stations.json 2>&1)
 
if [[ "$mongoimport_status" == *"ERROR"* ]]
then
echo "[$(date +"%d-%m-%Y_%T")] [MONGODB] [ERROR] Failed on importing: $mongoimport_status"
else
echo "[$(date +"%d-%m-%Y_%T")] [MONGODB] [OK] ${mongoimport_status:(${#mongoimport_status} - 20)}"
fi
fi

