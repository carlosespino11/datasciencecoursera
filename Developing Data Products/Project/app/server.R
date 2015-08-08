library(shiny)
library(leaflet)
library(dplyr)
library(caret)

source("utils.R")

data_sets = read_data()
data = data_sets$data
poly = data_sets$map

server <- function(input, output, session) {

  index = reactive({
    pcaData = data[,names(data) %in% input$pcaVars]
    index_pca = preProcess(pcaData)
    predict(index_pca, pcaData)[[1]]

  })
  
  clustering = reactive({
    clust = kmeans(data %>% select(illiteracy:min_wage), input$numClust)
  })
  
  output$mapCaption = renderText(varMap[[input$var]])
  output$map = renderLeaflet({
    mapDrawer(poly,data[,input$var], "" ,labelFormat(suffix = "%")) 
  })

  output$indexMap = renderLeaflet({
    mapDrawer(poly,index(), "index" ,labelFormat()) 
  })
  
  output$clusterMap = renderLeaflet({
    mapDrawer(poly, clustering()$cluster, legendTitle = "group", pallete = factpal)
  })
}




  
  
# c("illiteracy", "elem_school", "drainage_wc", "electricity", "piped_water",
#   "overcrowding", "dirt_floor", "small_towns", "min_wage", "marginalization_iindex")
# 
# variable = switch(input$var,
#                   "% Of illiterate population above 15 years old" = data$illiteracy,
#                   "% Of population above 15 years old without elementary school" = data$elem_school,
#                   "% Occupants in dwellings without drainage or toilet" = data$drainage_wc,
#                   "% Occupants in dwellingss without electricity" = data$electricity,
#                   "% Occupants in dwellings without piped water" = data$piped_water,
#                   "% Overcrowded dwellings" = data$overcrowding,
#                   "% Occupants in dwellingss with dirt floor" = data$dirt_floor,
#                   "% Population in towns with less than 5000 inhabitants" = data$small_towns,
#                   "% Employed population with an income less than 2 minimum wages" = data$min_wage)