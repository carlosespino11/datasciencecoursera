library(shiny)
library(leaflet)
library(dplyr)
library(caret)
library(jsonlite)

source("utils.R")


objects = read_data()
marg = objects$data
mex = objects$map

server <- function(input, output, session) {
  index = reactive({
    pcaData = marg[,names(marg) %in% input$pcaVars]
    index_pca = preProcess(pcaData)
    predict(index_pca, pcaData)[[1]]

  })
  
  clustering = reactive({
    set.seed(7)
    clust = kmeans(marg %>% select(illiteracy:min_wage), input$numClust)
  })
  
  output$mapCaption = renderText(varMap[[input$var]])
  
  output$map = renderLeaflet({
    mapDrawer(mex, marg[,input$var], "" ,labelFormat(suffix = "%")) 
  })

  output$indexMap = renderLeaflet({
    mapDrawer(mex, index(), "index" ,labelFormat()) 
  })
  
  output$clusterMap = renderLeaflet({
    mapDrawer(mex, clustering()$cluster, legendTitle = "group", pallete = factpal)
  })
}
