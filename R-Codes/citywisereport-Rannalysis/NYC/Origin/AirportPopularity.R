library(data.table)
library(googleVis)
airport<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/citiwise-reports/NYC/NYC-AirportPopularity/origin/NYCAirportOrigin.csv",sep="\t")
airport<-data.table(airport)
setnames(airport,"X1987","year")
setnames(airport,"JFK","iata")
setnames(airport,"X12273.0","visits")

airportname<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/airports.csv",sep=",")
airportname<-data.table(airportname)
setkey(airport,"iata")
setkey(airportname,"iata")

port<-merge(airport,airportname,by="iata")
port<-port[order(-year,visits,decreasing = T)]

M<-gvisMotionChart(data = port,timevar = "year",idvar = "airport",xvar = "visits",yvar = "visits",options=list(width=1240, height=600))
plot(M)
