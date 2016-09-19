#+++++++++++++++++++++++++
# MAPA DE PREFERENCIAS ELECTORALES
#+++++++++++++++++++++++++

library(shiny)
library(stringr)
library(dplyr)
library(scales)
library(ggplot2)
load("data/dbife.RData")
load("data/elec16.RData")
load("data/secciones.rda")

dfelec <- with(elec16$gob, data.frame(
  Seccion = seccion,
  pan_prd = pan + prd + pan_prd,
  pri_pvem_panal = pri + pvem + panal + pri_pvem_panal + pri_pvem + pri_panal + pvem_panal,
  pt = pt,
  morena = morena,
  pes = pes,
  candi = candi))

rgob16 <- data.frame(id = dfelec$Seccion, partido = 
                       factor(x = apply(dfelec[,2:7], 1, which.max), levels = 1:6, 
                              labels = c("PAN-PRD", "PRI-PVEM-PANAL", "PT", "MORENA", "PES", "OTRO")))

# Funcion que genera el mapa electoral
mapaElectoral <- function(region = "Estado", id.region = "", relecc = rgob16, 
                          lpos="right") {
  
  # Verifica parametros de entrada
  mapsecc <- switch(region,
                    Estado = secciones,
                    Distrito_Federal = {
                      id.region <- as.numeric(id.region)
                      if (!(id.region %in% 1:4)) {
                      stop("No es un distrito federal valido.")
                      }
                      filter(secciones, id_dtofed == id.region)},
                    Distrito_Local = {
                      id.region <- as.numeric(id.region)
                      if (!(id.region %in% 1:18)) {
                        stop("No es un distro local valido.")
                      }
                      filter(secciones, id_dtoloc == id.region)},
                    Municipio = {
                      id.region <- as.numeric(id.region)
                      if (!(id.region %in% 1:58)) {
                        stop("No un municipio valido.")
                      }
                      filter(secciones, id_muni == id.region)},
                    Localidad = {
                      if (!(id.region %in% str_trim(as.character(dbife$Nom_Localidad)))) {
                        stop("No existe esa localidad.")
                      }
                      mapsecc <- filter(secciones, id_loc == id.region)
                    })
  
  # Construye grafico
  ggplot(data=mapsecc, aes(map_id=id)) + 
    geom_map(map=mapsecc, aes(x=long, y=lat), fill="white", size=0.2) +
    geom_map(data=relecc, map=mapsecc, aes(fill=partido), size=0.2) +
    scale_fill_manual(values=c("#E6E600", "#339900", "#FF0033", "#990000", "#660099")) +
    coord_equal() + xlab("Longitud") + ylab("Latitud")
}

# Ejecucion de la aplicacion
shinyServer(function(input, output) {
    
    # Genera el mapa Electoral
    output$plotelec <- renderPlot({
      switch(input$op,
             "Estado" = mapaElectoral(),
             "Distrito Federal" = mapaElectoral(region = input$op, id.region = input$iddfed),
             "Distrito Local" = mapaElectoral(region = input$op, id.region = input$iddloc),
             "Municipio" = mapaElectoral(region = input$op, id.region = input$idmuni),
             "Localidad" = mapaElectoral(region = input$op, id.region = input$idloc)
      )
    })
    
    # Filtra la base para la region seleccionada
    datasetOutput <- reactive({
      # Suma alianzas
      dfelec <- with(elec16$gob, data.frame(
        Seccion = seccion,
        pan_prd = pan + prd + pan_prd,
        pri_pvem_panal = pri + pvem + panal + pri_pvem_panal + pri_pvem + pri_panal + pvem_panal,
        pt = pt,
        morena = morena,
        pes = pes,
        candi = candi))
      dfelec <- merge(dfelec, 
                  select(dbife, Seccion, Distrito, dtoloc, MUNICIPIO, Nom_Localidad),
                  by = "Seccion")
      
      dfelec <- switch(input$op,
             "Estado" = dfelec,
             "Distrito Federal" = filter(dfelec, Distrito == as.numeric(input$iddfed)),
             "Distrito Local" = filter(dfelec, unclass(dtoloc) == as.numeric(input$iddloc)),
             "Municipio" = filter(dfelec, unclass(MUNICIPIO) == as.numeric(input$idmuni)),
             "Localidad" = filter(dfelec, str_trim(as.character(Nom_Localidad)) == input$idloc)
             )
      tbres <- as.data.frame(colSums(dfelec[,2:7]))
      colnames(tbres) <- "Total"
      tbres$Porcentaje <- tbres$Total/sum(tbres$Total)*100
      return(tbres)
    })
    
    # Tabla de los resultados de la eleccion
    output$tbelec <- renderTable({
      datasetOutput()
    })
    
})
