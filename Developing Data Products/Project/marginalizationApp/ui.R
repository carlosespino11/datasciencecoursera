library(shiny)
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


pcaPanel = sidebarLayout(
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

appPanel <- fluidPage(

  tabsetPanel(type = "tabs", 
              tabPanel("Explore", exploratoryPanel),
              tabPanel("Create Index", pcaPanel),
              tabPanel("Clusterize", clusteringPanel)
  )
  
)

overviewPanel <- fluidPage(
  mainPanel(
    tags$p(class="lead", "The purpose of this app is to make an analysis of social exclusion (marginalization) 
           in Mexico. Marginalization is defined as a social disadvantage and relegation to the fringe of society. 
           Social exclusion is the process in which individuals or entire communities of people are systematically 
           blocked from (or denied full access to) various rights, opportunities and resources that are normally 
           available to members of a different group, and which are fundamental to social integration within 
           that particular group."),
    tags$p(class="lead", "To make this analysis, we use some commonly used variables to measure marginalization. These are measured by state"),
    tags$p(class="lead", "The app has three panels:"),
    tags$ul(
      tags$li(tags$p(class="lead", tags$strong("Visualize"), "contains tools to visualize the marginalization variables in the map.")),
      tags$li(tags$p(class="lead", tags$strong("Create Index"), "contains tools to create a marginalization index using variables chosen by the user.")),
      tags$li(tags$p(class="lead", tags$strong("Clusterize"), "contains tools to cluster similiar states into groups."))
    ),
    tags$p(class="lead", "The variables used to measure marginalization in Mexico are:"),
    tags$ul(
      tags$li(tags$p(class="lead", "% Of illiterate population above 15 years old")),
      tags$li(tags$p(class="lead","% Of population above 15 years old without elementary school")),
      tags$li(tags$p(class="lead","% Occupants in dwellings without drainage or toilet")),
      tags$li(tags$p(class="lead","% Occupants in dwellingss without electricity")),
      tags$li(tags$p(class="lead", "% Occupants in dwellings without piped water")),
      tags$li(tags$p(class="lead","% Overcrowded dwellings")),
      tags$li(tags$p(class="lead",  "% Occupants in dwellingss with dirt floor")),
      tags$li(tags$p(class="lead","% Population in towns with less than 5000 inhabitants")),
      tags$li(tags$p(class="lead","% Employed population with an income less than 2 minimum wages"))
    ),
    tags$p(class="lead", tags$strong("Click on the 'App' button on the navigation bar to begin using the app."))
  )
)
  
ui <- navbarPage("Marginalization in Mexico",
  tabPanel("Overview", overviewPanel),
  tabPanel("App", appPanel)
)


