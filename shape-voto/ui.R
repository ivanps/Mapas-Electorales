library(shiny)
library(dplyr)
load("data/dfelec.RData")

# Selecciones las localidades con al menos 1,000 votos
listloc <- data.frame(tvotos = as.numeric(tapply(dfelec$tvotos, dfelec$loc, sum)),
                      loc = as.character(tapply(dfelec$loc, dfelec$loc, function(x){x[1]})))
listloc <- filter(listloc, tvotos >= 1000)

#---------------------------------------------------------------
# Despliega menú y resultados
shinyUI(fluidPage(
  titlePanel("Elecciones Gubernamentales 2016"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("op", "Region:",
                   choices = c("Localidad", "Municipio", "Distrito_Local",
                               "Distrito_Federal", "Estado"),
                   selected = "Municipio"),
      conditionalPanel(condition = "input.op == 'Localidad'",
                       selectInput("idloc", "Localidad:", 
                                   choices = sort(listloc$loc))),
      conditionalPanel(condition = "input.op == 'Municipio'",
                       numericInput("idmuni", "Municipio:", min=1, max=58, value = 17)),
      conditionalPanel(condition = "input.op == 'Distrito_Local'",
                       numericInput("iddloc", "Distrito Local:", min=1, max=18, value = 4)),
      conditionalPanel(condition = "input.op == 'Distrito_Federal'",
                       numericInput("iddfed", "Distrito Federal:", min=1, max=4, value = 4)),
    width = 3),
    mainPanel(
      h2("¿Sabes cómo votaron en tu comunidad?", style="color:orange"),
      tabsetPanel(type="tabs",
                tabPanel("Mapa Electoral", plotOutput('plotelec')),
                tabPanel("Votación", tableOutput('tbelec'))
      )
    )
  )
))
