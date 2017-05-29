# Despliega menú lateral y resultados
shinyUI(fluidPage(
  titlePanel("Elecciones Gubernamentales 2016"),
  sidebarLayout(
    sidebarPanel(
      selectInput("part", "Partido:", c("TODOS", "PAN_PRD", "PRI_PVEM_PANAL", 
                  "PT", "MORENA", "PES"), selected = "TODOS"),
      conditionalPanel(
        condition = "input.part != 'TODOS'",
        sliderInput("pciento", "% Preferencia minima", min=10, max=100, value=20)
      ),
      sliderInput("magnif", "Zoom:", min=0, max=15, value=7),
      sliderInput("loclon", "Longitud", min=-105, max=-101, value = -102.5832, step = .01),
      sliderInput("loclat", "Latitud", min=21, max=26, value = 22.7709, step = .01),
      width = 4),
    mainPanel(
      h2("¿Dónde se concentró la votación del partido?", style="color:orange"),
      plotOutput('plotpart', height = 500)
    )
  )
))
