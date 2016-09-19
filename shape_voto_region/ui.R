#++++++++++++++++++++++++++++++++++++++++
#  MAPA ELECTORAL
#+++++++++++++++++++++++++++++++++++++++

library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Elecciones Gubernamentales 2016"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("op", "Region:",
                   choices = c("Localidad", "Municipio", "Distrito_Local",
                               "Distrito_Federal", "Estado"),
                   selected = "Localidad"),
      conditionalPanel(condition = "input.op == 'Localidad'",
                       textInput("idloc", 'Localidad:', value = "GUADALUPE")),
      conditionalPanel(condition = "input.op == 'Municipio'",
                       textInput("idmuni", 'Municipio:', value = "17")),
      conditionalPanel(condition = "input.op == 'Distrito_Local'",
                       textInput("iddloc", 'Distrito Local:', value = "4")),
      conditionalPanel(condition = "input.op == 'Distrito_Federal'",
                       textInput("iddfed", 'Distrito Federal:', value = "4")),
    width = 3),
    mainPanel(
      h2("¿Sabes cómo votaron en tu comunidad?", style="color:orange"),
      tabsetPanel(type="tabs",
                tabPanel("Mapa Electoral", plotOutput('plotelec')),
                tabPanel("Votacion", tableOutput('tbelec'))
      )
    )
  )
))
