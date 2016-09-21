#+++++++++++++++++++++++++
# MAPA EXIT POLL
#+++++++++++++++++++++++++

library(shiny)
library(ggmap)
library(dplyr)
load("data/dfelec.RData")

shinyServer(function(input, output) {
  
  # Mapa de Zacatecas
  output$plotpart <- renderPlot({
    # Filtra la base por el partido seleccionado
    dfelec$pciento <- input$pciento
    dfpart <- switch(input$part,
                     TODOS = dfelec,
                     PAN_PRD = filter(select(dfelec, lon, lat, pan_prd, tvotos, pciento),
                                      pan_prd > pciento*tvotos/100),
                     PRI_PVEM_PANAL = filter(select(dfelec, lon, lat, pri_pvem_panal, tvotos, pciento),
                                             pri_pvem_panal > pciento*tvotos/100),
                     PT = filter(select(dfelec, lon, lat, pt, tvotos, pciento),
                                 pt > pciento*tvotos/100),
                     MORENA = filter(select(dfelec, lon, lat, morena, tvotos, pciento),
                                     morena > pciento*tvotos/100),
                     PES = filter(select(dfelec, lon, lat, pes, tvotos, pciento),
                                  pes > pciento*tvotos/100))
    # Obtiene el mapa estatico de Google
    region_map <- get_map(location = c(input$loclon, input$loclat), 
                          zoom = input$magnif, maptype = "roadmap")
    # Contruye grafico dependiendo de la opcion de partido
    if (input$part == "TODOS") {
      ggmap(region_map) +
        geom_point(aes(x=lon, y=lat, colour = factor(partido)), 
                   data = dfelec, alpha = .25, size = 3) +
        scale_color_manual(values=c("#E6E600", "#339900", "#FF0033",
                                    "#990000", "#660099")) +
        labs(x = "Longitud", y = "Latitud") +
        theme(legend.position = "top")
    } else {
      # Define atributos para burbujas
      map_zac <- ggmap(region_map, darken = c(.1,"white")) + 
        switch(input$part,
          PAN_PRD = geom_point(aes(x=lon, y=lat, size = pan_prd), 
                   data = dfpart, alpha = .25, colour = "#0000FF"),
          PRI_PVEM_PANAL = geom_point(aes(x=lon, y=lat, size = pri_pvem_panal), 
                           data = dfpart, alpha = .25, colour = "#339900"),
          PT = geom_point(aes(x=lon, y=lat, size = pt), 
               data = dfpart, alpha = .25, colour = "#FF0033"),
          MORENA = geom_point(aes(x=lon, y=lat, size = morena), 
                   data = dfpart, alpha = .25, colour = "#990000"),
          PES = geom_point(aes(x=lon, y=lat, size = pes), 
                data = dfpart, alpha = .25, colour = "#660099"))
      # Grafica mapa
      map_zac +
        labs(x = "Longitud", y = "Latitud") +
        theme(legend.position = "top")
    }
  })
    
})
