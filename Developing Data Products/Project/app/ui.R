library(shiny)
library(maptools)
library(leaflet)
library(ggthemes)

source("utils.R")

exploratoryPanel = sidebarLayout(
  sidebarPanel(
    selectInput("var", 
                label = c("Choose a variable to display"),
                choices = varNames),
    p("To create a marginalization index click the 'Create Index' tab. "),
    p("To cluster states by similarity click the 'Clusterize' tab. ")
    
  ),
  mainPanel(
    h3(textOutput("mapCaption")),
    leafletOutput("map")
  )
)


indexPanel = sidebarLayout(
  sidebarPanel(
    p("Now we are going to create an marginalization index. This is a single number for each state that summarizes its marginalization variables."),
    p("A common way to do this is to perform a principal component analysis and use the first component as the index."),
    
    checkboxGroupInput("pcaVars", 
                label = c("Select variables to include in the index"),
                choices = varNames,
                selected = varNames)
  ),
  mainPanel(
    h3("Marginalization Index"),
    leafletOutput("indexMap")
  )
)

clusteringPanel = sidebarLayout(
  sidebarPanel(
    p("Now we are going to group states into groups. The objective is to make groups such that states in the same group are more similar to each other than to those in other groups."),
    p("The clustering algorithm that we are going to use is k-means."),
    
    selectInput("numClust", 
                       label = c("Choose the desired number of clusters"),
                       choices = 1:7,
                       selected = 3)
  ),
  mainPanel(
    h3("State groups"),
    leafletOutput("clusterMap")
  )
)

ui <- fluidPage(
  titlePanel("Marginalization in Mexico"),
  tabsetPanel(type = "tabs", 
              tabPanel("Explore", exploratoryPanel),
              tabPanel("Create Index", indexPanel),
              tabPanel("Clusterize", clusteringPanel)
  )
  
)


# c("% Of illiterate population above 15 years old",
#   "% Of population above 15 years old without elementary school",
#   "% Occupants in dwellings without drainage or toilet",
#   "% Occupants in dwellingss without electricity",
#   "% Occupants in dwellings without piped water",
#   "% Overcrowded dwellings",
#   "% Occupants in dwellingss with dirt floor",
#   "% Population in towns with less than 5000 inhabitants",
#   "% Employed population with an income less than 2 minimum wages")