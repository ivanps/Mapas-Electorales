library(shiny)
library(dplyr)

# Filtra localidades con al menos 1000 votos
load("data/dfelec.RData")
listloc <- data.frame(tvotos = as.numeric(tapply(dfelec$tvotos, dfelec$loc, sum)),
                      loc = as.character(tapply(dfelec$loc, dfelec$loc, function(x){x[1]})))
listloc <- filter(listloc, tvotos >= 1000)

#---------------------------------------------------------
# Despliega menu lateral y resultados
shinyUI(fluidPage(
  titlePanel("Elecciones Gubernamentales 2016"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("op", "Region:",
            choices = c("Seccion", "Localidad", "Municipio", "Distrito_Local",
                               "Distrito_Federal", "Estado"),
            selected = "Seccion"),
      conditionalPanel(condition = "input.op == 'Seccion'",
            numericInput("idsecc", "Seccion:", min=1, max=1882, value = 500),
            sliderInput("magnif6", "Zoom:", min=3, max=21, value=13)),
      conditionalPanel(condition = "input.op == 'Localidad'",
            selectInput("idloc", "Localidad:", choices = sort(listloc$loc)),
            sliderInput("magnif5", "Zoom:", min=3, max=21, value=11)),
      conditionalPanel(condition = "input.op == 'Municipio'",
            numericInput("idmun", "Municipio:", min=1, max=56, value = 17),
            sliderInput("magnif4", "Zoom:", min=3, max=21, value=10)),
      conditionalPanel(condition = "input.op == 'Distrito_Local'",
            numericInput("iddloc", "Distrito Local:", min=1, max=18, value = 4),
            sliderInput("magnif3", "Zoom:", min=3, max=21, value=9)),
      conditionalPanel(condition = "input.op == 'Distrito_Federal'",
            numericInput("iddfed", "Distrito Federal:", min=1, max=4, value = 4),
            sliderInput("magnif2", "Zoom:", min=3, max=21, value=8)),
      conditionalPanel(condition = "input.op == 'Estado'",
            sliderInput("magnif1", "Zoom:", min=3, max=21, value=7)),
      width = 3),
    mainPanel(
      h2("¿Sabes cómo votaron en tu comunidad?", style="color:orange"),
      plotOutput('plotelec', height = 500)
    )
  )
))
