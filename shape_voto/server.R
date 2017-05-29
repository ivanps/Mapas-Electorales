library(shiny)
library(dplyr)
library(ggplot2)
# Resultados de la elección
load("data/dfelec.RData")
# Polígonos de las secciones electorales
load("data/secciones.RData")

#--------------------------------------------------------------------
# Función que genera el mapa electoral
mapaElectoral <- function(region = "Estado", id.region = "", relecc = dfelec, 
                          lpos="right") {
  # Filtra región del mapa a mostrar
  mapsecc <- switch(region,
        Estado = secciones,
        Distrito_Federal = filter(secciones, id_dtofed == id.region),
        Distrito_Local = filter(secciones, id_dtoloc == id.region),
        Municipio = filter(secciones, id_muni == id.region),
        Localidad = filter(secciones, id_loc == id.region))
  
  # Construye mapa temático
  ggplot(data=mapsecc, aes(map_id=id)) + 
    geom_map(map=mapsecc, fill="white", size=0.2) +
    expand_limits(x = mapsecc$long, y = mapsecc$lat) +
    geom_map(data=relecc, map=mapsecc, aes(fill=partido), size=0.2) +
    scale_fill_manual(values=c("#E6E600", "#339900", "#FF0033", "#990000", "#660099")) +
    coord_equal() + xlab("Longitud") + ylab("Latitud")
}

#----------------------------------------------------------------------
# Ejecución de la aplicación
shinyServer(function(input, output) {
    
    # Mapa de la región
    output$plotelec <- renderPlot({
      switch(input$op,
         "Estado" = mapaElectoral(),
         "Distrito_Federal" = mapaElectoral(region = input$op, id.region = input$iddfed),
         "Distrito_Local" = mapaElectoral(region = input$op, id.region = input$iddloc),
         "Municipio" = mapaElectoral(region = input$op, id.region = input$idmuni),
         "Localidad" = mapaElectoral(region = input$op, id.region = input$idloc)
      )
    })
    
    # Resultado de la votación en la región
    datasetOutput <- reactive({
      tbres <- switch(input$op,
          "Estado" = dfelec,
          "Distrito_Federal" = filter(dfelec, dtofed == as.numeric(input$iddfed)),
          "Distrito_Local" = filter(dfelec, dtoloc == as.numeric(input$iddloc)),
          "Municipio" = filter(dfelec, muni == as.numeric(input$idmuni)),
          "Localidad" = filter(dfelec, loc == input$idloc)
             )
      tbres <- as.data.frame(colSums(tbres[,3:8]))
      colnames(tbres) <- "Total"
      tbres$Porcentaje <- tbres$Total/sum(tbres$Total)*100
      return(tbres)
    })
    
    # Tabla de resultados
    output$tbelec <- renderTable({
      datasetOutput()
    }, rownames = TRUE)
    
})
