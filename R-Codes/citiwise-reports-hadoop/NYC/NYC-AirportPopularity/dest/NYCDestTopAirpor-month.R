#! /usr/bin/env Rscript
library(Rhipe)
rhinit()

map <- expression({
  # For each input record, parse out required fields and output new record:
  extractTop20 = function(line) {
    fields <- unlist(strsplit(line, "\\t"))
    # Skip header lines and bad records:
    if (length(fields) == 21) {
      desti <- fields[[16]]
      #print(desti)
      #destination <- fields[[16]]
     # Skip records where departure dalay is "NA":
      if (!(identical(desti, "NA"))) {
        # field[9] is carrier, field[1] is year, field[2] is month:
        rhcollect(paste(fields[[1]], "\t",fields[[2]], "\t", desti, sep=""), 1)
      }
      
    }
  }
  # Process each record in map input:
  lapply(map.values, extractTop20)
})


reduce <- expression(
  pre = {
    count <- numeric(0)
  },
  reduce = {
    # Depending on size of input, reduce will get called multiple times
    # for each key, so accumulate intermediate values in delays vector: 
    count <- c(count, as.numeric(reduce.values))
  },
  post = {
    # Process all the intermediate values for key:
   #key <- unlist(reduce.key)
   tot <- sum(count)
    #avg <- mean(delays)
    rhcollect(reduce.key, tot)            
  }
)


#mapred$rhipe_map_buff_size <- 15
input <-"/results/NYCDest/"
output <-"/results/NYC/Desti/TopAirport"
z <- rhwatch(
  map=map,
  reduce=reduce,
  combiner=TRUE,
  input=rhfmt(input, type="text"),
  output=rhfmt(output, type="text"),
  jobname='Top Desti Airport in NYC',
  mapred=list(mapred.reduce.tasks=2)
  #mapred=list(rhipe_map_buff_size=15)
  )


#counts <- rhread("/perfectus/topvolume")
counts <- rhread(paste(output, "/part-*", sep = ""), type = "text")
write(counts, file="NYCAirportDesti-month.csv")

