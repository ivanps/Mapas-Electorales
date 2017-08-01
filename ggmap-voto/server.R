library(shiny)
library(ggmap)
library(ggplot2)
library(dplyr)
# Polígonos de las secciones electorales
load("data/secciones.RData")

#--------------------------------------------------------------
# Función que genera mapa
mapaElectoral <- function(region, magnif) {
  # Colores PAN-PRD, PRI-PVEM-PANAL, PT, MORENA y PES
  colores <-c("#FFFF00", "#339900", "#FF0033","#990000", "#660099", "#999999")
  # Obtiene mapa estatico de Google
  region_map <- get_map(location = c(mean(region$long), mean(region$lat)), zoom = magnif, maptype = "roadmap")
  # Grafica el mapa con el shapefile
  ggmap(region_map) +
    geom_polygon(aes(x = long, y = lat, group = id, fill = partido), data = region, color="black", size=.1, alpha = .3) +
    scale_fill_manual(values=colores[table(region$partido) > 0]) +
    xlab("Longitud") + ylab("Latitud") + theme(legend.position = "top") 
}

#----------------------------------------------------------------
shinyServer(function(input, output) {
  
  mapaRegion <- reactive({
    # Filtra la region seleccionada
    mapsecc <- switch(input$op,
                      Estado = secciones,
                      Distrito_Federal = filter(secciones, id_dtofed == input$iddfed),
                      Distrito_Local = filter(secciones, id_dtoloc == input$iddloc),
                      Municipio = filter(secciones, id_muni == input$idmun),
                      Seccion = filter(secciones, id == input$idsecc),
                      Localidad = filter(secciones, id_loc == input$idloc))
    return(mapsecc)
  })
  
  # Selecciona un zoom appropiado para cada tipo de región
  zoomMapa <- reactive({
    # Establece nivel del zoom
    zm <- switch(input$op,
                 Estado = input$magnif1,
                 Distrito_Federal = input$magnif2,
                 Distrito_Local = input$magnif3,
                 Municipio = input$magnif4,
                 Localidad = input$magnif5,
                 Seccion = input$magnif6)
    return(zm)
  })
  
  # Mapa de la región
  output$plotelec <- renderPlot({
    mapaElectoral(region = mapaRegion(), magnif = zoomMapa())
  })
    
})
