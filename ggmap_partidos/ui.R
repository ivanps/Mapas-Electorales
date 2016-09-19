#++++++++++++++++++++++++++++++++++++++++
#  MAPA EXIT POLL
#+++++++++++++++++++++++++++++++++++++++

shinyUI(fluidPage(
  
  titlePanel("Elecciones Gubernamentales 2016"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("magnif", "Zoom:", min=5, max=15, value=7),
      sliderInput("loclon", "Longitud", min=-105, max=-101, value = -102.5832, step = .01),
      sliderInput("loclat", "Latitud", min=21, max=26, value = 22.7709, step = .01),
      width = 3),
    mainPanel(
      h2("¿Cómo fue la votación por partidos?", style="color:orange"),
      plotOutput('plotelec', height = 500)
    )
  )
))
