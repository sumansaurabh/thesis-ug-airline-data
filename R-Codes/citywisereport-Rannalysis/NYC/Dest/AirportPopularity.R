library(data.table)
library(googleVis)
airport<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/citiwise-reports/NYC/NYC-AirportPopularity/dest/NYCAirportDesti-month.csv",sep="\t")
airport<-data.table(airport)
setnames(airport,"X1988","year")
setnames(airport,"LGA","iata")
setnames(airport,"X9648.0","visits")
setnames(airport,"X1","month")


airportname<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/airports.csv",sep=",")
airportname<-data.table(airportname)

setkey(airport,"iata")
setkey(airportname,"iata")

port<-merge(airport,airportname,by="iata")
port<-port[order(-year,-month,visits,decreasing = T)]
port$TimeLine <- as.Date(ISOdate(year = port$year,month = port$month,day = 1)) 

#M<-gvisMotionChart(data = port,timevar = "year2",idvar = "airport",xvar = "visits",yvar = "visits",options=list(width=1240, height=600))
#M<-gvisLineChart(data = port,xvar = "year",yvar = "visits",options=list(width=1240, height=600))
#plot(M)
#library("reshape2")
library("ggplot2")
library(scales)

p1<-ggplot(port, aes(x=TimeLine, y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Growth curve for Flight Traffic")+
  scale_x_date(breaks = "1 year",minor_breaks = "1 month", labels=date_format("%Y"))
p1
