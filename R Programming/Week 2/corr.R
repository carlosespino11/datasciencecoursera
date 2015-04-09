corr <- function(directory, threshold = 0) {
  file_list <- list.files(directory)
  cors = lapply(file_list, function (file){
    data = read.csv(paste(directory, "/", file, sep = ""), header = T, na.strings = "NA")
    if(sum(complete.cases(data)) > threshold){
      cor(x = data$sulfate, y = data$nitrate, use ="complete.obs")      
    } else {
      9999
    }
  })
  unlist(cors[cors != 9999])
}