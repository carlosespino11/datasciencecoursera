

read_data = function(){
  # poly = readShapePoly("states.shp", proj4string=CRS("+proj=longlat +no_defs +towgs84=0,0,0")) 
  poly = poly <- readLines("mx_states.json", warn = FALSE) %>%
    paste(collapse = "\n") %>%
    fromJSON(simplifyVector = FALSE)
  data = read.csv("marginalization_data.csv")
  data$state <- iconv(data$state, "windows-1252", "utf-8")
  # row.names(data) = row.names(poly)
  # poly = spCbind(poly, data %>% select(state:marginalization_iindex))
  
  list(data = data, map = poly)
}

pal <- function(measure){colorNumeric(
  palette = 'YlOrRd',
  domain = measure
)}

factpal <- function(measure){
  colorFactor(
    palette = tableau_color_pal(palette = "tableau10")(7), 
    measure)
}


mapDrawer = function(polygons, variable, legendTitle = "", labFormat = labelFormat(), pallete = pal) {
  color = pallete(variable)(variable)
  colorMap = data.frame(id = 1:32, color = color)
  
  polygons$objects$states$geometries  <- lapply(polygons$objects$states$geometries, function(feat) {
    feat$properties$style <- list(
      fillColor = (colorMap %>% filter(id == feat$properties$state_id))$color
    )
    feat
  })
  
  leaflet() %>%
    setView(lng = -103, lat = 25, zoom = 4) %>%
    addTiles() %>%
    addTopoJSON(polygons, stroke = TRUE, fillOpacity = 0.8, color = "black", weight=1) %>%
    addLegend(
      "topright", pal = pallete(variable), values = variable,
      title = legendTitle,
      labFormat = labFormat,
      opacity = 1
    )
}
mapDrawerPolygons = function(polygons, variable, legendTitle = "", labFormat = labelFormat(), pallete = pal) {
  leaflet(polygons) %>%
    addTiles() %>%
    addPolygons(
      stroke = TRUE, fillOpacity = 0.8, color = "black", weight=1,
      fillColor = ~pallete(variable)(variable)
    ) %>%
    addLegend(
      "topright", pal = pallete(variable), values = ~variable,
      title = legendTitle,
      labFormat = labFormat,
      opacity = 1
    )
  }
varNames =  c("Illiterate population" = "illiteracy",
              "Population w/o elementary school" = "elem_school",
              "Occupants in dwellings w/o drainage" = "drainage_wc",
              "Occupants in dwellings w/o electricity" = "electricity",
              "Occupants in dwellings w/o piped water" = "piped_water",
              "Overcrowded dwellings" = "overcrowding",
              "Occupants in dwellings w/ dirt floor" = "dirt_floor",
              "Population in small towns" = "small_towns",
              "Employed population with an income less than 2 min wages" = "min_wage")

varMap =  list("illiteracy" = "Illiterate population" ,
              "elem_school" = "Population w/o elementary school",
              "drainage_wc" = "Occupants in dwellings w/o drainage",
              "electricity" = "Occupants in dwellings w/o electricity",
              "piped_water" = "Occupants in dwellings w/o piped water",
              "overcrowding" = "Overcrowded dwellings",
              "dirt_floor" = "Occupants in dwellings w/ dirt floor",
              "small_towns" = "Population in small towns",
              "min_wage" = "Employed population with an income less than 2 min wages")
# varNames = c("Illiterate population",
#              "Population w/o elementary school" ,
#              "Occupants in dwellings w/o drainage",
#              "Occupants in dwellings w/o electricity",
#              "Occupants in dwellings w/o piped water",
#              "Overcrowded dwellings",
#              "Occupants in dwellings w/ dirt floor",
#              "Population in small towns",
#              "Employed population with an income less than 2 min wages")

