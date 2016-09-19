#+++++++++++++++++++++++++
# MAPA EXIT POLL
#+++++++++++++++++++++++++

library(shiny)
library(ggmap)
load("data/dfelec.RData")

shinyServer(function(input, output) {
  
  # Mapa de Zacatecas
  output$plotelec <- renderPlot({
    region_map <- get_map(location = c(input$loclon, input$loclat), 
                          zoom = input$magnif, maptype = "roadmap")
    ggmap(region_map) +
      geom_point(aes(x=lon, y=lat, colour = factor(partido)), 
                 data = dfelec, alpha = .25, size = 3) +
      scale_color_manual(values=c("#E6E600", "#339900", "#FF0033",
                                 "#990000", "#660099")) +
      labs(x = "Longitud", y = "Latitud") +
      theme(legend.position = "top")
  })
    
})
