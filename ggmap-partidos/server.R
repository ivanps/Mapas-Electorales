library(shiny)
library(ggmap)
library(dplyr)
load("data/dfelec.RData")

shinyServer(function(input, output) {

  output$plotpart <- renderPlot({
    # Filtra la base por el partido seleccionado
    dfelec$pciento <- input$pciento
    dfpart <- switch(input$part,
                     TODOS = dfelec,
                     PAN_PRD = filter(select(dfelec, long, lat, pan_prd, tvotos, pciento),
                                      pan_prd > pciento*tvotos/100),
                     PRI_PVEM_PANAL = filter(select(dfelec, long, lat, pri_pvem_panal, tvotos, pciento),
                                             pri_pvem_panal > pciento*tvotos/100),
                     PT = filter(select(dfelec, long, lat, pt, tvotos, pciento),
                                 pt > pciento*tvotos/100),
                     MORENA = filter(select(dfelec, long, lat, morena, tvotos, pciento),
                                     morena > pciento*tvotos/100),
                     PES = filter(select(dfelec, long, lat, pes, tvotos, pciento),
                                  pes > pciento*tvotos/100))
    # Obtiene el mapa estático de Google
    region_map <- get_map(location = c(input$loclon, input$loclat), 
                          zoom = input$magnif, maptype = "roadmap")
    # Colores PAN-PRD, PRI-PVEM-PANAL, PT, PES, MORENA, C.IND y NR.
    colores <-c("#FFFF00", "#339900", "#FF0033", "#660099", "#990000", "#999999", "#FFFFFF")
    # Contruye grafico dependiendo de la opción de partido
    if (input$part == "TODOS") {
      ggmap(region_map) +
        geom_point(aes(x=long, y=lat, colour = factor(partido)), 
                   data = dfelec, alpha = .25, size = 3) +
        scale_color_manual(values=colores) +
        labs(x = "Longitud", y = "Latitud") +
        theme(legend.position = "top")
    } else {
      # Define atributos para burbujas
      map_zac <- ggmap(region_map, darken = c(.1,"white")) + 
        switch(input$part,
          PAN_PRD = geom_point(aes(x=long, y=lat, size = pan_prd), 
                   data = dfpart, alpha = .25, colour = colores[1]),
          PRI_PVEM_PANAL = geom_point(aes(x=long, y=lat, size = pri_pvem_panal), 
                           data = dfpart, alpha = .25, colour = colores[2]),
          PT = geom_point(aes(x=long, y=lat, size = pt), 
               data = dfpart, alpha = .25, colour = colores[3]),
          MORENA = geom_point(aes(x=long, y=lat, size = morena), 
                   data = dfpart, alpha = .25, colour = colores[5]),
          PES = geom_point(aes(x=long, y=lat, size = pes), 
                data = dfpart, alpha = .25, colour = colores[4]))
      # Grafica mapa
      map_zac +
        labs(x = "Longitud", y = "Latitud") +
        theme(legend.position = "top")
    }
  })
    
})
