#! /usr/bin/env Rscript
library(Rhipe)
rhinit()

map <- expression({
  # For each input record, parse out required fields and output new record:
  extractTop20 = function(line) {
    fields <- unlist(strsplit(line, "\\t"))
    # Skip header lines and bad records:
    if (length(fields) == 21) {
      #origin <- fields[[17]]
      #print(origin)
      origin <- fields[[15]]
     # Skip records where departure dalay is "NA":
      
        # field[9] is carrier, field[1] is year, field[2] is month:
        if(identical(origin,"6N5")||identical(origin,"6N7")||identical(origin,"JFK")||identical(origin,"JRA")||identical(origin,"JRB")||identical(origin,"LGA"))

        rhcollect(paste(fields[[1]], "\t", fields[[2]],"\t",fields[[3]], "\t",fields[[4]], "\t",fields[[5]], "\t",fields[[6]], "\t",fields[[7]], "\t",fields[[8]], "\t",fields[[9]], "\t",fields[[10]], "\t",fields[[11]], "\t",fields[[12]], "\t",fields[[13]], "\t",fields[[14]], "\t",fields[[15]], "\t",fields[[16]], "\t",fields[[17]], "\t",fields[[18]], "\t",fields[[19]], "\t",fields[[20]],sep=""), 1)
      
      
    }
  }
  # Process each record in map input:
  lapply(map.values, extractTop20)
})


reduce <- expression(
  pre = {
    #count <- numeric(0)
  },
  reduce = {
    # Depending on size of input, reduce will get called multiple times
    # for each key, so accumulate intermediate values in delays vector: 
    #count <- c(count, as.numeric(reduce.values))
  },
  post = {
    # Process all the intermediate values for key:
   #key <- unlist(reduce.key)
   #tot <- sum(count)
    #avg <- mean(delays)
    rhcollect(reduce.key, 1)            
  }
)


#mapred$rhipe_map_buff_size <- 15
input <-"/results/NYCDallasDetails/"
output <-"/results/NYCOrigin"
z <- rhwatch(
  map=map,
  reduce=reduce,
  combiner=TRUE,
  input=rhfmt(input, type="text"),
  output=rhfmt(output, type="text"),
  jobname='NYC Origin Details',
  mapred=list(mapred.reduce.tasks=2)
  #mapred=list(rhipe_map_buff_size=15)
  )


#counts <- rhread("/perfectus/topvolume")
counts <- rhread(paste(output, "/part-*", sep = ""), type = "text")
write(counts, file="NYCorigin.dat")

