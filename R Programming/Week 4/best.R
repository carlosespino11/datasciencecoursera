best <- function(state, outcome) {
  if(!file.exists("outcome-of-care-measures.csv")){
    download.file("https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip", "data.zip", method="curl")
    unzip("data.zip")
  }

  data = read.csv("outcome-of-care-measures.csv", colClasses = "character", na.strings = "Not Available")
  if(!(state %in% data$State))
    stop("invalid state")
  var_name = if(outcome == "heart attack"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  } else if (outcome == "heart failure"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  } else if (outcome == "pneumonia"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  } else {
    stop("invalid outcome")
  }
  filtered = data %>% select(var_name = one_of(var_name), State, Hospital.Name) %>% mutate(var_name = as.numeric(as.character(var_name))) %>% 
    filter(State == state) %>% 
    na.omit() %>% filter(var_name==min(var_name)) %>% arrange(Hospital.Name) %>% slice(1)
  
  
  
  filtered$Hospital.Name

}