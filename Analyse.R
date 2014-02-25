#{
#  "number": 123,
#  "contract_name" : "Paris",
#  "name": "nom station",
#  "address": "adresse indicative",
#  "position": {
#    "lat": 48.862993,
#    "lng": 2.344294
#  },
#  "banking": true,
#  "bonus": false,
#  "status": "OPEN",
#  "bike_stands": 20,
#  "available_bike_stands": 15,
#  "available_bikes": 5,
#  "last_update": <timestamp>
#}

library(RMongo)
library(rjson)
library(ggplot2)
library(jpeg)
library(grid)

plan <- readJPEG("C:/Users/Mathilde/Desktop/paris.jpg")


mongo <- mongoDbConnect("velos", "ec2-54-213-208-178.us-west-2.compute.amazonaws.com", 27017)
dbShowCollections(mongo)

data<-dbGetQuery(mongo, "stations", '{"contract_name" : "Paris"}',skip=0,limit=300000)
# limit=1000 par défaut


mpos<-data$position

data$lat<-mapply(function(a){pos<-fromJSON(a)
                              return(pos$lat)},mpos)
data$lng<-mapply(function(a){pos<-fromJSON(a)
                              return(pos$lng)},mpos)
rm(mpos)

data$available_prop<-0+data$available_bikes/data$bike_stands*(data$bike_stands!=0)
data$available_prop[data$available_prop>1]<-1

data$hour<-(data$last_update-1393282829000)/3600000
data$time<-(data$last_update-1393282829000)%/%60000 #update à la minute près

#evolution du nombre de vélibs disponibles dans la station 10025
data_10025<-data[data$number==10025,]
qplot(data_10025$hour,data_10025$available_bikes,xlab="temps(h)",ylab="nombre de vélos disponibles")
qplot(data_10025$hour,data_10025$available_prop,xlab="temps(h)",ylab="proportion de vélos disponibles")

## carte des disponibilités de vélos pendant la période choisie
qplot( lng, lat, data=data[data$hour>12 & data$hour<12.2,],color=available_prop, xlab="longitude",ylab="latitude")

##carte des stations fermées
data$c=(data$status=="CLOSED")*1
data_closed<-data[data$c==1,]
data_open<-data[data$c==0,]
ggplot(data,aes(x=lng,y=lat)) +
  geom_point(data=data[data$c==1,],aes(x = data$lng[data$c==1], y =data$lat[data$c==1]),colour='red') +
  geom_point(data=data[data$c==0,],aes(x = data$lng[data$c==0], y =data$lat[data$c==0]),colour='blue')



## carte des stations pleines et vides
data$c=(data$available_bikes==0)*1
data$d=(data$available_bike_stands==0)*1
data_empty<-data[data$c==1,]
data_full<-data[data$d==1,]
data_mid<-data[data$c==0 & data$d==0,]

datas<-data[data$hour>12 & data$hour<12.2,]

ggplot(datas,aes(x=lng,y=lat)) +
  geom_point(data=datas[datas$d==0 & datas$c==0,],aes(x = datas$lng[datas$d==0 & datas$c==0], y =datas$lat[datas$d==0 & datas$c==0]),colour='green')+
  geom_point(data=datas[datas$c==1,],aes(x = datas$lng[datas$c==1], y =datas$lat[datas$c==1]),colour='red') +
  geom_point(data=datas[datas$d==1,],aes(x = datas$lng[datas$d==1], y =datas$lat[datas$d==1]),colour='blue')

