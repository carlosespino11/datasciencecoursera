pollutantmean <- function(directory, pollutant, id = 1:332) {
  add_zeros = function(i){
    paste(paste(rep(0, 3 - nchar(as.character(i))), collapse =""),i,sep="")
  }
  tables = lapply(id, function (x){
    read.csv(paste(directory, "/", add_zeros(x), ".csv",sep = ""), header = T, na.strings = "NA")
  })
  values = do.call(rbind, tables)
  
  mean(values[, names(values) %in% pollutant], na.rm =T)
}
