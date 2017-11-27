library(data.table)
library(ggvis)
flight<-read.csv("C:/Users/Sunil/OneDrive/Documents/Rworkspace/topCities.csv",sep="\t")
airports<-read.csv("C:/Users/Sunil/OneDrive/Documents/Rworkspace/airports.csv",sep=",")
setnames(flight,old="X1987",new="year")
setnames(flight,old="AGS",new="iata")
setnames(flight,old="X1719.0",new="visits")

airports<-data.table(airports)
flight<-data.table(flight)

#topCities<-flight[,.(visits=sum(visits)),.(iata,year)]

setkey(flight,iata)
setkey(airports,iata)
topCities<-merge(flight,airports,by="iata")

topCities<-topCities[,.(visits=sum(visits),lat=ave(lat),long=ave(long)),.(city,year)]
topCities<-unique(topCities)
topCities<-topCities[order(year,-visits,increasing=T)]
topCities<-topCities[,.SD[1:20],.(year)]

topCities$visits<-log10(topCities$visits)
#which(topCities$city == 'San Diego')
all_values <- function(x) {
  x$visits<-10^x$visits
  if(is.null(x)) return(NULL)
  paste0(names(x), " : ", format(x), collapse = "<br />")
}
City<-factor(topCities$city)
City<-reorder(City,1/topCities$visits)
base<-topCities %>% ggvis(x=~visits, y=~City, fill :="red") %>% layer_points() %>% add_axis("y", title = "") %>% add_axis("x", title = "Number of Visits (log10(m))")
base %>% add_tooltip(all_values, "hover")

write.csv(topC,file="/home/perfectus/Desktop/btp/airline-dataset/visualization-coding/coding/20popularityYear/topOrderedCities.csv",row.names=FALSE)





