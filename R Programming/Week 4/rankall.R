rankall <- function(outcome, num = "best") {
  if(!file.exists("outcome-of-care-measures.csv")){
    download.file("https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip", "data.zip", method="curl")
    unzip("data.zip")
  }
  
  data = read.csv("outcome-of-care-measures.csv", colClasses = "character", na.strings = "Not Available")
  
  var_name = if(outcome == "heart attack"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  } else if (outcome == "heart failure"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  } else if (outcome == "pneumonia"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  } else {
    stop("invalid outcome")
  }
  
  select_row = function(num){
    if(num == "best") first()
    else if(num == "worst") last()
    else nth(num)
  }
  
  ldply(sort(unique(data$State)), function(state){
    filtered = data %>% dplyr::select(var_name = one_of(var_name), State, Hospital.Name) %>% 
      dplyr::mutate(var_name = as.numeric(as.character(var_name))) %>% 
      dplyr::filter(State == state) %>% 
      dplyr::arrange(var_name, Hospital.Name)
    
    hospital = unlist(if(num == "best") filtered %>% dplyr::slice(1) %>% dplyr::select(Hospital.Name)
           else if(num == "worst") filtered %>% dplyr::slice(nrow(filtered))%>% dplyr::select(Hospital.Name)
           else if(num > nrow(filtered)) NA
           else filtered %>% dplyr::slice(num) %>% dplyr::select(Hospital.Name)
    )
    data.frame(hospital = hospital, state = state)
  })
  
}
