best <- function(state, outcome) {
  data = read.csv("outcome-of-care-measures.csv", colClasses = "character")
  if(!(state %in% data$State))
    stop("invalid state")
  var_name = if(outcome == "heart attack"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  } else if (outcome == "heart falure"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  } else if (outcome == "pneumonia"){
    "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  } else {
    stop("invalid outcome")
  }
  filtered = data[,names(data) %in% var_name] %>% filter(State == state) 
  %>% group_by(var_name)
#   
#   by_state = data %>% filter(data, state)
#   filtered = data[ ,names(data) %in% paste("Hospital.30.Day.Death..Mortality..Rates.from.", outcome ,sep="")]
  ## Read outcome data
  ## Check that state and outcome are valid
  ## Return hospital name in that state with lowest 30-day death
  ## rate
}
best("AL", "heart attack")
