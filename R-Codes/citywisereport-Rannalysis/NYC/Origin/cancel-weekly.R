library(data.table)
library(googleVis)
library("ggplot2")
library(scales)

airport<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/citiwise-reports/NYC/NYC-CancellatioRate/Origin/weekly/NYCCancel-week.csv",sep="\t",header = F)
airport<-data.table(airport)
setnames(airport,"V1","year")
setnames(airport,"V2","day")

setnames(airport,"V3","iata")
setnames(airport,"V4","visits")

airportname<-read.csv("/home/perfectus/Desktop/btp/airline-dataset/rhipe-airlie/resultset/airports.csv",sep=",")
dayname<-read.csv("/home/perfectus/Documents/Rworkspace/week.csv",sep=",")
dayname<-data.table(dayname)
airportname<-data.table(airportname)
setkey(dayname,"day")
setkey(airport,"day")
airport<-merge(airport,dayname,by="day")

setkey(airport,"iata")
setkey(airportname,"iata")

port<-merge(airport,airportname,by="iata")
port<-port[order(-day,-year,visits,decreasing = T)]
#port$TimeLine <- as.Date(ISOdate(year = port$year,month = port$month,day = 1)) 

#M<-gvisMotionChart(data = port,timevar = "year2",idvar = "airport",xvar = "visits",yvar = "visits",options=list(width=1240, height=600))
#M<-gvisLineChart(data = port,xvar = "year",yvar = "visits",options=list(width=1240, height=600))
#plot(M)
#library("reshape2")

p1<-ggplot(port[which(port$year=="2008")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Flight Cancelled (Year 2008) ")+
  xlab("")+ylab("Cancelled Flights")
p1

p2<-ggplot(port[which(port$year=="2007")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2007")+
  xlab("")+ylab("")
p3<-ggplot(port[which(port$year=="2006")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2006")+
  xlab("")+ylab("")

p4<-ggplot(port[which(port$year=="2005")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2005")+
  xlab("")+ylab("")

p5<-ggplot(port[which(port$year=="2004")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2004")+
  xlab("")+ylab("")

p6<-ggplot(port[which(port$year=="2003")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2003")+
  xlab("")+ylab("")

p7<-ggplot(port[which(port$year=="2002")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2002")+
  xlab("")+ylab("")

p8<-ggplot(port[which(port$year=="2001")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2001")+
  xlab("")+ylab("")
p9<-ggplot(port[which(port$year=="2000")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 2000")+
  xlab("")+ylab("")
p10<-ggplot(port[which(port$year=="1999")], aes(x=reorder(dayname,day), y=visits, colour=airport, group=iata)) +
  geom_line() +
  ggtitle("Year 1999")+
  xlab("")+ylab("")
grid.arrange(p1,p2,p3,p4,p5,ncol = 1, main = "New York Weekly Cancellation Traffic")
grid.arrange(p6,p7,p8,p9,p10,ncol = 1, main = "New York Weekly Cancellation Traffic")



multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

multiplot(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,col=1,layout = matrix(5,5))
