library(data.table)
library(ggvis)
flight<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/visualization-coding/coding/20popularityYear/topcarrier.csv",sep="\t")
carrier<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/carriers.csv",sep=",")
setnames(flight,old="X1987",new="year")
setnames(flight,old="NW",new="Code")
setnames(flight,old="X108273.0",new="visits")

flight<-as.data.table(flight)
carrier<-as.data.table(carrier)

flight$year<-NULL
flight<-flight[,.(visits=sum(visits)),.(Code)]
setkey(flight,Code)
setkey(carrier,Code)
flight<-merge(flight,carrier,by="Code")
flight<-flight[order(visits,decreasing=T)]
write.csv(flight,file="/home/perfectus/Desktop/btp/airline-dataset/visualization-coding/coding/20popularityYear/top29Carrier.csv",row.names=FALSE)
flight<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/visualization-coding/coding/20popularityYear/top29Carrier.csv",sep=",")


#topFlight<-flight[1:20]
flight$visits<-log10(flight$visits)
#which(topCities$city == 'San Diego')
all_values <- function(x) {
  x$visits<-10^x$visits
  if(is.null(x)) return(NULL)
  paste0(names(x), " : ", format(x), collapse = "<br />")
}

Description<-reorder(flight$Description,1/flight$visits)
base<-flight %>% ggvis(x=~visits, y=~Description, fill :="red") %>% layer_points() %>% add_axis("y", title = "") %>% add_axis("x", title = "Number of Visits (log10(m))")
base %>% add_tooltip(all_values, "hover")


