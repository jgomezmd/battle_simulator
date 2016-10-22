
library(shiny)
library(ggplot2)
library(dplyr)
library(scales)

data_simulated <- read.csv("combates_risk.csv",
                           header = TRUE, sep = ",", dec = ".", na.strings = "", colClasses = "character")

data_simulated$atacantes_i <- as.numeric(data_simulated$atacantes_i)
data_simulated$defensores_i <- as.numeric(data_simulated$defensores_i)
data_simulated$atacantes_f <- as.numeric(data_simulated$atacantes_f)
data_simulated$defensores_f <- as.numeric(data_simulated$defensores_f)

shinyServer <- (function(input,output){
  data_subset <- reactive({
    data_simulated %>%
      filter(atacantes_i == as.character(input$atacantes)) %>%
               filter(defensores_i == as.character(input$defensores))
  })
  output$atacantes_fin <- renderText({
    df <- data_subset()
    input$atacantes - mean(df$atacantes_f)
  }) 
  output$prob_territorio <- renderText({
    df <- data_subset()
    length(filter(df, df$atacantes_f > 1)$atacantes_f)/length(df$atacantes_f)
  })
  output$dist_perdidas <- renderPlot({
    df <- data_subset()
    ggplot(data=df, aes(input$atacantes - df$atacantes_f)) + geom_bar() + scale_y_continuous(labels = percent) +
      labs(title = "Distribución del nº de pérdidas", x = "nº de tropas perdidas del atacante", y = "frecuencia")
  })
  output$info <- renderUI({
    list(h6("*La estrategia basada en los combates siempre usa el mayor número de dados para atacar y defender, 
            mas información: ", a("http://www.plainsboro.com/~lemke/risk/")),
         h6("*Las probabilidades son simuladas a partir de combates_risk.csv, mas info en study.R"))
  })

})

