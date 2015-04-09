complete <- function(directory, id = 1:332) {
  values = data.frame(id = integer(0), nobs = integer(0))
  
  add_zeros = function(i){
    paste(paste(rep(0, 3 - nchar(as.character(i))), collapse =""),i,sep="")
  }
  tables = lapply(id, function (x){
    data = read.csv(paste(directory, "/", add_zeros(x), ".csv",sep = ""), header = T, na.strings = "NA")
    data.frame(id = x, nobs =sum(complete.cases(data)))
  })
  do.call(rbind, tables)
}
