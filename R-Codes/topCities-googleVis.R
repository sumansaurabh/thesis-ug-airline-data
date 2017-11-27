library(data.table)
library(googleVis)
flight<-read.csv("/home/perfectus/Documents/Rworkspace/topCities.csv",sep="\t",header = F)
airports<-read.csv("/home/perfectus/Documents/Rworkspace/airports.csv",sep=",")
setnames(flight,old="V1",new="year")
setnames(flight,old="V2",new="iata")
setnames(flight,old="V3",new="visits")

airports<-data.table(airports)
flight<-data.table(flight)

#topCities<-flight[,.(visits=sum(visits)),.(iata,year)]

setkey(flight,iata)
setkey(airports,iata)
topCities<-merge(flight,airports,by="iata")

topCities<-topCities[,.(Latitude=ave(lat),Longitude=ave(long),Population=sum(visits)),.(city)]
topCities<-unique(topCities)
topCities<-unique(topCities)

topCities<-topCities[order(-Population,increasing=T)]
t<-topCities[1:100]

t$city<-NULL
t$Population<-as.numeric(t$Population)
t$Population<-t$Population/15576481

saveRDS(t,"/home/perfectus/Mydata.Rds")
topCities<-topCities[,.SD[1:20],.(year)]
write.csv(t,file="/home/perfectus/Mydata.csv",row.names=F)


topCities$lat<-NULL
topCities$long<-NULL
p1<-ggplot(topCities, aes(x=year, y=visits, colour=city, group=city)) +
  geom_line() +
  ggtitle("Top Cities with Highest Traffic ")+
  xlab("")+ylab("Flights Traffic")+
  scale_x_continuous(breaks=c(1986:2009))

p1

Motion<-gvisMotionChart(topCities, 
                       idvar="city", 
                       timevar="year",options=list(width=1240, height=600))
plot(Motion)
