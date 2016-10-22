shinyUI(fluidPage(
  titlePanel(h1(strong("Risk Battle Simulator"))),
  sidebarLayout(sidebarPanel(
    h5(strong("Número de tropas al inicio de la batalla: ")),
    numericInput("atacantes", label = h6("Atacantes: "), min = 2, max = 20, step = 1, value = 4),
    numericInput("defensores", label = h6("Defensores: "), min = 1, max = 20, step = 1, value = 2),
    h5(strong("Resultado: ")),
    h6("Promedio de pérdidas: "),
    h4(strong(textOutput("atacantes_fin"), style = "color: #cc0000")),
    h6("Probabilidad de conseguir el territorio: "),
    h4(strong(textOutput("prob_territorio"), style = "color: #cc0000"))
  ),
  mainPanel(
    plotOutput("dist_perdidas"),
    htmlOutput("info")
  )
  )
))