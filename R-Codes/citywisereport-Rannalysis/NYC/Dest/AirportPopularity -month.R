library(data.table)
library(googleVis)
airport<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/citiwise-reports/NYC/NYC-AirportPopularity/dest/NYCAirportDesti.csv",sep="\t")
airport<-data.table(airport)
setnames(airport,"X1987","year")
setnames(airport,"JFK","iata")
setnames(airport,"X12309.0","visits")

airportname<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/airports.csv",sep=",")
airportname<-data.table(airportname)
setkey(airport,"iata")
setkey(airportname,"iata")

port1<-merge(airport,airportname,by="iata")
port1<-port1[order(-year,visits,decreasing = T)]

M<-gvisMotionChart(data = port1,timevar = "year",idvar = "airport",xvar = "visits",yvar = "visits")
plot(M)
